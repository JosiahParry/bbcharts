
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bbcharts

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/bbcharts)](https://cran.r-project.org/package=bbcharts)
<!-- badges: end -->

The goal of bbcharts is to provide an interface to the Billboards top
charts.

## Installation

You can install the latest version of bbcharts from GitHub with:

``` r
remotes::install_github("josiahparry/bbcharts")
```

## Example

The “Hot 100” Billboard Chart

``` r
library(bbcharts)

bb_chart("hot-100")
#> # A tibble: 100 x 6
#>     rank date       artist        featured_artist title              chart 
#>    <int> <date>     <chr>         <chr>           <chr>              <chr> 
#>  1     1 2019-06-09 Lil Nas X     Billy Ray Cyrus Old Town Road      The H…
#>  2     2 2019-06-09 Billie Eilish <NA>            Bad Guy            The H…
#>  3     3 2019-06-09 Khalid        <NA>            Talk               The H…
#>  4     4 2019-06-09 Ed Sheeran &… <NA>            I Don't Care       The H…
#>  5     5 2019-06-09 Jonas Brothe… <NA>            Sucker             The H…
#>  6     6 2019-06-09 Post Malone   <NA>            Wow.               The H…
#>  7     7 2019-06-09 Post Malone … <NA>            Sunflower (Spider… The H…
#>  8     8 2019-06-09 DaBaby        <NA>            Suge               The H…
#>  9     9 2019-06-09 Sam Smith & … <NA>            Dancing With A St… The H…
#> 10    10 2019-06-09 Ava Max       <NA>            Sweet But Psycho   The H…
#> # … with 90 more rows
```

Use `bbcharts` in conjunction with
[`genius`](https://github.com/josiahparry/genius) to get the lyrics for
songs on the top charts.

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(genius)
alt <- bb_chart("alternative-songs")

alt_lyrics <- alt %>% 
  # get only the first 5 songs
  slice(1:5) %>% 
  # add lyrics to a data frame
  add_genius(artist, title, type = "lyrics")
#> Joining, by = c("rank", "date", "artist", "featured_artist", "title", "chart")

alt_lyrics
#> # A tibble: 199 x 9
#>     rank date       artist featured_artist title chart track_title  line
#>    <int> <date>     <chr>  <chr>           <chr> <chr> <chr>       <int>
#>  1     1 2019-06-09 SHAED  <NA>            Tram… Alte… Trampoline      1
#>  2     1 2019-06-09 SHAED  <NA>            Tram… Alte… Trampoline      2
#>  3     1 2019-06-09 SHAED  <NA>            Tram… Alte… Trampoline      3
#>  4     1 2019-06-09 SHAED  <NA>            Tram… Alte… Trampoline      4
#>  5     1 2019-06-09 SHAED  <NA>            Tram… Alte… Trampoline      5
#>  6     1 2019-06-09 SHAED  <NA>            Tram… Alte… Trampoline      6
#>  7     1 2019-06-09 SHAED  <NA>            Tram… Alte… Trampoline      7
#>  8     1 2019-06-09 SHAED  <NA>            Tram… Alte… Trampoline      8
#>  9     1 2019-06-09 SHAED  <NA>            Tram… Alte… Trampoline      9
#> 10     1 2019-06-09 SHAED  <NA>            Tram… Alte… Trampoline     10
#> # … with 189 more rows, and 1 more variable: lyric <chr>
```

## List possible charts

You can view all possible charts to query from using the `chart_table`
that is exported.

``` r
bbcharts::chart_table
#> # A tibble: 134 x 2
#>    chart_name                chart_url         
#>    <chr>                     <chr>             
#>  1 The Hot 100               hot-100           
#>  2 Billboard 200             billboard-200     
#>  3 Artist 100                artist-100        
#>  4 Radio Songs               radio-songs       
#>  5 Digital Song Sales        digital-song-sales
#>  6 Streaming Songs           streaming-songs   
#>  7 Songs Of The Summer       summer-songs      
#>  8 On-Demand Streaming Songs on-demand-songs   
#>  9 Top Album Sales           top-album-sales   
#> 10 Digital Albums            digital-albums    
#> # … with 124 more rows
```
