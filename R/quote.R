#' Quote and Top of Book data for a given ticker
#'
#' Tiingo is plugged into the IEX feed, and they provide last sale data along
#' with TOP (top of book) bid and ask quotes. Note that this cannot be historically
#' queried.
#'
#' @inheritParams riingo_prices
#'
#' @details
#'
#' At the end of the day, the `mid`, `askPrice`, `bidSize`, `bidPrice`, `askSize`,
#' and `lastSize` fields will be `NA`. This is normal.
#'
#' @examples
#'
#' riingo_quote_iex("QQQ")
#'
#' @export
riingo_quote_iex <- function(ticker) {
  assert_x_inherits(ticker, "ticker", class = "character")

  purrr::map_dfr(ticker, riingo_quote_iex_single)
}

riingo_quote_iex_single <- function(ticker) {
  base_url <- retrieve_base_url("iex")

  temp_url <- paste0(base_url, ticker) # Append tickers

  riingo_data <- skeleton_downloader(temp_url, ticker, "tiingo_price_quote_iex")

  riingo_data$ticker <- NULL # to be consistent, don't use the provided meta ticker column
  riingo_data <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data
}
