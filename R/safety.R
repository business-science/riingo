# can't be .f because purrr::partial() uses that
riingo_single_safely <- function(.f, ticker, ...) {
  safe_single <- purrr::safely(.f, otherwise = NULL)
  safe_result <- safe_single(ticker, ...)

  # No issues!
  if (is.null(safe_result$error)) {
    return(safe_result$result)
  }

  msg <- glue::glue(
    "Download failure with {green(ticker)}, removing. See full message below:",
    "\n",
    "{italic(safe_result$error$message)}"
  )

  rlang::warn(msg)

  safe_result$result
}
