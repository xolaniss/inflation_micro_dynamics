# Description
# rentals data - XS 
# Preliminaries -----------------------------------------------------------
library(here)

# Functions ---------------------------------------------------------------
source(here("packages.R"))
source(here("Functions", "fx_plot.R"))

# Import -------------------------------------------------------------
rental_tbl <- read_excel(here("Data", "Rental metadata", "Rental_Unit_data_Monthly_History.xlsx"))


# Clean -------------------------------------------------------------------
rental_clean_tbl <- 
  rental_tbl |> 
  janitor::clean_names() |> 
  mutate(
    across(starts_with('m'), as.numeric),
    across(!starts_with('m'), as.character)
  ) |> 
  pivot_longer(-c(1:7), names_to = "date", values_to = 'price') |> 
  mutate(
    date = str_remove_all(date, "m"),
    date = parse_date_time(date, "Ym")
  )

# EDA ---------------------------------------------------------------
# rental_tbl |> 
#   DataExplorer::create_report()

# Graphing ---------------------------------------------------------------
rental_clean_tbl |> 
  ggplot(aes(x = price )) +
  geom_density(fill = "steelblue") +
  scale_x_log10(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +
  labs(x = "Distribution of Rentals (R)", y = "Density") +
  facet_wrap( ~ lubridate::year(date), scales = "free") +
  theme_minimal()


# Export ---------------------------------------------------------------
artifacts_rentals <- list (
  rental_tbl = rental_tbl
)

write_rds(artifacts_rentals, file = here("Outputs", "artifacts_rentals.rds"))


