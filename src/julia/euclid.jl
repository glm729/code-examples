#!/usr/bin/env julia

# -----------------------------------------------------------------------------
# An implementation of Euclid's algorithm in Julia.  I haven't a clue how Julia
# works or how to use it properly, so feel free to make some reasoned comments,
# but I thought I would give it a bit of a shot!  It's essentially a copy of
# the Python / Ruby functions, but transcribed.
# -----------------------------------------------------------------------------
# - Shuffles a and b if b is larger than a
# -----------------------------------------------------------------------------

function euclid(a, b, max_iter = 100)
  seq = (b > a) ? [b, a] : [a, b]
  for i in 2:max_iter
    x = seq[i - 1]
    y = seq[i]
    remain = x - (y * floor(x / y))
    if remain == 0
      println("Greatest common divisor of $a and $b is $(last(seq))")
      return(seq)
    else
      push!(seq, remain)
    end
  end
  println("Reached max. iterations!\nSequence:\n$seq")
  return(seq)
end
