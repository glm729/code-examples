#!/usr/bin/python3

# =============================================================================
# An implementation of Euclid's algorithm in Python. Had this one sitting there
# for a while, but decided to clean it up when I wanted to try it in Ruby. It's
# probably not the best implementation, but I enjoyed writing it.
# =============================================================================
# - Shuffles a and b if they're the wrong way around.
# =============================================================================


def euclid(a, b, max_iter=100):
    if(b > a):
        sequence = [int(b), int(a)]
    else:
        sequence = [int(a), int(b)]
    for i in range(1, (max_iter + 1)):
        x = sequence[i - 1]
        y = sequence[i]
        remain = x - (y * (x // y))
        if remain == 0:
            print(
                "Greatest common divisor of %s and %s is %s"
                % (a, b, sequence[-1])
            )
            return(sequence)
        else:
            sequence.append(remain)
    print(
        "Reached max. iterations!\nSequence:\n%s" % sequence
    )
    return(sequence)
