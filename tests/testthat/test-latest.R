context("test-latest.R")

# ------------------------------------------------------------------------------
# Tiingo

test_that("latest riingo prices - can be pulled", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_latest("AAPL")
  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 14) # structurally should always have this many cols
  expect_equal(nrow(prices), 1)  # structurally should always have this many rows
}))

# ------------------------------------------------------------------------------
# IEX

test_that("latest riingo iex prices - can be pulled", try_again(2, {
  skip_if_no_auth()

  prices <- riingo_iex_latest("AAPL")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 6) # structurally should always have 6 cols
}))

test_that("latest riingo iex prices - resample freq arg works", try_again(2, {
  skip_if_no_auth()
  prices <- riingo_iex_latest("AAPL", resample_frequency = "5min")

  min_diff <- as.numeric(min(diff(prices$date))) # should be 5 if 5minute data

  expect_equal(min_diff, 5)
}))

# ------------------------------------------------------------------------------
# Crypto

# These are all tested by riingo_crypto_prices()
