#!/usr/bin/ruby

# =============================================================================
# An implementation of Euclid's algorithm. Decided to try it out in Ruby, as I
# had a version in Python (which has now been cleaned up and posted). It's
# likely there's a neater way to do it, feel free to demo.
# =============================================================================
# - Shuffles a and b if they're the wrong way around.
# - As before, apparently explicit return is bad, but I disagree.
# =============================================================================

# Slightly updated -- 12th of April, 2021

def euclid(a, b, max_iter = 100)
  sequence = (b > a) ? [b.to_i, a.to_i] : [a.to_i, b.to_i]
  (1..max_iter).each do |i|
    x = sequence[i - 1]
    y = sequence[i]
    remain = x - (y * (x / y))
    if remain === 0
      print("Greatest common divisor of #{a} and #{b} is #{sequence.last}\n")
      return sequence
    else
      sequence.append(remain)
    end
  end
  print("Reached max. iterations!\nSequence:\n#{sequence}\n")
  return sequence
end
