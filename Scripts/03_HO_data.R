# Description

# Preliminaries -----------------------------------------------------------
library(here)

# Functions ---------------------------------------------------------------
source(here("packages.R"))
source(here("Functions", "fx_plot.R"))

# Import -------------------------------------------------------------
HO_tbl <- read_excel(here("Data", "HO_Unit_data_Monthly_History", "HO_Unit_data_Monthly_History.xlsx")) 



# EDA ---------------------------------------------------------------


# Graphing ---------------------------------------------------------------


# Export ---------------------------------------------------------------
artifacts_HO <- list (
  HO_tbl = HO_tbl

)

write_rds(artifacts_HO, file = here("Outputs", "artifacts_HO.rds"))


