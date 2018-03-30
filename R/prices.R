# ------------------------------------------------------------------------------
# Tiingo prices

#' Get stock or ETF prices from the Tiingo API
#'
#' The Tiingo API provides a large feed of historical data at the
#' daily (and monthly, quarterly, or yearly) level.
#'
#' @param ticker One or more tickers to download data for from Tiingo. Can be a
#' stock, mutual fund, or ETF. A character vector.
#' @param start_date The first date to download data for.
#' A character in the form YYYY-MM-DD, or a `Date` variable. The default is to
#' download 1 year's worth of data.
#' @param end_date The last date to download data for.
#' A character in the form YYYY-MM-DD, or a `Date` variable.
#' @param resample_frequency For Tiingo data, a character specified as one of:
#' `"daily"`, `"monthly"`, `"quarterly"` or `"yearly"`. For IEX data, a character
#' specified at the `"min"` or `"hour"` frequencies in the form:
#' `"1min"`, `"5min"`, or `"2hour"`.
#'
#' @details
#'
#' Multiple downloads are done _sequentially_, meaning that downloading 5 tickers
#' costs 5 requests against your usage limits. Sadly Tiingo does not support
#' batch downloads at the moment.
#'
#' __Tiingo supplied documentation regarding the resample frequency:__
#'  * daily: Values returned as daily periods, with a holiday calendar
#'  * weekly: Values returned as weekly data, with days ending on Friday
#'  * monthly: Values returned as monthly data, with days ending on the last standard business day (Mon-Fri) of each month
#'  * annually: Values returned as annual data, with days ending on the last standard business day (Mon-Fri) of each year
#'
#'  * Note, that if you choose a value in-between the resample period for weekly,
#' monthly, and daily, the start date rolls back to consider the entire period.
#' For example, if you choose to resample weekly, but your "start_date" parameter
#' is set to Wednesday of that week, the start_date will be adjusted to Monday,
#' so the entire week is captured. Another example is if you send a start_date
#' mid-month, we roll back the start_date to the beginning of the month.
#'
#'  * Similarly, if you provide an end_date, and it's midway through the period,
#' we roll-forward the date to capture the whole period. In the above example,
#' if the end date is set to a wednesday with a weekly resample, the end date is
#' rolled forward to the Friday of that week.
#'
#'
#' @examples
#'
#' # Downloading 1 year's worth of prices for AAPL
#' riingo_prices("AAPL")
#'
#' # Downloading a range of data, using 2 tickers
#' riingo_prices(c("AAPL", "MSFT"), "1999-01-01", "2005-01-01")
#'
#' # Monthly data
#' riingo_prices(c("AAPL", "MSFT"), "1999-01-01", "2005-01-01", "monthly")
#'
#' @export
riingo_prices <- function(ticker, start_date = NULL, end_date = NULL, resample_frequency = "daily") {

  assert_valid_argument_inheritance(ticker, start_date, end_date, resample_frequency)
  assert_resample_freq_is_granular(resample_frequency)

  purrr::map_dfr(
    .x = ticker,
    .f = riingo_prices_single,
    start_date = start_date,
    end_date = end_date,
    resample_frequency = resample_frequency
  )

}

riingo_prices_single <- function(ticker, start_date = NULL, end_date = NULL, resample_frequency = "daily") {
  base_url <- retrieve_base_url("tiingo")

  start_date <- as_parameter(start_date, "startDate")
  end_date <- as_parameter(end_date, "endDate")
  resample_frequency <- as_parameter(resample_frequency, "resampleFreq")

  temp_url <- paste0(base_url, ticker, "/prices?") # Append tickers
  temp_url <- paste0(temp_url, start_date, end_date, resample_frequency) # Append parameters

  riingo_data <- skeleton_downloader(temp_url, ticker, "tiingo_prices")

  riingo_data_with_ticker <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data_with_ticker
}

# ------------------------------------------------------------------------------
# IEX prices

#' Get stock or ETF prices from IEX through Tiingo
#'
#' The Tiingo API provides a way to access data from IEX, The Investors Exchange.
#' This data is supplied at a much lower (intraday!) frequency than the data from Tiingo's
#' native API.
#'
#' @inheritParams riingo_prices
#'
#' @details
#'
#' This feed returns the most recent 2000 ticks of data at the specified frequency.
#' For example, `"5min"` would return the 2000 most recent data points spaced 5 minutes apart.
#' You can subset the returned range with `start_date` and `end_date`, but __you cannot
#' request data older than today's date minus 2000 data points.__
#'
#' Because the default attempts to pull 1 year's worth of data, at a 5 minute
#' frequency, all available data will be pulled so there is no need to use
#' `start_date` and `end_date`. Only use them if you set the frequency to hourly.
#'
#' @examples
#'
#' # Pulling all available minute level data for Apple
#' riingo_prices_iex("AAPL", resample_frequency = "1min")
#'
#' # This would result in an error, as you are pulling outside the available range
#' # riingo_prices_iex("AAPL", "1990-01-01", "2000-01-01", resample_frequency = "5min")
#'
#' @export
riingo_prices_iex <- function(ticker, start_date = NULL, end_date = NULL, resample_frequency = "5min") {

  assert_valid_argument_inheritance(ticker, start_date, end_date, resample_frequency)
  assert_resample_freq_is_fine(resample_frequency)

  purrr::map_dfr(
    .x = ticker,
    .f = riingo_prices_iex_single,
    start_date = start_date,
    end_date = end_date,
    resample_frequency = resample_frequency
  )

}

riingo_prices_iex_single <- function(ticker, start_date = NULL, end_date = NULL, resample_frequency = "5min") {
  base_url <- retrieve_base_url("iex")

  start_date <- as_parameter(start_date, "startDate")
  end_date <- as_parameter(end_date, "endDate")
  resample_frequency <- as_parameter(resample_frequency, "resampleFreq")

  temp_url <- paste0(base_url, ticker, "/prices?") # Append tickers
  temp_url <- paste0(temp_url, start_date, end_date, resample_frequency) # Append parameters

  riingo_data <- skeleton_downloader(temp_url, ticker, "tiingo_prices_iex")

  riingo_data_with_ticker <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data_with_ticker
}
