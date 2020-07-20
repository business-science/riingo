# riingo (development version)

* All functions now retry their download 3 times before failing.

# riingo 0.2.0

* All functions are now robust against partial successes with multiple tickers, 
and will return any data that could be downloaded and warn about the tickers
that failed. If all tickers fail, an error is thrown (#6).

* A small change was made in `riingo_iex_quote()` to reflect the fact that the 
Tiingo API correctly returns JSON arrays now. 

* The deprecated `glue::collapse()` has been replaced 
with `glue::glue_collapse()` (#7).

# riingo 0.1.0

* First release
* Added a `NEWS.md` file to track changes to the package.
