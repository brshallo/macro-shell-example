library(tidyverse)

source(here::here("R", "funs.R"))

#### SIMULATE AND WRITE OUT DEAL

create_deal(10) %>% 
  write_csv(here::here("data-spreadsheet", "deal_example.csv"))

### PREP & RUN SHELL SCRIPT

wrapper_loc_norm <- normalizePath(here::here("vbs", "run_vba.vbs"))

vba_loc <- here::here("data-spreadsheet", "deal_calculator.xlsm")
vba_loc_norm <- normalizePath(vba_loc)

# Run VBA via VBS wrapper
shell_script_for_vbs <- paste("cscript",
      wrapper_loc_norm,
      glue::glue('/xlPath:"{vba_loc_norm}"'),
      sep = " ")

system(shell_script_for_vbs, wait = TRUE)

### READ BACK-IN OUTPUTS FROM VBA / SPREADSHEET LOGIC

readxl::read_excel(vba_loc_norm, 
                   sheet = "deal_calcs", 
                   range = "I4", 
                   col_names = "deal_net_present_value")
