# Construct the URL and handoff to downloader
validate_and_download <- function(ticker, type, endpoint, start_date = NA, end_date = NA, resample_frequency = NA) {
  start_date         <- as_parameter(start_date, "startDate", type)
  end_date           <- as_parameter(end_date, "endDate", type)
  resample_frequency <- as_parameter(resample_frequency, "resampleFreq", type)

  riingo_url <- glue::glue(construct_url(type, endpoint))

  riingo_data <- skeleton_downloader(riingo_url, ticker, type, endpoint)
}

# Download and clean
skeleton_downloader <- function(riingo_url, ticker, type, endpoint) {
  riingo_headers <- retrieve_headers()

  resp <- httr::GET(riingo_url, riingo_headers)

  assert_valid_response(ticker, resp)

  cont <- httr::content(resp, as = "text", encoding = "UTF-8")

  assert_valid_content(ticker, cont)

  cont_tbl <- json_to_tibble(cont, type, endpoint)

  cont_tbl
}

# ------------------------------------------------------------------------------
# Utilities

# Tiingo requires Authorization and Content-Type
retrieve_headers <- function() {
  token <- riingo_get_token()
  httr::add_headers(Authorization = paste("Token", token), `Content-Type` = "application/json")
}

# Converts the JSON result to a tibble and type converts appropriate columns
json_to_tibble <- function(cont, type, endpoint) {

  # For quotes, they aren't returned as JSON arrays and they should be
  if(type == "iex" && endpoint == "quote") {
    cont <- paste0("[", cont, "]")
  }

  cont_df <- jsonlite::fromJSON(cont)
  cont_tbl <- tibble::as_tibble(cont_df)

  date_cols <- retrieve_date_col_names(endpoint)

  cont_tbl_conv <- purrr::modify_at(
    .x  = cont_tbl,
    .at = date_cols,
    .f  = ~as.POSIXct(.x, tz = "UTC", format = retrieve_date_col_format(endpoint))
  )

  cont_tbl_conv
}

# The known date columns that get returned
retrieve_date_col_names <- function(endpoint) {
  switch(endpoint,
         "meta"   = c("endDate", "startDate"),
         "quote"  = c("quoteTimestamp", "lastsaleTimeStamp", "timestamp"),
         "latest" = "date",
         "prices" = "date"
  )
}

# The known date column formats
retrieve_date_col_format <- function(endpoint) {
  switch(endpoint,
        "meta"   = "%Y-%m-%d",
        "quote"  = "%Y-%m-%dT%H:%M:%S",
        "latest" = "%Y-%m-%dT%H:%M:%S",
        "prices" = "%Y-%m-%dT%H:%M:%S"
  )
}
