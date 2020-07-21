#' Forex - Prices
#'
#' @description
#' This function collects forex prices for specified tickers. It can return
#' daily, hourly, and minutely data, however, the amount of returned data
#' becomes more limited with a finer resolution.
#'
#' @inheritParams riingo_prices
#'
#' @param ticker One or more fx tickers to download financial metrics for, such
#'   as `"audusd"` or `"eurusd"`.
#'
#' @param resample_frequency A single character specified at the `"day"`,
#'   `"min"` or `"hour"` frequencies in the form: `"1day"`, `"1min"`,
#'   `"5min"`, or `"2hour"`.
#'
#' @return
#' A data frame containing the fx prices for the requested tickers.
#'
#' @export
#' @examples
#' \dontrun{
#' start <- Sys.Date() - 10
#' riingo_fx_prices(c("audusd", "eurusd"), start_date = start)
#' }
riingo_fx_prices <- function(ticker,
                             start_date = NULL,
                             end_date = NULL,
                             resample_frequency = "1day") {
  assert_x_inherits(ticker, "ticker", class = "character")
  assert_x_inherits_one_of(start_date, "start_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits_one_of(end_date, "end_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits(resample_frequency, "resample_frequency", "character")

  results <- purrr::map(
    .x = ticker,
    .f = riingo_fx_prices_single_safely,
    start_date = start_date,
    end_date = end_date,
    resample_frequency = resample_frequency
  )

  validate_not_all_null(results)

  vctrs::vec_rbind(!!!results)
}


riingo_fx_prices_single_safely <- function(ticker,
                                           start_date,
                                           end_date,
                                           resample_frequency) {
  riingo_single_safely(
    .f = riingo_fx_prices_single,
    ticker = ticker,
    start_date = start_date,
    end_date = end_date,
    resample_frequency = resample_frequency
  )
}

riingo_fx_prices_single <- function(ticker,
                                    start_date,
                                    end_date,
                                    resample_frequency) {
  type <- "tiingo"
  endpoint <- "fx-prices"

  # URL construction
  riingo_url <- construct_url(
    type,
    endpoint,
    ticker,
    startDate = start_date,
    endDate = end_date,
    resampleFreq = resample_frequency
  )

  # Download
  cont_df <- content_downloader(riingo_url, ticker)

  # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

  # Tiingo seems to try and provide a ticker column, but I'd rather use
  # my own
  ticker <- riingo_data[["ticker"]]
  if (!is.null(ticker)) {
    riingo_data[["ticker"]] <- NULL
  }

  # Add ticker
  riingo_data_with_ticker <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data_with_ticker
}
