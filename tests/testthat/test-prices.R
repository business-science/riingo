# ------------------------------------------------------------------------------
# Tiingo

test_that("riingo prices - can be pulled", {
  skip_if_no_token()

  prices <- riingo_prices("AAPL")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 14) # structurally should always have 14 cols
})

test_that("riingo prices - multiple tickers can be pulled", {
  skip_if_no_token()

  prices <- riingo_prices(c("AAPL", "MSFT"))
  tickers <- unique(prices$ticker)

  expect_is(prices, "tbl_df")
  expect_equal(length(tickers), 2)
  expect_equal(ncol(prices), 14) # structurally should always have 14 cols
})

test_that("riingo prices - start date / end date args work", {
  skip_if_no_token()

  prices <- riingo_prices("AAPL", start_date = "2017-01-03", end_date = "2017-01-05")

  expect_equal(nrow(prices), 3) # 3 days here
})

test_that("riingo prices - resample freq arg works - monthly", {
  skip_if_no_token()

  prices <- riingo_prices(
    "AAPL",
    start_date = "2017-01-01",
    end_date = "2017-03-31",
    resample_frequency = "monthly"
  )

  expect_equal(nrow(prices), 3) # 3 months here
})

test_that("riingo prices - resample freq arg works - weekly", {
  skip_if_no_token()

  prices <- riingo_prices(
    "AAPL",
    start_date = "2017-01-01",
    end_date = "2017-03-31",
    resample_frequency = "weekly"
  )

  expect_equal(nrow(prices), 14) # 14 weeks
})

test_that("riingo prices - resample freq arg works - annually", {
  skip_if_no_token()

  prices <- riingo_prices(
    "AAPL",
    start_date = "2017-01-01",
    end_date = "2017-03-31",
    resample_frequency = "annually"
  )

  expect_equal(nrow(prices), 1) # 1 year
})

test_that("riingo prices - fails gracefully on single unknown ticker", {
  skip_if_no_token()

  expect_error(
    expect_warning(
      riingo_prices("badticker"),
      "Ticker 'BADTICKER' not found"
    ),
    "All tickers failed to download any data"
  )

})

test_that("riingo prices - fails gracefully on multiple unknown tickers", {
  skip_if_no_token()

  expect_error(
    expect_warning(
      riingo_prices(c("badticker", "badticker2")),
      "Ticker 'BADTICKER2' not found"
    ),
    "All tickers failed to download any data"
  )

})

test_that("riingo prices - handles partial successes", {
  skip_if_no_token()

  x <- expect_warning(
    riingo_prices(c("badticker2", "AAPL", "badticker2")),
    "Ticker 'BADTICKER2' not found"
  )

  expect_is(x, "tbl_df")
  expect_equal(x$ticker[1], "AAPL")
})

# ------------------------------------------------------------------------------
# IEX

test_that("riingo iex prices - can be pulled", {
  skip_if_no_token()

  prices <- riingo_iex_prices("AAPL")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 7) # structurally should always have 6 cols
  expect_true("volume" %in% names(prices))
})

test_that("riingo iex prices - start date / end date args work", {
  skip_if_no_token()

  start <- Sys.Date() - 10
  end   <- Sys.Date() - 1

  start_UTC <- as.POSIXct(start)
  attr(start_UTC, "tzone") <- "UTC"

  # pulls all of end date (through 23:59:59), so need to go 1 day further for checking
  end_UTC <- as.POSIXct(end + 1)
  attr(end_UTC, "tzone") <- "UTC"

  prices <- riingo_iex_prices("AAPL", start_date = start, end_date = end)

  expect_true(start_UTC <= min(prices$date))
  expect_true(end_UTC   >= max(prices$date))
})

test_that("riingo iex prices - resample freq arg works", {
  skip_if_no_token()

  prices <- riingo_iex_prices("AAPL", resample_frequency = "1min")

  min_diff <- as.numeric(min(diff(prices$date))) # should be 1 if minute data

  expect_equal(min_diff, 1)
})

