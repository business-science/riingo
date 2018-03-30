# ------------------------------------------------------------------------------
# Assertions

assert_x_is_length <- function(x, x_name, length) {
  l <- length(x)
  is_correct_length <- l == length
  if(!is_correct_length) {
    glue_stop("{x_name} must be length {yellow('1')}, but is actually length {green(l)}.")
  }
}

assert_x_inherits <- function(x, x_name, class) {
  has_class <- inherits(x, class)
  if(!has_class) {
    classes <- glue::collapse(green(class(x)), ", ")
    correct_class <- yellow(class)
    glue_stop("{x_name} must be {correct_class}. You have passed in a: {classes}")
  }
}

assert_x_inherits_one_of <- function(x, x_name, classes) {
  has_one_of_classes <- any(class(x) %in% classes)
  if(!has_one_of_classes) {
    x_classes <- glue::collapse(green(class(x)), ", ")
    correct_classes <- glue::collapse(yellow(classes), ", or ")
    glue_stop("{x_name} must be {correct_classes}. You have passed in a: {x_classes}")
  }
}

assert_valid_response <- function(ticker, resp) {
  status <- resp$status_code

  if(status == 404) {
    server_error <- httr::content(resp) # only get the content() if there was a problem
    msg <- paste0("The ticker name, {green(ticker)}, is invalid or data is currently not available. ",
                  "Check ticker validity with {yellow('is_supported_ticker()')}`.")
    msg_tiingo <- paste0("Tiingo msg) ", server_error)
    glue_stop(msg, "\n", msg_tiingo)
  }

  if(status == 400) {
    server_error <- httr::content(resp)
    msg <- paste0("The {green('resample_frequency')} specified is not allowed.")
    msg_tiingo <- paste0("Tiingo msg) ", server_error)
    glue_stop(msg, "\n", msg_tiingo)
  }
}

assert_valid_content <- function(ticker, cont) {
  if(cont == "[]") {
    glue_stop("No error was thrown by Tiingo for {green(ticker)}, but no content was returned. \n",
              "Are you sure this is a valid ticker? Check this with {yellow('is_supported_ticker()')}. \n",
              "Alternatively, you might be outside the valid date range.")
  }
}

# Check all of the arguments at once
assert_valid_argument_inheritance <- function(ticker, start_date, end_date, resample_frequency) {
  assert_x_inherits(ticker, "ticker", class = "character")
  assert_x_inherits_one_of(start_date, "start_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits_one_of(end_date, "end_date", c("NULL", "character", "Date", "POSIXct"))
  assert_x_inherits(resample_frequency, "resample_frequency", "character")
}

assert_resample_freq_is_granular <- function(resample_frequency) {
  valid_freq <- c("daily", "monthly", "quarterly", "yearly")

  is_valid_freq <- resample_frequency %in% valid_freq
  if(!is_valid_freq) {
    user_freq <- green(resample_frequency)
    correct_freq <- glue::collapse(yellow(valid_freq), ", ", last = ", or ")
    glue_stop("resample_frequency must be {correct_freq}. You have passed in: {user_freq}")
  }
}

assert_resample_freq_is_fine <- function(resample_frequency) {
  valid_base <- c("min", "hour")
  has_valid_base <- any(purrr::map_lgl(valid_base, ~grepl(.x, resample_frequency)))

  if(!has_valid_base) {
    user_freq <- green(resample_frequency)
    correct_base <- glue::collapse(yellow(valid_base), ", or ")
    correct_freq <- glue::collapse(yellow(c("1min", "5min", "1hour")), ", ", last = ", or ")
    glue_stop("resample_frequency is only valid for {correct_base}, and must be formatted similar to {correct_freq}. ",
              "You have passed in: {user_freq}.")
  }
}
