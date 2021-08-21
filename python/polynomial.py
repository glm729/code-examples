#!/usr/bin/env python3


# An exercise from a Java tutorial.  I am not familiar with Java but might want
# to learn it, so I borrowed a book from one of my brothers and happened upon a
# maths-based exercise I liked the look of.  Here it is in Python, to warm up a
# bit, before I launch in to Java....

# For reference, the book is Walter Savitch's "Java: An Introduction to Problem
# Solving and Programming" (6th edition), and the exercise is on page 559 (Ch.
# 7.6, Graphics Supplement).


# Class definition
# -----------------------------------------------------------------------------


class Polynomial:
    """
    Create a class `Polynomial` that is used to evaluate a polynomial function
    of `x`:

        P(x) = a_0 + a_1 * x + a_2 * (x ^ 2) + ... +
            a_(n - 1) * (x ^ (n - 1)) + a_n * (x ^ n)

    The coefficients `a_i` are floating-point numbers, the exponents of `x` are
    integers, and the largest exponent `n` -- called the degree of the
    polynomial -- is greater than or equal to 0.

    The class has the attributes
    - degree -- the value of the largest exponent `n`
    - coefficients -- an array of the coefficients `a_i`

    and the following methods:
    - Polynomial(max) -- a constructor that creates a polynomial of degree
      `max` whose coefficients are all 0
    - setConstant(i, value) -- sets the coefficient `a_i` to `value`
    - evaluate(x) -- returns the value of the polynomial for the given value
      `x`
    """

    def __init__(self, maximum):
        # Check that the degree is at least 0
        assert maximum >= 0, "Degree must be at least 0"
        # Assign the `degree` attribute
        self.degree = maximum
        # Initialise the coefficients as all 0
        self.coefficients = [0 for _ in range(0, maximum + 1)]
        # ^ Note `max + 1` -- degree is the maximal exponent, but `range` stops
        #   with final value at `max - 1`, so this ensures degree is met.

    def set_constant(self, i, value):
        """
        Attempt to set the value of coefficient `i` to `value`.
        Print an error message if the index is out of range.

        Arguments:
            i: Index of the coefficient to set
            value: Value for which to set the coefficient
        """
        try:
            self.coefficients[i] = value
        except IndexError:
            print(f"\033[31mIndex {i} out of range\033[0m")

    def evaluate(self, x):
        """
        Evaluate the polynomial for the given value of x.

        Arguments:
            x: Value of x for which to evaluate the polynomial
        """
        # Initialise the result
        result = 0
        # Loop over the length of the coefficients
        for i in range(0, len(c := self.coefficients)):
            # Mutate the result for the given coefficient and exponent pair
            result += c[i] * (x ** i)
        # Return the final product
        return result


# Exercise operations
# -----------------------------------------------------------------------------


if __name__ == "__main__":
    # Instantiate a polynomial of degree 3
    poly = Polynomial(3)
    # Set the values of the coefficients for the function:
    #     P(x) = 3 + (5 * x) + (2 * (x ** 3))
    for i in range(0, len(c := [3, 5, 0, 2])):
        poly.set_constant(i, c[i])
    # Evaluate for x = 7  =>  P(7) = 724
    print(f"P(7) = {poly.evaluate(7)}")
    # Or, more formally / Pythonic:
    assert poly.evaluate(7) == 724
