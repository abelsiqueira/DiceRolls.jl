export histogram

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