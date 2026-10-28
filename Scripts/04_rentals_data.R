# Description

# Preliminaries -----------------------------------------------------------
library(here)

# Functions ---------------------------------------------------------------
source(here("packages.R"))
source(here("Functions", "fx_plot.R"))

# Import -------------------------------------------------------------
rental_tbl <- read_excel(here("Data", "Rental metadata", "Rental_Unit_data_Monthly_History.xlsx"))

# EDA ---------------------------------------------------------------


# Graphing ---------------------------------------------------------------


# Export ---------------------------------------------------------------
artifacts_rentals <- list (
  rental_tbl = rental_tbl
)

write_rds(artifacts_rentals, file = here("Outputs", "artifacts_rentals.rds"))


