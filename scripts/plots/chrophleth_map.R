library(devtools)
devtools::install_github("ropensci/rnaturalearthhires")
library(rnaturalearthhires)
library(tidyverse)
library(gganimate)
library(rnaturalearth)
library(gifski)
library(extrafont)
font_import()
# loadfonts(device = )


dataset <-
  read.csv("processed_data/3.historical_data_1998_2013_year_avg_per_geographical_area.csv")

italy_map <- ne_states(country = "Italy", returnclass = "sf")
italy_map <- italy_map %>%
  select(province = name, region, geometry)

italy_map_areas <- italy_map %>%
  group_by(region) %>%
  summarise(n = n()) %>%
  select(-n) %>%
  mutate(area =
           recode(region,
                  Abruzzo = "South",
                  Campania = "South",
                  Liguria = "North",
                  Piemonte = "North",
                  "Trentino-Alto Adige" = "North",
                  Apulia = "South",
                  "Emilia-Romagna" = "North",
                  Lombardia = "North",
                  Sardegna = "South",
                  Umbria = "Center",
                  Basilicata = "South",
                  "Friuli-Venezia Giulia" = "North",
                  Marche = "Center",
                  Sicily = "South",
                  "Valle d'Aosta" = "North",
                  Calabria = "South",
                  Lazio = "Center",
                  Molise = "South",
                  Toscana = "Center",
                  Veneto = "North"
           )) %>%
  group_by(area) %>%
  summarise(n = n())

temp <- italy_map_areas %>%
  inner_join(dataset, by = c("area" = "Geographical.Area")) %>%
  select(-n) %>%
  arrange(Year)

plot3 <-
  ggplot(temp, aes(fill = Percentage.People.Traveled)) +
    transition_manual(frames = Year) +
    geom_sf() +
    scale_fill_gradient(
      low = "#fff7ec", high = "#7f0000",
      name = "% of travellers"
    ) +
    theme_void(base_size = 20, base_family = "Corbel") +
    labs(
      title = "Travel Trends Variations in Italian Geographical Areas",
      subtitle = "Year: {frame+1997}",
      caption ="Data source: http://dati.istat.it/"
    )

plot3

animate(plot3, height = 1000, width = 1000)
anim_save("plots/3chrophlet.gif")