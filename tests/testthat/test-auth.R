# ------------------------------------------------------------------------------
# riingo_get_token()

test_that("Error with no token", {
  withr::with_envvar(
    c(RIINGO_TOKEN = ""),
    expect_error(riingo_get_token(), "Please set")
  )
})

test_that("Can get the token from global option", {
  withr::with_envvar(
    c(RIINGO_TOKEN = ""),
    withr::with_options(
      list(riingo_token = "token"),
      expect_identical(riingo_get_token(), "token")
    )
  )
})

test_that("Can get the token from environment variable", {
  withr::with_envvar(
    c(RIINGO_TOKEN = "token"),
    expect_identical(riingo_get_token(), "token")
  )
})

test_that("Environment variable has prescedence", {
  withr::with_envvar(
    c(RIINGO_TOKEN = "token1"),
    withr::with_options(
      list(riingo_token = "token2"),
      expect_identical(riingo_get_token(), "token1")
    )
  )
})

# ------------------------------------------------------------------------------
# riingo_set_token()

test_that("Can set global option, with message", {
  # Will reset on exit for us
  local_options(riingo_token = "local")

  expect_message(riingo_set_token("token1"), "Token has been set")
  expect_silent(riingo_set_token("token2", inform = FALSE))

  withr::with_envvar(
    c(RIINGO_TOKEN = ""),
    expect_identical(riingo_get_token(), expected = "token2")
  )
})
