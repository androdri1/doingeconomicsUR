# Descripcion: Se analizan los datos y se transforman

### Clear memory
rm(list = ls())

# https://rpubs.com/SmilodonCub/582905
# Basic data handling
library(tidyr)
library(dplyr)


#the url for the .csv file
URL <-'https://raw.githubusercontent.com/SmilodonCub/DATA607/master/eduDATA_df.csv'
#read to an R data.frame with read.csv().
eduDATA_OR <- read.csv( URL ,stringsAsFactors = FALSE )
View(eduDATA_OR)

# Melt ========================================================================

eduDATA_OR2 <- eduDATA_OR %>% 
  #there are uninformative text labels in row2: 
  #remove them with tidyverse methods
  filter( row_number() != 2L ) %>%
  #rename the columns with dplyr rename()
  rename( Region = NA., Male.NoHS = Male, Male.HS = Male.1, Male.Associate = Male.2, Male.Bachelors = Male.3, Male.Graduate = Male.4, Female.NoHS = Female, Female.HS = Female.1, Female.Associate = Female.2, Female.Bachelors = Female.3, Female.Graduate = Female.4) %>%
  #remove row 2
  filter( row_number() != 1L )

eduDATA_df <- eduDATA_OR2 %>% 
  #pivot_long() to give each observation it's own row in the data.frame
  pivot_longer( cols = Male.NoHS:Female.Graduate, names_to = 'Category', 
                values_to = 'Total') %>%
  #mutate Total to numeric
  mutate( Total = as.numeric( Total ))

eduDATA_df <- eduDATA_df %>% separate( Category,  c("Gender", "eduLevel"))
head( eduDATA_df )

View( eduDATA_df )

# Group ========================================================================
#Question 1: Which region appears to have the highest proportions of HS graduates 
#            as the highest educational attainment?

#This question does not involves the 'Gender' feature, so we will aggreggate the data by Region and eduLevel to simplify our visualization
edu_byRegion <- eduDATA_df %>% 
  #group_by() to aggregate Region & eduLevel data
  group_by( Region, eduLevel ) %>%
  #find the total of Male + Female incidences
  summarise( Total = sum( Total )) 


# Calcular proporción dentro de cada región
# Calculate proportion within each region
edu_grouped_prop <- edu_byRegion %>%
  group_by(Region) %>%
  mutate(Proporcion = Total / sum(Total)* 100) %>%
  ungroup()

# Visualizar las proporciones (primeras filas)
# View proportions
head(edu_grouped_prop)



# Merge ========================================================================
# Toy examples


# Append: https://www.w3schools.com/r/r_data_frames.asp
Data_Frame1 <- data.frame (
  Training = c("Strength", "Stamina", "Other"),
  Pulse    = c(100, 150, 120),
  Duration = c(60, 30, 45)
)

Data_Frame2 <- data.frame (
  Training = c("Stamina", "Stamina", "Strength"),
  Pulse    = c(140, 150, 160),
  Duration = c(30, 30, 20)
)

New_Data_Frame <- rbind(Data_Frame1, Data_Frame2)
New_Data_Frame 

# Merge.....................................................................
# Ojo, no usar rbind!! Casi nunca va a ser una buena idea
# La clave esta siempre en los identificadores
Data_Frame4 <- data.frame (
  Training = c("Strength", "Stamina", "Fondo"),
  Steps    = c(3000, 6000, 2000),
  Calories = c(300, 400, 300)
)

# Base R ======================================================================

#Inner.join
merge(New_Data_Frame, Data_Frame4, by.x = "Training", by.y = "Training")

# Left join
merge(New_Data_Frame, Data_Frame4, by.x = "Training", by.y = "Training",
      all.x = TRUE)


# Right join
merge(New_Data_Frame, Data_Frame4, by.x = "Training", by.y = "Training",
      all.y = TRUE)

# Full
merge(New_Data_Frame, Data_Frame4, by.x = "Training", by.y = "Training",
      all.x=TRUE, all.y = TRUE)

# Dplry =======================================================================
inner_join(New_Data_Frame, Data_Frame4, by = join_by(Training == Training))
left_join(New_Data_Frame, Data_Frame4, by = join_by(Training == Training))
right_join(New_Data_Frame, Data_Frame4, by = join_by(Training == Training))
full_join(New_Data_Frame, Data_Frame4, by = join_by(Training == Training))


# Handling missing data ========================================================

# Check for missing values in the final dataframe
missing_summary <- eduDATA_df %>%
  summarise_all(~sum(is.na(.))) %>%
  pivot_longer(cols = everything(), names_to = "Variable", values_to = "NA_Count")


# Optional: remove rows with NAs
eduDATA_clean <- eduDATA_df %>%
  drop_na()

# Alternative option: assign a value of 0 to missing values in the ‘Total’ column.
eduDATA_imputed <- eduDATA_df %>%
  mutate(Total = ifelse(is.na(Total), 0, Total))

# Verification after cleaning
summary(eduDATA_clean)





