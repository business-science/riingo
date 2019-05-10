## Release Summary

This is the second release of riingo. It:
- Uses `glue::glue_collapse()` rather than `glue::collapse()` to avoid a warning.
- Updates JSON parsing to accomodate a change in the Tiingo API
- Adds handling of partial successes when downloading multiple tickers.

The maintainer changed because I updated my email.

## Test environments
* local OS X install, R 3.5.3
* ubuntu 14.04 (on travis-ci) (devel and release)
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes
