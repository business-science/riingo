#' Ticker information
#'
#' [is_supported_ticker()] can tell you if a given ticker is supported on Tiingo.
#' [supported_tickers()] returns a `tibble` listing every available ticker.
#'
#' @param ticker The single ticker to check for on Tiingo.
#'
#' @export
#'
#' @rdname ticker_info
#'
is_supported_ticker <- function(ticker) {
  assert_x_is_length(ticker, "ticker", 1L)
  assert_x_inherits(ticker, "ticker", "character")

  tickers <- supported_tickers()
  ticker %in% tickers$ticker
}

#' @rdname ticker_info
#' @export
supported_tickers <- function() {
  supported_ticker_url <- "https://apimedia.tiingo.com/docs/tiingo/daily/supported_tickers.zip"

  col_types <- readr::cols(ticker = "c", exchange = "c",
                           assetType = "c", priceCurrency = "c",
                           startDate = "T", endDate = "T")

  temp_file <- fs::file_temp(ext = ".zip")

  # Write zip to disk
  httr::GET(supported_ticker_url, httr::write_disk(temp_file))

  # Unzip and read
  tickers <- readr::read_csv(temp_file, col_types = col_types)

  unlink(temp_file)

  tickers
}
