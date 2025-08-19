# Reproducible example ----
# install.packages(c("tidyr","dplyr","tibble"))  # <- uncomment if needed
library(dplyr)
library(tidyr)
library(tibble)

# 1) Data in WIDE format (like your left table)
baseextensa <- tribble(
  ~Nombre,  ~Signo,      ~var1, ~var2, ~var3,
  "Paul",   "Escorpion",    11,    12,    13,
  "Andres", "Sagitario",    21,    22,    23,
  "Maria",  "Virgo",        31,    32,    33
)

baseextensa

# 2) Wide -> Long: pasamos de la version extensa original a una larga
baselarga <- baseextensa %>%
  pivot_longer(
    cols = c(var1, var2, var3),
    names_to  = "variableCategorias",
    values_to = "Numeros"
  ) %>%
  arrange(Nombre, variableCategorias)

baselarga

# 3) Long -> Wide: pasamos de la verison larga a la extensa
baseextensa_rec <- baselarga %>%
  pivot_wider(
    names_from  = variableCategorias,  # creates columns var1, var2, var3
    values_from = Numeros              # fills them with the numbers
  ) %>%
  arrange(Nombre)

baseextensa_rec

