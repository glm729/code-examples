#!/usr/bin/R

# -----------------------------------------------------------------------------
# Cleaner version of neat_date.R, which I wrote previously to assist with a
# preferred date format when writing university assignments in R Markdown. It
# turned out to be more useful than I thought, for a time.
# -----------------------------------------------------------------------------
# - Last modified:  2020-07-27
# - The indent level is 2, rather than 4. I am aware that this is inconsistent,
#   with reference to the other R source file I have here (add_ts.R). If you
#   know the proper style to use in R, please let me know.
# - If you know how to do this in TeX, I would really like to know.
# -----------------------------------------------------------------------------

neat_date <- function(date, ISO=FALSE){
  suffix <- "th"
  if(!startsWith(format(date, "%d"), "1")) {
    if(endsWith(format(date, "%d"), "1")) {
      suffix <- "st"
    }
    if(endsWith(format(date, "%d"), "2")) {
      suffix <- "nd"
    }
    if(endsWith(format(date, "%d"), "3")) {
      suffix <- "rd"
    }
  }
  if(ISO) {
    return(format(date, paste0("%Y-%m-%d")))
  } else {
    return(format(date, paste0("%e^", suffix, "^ of %B, %Y")))
  }
}
