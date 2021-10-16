export DiceRoll

"""
A DiceRoll is an Roll made only of dice. A sum or product of several dice, for instance.
"""
struct DiceRoll{P,I<:Integer,A} <: Roll
  parts::P
  modifier::I
  activator::A
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