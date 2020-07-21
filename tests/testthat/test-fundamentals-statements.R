test_that("can get fundamentals statements", {
  skip_if_no_token()

  x <- riingo_fundamentals_statements(c("AAPL", "MSFT"))

  cols <- c(
    "ticker", "quarter", "year", "date",
    "overview", "cashFlow", "incomeStatement", "balanceSheet"
  )

  expect_identical(all(cols %in% names(x)), TRUE)
  expect_identical(unique(x$ticker), c("AAPL", "MSFT"))
})
