library(devtools)
library(remotes)
devtools::install_github("ropensci/rnaturalearthhires")
remotes::install_version("Rttf2pt1", version = "1.3.8")
library(rnaturalearthhires)
library(tidyverse)
library(gganimate)
library(rnaturalearth)
library(gifski)



library(extrafont)
font_import(pattern = "corbel")
loadfonts(device = "win")




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
  arrange(Year) %>%
  mutate(Percentage.People.Traveled.Label = paste0(round(Percentage.People.Traveled, 0), "%"))

plot3 <-
  ggplot(temp, aes(fill = Percentage.People.Traveled)) +
    transition_time(Year) +
    geom_sf() +
    geom_sf_text(aes(label = Percentage.People.Traveled.Label),
                 colour = "black", size = 10, family = "Corbel") +
    scale_fill_gradient(
      low = "#fff7ec", high = "#7f0000",
      name = "% of travellers"
    ) +
    theme_void(base_size = 28, base_family = "Corbel") +
    labs(
      title = "Even during a recession, northern Italians travel more",
      subtitle = "Year: {frame_time}",
      caption ="Data source: http://dati.istat.it/"
    )

plot3 + ease_aes(interval = 10)

animate(plot3 + ease_aes(interval = 10000), fps = 7, detail = 50, height = 1000, width = 1000)
anim_save("plots/3chrophlet.gif")