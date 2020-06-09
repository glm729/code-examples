#!/usr/bin/ruby

# ==============================================================================
# An implementation of the Syracuse algorithm in Ruby. Essentially imitating a
# Python script I wrote previously. Perhaps I should clean that one up and put
# it up too, I've learned a little more since then.
# ==============================================================================
# - Apparently explicit return is bad. I disagree, regardless of convention.
# - It looks a bit convoluted, maybe there's a way to make it a bit more neat.
# ==============================================================================

def syracuse(number, max_iter = 100)
  sequence = []
  sequence.append(Integer(number))
  (0..max_iter).each do |i|
    if sequence.last == 1  # Could be: [4, 2, 1].include?(sequence.last)
      print(
        "\n    Sequence repeats!\n\n",
        "Number of iterations:    #{i}\n",
        "Sequence:\n#{sequence}\n"
      )
      return(sequence)
    end
    if (sequence[i] % 2) == 1
      sequence.append(3 * sequence[i] + 1)
    end
    if (sequence[i] % 2) == 0
      sequence.append(sequence[i] / 2)
    end
    if i == max_iter - 1
      print(
        "\n    Reached max. iterations!\n\n",
        "Sequence:\n#{sequence}\n"
      )
      return(sequence)
    end
  end
end
