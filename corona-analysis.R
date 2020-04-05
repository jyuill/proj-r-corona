## Analyze Corona Data
## from: https://www.worldometers.info/coronavirus/
## imported using: get-data-worldometers.R

library(tidyverse)
library(lubridate)
library(scales)
library(PerformanceAnalytics)

## import latest data saved
df_corona <- read_csv('data/corona-wom-data.csv')

df_corona_sel <- df_corona %>% filter(Country!='World')
df_corona_sel <- df_corona %>% filter(TotalCases<100)

## check correlations
cor.test(df_corona_sel$TotalCasespMp, df_corona_sel$TestspMp)

chart.Correlation(df_corona_sel[,c(10:12)], histogram = TRUE)
