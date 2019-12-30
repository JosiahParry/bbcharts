gen_chart_url <- function(chart_url, date = Sys.Date()) {

  chart_date <- lubridate::floor_date(as.Date(date), "weeks")


  ifelse(chart_url %in% bad_charts,
         {
           base_url <- paste("https://www.billboard.com/charts", chart_url, sep = "/")
           usethis::ui_warn("Chart does not use a date, `date` will be ignored.")
         },
         base_url <- paste("https://www.billboard.com/charts", chart_url, chart_date, sep = "/")
  )

  base_url
}
