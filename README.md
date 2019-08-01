
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis build status](https://travis-ci.org/business-science/riingo.svg?branch=master)](https://travis-ci.org/business-science/riingo) [![Coverage status](https://codecov.io/gh/business-science/riingo/branch/master/graph/badge.svg)](https://codecov.io/github/business-science/riingo?branch=master) [![CRAN status](https://www.r-pkg.org/badges/version/riingo)](https://cran.r-project.org/package=riingo)

riingo
======

`riingo` allows you to access the Tiingo API for stock prices, cryptocurrencies, and intraday feeds from the IEX (Investors Exchange). This can serve as an alternate source of data to Yahoo Finance.

Installation
------------

Install the stable version from [CRAN](https://cran.r-project.org/) with:

``` r
install.packages("riingo")
```

Install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("DavisVaughan/riingo")
```

API Token
---------

The first thing you must do is create an account and set an API token. I recommend using the two functions below to help create your account and find the token.

``` r
riingo_browse_signup()
riingo_browse_token() # This requires that you are signed in on the site once you sign up
```

Once you have signed up and have an API token, I recommmend setting the token as an environment variable, `RIINGO_TOKEN` in an `.Renviron` file. The easiest way to do this is with `usethis`.

``` r
usethis::edit_r_environ()

# Then add a line in the environment file that looks like:
RIINGO_TOKEN = token_here
```

Do not put the token in quotes, and restart R after you have set it.

See the documentation `?riingo_get_token()` for more information.

Basic example
=============

``` r
library(riingo)
```

Let's grab some data with `riingo`. The default parameters attempt to get 1 year's worth of data.

``` r
riingo_prices("AAPL")
#> # A tibble: 251 x 14
#>    ticker date                close  high   low  open volume adjClose
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <int>    <dbl>
#>  1 AAPL   2018-08-01 00:00:00  202.  202.  197.  199. 6.79e7     198.
#>  2 AAPL   2018-08-02 00:00:00  207.  208.  200.  201. 6.24e7     204.
#>  3 AAPL   2018-08-03 00:00:00  208.  209.  205.  207. 3.34e7     205.
#>  4 AAPL   2018-08-06 00:00:00  209.  209.  207.  208  2.54e7     206.
#>  5 AAPL   2018-08-07 00:00:00  207.  210.  207.  209. 2.56e7     204.
#>  6 AAPL   2018-08-08 00:00:00  207.  208.  205.  206. 2.25e7     204.
#>  7 AAPL   2018-08-09 00:00:00  209.  210.  207.  207. 2.35e7     206.
#>  8 AAPL   2018-08-10 00:00:00  208.  209.  207.  207. 2.46e7     205.
#>  9 AAPL   2018-08-13 00:00:00  209.  211.  208.  208. 2.59e7     206.
#> 10 AAPL   2018-08-14 00:00:00  210.  211.  208.  210. 2.07e7     207.
#> # … with 241 more rows, and 6 more variables: adjHigh <dbl>, adjLow <dbl>,
#> #   adjOpen <dbl>, adjVolume <int>, divCash <dbl>, splitFactor <dbl>
```

But of course you can try and get as much as is available...

``` r
riingo_prices("AAPL", start_date = "1950-01-01")
#> # A tibble: 9,740 x 14
#>    ticker date                close  high   low  open volume adjClose
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <int>    <dbl>
#>  1 AAPL   1980-12-12 00:00:00  28.8  28.9  28.8  28.8 2.09e6    0.412
#>  2 AAPL   1980-12-15 00:00:00  27.2  27.4  27.2  27.4 7.85e5    0.390
#>  3 AAPL   1980-12-16 00:00:00  25.2  25.4  25.2  25.4 4.72e5    0.361
#>  4 AAPL   1980-12-17 00:00:00  25.9  26    25.9  25.9 3.86e5    0.370
#>  5 AAPL   1980-12-18 00:00:00  26.6  26.8  26.6  26.6 3.28e5    0.381
#>  6 AAPL   1980-12-19 00:00:00  28.2  28.4  28.2  28.2 2.17e5    0.404
#>  7 AAPL   1980-12-22 00:00:00  29.6  29.8  29.6  29.6 1.67e5    0.424
#>  8 AAPL   1980-12-23 00:00:00  30.9  31    30.9  30.9 2.10e5    0.442
#>  9 AAPL   1980-12-24 00:00:00  32.5  32.6  32.5  32.5 2.14e5    0.465
#> 10 AAPL   1980-12-26 00:00:00  35.5  35.6  35.5  35.5 2.48e5    0.508
#> # … with 9,730 more rows, and 6 more variables: adjHigh <dbl>,
#> #   adjLow <dbl>, adjOpen <dbl>, adjVolume <int>, divCash <dbl>,
#> #   splitFactor <dbl>
```

And multiple tickers work as well.

``` r
riingo_prices(c("AAPL", "IBM"), start_date = "2001-01-01", end_date = "2005-01-01", resample_frequency = "monthly")
#> # A tibble: 98 x 14
#>    ticker date                close  high   low  open volume adjClose
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <int>    <dbl>
#>  1 AAPL   2001-01-31 00:00:00  21.6  22.5  14.4  14.9 2.45e8    1.35 
#>  2 AAPL   2001-02-28 00:00:00  18.2  21.9  18    20.7 1.25e8    1.14 
#>  3 AAPL   2001-03-30 00:00:00  22.1  23.8  17.2  17.8 1.93e8    1.38 
#>  4 AAPL   2001-04-30 00:00:00  25.5  27.1  18.8  22.1 1.99e8    1.59 
#>  5 AAPL   2001-05-31 00:00:00  20.0  26.7  19.3  25.4 1.33e8    1.25 
#>  6 AAPL   2001-06-29 00:00:00  23.2  25.1  19.4  20.1 1.36e8    1.45 
#>  7 AAPL   2001-07-31 00:00:00  18.8  25.2  17.8  23.6 1.55e8    1.18 
#>  8 AAPL   2001-08-31 00:00:00  18.6  19.9  17.3  19.0 9.16e7    1.16 
#>  9 AAPL   2001-09-28 00:00:00  15.5  19.1  14.7  18.5 9.88e7    0.970
#> 10 AAPL   2001-10-31 00:00:00  17.6  19.4  14.8  15.5 1.35e8    1.10 
#> # … with 88 more rows, and 6 more variables: adjHigh <dbl>, adjLow <dbl>,
#> #   adjOpen <dbl>, adjVolume <dbl>, divCash <dbl>, splitFactor <dbl>
```

Intraday data
=============

You can get *limited* intraday data with `riingo_iex_prices()`. This gives you access to Tiingo's direct feed to the IEX.

``` r
riingo_iex_prices("AAPL", resample_frequency = "1min")
#> # A tibble: 5,000 x 6
#>    ticker date                 open  high   low close
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>
#>  1 AAPL   2019-07-16 13:38:00  205.  205.  205.  205.
#>  2 AAPL   2019-07-16 13:39:00  205.  205.  205.  205.
#>  3 AAPL   2019-07-16 13:40:00  205.  205.  205.  205.
#>  4 AAPL   2019-07-16 13:41:00  205.  206.  205.  206.
#>  5 AAPL   2019-07-16 13:42:00  206.  206.  206.  206.
#>  6 AAPL   2019-07-16 13:43:00  206.  206.  206.  206.
#>  7 AAPL   2019-07-16 13:44:00  206.  206.  206.  206.
#>  8 AAPL   2019-07-16 13:45:00  206.  206.  206.  206.
#>  9 AAPL   2019-07-16 13:46:00  206.  206.  206.  206.
#> 10 AAPL   2019-07-16 13:47:00  206.  206.  206.  206.
#> # … with 4,990 more rows
```

See the documentation for all of the restrictions.

Meta data
=========

Meta data about each ticker is available through `riingo_meta()`.

``` r
riingo_meta(c("AAPL", "QQQ"))
#> # A tibble: 2 x 6
#>   ticker startDate           exchangeCode name  endDate            
#>   <chr>  <dttm>              <chr>        <chr> <dttm>             
#> 1 AAPL   1980-12-12 00:00:00 NASDAQ       Appl… 2019-07-31 00:00:00
#> 2 QQQ    1999-03-10 00:00:00 NASDAQ       POWE… 2019-07-31 00:00:00
#> # … with 1 more variable: description <chr>
```

Available tickers
=================

You can check if a ticker is supported on Tiingo with `is_supported_ticker()` and you can get a `tibble` of all supported tickers with `supported_tickers()`

``` r
is_supported_ticker("AAPL")
#> [1] TRUE

tickers <- supported_tickers()
tickers
#> # A tibble: 79,683 x 6
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
#> # … with 79,673 more rows, and 1 more variable: endDate <dttm>
```

Quote data
==========

Another benefit of getting a feed from IEX is real time quote data. This includes TOP (top of book) bid and ask prices, along with most recent sale prices.

It is normal for some fields to return `NA` when outside of trading hours.

``` r
riingo_iex_quote(c("AAPL", "QQQ"))
#> # A tibble: 2 x 17
#>   ticker lastSaleTimesta…  high  last askPrice  open prevClose   mid volume
#>   <chr>  <chr>            <dbl> <dbl>    <dbl> <dbl>     <dbl> <dbl>  <int>
#> 1 AAPL   2019-08-01T14:4…  218.  208.     208.  214.      213.  208.      0
#> 2 QQQ    2019-08-01T14:4…  195.  190.     190.  191.      191.  190.      0
#> # … with 8 more variables: lastSize <int>, quoteTimestamp <dttm>,
#> #   bidPrice <dbl>, askSize <int>, bidSize <int>, tngoLast <dbl>,
#> #   low <dbl>, timestamp <dttm>
```

Crypto data
===========

Cryptocurrency data can be accessed with `riingo_crypto_*()` functions. By default, 1 year's worth is pulled if available. Some tickers go back much further than others.

``` r
riingo_crypto_prices(c("btcusd", "btceur"))
#> # A tibble: 727 x 11
#>    ticker baseCurrency quoteCurrency date                 open  high   low
#>    <chr>  <chr>        <chr>         <dttm>              <dbl> <dbl> <dbl>
#>  1 btceur btc          eur           2018-08-01 00:00:00 6619. 6625. 6379.
#>  2 btceur btc          eur           2018-08-02 00:00:00 6543. 6614. 6423.
#>  3 btceur btc          eur           2018-08-03 00:00:00 6505. 6508. 6292.
#>  4 btceur btc          eur           2018-08-04 00:00:00 6411. 6470. 6022.
#>  5 btceur btc          eur           2018-08-05 00:00:00 6055. 6128. 5958.
#>  6 btceur btc          eur           2018-08-06 00:00:00 6114. 6174. 5920.
#>  7 btceur btc          eur           2018-08-07 00:00:00 6005. 6165. 5754.
#>  8 btceur btc          eur           2018-08-08 00:00:00 5798. 5798. 5276.
#>  9 btceur btc          eur           2018-08-09 00:00:00 5410. 5761. 5345.
#> 10 btceur btc          eur           2018-08-10 00:00:00 5685. 5713. 5278.
#> # … with 717 more rows, and 4 more variables: close <dbl>, volume <dbl>,
#> #   volumeNotional <dbl>, tradesDone <dbl>
```

Intraday data is available as well. The intraday ranges are not well documented, so it is a little hard to know what you can pull. From what I have discovered, you can pull a few days at a time, with the max date of intraday data being about ~4 months back (When the date was April 5, 2018, I could pull intraday data back to December 15, 2017, but only 5000 minutes at a time).

``` r
riingo_crypto_prices("btcusd", start_date = Sys.Date() - 5, end_date = Sys.Date(), resample_frequency = "1min")
#> # A tibble: 4,974 x 11
#>    ticker baseCurrency quoteCurrency date                 open  high   low
#>    <chr>  <chr>        <chr>         <dttm>              <dbl> <dbl> <dbl>
#>  1 btcusd btc          usd           2019-07-27 00:00:00 9840. 9840. 9840 
#>  2 btcusd btc          usd           2019-07-27 00:01:00 9840  9840. 9840 
#>  3 btcusd btc          usd           2019-07-27 00:02:00 9840  9840. 9840 
#>  4 btcusd btc          usd           2019-07-27 00:03:00 9840. 9840. 9840 
#>  5 btcusd btc          usd           2019-07-27 00:04:00 9840  9840  9840 
#>  6 btcusd btc          usd           2019-07-27 00:05:00 9840. 9840. 9827.
#>  7 btcusd btc          usd           2019-07-27 00:06:00 9827. 9827. 9826.
#>  8 btcusd btc          usd           2019-07-27 00:07:00 9826. 9826. 9826.
#>  9 btcusd btc          usd           2019-07-27 00:08:00 9825. 9839. 9825.
#> 10 btcusd btc          usd           2019-07-27 00:09:00 9838. 9855. 9838.
#> # … with 4,964 more rows, and 4 more variables: close <dbl>, volume <dbl>,
#> #   volumeNotional <dbl>, tradesDone <dbl>
```

Also available are meta data with `riingo_crypto_meta()`, and TOP (top of book) quote data with `riingo_crypto_quote()`.

Lastly, you can extract raw (unaggregated) data feeds from multiple exchanges by using the `raw = TRUE` argument in the price and quote crypto function.

News Data
=========

The Tiingo news feed can be accessed via the `riingo_news()` function.

This function is only available for those who have a paid Power plan with Tiingo.

``` r
riingo_news(ticker='AAPL', start_date = Sys.Date() - 5, end_date = Sys.Date(), limit=100)
#> # A tibble: 100 x 9
#>    crawlDate               id publishedDate       description source url  
#>    <dttm>               <int> <dttm>              <chr>       <chr>  <chr>
#>  1 2019-07-31 23:52:33 1.87e7 2019-07-31 23:34:45 "\"People … cnbc.… http…
#>  2 2019-08-01 00:57:45 1.87e7 2019-07-31 23:05:00 Let's see … zacks… http…
#>  3 2019-07-31 23:00:36 1.87e7 2019-07-31 23:00:27 "For the f… talkm… http…
#>  4 2019-07-31 23:36:09 1.87e7 2019-07-31 22:56:34 While I do… seeki… http…
#>  5 2019-07-31 23:12:40 1.87e7 2019-07-31 22:37:44 "\"When yo… cnbc.… http…
#>  6 2019-08-01 00:35:58 1.87e7 2019-07-31 22:36:33 Wearable d… reute… http…
#>  7 2019-08-01 00:34:12 1.87e7 2019-07-31 22:30:22 Qualcomm I… reute… http…
#>  8 2019-07-31 23:33:46 1.87e7 2019-07-31 22:25:22 ""          bloom… http…
#>  9 2019-07-31 23:35:54 1.87e7 2019-07-31 22:21:11 "Apple is … seeki… http…
#> 10 2019-07-31 22:19:11 1.87e7 2019-07-31 22:04:59 US Indexes… guruf… http…
#> # … with 90 more rows, and 3 more variables: title <chr>, tickers <list>,
#> #   tags <list>
```

Related projects
================

-   [tiingo-python](https://github.com/hydrosquall/tiingo-python) - A Python client for interacting with the Tiingo API.

-   [quantmod](https://github.com/joshuaulrich/quantmod) - One of the data sources `quantmod` can pull from is Tiingo.
