library(tidyverse)

data <- read.csv("processed_data/1.historical_data_1998_2013_type_of_journey.csv")

data %>%
  ggplot(aes(x = Year, y = Avg.People.Per.Quarter, group = Travel.Type , color = Travel.Type)) +
  geom_line() +
  geom_point() +
  geom_errorbar(aes(ymin = Avg.People.Per.Quarter-Sd.People.Per.Quarter, ymax = Avg.People.Per.Quarter+Sd.People.Per.Quarter))
