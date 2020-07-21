# ------------------------------------------------------------------------------
# Tiingo

test_that("latest riingo prices - can be pulled", {
  skip_if_no_token()

  prices <- riingo_latest("AAPL")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 14) # structurally should always have this many cols
  expect_equal(nrow(prices), 1)  # structurally should always have this many rows
})

test_that("latest riingo prices - fails gracefully on single unknown ticker", {
  skip_if_no_token()

  expect_error(
    expect_warning(
      riingo_latest("badticker")
    ),
    "All tickers failed to download any data"
  )
})

test_that("latest riingo prices - fails gracefully on multiple unknown tickers", {
  skip_if_no_token()

  expect_error(
    expect_warning(
      riingo_latest(c("badticker", "badticker2"))
    ),
    "All tickers failed to download any data"
  )
})

test_that("latest riingo prices - handles partial successes", {
  skip_if_no_token()

  x <- expect_warning(
    riingo_latest(c("badticker2", "MSFT", "badticker2"))
  )

  expect_is(x, "tbl_df")
  expect_equal(x$ticker[1], "MSFT")
})

# ------------------------------------------------------------------------------
# IEX

test_that("latest riingo iex prices - can be pulled", {
  skip_if_no_token()

  prices <- riingo_iex_latest("AAPL")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 6) # structurally should always have 6 cols
})

test_that("latest riingo iex prices - resample freq arg works", {
  skip_if_no_token()

  prices <- riingo_iex_latest("AAPL", resample_frequency = "5min")

  min_diff <- as.numeric(min(diff(prices$date))) # should be 5 if 5minute data

  expect_equal(min_diff, 5)
})

test_that("latest riingo iex prices - fails gracefully on single unknown ticker", {
  skip_if_no_token()

  expect_error(
    expect_warning(
      riingo_iex_latest("badticker"),
      "Not found."
    ),
    "All tickers failed to download any data"
  )
})

test_that("latest riingo iex prices - fails gracefully on multiple unknown tickers", {
  skip_if_no_token()

  expect_error(
    expect_warning(
      riingo_iex_latest(c("badticker", "badticker2")),
      "Not found."
    ),
    "All tickers failed to download any data"
  )
})

test_that("latest riingo iex prices - handles partial successes", {
  skip_if_no_token()

  x <- expect_warning(
    riingo_iex_latest(c("badticker2", "AAPL", "badticker2")),
    "Not found."
  )

  expect_is(x, "tbl_df")
  expect_equal(x$ticker[1], "AAPL")
  expect_equal(ncol(x), 6)
})

# ------------------------------------------------------------------------------
# Crypto

# These are all tested by riingo_crypto_prices()
