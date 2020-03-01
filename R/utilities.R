# from https://github.com/pzhaonet/ncovr/blob/master/R/ncovr.R
conv_time <- function(x){
  as.POSIXct('1970-01-01', tz = 'GMT') + x / 1000
}

conv_firstletter <- function(x){
  paste(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)), sep = "")
}
