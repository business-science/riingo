# ------------------------------------------------------------------------------
# Tiingo

test_that("riingo meta - can be pulled", {
  local_riingo_mock()

  meta <- riingo_meta("AAPL")

  expect_is(meta, "tbl_df")
  expect_equal(ncol(meta), 6) # structurally should always have this many cols
  expect_equal(nrow(meta), 1)
})

test_that("riingo meta - multiple tickers can be pulled", {
  local_riingo_mock()

  meta <- riingo_meta(c("AAPL", "MSFT"))

  expect_is(meta, "tbl_df")
  expect_equal(ncol(meta), 6) # structurally should always have this many cols
  expect_equal(nrow(meta), 2)
})

test_that("riingo meta - fails gracefully on single unknown ticker", {
  local_riingo_mock()

  expect_error(
    expect_warning(
      riingo_meta("badticker"),
      "Not found."
    ),
    "All tickers failed to download any data"
  )

})

test_that("riingo meta - fails gracefully on multiple unknown tickers", {
  local_riingo_mock()

  expect_error(
    expect_warning(
      riingo_meta(c("badticker", "badticker2")),
      "Not found."
    ),
    "All tickers failed to download any data"
  )

})

test_that("riingo meta - handles partial successes", {
  local_riingo_mock()

  x <- expect_warning(
    riingo_meta(c("badticker2", "AAPL", "badticker2")),
    "Not found."
  )

  expect_is(x, "tbl_df")
  expect_equal(x$ticker[1], "AAPL")
})

# ------------------------------------------------------------------------------
# IEX

# Meta does not exist for iex

# ------------------------------------------------------------------------------
# Crypto

test_that("riingo crypto meta - can be pulled", {
  local_riingo_mock()

  meta <- riingo_crypto_meta("btcusd")

  expect_is(meta, "tbl_df")
  expect_equal(ncol(meta), 5) # structurally should have this many cols
  expect_equal(nrow(meta), 1)
})

test_that("riingo crypto meta - fails gracefully on single unknown ticker", {
  local_riingo_mock()

  expect_error(
    expect_warning(
      riingo_crypto_meta("badticker"),
      "no content was returned"
    ),
    "All tickers failed to download any data"
  )

})

test_that("riingo crypto meta - fails gracefully on multiple unknown tickers", {
  local_riingo_mock()

  expect_error(
    expect_warning(
      riingo_crypto_meta(c("badticker", "badticker2")),
      "no content was returned"
    ),
    "All tickers failed to download any data"
  )

})

test_that("riingo crypto meta - handles partial successes", {
  local_riingo_mock()

  x <- expect_warning(
    riingo_crypto_meta(c("badticker2", "btcusd", "badticker2")),
    "no content was returned"
  )

  expect_is(x, "tbl_df")
  expect_equal(x$ticker[1], "btcusd")
})
