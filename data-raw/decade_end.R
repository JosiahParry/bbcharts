library(bbcharts)
library(tidyverse)

#------------------------------------------------------------------------------#
#                          create decade end lookups                           #
#------------------------------------------------------------------------------#
de_session <- html_session("https://www.billboard.com/charts/decade-end")

de_unique_charts <- de_session %>%
  html_nodes(".chart-panel__link") %>%
  html_attr("href") %>%
  str_remove("\\/charts\\/decade-end\\/")


de_chart_names <- de_session %>%
  html_nodes(".chart-panel__link .chart-panel__text") %>%
  html_text(trim = TRUE) %>%
  str_squish()

de_chart_table <- tibble(chart_name = de_chart_names, chart_url = de_unique_charts)



de_chart_lookup <- de_unique_charts %>%
  setNames(de_chart_names)

#------------------------------------------------------------------------------#
#                      create df of all decade end charts                      #
#------------------------------------------------------------------------------#
decade_end <- map_dfr(de_chart_lookup, decade_end_bb)


#-------------------------------- clean charts --------------------------------#
decade_end <- decade_end %>%
  mutate(artist = case_when(
    chart == "Top Artists" ~ title,
    artist == "" ~ title,
    TRUE ~ artist
  ),
  #  artist = ifelse(artist == "", NA, artist),
  title = case_when(
    chart == "Top Artists" ~ NA_character_,
    artist == title ~ NA_character_,
    TRUE ~ title
  )
  )


#------------------------------------------------------------------------------#
#                            write to package data                             #
#------------------------------------------------------------------------------#
usethis::use_data(de_chart_lookup, de_chart_table, decade_end, overwrite = TRUE)


