using DiceRolls, Plots
gr()

begin
  v, f = DiceRolls.histogram(drop(4d6), normalize=true)
  Plots.bar(v, f, size=(400,300), leg=false)
  xticks!(v)
  png("4d6D1")
end

begin
  v, f = DiceRolls.histogram((1d4 - 1) * (1d4 - 1))
  Plots.bar(v, f, size=(400,300), leg=false)
  xticks!(v)
  png("complex")
end