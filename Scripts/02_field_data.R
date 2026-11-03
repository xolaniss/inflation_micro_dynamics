# Description
# Statssa field data - Nov XS

# Notes -------------------------------------------------------------------
## 2025 marked the COICOP classification change - this is significants


# Preliminaries -----------------------------------------------------------
library(here)

# Functions ---------------------------------------------------------------
source(here("packages.R"))
source(here("Functions", "fx_plot.R"))

# Import -------------------------------------------------------------
sheet_names <- excel_sheets(here("Data", "Field (2008 to 2016) metadata", "FIELD_UNIT_DATA_Monthly_HISTORY.xlsx"))

field <- 
  sheet_names |> 
  purrr::map( ~read_excel(here("Data", "Field (2008 to 2016) metadata", "FIELD_UNIT_DATA_Monthly_HISTORY.xlsx"), sheet = .x)) |> 
  set_names(sheet_names) |> 
  purrr::map(~ .x |> 
        mutate(
          across(starts_with("M"), as.numeric),
          across(!starts_with("M"), as.character)
        )
  ) |>  # turning to correct col format
  purrr::map(
    ~.x |> 
      janitor::clean_names()
  )

# Split each sheet into one element per year ------------------------------
field_yearly <- 
  field |> 
  purrr::map(function(df) {
    month_cols <- str_subset(names(df), "^m\\d{6}$")
    
    month_cols |> 
      split(str_sub(month_cols, 2, 5)) |> 
      purrr::map(~ select(df, -all_of(month_cols), all_of(.x)))
  }) |> 
  purrr::list_flatten(name_spec = "{inner}") |> 
  purrr::map(
    ~.x |> 
      pivot_longer(-!starts_with("m"), names_to = "date", values_to = "price") |> 
      mutate(date = str_remove_all(date, "m"),
             date = paste0(date, "-01"),
             date = ymd(date)
             )
  )

# EDA ---------------------------------------------------------------
# field_yearly |> map(~glimpse(.x))
# field_yearly |> map(~DataExplorer::create_report(.x))


# Plotting ----------------------------------------------------------------

# Common x range so years are comparable
price_range <- 
  field_yearly |> 
  map(~ range(.x$price[.x$price > 0], na.rm = TRUE)) |> 
  unlist() |> 
  range()

field_density_gg <- 
  field_yearly |> 
  map(
    ~ .x |> 
      ggplot(aes(x = price)) +
      geom_density(fill = "steelblue") +
      scale_x_log10(
        limits = price_range,
        breaks = 10^c(0, 2, 4, 6),
        labels = c("1", "100", "10K", "1M")
      ) +
      labs(x = "Distribution of Products (R)", y = "Density") +
      facet_wrap(~ lubridate::year(date)) +
      theme_minimal(base_size = 8)
  ) |> 
  wrap_plots(ncol = 4) +
  plot_layout(axes = "collect", axis_titles = "collect")

field_density_gg


# Export ---------------------------------------------------------------
artifacts_field <- list (
  field_yearly = field_yearly
)

write_rds(artifacts_field, file = here("Outputs", "artifacts_field.rds"))


