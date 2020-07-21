export DiceRoll

"""
A DiceRoll is an Roll made only of dices. A sum or product of several dices, for instance.
"""
struct DiceRoll <: Roll
  parts
  modifier :: Integer
  activator
end

function show(io :: IO, r :: DiceRoll)
  U = r.activator == sum ? unique(r.parts) : r.parts
  U = sort(U, by=x->x.sides)
  conn = if r.activator == sum
    "+"
  elseif r.activator == prod
    "×"
  else
    "?"
  end
  for (i,u) in enumerate(U)
    if r.activator == sum
      print(io, sum(u == ri for ri in r.parts))
    end
    print(io, u)
    if i != length(U)
      print(io, conn)
    end
  end
  if r.modifier > 0
    print(io, "+$(r.modifier)")
  elseif r.modifier < 0
    print(io, "-$(-r.modifier)")
  end
end

"""
    Roll(d :: Dice)

Create a Roll from a single Dice. Usually used internally.
"""
function Roll(d :: Dice...)
  DiceRoll([d...], 0, sum)
end