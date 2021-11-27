library(ggradar) # ggradar
library(tidyverse) # pivot_wider
theme_set(theme_bw())

data <- read.csv("processed_data/2.historical_data_1998_2013_per_professional_category.csv", header = TRUE)

# select which years display in the radar plot
relevant_years <- c("1998", "2002", "2006", "2010", "2013")

# grid ranges for spider plot
# grid.min <- min(data[data$Year %in% relevant_years, ]$Avg.People.Per.Quarter) # min value = 0 or min number of travels
grid.mid <- mean(data[data$Year %in% relevant_years, ]$Avg.People.Per.Quarter)
grid.max <- max(data[data$Year %in% relevant_years, ]$Avg.People.Per.Quarter)

# pivot table: Professional.Status columns, Year rows indexes and Avg.People.Per.Quarter values
pivot_data <- pivot_wider(data[data$Year %in% relevant_years, ], id_cols = Year,
                          names_from = Professional.Status,
                          values_from = Avg.People.Per.Quarter)

# function: set the umbrella of colours for the radar plot
set_colours <- function (standard, relevant_years, pivot_data, colours_vector){
  colours <- colorRampPalette(colours_vector)(nrow(pivot_data))
  if(standard == FALSE){
    radar_order_by_colours <- data.frame(Year = relevant_years, Mean = rowMeans(pivot_data))
    radar_order_by_colours <- radar_order_by_colours[order(radar_order_by_colours$Mean), ]
    radar_order_by_colours$Colours <- colours
    radar_order_by_colours <- radar_order_by_colours[order(radar_order_by_colours$Year), ]
    colours <- radar_order_by_colours$Colours
  }
  return(colours)
}

custom_colours <- set_colours(FALSE, relevant_years, pivot_data, c("#67000d", "#fb6a4a"))

ggradar(pivot_data,
        # grid.min = grid.min,
        grid.mid = grid.mid,
        grid.max = grid.max,
        label.gridline.min = FALSE, # display percentage
        label.gridline.mid = FALSE, # display percentage
        label.gridline.max = FALSE, # display percentage
        # background.circle.colour = "#FFFFFF",
        plot.extent.x.sf = 2.5, # extention of image along the x axis
        axis.line.colour = "gray60",
        axis.label.size = 5,
        gridline.min.colour = "gray60",
        gridline.mid.colour = "gray60",
        gridline.max.colour = "gray60",
        legend.title = "Year",
        legend.position = "bottom",
        # plot.title = 'TITLE',
        group.colours = custom_colours,
        group.point.size = 0,
        group.line.width = 2
)
