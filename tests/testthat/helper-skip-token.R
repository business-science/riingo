skip_if_no_token <- function() {
  if (identical(Sys.getenv("RIINGO_TOKEN"), "")) {
    testthat::skip("No authentication available")
  }
}
