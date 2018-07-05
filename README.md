
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis build
status](https://travis-ci.org/business-science/riingo.svg?branch=master)](https://travis-ci.org/business-science/riingo)
[![Coverage
status](https://codecov.io/gh/business-science/riingo/branch/master/graph/badge.svg)](https://codecov.io/github/business-science/riingo?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/riingo)](https://cran.r-project.org/package=riingo)

# riingo

`riingo` allows you to access the Tiingo API for stock prices,
cryptocurrencies, and intraday feeds from the IEX (Investors Exchange).
This can serve as an alternate source of data to Yahoo Finance.

## Installation

Install the stable version from [CRAN](https://cran.r-project.org/)
with:

``` r
install.packages("riingo")
```

Install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("DavisVaughan/riingo")
```

## API Token

The first thing you must do is create an account and set an API token. I
recommend using the two functions below to help create your account and
find the token.

``` r
riingo_browse_signup()
riingo_browse_token() # This requires that you are signed in on the site once you sign up
```

Once you have signed up and have an API token, I recommmend setting the
token as an environment variable, `RIINGO_TOKEN` in an `.Renviron` file.
The easiest way to do this is with `usethis`.

``` r
usethis::edit_r_environ()

# Then add a line in the environment file that looks like:
RIINGO_TOKEN = token_here
```

Do not put the token in quotes, and restart R after you have set it.

See the documentation `?riingo_get_token()` for more information.

# Basic example

``` r
library(riingo)
```

Let’s grab some data with `riingo`. The default parameters attempt to
get 1 year’s worth of data.

``` r
riingo_prices("AAPL")
#> # A tibble: 253 x 14
#>    ticker date                close  high   low  open volume adjClose
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <int>    <dbl>
#>  1 AAPL   2017-07-05 00:00:00  144.  145.  143.  144. 2.08e7     142.
#>  2 AAPL   2017-07-06 00:00:00  143.  144.  142.  143. 2.34e7     141.
#>  3 AAPL   2017-07-07 00:00:00  144.  145.  143.  143. 1.85e7     142.
#>  4 AAPL   2017-07-10 00:00:00  145.  146.  143.  144. 2.10e7     143.
#>  5 AAPL   2017-07-11 00:00:00  146.  146.  144.  145. 1.83e7     143.
#>  6 AAPL   2017-07-12 00:00:00  146.  146.  145.  146. 2.36e7     143.
#>  7 AAPL   2017-07-13 00:00:00  148.  148.  145.  146. 2.49e7     145.
#>  8 AAPL   2017-07-14 00:00:00  149.  149.  147.  148. 2.00e7     147.
#>  9 AAPL   2017-07-17 00:00:00  150.  151.  149.  149. 2.32e7     147.
#> 10 AAPL   2017-07-18 00:00:00  150.  150.  149.  149. 1.77e7     148.
#> # ... with 243 more rows, and 6 more variables: adjHigh <dbl>,
#> #   adjLow <dbl>, adjOpen <dbl>, adjVolume <int>, divCash <dbl>,
#> #   splitFactor <dbl>
```

But of course you can try and get as much as is available…

``` r
riingo_prices("AAPL", start_date = "1950-01-01")
#> # A tibble: 9,471 x 14
#>    ticker date                close  high   low  open volume adjClose
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <int>    <dbl>
#>  1 AAPL   1980-12-12 00:00:00  28.8  28.9  28.8  28.8 2.09e6    0.418
#>  2 AAPL   1980-12-15 00:00:00  27.2  27.4  27.2  27.4 7.85e5    0.396
#>  3 AAPL   1980-12-16 00:00:00  25.2  25.4  25.2  25.4 4.72e5    0.367
#>  4 AAPL   1980-12-17 00:00:00  25.9  26    25.9  25.9 3.86e5    0.376
#>  5 AAPL   1980-12-18 00:00:00  26.6  26.8  26.6  26.6 3.28e5    0.387
#>  6 AAPL   1980-12-19 00:00:00  28.2  28.4  28.2  28.2 2.17e5    0.411
#>  7 AAPL   1980-12-22 00:00:00  29.6  29.8  29.6  29.6 1.67e5    0.431
#>  8 AAPL   1980-12-23 00:00:00  30.9  31    30.9  30.9 2.10e5    0.449
#>  9 AAPL   1980-12-24 00:00:00  32.5  32.6  32.5  32.5 2.14e5    0.472
#> 10 AAPL   1980-12-26 00:00:00  35.5  35.6  35.5  35.5 2.48e5    0.516
#> # ... with 9,461 more rows, and 6 more variables: adjHigh <dbl>,
#> #   adjLow <dbl>, adjOpen <dbl>, adjVolume <int>, divCash <dbl>,
#> #   splitFactor <dbl>
```

And multiple tickers work as
well.

``` r
riingo_prices(c("AAPL", "IBM"), start_date = "2001-01-01", end_date = "2005-01-01", resample_frequency = "monthly")
#> # A tibble: 98 x 14
#>    ticker date                close  high   low  open volume adjClose
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <int>    <dbl>
#>  1 AAPL   2001-01-31 00:00:00  21.6  22.5  14.4  14.9 2.45e8    1.37 
#>  2 AAPL   2001-02-28 00:00:00  18.2  21.9  18    20.7 1.25e8    1.16 
#>  3 AAPL   2001-03-30 00:00:00  22.1  23.8  17.2  17.8 1.93e8    1.40 
#>  4 AAPL   2001-04-30 00:00:00  25.5  27.1  18.8  22.1 1.99e8    1.62 
#>  5 AAPL   2001-05-31 00:00:00  20.0  26.7  19.3  25.4 1.33e8    1.27 
#>  6 AAPL   2001-06-29 00:00:00  23.2  25.1  19.4  20.1 1.36e8    1.48 
#>  7 AAPL   2001-07-31 00:00:00  18.8  25.2  17.8  23.6 1.55e8    1.19 
#>  8 AAPL   2001-08-31 00:00:00  18.6  19.9  17.3  19.0 9.16e7    1.18 
#>  9 AAPL   2001-09-28 00:00:00  15.5  19.1  14.7  18.5 9.88e7    0.985
#> 10 AAPL   2001-10-31 00:00:00  17.6  19.4  14.8  15.5 1.35e8    1.12 
#> # ... with 88 more rows, and 6 more variables: adjHigh <dbl>,
#> #   adjLow <dbl>, adjOpen <dbl>, adjVolume <dbl>, divCash <dbl>,
#> #   splitFactor <dbl>
```

# Intraday data

You can get *limited* intraday data with `riingo_iex_prices()`. This
gives you access to Tiingo’s direct feed to the IEX.

``` r
riingo_iex_prices("AAPL", resample_frequency = "1min")
#> # A tibble: 2,000 x 6
#>    ticker date                 open  high   low close
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>
#>  1 AAPL   2018-06-29 15:45:00  186.  186.  186.  186.
#>  2 AAPL   2018-06-29 15:46:00  186.  186.  186.  186.
#>  3 AAPL   2018-06-29 15:47:00  186.  186.  186.  186.
#>  4 AAPL   2018-06-29 15:48:00  186.  186.  186.  186.
#>  5 AAPL   2018-06-29 15:49:00  186.  186.  186.  186.
#>  6 AAPL   2018-06-29 15:50:00  186.  186.  186.  186.
#>  7 AAPL   2018-06-29 15:51:00  186.  186.  186.  186.
#>  8 AAPL   2018-06-29 15:52:00  186.  186.  186.  186.
#>  9 AAPL   2018-06-29 15:53:00  186.  186.  186.  186.
#> 10 AAPL   2018-06-29 15:54:00  186.  186.  186.  186.
#> # ... with 1,990 more rows
```

See the documentation for all of the restrictions.

# Meta data

Meta data about each ticker is available through `riingo_meta()`.

``` r
riingo_meta(c("AAPL", "QQQ"))
#> # A tibble: 2 x 6
#>   ticker name  startDate           description endDate            
#>   <chr>  <chr> <dttm>              <chr>       <dttm>             
#> 1 AAPL   Appl… 1980-12-12 00:00:00 Apple Inc.… 2018-07-05 00:00:00
#> 2 QQQ    POWE… 1999-03-10 00:00:00 "PowerShar… 2018-07-05 00:00:00
#> # ... with 1 more variable: exchangeCode <chr>
```

# Available tickers

You can check if a ticker is supported on Tiingo with
`is_supported_ticker()` and you can get a `tibble` of all supported
tickers with `supported_tickers()`

``` r
is_supported_ticker("AAPL")
#> [1] TRUE

tickers <- supported_tickers()
tickers
#> # A tibble: 67,006 x 6
#>    ticker exchange assetType priceCurrency startDate          
#>    <chr>  <chr>    <chr>     <chr>         <dttm>             
#>  1 000001 SHE      Stock     CNY           2007-08-30 00:00:00
#>  2 000002 SHE      Stock     CNY           2000-01-04 00:00:00
#>  3 000004 SHE      Stock     CNY           2007-08-31 00:00:00
#>  4 000005 SHE      Stock     CNY           2001-01-02 00:00:00
#>  5 000006 SHE      Stock     CNY           2018-01-02 00:00:00
#>  6 000007 SHE      Stock     CNY           2007-08-31 00:00:00
#>  7 000008 SHE      Stock     CNY           2000-01-03 00:00:00
#>  8 000009 SHE      Stock     CNY           2000-01-03 00:00:00
#>  9 000010 SHE      Stock     CNY           2007-08-31 00:00:00
#> 10 000011 SHE      Stock     CNY           2018-01-02 00:00:00
#> # ... with 66,996 more rows, and 1 more variable: endDate <dttm>
```

# Quote data

Another benefit of getting a feed from IEX is real time quote data. This
includes TOP (top of book) bid and ask prices, along with most recent
sale prices.

It is normal for some fields to return `NA` when outside of trading
hours.

``` r
riingo_iex_quote(c("AAPL", "QQQ"))
#> # A tibble: 2 x 17
#>   ticker  last lastSize lastsaleTimeStamp   bidPrice  high
#>   <chr>  <dbl> <lgl>    <dttm>              <lgl>    <dbl>
#> 1 AAPL    185. NA       2018-07-05 20:00:00 NA        186.
#> 2 QQQ     173. NA       2018-07-05 20:00:00 NA        173.
#> # ... with 11 more variables: quoteTimestamp <dttm>, tngoLast <dbl>,
#> #   mid <lgl>, bidSize <lgl>, prevClose <dbl>, timestamp <dttm>,
#> #   askSize <lgl>, askPrice <lgl>, open <dbl>, volume <int>, low <dbl>
```

# Crypto data

Cryptocurrency data can be accessed with `riingo_crypto_*()` functions.
By default, 1 year’s worth is pulled if available. Some tickers go back
much further than others.

``` r
riingo_crypto_prices(c("btcusd", "btceur"))
#> # A tibble: 570 x 11
#>    ticker baseCurrency quoteCurrency date                  open   high
#>    <chr>  <chr>        <chr>         <dttm>               <dbl>  <dbl>
#>  1 btceur btc          eur           2017-12-14 00:00:00 13873. 14354.
#>  2 btceur btc          eur           2017-12-15 00:00:00 14076. 15195.
#>  3 btceur btc          eur           2017-12-16 00:00:00 15073. 16881.
#>  4 btceur btc          eur           2017-12-17 00:00:00 16573. 16933.
#>  5 btceur btc          eur           2017-12-18 00:00:00 16010. 16439.
#>  6 btceur btc          eur           2017-12-19 00:00:00 16051. 16329.
#>  7 btceur btc          eur           2017-12-20 00:00:00 14994. 15408.
#>  8 btceur btc          eur           2017-12-21 00:00:00 13855. 14912.
#>  9 btceur btc          eur           2017-12-22 00:00:00 13314. 13562 
#> 10 btceur btc          eur           2017-12-23 00:00:00 12702. 14465.
#> # ... with 560 more rows, and 5 more variables: low <dbl>, close <dbl>,
#> #   volume <dbl>, volumeNotional <dbl>, tradesDone <dbl>
```

Intraday data is available as well. The intraday ranges are not well
documented, so it is a little hard to know what you can pull. From what
I have discovered, you can pull a few days at a time, with the max date
of intraday data being about ~4 months back (When the date was April 5,
2018, I could pull intraday data back to December 15, 2017, but only
5000 minutes at a
time).

``` r
riingo_crypto_prices("btcusd", start_date = Sys.Date() - 5, end_date = Sys.Date(), resample_frequency = "1min")
#> # A tibble: 5,001 x 11
#>    ticker baseCurrency quoteCurrency date                 open  high   low
#>    <chr>  <chr>        <chr>         <dttm>              <dbl> <dbl> <dbl>
#>  1 btcusd btc          usd           2018-06-30 00:00:00 6206. 6206. 6202.
#>  2 btcusd btc          usd           2018-06-30 00:01:00 6205. 6206. 6198.
#>  3 btcusd btc          usd           2018-06-30 00:02:00 6201. 6201. 6196.
#>  4 btcusd btc          usd           2018-06-30 00:03:00 6196. 6202. 6192.
#>  5 btcusd btc          usd           2018-06-30 00:04:00 6202. 6209. 6189.
#>  6 btcusd btc          usd           2018-06-30 00:05:00 6202. 6214. 6201.
#>  7 btcusd btc          usd           2018-06-30 00:06:00 6214. 6225. 6213.
#>  8 btcusd btc          usd           2018-06-30 00:07:00 6227. 6231. 6222.
#>  9 btcusd btc          usd           2018-06-30 00:08:00 6218. 6218. 6212.
#> 10 btcusd btc          usd           2018-06-30 00:09:00 6213. 6216. 6208.
#> # ... with 4,991 more rows, and 4 more variables: close <dbl>,
#> #   volume <dbl>, volumeNotional <dbl>, tradesDone <dbl>
```

Also available are meta data with `riingo_crypto_meta()`, and TOP (top
of book) quote data with `riingo_crypto_quote()`.

Lastly, you can extract raw (unaggregated) data feeds from multiple
exchanges by using the `raw = TRUE` argument in the price and quote
crypto function.

# Related projects

  - [tiingo-python](https://github.com/hydrosquall/tiingo-python) - A
    Python client for interacting with the Tiingo API.

  - [quantmod](https://github.com/joshuaulrich/quantmod) - One of the
    data sources `quantmod` can pull from is Tiingo.
