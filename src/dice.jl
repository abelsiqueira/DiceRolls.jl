export Dice, roll

"""
    Dice(sides)

`Dice` is the basic structure of the package. It has `sides`.
The traditional RPG dice are predefined: `d4`, `d6`, `d8`, `d10`, `d12`, and `d20`.
There is also an additional useful "dice": `coin`.
"""
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

"""
    roll(d :: Dice)

Roll the dice `d`.
"""
function roll(d :: Dice)
  rand(1:d.sides)
end
