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
    filter(Professional.Status != "occupato" &
             Professional.Status != "non occupato" &
             Professional.Status != "totale" &
             Professional.Status != "lavoratore in proprio, coadiuvante familiare, co.co.co.") %>%
    mutate(Professional.Status = recode(Professional.Status,
                                        "casalinga-o" = "homemaker",
                                        "direttivo, quadro, impiegato" = "BOD, employees",
                                        "dirigenti, imprenditori, liberi professionisti" = "managers, entrepreneur, freelancers",
                                        "disoccupato alla ricerca di nuova occupazione" = "unemployed looking for a job",
                                        "in altra condizione" = "retired or in other status",
                                        "in cerca di prima occupazione" = "unemployed looking for a job",
                                        "operaio, apprendista" = "worker, apprentice",
                                        "ritirato-a dal lavoro" = "retired or in other status",
                                        "studente" = "student"
    )) %>%
    group_by(Year, Quarter, Professional.Status) %>%
    summarise(Percentage.People.Traveled = sum(Percentage.People.Traveled)) %>%
    ungroup() %>%
    group_by(Year, Professional.Status) %>%
    summarise(Avg.People.Per.Quarter = round(mean(Percentage.People.Traveled), digits = 1),
              Sd.People.Per.Quarter = round(sd(Percentage.People.Traveled), digits = 1)) %>%
    ungroup() %>%
    arrange(Year, Professional.Status)

write.csv(finalDataset, file = "processed_data/2.historical_data_1998_2013_per_professional_category.csv", row.names = FALSE)