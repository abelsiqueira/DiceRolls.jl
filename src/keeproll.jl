export keep, KeepRoll

struct KeepRoll <: Roll
  parts
  modifier :: Integer
  activator
  roll :: Roll
  kind
  n
end

function show(io :: IO, r :: KeepRoll)
  show(io, r.roll)
  print(io, " keep $(r.kind) $(r.n)")
end

function keep(r :: Roll; kind :: Symbol = :highest, n :: Integer = 1)
  if !(kind in [:lowest, :highest])
    error("second argument of drop should be :lowest or :highest")
  end
  if length(r.parts) < n
    error("Can't keep $n parts of roll with $(length(r.parts)) parts")
  end

  if kind == :lowest
    KeepRoll(r.parts, r.modifier, v -> r.activator(sort(v)[1:n]), r, kind, n)
  elseif kind == :highest
    KeepRoll(r.parts, r.modifier, v -> r.activator(sort(v)[end-n+1:end]), r, kind, n)
  end
end