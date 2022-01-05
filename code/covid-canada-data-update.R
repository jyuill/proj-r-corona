## Get Updated Covid data
library(tidyverse)
library(here)

## Source
## Govt Canada website: https://health-infobase.canada.ca/src/data/covidLive/covid19-download.csv

## Check if refreshed recently; update if not
## back-up existing
covid_bu <- read_csv('data/covid-canada.csv')

## if latest data in file is not newer than day before yesterday, refresh
#if(file.info('data/covid-canada.csv')$mtime<Sys.time()-(60*60*24)){
if(max(covid_bu$date)<Sys.Date()-1){
  covid_src <- read_csv('https://health-infobase.canada.ca/src/data/covidLive/covid19-download.csv')
  write_csv(covid_src, 'data/covid-canada.csv')
}
