library(tidyverse)

theme_set(theme_bw())
data <- read.csv("processed_data/1.historical_data_1998_2013_type_of_journey.csv")

data %>%
  ggplot(aes(x = factor(Year), y = Avg.People.Per.Quarter, group = Travel.Type)) +
  geom_line(aes(color = Travel.Type)) +
  geom_vline(xintercept = 11, linetype = "longdash", color = "grey") +
  geom_vline(xintercept = 15, linetype = "longdash", color = "grey") +
  geom_text(aes(x = 10.5, label = "Finalcial Crisis", y = 7.5), color = "grey", size = 5) +
  geom_text(aes(x = 14.5, label = "Spending Review", y = 5), color = "grey", size = 5) +
  labs(
    title = "Average Number of People every 100 that Traveled per Year",
    caption = "Data Source: http://dati.istat.it/",
    x = "Year",
    y = "Average number of people"
  )
  # geom_errorbar(aes(ymin = Avg.People.Per.Quarter-Sd.People.Per.Quarter, ymax = Avg.People.Per.Quarter+Sd.People.Per.Quarter))
