test_that("can get fundamentals definitions", {
  skip_if_no_token()

  x <- riingo_fundamentals_definitions()

  cols <- c("dataCode", "name", "description", "statementType", "units")

  expect_identical(all(cols %in% names(x)), TRUE)
})
