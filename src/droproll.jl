export drop

struct DropRoll <: Roll
  parts
  modifier :: Integer
  activator
  roll :: Roll
  kind
  n
end

function show(io :: IO, r :: DropRoll)
  show(io, r.roll)
  print(io, " drop $(r.kind) $(r.n)")
end

function drop(r :: Roll; kind :: Symbol = :lowest, n :: Integer = 1)
  if !(kind in [:lowest, :highest])
    error("second argument of drop should be :lowest or :highest")
  end
  if length(r.parts) ≤ n
    error("Can't drop $n parts of roll with $(length(r.parts)) parts")
  end

  if kind == :lowest
    DropRoll(r.parts, r.modifier, v -> r.activator(sort(v)[1+n:end]), r, kind, n)
  elseif kind == :highest
    DropRoll(r.parts, r.modifier, v -> r.activator(sort(v)[1:end-n]), r, kind, n)
  end
end