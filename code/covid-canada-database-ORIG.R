## ORIGINAL EXPLORATION / TESTING WRITE covid data ta MySQL database

library(tidyverse)
library(RMariaDB)
library(keyring)
library(here)
library(glue)

## make connection to database
con4 <- dbConnect(RMariaDB::MariaDB(), user=,keyring::key_list('starter2')[1,2], password=keyring::key_get('starter2'), dbname='starter2')
dbGetQuery(con4, "SELECT * FROM starter2.covid_test;")

file_load <- here('data','covid-canada-upload.csv')
## didn't work due to file access/upload permissions - only some (none?) locations allowed
dbExecute(con4, paste0("LOAD DATA LOCAL INFILE '",file_load,"' 
                       INTO TABLE covid
                       FIELDS TERMINATED BY ','
                       ENCLOSED BY '\\\"'
                       LINES TERMINATED BY '\\\n'
                       IGNORE 1 ROWS;"))
## convert data frame rows into usable in INSERT
## problem is different data types - can't just convert to vector
v1 <- ccu[[1,1]]
v2 <- ccu[[1,2]]
v3 <- ccu[[1,3]]
v4 <- ccu[[1,4]]
v5 <- ccu[[1,5]]
v6 <- ccu[[1,6]]

## combine values above
i1 <- paste(v1, v2, v3, v4, v5, v6, sep="','")
i1 <- paste0("('",i1,"')")

dbExecute(con4, paste0("INSERT INTO covid_test(pruid, prname, prnameFR, date, numconf, numprob)
          VALUES ", i1))
## check
dbGetQuery(con4, "SELECT * FROM covid_test;")

for(r in 2:4){
  vc1 <- ccu[[r,1]]
  vc2 <- ccu[[r,2]]
  vc3 <- ccu[[r,3]]
  vc4 <- ccu[[r,4]]
  vc5 <- ccu[[r,5]]
  vc6 <- ccu[[r,6]]
  ## combine values above
  ins <- paste(vc1, vc2, vc3, vc4, vc5, vc6, sep="','")
  ## wrap in brackets
  ins <- paste0("('",ins,"')")
  ## INSERT to database table - one row at a time :(
  dbExecute(con4, paste0("INSERT INTO covid_test(pruid, prname, prnameFR, date, numconf, numprob)
          VALUES ", ins))
}


## saving data without 'upgrade' column
cc <- read_csv(here('data','covid-canada.csv'))
ccu <- cc %>% select(-update)
write_csv(ccu, 'data/covid-canada-upload.csv')

## build query same as above - for complete ccu cols
for(r in 1:nrow(ccu)){
  vc1 <- ccu[[r,1]]
  vc2 <- ccu[[r,2]]
  vc3 <- ccu[[r,3]]
  vc4 <- ccu[[r,4]]
  vc5 <- ccu[[r,5]]
  vc6 <- ccu[[r,6]]
  vc7 <- ccu[[r,7]]
  vc8 <- ccu[[r,8]]
  vc9 <- ccu[[r,9]]
  vc10 <- ccu[[r,10]]
  vc11 <- ccu[[r,11]]
  vc12 <- ccu[[r,12]]
  vc13 <- ccu[[r,13]]
  vc14 <- ccu[[r,14]]
  vc15 <- ccu[[r,15]]
  vc16 <- ccu[[r,16]]
  vc17 <- ccu[[r,17]]
  vc18 <- ccu[[r,18]]
  vc19 <- ccu[[r,19]]
  vc20 <- ccu[[r,20]]
  vc21 <- ccu[[r,21]]
  vc22 <- ccu[[r,22]]
  vc23 <- ccu[[r,23]]
  vc24 <- ccu[[r,24]]
  vc25 <- ccu[[r,25]]
  vc26 <- ccu[[r,26]]
  vc27 <- ccu[[r,27]]
  vc28 <- ccu[[r,28]]
  vc29 <- ccu[[r,29]]
  vc30 <- ccu[[r,30]]
  vc31 <- ccu[[r,31]]
  vc32 <- ccu[[r,32]]
  vc33 <- ccu[[r,33]]
  vc34 <- ccu[[r,34]]
  vc35 <- ccu[[r,35]]
  vc36 <- ccu[[r,36]]
  vc37 <- ccu[[r,37]]
  vc38 <- ccu[[r,38]]
  vc39 <- ccu[[r,39]]
 
  ## alternate
## get list of cols to use in query
fields <- paste0(names(ccu[1:11]), collapse=", ")
## use glue to get list in form that can be used for query values
fields2 <- paste0("('{",paste0(names(ccu[1:11]), collapse="}', '{"),"}')")
vals <- ccu[9,1:11] %>% glue_data(fields2)
## replace 'NA' with NULL for query
vals <- vals %>% str_replace_all('NA',"x NULL x")
vals <- vals %>% str_remove_all("'x ")
vals <- vals %>% str_remove_all(" x'")
  ## INSERT to database table - one row at a time :(
  dbExecute(con4, paste0("INSERT INTO covid_test(",fields,")
          VALUES ", vals))
}
## for real
## get list of cols to use in query
fields <- paste0(names(ccu), collapse=", ")
## with glue
fields2 <- paste0("('{",paste0(names(ccu), collapse="}', '{"),"}')")
vals <- ccu[5:6,] %>% glue_data(fields2)

## INSERT to database table - one row at a time :(
dbExecute(con4, paste0("INSERT INTO covid_test(",fields,")
          VALUES ", vals))

## using dplyr SQL - recommended for read, not insert
ccu_test <- tbl(con4, "covid_test")
