
library(tidyverse)
library(plotly)

## get latest data for Canada by province
## from https://open.canada.ca/data/en/dataset/261c32ab-4cfd-4f81-9dea-7b64065690dc
covid <- read_csv("https://health-infobase.canada.ca/src/data/covidLive/covid19-download.csv")
data_dict <- read_csv("https://health-infobase.canada.ca/src/data/covidLive/covid19-data-dictionary.csv")

## check
str(covid)
summary(covid)

## check metrics
## is numconf same as numtotal? YES
covid %>% filter(prname=='Canada' & date>='2021-11-01') %>% 
  select(prname, date, numconf, numtotal) %>%
  pivot_longer(cols=c(numconf, numtotal), names_to='metric', values_to='number') %>% 
  ggplot(aes(x=date, y=number, fill=metric))+
  #geom_col(position='dodge')
  geom_col(aes(y=number), position=position_dodge2())

## is percentoday increase in cases over previous day? cumulative? NO
covid %>% filter(prname=='Canada' & date>='2021-11-01') %>% 
  select(prname, date, numconf, numtoday, percentoday) %>% 
  mutate(num_conf_pc_chg=round((numconf/lag(numconf)-1)*100, digits=2), ## YES
         numtoday_pc_chg=round((numtoday/lag(numtoday)-1)*100, digits=2), ## NO
         numtdconf_pc_chg=round((numtoday/lag(numconf))*100, digits=2), ## YES
         numtoday_pc_pop=numtoday*(1/percentoday))

## save
write_csv(covid, "data/covid-canada.csv")

## BC deaths total
covid %>% filter(prname=='British Columbia') %>%
  ggplot(aes(x=date, y=numdeaths))+geom_line()

## BC deaths by day
cplot_bc_case <- covid %>% filter(prname=='British Columbia') %>%
  ggplot(aes(x=date, y=numdeathstoday))+geom_line()
ggplotly(cplot_bc_case)

## daily cases by province
cplot2 <- covid %>% filter(prname!='Canada') %>% ggplot(aes(x=date, y=numtoday, color=prname))+geom_line()
ggplotly(cplot2)

cplot_case_ttl <- covid %>% filter(prname!='Canada') %>% ggplot(aes(x=date, y=numconf, color=prname))+geom_line()
ggplotly(cplot_case_ttl)

cplot_death_day <- covid %>% filter(prname!='Canada') %>% ggplot(aes(x=date, y=numdeathstoday, color=prname))+geom_line()
ggplotly(cplot_deaths_day)