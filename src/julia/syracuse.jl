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


# -----------------------------------------------------------------------------
# Updated 2021-04-16
#
# I've been using Julia quite a bit at work recently (out of curiosity,
# mostly), so I thought I'd try to condense and improve this function
# definition.  Not overwriting the previous definition, posterity or sentiment,
# whichever is more accurate, but I wanted to give it another shot.
#
# As before, my use of Julia is probably very basic, so if you have any tips,
# advice, or expriences to contribute, I would appreciate it.
# -----------------------------------------------------------------------------

function syracuse(num::Int; max_iter::Int = 100)
  seq = [num]
  for i in 1:max_iter
    push!(seq, ((seq[i] % 2) === 1) ? ((3 * seq[i]) + 1) : (seq[i] / 2))
    if seq[end] in [4, 2, 1]
      println(join([
        "\n    \e[7;32mSequence repeats!\e[0m\n\n",
        "Number of iterations:  $i\n",
        "Sequence:\n$seq\n"
      ]))
      return seq
    end
  end
  println("\n    \e[7;33mReached max. iterations!\e[0m\n\nSequence:\n$seq\n")
  return seq
end
