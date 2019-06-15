#' Billboard Chart history for a given artist
#'
#' List Billboard Chart history for a given artist and chart.
#'
#' @param artist The name of an artist
#' @param chart_url The url indicating the chart to search.
#' @importFrom rvest html_session html_text html_nodes
#' @importFrom stringr str_replace_all str_detect str_extract
#' @importFrom lubridate mdy
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#' @importFrom glue glue
#' @export
get_artist_chart_history <- function(artist, chart_url) {
  artist_url <- str_replace_all(artist, " ", "-")
  base_url <- glue::glue("https://www.billboard.com/music/{artist_url}/chart-history/{chart_url}")
  session <- html_session(base_url)

  # save chart stats object to identify how many songs there are
  chart_stats <- html_nodes(session, ".artist-section--chart-history__stats__stat") %>%
    html_text()

  # use chart stats to identify how many pages need to be iterated through
  n_pages <- chart_stats[str_detect(chart_stats, "[0-9+] Songs")] %>%
    str_extract("[0-9]+") %>%
    as.integer() %>% {
      ceiling(./10)
    }

  # if there is no n_pages, make the n_pages value = 1
  n_pages <- ifelse(length(n_pages) == 0, 1, n_pages)

  # iterate through all pages and create a data frame
  chart_results <- purrr::map_dfr(1:n_pages, ~{
    chart_url <- glue::glue("{base_url}/{.}")

    session <- html_session(chart_url)

    chart_songs <- session %>%
      html_nodes(".artist-section--chart-history__title-list__title__text--title") %>%
      html_text(trim = TRUE)

    peak_date <- session %>%
      html_nodes(".artist-section--chart-history__title-list__title__text--peak-rank .date") %>%
      html_text() %>%
      mdy()

    peak_rank <- session %>%
      html_nodes(".artist-section--chart-history__title-list__title__text--peak-rank") %>%
      html_text() %>%
      str_extract("[0-9]+") %>%
      as.integer()


    tibble(
      artist = artist,
      title = chart_songs,
      peak_date = peak_date,
      peak_rank = peak_rank
    )

  })

  return(chart_results)

}
