library(dplyr)

# "persone che hanno viaggiato. Media annuale - valori per 100 abitanti"
rawData <- read.csv("raw_data/3.historical_data_1998_2013_year_avg_per_geographical_area.csv")

finalData <- rawData %>%
  select(TIME, Territorio, Value) %>%
  rename(Year = TIME, Geographical.Area = Territorio, Percentage.People.Traveled = Value) %>%
  mutate(Geographical.Area = recode(Geographical.Area,
    Nord = "North",
    Centro = "Center",
    Mezzogiorno = "South"
  ))

write.csv(finalData, file = "processed_data/3.historical_data_1998_2013_year_avg_per_geographical_area.csv", row.names = FALSE)
