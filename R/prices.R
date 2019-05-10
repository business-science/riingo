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
#' `"1min"`, `"5min"`, or `"2hour"`. For Crypto data, a character specified at
#' the `"min"`, `"hour"` or `"day"` frequencies similar to IEX.
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
#' \dontrun{
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
#' }
#'
#' @export
riingo_prices <- function(ticker, start_date = NULL, end_date = NULL, resample_frequency = "daily") {

  assert_valid_argument_inheritance(ticker, start_date, end_date, resample_frequency)
  assert_resample_freq_is_granular(resample_frequency)

  results <- purrr::map(
    .x = ticker,
    .f = riingo_prices_single_safely,
    start_date = start_date,
    end_date = end_date,
    resample_frequency = resample_frequency
  )

  validate_not_all_null(results)

  dplyr::bind_rows(results)
}

riingo_prices_single_safely <- function(ticker, start_date, end_date, resample_frequency) {
  riingo_single_safely(
    .f = riingo_prices_single,
    ticker = ticker,
    start_date = start_date,
    end_date = end_date,
    resample_frequency = resample_frequency
  )
}

riingo_prices_single <- function(ticker, start_date, end_date, resample_frequency) {

  type <- "tiingo"
  endpoint <- "prices"

  # URL construction
  riingo_url <- construct_url(
    type, endpoint, ticker,
    startDate = start_date,
    endDate = end_date,
    resampleFreq = resample_frequency
  )

  # Download
  json_content <- content_downloader(riingo_url, ticker)

  # Parse
  cont_df <- jsonlite::fromJSON(json_content)

  # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

  # Add ticker
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
#' \dontrun{
#'
#' # Pulling all available minute level data for Apple
#' riingo_iex_prices("AAPL", resample_frequency = "1min")
#'
#' # This would result in an error, as you are pulling outside the available range
#' # riingo_iex_prices("AAPL", "1990-01-01", "2000-01-01", resample_frequency = "5min")
#'
#' }
#'
#' @export
riingo_iex_prices <- function(ticker, start_date = NULL, end_date = NULL, resample_frequency = "5min") {

  assert_valid_argument_inheritance(ticker, start_date, end_date, resample_frequency)
  assert_resample_freq_is_fine(resample_frequency)

  purrr::map_dfr(
    .x = ticker,
    .f = riingo_iex_prices_single,
    start_date = start_date,
    end_date = end_date,
    resample_frequency = resample_frequency
  )

}

riingo_iex_prices_single <- function(ticker, start_date = NULL, end_date = NULL, resample_frequency = "5min") {

  type <- "iex"
  endpoint <- "prices"

  # URL construction
  riingo_url <- construct_url(
    type, endpoint, ticker,
    startDate = start_date,
    endDate = end_date,
    resampleFreq = resample_frequency
  )

  # Download
  json_content <- content_downloader(riingo_url, ticker)

  # Parse
  cont_df <- jsonlite::fromJSON(json_content)

  # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

  # Add ticker
  riingo_data_with_ticker <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data_with_ticker
}

# ------------------------------------------------------------------------------
# Crypto prices


#' Get cryptocurrency prices aggregated through Tiingo
#'
#'
#' @inheritParams riingo_prices
#' @param ticker One or more cryptocurrency tickers.
#' Specified as `"btcusd"` for bitcoin quoted in USD. A character vector.
#' @param base_currency _Instead_ of `ticker` you may pass a base currency.
#' This selects all currencies with that base currency.
#' For example if `base_currency="btc"`` tickers _btcusd_, _btcjpy_, _btceur_, etc..
#' will all be returned.
#' @param exchanges If you would like to limit the query to a subset of exchanges,
#' pass a comma-separated list of exchanges to select. Example) `"POLONIEX, GDAX"`
#' @param convert_currency This parameter will convert the return data into another
#' fx rate. For example if querying `BTCUSD` and convert_currency is `'cure'`,
#' the bitcoin prices will be converted to CureCoin prices.
#' Setting this to a value will add `fxOpen`, `fxHigh`, `fxLow`, `fxClose`, `fxVolumeNotional`,
#' and `fxRate` accordingly. `fxRate` is the rate used to perform the currency calculation.
#' If `exchanges` is specified, the conversion rate will be calculated using the exchanges passed.
#' @param raw If `TRUE`, the raw underlying data from multiple exchanges will be
#' returned, rather than the clean prices. This is the data that calculates the aggregated prices and quotes.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Bitcoin prices
#' riingo_crypto_prices("btcusd")
#'
#' # Bitcoin in USD and EUR
#' riingo_crypto_prices(c("btcusd", "btceur"), start_date = "2018-01-01", resample_frequency = "5min")
#'
#' # Bitcoin raw data
#' riingo_crypto_prices("btcusd", raw = TRUE)
#'
#' # Only use the POLONIEX exchange
#' riingo_crypto_prices("btcusd", raw = TRUE, exchanges = "POLONIEX")
#'
#' # All btc___ crypotcurrency pairs
#' riingo_crypto_prices(base_currency = "btc")
#'
#' }
#'
riingo_crypto_prices <- function(ticker, start_date = NULL, end_date = NULL,
                                 resample_frequency = "1day", base_currency = NULL,
                                 exchanges = NULL, convert_currency = NULL, raw = FALSE) {

  if(!is.null(base_currency)) {
    if(!missing(ticker)) {
      stop("Cannot specify both the ticker and the base_currency arguments.", call. = FALSE)
    } else {
      ticker <- NA_character_
    }
  }

  if(!is.null(convert_currency)) {
    if(length(ticker) > 1L) {
      warning("The Tiingo API only uses the first ticker when convert_currency is specified.", call. = FALSE)
    }
  }

  # Assertions
  assert_x_inherits(ticker, "ticker", class = "character")
  assert_x_inherits_one_of(start_date, "start_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits_one_of(end_date, "end_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits(resample_frequency, "resample_frequency", "character")
  assert_x_inherits_one_of(base_currency, "base_currency", c("NULL", "character"))
  assert_x_inherits_one_of(exchanges, "exchanges", c("NULL", "character"))
  assert_x_inherits_one_of(convert_currency, "convert_currency", c("NULL", "character"))
  assert_resample_freq_is_crypto(resample_frequency)

  type <- "crypto"
  endpoint <- "prices"

  # For crypto, tickers are passed as a comma separated parameter
  ticker <- glue::glue_collapse(ticker, ",")

  # URL construction
  riingo_url <- construct_url(
    type, endpoint, ticker = NULL,
    tickers = ticker,
    startDate = start_date,
    endDate = end_date,
    resampleFreq = resample_frequency,
    baseCurrency = base_currency,
    exchanges = exchanges,
    convertCurrency = convert_currency
  )

  if(raw) {

    riingo_url <- glue::glue(riingo_url, "&includeRawExchangeData=true")

    # Download
    json_content <- content_downloader(riingo_url, ticker)

    # Parse
    cont_df <- jsonlite::fromJSON(json_content)

    # We are only going to return exchange data, ignore price data
    exch_data_idx <- which(colnames(cont_df) == "exchangeData")
    pd_idx <- which(colnames(cont_df) == "priceData")

    # Meta data section
    meta <- tibble::as_tibble(cont_df[, -c(exch_data_idx, pd_idx)])
    meta_rows <- split(meta, meta$ticker)

    # The actual raw data
    exch_data <- cont_df[, exch_data_idx]

    seq_ticker <- seq_along(meta$ticker)

    # Extract "nested" data frames
    exch_data_rows <- purrr::map(seq_ticker, ~{
      i <- .x
      tibble::as_tibble(purrr::map_dfr(exch_data, ~.x[[i]]))
    })

    # Bind each row of meta to an exchange data frame
    riingo_df <- purrr::map2_dfr(meta_rows, exch_data_rows, ~cbind(.x, .y))

  } else {

    # Download
    json_content <- content_downloader(riingo_url, ticker)

    # Parse
    cont_df <- jsonlite::fromJSON(json_content)

    # Have to convert to tibble here, otherwise warnings in the map
    cont_tbl <- tibble::as_tibble(cont_df)

    # Coerce to tidy format (for each row, unnest the priceData)
    cont_tbl_split <- split(cont_tbl, cont_tbl$ticker)

    riingo_df <- purrr::map_dfr(cont_tbl_split, ~{
      pd_idx <- which(colnames(.x) == "priceData")
      meta <- .x[, -pd_idx]
      pd   <- purrr::flatten_dfr(.x[, pd_idx])
      cbind(meta, pd)
    })
  }

  # cbind() returned as df
  riingo_tbl <- tibble::as_tibble(riingo_df)

  # type convert date columns
  date_cols <- retrieve_date_col_names(type, endpoint)

  riingo_data <- purrr::modify_at(
    .x  = riingo_tbl,
    .at = date_cols,
    .f  = ~as.POSIXct(.x, tz = "UTC", format = retrieve_date_col_format(endpoint))
  )

  # Reorder columns
  riingo_data <- riingo_data[, retrieve_crypto_price_col_ordering(raw, convert_currency)]

  riingo_data
}

retrieve_crypto_price_col_ordering <- function(raw = FALSE, convert_currency = NULL) {
  if(raw) {
    cols <- c("ticker", "exchangeCode", "baseCurrency", "quoteCurrency", "date", "open", "high", "low", "close", "volume", "volumeNotional", "tradesDone")
  } else {
    cols <- c("ticker", "baseCurrency", "quoteCurrency", "date", "open", "high", "low", "close", "volume", "volumeNotional", "tradesDone")
  }

  if(!is.null(convert_currency)) {
    cols <- c(cols, "fxOpen", "fxHigh", "fxLow", "fxClose", "fxRate", "fxVolumeNotional")
  }

  cols
}
