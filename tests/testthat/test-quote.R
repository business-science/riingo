# ------------------------------------------------------------------------------
# Tiingo

# Quote is not a thing for the Tiingo API piece

# ------------------------------------------------------------------------------
# IEX

test_that("riingo iex quote - can be pulled", {
  local_riingo_mock()

  prices <- riingo_iex_quote("AAPL")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 17) # structurally should always have this many cols
})

test_that("riingo iex quote - fails gracefully on single unknown ticker", {
  local_riingo_mock()

  expect_error(
    expect_warning(
      riingo_iex_quote("badticker"),
      "no content was returned"
    ),
    "All tickers failed to download any data"
  )

})

test_that("riingo iex quote - fails gracefully on multiple unknown tickers", {
  local_riingo_mock()

  expect_error(
    expect_warning(
      riingo_iex_quote(c("badticker", "badticker2")),
      "no content was returned"
    ),
    "All tickers failed to download any data"
  )

})

test_that("riingo iex quote - handles partial successes", {
  local_riingo_mock()

  x <- expect_warning(
    riingo_iex_quote(c("badticker2", "AAPL", "badticker2")),
    "no content was returned"
  )

  expect_is(x, "tbl_df")
  expect_equal(x$ticker[1], "AAPL")
})

# ------------------------------------------------------------------------------
# Crypto

test_that("riingo crypto quote - can be pulled", {
  local_riingo_mock()

  prices <- riingo_crypto_quote("btcusd")

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 15) # structurally should always have this many cols
})

test_that("riingo crypto quote - raw can be pulled", {
  local_riingo_mock()

  prices <- riingo_crypto_quote("btcusd", raw = TRUE)

  expect_is(prices, "tbl_df")
  expect_equal(ncol(prices), 12) # structurally should always have this many cols
})
