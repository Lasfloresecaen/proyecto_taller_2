rcompendium::new_compendium() 
usethis::use_tidy_support() 
renv::init()

rcompendium::add_renv()


renv::status()

renv::snapshot()


# Load packages------------

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

renv::status()

renv::install()


# Load packages-------------------
library(tidyverse)
library(incidence2)

# Read data
ebola_dat <- readr::read_rds("outputs/linelist_clean.rds")

# Create incidence2 object
ebola_onset <-
  incidence2::incidence(
    x = ebola_dat,
    date_index = c("date_of_onset"),
    interval = "epiweek"
  )

# Read incidence2 object
ebola_onset

# Plot incidence data
plot(ebola_onset)

# Write ggplot as figure
ggsave("figures/02-plot_incidence.png", height = 3, width = 5)


source(here::here("analyses", "01-clean.R"))
source(here::here("analyses", "02-plot.R"))


install.packages("cffr")
library(cffr)
cffr::cff_write()
