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
#' \dontrun{
#'
#' # The latest available day of daily data for QQQ
#' riingo_latest("QQQ")
#'
#' }
#'
#' @export
#'
riingo_latest <- function(ticker) {
  assert_x_inherits(ticker, "ticker", class = "character")

  purrr::map_dfr(ticker, riingo_latest_single)
}

riingo_latest_single <- function(ticker) {
  type <- "tiingo"
  endpoint <- "latest"

  # URL construction
  riingo_url <- construct_url(
    type, endpoint, ticker
  )

  # Download
  json_content <- content_downloader(riingo_url, ticker)

  # Parse
  cont_df <- jsonlite::fromJSON(json_content)

  # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

  # For single days, the ordering is not the same as historical prices so we reorder to be consistent
  col_ordering <- retrieve_latest_col_ordering()
  riingo_data <- riingo_data[,col_ordering]

  # Add ticker
  riingo_data_with_ticker <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data_with_ticker
}

retrieve_latest_col_ordering <- function() {
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
#' \dontrun{
#'
#' # The latest available day of intraday data for QQQ
#' riingo_iex_latest("QQQ")
#'
#' riingo_iex_latest("QQQ", "1hour")
#'
#' }
#'
#' @export
riingo_iex_latest <- function(ticker, resample_frequency = "1min") {
  assert_x_inherits(ticker, "ticker", class = "character")
  assert_x_inherits(resample_frequency, "resample_frequency", class = "character")
  assert_resample_freq_is_fine(resample_frequency)

  purrr::map_dfr(
    .x = ticker,
    .f = riingo_iex_latest_single,
    resample_frequency = resample_frequency
  )
}


riingo_iex_latest_single <- function(ticker, resample_frequency = "1min") {

  type <- "iex"
  endpoint <- "latest"

  # URL construction
  riingo_url <- construct_url(
    type, endpoint, ticker,
    resampleFreq = resample_frequency
  )

  # Download
  json_content <- content_downloader(riingo_url, ticker)

  # Parse
  cont_df <- jsonlite::fromJSON(json_content)

  # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

  # Add ticker
  riingo_data$ticker <- NULL # to be consistent, don't use the provided meta ticker column
  riingo_data <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data
}

# ------------------------------------------------------------------------------
# Crypto prices

#' The latest day's worth of intraday data for a given cryptocurrency
#'
#' This returns only the most recent day of intraday data for the supplied ticker(s).
#'
#' @inheritParams riingo_crypto_prices
#'
#' @examples
#'
#' \dontrun{
#'
#' # The latest available day of intraday data for QQQ
#' riingo_crypto_latest("btcusd")
#'
#'
#' }
#'
#' @export
riingo_crypto_latest <- function(ticker, resample_frequency = "1min", base_currency = NULL,
                                 exchanges = NULL, convert_currency = NULL, raw = FALSE) {
  riingo_crypto_prices(ticker,
                       start_date = NA_character_,
                       end_date = NA_character_,
                       resample_frequency,
                       base_currency,
                       exchanges,
                       convert_currency,
                       raw)
}
