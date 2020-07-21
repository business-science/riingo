test_that("can get news for a ticker", {
  skip_if_no_token()

  x <- riingo_news("AAPL")

  cols <- c(
    "tags", "id", "tickers", "url", "description",
    "publishedDate", "source", "title", "crawlDate"
  )

  expect_true(all(cols %in% names(x)))
})

test_that("limit works", {
  skip_if_no_token()

  x <- riingo_news("AAPL", limit = 1)

  expect_identical(nrow(x), 1L)
})

test_that("can get news without any inputs", {
  skip_if_no_token()

  x <- riingo_news(limit = 1)

  expect_identical(nrow(x), 1L)
})

test_that("can get news without ticker", {
  skip_if_no_token()

  x <- riingo_news(source = "bloomberg.com", limit = 1)

  expect_identical(nrow(x), 1L)
})
