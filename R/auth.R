#' Set and get your Tiingo API token
#'
#' There are two methods for setting your token, an environment variable in your
#' `.Renviron` file, or setting an option. If both are set, the environment
#' variable will always be used. See details for how to get started.
#'
#' @param token Tiingo API token. A character.
#'
#' @details
#'
#' To use the Tiingo API, you must create an account and set an API token.
#' It is completely free to get started and use their free source of data.
#'
#' To sign up, use [riingo_browse_signup()] and click Sign-up.
#'
#' To find your API token, use [riingo_browse_token()]. Note that you must be
#' signed in on the opened browser.
#'
#' With your API token in hand, you can do one of two things:
#'
#' * Set the API token with [riingo_set_token()]. This is only valid for the
#' current R session and must be done each time you open R.
#'
#' * Set the API token as the `RIINGO_TOKEN` environment variable in an `.Renviron` file.
#' This is what I recommend. The easiest way to access this file is with the `usethis` package.
#' Open it with `usethis::edit_r_environ()` and then add a line with `RIINGO_TOKEN = token_here`.
#' Do not put the token in quotes, and make sure to restart R once you have set it.
#' After that, you shouldn't have to worry about it again.
#'
#'
#' @rdname riingo_token
#' @export
#'
riingo_set_token <- function(token) {
  options(riingo_token = token)
}

#' @rdname riingo_token
#' @export
riingo_get_token <- function() {
  token <- Sys.getenv("RIINGO_TOKEN")

  if(token == "") {
    token <- getOption("riingo_token")
    if(is.null(token)) token <- ""
  }

  if(token == "") {
    stop("Please set a token using riingo_set_token() or by setting the variable RIINGO_TOKEN in a .Renviron file and then restarting R.")
  }

  token
}
