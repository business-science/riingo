# ------------------------------------------------------------------------------
# Tiingo prices

#' The latest day's worth of data for a given ticker
#'
#' This returns only the most recent day of daily data for the supplied ticker(s).
#'
#' @inheritParams riingo_prices
#'
#' @examples
#'
#' # The latest available day of daily data for QQQ
#' riingo_latest("QQQ")
#'
#' @export
#'
riingo_latest <- function(ticker) {
  assert_x_inherits(ticker, "ticker", class = "character")

  purrr::map_dfr(ticker, riingo_latest_single)
}

riingo_latest_single <- function(ticker) {
  riingo_data <- validate_and_download(ticker, "tiingo", "latest")

  # For single days, the ordering is not the same as historical prices so we reorder to be consistent
  col_ordering <- retieve_latest_col_ordering()
  riingo_data <- riingo_data[,col_ordering]

  riingo_data_with_ticker <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data_with_ticker
}

retieve_latest_col_ordering <- function() {
  c("date", "close", "high", "low", "open", "volume", "adjClose", "adjHigh",
    "adjLow", "adjOpen", "adjVolume", "divCash", "splitFactor")
}

# ------------------------------------------------------------------------------
# IEX prices

#' The latest day's worth of intraday data for a given ticker
#'
#' This returns only the most recent day of intraday data for the supplied ticker(s).
#'
#' @inheritParams riingo_prices
#'
#' @examples
#'
#' # The latest available day of intraday data for QQQ
#' riingo_latest_iex("QQQ")
#'
#' riingo_latest_iex("QQQ", "1hour")
#'
#' @export
riingo_latest_iex <- function(ticker, resample_frequency = "1min") {
  assert_x_inherits(ticker, "ticker", class = "character")
  assert_x_inherits(resample_frequency, "resample_frequency", class = "character")
  assert_resample_freq_is_fine(resample_frequency)

  purrr::map_dfr(ticker, riingo_latest_iex_single)
}


riingo_latest_iex_single <- function(ticker, resample_frequency = "1min") {
  riingo_data <- validate_and_download(ticker, "iex", "latest", resample_frequency = resample_frequency)

  riingo_data$ticker <- NULL # to be consistent, don't use the provided meta ticker column
  riingo_data <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data
}
