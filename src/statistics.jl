import Statistics: mean, median, std, var
export mean, median, std, var

"""
    mean(r)

Compute the mean of a dice or roll.
"""
function mean(r :: Union{Dice,Roll})
  v, f = histogram(r, normalize=true)
  dot(v, f)
end

"""
    median(r)

Compute the median of a dice or roll.
"""
function median(r :: Union{Dice,Roll})
  v, f = histogram(r, normalize=true)
  cp = 0.0
  for (vi, fi) in zip(v, f)
    cp += fi
    cp ≥ 0.5 && return vi
  end
end

"""
    var(r)

Compute the variance of a dice or roll.
"""
function var(r :: Union{Dice,Roll})
  v, f = histogram(r, normalize=true)
  μ = dot(v, f)
  sum( (vi - μ)^2 * fi for (vi, fi) in zip(v, f) )
end

"""
    std(r)

Compute the standard deviation of a dice or roll.
"""
std(r :: Union{Dice,Roll}) = sqrt(var(r))
