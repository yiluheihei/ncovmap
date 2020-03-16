# from https://github.com/pzhaonet/ncovr/blob/master/R/ncovr.R
conv_time <- function(x){
  as.POSIXct('1970-01-01', tz = 'GMT') + x / 1000
}

conv_firstletter <- function(x){
  paste(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)), sep = "")
}

#' Format legend labels
#' @noRd
format_labels <- function(bins, sep = "~") {
  bins <- setdiff(bins, c(0, 1)) %>%
    c(0, 1, .)
  n <- length(bins)
  labels <- vector("character", n -1)
  labels[1] <- 0
  labels[n] <- paste(">=", bins[n])
  for (i in 2:(n-1)) {
    if (bins[i] == bins[i + 1] - 1) {
      labels[i] = bins[i]
    } else {
      labels[i] <- paste0(bins[i], sep, bins[i + 1]  - 1)
    }
  }

  labels
}
