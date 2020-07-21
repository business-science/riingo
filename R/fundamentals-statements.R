#' Fundamentals - Statements
#'
#' @description
#' This function collects financial statement information for individual
#' tickers. Cash flow, income statement, and balance sheet information are
#' returned at the quarterly level, with an additional annual report attached
#' if available.
#'
#' In the returned data frame, `quarter == 0` represents an annual report for
#' the corresponding `year`.
#'
#' If `as_reported = FALSE`, an `overview` list column is also returned that
#' contains a combination of metrics from various statements.
#'
#' The returned data frame is in a very compact form containing _list columns_.
#' Each list column is made up of more data frames, where each data frame
#' represents that particular financial statement for that quarter. The
#' easiest way to get at the underlying data is to unnest the list columns
#' individually using `tidyr::unnest()`.
#'
#' @inheritParams riingo_prices
#'
#' @param ticker One or more tickers to download financial statements for.
#'
#' @param as_reported A single logical.
#'
#'   When `FALSE`, the most recent data will be returned, including any
#'   revisions for the reporting period. The dates will correspond to the
#'   fiscal end of the quarter or year (note that this can vary from company
#'   to company).
#'
#'   When `TRUE`, the endpoint will return the data as it was reported on the
#'   release date. Similarly, the date will correspond to the date the filings
#'   were posted on the SEC website.
#'
#' @return
#' A data frame containing the financial statement information for the
#' requested tickers.
#'
#' @family fundamentals
#' @export
#' @examples
#' \dontrun{
#' riingo_fundamentals_statements(c("AAPL", "MSFT"))
#'
#' riingo_fundamentals_statements(c("AAPL", "MSFT"), as_reported = TRUE)
#' }
riingo_fundamentals_statements <- function(ticker,
                                           start_date = NULL,
                                           end_date = NULL,
                                           as_reported = FALSE) {
  assert_x_inherits(ticker, "ticker", class = "character")
  assert_x_inherits_one_of(start_date, "start_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits_one_of(end_date, "end_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits(as_reported, "as_reported", "logical")

  results <- purrr::map(
    .x = ticker,
    .f = riingo_fundamentals_statements_single_safely,
    start_date = start_date,
    end_date = end_date,
    as_reported = as_reported
  )

  validate_not_all_null(results)

  vctrs::vec_rbind(!!!results)
}

riingo_fundamentals_statements_single_safely <- function(ticker,
                                                         start_date,
                                                         end_date,
                                                         as_reported) {
  riingo_single_safely(
    .f = riingo_fundamentals_statements_single,
    ticker = ticker,
    start_date = start_date,
    end_date = end_date,
    as_reported = as_reported
  )
}

riingo_fundamentals_statements_single <- function(ticker,
                                                  start_date,
                                                  end_date,
                                                  as_reported) {
  type <- "tiingo"
  endpoint <- "fundamentals-statements"

  # URL construction
  riingo_url <- construct_url(
    type,
    endpoint,
    ticker,
    startDate = start_date,
    endDate = end_date,
    asReported = as_reported
  )

  # Download
  cont_df <- content_downloader(riingo_url, ticker)

  # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

  # Reorder and unpack
  statements <- riingo_data[["statementData"]]
  riingo_data[["statementData"]] <- NULL

  riingo_data <- vctrs::vec_cbind(riingo_data, statements)

  # Add ticker
  riingo_data_with_ticker <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data_with_ticker
}
