import Statistics: mean, median, std, var
export mean, median, std, var

function mean(r :: Union{Dice,Roll})
  v, f = histogram(r, normalize=true)
  dot(v, f)
end

function median(r :: Union{Dice,Roll})
  v, f = histogram(r, normalize=true)
  cp = 0.0
  for (vi, fi) in zip(v, f)
    cp += fi
    cp ≥ 0.5 && return vi
  end
end

function var(r :: Union{Dice,Roll})
  v, f = histogram(r, normalize=true)
  μ = dot(v, f)
  sum( (vi - μ)^2 * fi for (vi, fi) in zip(v, f) )
end

std(r :: Union{Dice,Roll}) = sqrt(var(r))
