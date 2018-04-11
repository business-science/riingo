context("test-meta.R")

# ------------------------------------------------------------------------------
# Tiingo

test_that("riingo meta - can be pulled", try_again(2, {
  skip_if_no_auth()
  meta <- riingo_meta("AAPL")

  expect_is(meta, "tbl_df")
  expect_equal(ncol(meta), 6) # structurally should always have this many cols
  expect_equal(nrow(meta), 1)
}))

test_that("riingo meta - multiple tickers can be pulled", try_again(2, {
  skip_if_no_auth()
  meta <- riingo_meta(c("AAPL", "MSFT"))

  expect_is(meta, "tbl_df")
  expect_equal(ncol(meta), 6) # structurally should always have this many cols
  expect_equal(nrow(meta), 2)
}))


# ------------------------------------------------------------------------------
# IEX

# Meta does not exist for iex

# ------------------------------------------------------------------------------
# Crypto

test_that("riingo crypto meta - can be pulled", try_again(2, {
  skip_if_no_auth()

  meta <- riingo_crypto_meta("btcusd")

  expect_is(meta, "tbl_df")
  expect_equal(ncol(meta), 5) # structurally should have this many cols
  expect_equal(nrow(meta), 1)
}))
