library(shiny)
library(googlesheets4)
library(janitor)
library(dplyr)
library(tidyr)
library(gsheet)
library(lubridate)
library(synthpop)

options(warn = -1)

ESM <-gsheet2tbl('https://docs.google.com/spreadsheets/d/1grnrXPY2i8W73XHphScS3P0UcTvhw3BNEzlGYLVwJ4M/edit?resourcekey=&gid=698980028#gid=698980028')
#this guy has a cool little way to import from sheets. I am completely in love with how easy this was
# Source - https://stackoverflow.com/a/28986107
# Posted by Max Conway
# Retrieved 2026-02-05, License - CC BY-SA 3.0
#https://github.com/maxconway/gsheet


ESM <- ESM %>%
  mutate(num_name = case_when(
    `Who are you` == "Cailey" ~ 0,
    `Who are you` == "Ethan" ~ 1
  )) %>%
  clean_names()
#now its numeric, and there are no spaces in the names. Now I want to assign different names

ESM <- ESM %>%
  mutate(Extraversion = in_the_last_30_minutes_how_extraverted_have_you_felt,
         Agreeableness = in_the_last_30_minutes_how_agreeable_have_you_felt,
         Conscientiousness = in_the_last_30_minutes_how_conscientious_have_you_felt,
         Emotional_Stability = in_the_last_30_minutes_how_emotionally_stable_have_you_felt,
         Openness = in_the_last_30_minutes_how_creative_have_you_felt)

#now I am dropping the duplicated names
ESM <- ESM %>%
  select(c("Extraversion","Agreeableness","Conscientiousness","Emotional_Stability","Openness","timestamp","who_are_you","num_name"))

#Last thing I want to do is convert the timestamp data into something workable. I need to think more about this.
ESM <- ESM %>%
  mutate(date_time = mdy_hms(all_of(timestamp))) # I got this mdy_hms function technique from here: https://github.com/rstudio/cheatsheets/blob/main/lubridate.pdf

ESM <- ESM %>%
  mutate(hour = hour(date_time))
#now I have a variable that takes the hour the data was collected from. This baby is good to go.


  synthetic_dataset <- syn(ESM, k=1000)
write.syn(synthetic_dataset, filename = "my_synthetic_data", filetype = "csv")
syn_data <- read.csv("my_synthetic_data.csv")


