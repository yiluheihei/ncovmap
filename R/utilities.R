# from https://github.com/pzhaonet/ncovr/blob/master/R/ncovr.R
conv_time <- function(x){
  as.POSIXct('1970-01-01', tz = 'GMT') + x / 1000
}
