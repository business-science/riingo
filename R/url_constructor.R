construct_url <- function(type, endpoint, ticker, ...) {

  # Construct parameter string
  parameters <- as_http_parameter_string(..., type = type)

  # Full URL construction
  riingo_url <- construct_unglued_url(type, endpoint, parameters)

  # Splice in the ticker
  riingo_url_with_ticker <- glue::glue(riingo_url)

  riingo_url_with_ticker
}

construct_unglued_url <- function(type, endpoint, parameters) {
  base_url        <- retrieve_base_url(type, endpoint)
  endpoint_url    <- retrieve_endpoint(type, endpoint)

  paste0(base_url, endpoint_url, parameters)
}

retrieve_base_url <- function(type, endpoint) {
  switch(type,
         "tiingo" = switch(endpoint,
                           "news" = "https://api.tiingo.com/tiingo",
                           "https://api.tiingo.com/tiingo/daily/{ticker}"), # default
         "iex"    = "https://api.tiingo.com/iex/{ticker}",
         "crypto" = "https://api.tiingo.com/tiingo/crypto"
  )
}

retrieve_endpoint <- function(type, endpoint) {
  switch(type,

         "iex"    = switch(endpoint,
                           "quote"  = "",
                           "latest" = "/prices?",
                           "prices" = "/prices?"),

         "tiingo" = switch(endpoint,
                           "meta"   = "",
                           "latest" = "/prices",
                           "prices" = "/prices?",
                           "news"   = "/news?"),

         "crypto" = switch(endpoint,
                           "latest" = "/prices?",
                           "quote"  = "/top?",
                           "prices" = "/prices?",
                           "raw"    = "/prices?includeRawExchangeData=true&",
                           "meta"   = "/{ticker}"),
         )
}

# retrieve_endpoint_parameters <- function(type, endpoint) {
#
#   switch(type,
#
#          "iex"    = switch(endpoint,
#                            "quote"  = "",
#                            "latest" = "",
#                            "prices" = "{start_date}{end_date}{resample_frequency}"),
#
#          "tiingo" = switch(endpoint,
#                            "meta"   = "",
#                            "latest" = "",
#                            "prices" = "{start_date}{end_date}{resample_frequency}"),
#
#          "crypto" = switch(endpoint,
#                            "latest" = "{ticker}",
#                            "quote"  = "{ticker}",
#                            "prices" = "{ticker}{start_date}{end_date}{resample_frequency}{base_currency}{exchanges}{convert_currency}",
#                            "raw"    = "{ticker}{start_date}{end_date}{resample_frequency}{base_currency}{exchanges}{convert_currency}",
#                            "meta"   = "")
#   )
# }

# Turn a name value parameter pair into the real query parameter
as_http_parameter_string <- function(..., type) {

  params <- list(...)

  structure_as_http <- function(param, param_name, type) {
    if(is.null(param)) {
      param <- retrieve_default_parameter(param_name, type)
    }

    # Return "" so glue just ignores it
    if(is.na(param)) {
      return("")
    }

    param <- clean_logical_parameter(param)
    param <- clean_date_parameter(param)

    paste(param_name, param, sep = "=")
  }

  http_params <- purrr::imap_chr(params, ~structure_as_http(.x, .y, type))

  # Remove any params that were NULL and should use Tiingo defaults
  http_params <- http_params[which(http_params != "")]

  glue::glue_collapse(http_params, sep = "&", last = "")
}


# Defaults are set to attempt to retrieve 1 year's worth of data
retrieve_default_parameter <- function(param_name, type) {
  switch(param_name,
         "startDate"    = as.character(Sys.Date() - 365),
         "endDate"      = as.character(Sys.Date()),
         NA_character_ # default
        )
}

# Dates -> character
clean_date_parameter <- function(param) {

  if(inherits(param, "Date")) {
    param <- as.character(param)
  }

  if(inherits(param, "POSIXct")) {
    param <- format(param, "%Y-%m-%dT%H:%M:%S") # YYYY-mm-ddTHH:MM:SS (offset isn't accepted)
  }

  param
}

clean_logical_parameter <- function(param) {
  if (!is.logical(param)) {
    return(param)
  }

  if (rlang::is_true(param)) {
    "true"
  } else {
    "false"
  }
}
