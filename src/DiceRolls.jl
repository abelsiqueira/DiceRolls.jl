module DiceRolls

using LinearAlgebra: dot

export coin, @roll_str

include("dice.jl")
include("roll.jl")
include("operations.jl")

include("histogram.jl")

include("statistics.jl")

const coin = Dice(2) - 1

"""
    @roll_str(str)

Convenient string macro. Format:
<n rolls>#<N>d<faces>+<modifier><mod effect>

<n rolls>, <N>, <modifier>, <mod effect> are optional.

Example:
```
r"2#1d20+6" # Rolls 1d20+6 twice
r"2d20kh1" # Rolls 2d20 and keeps highest
```
"""
macro roll_str(str)
    # find the main die
    parts = findall(r"[0-9]*d[0-9]*", str)
    len_pts = length(parts)
    len_pts == 1 || throw(ArgumentError("Require exactly 1 kind of die, found $len_pts."))
    die_pos = only(parts)
    main_die = str[die_pos]

    # how many rolls
    n_rolls = match(r"([0-9]*)#", str[1:first(die_pos)]) #search before the main die
    n_rolls = isnothing(n_rolls) ? 1 : parse(Int, only(n_rolls.captures))

    # + modifier
    plus = match(r"\+([0-9]*)", str, last(die_pos)) #search after the main die
    plus = isnothing(plus) ? 0 : only(plus.captures)

    # kh<n> or kl<n> modifier
    keep = match(r"(k[h|l])([0-9]*)", str, last(die_pos)) #search after the main die
    kind, keep_n = isnothing(keep) ? (nothing, nothing) : keep.captures
    kind = if kind == "kh"
        :highest
    elseif kind == "kl"
        :lowest
    else
        nothing
    end

    ex = "$main_die + $plus"
    ex = isnothing(kind) ? ex : "keep($ex, kind=:$kind, n=$keep_n)"
    if n_rolls > 1
        Meta.parse("sum([roll($ex) for _ in 1:$n_rolls])")
    else
        Meta.parse("roll($ex)")
    end
end

end # module
