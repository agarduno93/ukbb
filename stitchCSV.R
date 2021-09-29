rm(list=ls())
library(dplyr)
library(readr)
df <- list.files(path="Stanford Scratch Path",
                 full.names = TRUE) %>%
  lapply(read_csv) %>%
  bind_rows
