context("test-latest.R")

test_that("latest riingo prices are pulled", {
  aapl <- riingo_prices("AAPL")
  expect_is(aapl, "tbl_df")
})
