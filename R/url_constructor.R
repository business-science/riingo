

construct_url <- function(type, endpoint) {
  base_url <- retrieve_base_url(type)
  endpoint_params <- retrieve_endpoint_parameters(endpoint)
  paste0(base_url, endpoint_params)
}

retrieve_base_url <- function(type) {
  switch(type,
         "tiingo" = "https://api.tiingo.com/tiingo/daily/{ticker}",
         "iex"    = "https://api.tiingo.com/iex/{ticker}"
  )
}

retrieve_endpoint_parameters <- function(endpoint) {
  switch(endpoint,
         "meta"   = "",
         "quote"  = "",
         "latest" = "/prices?{resample_frequency}",
         "prices" = "/prices?{start_date}{end_date}{resample_frequency}")
}

# Turn a name value parameter pair into the real query parameter
as_parameter <- function(param, param_name, type) {

  if(is.null(param)) {
    param <- retrieve_default_parameter(param_name, type)
  }

  # Return "" so glue just ignores it
  if(is.na(param)) {
    return("")
  }

  param <- clean_parameter(param)
  resp <- paste(param_name, param, sep = "=")
  resp <- paste0(resp, "&")

  resp
}

# Defaults are set to attempt to retrieve 1 year's worth of data
retrieve_default_parameter <- function(param_name, type) {
  switch(param_name,
         "startDate"    = as.character(Sys.Date() - 365),
         "endDate"      = as.character(Sys.Date()),
         "resampleFreq" = switch(type, "iex" = "5min", "tiingo" = "daily"))
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
