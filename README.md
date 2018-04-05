
<!-- README.md is generated from README.Rmd. Please edit that file -->

# riingo

`riingo` allows you to access the Tiingo API for stock prices,
cryptocurrencies, and intraday feeds from the IEX (Investors Exchange).
This can serve as an alternate source of data to Yahoo Finance.

## Installation

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
RIINGO_API = token_here
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
#> # A tibble: 251 x 14
#>    ticker date                close  high   low  open   volume adjClose
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>    <int>    <dbl>
#>  1 AAPL   2017-04-05 00:00:00  144.  145.  144.  144. 27717854     142.
#>  2 AAPL   2017-04-06 00:00:00  144.  145.  143.  144. 21149034     141.
#>  3 AAPL   2017-04-07 00:00:00  143.  144.  143.  144. 16658543     141.
#>  4 AAPL   2017-04-10 00:00:00  143.  144.  143.  144. 18933397     141.
#>  5 AAPL   2017-04-11 00:00:00  142.  143.  140.  143. 30379376     139.
#>  6 AAPL   2017-04-12 00:00:00  142.  142.  141.  142. 20350000     140.
#>  7 AAPL   2017-04-13 00:00:00  141.  142.  141.  142. 17822880     139.
#>  8 AAPL   2017-04-17 00:00:00  142.  142.  141.  141. 16582094     140.
#>  9 AAPL   2017-04-18 00:00:00  141.  142.  141.  141. 14697544     139.
#> 10 AAPL   2017-04-19 00:00:00  141.  142.  140.  142. 17328375     138.
#> # ... with 241 more rows, and 6 more variables: adjHigh <dbl>,
#> #   adjLow <dbl>, adjOpen <dbl>, adjVolume <int>, divCash <dbl>,
#> #   splitFactor <dbl>
```

But of course you can try and get as much as is available…

``` r
riingo_prices("AAPL", start_date = "1950-01-01")
#> # A tibble: 9,407 x 14
#>    ticker date                close  high   low  open  volume adjClose
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>   <int>    <dbl>
#>  1 AAPL   1980-12-12 00:00:00  28.8  28.9  28.8  28.8 2093900    0.419
#>  2 AAPL   1980-12-15 00:00:00  27.2  27.4  27.2  27.4  785200    0.398
#>  3 AAPL   1980-12-16 00:00:00  25.2  25.4  25.2  25.4  472000    0.368
#>  4 AAPL   1980-12-17 00:00:00  25.9  26.0  25.9  25.9  385900    0.377
#>  5 AAPL   1980-12-18 00:00:00  26.6  26.8  26.6  26.6  327900    0.389
#>  6 AAPL   1980-12-19 00:00:00  28.2  28.4  28.2  28.2  217100    0.412
#>  7 AAPL   1980-12-22 00:00:00  29.6  29.8  29.6  29.6  166800    0.432
#>  8 AAPL   1980-12-23 00:00:00  30.9  31.0  30.9  30.9  209600    0.451
#>  9 AAPL   1980-12-24 00:00:00  32.5  32.6  32.5  32.5  214300    0.474
#> 10 AAPL   1980-12-26 00:00:00  35.5  35.6  35.5  35.5  248100    0.518
#> # ... with 9,397 more rows, and 6 more variables: adjHigh <dbl>,
#> #   adjLow <dbl>, adjOpen <dbl>, adjVolume <int>, divCash <dbl>,
#> #   splitFactor <dbl>
```

And multiple tickers work as
well.

``` r
riingo_prices(c("AAPL", "IBM"), start_date = "2001-01-01", end_date = "2005-01-01", resample_frequency = "monthly")
#> # A tibble: 98 x 14
#>    ticker date                close  high   low  open    volume adjClose
#>    <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>     <int>    <dbl>
#>  1 AAPL   2001-01-31 00:00:00  21.6  22.5  14.4  14.9 244811800    1.38 
#>  2 AAPL   2001-02-28 00:00:00  18.2  21.9  18.0  20.7 125424400    1.16 
#>  3 AAPL   2001-03-30 00:00:00  22.1  23.8  17.2  17.8 192840400    1.41 
#>  4 AAPL   2001-04-30 00:00:00  25.5  27.1  18.8  22.1 199267700    1.63 
#>  5 AAPL   2001-05-31 00:00:00  20.0  26.7  19.3  25.4 133364900    1.27 
#>  6 AAPL   2001-06-29 00:00:00  23.2  25.1  19.4  20.1 136397600    1.48 
#>  7 AAPL   2001-07-31 00:00:00  18.8  25.2  17.8  23.6 154555400    1.20 
#>  8 AAPL   2001-08-31 00:00:00  18.6  19.9  17.3  19.0  91595700    1.18 
#>  9 AAPL   2001-09-28 00:00:00  15.5  19.1  14.7  18.5  98777200    0.989
#> 10 AAPL   2001-10-31 00:00:00  17.6  19.4  14.8  15.5 134718700    1.12 
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
#>  1 AAPL   2018-03-29 19:58:00  169.  169.  169.  169.
#>  2 AAPL   2018-03-29 19:59:00  169.  169.  169.  169.
#>  3 AAPL   2018-03-29 20:00:00  169.  169.  169.  169.
#>  4 AAPL   2018-03-29 20:01:00  168.  168.  168.  168.
#>  5 AAPL   2018-03-29 20:02:00  168.  168.  168.  168.
#>  6 AAPL   2018-03-29 20:03:00  168.  168.  168.  168.
#>  7 AAPL   2018-03-29 20:04:00  168.  168.  168.  168.
#>  8 AAPL   2018-03-29 20:05:00  168.  168.  168.  168.
#>  9 AAPL   2018-03-29 20:06:00  168.  168.  168.  168.
#> 10 AAPL   2018-03-29 20:07:00  168.  168.  168.  168.
#> # ... with 1,990 more rows
```

See the documentation for all of the restrictions.

# Meta data

Meta data about each ticker is available through `riingo_meta()`.

``` r
riingo_meta(c("AAPL", "QQQ"))
#> # A tibble: 2 x 6
#>   ticker name   startDate           description        endDate            
#>   <chr>  <chr>  <dttm>              <chr>              <dttm>             
#> 1 AAPL   Apple… 1980-12-12 00:00:00 Apple Inc. (Apple… 2018-04-04 00:00:00
#> 2 QQQ    POWER… 1999-03-10 00:00:00 "PowerShares QQQ™… 2018-04-04 00:00:00
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
#> # A tibble: 64,809 x 6
#>    ticker exchange assetType priceCurrency startDate          
#>    <chr>  <chr>    <chr>     <chr>         <dttm>             
#>  1 000001 SHE      Stock     CNY           2007-08-30 00:00:00
#>  2 000002 SHE      Stock     CNY           2000-01-04 00:00:00
#>  3 000004 SHE      Stock     CNY           2007-08-31 00:00:00
#>  4 000005 SHE      Stock     CNY           2001-01-02 00:00:00
#>  5 000006 SHE      Stock     CNY           2007-08-31 00:00:00
#>  6 000007 SHE      Stock     CNY           2007-08-31 00:00:00
#>  7 000008 SHE      Stock     CNY           2000-01-03 00:00:00
#>  8 000009 SHE      Stock     CNY           2000-01-03 00:00:00
#>  9 000010 SHE      Stock     CNY           2007-08-31 00:00:00
#> 10 000011 SHE      Stock     CNY           2018-01-02 00:00:00
#> # ... with 64,799 more rows, and 1 more variable: endDate <dttm>
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
#>   ticker  last askSize lastsaleTimeStamp   bidPrice volume
#>   <chr>  <dbl>   <int> <dttm>                 <dbl>  <int>
#> 1 AAPL    174.     100 2018-04-05 12:55:45     174.      0
#> 2 QQQ     161.     400 2018-04-05 12:50:24     161.      0
#> # ... with 11 more variables: quoteTimestamp <dttm>, tngoLast <dbl>,
#> #   mid <dbl>, bidSize <int>, prevClose <dbl>, timestamp <dttm>,
#> #   high <dbl>, lastSize <int>, askPrice <dbl>, open <dbl>, low <dbl>
```

# Crypto data

Cryptocurrency data can be accessed with `riingo_crypto_*()` functions.
By default, 1 year’s worth is pulled if available. Some tickers go back
much further than others.

``` r
riingo_crypto_prices(c("btcusd", "btceur"))
#> # A tibble: 479 x 10
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
#>  9 btceur btc          eur           2017-12-22 00:00:00 13314. 13562.
#> 10 btceur btc          eur           2017-12-23 00:00:00 12702. 14465.
#> # ... with 469 more rows, and 4 more variables: low <dbl>, close <dbl>,
#> #   volume <dbl>, volumeNotional <dbl>
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
#> # A tibble: 4,991 x 10
#>    ticker baseCurrency quoteCurrency date                 open  high   low
#>    <chr>  <chr>        <chr>         <dttm>              <dbl> <dbl> <dbl>
#>  1 btcusd btc          usd           2018-03-31 00:00:00 6840. 6851. 6840.
#>  2 btcusd btc          usd           2018-03-31 00:01:00 6854. 6857. 6850.
#>  3 btcusd btc          usd           2018-03-31 00:02:00 6851. 6859. 6851.
#>  4 btcusd btc          usd           2018-03-31 00:03:00 6859. 6861. 6857.
#>  5 btcusd btc          usd           2018-03-31 00:04:00 6862. 6875. 6862.
#>  6 btcusd btc          usd           2018-03-31 00:05:00 6875. 6891. 6875.
#>  7 btcusd btc          usd           2018-03-31 00:06:00 6887. 6893. 6878.
#>  8 btcusd btc          usd           2018-03-31 00:07:00 6887. 6891. 6887.
#>  9 btcusd btc          usd           2018-03-31 00:08:00 6887. 6919. 6887.
#> 10 btcusd btc          usd           2018-03-31 00:09:00 6921. 6966. 6921.
#> # ... with 4,981 more rows, and 3 more variables: close <dbl>,
#> #   volume <dbl>, volumeNotional <dbl>
```

Also available are meta data with `riingo_crypto_meta()`, and TOP (top
of book) quote data with `riingo_crypto_quote()`.

Lastly, you can extract raw (unaggregated) data feeds from multiple
exchanges by using the `raw = TRUE` argument in the price and quote
crypto function.
