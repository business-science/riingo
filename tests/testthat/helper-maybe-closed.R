new_york_time <- function() {
  .POSIXct(unclass(Sys.time()), tz = "America/New_York")
}

is_new_york_weekday <- function() {
  time <- as.POSIXlt(new_york_time())
  !(time$wday %in% c(6L, 7L))
}

is_at_least_9_35_am <- function() {
  time <- as.POSIXlt(new_york_time())
  nine_thirty_five <- (9L * 60L) + 35L
  (time$hour * 60L + time$min) > nine_thirty_five
}

is_market_probably_open <- function() {
  is_new_york_weekday() && is_at_least_9_35_am()
}

skip_if_maybe_closed <- function() {
  if (!is_market_probably_open()) {
    testthat::skip("Market is likely closed right now. Not attempting to pull.")
  }
}
