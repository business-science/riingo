# ------------------------------------------------------------------------------
# IEX quote

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
#' \dontrun{
#'
#' riingo_iex_quote("QQQ")
#'
#' }
#'
#' @export
riingo_iex_quote <- function(ticker) {
  assert_x_inherits(ticker, "ticker", class = "character")

  results <- purrr::map(ticker, riingo_iex_quote_single_safely)

  validate_not_all_null(results)

  dplyr::bind_rows(results)
}

riingo_iex_quote_single_safely <- function(ticker) {
  riingo_single_safely(
    .f = riingo_iex_quote_single,
    ticker = ticker
  )
}

riingo_iex_quote_single <- function(ticker) {

  type <- "iex"
  endpoint <- "quote"

  # URL construction
  riingo_url <- construct_url(
    type, endpoint, ticker
  )

  # Download
  json_content <- content_downloader(riingo_url, ticker)

  # Parse
  cont_df <- jsonlite::fromJSON(json_content)

  # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

  # Add ticker
  riingo_data$ticker <- NULL # to be consistent, don't use the provided meta ticker column
  riingo_data <- tibble::add_column(riingo_data, ticker = ticker, .before = 1L)

  riingo_data
}

# ------------------------------------------------------------------------------
# Crypto quote

#' Quote and Top of Book data for a given cryptocurrency
#'
#' Tiingo provides TOP (top of book) bid and ask quotes for cryptocurrencies.
#' Note that this cannot be historically queried.
#'
#' @inheritParams riingo_crypto_prices
#'
#' @details
#'
#' At the end of the day, the, `askPrice`, `bidSize`, `bidPrice`, `askSize`,
#' and `lastSize` fields may be `NA`. This is normal.
#'
#' @examples
#'
#' \dontrun{
#'
#' riingo_crypto_quote("btcusd")
#'
#' # The raw data can provide more insight into each individual exchange
#' riingo_crypto_quote("btcusd", raw = TRUE)
#'
#' }
#'
#' @export
riingo_crypto_quote <- function(ticker, exchanges = NULL, convert_currency = NULL, raw = FALSE) {

  # Assertions
  assert_x_inherits(ticker, "ticker", class = "character")
  assert_x_inherits_one_of(exchanges, "exchanges", c("NULL", "character"))
  assert_x_inherits_one_of(convert_currency, "convert_currency", c("NULL", "character"))

  type <- "crypto"
  endpoint <- "quote"

  # For crypto, tickers are passed as a comma separated parameter
  ticker <- glue::glue_collapse(ticker, ",")

  # URL construction
  riingo_url <- construct_url(
    type, endpoint, ticker = NULL,
    tickers = ticker,
    exchanges = exchanges,
    convertCurrency = convert_currency
  )

  if(raw) {

    riingo_url <- glue::glue(riingo_url, "&includeRawExchangeData=true")

    # Download
    json_content <- content_downloader(riingo_url, ticker)

    # Parse
    cont_df <- jsonlite::fromJSON(json_content)

    # We are only going to return exchange data, ignore price data
    exch_data_idx <- which(colnames(cont_df) == "exchangeData")
    top_idx <- which(colnames(cont_df) == "topOfBookData")

    # Meta data section
    meta <- tibble::as_tibble(cont_df[, -c(exch_data_idx, top_idx)])
    meta_rows <- split(meta, meta$ticker)

    # The actual raw data
    exch_data <- cont_df[, exch_data_idx]

    seq_ticker <- seq_along(meta$ticker)

    # Extract "nested" data frames
    exch_data_rows <- purrr::map(seq_ticker, ~{
      i <- .x
      tibble::as_tibble(purrr::map_dfr(exch_data, ~.x[[i]]))
    })

    # Bind each row of meta to an exchange data frame
    riingo_df <- purrr::map2_dfr(meta_rows, exch_data_rows, ~cbind(.x, .y))

  } else {

    # Download
    json_content <- content_downloader(riingo_url, ticker)

    # Parse
    cont_df <- jsonlite::fromJSON(json_content)

    # Have to convert to tibble here, otherwise warnings in the map
    cont_tbl <- tibble::as_tibble(cont_df)

    # Coerce to tidy format (for each row, unnest the priceData)
    cont_tbl_split <- split(cont_tbl, cont_tbl$ticker)

    riingo_df <- purrr::map_dfr(cont_tbl_split, ~{
      top_idx <- which(colnames(.x) == "topOfBookData")
      meta <- .x[, -top_idx]
      pd   <- purrr::flatten_dfr(.x[, top_idx])
      cbind(meta, pd)
    })
  }

  # cbind() returned as df
  riingo_tbl <- tibble::as_tibble(riingo_df)

  # type convert date columns (for some reason these are non standard names)
  date_cols <- c("quoteTimestampStr", "lastSaleTimestampStr")

  riingo_data <- purrr::modify_at(
    .x  = riingo_tbl,
    .at = date_cols,
    .f  = ~as.POSIXct(.x, tz = "UTC", format = retrieve_date_col_format(endpoint))
  )

  riingo_data
}
