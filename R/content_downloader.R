content_downloader <- function(riingo_url, ticker) {
  riingo_headers <- retrieve_headers()

  # Handled by `assert_valid_response()`
  known_failure_status <- c(404, 400)

  resp <- httr::RETRY(
    verb = "GET",
    url = riingo_url,
    config = riingo_headers,
    times = 3,
    terminate_on = known_failure_status
  )

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
