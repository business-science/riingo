#' Get meta data about a ticker available on Tiingo
#'
#' Retrieve start and end dates for available ticker data, along with the name,
#' exchange, and description of the ticker.
#'
#' @inheritParams riingo_prices
#'
#' @examples
#'
#' riingo_meta("AAPL")
#'
#' riingo_meta("QQQ")
#'
#' @export
riingo_meta <- function(ticker) {
  assert_x_inherits(ticker, "ticker", class = "character")

  purrr::map_dfr(ticker, riingo_meta_single)
}

riingo_meta_single <- function(ticker) {
  riingo_data <- validate_and_download(ticker, "tiingo", "meta")

  riingo_data$ticker <- NULL # to be consistent, don't use the provided meta ticker column
  riingo_data <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data
}
