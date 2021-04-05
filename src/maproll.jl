export map_roll, roll, MapRoll

"""
A MapRoll is a roll where the results of the input roll `input_roll` get mapped
to new rolls by `mapper`.
"""
struct MapRoll <: Roll
  input_roll :: Union{Dice, Roll}
  mapper
end

map_roll(r :: Union{Dice, Roll}, mapper) = MapRoll(r, mapper)

function histogram(r :: MapRoll; normalize :: Bool = false)
  input_values, input_freqs = histogram(r.input_roll)
  # Output rolls to occurence
  output_rolls = Dict{Any,Int}()
  # Figure out all of the possible output rolls and their frequency
  for (in_value, in_freq) in zip(input_values, input_freqs)
    roll = r.mapper(in_value)
    if haskey(output_rolls, roll)
      output_rolls[roll] += in_freq
    else
      output_rolls[roll] = in_freq
    end
  end

  # Create the histogram of these rolls
  hist = Dict{Int,Number}()
  for (roll, roll_freq) in output_rolls
    values, freqs = histogram(roll, normalize = true)
    for (value, freq) in zip(values, freqs)
      if haskey(hist, value)
        hist[value] += freq * roll_freq
      else
        hist[value] = freq * roll_freq
      end
    end
  end

  rolled_vals = sort(collect(keys(hist)))
  rolled_freqs = [hist[r] for r in rolled_vals]
  if normalize
    rolled_freqs /= sum(rolled_freqs)
  end

  rolled_vals, rolled_freqs
end

function roll(r :: MapRoll)
  output_roll = r.mapper(roll(r.input_roll))
  roll(output_roll)
end
