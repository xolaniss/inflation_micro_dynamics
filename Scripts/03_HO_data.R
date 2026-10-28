# Description

# TODO
# Deal with extreme values

# Preliminaries -----------------------------------------------------------
library(here)


# Functions ---------------------------------------------------------------
source(here("packages.R"))
source(here("Functions", "fx_plot.R"))

# Import -------------------------------------------------------------
HO_tbl <- read_excel(here("Data", "HO_Unit_data_Monthly_History", "HO_Unit_data_Monthly_History.xlsx")) 

# EDA ---------------------------------------------------------------
HO_tbl |> 
  DataExplorer::create_report()


unique(HO_tbl$`COICOP 2018 description`)
# Graphing ---------------------------------------------------------------


# Export ---------------------------------------------------------------
artifacts_HO <- list (
  HO_tbl = HO_tbl

)

write_rds(artifacts_HO, file = here("Outputs", "artifacts_HO.rds"))


