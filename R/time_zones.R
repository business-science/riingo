#' Convert the `POSIXct` columns of a data frame to the local time zone
#'
#' Tiingo returns data with a UTC time zone. Often you will want to view this
#' in your own time zone. This function converts each `POSIXct` column of the
#' returned `tibble` to the local (or specified) time zone.
#'
#' @param .data A tibble with `POSIXct` columns
#' @param tz The time zone to convert to. The default is the local time zone.
#'
#' @export
#'
convert_to_local_time <- function(.data, tz = "") {
  assert_valid_tz(tz)
  purrr::modify_if(.data, ~inherits(.x, "POSIXct"), ~{attr(.x, "tzone") <- tz; .x})
}

assert_valid_tz <- function(tz) {
  is_invalid_tz <- (tz != "") && !(tz %in% OlsonNames())

  if(is_invalid_tz) {
    glue_stop("Supplied time zone, {green(tz)}, is not a known time zone.")
  }
}
