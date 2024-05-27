library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)

#install.packages("plotly")


# Read your data into a data frame
data <- read.csv("simulation_results_v5.csv")

# Reshape data from wide to long format
long_data <- pivot_longer(data, cols = starts_with("iter"), 
                          names_to = "simulation",
                          values_to = "cases")


# Calculate average for each day, size, and density


mean_data <- long_data %>%
  group_by(Infectious_time, Population_size, Density) %>%
  summarize(avg_cases = mean(cases, na.rm = TRUE))

mean_data <- mean_data %>%
  distinct()

# Get unique day values for x-axis ticks
unique_pop_size <- sort(unique(mean_data$Population_size))


p <- ggplot(mean_data, aes(x = Population_size, y = avg_cases, color = Density, group = Density)) +
  geom_line(linewidth = 1) +
  geom_point()+
  facet_wrap(~ Infectious_time, ncol = 2) +
  labs(x = "Population Size", y = "Average number of secondary cases", color = "Density") +
  ggtitle("Secondary cases Vs Population size by density per Infectious time")+
  theme_minimal()


p

#===============================================================================


mean_data_1 <- long_data %>%
  group_by(Infectious_time, Population_size, Density) %>%
  summarize(avg_cases = mean(cases, na.rm = TRUE)/Infectious_time)

mean_data_1 <- mean_data_1 %>%
  distinct()


g <- ggplot(mean_data_1, aes(x = Population_size, y = avg_cases, color = Density, group = Density)) +
  geom_line(linewidth = 1) +
  geom_point()+
  facet_wrap(~ Infectious_time, ncol = 2) +
  labs(x = "Population Size", y = "Average number of secondary cases", color = "Density") +
  ggtitle("Secondary cases Vs Population size by density per Infectious time")+
  theme_minimal()


g
#===============================================================================

mean_data_2 <- long_data %>%
  group_by(Infectious_time, Population_size, Density) %>%
  summarize(avg_cases = mean(cases, na.rm = TRUE)/Population_size)

mean_data_2 <- mean_data_2 %>%
  distinct()


# Get unique day values for x-axis ticks
unique_pop_size <- sort(unique(mean_data$Population_size))



#===============================================================================


cols_to_factor <- c("Density", "Population_size", "Infectious_time")

mean_data[cols_to_factor] <- lapply(mean_data[cols_to_factor], factor)

str(mean_data)

model <- lm(avg_cases ~ Density + Population_size + Infectious_time, data = mean_data)

summary(model)

write.csv(mean_data, "avg_simulation_v5.csv")


