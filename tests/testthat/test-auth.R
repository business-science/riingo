context("test-test_auth.R")

test_that("Auth token can be retrieved", {
  skip_if_no_auth() # my auth token is set in the environment
  token <- riingo_get_token()
  expect_equal(class(token), "character") # Prevent showing token in log
})
