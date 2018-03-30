
#' Browse various pages of the Tiingo site
#'
#' Note that you __must__ be signed into the site on the opened browser
#' for most of these functions to work properly, otherwise you will redirected
#' to the sign in page.
#'
#' @rdname riingo_browse
#' @export
#'
riingo_browse_usage <- function() {
  browseURL("https://api.tiingo.com/account/usage")
}

#' @rdname riingo_browse
#' @export
riingo_browse_token <- function() {
  browseURL("https://api.tiingo.com/account/token")
}

#' @rdname riingo_browse
#' @export
riingo_browse_documentation <- function() {
  browseURL("https://api.tiingo.com/docs/general/overview")
}

#' @rdname riingo_browse
#' @export
riingo_browse_signup <- function() {
  browseURL("https://api.tiingo.com/")
}
