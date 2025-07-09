

### Clear memory
rm(list = ls())

# Libraries ===========================================
library(ggplot2)   
library(dplyr)     
library(gtsummary) 


# Load the built-in 'economics' dataset from ggplot2
data("economics")

# Create a modified version of the dataset
economics_mod <- economics %>%
  mutate(
    year = format(date, "%Y"),                   # Extract the year from the date
    decada = paste0(substr(year, 1, 3), "0s")     # Create a 'decade' variable (e.g., "1970s")
  )


# Generate a summary table of selected variables grouped by decade
tabla_econ <- economics_mod %>%
  select(decada, pce, psavert, uempmed, unemploy) %>%   
  tbl_summary(
    by = decada,                                         
    statistic = list(all_continuous() ~ "{mean} ({sd})"),
    digits = all_continuous() ~ 1,                       
    missing = "no"                                       
  ) %>%
  modify_caption("**Summary of macroeconomic indicators by decade**") %>%
  add_overall()  

# Display the table
tabla_econ


# Scatter plot showing the relationship between unemployment and personal saving rate
ggplot(economics, aes(x = unemploy, y = psavert)) +
  geom_point(alpha = 0.6) +                             
  geom_smooth(method = "lm", se = FALSE, color = "darkblue") + 
  labs(
    title = "Relationship between Unemployment and Personal Saving Rate",
    x = "Number of Unemployed (thousands)",
    y = "Personal Saving Rate (%)"
  ) +
  theme_minimal()  





