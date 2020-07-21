#' Fundamentals - Metrics
#'
#' @description
#' This function collects daily financial metrics for the specificed tickers.
#' These might include market capitalization, P/E ratios, and more.
#'
#' @inheritParams riingo_prices
#'
#' @param ticker One or more tickers to download financial metrics for.
#'
#' @return
#' A data frame containing the financial metrics for the requested tickers.
#'
#' @family fundamentals
#' @export
#' @examples
#' \dontrun{
#' riingo_fundamentals_metrics(c("AAPL", "MSFT"), start_date = "2020-01-01")
#' }
riingo_fundamentals_metrics <- function(ticker,
                                        start_date = NULL,
                                        end_date = NULL) {
  assert_x_inherits(ticker, "ticker", class = "character")
  assert_x_inherits_one_of(start_date, "start_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits_one_of(end_date, "end_date", c("NULL", "character", "Date", "POSIXct"))

  results <- purrr::map(
    .x = ticker,
    .f = riingo_fundamentals_metrics_single_safely,
    start_date = start_date,
    end_date = end_date
  )

  validate_not_all_null(results)

  vctrs::vec_rbind(!!!results)
}

riingo_fundamentals_metrics_single_safely <- function(ticker,
                                                      start_date,
                                                      end_date) {
  riingo_single_safely(
    .f = riingo_fundamentals_metrics_single,
    ticker = ticker,
    start_date = start_date,
    end_date = end_date
  )
}

riingo_fundamentals_metrics_single <- function(ticker,
                                               start_date,
                                               end_date) {
  type <- "tiingo"
  endpoint <- "fundamentals-metrics"

  # URL construction
  riingo_url <- construct_url(
    type,
    endpoint,
    ticker,
    startDate = start_date,
    endDate = end_date
  )

  # Download
  cont_df <- content_downloader(riingo_url, ticker)

  # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

  # Add ticker
  riingo_data_with_ticker <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data_with_ticker
}
