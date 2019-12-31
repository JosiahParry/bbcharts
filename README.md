
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bbcharts

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/bbcharts)](https://cran.r-project.org/package=bbcharts)
<!-- badges: end -->

`bbcharts` provides an interface to the Billboards top charts. There is
functionality for accessing weekly charts, annual charts, and the decade
end data is exported as an object `bbcharts::decade_end`.

## Installation

You can install the latest version of bbcharts from GitHub with:

``` r
remotes::install_github("josiahparry/bbcharts")
```

## Decade End Charts

``` r
count(bbcharts::decade_end, artist, sort = TRUE)
```

## Year End Charts

View all possible year end charts with `ye_chart_table`

``` r
bbcharts::ye_chart_table
```

Identify which chart you would like then pass along that `chart_url` to
`year_end_bb()` and the year you would like it for. Due to slight
inconsistencies between charts, i.e. album, artist, and song charts, the
artist and title fields may be swapped around.

``` r
year_end_bb("hot-100-songs", 1960)
```

## Weekly Charts

You can retrieve weekly charts in a very similar manner as the yearly
charts. To view the weekly charts use `bbcharts::chart_table`

``` r
chart_table
```

Provide the name of the chart you want and the week you want it for in
`yyyy-mm-dd` format.

``` r
bb_chart("hot-100", "2017-12-10")
```

## {bbcharts} + {genius}

Use `bbcharts` in conjunction with
[`genius`](https://github.com/josiahparry/genius) to get the lyrics for
songs on the top charts.

``` r
library(dplyr)
library(genius)
alt <- bb_chart("alternative-songs")

alt_lyrics <- alt %>% 
  # get only the first 5 songs
  slice(1:5) %>% 
  # add lyrics to a data frame
  add_genius(artist, title, type = "lyrics")

alt_lyrics
```

## List possible charts

You can view all possible charts to query from using the `chart_table`
that is exported.

``` r
bbcharts::chart_table
```

## Artist Specific Chart Data

There are a number of functions that provide Billboard chart data for a
specific artist.

### Listing artist charts

It is possible to list all of the charts that a given artist appears on
using `list_artist_charts()`.

``` r
list_artist_charts("Andrew Bird")
```

### Artist songs on a specific chart

Using the information above we can list all of the songs on a chart from
a given artist using `get_artist_chart_history()`. In this case we will
look at Triple A Songs (adult alternative).

``` r
get_artist_chart_history("Andrew Bird", "triple-a")
```

### All chart information for a given artist

We can use the `add_chart_history()` function in conjunction with
`list_artist_charts()` to get all chart history for an artist.

``` r
list_artist_charts("Andrew Bird") %>% 
  add_chart_history(artist = artist, chart_url = chart_url)
```

You can also do this for any mix of artists.

``` r
tribble(
  ~artist, ~chart,
  "Andrew Bird", "triple-a",
  "Taylor Swift", "hot-100"
) %>% 
  add_chart_history(artist, chart)
```
