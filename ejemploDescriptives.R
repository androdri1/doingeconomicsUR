# Desc: Este archivo realiza estadisticas basicas de la base de datos
pacman::p_load(
  rio,          # File import
  skimr,        # get overview of data
  tidyverse    # data management + ggplot2 graphics 
)
linelist <- import("linelist_cleaned.rds")

## get information about each variable in a dataset 
skim(linelist)

# Basic tabulations ====================================

table(linelist$age_cat )

#dplry version
linelist %>% 
  group_by(age_cat) %>%     # group data by unique values in column age_cat
  summarise(n_rows = n())   # return number of rows *per group*

# A bit more useful...
age_summary <- linelist %>% 
  count(age_cat) %>%                     # group and count by gender (produces "n" column)
  mutate(                                # create percent of column - note the denominator
    percent = scales::percent(n / sum(n))) 
age_summary

# Crosstabs =============================================
table(linelist$age_cat, linelist$gender )

linelist %>% 
  count(age_cat, gender)

# Cell specific proportions
age_summary <- linelist %>% 
  count(age_cat,gender) %>%                     # group and count by gender (produces "n" column)
  mutate(                                # create percent of column - note the denominator
    percent = scales::percent(n / sum(n))) 
age_summary

# Proprotions per group
age_by_outcome <- linelist %>%                  # begin with linelist
  group_by(gender) %>%                         # group by gender 
  count(age_cat) %>%                            # group and count by age_cat, and then remove age_cat grouping
  mutate(percent = scales::percent(n / sum(n))) # calculate percent - note the denominator is by gender group
print(age_by_outcome,n=24)

# Getting an idea of the distribution
summary(linelist$age)

plot(density(linelist$age, na.rm=TRUE))

ggplot(linelist, aes(x=age)) + 
  geom_density()+ 
  geom_vline(aes(xintercept=mean(age, na.rm=TRUE)),
                             color="blue", linetype="dashed", size=1)


ggplot(linelist,aes(age)) + 
  geom_boxplot(outlier.colour="black", outlier.shape=16,
               outlier.size=2, notch=FALSE)

