export Roll

"""
A Roll is an abstract type for operations with Dice.
"""
abstract type Roll end

"""
    roll(r :: Roll)

Roll `r`.
"""
function roll(r :: Roll)
  r.activator(roll.(r.parts)) + r.modifier
end

include("diceroll.jl")
include("compositeroll.jl")
include("droproll.jl")
include("keeproll.jl")

include("rolllist.jl")