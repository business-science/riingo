skeleton_downloader <- function(riingo_url, ticker, type) {
  riingo_headers <- retrieve_headers()

  resp <- httr::GET(riingo_url, riingo_headers)

  assert_valid_response(ticker, resp)

  cont <- httr::content(resp, as = "text", encoding = "UTF-8")

  assert_valid_content(ticker, cont)

  cont_tbl <- json_to_tibble(cont, type)

  cont_tbl
}

# ------------------------------------------------------------------------------
# Utilities

# Tiingo requires Authorization and Content-Type
retrieve_headers <- function() {
  token <- riingo_get_token()
  httr::add_headers(Authorization = paste("Token", token), `Content-Type` = "application/json")
}

retrieve_base_url <- function(type) {
  switch(type,
         "tiingo" = "https://api.tiingo.com/tiingo/daily/",
         "iex"    = "https://api.tiingo.com/iex/"
  )
}

# Turn a name value parameter pair into the real query parameter
as_parameter <- function(param, param_name) {

  if(is.null(param)) {
    param <- retrieve_default_parameter(param_name)
  }

  param <- clean_parameter(param)
  resp <- paste(param_name, param, sep = "=")
  resp <- paste0(resp, "&")

  resp
}

# Defaults are set to attempt to retrieve 1 year's worth of data
retrieve_default_parameter <- function(param_name) {
  switch(param_name,
         "startDate" = as.character(Sys.Date() - 365),
         "endDate" = as.character(Sys.Date()),
         "resampleFreq" = "daily"
  )
}

# Dates -> character
clean_parameter <- function(param) {

  if(inherits(param, "Date")) {
    param <- as.character(param)
  }

  if(inherits(param, "POSIXct")) {
    param <- format(param, "%Y-%m-%dT%H:%M:%S") # YYYY-mm-ddTHH:MM:SS (offset isn't accepted)
  }

  param
}

# Converts the JSON result to a tibble and type converts appropriate columns
json_to_tibble <- function(cont, type) {

  # For quotes, they aren't returned as JSON arrays and they should be
  if(type == "tiingo_price_quote_iex") {
    cont <- paste0("[", cont, "]")
  }

  cont_df <- jsonlite::fromJSON(cont)
  cont_tbl <- tibble::as_tibble(cont_df)
  cont_tbl_conv <- readr::type_convert(cont_tbl, col_types = retrieve_date_col_types(type))
  cont_tbl_conv
}

# The type conversions for the known date columns that get returned
retrieve_date_col_types <- function(type) {
  switch(type,
         "tiingo_prices"          = readr::cols(date = "T"),
         "tiingo_prices_iex"      = readr::cols(date = "T"),
         "tiingo_latest"          = readr::cols(date = "T"),
         "tiingo_latest_iex"      = readr::cols(date = "T"),
         "tiingo_meta"            = readr::cols(endDate = "T", startDate = "T"),
         "tiingo_price_quote_iex" = readr::cols(quoteTimestamp = "T", lastsaleTimeStamp = "T", timestamp = "T")
  )
}
