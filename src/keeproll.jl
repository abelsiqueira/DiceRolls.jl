export keep, KeepRoll

"""
A KeepRoll is a roll where some of the parts of the internal roll are ignored.
See `keep` for more information.
"""
struct KeepRoll{P,I<:Integer,A,R} <: Roll
  parts::P
  modifier::I
  activator::A
  roll::R
  kind::Symbol
  n::I
end

function show(io :: IO, r :: KeepRoll)
  show(io, r.roll)
  print(io, " keep $(r.kind) $(r.n)")
end

"""
    keep(r)
    keep(r; kind=:highest, n=1)

Keep only the highest part of a roll. Notice that for a `DiceRoll`, this means keeping the
largest dice in a roll, but for composite dice, it can mean keeping a whole segment.
See the behaviour of `drop` for more information.

**keyword arguments**

- `kind`: Either `:lowest` or `:highest` to keep either the lowest or highest roll or rolls.
- `n`: The number of dice to be kept.
"""
function keep(r :: Roll; kind :: Symbol = :highest, n :: Integer = 1)
  if !(kind in [:lowest, :highest])
    error("second argument of drop should be :lowest or :highest")
  end
  if length(r.parts) < n
    error("Can't keep $n parts of roll with $(length(r.parts)) parts")
  end

  if kind == :lowest
    KeepRoll(r.parts, r.modifier, v -> r.activator(sort(v)[1:n]), r, kind, n)
  elseif kind == :highest
    KeepRoll(r.parts, r.modifier, v -> r.activator(sort(v)[end-n+1:end]), r, kind, n)
  end
end
