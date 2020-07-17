# ------------------------------------------------------------------------------
# Reexports



# ------------------------------------------------------------------------------
# Pure imports

# Colors for error messages
# green = user entry, yellow = correct entry
#' @importFrom crayon green
#' @importFrom crayon yellow
#' @importFrom crayon italic


# ------------------------------------------------------------------------------
# Error messages

glue_stop <- function(..., .sep = "", .envir = parent.frame()) {
  msg <- glue::glue(..., .sep, .envir = .envir)
  abort(msg)
}

validate_not_all_null <- function(x) {
  all_null <- all(purrr::map_lgl(x, is.null))

  if (all_null) {
    glue_stop("All tickers failed to download any data. Aborting.")
  }

  invisible(x)
}
