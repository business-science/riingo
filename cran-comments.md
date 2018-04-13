## Resubmission

- I have written 'Tiingo' in single quotes in the Description title and description.
- I have added a URL for the Tiingo API in the Description
- Based on discussion with Swetlana and Uwe, I have not changed \dontrun{}
to \donttest{}. See below:

"Thanks! Everything wrapped in \dontrun{} requires API authentication (a
token set as an environment variable). I heard that if I wrap them in
\donttest{}, CRAN will run them later anyways? They will fail if that is
the case. *Should I still do so?*"

## Release Summary
This is the first release of riingo. riingo provides an R interface to the 
Tiingo API for stock prices and cryptocurrency data.

## Test environments
* local OS X install, R 3.4.3
* ubuntu 14.04 (on travis-ci), R 3.4.3
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a new release.
