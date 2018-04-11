context("test-test_auth.R")

test_that("Auth token can be set by options", {
  skip_on_local() # my auth token is set in the environment
  options(riingo_token = "token")
  on.exit( {options("riingo_token" = NULL)} )

  expect_equal(riingo_get_token(), "token")
})
