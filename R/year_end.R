#' Search Year End Billboard Charts
#'
#' Retrieve a year end Billboardchart
#'
#' @param chart_url The url indicating the chart to search. See \code{bbcharts::ye_chart_table} for all available charts.
#' @param chart_year Specify the year of interest.
#' @importFrom rvest html_session html_nodes html_text html_node
#' @importFrom purrr map pluck
#' @importFrom stringr str_split str_trim
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#' @export
year_end_bb <- function(chart_url, chart_year) {

  base_url <- paste("https://www.billboard.com/charts/year-end", chart_year, chart_url, sep = "/")

  session <- html_session(base_url)

  title <- session %>%
    html_nodes(".ye-chart-item__title") %>%
    html_text(trim = TRUE)

  artist_info <- session %>%
    html_nodes(".ye-chart-item__artist") %>%
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
    html_nodes(".ye-chart-item__rank") %>%
    html_text(trim = TRUE) %>%
    as.integer() %>%
    unlist()


  results <- tibble(
    rank = rank,
    year = chart_year,
    chart = names(ye_chart_lookup[ye_chart_lookup == chart_url]),
    artist = artist,
    featured_artist = featured_artist,
    title = title
  )

  return(results)
}

