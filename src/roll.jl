export Roll

abstract type Roll end

function roll(r :: Roll)
  r.activator(roll.(r.parts)) + r.modifier
end

include("diceroll.jl")
include("compositeroll.jl")
include("droproll.jl")
include("keeproll.jl")