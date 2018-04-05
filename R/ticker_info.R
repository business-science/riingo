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

    temp_file <- tempfile(fileext = ".zip")

    # Write zip to disk
    httr::GET(supported_ticker_url, httr::write_disk(temp_file))

    # Unzip and read
    dir_path <- dirname(temp_file)

    unzip(temp_file, exdir = dir_path)
    ticker_path <- paste0(dir_path, "/supported_tickers.csv")

    tickers <- tibble::as_tibble(read.csv(ticker_path, stringsAsFactors = FALSE))

    # Date
    tickers <- purrr::modify_at(
      .x = tickers,
      .at = c("startDate", "endDate"),
      .f = ~as.POSIXct(.x, tz = "UTC", format = "%Y-%m-%d")
    )

    unlink(temp_file)
    unlink(ticker_path)

  }

  tickers
}
