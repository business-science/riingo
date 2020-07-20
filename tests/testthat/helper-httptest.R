# Must library it so `get_current_redactor()` is found in
# the `httptest::start_capturing()` substitution code
library(httptest)

# - cache: Use cached requests in `testthat/tests/api.tiingo.com`
# - capture: Run the actual tests, capturing as you go
# - full: Run the actual tests, without any capturing
local_riingo_mock <- function(envir = parent.frame()) {
  type <- Sys.getenv("RIINGO_MOCK_TYPE", unset = "cache")

  local_mocker <- switch(type,
    cache = local_riingo_mock_cache,
    capture = local_riingo_mock_capture,
    none = local_riingo_mock_none,
    rlang::abort("`RIINGO_MOCK_TYPE` type is unknown.")
  )

  local_mocker(envir)
}

local_riingo_mock_cache <- function(envir) {
  httptest::use_mock_api()
  withr::defer(httptest::stop_mocking(), envir = envir)
}

local_riingo_mock_capture <- function(envir) {
  httptest::start_capturing()
  withr::defer(httptest::stop_capturing(), envir = envir)
}

local_riingo_mock_none <- function(envir) {
  # Runs the full test with no mocking
}
