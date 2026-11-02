# Description
# domestic worker wages (UIF) - XS Nov 2026

# TODO -----------------------------


# Preliminaries -----------------------------------------------------------
library(here)
library(dplyr)

# Functions ---------------------------------------------------------------
source(here("packages.R"))
source(here("Functions", "fx_plot.R"))


# Import  -------------------------------------------------------------
dww_tbl <- read_excel(here("Data", "DDW metadata", "DWW_Unit_data_Monthly_History.xlsx"))


# Clean -------------------------------------------------------------------
dww_clean_tbl <- 
  dww_tbl |> 
  tidyr::pivot_longer(-employerId, names_to = "date", values_to = "dww") |> 
  dplyr::mutate(date = str_remove_all(date, "Payment_"),
         date = parse_date_time(date, "Ym"),
         date = as.Date(date)
  ) |> 
  dplyr::mutate(
    p_low  = quantile(dww, 0.05, na.rm = TRUE),
    p_high = quantile(dww, 0.95, na.rm = TRUE),
    dww    = dplyr::case_when(
      dww < p_low  ~ p_low,
      dww > p_high ~ p_high,
      TRUE         ~ dww
    )
  ) |> # winsorize at 1%
  dplyr::select(-p_low, -p_high) |> 
  mutate(dww = dww * 100/2) # converting to overall domestic worker wage

# Aggregate ---------------------------------------------------------------
dww_aggregate_tbl <- 
  dww_clean_tbl |> 
  dplyr::select(-employerId) |>  # dropping the individual IDs
  dplyr::group_by(date) |>
  dplyr::summarise(dww_avg = mean(dww, na.rm = TRUE), .groups = "drop") 

dww_aggregate_gg <- 
  dww_aggregate_tbl|> 
  ggplot(aes(x = date, y = dww_avg)) +
  geom_line() + 
  labs(x = "", y = "Average domestic worker wage (R)") +
  theme_minimal()

dww_aggregate_gg

# Distritbution -----------------------------------------------------------
dww_distribution_gg <- 
  dww_clean_tbl |> 
  ggplot(aes(x = dww, y = after_stat(count / sum(count)))) + 
  geom_histogram(bins = 30, fill = "steelblue", color = "white") +
  # Formats the scale numbers neatly as 10%, 20%, etc.
  scale_y_continuous(labels = scales::percent_format()) +
  labs(x = "Distribution of domestic worker wage (R)", y = "Percentage of Total") +
  facet_wrap( ~ lubridate::year(date), scales = "free") +
  theme_minimal()

dww_distribution_gg

# Export ---------------------------------------------------------------
artifacts_domestic_worker_wages <- list (
  dww_clean_tbl = dww_clean_tbl,
  dww_aggregate_gg <- dww_aggregate_gg,
  dww_distribution_gg = dww_distribution_gg
)

write_rds(artifacts_domestic_worker_wages, file = here("Outputs", "artifacts_domestic_worker_wages.rds"))


