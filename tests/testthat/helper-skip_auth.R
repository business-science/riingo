skip_if_no_auth <- function() {
  if (identical(Sys.getenv("RIINGO_TOKEN"), "")) {
    testthat::skip("No authentication available")
  }
}
