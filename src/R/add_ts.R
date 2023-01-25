#!/usr/bin/env R

## ----------------------------------------------------------------------------
## Functions written to keep track of my timesheets while working at the Centre
## for Comparative Genomics. Intended to be used in an interactive session -- I
## had a specific directory for this purpose, which meant that starting an R
## session in this directory already had the functions in the workspace.
## Otherwise, it would only be necessary to source this file.
## ----------------------------------------------------------------------------
## - The rates of pay have been blanked out. These will need to be entered if
##   you want to use these functions, or the functions modified.
## - The date check was because of a slight pay increase, but was no longer
##   necessary in the long run.
## - The path to the CSV is passed in rather than hardcoded. This was because I
##   had two different casual positions when I first started writing this set
##   of functions, and wanted to keep track of the pay separately.
## - Although the indent level is 4, I haven't rewritten it. I am still not
##   entirely sure whether the common convention for R is to use 2 or 4 spaces,
##   but I tend to use 2 for almost everything I do (except Python re: PEP8).
## ----------------------------------------------------------------------------

new_ts <- function(csv_path, date, time) {
    ymd <- "%Y-%m-%d"
    csv <- read.csv(csv_path, header = TRUE, stringsAsFactors = FALSE)
    grp <- data.frame(matrix(NA, ncol = 3, nrow = dim(csv)[1] + 1))
    names(grp) <- names(csv)
    grp[1:dim(csv)[1], ] <- csv
    grp[dim(csv)[1] + 1, 1:2] <- c(date, time)
    for(i in 1:dim(grp)[1]) {
        if(strptime(grp[i, 1], ymd) < strptime("2019-11-08", ymd)) {
            grp[i, 3] <- as.numeric(grp[i, 2]) * NULL  # Pay rate 1
        } else {
            grp[i, 3] <- as.numeric(grp[i, 2]) * NULL  # Pay rate 2
        }
    }
    grp[, 2] <- sprintf("%.2f", as.numeric(grp[, 2]))
    grp[, 3] <- sprintf("%.2f", as.numeric(grp[, 3]))
    write.csv(grp[order(grp[, 1]), ], csv_path, row.names = FALSE)
    return(tail(grp, n = 6L))
}

query_ts <- function(csv_path, start, end) {
    csv <- read.csv(csv_path, header=TRUE, stringsAsFactors=FALSE)
    csv[, 2] <- sprintf("%.2f", as.numeric(csv[, 2]))
    csv[, 3] <- sprintf("%.2f", as.numeric(csv[, 3]))
    res <- subset(csv, csv[, 1] >= start & csv[, 1] <= end)
    fin <- rbind(
        res,
        c(
            "SUBTOTAL",
            sprintf("%.2f", as.numeric(res[, 2])),
            sprintf("%.2f", as.numeric(res[, 3]))
        )
    )
    cat("\n"); print(res)
    cat("\nSUBTOTAL:\n\tHours:\t",
        sprintf("%.2f", sum(as.numeric(res[, 2]))),
        "\n\tPay:\t",
        sprintf("%.2f", sum(as.numeric(res[, 3]))),
        "\n")
    return(invisible(fin))
}

rm_ts <- function(csv_path, date) {
    csv <- read.csv(csv_path, header=TRUE, stringsAsFactors=FALSE)
    rs <- readline(
        prompt=cat("Are you sure you want to remove this timesheet? [y/n]")
    )
    if(! tolower(rs) %in% c("y", "n")) {
        stop("Please answer only y or n")
    }
    if(tolower(rs) == "y") {
        temp <- csv[which(csv[, 1] == date), ]
        csv <- csv[-which(csv[, 1] == date), ]
        write.csv(csv, csv_path, row.names=FALSE)
        cat(
            "Timesheet for date ",
            date,
            " removed.",
            "\nHours:\t",
            sprintf("%.2f", as.numeric(temp[, 2])),
            "\nPay:\t",
            sprintf("%.2f", as.numeric(temp[, 3])),
            "\n",
            sep=""
        )
        return(invisible(csv))
    } else {
        cat("Operation cancelled.")
    }
}
