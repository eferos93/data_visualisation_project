library(tidyverse)

theme_set(theme_bw())
data <- read.csv("processed_data/1.historical_data_1998_2013_type_of_journey.csv")

data %>%
  ggplot(aes(x = factor(Year), y = Avg.People.Per.Quarter, group = Travel.Type , color = Travel.Type)) +
  geom_line() +
  labs(
    title = "Average Number of People every 100 that Traveled per Year",
    caption = "Data Source: http:// dati.istat.it/",
    x = "Year",
    y = "Average number of people"
  )
  # geom_errorbar(aes(ymin = Avg.People.Per.Quarter-Sd.People.Per.Quarter, ymax = Avg.People.Per.Quarter+Sd.People.Per.Quarter))
