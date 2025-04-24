renv::install()
renv::status()
renv::snapshot()
library(rio)
library(tidyverse)

# Read raw data
dat_path <- "https://github.com/reconhub/learn/raw/master/static/data/linelist_20140701.xlsx"
dat <- rio::import(file = dat_path) %>%
  tibble::as_tibble()

# Clean raw data
dat_clean <- dat %>%
  dplyr::select(case_id, date_of_onset, date_of_outcome, outcome) %>%
  dplyr::mutate(dplyr::across(
    .cols = c(date_of_onset, date_of_outcome),
    .fns = as.Date
  )) %>%
  dplyr::mutate(
    outcome = fct(outcome, level = c("Death", "Recover"), na = "NA")
  )

# Write clean data
dat_clean %>%
  readr::write_rds("outputs/linelist_clean.rds")