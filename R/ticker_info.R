#' Ticker information
#'
#' [is_supported_ticker()] can tell you if a given ticker is supported on Tiingo.
#' [supported_tickers()] returns a `tibble` listing every available ticker.
#'
#' @param ticker The single ticker to check for on Tiingo.
#' @param iex Boolean representing whether to check for the symbol on Tiingo or IEX.
#'
#' @examples
#'
#' # VOO is supported on both Tiingo and IEX
#' \dontrun{
#' is_supported_ticker("VOO")
#' is_supported_ticker("VOO", iex = TRUE)
#' }
#'
#'
#' # PRHSX is a mutual fund that is supported by Tiingo but not IEX
#' \dontrun{
#' is_supported_ticker("PRHSX")
#' is_supported_ticker("PRHSX", iex = TRUE)
#' }
#'
#' @export
#'
#' @rdname ticker_info
#'
is_supported_ticker <- function(ticker, iex = FALSE) {
  assert_x_is_length(ticker, "ticker", 1L)
  assert_x_inherits(ticker, "ticker", "character")

  tickers <- supported_tickers(iex)

  if(iex) {
    ticker_col <- "Symbol"
  } else {
    ticker_col <- "ticker"
  }

  ticker %in% tickers[[ticker_col]]
}

#' @rdname ticker_info
#' @export
supported_tickers <- function(iex = FALSE) {

  if(iex) {

    resp <- httr::GET("https://iextrading.com/api/mobile/refdata")
    cont <- httr::content(resp, as = "text")
    tickers <- jsonlite::fromJSON(cont)

  } else {

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

  }

  tickers
}
