# ANIMATE YOUR SCIENCE VISUAL STORYTELLING WORKSHOP (2023)
# PREPROCESSING DATA SCRIPT FOR THE NOVEMBER EVALUATION
# JEN BEAUDRY

#### LOAD LIBRARY ####

library(here)
library(tidyverse)

source(here("..", "functions", "read_qualtrics.R"))
source(here("..", "functions", "meta_rename.R"))

#### LOAD DATA ####

df <- here::here("data", "sci_comm_raw_data.csv") %>%
  read_qualtrics(legacy = FALSE) %>%
 filter(!is.na(ratings_1)) %>%  # delete those who didn't answer any questions
  select(-c("start_date":"user_language", "sc0")) %>%
  mutate(id = 1:n()) %>%
  relocate(id)

# [breadcrumb: check that the filter variable is NA for only those who skipped all items]

# load metadata

meta <- read_csv(here::here("data", "sci_comm_metadata.csv"), lazy = FALSE) %>%
  filter(old_variable != "NA", old_variable != "exclude") # remove the instruction variables


##### RECODE VARIABLES #####

# recode variable labels according to metadata

df <- meta_rename(df = df, metadata = meta, old = old_variable, new = new_variable)



#### WRITE DATA ####

# when done preprocessing, write the data to new files
# row.names gets rid of the first column from the dataframe.

write.csv(df, here::here("data", "sci_comm_processed_data.csv"), row.names = FALSE)


