test_that("can get fundamentals meta data", {
  skip_if_no_token()

  x <- riingo_fundamentals_meta(c("AAPL", "MSFT"))

  expect_identical("permaTicker" %in% names(x), TRUE)
  expect_s3_class(x$statementLastUpdated, "POSIXct")
  expect_s3_class(x$dailyLastUpdated, "POSIXct")
})

test_that("can fail nicely", {
  skip_if_no_token()

  expect_error(
    riingo_fundamentals_meta("PRHSX"),
    "No error was thrown"
  )
})

test_that("works with partial failure", {
  x <- riingo_fundamentals_meta(c("AAPL", "MSFT", "PRHSX"))
  expect_identical(nrow(x), 2L)
})
