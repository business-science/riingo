context("test-prices.R")

# ------------------------------------------------------------------------------
# Tiingo

test_that("riingo prices - can be pulled", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_prices("AAPL")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 14) # structurally should always have 14 cols
}))

test_that("riingo prices - multiple tickers can be pulled", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_prices(c("AAPL", "MSFT"))
  tickers <- unique(prices$ticker)

  expect_is(prices, "tbl_df")
  expect_equal(length(tickers), 2)
  expect_equal(ncol(prices), 14) # structurally should always have 14 cols
}))

test_that("riingo prices - start date / end date args work", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_prices("AAPL", start_date = "2017-01-03", end_date = "2017-01-05")

  expect_equal(nrow(prices), 3) # 3 days here
}))

test_that("riingo prices - resample freq arg works", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_prices("AAPL", start_date = "2017-01-01",
                        end_date = "2017-03-31", resample_frequency = "monthly")

  expect_equal(nrow(prices), 3) # 3 months here
}))

test_that("riingo prices - fails gracefully on unknown ticker", try_again(2, {
  skip_if_no_auth()
  expect_error(riingo_prices("badticker"), "Ticker 'BADTICKER' not found") # Tiingo msg is expected
}))

# ------------------------------------------------------------------------------
# IEX

test_that("riingo iex prices - can be pulled", try_again(2, {
  skip_if_no_auth()

  prices <- riingo_iex_prices("AAPL")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 6) # structurally should always have 6 cols
}))

test_that("riingo iex prices - start date / end date args work", try_again(2, {
  skip_if_no_auth()

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
}))

test_that("riingo iex prices - resample freq arg works", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_iex_prices("AAPL", resample_frequency = "1min")

  min_diff <- as.numeric(min(diff(prices$date))) # should be 1 if minute data

  expect_equal(min_diff, 1)
}))

test_that("riingo iex prices - fails gracefully on unknown ticker", try_again(2, {
  skip_if_no_auth()
  expect_error(riingo_iex_prices("badticker"), "Not found.") # Tiingo msg is expected
}))

# ------------------------------------------------------------------------------
# Crypto

test_that("riingo crypto prices - can be pulled", try_again(2, {
  skip_if_no_auth()

  prices <- riingo_crypto_prices("btcusd")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 11) # structurally should have this many cols
}))

test_that("riingo crypto prices - start date / end date args work", try_again(2, {
  skip_if_no_auth()

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
}))

test_that("riingo crypto prices - resample freq arg works", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_crypto_prices("btcusd", resample_frequency = "1min")

  min_diff <- as.numeric(min(diff(prices$date))) # should be 1 if minute data

  expect_equal(min_diff, 1)
}))

test_that("riingo crypto prices - base currency pulls all of base", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_crypto_prices(base_currency = "btc")

  unique_quotes <- unique(prices$quoteCurrency)

  expect_is(prices, "tbl_df")
  expect_true(length(unique_quotes) >= 1) # multiple currencies pulled
}))

test_that("riingo crypto prices - base currency can't be specified with ticker", try_again(2, {
  expect_error(riingo_crypto_prices(ticker = "btcusd", base_currency = "btc"),
               "Cannot specify both")
}))

test_that("riingo crypto prices - raw data can be pulled", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_crypto_prices("btcusd", raw = TRUE)

  expect_equal(ncol(prices), 12) # One more col than normal, exchangeCode
}))

test_that("riingo crypto prices - specific exchanges can be specified", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_crypto_prices("btcusd", exchanges = "BINANCE", raw = TRUE)

  exchangeCode <- unique(prices$exchangeCode) # should ONLY be BINANCE

  expect_equal(exchangeCode, "BINANCE")
}))

test_that("riingo crypto prices - convert currency works", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_crypto_prices("btcusd", convert_currency = "jpy")

  expect_equal(ncol(prices), 17) # 17 columns with the fx ones
}))
