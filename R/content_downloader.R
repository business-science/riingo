content_downloader <- function(riingo_url, ticker) {
  riingo_headers <- retrieve_headers()

  resp <- httr::GET(riingo_url, riingo_headers)

  assert_valid_response(ticker, resp)

  cont <- httr::content(resp, as = "text", encoding = "UTF-8")

  out <- jsonlite::fromJSON(cont)

  assert_valid_content(ticker, out)

  out
}

# ------------------------------------------------------------------------------
# Utilities

# Tiingo requires Authorization and Content-Type
retrieve_headers <- function() {
  token <- riingo_get_token()
  httr::add_headers(Authorization = paste("Token", token), `Content-Type` = "application/json")
}
