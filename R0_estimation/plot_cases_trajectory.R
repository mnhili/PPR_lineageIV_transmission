library(ggplot2)
library(dplyr)
library(tidyr)

# Read your data into a data frame
data <- read.csv("simulation_results_v2.csv")

# Reshape data from wide to long format
long_data <- pivot_longer(data, cols = starts_with("Iteration"), 
                          names_to = "simulation", 
                          values_to = "cases")

# Calculate average for each day, size, and density
avg_data <- long_data %>%
  group_by(Infectious.Time, Population.Size, Density) %>%
  summarize(avg_cases = round(mean(cases, na.rm = TRUE)))

# Create faceted plot
ggplot(avg_data, aes(x = Infectious.Time, y = avg_cases)) +
  geom_line() +
  facet_wrap(~Population.Size + Density, ncol = 3) +
  labs(x = "Day", y = "Average Number of Cases") +
  ggtitle("Trajectories of Average Cases by Size and Density")


# Get unique day values for x-axis ticks
unique_days <- sort(unique(avg_data$Infectious.Time))

# Create faceted plot with custom x-axis ticks
ggplot(avg_data, aes(x = Infectious.Time, y = avg_cases)) +
  geom_line() +
  facet_wrap(~Population.Size + Density, ncol = 3) +
  labs(x = "Day", y = "Average Number of Secondary Cases") +
  ggtitle("Trajectories of Average Secondary Cases by Size and Density") +
  scale_x_continuous(breaks = unique_days, labels = unique_days)
