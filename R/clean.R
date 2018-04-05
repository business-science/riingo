# Converts the basic data frame and type converts appropriate columns
# Useful for most enpoints, but notably not crypto
clean_json_df <- function(cont_df, type, endpoint) {

  cont_tbl <- tibble::as_tibble(cont_df)

  date_cols <- retrieve_date_col_names(type, endpoint)

  cont_tbl_conv <- purrr::modify_at(
    .x  = cont_tbl,
    .at = date_cols,
    .f  = ~as.POSIXct(.x, tz = "UTC", format = retrieve_date_col_format(endpoint))
  )

  cont_tbl_conv
}

# The known date columns that get returned
retrieve_date_col_names <- function(type, endpoint) {
  switch(endpoint,
         "meta"   = c("endDate", "startDate"),
         "quote"  = switch(type,
                           "iex"    = c("quoteTimestamp", "lastsaleTimeStamp", "timestamp"),
                           "crypto" = c("quoteTimestamp", "lastSaleTimestamp")),
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
