
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
#> # A tibble: 100 x 9
#>     rank date       chart artist featured_artist title last_position
#>    <int> <date>     <chr> <chr>  <chr>           <chr>         <int>
#>  1     1 2019-06-09 The … Lil N… Billy Ray Cyrus Old …             1
#>  2     2 2019-06-09 The … Billi… <NA>            Bad …             2
#>  3     3 2019-06-09 The … Khalid <NA>            Talk              3
#>  4     4 2019-06-09 The … Ed Sh… <NA>            I Do…             4
#>  5     5 2019-06-09 The … Jonas… <NA>            Suck…             5
#>  6     6 2019-06-09 The … Post … <NA>            Wow.              7
#>  7     7 2019-06-09 The … Post … <NA>            Sunf…             6
#>  8     8 2019-06-09 The … DaBaby <NA>            Suge              9
#>  9     9 2019-06-09 The … Sam S… <NA>            Danc…             8
#> 10    10 2019-06-09 The … Ava M… <NA>            Swee…            10
#> # … with 90 more rows, and 2 more variables: peak_position <int>,
#> #   weeks_on_chart <int>
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
#> Joining, by = c("rank", "date", "chart", "artist", "featured_artist", "title", "last_position", "peak_position", "weeks_on_chart")

alt_lyrics
#> # A tibble: 199 x 12
#>     rank date       chart artist featured_artist title last_position
#>    <int> <date>     <chr> <chr>  <chr>           <chr>         <int>
#>  1     1 2019-06-09 Alte… SHAED  <NA>            Tram…             1
#>  2     1 2019-06-09 Alte… SHAED  <NA>            Tram…             1
#>  3     1 2019-06-09 Alte… SHAED  <NA>            Tram…             1
#>  4     1 2019-06-09 Alte… SHAED  <NA>            Tram…             1
#>  5     1 2019-06-09 Alte… SHAED  <NA>            Tram…             1
#>  6     1 2019-06-09 Alte… SHAED  <NA>            Tram…             1
#>  7     1 2019-06-09 Alte… SHAED  <NA>            Tram…             1
#>  8     1 2019-06-09 Alte… SHAED  <NA>            Tram…             1
#>  9     1 2019-06-09 Alte… SHAED  <NA>            Tram…             1
#> 10     1 2019-06-09 Alte… SHAED  <NA>            Tram…             1
#> # … with 189 more rows, and 5 more variables: peak_position <int>,
#> #   weeks_on_chart <int>, track_title <chr>, line <int>, lyric <chr>
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

## Artist Specific Chart Data

There are a number of functions that provide Billboard chart data for a
specific artist.

### Listing artist charts

It is possible to list all of the charts that a given artist appears on
using `list_artist_charts()`.

``` r
list_artist_charts("Andrew Bird")
#> # A tibble: 10 x 3
#>    artist      chart                 chart_url            
#>    <chr>       <chr>                 <chr>                
#>  1 Andrew Bird Top Rock Albums       rock-albums          
#>  2 Andrew Bird Alternative Albums    alternative-albums   
#>  3 Andrew Bird Americana/Folk Albums americana-folk-albums
#>  4 Andrew Bird Top Album Sales       top-album-sales      
#>  5 Andrew Bird Digital Albums        digital-albums       
#>  6 Andrew Bird Vinyl Albums          vinyl-albums         
#>  7 Andrew Bird Independent Albums    independent-albums   
#>  8 Andrew Bird Catalog Albums        catalog-albums       
#>  9 Andrew Bird Tastemakers           tastemaker-albums    
#> 10 Andrew Bird Triple A Songs        triple-a
```

### Artist songs on a specific chart

Using the information above we can list all of the songs on a chart from
a given artist using `get_artist_chart_history()`. In this case we will
look at Triple A Songs (adult alternative).

``` r
get_artist_chart_history("Andrew Bird", "triple-a")
#> # A tibble: 3 x 4
#>   artist      title                    peak_date  peak_rank
#>   <chr>       <chr>                    <date>         <int>
#> 1 Andrew Bird Capsized                 2016-05-14         6
#> 2 Andrew Bird Fitz And The Dizzyspells 2009-04-11        17
#> 3 Andrew Bird Sisyphus                 2019-04-27        26
```

### All chart information for a given artist

We can use the `add_chart_history()` function in conjunction with
`list_artist_charts()` to get all chart history for an artist.

``` r
list_artist_charts("Andrew Bird") %>% 
  add_chart_history(artist = artist, chart_url = chart_url)
#> # A tibble: 45 x 6
#>    artist    chart         chart_url       title       peak_date  peak_rank
#>    <chr>     <chr>         <chr>           <chr>       <date>         <int>
#>  1 Andrew B… Top Rock Alb… rock-albums     Break It Y… 2012-03-24         3
#>  2 Andrew B… Top Rock Alb… rock-albums     Noble Beast 2009-02-07         3
#>  3 Andrew B… Top Rock Alb… rock-albums     Are You Se… 2016-04-23         8
#>  4 Andrew B… Top Rock Alb… rock-albums     Hands Of G… 2012-11-17        15
#>  5 Andrew B… Top Rock Alb… rock-albums     Armchair A… 2007-04-07        21
#>  6 Andrew B… Top Rock Alb… rock-albums     My Finest … 2019-04-06        26
#>  7 Andrew B… Alternative … alternative-al… Are You Se… 2016-04-23         5
#>  8 Andrew B… Alternative … alternative-al… My Finest … 2019-04-06        13
#>  9 Andrew B… Americana/Fo… americana-folk… Break It Y… 2012-03-24         1
#> 10 Andrew B… Americana/Fo… americana-folk… Are You Se… 2016-04-23         1
#> # … with 35 more rows
```

You can also do this for any mix of artists.

``` r
tribble(
  ~artist, ~chart,
  "Andrew Bird", "triple-a",
  "Taylor Swift", "hot-100"
) %>% 
  add_chart_history(artist, chart)
#> # A tibble: 81 x 5
#>    artist      chart   title                           peak_date  peak_rank
#>    <chr>       <chr>   <chr>                           <date>         <int>
#>  1 Andrew Bird triple… Capsized                        2016-05-14         6
#>  2 Andrew Bird triple… Fitz And The Dizzyspells        2009-04-11        17
#>  3 Andrew Bird triple… Sisyphus                        2019-04-27        26
#>  4 Taylor Swi… hot-100 Shake It Off                    2014-09-06         1
#>  5 Taylor Swi… hot-100 Blank Space                     2014-11-29         1
#>  6 Taylor Swi… hot-100 Bad Blood                       2015-06-06         1
#>  7 Taylor Swi… hot-100 We Are Never Ever Getting Back… 2012-09-01         1
#>  8 Taylor Swi… hot-100 Look What You Made Me Do        2017-09-16         1
#>  9 Taylor Swi… hot-100 You Belong With Me              2009-08-22         2
#> 10 Taylor Swi… hot-100 I Knew You Were Trouble.        2013-01-12         2
#> # … with 71 more rows
```
