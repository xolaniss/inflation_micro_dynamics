# Description
# domestic worker wages (UIF) - XS Nov 2026

# TODO -----------------------------
# Some sort of missing identifier or a way to plot the data

# Preliminaries -----------------------------------------------------------
library(here)
library(tidytable)

# Functions ---------------------------------------------------------------
source(here("packages.R"))
source(here("Functions", "fx_plot.R"))


# Import and clean -------------------------------------------------------------
dww_tbl <- read_excel(here("Data", "DDW metadata", "DWW_Unit_data_Monthly_History.xlsx")) |> 
  tidytable::pivot_longer(-employerId, names_to = "date", values_to = "ddw") |> 
  tidytable::mutate(date = str_remove_all(date, "Payment_"),
         date = parse_date_time(date, "Ym"),
         date = as.Date(date)
  ) |> 
  tidytable::pivot_wider(id_cols = employerId, values_from = ddw, names_from = date)
  
# EDA ---------------------------------------------------------------
dww_tbl |> 
  DataExplorer::create_report()

# Graphing ---------------------------------------------------------------


# Export ---------------------------------------------------------------
artifacts_domestic_worker_wages <- list (
  dww_tbl = dww_tbl

)

write_rds(artifacts_domestic_worker_wages, file = here("Outputs", "artifacts_domestic_worker_wages.rds"))


