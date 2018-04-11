context("test-quote.R")

# ------------------------------------------------------------------------------
# Tiingo

# Quote is not a thing for the Tiingo API piece

# ------------------------------------------------------------------------------
# IEX

test_that("riingo iex quote - can be pulled", try_again(2, {
  skip_if_no_auth()

  prices <- riingo_iex_quote("AAPL")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 17) # structurally should always have this many cols
}))

# ------------------------------------------------------------------------------
# Crypto

test_that("riingo crypto quote - can be pulled", try_again(2, {
  skip_if_no_auth()

  prices <- riingo_crypto_quote("btcusd")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 15) # structurally should always have this many cols
}))

test_that("riingo crypto quote - raw can be pulled", try_again(2, {
  skip_if_no_auth()

  prices <- riingo_crypto_quote("btcusd", raw = TRUE)

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 12) # structurally should always have this many cols
}))
