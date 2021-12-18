
library(tidyverse)
library(plotly)

covid <- read_csv("https://health-infobase.canada.ca/src/data/covidLive/covid19-download.csv")

covid %>% filter(prname=='British Columbia') %>%
  ggplot(aes(x=date, y=numdeaths))+geom_line()

cplot <- covid %>% filter(prname=='British Columbia') %>%
  ggplot(aes(x=date, y=numdeathstoday))+geom_line()

ggplotly(cplot)