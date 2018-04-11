skip_on_local <- function() {
  if(Sys.info()[["login"]] == "davisvaughan") {
    testthat::skip("On local")
  }
}

skip_if_no_auth <- function() {
  if (identical(Sys.getenv("RIINGO_TOKEN"), "")) {
    testthat::skip("No authentication available")
  }
}
