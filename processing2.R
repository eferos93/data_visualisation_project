library(dplyr)
library(tidyr)

# persone che hanno viaggiato - valori per 100 abitanti con le stesse caratteristiche
filteredDataset <-
  read.csv("raw_data/2.historical_data_1998_2013_per_professional_category.csv") %>%
    select(TIME, Condizione.professionale, Value) %>%
    rename(Year.Quarter = TIME, Professional.Status = Condizione.professionale, Percentage.People.Traveled = Value) %>%
    separate(Year.Quarter, c("Year", "Quarter"), sep = "-") %>%
    arrange(Year, Quarter)

finalDataset <-
  filteredDataset %>%
    filter(Professional.Status != "occupato" & Professional.Status != "non occupato" & Professional.Status != "totale") %>%
    mutate(Professional.Status = case_when(
      Professional.Status == "casalinga-o" ~ "homemaker",
      Professional.Status == "direttivo, quadro, impiegato" ~ "BOD, employees",
      Professional.Status == "dirigenti, imprenditori, liberi professionisti" ~ "managers, entrepreneur, freelancers",
      Professional.Status == "disoccupato alla ricerca di nuova occupazione" ~ "unemployed looking for a job",
      Professional.Status == "in altra condizione" ~ "other status",
      Professional.Status == "in cerca di prima occupazione" ~ "unemployed looking for a job",
      Professional.Status == "lavoratore in proprio, coadiuvante familiare, co.co.co." ~ "managers, entrepreneur, freelancers",
      Professional.Status == "operaio, apprendista" ~ "worker, apprentice",
      Professional.Status == "ritirato-a dal lavoro" ~ "other status",
      Professional.Status == "studente" ~ "student"
    )) %>%
    group_by(Year, Quarter, Professional.Status) %>%
    summarise(Percentage.People.Traveled = sum(Percentage.People.Traveled)) %>%
    ungroup() %>%
    group_by(Year, Professional.Status) %>%
    summarise(Percentage.People.Traveled = mean(Percentage.People.Traveled)) %>%
    ungroup() %>%
    arrange(Year, Professional.Status)

write.csv(finalDataset, file = "processed_data/2.historical_data_1998_2013_per_professional_category", row.names = FALSE)