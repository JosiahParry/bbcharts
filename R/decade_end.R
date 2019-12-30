#' Search Decade End Billboard Charts
#'
#' Retrieve the Billboard decade end charts.
#'
#' @param chart_url The url indicating the chart to search. See \code{bbcharts::de_chart_table} for all available charts.
#' @importFrom rvest html_session html_nodes html_text html_node
#' @importFrom purrr map pluck
#' @importFrom stringr str_split str_trim
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#' @export
#'

decade_end_bb <- function(chart_url) {

  base_url <- paste("https://www.billboard.com/charts/decade-end", chart_url, sep = "/")

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
    #year = chart_year,
    chart = names(de_chart_lookup[de_chart_lookup == paste0("/charts/decade-end/", chart_url)]),
    artist = artist,
    featured_artist = featured_artist,
    title = title
  )

  return(results)
}

