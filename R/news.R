# ------------------------------------------------------------------------------
# Tiingo News

#' Get Tiingo news feed for a single or series of tickers
#'
#'
#'
#' @param ticker One or more tickers to download data for from Tiingo. Can be a
#' stock, mutual fund, or ETF. A character vector.
#' @param start_date The first date to download data for.
#' A character in the form YYYY-MM-DD, or a `Date` variable.
#' @param end_date The last date to download data for.
#' A character in the form YYYY-MM-DD, or a `Date` variable.
#' @param tags Tags Requested. A character vector
#' @param source Requested news source URL.
#' @param limit The maximum number of articles to be retrieved. The default is 100, the maxiumum is 1,000
#' @param offset Pagination variable used alongside limit. Returns an array wih the results shifted by this parameter
#'
#' @details
#
#' @examples
#'
#' \dontrun{
#'
#' riingo_news("QQQ")
#'
#' }
#'
#' @export

riingo_news <- function(ticker, start_date = NULL, end_date = NULL, tags = NULL, source = NULL, limit = 100, offset = 0) {

   type <- "tiingo"
   endpoint <- "news"

# Assertions
   assert_x_inherits(ticker, "ticker", class = "character")
  assert_x_inherits_one_of(start_date, "start_date", c("NULL", "character", "Date", "POSIXct"))
   assert_x_inherits_one_of(end_date, "end_date", c("NULL", "character", "Date", "POSIXct"))
   assert_x_inherits_one_of(tags, "tags", c("NULL", "character"))
   assert_x_inherits_one_of(source, "source", c("NULL", "character"))
   assert_x_inherits(limit, "limit", "numeric")
   assert_x_inherits(offset, "offset", "numeric")

 # Collapse vector of characters to single character
   ticker <- glue::glue_collapse(ticker, ",")
   if(length(tags) > 1L)   tags   <- glue::glue_collapse(tags, ",")
   if(length(source) > 1L) source <- glue::glue_collapse(source, ",")

   # Construct url
  riingo_url <- construct_url(
     type, endpoint, ticker = NULL,
     tickers = ticker,
     startDate = start_date,
     endDate = end_date,
     tags = tags,
     source = source,
     limit = limit,
     offset = offset
   )

   # Download
   json_content <- content_downloader(riingo_url, ticker)

   # Parse
   cont_df <- jsonlite::fromJSON(json_content)

   # Clean
  riingo_data <- clean_json_df(cont_df, type, endpoint)

   riingo_data
}
