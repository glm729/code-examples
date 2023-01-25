#!/usr/bin/env julia


# Area of a trapezoid with:
# - flat base of width `bw`
# - side heights `h0` and `h1`
function area_trapezoid(
    h0::Union{Int64,Float64},
    h1::Union{Int64,Float64},
    bw::Union{Int64,Float64}
  )::Float64
  return (1.0 / 2.0) * bw * (h0 + h1)
end

# Estimate the integral of a function `func` between `from` and `to`, with step
# size `step`.  Appears to be more precise than the below function.
function estimate_integral(
    func,
    from::Union{Int64,Float64},
    to::Union{Int64,Float64},
    step::Union{Int64,Float64}
  )::Float64
  return reduce(
    (a, x) -> a += area_trapezoid(func(x), func(x + step), step),
    range(from, step = step, stop = to - step);
    init = 0.0
  )
end

# Theoretically identical operations to above, but appears to be less precise
# for some reason!  But would this one not be less computationally intensive?
# No need to construct the iterators / objects for the reduce.
function estimate_integral(
    func,
    from::Union{Int64,Float64},
    to::Union{Int64,Float64},
    step::Union{Int64,Float64}
  )::Float64
  local area::Float64 = 0.0
  local x::Float64 = convert(Float64, from)
  while x < to
    area += area_trapezoid(func(x), func(x + step), step)
    x += step
  end
  return area
end
