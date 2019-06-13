#' Search Billboard Charts
#'
#' Retrieve information from a Billboard chart.
#'
#' @param chart_url The url indicating the chart to search. See \code{bbchart::chart_table} for all available charts.
#' @importFrom lubridate floor_date
#' @importFrom rvest html_session html_nodes html_text
#' @importFrom purrr map pluck
#' @importFrom stringr str_split str_trim
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
bb_chart <- function(chart_url, date = Sys.Date()) {

  chart_date <- floor_date(date, "weeks")


  ifelse(chart_url %in%  bbchart::bad_charts,
         {
           base_url <- paste("https://www.billboard.com/charts", chart_url, sep = "/")
           warning("Chart does not use a date, `date` arg will be ignored.", call. = FALSE)
         },
         base_url <- paste("https://www.billboard.com/charts", chart_url, chart_date, sep = "/")
  )

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
    date = chart_date,
    artist = artist,
    featured_artist = featured_artist,
    title = title,
    chart = names(chart_lookup[chart_lookup == chart_url])
  )

  return(results)

}
