# Description

# Preliminaries -----------------------------------------------------------
library(here)

# Functions ---------------------------------------------------------------
source(here("packages.R"))
source(here("Functions", "fx_plot.R"))

# Import -------------------------------------------------------------
sheet_names <- excel_sheets(here("Data", "Field (2008 to 2016) metadata", "FIELD_UNIT_DATA_Monthly_HISTORY.xlsx"))

fieldsheet_names <- 
  sheet_names |> 
  tidytable::map( ~read_excel(here("Data", "Field (2008 to 2016) metadata", "FIELD_UNIT_DATA_Monthly_HISTORY.xlsx"), sheet = .x)) |> 
  set_names(sheet_names)


# EDA ---------------------------------------------------------------


# Graphing ---------------------------------------------------------------


# Export ---------------------------------------------------------------
artifacts_field <- list (
  fieldsheet_names = fieldsheet_names
)

write_rds(artifacts_field, file = here("Outputs", "artifacts_field.rds"))


