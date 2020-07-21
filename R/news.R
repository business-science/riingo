#' Get news articles cultivated by Tiingo
#'
#' This function retrieves news articles filtered by tickers, tags, or sources.
#' It returns them as a data frame with one row per article. The original URL
#' to the article, its description, and a number of other features are
#' returned.
#'
#' @inheritParams riingo_prices
#'
#' @param tags A character vector of one word tags to filter with, such as
#'   `"Election"` or `"Australia"`.
#'
#' @param source A character vector of URLs corresponding to news sources to
#'   collect articles from (such as `"bloomberg.com"` or `"seekingalpha.com"`).
#'
#' @param limit The maximum number of articles to be retrieved.
#'   The default is 100, the maximum is 1000.
#'
#' @param offset A single integer representing the "pagination". This is
#'   generally used in combination with `limit` to retrieve more articles.
#'   For example, if `limit = 100`, you can request the first 100 articles. If
#'   `offset` is then set to `100`, you can request again to get the next 100
#'   articles.
#'
#' @details
#' Returns a data frame of news article descriptions, urls, sources, and more.
#'
#' @export
#' @examples
#' \dontrun{
#' riingo_news(ticker = "QQQ")
#'
#' # Filter by either source URL or tag
#' riingo_news(ticker = "QQQ", source = "bloomberg.com")
#' riingo_news(ticker = "QQQ", tags = "Earnings")
#'
#' # A ticker is not required
#' riingo_news(tags = "Earnings")
#' }
riingo_news <- function(ticker = NULL,
                        start_date = NULL,
                        end_date = NULL,
                        tags = NULL,
                        source = NULL,
                        limit = 100,
                        offset = 0) {
  type <- "tiingo"
  endpoint <- "news"

  # Assertions
  assert_x_inherits(ticker, "ticker", class = c("NULL", "character"))
  assert_x_inherits_one_of(start_date, "start_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits_one_of(end_date, "end_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits_one_of(tags, "tags", c("NULL", "character"))
  assert_x_inherits_one_of(source, "source", c("NULL", "character"))
  assert_x_inherits(limit, "limit", "numeric")
  assert_x_inherits(offset, "offset", "numeric")

  # Collapse vector of characters to single character
  if (!is.null(ticker)) {
    ticker <- glue::glue_collapse(ticker, ",")
  }

  if (!is.null(tags)) {
    tags <- glue::glue_collapse(tags, ",")
  }

  if (!is.null(source)) {
    source <- glue::glue_collapse(source, ",")
  }

  # Construct url
  riingo_url <- construct_url(
    type,
    endpoint,
    ticker = NULL,
    tickers = ticker,
    startDate = start_date,
    endDate = end_date,
    tags = tags,
    source = source,
    limit = limit,
    offset = offset
  )

  # Download
  cont_df <- content_downloader(riingo_url, ticker)

  # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

  riingo_data
}