test_that("riingo iex prices - after hours arg works", {
  skip_if_no_token()

  # Tough to reliably know if it really works. Interactive testing
  # showed that it does.
  prices <- riingo_iex_prices("AAPL", after_hours = TRUE)

  expect_identical(prices$ticker[[1]], "AAPL")
})

test_that("riingo iex prices - fails gracefully on single unknown ticker", {
  skip_if_no_token()

  expect_error(
    expect_warning(
      riingo_iex_prices("badticker"),
      "Not found."
    ),
    "All tickers failed to download any data"
  )

})

test_that("riingo iex prices - fails gracefully on multiple unknown tickers", {
  skip_if_no_token()

  expect_error(
    expect_warning(
      riingo_iex_prices(c("badticker", "badticker2")),
      "Not found."
    ),
    "All tickers failed to download any data"
  )
})

test_that("riingo iex prices - handles partial successes", {
  skip_if_no_token()

  x <- expect_warning(
    riingo_iex_prices(c("badticker2", "AAPL", "badticker2")),
    "Not found."
  )

  expect_is(x, "tbl_df")
  expect_equal(x$ticker[1], "AAPL")
  expect_equal(ncol(x), 7)
})

# ------------------------------------------------------------------------------
# Crypto

test_that("riingo crypto prices - can be pulled", {
  skip_if_no_token()

  prices <- riingo_crypto_prices("btcusd")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 11) # structurally should have this many cols
})

test_that("riingo crypto prices - start date / end date args work", {
  skip_if_no_token()

  start <- Sys.Date() - 10
  end   <- Sys.Date() - 1

  start_UTC <- as.POSIXct(start)
  attr(start_UTC, "tzone") <- "UTC"

  # pulls all of end date (through 23:59:59), so need to go 1 day further for checking
  end_UTC <- as.POSIXct(end + 1)
  attr(end_UTC, "tzone") <- "UTC"

  prices <- riingo_crypto_prices("btcusd", start_date = start, end_date = end)

  expect_true(start_UTC <= min(prices$date))
  expect_true(end_UTC   >= max(prices$date))
})

test_that("riingo crypto prices - resample freq arg works", {
  skip_if_no_token()

  prices <- riingo_crypto_prices("btcusd", resample_frequency = "1min")

  min_diff <- as.numeric(min(diff(prices$date))) # should be 1 if minute data

  expect_equal(min_diff, 1)
})

test_that("riingo crypto prices - base currency pulls all of base", {
  skip_if_no_token()

  prices <- riingo_crypto_prices(base_currency = "btc")

  unique_quotes <- unique(prices$quoteCurrency)

  expect_is(prices, "tbl_df")
  expect_true(length(unique_quotes) >= 1) # multiple currencies pulled
})

test_that("riingo crypto prices - base currency can't be specified with ticker", {
  expect_error(
    riingo_crypto_prices(
      ticker = "btcusd",
      base_currency = "btc"
    ),
    "Cannot specify both"
  )
})

test_that("riingo crypto prices - raw data can be pulled", {
  skip_if_no_token()

  prices <- riingo_crypto_prices("btcusd", raw = TRUE)

  expect_equal(ncol(prices), 12) # One more col than normal, exchangeCode
})

test_that("riingo crypto prices - specific exchanges can be specified", {
  skip_if_no_token()

  prices <- riingo_crypto_prices("btcusd", exchanges = "BINANCE", raw = TRUE)

  exchangeCode <- unique(prices$exchangeCode) # should ONLY be BINANCE

  expect_equal(exchangeCode, "BINANCE")
})

test_that("riingo crypto prices - convert currency works", {
  skip_if_no_token()

  prices <- riingo_crypto_prices("btcusd", convert_currency = "jpy")

  expect_equal(ncol(prices), 17) # 17 columns with the fx ones
})
