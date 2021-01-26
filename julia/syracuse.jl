#!/usr/bin/env julia

# -----------------------------------------------------------------------------
# An implementation of the Syracuse algorithm in Julia.  Probably not the most
# fast or efficient, but it's all a learning exercise for me.  Essentially a
# copy of the Python and Ruby implementations.  One day I might even try these
# in R....
# -----------------------------------------------------------------------------

function syracuse(num, max_iter = 100)
  seq = [num]
  for i in 1:max_iter
    if last(seq) == 1
      println(join([
        "\n    Sequence repeats!\n\n",
        "Number of iterations:  $i\n",
        "Sequence:\n$seq\n"
      ]))
      return(seq)
    end
    if seq[i] % 2 == 1
      push!(seq, (3 * seq[i]) + 1)
    elseif seq[i] % 2 == 0
      push!(seq, (seq[i] / 2))
    end
  end
  println("\n    Reached max. iterations!\n\nSequence:\n$seq")
  return(seq)
end
