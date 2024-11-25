
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

View(locations)

locations_sf <- st_as_sf(locations, coords = c("Longitude", "Latitude"), crs = 4326)

california_shape <- st_read("CA_State.shp")

california_counties <- st_read("CA_Counties.shp")

california_bbox <- st_bbox(california_shape)
mid_latitude <- mean(c(california_bbox["ymin"], california_bbox["ymax"]))


locations_sf <- st_transform(locations_sf, st_crs(california_shape))

ggplot() +
  geom_sf(data = california_shape, fill = "lightblue", color = "black") +
  geom_sf(data = california_counties, fill = "lightblue", color = "black") +
  geom_sf(data = locations_sf, aes(color = hospital_name), size = 1) +
  geom_sf(data = locations_sf, aes(color = hospital_name, size = infections_reported)) +
  geom_segment(aes(x = california_bbox["xmin"], xend = california_bbox["xmax"], 
                   y = mid_latitude, yend = mid_latitude),
               color = "red", linetype = "dashed", size = 0.5) +
  theme_minimal() +
  labs(title = "MRSA In California") +
  theme(
    legend.position = "right",        # Ensure the legend is displayed
    legend.key.size = unit(0.5, "cm"), # Reduce the size of legend keys
    legend.text = element_text(size = 5), # Reduce the size of legend text
    legend.title = element_text(size = 8) # Adjust the size of the legend title
  ) +
  coord_sf()       



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



locations
#try with incomplete file
#drop_na(Longitude, Latitude)


#code that makes the legend go away entirely

ggplot() +
  geom_sf(data = california_shape, fill = "lightblue", color = "black") +
  geom_sf(data = california_counties, fill = "lightblue", color = "black") +
  geom_sf(data = locations_sf, aes(color = hospital_name), size = 1) +
  geom_segment(aes(x = california_bbox["xmin"], xend = california_bbox["xmax"], 
                   y = mid_latitude, yend = mid_latitude),
               color = "red", linetype = "dashed", size = 1) +
  theme_minimal() +
  labs(title = "MRSA In California") +
  theme(legend.position = "none") +  # Remove the legend
  coord_sf()                         # Keep aspect ratio intact






#code for dots based on size

ggplot() +
  geom_sf(data = california_shape, fill = "lightblue", color = "black") +
  geom_sf(data = california_counties, fill = "lightblue", color = "black") +
  geom_sf(data = locations_sf, aes(color = hospital_name, size = infections_reported)) +
  geom_segment(aes(x = california_bbox["xmin"], xend = california_bbox["xmax"], 
                   y = mid_latitude, yend = mid_latitude),
               color = "red", linetype = "dashed", size = 1) +
  theme_minimal() +
  labs(title = "MRSA In California") +
  theme(legend.position = "none") +  # Remove the legend
  coord_sf()                         # Keep aspect ratio intact

