test_that("can get a fx quote", {
  skip_if_no_token()

  x <- riingo_fx_quote(c("audusd", "jpyusd"))

  cols <- c(
    "index", "quoteTimestamp", "bidPrice", "bidSize",
    "askPrice", "askSize", "midPrice"
  )

  expect_true(all(cols %in% names(x)))
})
