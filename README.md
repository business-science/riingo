
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/riingo)](https://cran.r-project.org/package=riingo)
[![Codecov test
coverage](https://codecov.io/gh/business-science/riingo/branch/master/graph/badge.svg)](https://codecov.io/gh/business-science/riingo?branch=master)
[![R build
status](https://github.com/business-science/riingo/workflows/R-CMD-check/badge.svg)](https://github.com/business-science/riingo/actions)
<!-- badges: end -->

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
#> # A tibble: 252 x 14
#>    ticker date                close  high   low  open volume adjClose adjHigh
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <int>    <dbl>   <dbl>
#>  1 AAPL   2019-07-18 00:00:00  206.  206.  204.  204  1.86e7     203.    203.
#>  2 AAPL   2019-07-19 00:00:00  203.  206.  202.  206. 2.09e7     200.    204.
#>  3 AAPL   2019-07-22 00:00:00  207.  207.  204.  204. 2.23e7     205.    205.
#>  4 AAPL   2019-07-23 00:00:00  209.  209.  207.  208. 1.84e7     206.    206.
#>  5 AAPL   2019-07-24 00:00:00  209.  209.  207.  208. 1.50e7     206.    207.
#>  6 AAPL   2019-07-25 00:00:00  207.  209.  207.  209. 1.39e7     205.    207.
#>  7 AAPL   2019-07-26 00:00:00  208.  210.  207.  207. 1.76e7     205.    207.
#>  8 AAPL   2019-07-29 00:00:00  210.  211.  208.  208. 2.17e7     207.    208.
#>  9 AAPL   2019-07-30 00:00:00  209.  210.  207.  209. 3.39e7     206.    208.
#> 10 AAPL   2019-07-31 00:00:00  213.  221.  211.  216. 6.93e7     211.    219.
#> # … with 242 more rows, and 5 more variables: adjLow <dbl>, adjOpen <dbl>,
#> #   adjVolume <int>, divCash <dbl>, splitFactor <dbl>
```

But of course you can try and get as much as is available…

``` r
riingo_prices("AAPL", start_date = "1950-01-01")
#> # A tibble: 9,982 x 14
#>    ticker date                close  high   low  open volume adjClose adjHigh
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <int>    <dbl>   <dbl>
#>  1 AAPL   1980-12-12 00:00:00  28.8  28.9  28.8  28.8 2.09e6    0.407   0.408
#>  2 AAPL   1980-12-15 00:00:00  27.2  27.4  27.2  27.4 7.85e5    0.386   0.387
#>  3 AAPL   1980-12-16 00:00:00  25.2  25.4  25.2  25.4 4.72e5    0.357   0.359
#>  4 AAPL   1980-12-17 00:00:00  25.9  26    25.9  25.9 3.86e5    0.366   0.368
#>  5 AAPL   1980-12-18 00:00:00  26.6  26.8  26.6  26.6 3.28e5    0.377   0.378
#>  6 AAPL   1980-12-19 00:00:00  28.2  28.4  28.2  28.2 2.17e5    0.400   0.402
#>  7 AAPL   1980-12-22 00:00:00  29.6  29.8  29.6  29.6 1.67e5    0.419   0.421
#>  8 AAPL   1980-12-23 00:00:00  30.9  31    30.9  30.9 2.10e5    0.437   0.439
#>  9 AAPL   1980-12-24 00:00:00  32.5  32.6  32.5  32.5 2.14e5    0.460   0.462
#> 10 AAPL   1980-12-26 00:00:00  35.5  35.6  35.5  35.5 2.48e5    0.502   0.504
#> # … with 9,972 more rows, and 5 more variables: adjLow <dbl>, adjOpen <dbl>,
#> #   adjVolume <int>, divCash <dbl>, splitFactor <dbl>
```

And multiple tickers work as well.

``` r
riingo_prices(c("AAPL", "IBM"), start_date = "2001-01-01", end_date = "2005-01-01", resample_frequency = "monthly")
#> # A tibble: 98 x 14
#>    ticker date                close  high   low  open volume adjClose adjHigh
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <int>    <dbl>   <dbl>
#>  1 AAPL   2001-01-31 00:00:00  21.6  22.5  14.4  14.9 2.45e8    1.34     1.39
#>  2 AAPL   2001-02-28 00:00:00  18.2  21.9  18    20.7 1.25e8    1.13     1.36
#>  3 AAPL   2001-03-30 00:00:00  22.1  23.8  17.2  17.8 1.93e8    1.36     1.47
#>  4 AAPL   2001-04-30 00:00:00  25.5  27.1  18.8  22.1 1.99e8    1.58     1.68
#>  5 AAPL   2001-05-31 00:00:00  20.0  26.7  19.3  25.4 1.33e8    1.23     1.65
#>  6 AAPL   2001-06-29 00:00:00  23.2  25.1  19.4  20.1 1.36e8    1.44     1.55
#>  7 AAPL   2001-07-31 00:00:00  18.8  25.2  17.8  23.6 1.55e8    1.16     1.56
#>  8 AAPL   2001-08-31 00:00:00  18.6  19.9  17.3  19.0 9.16e7    1.15     1.23
#>  9 AAPL   2001-09-28 00:00:00  15.5  19.1  14.7  18.5 9.88e7    0.959    1.18
#> 10 AAPL   2001-10-31 00:00:00  17.6  19.4  14.8  15.5 1.35e8    1.09     1.20
#> # … with 88 more rows, and 5 more variables: adjLow <dbl>, adjOpen <dbl>,
#> #   adjVolume <dbl>, divCash <dbl>, splitFactor <dbl>
```

# Intraday data

You can get *limited* intraday data with `riingo_iex_prices()`. This
gives you access to Tiingo’s direct feed to the IEX.

``` r
riingo_iex_prices("AAPL", resample_frequency = "1min")
#> # A tibble: 10,000 x 6
#>    ticker date                close  high   low  open
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>
#>  1 AAPL   2020-06-12 13:55:00  346.  346.  346.  346.
#>  2 AAPL   2020-06-12 13:56:00  347.  347.  346.  346.
#>  3 AAPL   2020-06-12 13:57:00  346.  347.  346.  347.
#>  4 AAPL   2020-06-12 13:58:00  346.  346.  346.  346.
#>  5 AAPL   2020-06-12 13:59:00  346.  347.  346.  346.
#>  6 AAPL   2020-06-12 14:00:00  346.  347.  346.  347.
#>  7 AAPL   2020-06-12 14:01:00  347.  347.  346.  346.
#>  8 AAPL   2020-06-12 14:02:00  347.  347.  347.  347.
#>  9 AAPL   2020-06-12 14:03:00  347.  347.  347.  347.
#> 10 AAPL   2020-06-12 14:04:00  347.  347.  347.  347.
#> # … with 9,990 more rows
```

See the documentation for all of the restrictions.

# Meta data

Meta data about each ticker is available through `riingo_meta()`.

``` r
riingo_meta(c("AAPL", "QQQ"))
#> # A tibble: 2 x 6
#>   ticker name   startDate           exchangeCode description endDate            
#>   <chr>  <chr>  <dttm>              <chr>        <chr>       <dttm>             
#> 1 AAPL   Apple… 1980-12-12 00:00:00 NASDAQ       "Apple Inc… 2020-07-16 00:00:00
#> 2 QQQ    POWER… 1999-03-10 00:00:00 NASDAQ       "PowerShar… 2020-07-16 00:00:00
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
#> # A tibble: 85,714 x 6
#>    ticker exchange assetType priceCurrency startDate          
#>    <chr>  <chr>    <chr>     <chr>         <dttm>             
#>  1 000001 SHE      Stock     CNY           2007-08-30 00:00:00
#>  2 000002 SHE      Stock     CNY           2000-01-04 00:00:00
#>  3 000003 SHE      Stock     CNY           NA                 
#>  4 000004 SHE      Stock     CNY           2007-08-31 00:00:00
#>  5 000005 SHE      Stock     CNY           2001-01-02 00:00:00
#>  6 000006 SHE      Stock     CNY           2018-01-01 00:00:00
#>  7 000007 SHE      Stock     CNY           2007-08-31 00:00:00
#>  8 000008 SHE      Stock     CNY           2000-01-03 00:00:00
#>  9 000009 SHE      Stock     CNY           2000-01-03 00:00:00
#> 10 000010 SHE      Stock     CNY           2007-08-31 00:00:00
#> # … with 85,704 more rows, and 1 more variable: endDate <dttm>
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
#>   ticker  last bidPrice quoteTimestamp        low volume timestamp          
#>   <chr>  <dbl>    <dbl> <dttm>              <dbl>  <int> <dttm>             
#> 1 AAPL    385.     377  2020-07-17 13:39:00  383. 201592 2020-07-17 13:39:00
#> 2 QQQ     259.     259. 2020-07-17 13:39:16  257. 131168 2020-07-17 13:39:16
#> # … with 10 more variables: tngoLast <dbl>, lastsaleTimeStamp <dttm>,
#> #   lastSize <int>, askSize <int>, bidSize <int>, askPrice <dbl>, high <dbl>,
#> #   open <dbl>, prevClose <dbl>, mid <dbl>
```

# Crypto data

Cryptocurrency data can be accessed with `riingo_crypto_*()` functions.
By default, 1 year’s worth is pulled if available. Some tickers go back
much further than others.

``` r
riingo_crypto_prices(c("btcusd", "btceur"))
#> # A tibble: 731 x 11
#>    ticker baseCurrency quoteCurrency date                 open  high   low close
#>    <chr>  <chr>        <chr>         <dttm>              <dbl> <dbl> <dbl> <dbl>
#>  1 btceur btc          eur           2019-07-18 00:00:00 8638. 9568. 8282. 9444.
#>  2 btceur btc          eur           2019-07-19 00:00:00 9453. 9558. 9012. 9383.
#>  3 btceur btc          eur           2019-07-20 00:00:00 9377. 9901. 9246. 9578.
#>  4 btceur btc          eur           2019-07-21 00:00:00 9580. 9650. 9188. 9433.
#>  5 btceur btc          eur           2019-07-22 00:00:00 9449. 9539. 8986. 9221.
#>  6 btceur btc          eur           2019-07-23 00:00:00 9215. 9221. 8812. 8838.
#>  7 btceur btc          eur           2019-07-24 00:00:00 8843. 8915. 8550. 8769.
#>  8 btceur btc          eur           2019-07-25 00:00:00 8770. 9144. 8738. 8876.
#>  9 btceur btc          eur           2019-07-26 00:00:00 8872. 8913. 8674. 8844.
#> 10 btceur btc          eur           2019-07-27 00:00:00 8843. 9177. 8373. 8512.
#> # … with 721 more rows, and 3 more variables: volume <dbl>,
#> #   volumeNotional <dbl>, tradesDone <dbl>
```

Intraday data is available as well. The intraday ranges are not well
documented, so it is a little hard to know what you can pull. From what
I have discovered, you can pull a few days at a time, with the max date
of intraday data being about \~4 months back (When the date was April 5,
2018, I could pull intraday data back to December 15, 2017, but only
5000 minutes at a time).

``` r
riingo_crypto_prices("btcusd", start_date = Sys.Date() - 5, end_date = Sys.Date(), resample_frequency = "1min")
#> # A tibble: 4,530 x 11
#>    ticker baseCurrency quoteCurrency date                 open  high   low close
#>    <chr>  <chr>        <chr>         <dttm>              <dbl> <dbl> <dbl> <dbl>
#>  1 btcusd btc          usd           2020-07-12 00:00:00 9234. 9237. 9234. 9236.
#>  2 btcusd btc          usd           2020-07-12 00:01:00 9236. 9237. 9236. 9237.
#>  3 btcusd btc          usd           2020-07-12 00:02:00 9237. 9237. 9231. 9233.
#>  4 btcusd btc          usd           2020-07-12 00:03:00 9233. 9240. 9233. 9238.
#>  5 btcusd btc          usd           2020-07-12 00:04:00 9238. 9240. 9238. 9239.
#>  6 btcusd btc          usd           2020-07-12 00:05:00 9240. 9240. 9239. 9240.
#>  7 btcusd btc          usd           2020-07-12 00:06:00 9240. 9240. 9239. 9240.
#>  8 btcusd btc          usd           2020-07-12 00:07:00 9240. 9242. 9238. 9240.
#>  9 btcusd btc          usd           2020-07-12 00:08:00 9240. 9242. 9239. 9241.
#> 10 btcusd btc          usd           2020-07-12 00:09:00 9241. 9246. 9240. 9245.
#> # … with 4,520 more rows, and 3 more variables: volume <dbl>,
#> #   volumeNotional <dbl>, tradesDone <dbl>
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
