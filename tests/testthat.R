library(testthat)
library(riingo)

on_cran <- function() {
  !identical(Sys.getenv("NOT_CRAN"), "true")
}

if (!on_cran()) {
  test_check("riingo")
}
