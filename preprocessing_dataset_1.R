library(dplyr)
library(tidyr)

data <- read.csv("./raw_data/1.historical_data_1998_2013_type_of_journey.csv", header = TRUE)

processeData <-
  data %>%
    select(Tipo.di.viaggio, TIME, Value) %>%
    separate(TIME, c("Year", "Quarter"), "-") %>%
    rename(Travel.Type = Tipo.di.viaggio) %>%
    mutate(Travel.Type = recode(Travel.Type,
                                "vacanza breve (1-3 notti)" = "short holiday (1-3 nights)",
                                "vacanza lunga (4 o più notti)" = "long holiday (4 or more nights)",
                                "viaggio di lavoro" = "business trip")) %>%
    group_by(Year, Travel.Type) %>%
    summarise(Percentage.people.traveled = mean(Value)) %>%
    ungroup()

write.csv(processedData, "./processed_data/1.historical_data_1998_2013_type_of_journey.csv", row.names = FALSE)

