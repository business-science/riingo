# riingo 0.3.1

* `riingo_iex_latest()` now also returns a `volume` column, like
  `riingo_iex_prices()` (#18).

# riingo 0.3.0

* New `riingo_fx_quote()` for collecting current top-of-book data for forex
  exchange rates. This is an early beta feature, so the returned columns may
  change over time. It is not recommended to build production code using this
  function.

* New `riingo_fx_prices()` for collecting forex exchange rates. This is an
  early beta feature, so the returned columns may change over time. It is
  not recommended to build production code using this function.

* New `riingo_news()` for collecting information about news articles related
  to a ticker, news source, or topic (With contributions by @amiles2233, #11).

* There are four new functions for retrieving fundamental statement data from
  the new Fundamentals Tiingo endpoint (#13). This is an add on subscription for
  Tiingo that is in beta, and is only available with a paid plan. The four
  functions are:
  
  * `riingo_fundamentals_statements()` for retrieving quarterly data from
    income statements, balance sheets, and cash flow statements.
    
  * `riingo_fundamentals_meta()` for retrieving fundamentals meta data about
    a particular ticker.
    
  * `riingo_fundamentals_metrics()` for retrieving daily fundamentals metrics
    such as market capitalization and P/E ratio.
    
  * `riingo_fundamentals_definitions()` for retrieving descriptions of the
    various metrics that can be returned by the other fundamentals utilities.

* `riingo_iex_prices()` now returns a `volume` column (#12).

* `riingo_iex_prices()` gained two new arguments. `after_hours` returns pre
  and post market data if any is available. `force_fill` will use the most
  recent OHLC data for the current time point if none is available.

* The `resample_frequency` argument of `riingo_prices()` now correctly supports
  the weekly and annual frequencies.

* All functions now retry their download 3 times before failing.

* The dplyr dependency has been removed.

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
