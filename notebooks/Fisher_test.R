# Load libraries
library(tidyverse)  # for data manipulation and visualization
library(stats)      # for statistical tests
library(graphics)   # for basic plotting

setwd("D:/CIRAD_2024/pprv-lineage4-study")
# Read the data (assuming you have a CSV file)

data <- read.csv("data/events.csv")

# Convert Duration into categories
data$Duration_Category <- cut(data$duration,
                              breaks = c(-Inf, 23.99, 24.01, Inf),
                              labels = c("<24h", "24h", ">24h"),
                              right = FALSE)

# Verify Status is binary (0 or 1)
# If not already binary, you might need to adjust this step
data$infected <- factor(data$infected, levels = c(0, 1))

# View the distribution of categories
print("Distribution of Duration Categories:")
print(table(data$Duration_Category))

print("\nCross-tabulation of Original Duration vs Categories:")
print(table(data$Duration, data$Duration_Category))

# Create the contingency table
cont_table <- table(data$Duration_Category, data$infected)

# View the contingency table
print("\nContingency Table:")
print(cont_table)

# Perform Fisher's Exact test
fisher_test <- fisher.test(cont_table, simulate.p.value = TRUE, B = 10000, conf.int = TRUE, conf.level = 0.95)

# Print results
print("\nFisher's Exact Test Results:")
print(fisher_test)

# Create a visualization
# Convert to proportions
props <- prop.table(cont_table, margin = 1)

# Basic summary statistics
summary_stats <- data.frame(
  Duration_Category = unique(data$Duration_Category),
  Total_Cases = as.numeric(table(data$Duration_Category)),
  Infectious_Cases = as.numeric(table(data$Duration_Category, data$infected)[,"1"]),
  Infection_Rate = round(as.numeric(props[,"1"]) * 100, 2)
)

print("\nSummary Statistics:")
print(summary_stats)

# Create barplot
par(mar = c(5, 4, 4, 8))  # Adjust margins to accommodate legend

tiff("contact_duration_vs_infection_status.tiff", 
     width = 8, height = 6, units = "in", res = 350)

# Generate the bar plot
barplot(t(props), 
        beside = TRUE,
        col = c("lightblue", "salmon"),
        legend.text = c("Negative", "Positive"),
        main = "Distribution of Infection Status Proportions by Duration Category",
        xlab = "Contact duration",
        ylab = "Proportion",
        args.legend = list(x = "topright"))

# Close the TIFF device
dev.off()


#================================================


plot_data <- as.data.frame(prop.table(cont_table, margin = 1))
colnames(plot_data) <- c("Duration", "Status", "Proportion")

# Create the plot
ggplot(plot_data, aes(x = Duration, y = Proportion, fill = Status)) +
  geom_bar(stat = "identity", 
           position = position_dodge(width = 0.9),
           width = 0.5) +
  # Add text labels
  geom_text(aes(label = sprintf("%.2f", Proportion)),
            position = position_dodge(width = 0.9),
            vjust = -0.5,
            fontface = "bold") +
  # Add horizontal lines
  geom_linerange(aes(ymin = Proportion, ymax = Proportion),
                 position = position_dodge(width = 0.9),
                 size = 0.8,
                 width = 0.4) +
  # Customize colors
  scale_fill_manual(values = c("lightblue", "salmon"),
                    labels = c("Negative", "Positive")) +
  # Customize labels and title
  labs(title = "Distribution of Infection Status Proportions by Duration Category",
       x = "Duration Category",
       y = "Proportion",
       fill = "Status") +
  # Customize theme
  theme_minimal() +
  theme(
    text = element_text(size = 12),
    axis.text = element_text(color = "black"),
    legend.position = "top",
    plot.title = element_text(hjust = 0.5)
  ) +
  # Adjust y-axis to make room for labels
  scale_y_continuous(limits = c(0, max(plot_data$Proportion) * 1.1))

# Save with high resolution
ggsave("duration_status_plot.tiff", 
       width = 8, 
       height = 6, 
       dpi = 350)

