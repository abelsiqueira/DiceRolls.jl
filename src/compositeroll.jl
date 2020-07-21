export CompositeRoll

"""
A `CompositeRoll` is a roll where its parts are rolls.
This structure is usually used only internally.
"""
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