## WRITE covid data ta MySQL database

library(tidyverse)
library(RMariaDB)
library(keyring)
library(here)

## make connection to database
con4 <- dbConnect(RMariaDB::MariaDB(), user=,keyring::key_list('starter2')[1,2], password=keyring::key_get('starter2'), dbname='starter2')
dbExecute(con4, "SELECT * FROM starter2.covid_test;")

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
