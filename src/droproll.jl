export drop, DropRoll

"""
A DropRoll is a roll where some of the parts of the internal roll are ignored.
See `drop` for more information.
"""
struct DropRoll{P,I<:Integer,A,R<:Roll} <: Roll
  parts::P
  modifier::I
  activator::A
  roll::R
  kind::Symbol
  n::I
end

function show(io :: IO, r :: DropRoll)
  show(io, r.roll)
  print(io, " drop $(r.kind) $(r.n)")
end

"""
    drop(r)
    drop(r; kind=:lowest, n=1)

Drops the lowest part of a roll. Notice that for a `DiceRoll`, this means dropping the
lowest dice in a roll, but for composite dice, it can mean dropping a whole segment.
For instance
```
drop(4d6)
```
will drop the lowest valued dice of the four 6-sided dice rolled. It is equivalent to
```
v = roll.([d6, d6, d6, d6])
sum(v) - minimum(v)
```
On the other hand,
```
drop((2d4 - 1) * (2d4 - 1))
```
will drop the lowest of the product, i.e., it is equivalent to
```
v = roll.([2d4 - 1, 2d4 - 1])
sum(v) - minimum(v)
```

**keyword arguments**

- `kind`: Either `:lowest` or `:highest` to remove either the lowest or highest roll or rolls.
- `n`: The number of dice to be removed.
"""
function drop(r :: Roll; kind :: Symbol = :lowest, n :: Integer = 1)
  if !(kind in (:lowest, :highest))
    error("second argument of drop should be :lowest or :highest")
  end
  if length(r.parts) ≤ n
    error("Can't drop $n parts of roll with $(length(r.parts)) parts")
  end

  if kind == :lowest
    DropRoll(r.parts, r.modifier, v -> r.activator(sort(v)[1+n:end]), r, kind, n)
  elseif kind == :highest
    DropRoll(r.parts, r.modifier, v -> r.activator(sort(v)[1:end-n]), r, kind, n)
  end
end