
library(tidyverse)
library(pacman)
library(sf)
library(terra)
library(dplyr)
library(MASS)
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

locations_sf <- locations_sf %>%
  mutate(region = ifelse(st_coordinates(.)[, 2] > mid_latitude, "North", "South"))
locations_sf

head(locations_sf)

# Extract data frame from the sf object
library(dplyr)  # Ensure dplyr is loaded
locations_with_region <- locations_sf %>%
  st_drop_geometry() %>%
  dplyr::select(everything())

# Merge the new column back into the original locations data frame
locations <- locations %>%
  mutate(region = locations_with_region$region)

write.csv(locations, "locations_with_region.csv", row.names = FALSE)

Regions <- read.csv("locations_with_region.csv")
View(Regions)

#Final Map Code
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



regions_data <- data.frame(Regions$region,Regions$infections_reported)
View(regions_data)


chi_squared_result <- chisq.test(regions_data$Regions.region, regions_data$Regions.infections_reported)
print(chi_squared_result)

t_test_result <- t.test(Regions$infections_reported ~ Regions$region, data = regions_data)
print(t_test_result)


summary_stats <- aggregate(Regions$infections_reported ~ Regions$region, data = regions_data, 
                           FUN = function(x) c(mean = mean(x), ci = qt(0.975, df = length(x)-1) * sd(x)/sqrt(length(x))))
summary_stats <- do.call(data.frame, summary_stats)
colnames(summary_stats) <- c("Region", "Mean", "CI")


ggplot(summary_stats, aes(x = Region, y = Mean, fill = Region)) +
  geom_bar(stat = "identity", color = "black", width = 0.6) +
  geom_errorbar(aes(ymin = Mean - CI, ymax = Mean + CI), width = 0.2) +
  labs(title = "Mean Infections Reported by Region",
       x = "Region",
       y = "Mean Infections Reported") +
  theme_minimal() +
  scale_fill_manual(values = c("skyblue", "lightgreen"))



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







