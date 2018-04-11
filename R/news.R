# riingo_news <- function(ticker, start_date = NULL, end_date = NULL, tags = NULL, source = NULL, limit = 100, offset = 0) {
#
#   type <- "tiingo"
#   endpoint <- "news"
#
#   # Assertions
#   assert_x_inherits(ticker, "ticker", class = "character")
#   assert_x_inherits_one_of(start_date, "start_date", c("NULL", "character", "Date", "POSIXct"))
#   assert_x_inherits_one_of(end_date, "end_date", c("NULL", "character", "Date", "POSIXct"))
#   assert_x_inherits_one_of(tags, "tags", c("NULL", "character"))
#   assert_x_inherits_one_of(source, "source", c("NULL", "character"))
#   assert_x_inherits(limit, "limit", "numeric")
#   assert_x_inherits(offset, "offset", "numeric")
#
#   # Collapse vector of characters to single character
#   ticker <- glue::collapse(ticker, ",")
#   if(length(tags) > 1L)   tags   <- glue::collapse(tags, ",")
#   if(length(source) > 1L) source <- glue::collapse(source, ",")
#
#   # Construct url
#   riingo_url <- construct_url(
#     type, endpoint, ticker = NULL,
#     tickers = ticker,
#     startDate = start_date,
#     endDate = end_date,
#     tags = tags,
#     source = source,
#     limit = limit,
#     offset = offset
#   )
#
#   # Download
#   json_content <- content_downloader(riingo_url, ticker)
#
#   # Parse
#   cont_df <- jsonlite::fromJSON(json_content)
#
#   # Clean
#   riingo_data <- clean_json_df(cont_df, type, endpoint)
#
#   riingo_data
# }
