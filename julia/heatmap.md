# Julia:  Heatmap of Euclid's algorithm
#### Mr. George L. Malone
#### 26<sup>th</sup> of January, 2021

### Why?

I was curious to see if I could write a short script in Julia to map out the
number of iterations required to calculate the greatest common divisor, using
Euclid's algorithm, of the numbers 1 to 100 with themselves (sort of).  I
mainly wanted to do this because I like heatmaps, I like the Inferno palette,
and I like the [UnicodePlots package](
https://github.com/Evizero/UnicodePlots.jl) (though I am quite literally brand
new to Julia, just started playing around with it today).  I thought that
mapping out the number of iterations for Euclid's algorithm might make an
interesting graph.

### How?

Using the following script:

```julia
using UnicodePlots

# Silent version of euclid.jl
function euclid_silent(a, b, max_iter = 100)
  seq = (b > a) ? [b, a] : [a, b]
  for i in 2:max_iter
    x = seq[i - 1]
    y = seq[i]
    r = x - (y * floor(x / y))
    if r == 0
      return(seq)
    end
    push!(seq, r)
  end
  return(seq)
end

# Make a matrix of Euclid's algorithm iterations
function euclid_matrix(m, n)
  return([(length(euclid_silent(i, j)) - 2) for i in 1:m, j in 1:n])
end

# Get the matrix
A = euclid_matrix(100, 100)

# Draw the heatmap
heatmap(A, height = 100, width = 100, colormap = :inferno)
```

### What?

I saw something interesting that I can't explain.  Below is a screenshot of the
graph output.  Apologies for the missing line there, each run does the same
thing.  (If anyone's looking and wants to test the bug(s), I'm running Konsole
in Ubuntu MATE on a Raspberry Pi 4, with Nord theme, and using the Julia REPL)

![Heatmap of Euclid iterations](heatmap_euclid.png "Heatmap of Euclid
iterations")

Now, of course this is going to be symmetric over the line `x = y`.  But what
is interesting to me are the patterns.  Sort of "fault lines" in the matrix, as
well as a handful of smaller patterns or clusters.  In particular, there are
clusters of high and low values making some almost regular shapes, and there
are lines of high and low values, almost like ridges and valleys.  It appears
that the minimum number of iterations is 0, and the maximum is 8 (which is
confirmed in the REPL).  Note that the minimum length of the object returned is
2, therefore the number of iterations is the length of the object minus 2.

### Conclusion

If anyone can shed any light on this, I would be quite interested.  This
appears to me to be quite fascinating, and I haven't any kind of knowledge or
experience to be able to explain this.  I probably would never have noticed
this unless I made this heatmap, and I'm not certain as to why I thought it
might be an interesting idea.

On another note, Julia seems quite fun to use for this sort of thing, and I do
love heatmaps with the Inferno palette!  I rather like the terminal-based
[UnicodePlots.jl](https://github.com/Evizero/UnicodePlots.jl), so I recommend
having a look at that too.
