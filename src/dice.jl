export Dice, roll

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
