## WRITE covid data ta MySQL database

library(tidyverse)
library(RMariaDB)
library(lubridate)
library(keyring)
library(here)
library(glue)

## GET DATA
## saving data without 'upgrade' column
cc <- read_csv(here('data','covid-canada.csv'))
ccu <- cc %>% select(-update)
write_csv(ccu, 'data/covid-canada-upload.csv')

## make connection to database
con <- dbConnect(RMariaDB::MariaDB(), user=,keyring::key_list('starter2')[1,2], password=keyring::key_get('starter2'), dbname='starter2')
## CALL dbDisconnect() when finished
# dbDisconnect()
#dbGetQuery(con, "SELECT * FROM starter2.covid;")

db_max_date <- dbGetQuery(con, "SELECT MAX(date) FROM covid")
ccu_max_date <- max(ccu$date)

## GET DATA SINCE LAST DB UPDATE
ccu_up <- ccu %>% filter(date>db_max_date[[1]])

## Set up for INSERT
## get list of cols to use in query
fields <- paste0(names(ccu_up), collapse=", ")
## use glue to get list in form that can be used for query values
## - set up field name structure
fields_val <- paste0("('{",paste0(names(ccu_up), collapse="}', '{"),"}')")

## INSERT to database table - one row at a time :(
for(r in 1:nrow(ccu_up)){
  ## use glue to get values based on field names in proper format (esp. dates)
  vals <- ccu_up[r,] %>% glue_data(fields_val)
  ## replace 'NA' with NULL for query
  vals <- vals %>% str_replace_all('N/A','NA') ## rare cases
  vals <- vals %>% str_replace_all('NA',"x NULL x")
  vals <- vals %>% str_remove_all("'x ")
  vals <- vals %>% str_remove_all(" x'")
  dbExecute(con, paste0("INSERT INTO covid(",fields,")
          VALUES ", vals))
  print(paste0(r, " ", ccu_up$pruid[r], " ", ccu_up$prname[r], " ", ccu_up$date[r]))
}
dbDisconnect(con)
