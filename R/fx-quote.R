#' Quote and Top of Book data for a given forex ticker
#'
#' This function queries the top of book data for the provided forex tickers.
#'
#' @inheritParams riingo_prices
#'
#' @return
#' A data frame containing 1 row per valid ticker with the top of book data.
#'
#' @examples
#'
#' \dontrun{
#' riingo_fx_quote(c("audusd", "usdjpy"))
#' }
#'
#' @export
riingo_fx_quote <- function(ticker) {
  assert_x_inherits(ticker, "ticker", "character")

  type <- "tiingo"
  endpoint <- "fx-quote"

  ticker <- glue::glue_collapse(ticker, ",")

  # URL construction
  riingo_url <- construct_url(
    type,
    endpoint,
    ticker = NULL,
    tickers = ticker
  )

  # Download
  cont_df <- content_downloader(riingo_url, ticker)

  # Clean
  cont_tbl <- clean_json_df(cont_df, type, endpoint)

  cont_tbl
}
