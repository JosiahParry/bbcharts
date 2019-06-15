#' List Charts that an Artist Appears on
#'
#' View all charts that an artist appears on.
#' @param artist The name of an artist
#' @return A tibble with the name of the artist, the charts that they appear on, and the chart-url for said chart.
#' @importFrom stringr str_replace_all str_remove_all
#' @importFrom glue glue
#' @importFrom rvest html_session html_nodes html_attr html_text
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#' @export
list_artist_charts <- function(artist) {
  artist_url <- str_replace_all(artist, " ", "-")

  session <- html_session(glue::glue("https://www.billboard.com/music/{artist_url}"))

  artist_charts <- session %>%
    html_nodes(".chart-history-dropdown__list__chart") %>%
    html_text(trim = TRUE)

  artist_chart_url <- session %>%
    html_nodes(".chart-history-dropdown__list__chart a") %>%
    html_attr("href")


  return(
    tibble(
      artist = artist,
      chart = artist_charts,
      chart_url = str_remove_all(artist_chart_url, glue::glue("/music/{artist_url}/chart-history/"))
    )
  )
}
