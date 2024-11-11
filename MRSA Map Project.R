
library(tidyverse)
library(pacman)
library(sf)
library(terra)

#PLOT DATA

#1 check normality- QQPlot, Shapiro Wilk Test, Histogram

#2 Homogeneity of variance- Levene's Test, Add Mauchlys test for sphericity if repeated measures design

#3 Run the Test
#T-Test: means comparison between two groups
#Anova: Means comparison between multiple groups
#Linear Regression: relationship between 2 variable (positive or negative)

#Types of Anova
#One Way Anova- means comparison between 3 or more groups
#Two Way Anova- means comparison between 3 or more groups with interaction effect
#Nested Anova- means comparison between 3 or more groups with nesting effects/variables
#Repeated measures Anova- means comparison between 3 or more groups with multiple measurements
#Chi-squared test: frequency between defined groups/character etc often behavioral counts



# coordinate data file
locations <-read.csv("MRSA Hospital Locations (1)(MRSA Hospital Locations).csv")
locations

locations <- locations %>% 
  drop_na(Longitude, Latitude)

#####################################################################################################
#Practice file with all blank Latitude and Longitude data manually removed 



practice <-read.csv("MRSA Hospital Locations.csv")
practice

View(practice)

practice_sf <- st_as_sf(practice, coords = c("Longitude", "Latitude"), crs = 4326)

california_shape <- st_read("CA_State.shp")

california_counties <- st_read("CA_Counties.shp")


practice_sf <- st_transform(practice_sf, st_crs(california_shape))


ggplot () +
  geom_sf(data = california_shape, fill = "lightblue", color = "black") +
  geom_sf(data = california_counties, fill = "lightblue", color = "black") +
  geom_sf(data = practice_sf, aes(color = hospital_name), size = 3) +
  theme_minimal() +
  labs(title = "MRSA In California")

View(locations)

locations
#try with incomplete file
#drop_na(Longitude, Latitude)


locations_sf <- st_as_sf(locations, coords = c("Longitude", "Latitude"), crs = 4326)
