#' Search Billboard Charts
#'
#' Retrieve information from a Billboard chart.
#'
#' @param chart_url The url indicating the chart to search. See \code{bbcharts::chart_table} for all available charts.
#' @param date Get chart data for a specificed date (YYYY-MM-DD).
#' @importFrom lubridate floor_date
#' @importFrom rvest html_session html_nodes html_text html_node
#' @importFrom purrr map pluck
#' @importFrom stringr str_split str_trim
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#' @export
bb_chart <- function(chart_url, date = Sys.Date()) {

  chart_date <- floor_date(as.Date(date), "weeks")


  ifelse(chart_url %in% bad_charts,
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

  last_week_position <- session %>%
    html_nodes(".chart-list-item__extra-info") %>%
    html_node(".chart-list-item__stats .chart-list-item__last-week") %>%
    html_text(trim = TRUE) %>%
    as.integer()


  peak_position <- session %>%
    html_nodes(".chart-list-item__extra-info") %>%
    html_node(".chart-list-item__stats .chart-list-item__weeks-at-one") %>%
    html_text(trim = TRUE) %>%
    as.integer()

  weeks_on_chart <- session %>%
    html_nodes(".chart-list-item__extra-info") %>%
    html_node(".chart-list-item__stats .chart-list-item__weeks-on-chart") %>%
    html_text(trim = TRUE) %>%
    as.integer()

  results <- tibble(
    rank = rank,
    date = chart_date,
    chart = names(chart_lookup[chart_lookup == chart_url]),
    artist = artist,
    featured_artist = featured_artist,
    title = title,
    last_position = last_week_position,
    peak_position = peak_position,
    weeks_on_chart = weeks_on_chart
  )

  return(results)

}
