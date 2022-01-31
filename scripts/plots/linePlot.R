library(tidyverse)

theme_set(theme_bw())
data <- read.csv("processed_data/1.historical_data_1998_2013_type_of_journey.csv")
data$Travel.Type <- factor(data$Travel.Type)
data$Travel.Type <- factor(data$Travel.Type, levels = c("long holiday (4 or more nights)", "short holiday (1-3 nights)", "business trip"))

data %>%
  ggplot(aes(x = factor(Year), y = Avg.People.Per.Quarter, group = factor(Travel.Type))) +
  geom_line(aes(color = Travel.Type)) +
  geom_vline(xintercept = 11, linetype = "longdash", color = "black", alpha = 0.5) +
  geom_vline(xintercept = 15, linetype = "longdash", color = "black", alpha = 0.5) +
  theme(text=element_text(family = "Corbel"), legend.position = "none", axis.text = element_text(size = 14)) +
  scale_color_manual(values = c("#1b9e77", "#d95f02", "#7570b3")) +
  # geom_text(aes(x = 10.5, label = "Finalcial Crisis", y = 7.5), color = "black", size = 5) +
  # geom_text(aes(x = 14.5, label = "Spending Review", y = 5), color = "black", size = 5) +
  labs(
    title = "",
    caption = "Data Source: http://dati.istat.it/",
    x = "",
    y = "",
    color = ""
  )
  # geom_errorbar(aes(ymin = Avg.People.Per.Quarter-Sd.People.Per.Quarter, ymax = Avg.People.Per.Quarter+Sd.People.Per.Quarter))
