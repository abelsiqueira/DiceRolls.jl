# DiceRolls.jl

_A package for dealing with dice in Julia._

```@contents
Pages = ["index.md"]
```

## Description

This package defines dice and some operations with them.
Dice is the basic unit of the package. It can be created with a simple call:

```@example ex1
using DiceRolls
Dice(6)
```

There are some existing dice already defined:

```@example ex1
d4, d6, d8, d10, d12, d20
```

As expected you can perform some operations with dice:

```@example ex1
3d6, 2d4 + 2, d4 + d6
```

And finally, you have one last "Dice" defined:

```@example ex1
coin
```

And naturally you can roll these dice.

```@example ex1
using UnicodePlots
v = [roll(3d4) for _ = 1:10000]
UnicodePlots.histogram(v)
```

## Sum and Multiplication

You can sum and multiply dice:

```@example ex1
d6 * d6 + d4 * d8
```

## Drop and Keep

You can easily drop the lowest dice of a roll:

```@example ex1
r = drop(4d6)
```

```@example ex1
v = [roll(r) for _ = 1:10000]
UnicodePlots.histogram(v)
```

Drop can also be used with argument `kind=:highest` to drop the highest roll, and with `n=<some number>` to drop more than one dice.

Keep works the same way except that it keeps the highest value by default. It accepts the same arguments.

```@example ex1
r = keep(2d20)
```

```@example ex1
v = [roll(r) for _ = 1:10000]
UnicodePlots.histogram(v)
```

## Histogram

Lastly, we define a function `histogram` that computes all combinations and the histogram of results.

```@example ex1
results, frequency = DiceRolls.histogram(drop(3d4))
UnicodePlots.barplot(results, frequency)
```

We can also pass `normalize=true` to compute the probabilities instead.

```@example ex1
results, frequency = DiceRolls.histogram(drop(3d4), normalize=true)
UnicodePlots.barplot(results, frequency)
```

## Statistics

You can compute some statistical information of a dice or roll with the function [`mean`](@ref), [`median`](@ref), [`std`](@ref) and [`var`](@ref)

```@example ex1
r = drop(3d4)
mean(r), median(r), std(r), var(r)
```

## Comparisons and Probabilities

Using comparison operators on a roll will return (a compact representation of) all rolls that
satisfy that comparison. For instance,

```@example ex1
r = drop(3d4)
collect(r > 7)
```

```@example ex1
collect(r == 7)
```

Using [`prob`](@ref) one can compute the probability of that situation happening.

```@example ex1
r = drop(4d6)
prob(r > 14)
```