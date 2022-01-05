## Get virus data
## from https://www.worldometers.info/coronavirus/ 

## load pkgs
library(tidyverse)
library(rvest)
library(lubridate)

## identify URL to scrape from 
data_url <- "https://www.worldometers.info/coronavirus/"

## read in html as xml
wp_xml <- read_html(data_url)
#print(wp_xml)

data_xpath <- "//*[(@id = 'main_table_countries_today')]"
data_node <- html_node(x=wp_xml, xpath=data_xpath)
data_xpath_y <- "//*[(@id = 'main_table_countries_yesterday')]"
data_node <- html_node(x=wp_xml, xpath=data_xpath_y)

## get tabular data from html into data frame
df_data <- html_table(data_node)
## check structure
str(df_data)
## clean data
df_data <- df_data %>% rename(
  Country=`Country,Other`
)
df_data$TotalCases <- as.numeric(str_remove_all(df_data$TotalCases,","))
df_data$NewCases <- as.numeric(str_remove_all(df_data$NewCases,","))
#df_data$NewCases <- as.numeric(str_remove_all(df_data$NewCases,"//+"))
df_data$TotalDeaths <- as.numeric(str_remove_all(df_data$TotalDeaths,","))
df_data$NewDeaths <- as.numeric(str_remove_all(df_data$NewDeaths,","))
#df_data$NewDeaths <- as.numeric(str_remove_all(df_data$NewDeaths,"//+"))
df_data$TotalRecovered <- as.numeric(str_remove_all(df_data$TotalRecovered,","))
df_data$ActiveCases <- as.numeric(str_remove_all(df_data$ActiveCases,","))
df_data$Serious <- as.numeric(str_remove_all(df_data$`Serious,Critical`,","))
df_data$TotalCasespMp <- as.numeric(str_remove_all(df_data$`Tot Cases/1M pop`,","))
df_data$DeathspMp <- as.numeric(str_remove_all(df_data$`Deaths/1M pop`,","))
df_data$TotalTests <- as.numeric(str_remove_all(df_data$TotalTests,","))
df_data$TestspMp <- as.numeric(str_remove_all(df_data$`Tests/1M pop`,","))
## remove fields that have been replaced with cleaner names
df_data <- df_data %>% select(-`Serious,Critical`,-`Tot Cases/1M pop`,
                              -`Deaths/1M pop`, -`Tests/1M pop`)
## add date - yesterday
df_data$date <- as.character(Sys.Date()-1) 

## check structure again
str(df_data)

## save
write_csv(df_data,'data/corona-wom-data.csv') 
write_csv(df_data, paste0('data/corona-wom-data_',Sys.Date(),'.csv'))
