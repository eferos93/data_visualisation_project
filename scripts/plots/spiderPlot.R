library(ggradar) # ggradar
library(tidyverse) # pivot_wider
theme_set(theme_bw())

data <- read.csv("processed_data/2.historical_data_1998_2013_per_professional_category.csv", header = TRUE)

# grid ranges for spider plot
grid.max <- max(data$Avg.People.Per.Quarter)
grid.min <- min(data$Avg.People.Per.Quarter)
grid.mid <- mean(data$Avg.People.Per.Quarter)

# pivot table: Professional.Status columns, Year rows indexes and Avg.People.Per.Quarter values
pivot_data <- pivot_wider(data, id_cols = Year,
                          names_from = Professional.Status,
                          values_from = Avg.People.Per.Quarter)

ggradar(pivot_data, grid.min = grid.min, grid.mid = grid.min, grid.max = grid.max,
        background.circle.colour = "white",
        axis.line.colour = "gray60",
        gridline.min.colour = "gray60",
        gridline.mid.colour = "gray60",
        gridline.max.colour = "gray60",
        legend.title = "Year",
        legend.position = "right",
        plot.title = 'TITLE', )
