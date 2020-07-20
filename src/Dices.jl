module Dices

export CompositeRoll, Dice, DiceRoll, drop, histogram, keep, roll, Roll

struct Dice
  sides
end

import Base.show
function show(io :: IO, d :: Dice)
  s = "d" * join([Char('₀' - '0' + Int(x)) for x in string(d.sides)])

  print(io, s)
end

for s in [4, 6, 8, 10, 12, 20, 100]
  ss = Symbol("d$s")
  @eval begin
    const $ss = Dice($s)
    export $ss
  end
end

function roll(d :: Dice)
  rand(1:d.sides)
end

abstract type Roll end

struct DiceRoll <: Roll
  parts
  modifier :: Integer
  activator
end

function show(io :: IO, r :: DiceRoll)
  U = sort(unique(r.parts), by=x->x.sides)
  conn = if r.activator == sum
    "+"
  elseif r.activator == prod
    "×"
  else
    "?"
  end
  for u in U
    print(io, sum(u == ri for ri in r.parts))
    print(io, u)
    if u != U[end]
      print(io, conn)
    end
  end
  if r.modifier > 0
    print(io, "+$(r.modifier)")
  elseif r.modifier < 0
    print(io, "-$(-r.modifier)")
  end
end

struct CompositeRoll <: Roll
  parts
  modifier :: Integer
  activator
end

function show(io :: IO, r :: CompositeRoll)
  conn = if r.activator == sum
    "+"
  elseif r.activator == prod
    "×"
  else
    "?"
  end
  for (i,u) in enumerate(r.parts)
    print(io, "($u)")
    if i != length(r.parts)
      print(io, conn)
    end
  end
  if r.modifier > 0
    print(io, "+$(r.modifier)")
  elseif r.modifier < 0
    print(io, "-$(-r.modifier)")
  end
end

# function show(io :: IO, r :: DropRoll)
  
# end

function roll(r :: Roll)
  r.activator(roll.(r.parts)) + r.modifier
end

function Roll(d :: Dice...)
  DiceRoll([d...], 0, sum)
end

## Operations

import Base.*
function *(n :: Integer, d :: Dice)
  n ≤ 0 && error("Only positive multiples of dice accepted")
  DiceRoll([d for _ = 1:n], 0, sum)
end
*(d :: Dice, n :: Integer) = n * d

*(d :: Dice...) = DiceRoll(d, 0, prod)

*(r :: Roll...) = CompositeRoll(r, 0, prod)

import Base.+, Base.-
+(d :: Dice, n :: Integer) = DiceRoll([d], n, sum)
-(d :: Dice, n :: Integer) = DiceRoll([d], -n, sum)
+(n :: Integer, d :: Dice) = d + n


+(r :: T, n :: Integer) where T <: Roll = T(r.parts, r.modifier + n, r.activator)
-(r :: T, n :: Integer) where T <: Roll = T(r.parts, r.modifier - n, r.activator)
+(n :: Integer, r :: Roll) = r + n

function +(d :: Dice...)
  DiceRoll(d, 0, sum)
end

function +(d :: DiceRoll...)
  activators = [x.activator for x in d]
  if all(activators .== sum)
    DiceRoll(vcat([x.parts for x in d]...), sum(x.modifier for x in d), sum)
  else
    CompositeRoll(d, 0, sum)
  end
end

function +(r :: Roll...)
  CompositeRoll(r, 0, sum)
end

+(r :: Roll, d :: Dice) = r + Roll(d)

struct DropRoll <: Roll
  parts
  modifier :: Integer
  activator
  roll :: Roll
  kind
  n
end

function show(io :: IO, r :: DropRoll)
  show(io, r.roll)
  print(io, " drop $(r.kind) $(r.n)")
end

function drop(r :: Roll; kind :: Symbol = :lowest, n :: Integer = 1)
  if !(kind in [:lowest, :highest])
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

struct KeepRoll <: Roll
  parts
  modifier :: Integer
  activator
  roll :: Roll
  kind
  n
end

function show(io :: IO, r :: KeepRoll)
  show(io, r.roll)
  print(io, " keep $(r.kind) $(r.n)")
end

function keep(r :: Roll; kind :: Symbol = :lowest, n :: Integer = 1)
  if !(kind in [:lowest, :highest])
    error("second argument of drop should be :lowest or :highest")
  end
  if length(r.parts) ≤ n
    error("Can't keep $n parts of roll with $(length(r.parts)) parts")
  end

  if kind == :lowest
    KeepRoll(r.parts, r.modifier, v -> r.activator(sort(v)[1:n]), r, kind, n)
  elseif kind == :highest
    KeepRoll(r.parts, r.modifier, v -> r.activator(sort(v)[end-n+1:end]), r, kind, n)
  end
end

## Histogram

function histogram(d :: Dice; normalize :: Bool = false)
  if normalize
    1:d.sides, fill(1 / d.sides, d.sides)
  else
    1:d.sides, ones(Int, d.sides)
  end
end

function histogram(r :: DiceRoll; normalize :: Bool = false)
  hist = Dict{Int,Int}()
  for x in Iterators.product([1:d.sides for d in r.parts]...)
    v = r.activator(x) + r.modifier
    if haskey(hist, v)
      hist[v] += 1
    else
      hist[v] = 1
    end
  end
  k = sort(collect(keys(hist)))
  v = [hist[ki] for ki in k]
  if normalize
    return k, v / sum(v)
  else
    return k, v
  end
end

function histogram(r :: Roll; normalize :: Bool = false)
  hist = Dict{Int,Int}()

  H = histogram.(r.parts)
  values = getindex.(H, 1)
  freqs  = getindex.(H, 2)
  for (v,f) in zip(Iterators.product(values...), Iterators.product(freqs...))
    x = r.activator([v...]) + r.modifier
    haskey(hist, x) || (hist[x] = 0)
    hist[x] += prod(f)
  end
  k = sort(collect(keys(hist)))
  v = [hist[ki] for ki in k]
  if normalize
    return k, v / sum(v)
  else
    return k, v
  end
end

end # module
