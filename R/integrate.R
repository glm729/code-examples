#!/usr/bin/env R

# -----------------------------------------------------------------------------
# Had an idea to try making a function for estimating an integral using a sum
# of areas of trapezoidal segments.  Probably not the most efficient or precise
# implementation, but it was a fun thought exercise!
# -----------------------------------------------------------------------------


#' Function for calculating the area of a trapezoid with a flat base.  A
#' rudimentary image of the assumed shape is:
#'        /|
#'       / |
#'  h1  |  | h2
#'      |__|
#'       w
#' This is essentially the sum of the areas of the component rectangle and
#' triangle.
#' @param h1 Height of one side of the trapezoid
#' @param h2 Height of the other side of the trapezoid
#' @param w Base width of the trapezoid
#' @return Area of the flat-base trapezoid
areaTrapezoid <- function(h1, h2, w) {
  return((h1 * w) + ((1 / 2) * (h2 - h1) * w))
}

#' Function for making an array of numbers from start to end, separated by a
#' specified value.
#' @param x0 Starting value
#' @param x1 Ending value
#' @param dx Value to ``jump'' by
#' @return Array of values from x0 to x1, in jumps of dx.
makeRange <- function(x0, x1, dx) {
  result <- c()
  progress <- x0
  repeat {
    result <- append(result, progress)
    progress <- progress + dx
    if (progress > x1) break
  }
  return(result)
}

#' Function for producing an estimate of a first integral of a function.  In
#' its current configuration, it will asymptote to the true value from below as
#' dx goes to 0.
#' @param f Function to ``integrate''
#' @param x0 Value to start at
#' @param x1 Value to end at
#' @param dx Precision of the estimate
#' @return Estimate of the first integral of the function f between x0 and x1
integral <- function(f, x0, x1, dx) {
  # Max. value is x1 - dx to avoid overestimating by adding on an extra
  # trapezoid beyond the max. of the range
  valueRange <- makeRange(x0, x1 - dx, dx)
  trapezoids <- sapply(
    valueRange,
    function(x) {
      return(areaTrapezoid(f(x), f(x + dx), dx))
    }
  )
  return(sum(trapezoids))
}


# Here's an example of usage of these functions.

# I'd like to know how to pass additional arguments to this function in a nicer
# way than specifying the list in the `integral` function call
# quad <- function(x, a, b, c) return((a * (x ** 2)) + (b * x) + c)

quad <- function(x) return(x ** 2)

integral(quad, 2, 9, dx = 0.01)  #=> 240.3334

# The integral from 2 to 9 of x^2 is 240.3333... so this looks to be quite
# good!  But I found some strange behaviour:

integral(quad, 2, 9, dx = 0.1)    #=> 240.345  (overestimate)
integral(quad, 2, 9, dx = 0.001)  #=> 240.2523 (underestimate)

# I'd need to look into this more to properly understand why.
