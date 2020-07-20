# ------------------------------------------------------------------------------
# Tiingo meta

#' Get meta data about a ticker available on Tiingo
#'
#' Retrieve start and end dates for available ticker data, along with the name,
#' exchange, and description of the ticker.
#'
#' @inheritParams riingo_prices
#'
#' @examples
#'
#' \dontrun{
#'
#' riingo_meta("AAPL")
#'
#' riingo_meta("QQQ")
#'
#' }
#'
#' @export
riingo_meta <- function(ticker) {
  assert_x_inherits(ticker, "ticker", class = "character")

  results <- purrr::map(ticker, riingo_meta_single_safely)

  validate_not_all_null(results)

  vctrs::vec_rbind(!!!results)
}

riingo_meta_single_safely <- function(ticker) {
  riingo_single_safely(
    .f = riingo_meta_single,
    ticker = ticker
  )
}

riingo_meta_single <- function(ticker) {
  type <- "tiingo"
  endpoint <- "meta"

  # URL construction
  riingo_url <- construct_url(
    type, endpoint, ticker
  )

  # Download
  cont_df <- content_downloader(riingo_url, ticker)

  # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

  # Add ticker
  riingo_data$ticker <- NULL # to be consistent, don't use the provided meta ticker column
  riingo_data <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data
}

# ------------------------------------------------------------------------------
# Crypto meta


#' Get meta data about a cryptocurrency on Tiingo
#'
#' Relevant returned meta data include: ticker, name, description, quote currency,
#' and base currency.
#'
#' @inheritParams riingo_crypto_prices
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Bitcoin meta
#' riingo_crypto_meta("btcusd")
#'
#' # A trick to return ALL crypto meta data
#' # For some reason Descriptions are not returned here
#' riingo_crypto_meta("")
#'
#' }
#'
riingo_crypto_meta <- function(ticker) {
  assert_x_inherits(ticker, "ticker", class = "character")

  results <- purrr::map(ticker, riingo_crypto_meta_single_safely)

  validate_not_all_null(results)

  vctrs::vec_rbind(!!!results)
}

riingo_crypto_meta_single_safely <- function(ticker) {
  riingo_single_safely(
    .f = riingo_crypto_meta_single,
    ticker = ticker
  )
}

# Only one at a time
riingo_crypto_meta_single <- function(ticker) {

  type <- "crypto"
  endpoint <- "meta"

  # URL construction
  riingo_url <- construct_url(
    type, endpoint, ticker
  )

  # Download
  cont_df <- content_downloader(riingo_url, ticker)

  # Clean
  cont_tbl <- tibble::as_tibble(cont_df)

  cont_tbl
}
