# Description
# HO data XS Nov 2026

# Preliminaries -----------------------------------------------------------
library(here)

# Functions ---------------------------------------------------------------
source(here("packages.R"))
source(here("Functions", "fx_plot.R"))

# Import -------------------------------------------------------------
HO_tbl <- read_excel(here("Data", "HO_Unit_data_Monthly_History", "HO_Unit_data_Monthly_History.xlsx")) 

# Extreme values ----------------------------------------------------------
HO_clean_tbl <- 
  HO_tbl |> 
  mutate(
    across(starts_with("20"), as.numeric),
    across(!starts_with("20"), as.character)
  ) |> 
  tidyr::pivot_longer(-c(1:10), names_to = "date", values_to = "price") |> 
  dplyr::mutate(
    p_low  = quantile(price, 0.01, na.rm = TRUE),
    p_high = quantile(price, 0.99, na.rm = TRUE),
    price    = dplyr::case_when(
      price < p_low  ~ p_low,
      price > p_high ~ p_high,
      TRUE         ~ price
    )
  ) |> 
  dplyr::select(-p_low, -p_high) |> 
  mutate(
    date = parse_date_time(date, "Ym")
  )

# EDA ---------------------------------------------------------------
# HO_clean_tbl |> 
#   DataExplorer::create_report()


# Graphing ---------------------------------------------------------------
HO_distribution_gg <- 
  HO_clean_tbl |> 
  ggplot(aes(x = price )) +
  geom_density(fill = "steelblue") +
  scale_x_log10(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +
  labs(x = "Distribution of HO (R)", y = "Density") +
  facet_wrap( ~ lubridate::year(date), scales = "free") +
  theme_minimal()

HO_distribution_gg
# 
# Export ---------------------------------------------------------------
artifacts_HO <- list (
  HO_tbl = HO_tbl,
  HO_distribution_gg = HO_distribution_gg 

)

write_rds(artifacts_HO, file = here("Outputs", "artifacts_HO.rds"))


