# ------------------------------------------------------------------------------
# Reexports



# ------------------------------------------------------------------------------
# Pure imports

# Colors for error messages
# green = user entry, yellow = correct entry
#' @importFrom crayon green
#' @importFrom crayon yellow


# ------------------------------------------------------------------------------
# Error messages

glue_stop <- function(..., .sep = "") {
  msg <- glue::glue(..., .sep, .envir = parent.frame())
  stop(msg, call. = FALSE)
}
