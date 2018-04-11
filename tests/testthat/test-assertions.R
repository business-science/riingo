context("test-assertions.R")

test_that("assert_valid_argument_inheritance() catches malformed args", {

  expect_error(
    riingo_prices("AAPL", start_date = "2017-01-01",
                  end_date = "2017-03-31", resample_frequency = "1min"),
    "resample_frequency must be"
  )

  expect_error(
    riingo_prices("AAPL", start_date = 1,
                  end_date = "2017-03-31", resample_frequency = "daily"),
    "start_date must be"
  )

  expect_error(
    riingo_prices("AAPL", start_date = "2017-01-01",
                  end_date = 1, resample_frequency = "daily"),
    "end_date must be"
  )

  expect_error(
    riingo_prices(1, start_date = "2017-01-01",
                  end_date = "2017-03-31", resample_frequency = "daily"),
    "ticker must be"
  )
})


test_that("assert_resample_freq_is_crypto() catches malformed resample freq", {
  expect_error(
    assert_resample_freq_is_crypto("daily"),
    "resample_frequency is only valid"
  )
})

test_that("assert_resample_freq_is_granular() catches 'fine' resample freq", {
  expect_error(
    assert_resample_freq_is_granular("1min"),
    "resample_frequency must be"
  )
})

test_that("assert_resample_freq_is_fine() catches 'granular' resample freq", {
  expect_error(
    assert_resample_freq_is_fine("daily"),
    "resample_frequency is only valid"
  )
})

test_that("invalid time zones are caught", {
  expect_error(assert_valid_tz("as"), "Supplied time zone")
})
