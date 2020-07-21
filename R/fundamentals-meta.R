#' Fundamentals - Meta
#'
#' This function can be used to get fundamentals meta data for individual
#' tickers, which includes information about when that ticker was last updated
#' with new fundamentals data, along with things such as the sector and
#' industry that that company belongs to.
#'
#' @param ticker One or more tickers to download meta information for.
#'
#' @return
#' A data frame with one row per ticker containing fundamentals meta data.
#'
#' @family fundamentals
#' @export
#'
#' @examples
#' \dontrun{
#' riingo_fundamentals_meta(c("AAPL", "MSFT"))
#' }
riingo_fundamentals_meta <- function(ticker) {
  assert_x_inherits(ticker, "ticker", "character")

  type <- "tiingo"
  endpoint <- "fundamentals-meta"

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
