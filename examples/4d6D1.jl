using Dices, Plots

begin
  v, f = Dices.histogram(drop(4d6), normalize=true)
  Plots.bar(v, f, size=(400,300), leg=false)
  xticks!(v)
  png("4d6D1")
end