import Base.*, Base.+, Base.-

function *(n :: Integer, d :: Dice)
  n ≤ 0 && error("Only positive multiples of dice accepted")
  DiceRoll([d for _ = 1:n], 0, sum)
end
*(d :: Dice, n :: Integer) = n * d
*(d :: Dice...) = DiceRoll([d...], 0, prod)
*(r :: Roll...) = CompositeRoll([r...], 0, prod)

+(d :: Dice, n :: Integer) = DiceRoll([d], n, sum)
-(d :: Dice, n :: Integer) = DiceRoll([d], -n, sum)
+(n :: Integer, d :: Dice) = d + n

+(r :: T, n :: Integer) where T <: Roll = T(r.parts, r.modifier + n, r.activator)
-(r :: T, n :: Integer) where T <: Roll = T(r.parts, r.modifier - n, r.activator)
+(n :: Integer, r :: Roll) = r + n

+(d :: Dice...) = DiceRoll(d, 0, sum)
+(r :: Roll...) = CompositeRoll(r, 0, sum)
+(r :: Roll, d :: Dice) = r + Roll(d)

function +(d :: DiceRoll...)
  activators = [x.activator for x in d]
  if all(activators .== sum)
    DiceRoll(vcat([x.parts for x in d]...), sum(x.modifier for x in d), sum)
  else
    CompositeRoll(d, 0, sum)
  end
end
