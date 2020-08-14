export CompactedComparison, rolllist, prob
import Base.<, Base.>, Base.≤, Base.≥, Base.==

"""
    rolllist(d :: Dice; generator=false)
    rolllist(r :: Roll; generator=false)

Show all possible rolllist of dice `d` or roll `r`. For `DiceRoll`s this is a list of all dice results.
For `CompositeRoll`s and other `Roll`s where its parts are made of `Roll`s.
"""
function rolllist(d :: Dice)
  gen = [[i] for i = 1:d.sides]
  return collect(gen)
end

function rolllist(r :: Roll)
  gen = Iterators.product(rolllist.(r.parts)...)
  return [vcat(x...) for x in gen][:]
end

"""
    CompactedComparison(r, op, x)

Stores a comparison between a roll r and a value x. Use `collect` to collect all the roll values
that satisfy that comparison.
"""
mutable struct CompactedComparison{R <: Union{Dice,Roll}}
  r :: R
  op
  x
end

function CompactedComparison(r :: T, op, x :: Real) where T <: Roll
  CompactedComparison{T}(r, op, x)
end

<(r :: Union{Dice,Roll}, x :: Real) = CompactedComparison(r, <, x)
≤(r :: Union{Dice,Roll}, x :: Real) = CompactedComparison(r, ≤, x)
>(r :: Union{Dice,Roll}, x :: Real) = CompactedComparison(r, >, x)
≥(r :: Union{Dice,Roll}, x :: Real) = CompactedComparison(r, ≥, x)
<(x :: Real, r :: Union{Dice,Roll}) = CompactedComparison(r, >, x)
≤(x :: Real, r :: Union{Dice,Roll}) = CompactedComparison(r, ≥, x)
>(x :: Real, r :: Union{Dice,Roll}) = CompactedComparison(r, <, x)
≥(x :: Real, r :: Union{Dice,Roll}) = CompactedComparison(r, ≤, x)
==(r :: Union{Dice,Roll}, x :: Real) = CompactedComparison(r, ==, x)
==(x :: Real, r :: Union{Dice,Roll}) = CompactedComparison(r, ==, x)

function Base.show(io :: IO, tr :: CompactedComparison)
  print(io, "Compact ($(tr.r)) $(tr.op) $(tr.x) - Use collect for the list")
end

function Base.collect(tr :: CompactedComparison{<: Dice})
  rolls = rolllist(tr.r)
  I = findall(tr.op.(getindex.(rolls, 1), tr.x))
  rolls[I]
end

function Base.collect(tr :: CompactedComparison{<: Roll})
  rolls = rolllist(tr.r)
  I = findall(tr.op.(tr.r.activator.(rolls) .+ tr.r.modifier, tr.x))
  rolls[I]
end

"""
    prob(comparison)

Compute the probability of the given comparison, e.g., `prod(2d4 > 3)`.
"""
function prob(tr :: CompactedComparison)
  v, f = histogram(tr.r)
  I = findall(tr.op.(v, tr.x))
  sum(f[I]) / sum(f)
end