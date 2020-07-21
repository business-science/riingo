#' Fundamentals - Definitions
#'
#' This function can be used to check which fields are available from the
#' fundamentals endpoint. As Tiingo adds more indicators, the output of this
#' function may change to reflect the addition of new indicators.
#'
#' @return
#' A data frame with columns describing the various data codes that
#' will be returned by [riingo_fundamentals_statements()].
#'
#' @family fundamentals
#' @export
#'
#' @examples
#' \dontrun{
#' riingo_fundamentals_definitions()
#' }
riingo_fundamentals_definitions <- function() {
  type <- "tiingo"
  endpoint <- "fundamentals-definitions"

  # In theory, the docs say there is a `tickers` argument to query only
  # definitions for specific tickers, but this doesn't seem to do anything
  # so instead we just get all of the possible data codes
  # (there aren't that many)
  ticker <- NULL

  # URL construction
  riingo_url <- construct_url(
    type,
    endpoint,
    ticker = ticker
  )

  # Download
  cont_df <- content_downloader(riingo_url, ticker = "")

  # Clean
  cont_tbl <- tibble::as_tibble(cont_df)

  cont_tbl
}
