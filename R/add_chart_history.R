#' Adds chart history to a data frame
#'
#' Add artist chart history to a data frame. It is recommended to use this in conjunction with \code{list_artist_charts()}
#' @param df A data frame
#' @param artist Unquote name of the column that contains an artist name
#' @param chart_url Unquoted name of the column that contains the chart_url to search
#' @importFrom dplyr mutate select
#' @importFrom purrr map2
#' @importFrom tidyr unnest
#' @importFrom magrittr %>%
#' @importFrom rlang enquo
#' @export
add_chart_history <- function(df, artist, chart_url) {
  artist <- rlang::enquo(artist)
  chart_url <- rlang::enquo(chart_url)
  df %>%
    mutate(chart_history = map2(
      .x = !!artist, .y = !!chart_url,
      ~get_artist_chart_history(.x, .y)
    )
    ) %>%
    unnest() %>%
    select(-artist1)
}
