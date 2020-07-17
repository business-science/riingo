#' Set and get your Tiingo API token
#'
#' There are two methods for setting your token, an environment variable in your
#' `.Renviron` file, or setting an option. If both are set, the environment
#' variable will always be used. It is encouraged to use the environment
#' variable approach, as this will persist between R sessions.
#' See details for how to get started.
#'
#' @param token Tiingo API token. A character.
#'
#' @param inform A single logical. Should a message be displayed encouraging
#'   you to instead use an environment variable?
#'
#' @details
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
#' * Set the API token using the `RIINGO_TOKEN` environment variable in
#'   an `.Renviron` file. This is recommended. The easiest way to access
#'   this file is with `usethis::edit_r_environ()`. Add a line containing
#'   `RIINGO_TOKEN = <your-token-here>`. Do not put the token in quotes,
#'   and make sure to restart R once you have set it. After that, you shouldn't
#'   have to worry about it again.
#'
#' * Set the API token with [riingo_set_token()]. This is only valid for the
#'   current R session and must be done each time you open R.
#'
#' @rdname riingo_token
#' @export
riingo_set_token <- function(token, inform = TRUE) {
  if (!is_string(token)) {
    abort("`token` must be a single string.")
  }

  if (is_true(inform)) {
    msg <- glue(
      "Token has been set for this R session only. ",
      "It is recommended to instead set the `RIINGO_TOKEN` environment variable ",
      "in an `.Renviron` file using `usethis::edit_r_environ()`, ",
      "and then restart R."
    )

    inform(msg)
  }

  options(riingo_token = token)
}

#' @rdname riingo_token
#' @export
riingo_get_token <- function() {
  token <- get_env_var("RIINGO_TOKEN")

  if (!is.null(token)) {
    return(token)
  }

  token <- get_option("riingo_token")

  if (!is.null(token)) {
    return(token)
  }

  msg <- glue(
    "Please set the `RIINGO_TOKEN` environment variable in an `.Renviron` ",
    "file using `usethis::edit_r_environ()`, and then restart R. ",
    "Alternatively, set a once-per-session token using `riingo_set_token()`."
  )

  glue_stop(msg)
}


get_env_var <- function(x) {
  out <- Sys.getenv(x, unset = "")

  if (identical(out, "")) {
    NULL
  } else {
    out
  }
}

get_option <- function(x) {
  getOption(x, default = NULL)
}
