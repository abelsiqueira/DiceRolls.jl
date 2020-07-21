module Dices

export coin

include("dice.jl")
include("roll.jl")
include("operations.jl")
include("histogram.jl")

const coin = Dice(2) - 1

end # module