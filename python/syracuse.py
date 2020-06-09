#!/usr/bin/python3

# =============================================================================
# An implementation of the Syracuse algorithm in Python. Cleaned it up after
# trying the same in Ruby, using this for reference. The old one wasn't as
# smart in its operations, it used string concatenation and frequent conversion
# to integers. For example, it did not previously use integer division!
# =============================================================================


def syracuse(number, max_iter=100):
    number = int(number)
    max_iter = int(max_iter)
    sequence = []
    sequence.append(number)
    for i in range(0, max_iter + 1):
        if sequence[-1] == 1:  # Could be: sequence[-1] in [4, 2, 1]
            print(
                "\n    Sequence repeats!\n\n"
                "Number of iterations:    %s\n"
                "Sequence:\n%s"
                % (i, sequence)
            )
            return sequence
        if (sequence[i] % 2) == 1:
            sequence.append(3 * sequence[i] + 1)
        if (sequence[i] % 2) == 0:
            sequence.append(sequence[i] // 2)
        if i == max_iter - 1:
            print(
                "\n    Reached max. iterations!\n\n"
                "Sequence:\n%s"
                % sequence
            )
            return sequence
