test_that("can get fundamentals metrics", {
  skip_if_no_token()

  x <- riingo_fundamentals_metrics(c("AAPL", "MSFT"), start_date = "2020-01-01")

  cols <- c(
    "ticker", "date", "marketCap", "enterpriseVal", "peRatio",
    "pbRatio", "trailingPEG1Y"
  )

  expect_identical(all(cols %in% names(x)), TRUE)
  expect_identical(unique(x$ticker), c("AAPL", "MSFT"))
})
