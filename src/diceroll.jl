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

function Roll(d :: Dice...)
  DiceRoll([d...], 0, sum)
end