library(tidyverse)
library(rvest)
library(lubridate)

session <- html_session("https://www.billboard.com/charts")

unique_charts <- session %>%
  html_nodes(".chart-panel__link") %>%
  html_attr("href") %>%
  str_remove("/charts/")


chart_names <- session %>%
  html_nodes(".chart-panel__link .chart-panel__text") %>%
  html_text(trim = TRUE) %>%
  str_squish()

chart_table <- tibble(chart_name = chart_names, chart_url = unique_charts)



chart_lookup <- unique_charts %>%
  setNames(chart_names)


# create rough bb_chart fx for testing. has since been adapted
bb_chart <- function(chart, date = Sys.Date()) {

  chart_date <- floor_date(date, "weeks")

  base_url <- paste("https://www.billboard.com/charts", chart, chart_date, sep = "/")

  session <- html_session(base_url)

  title <- session %>%
    html_nodes(".chart-list-item__title") %>%
    html_text(trim = TRUE)


  artist_info <- session %>%
    html_nodes(".chart-list-item__artist") %>%
    html_text(trim = TRUE)

  artist <- str_split(artist_info, "Featuring") %>%
    map(str_trim) %>%
    map(purrr::pluck, 1) %>%
    unlist()

  featured_artist <- str_split(artist_info, "Featuring") %>%
    map(str_trim) %>%
    map(purrr::pluck, 2) %>%
    map(~ifelse(is.null(.), NA, .)) %>%
    unlist()

  rank <- session %>%
    html_nodes(".chart-list-item__rank") %>%
    html_text(trim = TRUE) %>%
    as.integer() %>%
    unlist()

  results <- tibble(
    rank = rank,
    artist = artist,
    featured_artist = featured_artist,
    title = title
  )

  return(results)

}


# test all different charts. identify which ones break
chart_test <- chart_lookup %>%
  map(~ {

    f <- possibly(bb_chart, otherwise = tibble())
    f(.)
  })


# these are due to having incompatible dates. must handle accordingly
bad_charts <- chart_lookup[map_lgl(chart_test, ~nrow(.) == 0)]


# write exported data
usethis::use_data(chart_table)

# write internal data
usethis::use_data(chart_lookup, bad_charts, internal = TRUE)
