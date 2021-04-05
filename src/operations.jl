import Base.*, Base.+, Base.-, Base.==

function *(n :: Integer, d :: Dice)
  n ≤ 0 && error("Only positive multiples of dice accepted")
  DiceRoll([d for _ = 1:n], 0, sum)
end
*(d :: Dice, n :: Integer) = n * d
*(d :: Dice...) = DiceRoll([d...], 0, prod)
*(r :: Roll...) = CompositeRoll([r...], 0, prod)
*(r :: DiceRoll, d :: Dice) = r * DiceRoll([d], 0, prod)
*(d :: Dice, r :: DiceRoll) = r * DiceRoll([d], 0, prod)
*(r :: Roll, d :: Dice) = DiceRoll([d], 0, prod) * r
*(d :: Dice, r :: Roll) = DiceRoll([d], 0, prod) * r

+(d :: Dice, n :: Integer) = DiceRoll([d], n, sum)
+(n :: Integer, d :: Dice) = DiceRoll([d], n, sum)
-(d :: Dice, n :: Integer) = DiceRoll([d], -n, sum)

+(r :: T, n :: Integer) where T <: Roll = T(r.parts, r.modifier + n, r.activator)
-(r :: T, n :: Integer) where T <: Roll = T(r.parts, r.modifier - n, r.activator)
+(n :: Integer, r :: Roll) = r + n

+(d :: Dice...) = DiceRoll([d...], 0, sum)
+(r :: Roll...) = CompositeRoll([r...], 0, sum)
+(r :: Roll, d :: Dice) = r + Roll(d)
+(d :: Dice, r :: Roll) = r + Roll(d)

function +(d :: DiceRoll...)
  activators = [x.activator for x in d]
  if all(activators .== sum)
    DiceRoll(vcat([x.parts for x in d]...), sum(x.modifier for x in d), sum)
  else
    CompositeRoll(d, 0, sum)
  end
end

function *(d :: DiceRoll...)
  activators = [x.activator for x in d]
  if all(activators .== prod) && sum(x.modifier for x in d) == 0
    DiceRoll(vcat([x.parts for x in d]...), 0, prod)
  else
    CompositeRoll(d, 0, prod)
  end
end

function ==(r1 :: Roll, r2 :: Roll)
  r1.parts == r2.parts && r1.modifier == r2.modifier && r1.activator == r2.activator
end

function Base.hash(r :: Roll, h :: UInt)
  hash(r.parts) ⊻ hash(r.modifier) ⊻ hash(r.activator) ⊻ h
end

function ==(r1 :: DiceRoll, r2 :: DiceRoll)
  sort(r1.parts, by=x->x.sides) == sort(r2.parts, by=x->x.sides) && r1.modifier == r2.modifier && r1.activator == r2.activator
end

function Base.hash(r :: DiceRoll, h :: UInt)
  hash(sort(r.parts, by=x->x.sides)) ⊻ hash(r.modifier) ⊻ hash(r.activator) ⊻ h
end

function ==(r1 :: DropRoll, r2 :: DropRoll)
  r1.parts == r2.parts && r1.modifier == r2.modifier && r1.activator == r2.activator && r1.kind == r2.kind && r1.n == r2.n
end

function Base.hash(r :: DropRoll, h :: UInt)
  hash(r.parts) ⊻ hash(r.modifier) ⊻ hash(r.activator) ⊻ hash(r.kind) ⊻ hash(r.n) ⊻ h
end

function ==(r1 :: KeepRoll, r2 :: KeepRoll)
  r1.parts == r2.parts && r1.modifier == r2.modifier && r1.activator == r2.activator && r1.kind == r2.kind && r1.n == r2.n
end

function Base.hash(r :: KeepRoll, h :: UInt)
  hash(r.parts) ⊻ hash(r.modifier) ⊻ hash(r.activator) ⊻ hash(r.kind) ⊻ hash(r.n) ⊻ h
end
