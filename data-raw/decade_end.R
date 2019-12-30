de_session <- html_session("https://www.billboard.com/charts/decade-end")

de_unique_charts <- de_session %>%
  html_nodes(".chart-panel__link") %>%
  html_attr("href") %>%
  str_remove("\\/charts\\/year-end\\/[0-9]{4}/")


de_chart_names <- de_session %>%
  html_nodes(".chart-panel__link .chart-panel__text") %>%
  html_text(trim = TRUE) %>%
  str_squish()

de_chart_table <- tibble(chart_name = de_chart_names, chart_url = de_unique_charts)



de_chart_lookup <- de_unique_charts %>%
  setNames(de_chart_names)

usethis::use_data(de_chart_lookup, de_chart_table)
