test_that("can get fx prices", {
  skip_if_no_token()

  x <- riingo_fx_prices(c("audusd", "eurusd"))

  expect_identical(unique(x$ticker), c("audusd", "eurusd"))
  expect_s3_class(x$date, "POSIXct")
})

test_that("can get fx prices with partial failures", {
  skip_if_no_token()

  expect_warning(
    x <- riingo_fx_prices(c("audusd", "foobar")),
    "No error was thrown"
  )

  expect_identical(unique(x$ticker), "audusd")
})

test_that("can get 1 minute resolution prices", {
  skip_if_no_token()

  start <- Sys.Date() - 10
  end <- Sys.Date()

  x <- riingo_fx_prices(
    "eurusd",
    start_date = start,
    end_date = end,
    resample_frequency = "1min"
  )

  min_diff <- min(diff(as.numeric(x$date)))

  # 60 seconds
  expect_identical(min_diff, 60)
})
