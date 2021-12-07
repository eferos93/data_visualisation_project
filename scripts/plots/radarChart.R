# devtools::install_github("ricardo-bion/ggradar", dependencies = TRUE) # ggradar
library(ggradar)
library(tidyverse) # pivot_wider
theme_set(theme_bw())

data <- read.csv("processed_data/2.historical_data_1998_2013_per_professional_category.csv", header = TRUE)

# select which years display in the radar plot
relevant_years <- c("2004", "2006", "2008", "2010", "2012")

cat("Do you want to use this deafult set of relevant years? ", relevant_years,"\n",sep=" ")
answer_to_years <- scan(what = "string")
if(answer_to_years == "no"){
  print('Which years do you want to plot? [1998, 2013]')
  relevant_years <- scan() %>% sapply(function(x) as.character(x)) # from integer to string
}
paste(c("Relevant Years: ", relevant_years), collapse=" ")

valid_colour_set <- FALSE
while(valid_colour_set == FALSE){
  print("Which configuration for colours do yo want to adopt?")
  print("1. Use Gradient of red colour")
  if(answer_to_years == "yes"){
    print("2. Use colours focused on crisis")
  }
  print("3. Use my custom set of coours")

  answer_to_colours <- scan(what="string")
  if(answer_to_colours == "1"){
    baseline_colours <- c('#67000d', '#fb6a4a') # gradient of red colour
    valid_colour_set <- TRUE
  }else if(answer_to_years == "yes" && answer_to_colours == "2"){
    baseline_colours <- c('#bdbdbd', '#969696', '#ef3b2c', '#a50f15', '#525252') # colours focused on crisis
    valid_colour_set <- TRUE
  }else if(answer_to_colours == "3"){
    print("provide set of RGB colours:")
    # #67000d #fc9272 #ef3b2c
    baseline_colours <- scan(what = "string") #  #ef3b2c  #a50f15  #fc9272
    valid_colour_set <- TRUE
  }else{
    paste(c(answer_to_colours, " is not a valid configuration, please select a valid one.", collapse=" "))
  }
}

# grid ranges for spider plot
grid.min <- min(data[data$Year %in% relevant_years, ]$Avg.People.Per.Quarter) # min value = 0 or min number of travels
grid.mid <- mean(data[data$Year %in% relevant_years, ]$Avg.People.Per.Quarter)
grid.max <- max(data[data$Year %in% relevant_years, ]$Avg.People.Per.Quarter)
print(paste("grid.min:", grid.min, "\n", "grid.mid:", grid.mid, "\n", "grid.max", grid.max))

# pivot table: Professional.Status columns, Year rows indexes and Avg.People.Per.Quarter values
pivot_data <- pivot_wider(data[data$Year %in% relevant_years, ], id_cols = Year,
                          names_from = Professional.Status,
                          values_from = Avg.People.Per.Quarter)

# function: set the umbrella of colours for the radar plot
set_gg_radar_colours <- function (standard, relevant_years, pivot_data, colours_vector){
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

# define colours
custom_colours <- set_gg_radar_colours(TRUE, relevant_years, pivot_data, baseline_colours)

ggradar(pivot_data,
        # grid.min = grid.min,
        grid.mid = grid.mid,
        grid.max = grid.max,
        label.gridline.min = FALSE, # display percentage
        label.gridline.mid = FALSE, # display percentage
        label.gridline.max = FALSE, # display percentage
        background.circle.colour = "#FFFFFF",
        plot.extent.x.sf = 2.5, # extention of image along the x axis
        axis.line.colour = "gray60",
        axis.label.size = 5,
        gridline.min.colour = "gray60",
        gridline.mid.colour = "gray60",
        gridline.max.colour = "gray60",
        legend.title = "Years",
        legend.position = "left",
        # plot.title = 'TITLE',
        group.colours = custom_colours,
        group.point.size = 3, # not possible to set point size for each target attribute from ggradar
        group.line.width = 2
)
