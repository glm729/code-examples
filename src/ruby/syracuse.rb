#!/usr/bin/ruby

# =============================================================================
# An implementation of the Syracuse algorithm in Ruby. Essentially imitating a
# Python script I wrote previously. Perhaps I should clean that one up and put
# it up too, I've learned a little more since then.
# =============================================================================
# - Apparently explicit return is bad. I disagree, regardless of convention.
# - It looks a bit convoluted, maybe there's a way to make it a bit more neat.
# =============================================================================

# Updated -- 12th of April, 2021

def syracuse(number, max_iter = 100)
  seq = [Integer(number)]
  (0..max_iter).each do |i|
    if seq.last === 1  # Could be: [4, 2, 1].include?(seq.last)
      print(
        "\n    Sequence repeats!\n\n",
        "Number of iterations:    #{i}\n",
        "Sequence:\n#{seq}\n"
      )
      return seq
    end
    seq << ((seq[i] % 2) === 1) ? (3 * seq[i] + 1) : (seq[i] / 2)
    if i === max_iter - 1
      print(
        "\n    Reached max. iterations!\n\n",
        "Sequence:\n#{seq}\n"
      )
      return seq
    end
  end
end
