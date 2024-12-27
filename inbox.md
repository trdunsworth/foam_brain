# Inbox

- Can I build a custom colour scheme for Viridis? 
  From the looks of it, I can. I need to build in the code for it and calve it off of the palette that I like for DECC. 

```{r}
library(ggplot2)
library(ggridges)
library(dplyr)

# Sample Data (Replace with your actual data)
set.seed(123) # for reproducibility
days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
wk50 <- data.frame(
  DOW = factor(rep(days, each = 24 * 5)), # 5 weeks of data
  Hour = rep(0:23, times = 5 * 7),
  Calls = sample(0:15, 24 * 7 * 5, replace = TRUE) # Random call counts
)

# Aggregate data to get counts per hour per day
hourly_calls <- wk50 %>%
  group_by(DOW, Hour) %>%
  summarize(CallCount = sum(Calls), .groups = "drop")

# Create the Ridgeline Plot
ridge_plot <- ggplot(hourly_calls, aes(x = Hour, y = DOW, height = CallCount, group = DOW)) +
  geom_density_ridges(stat = "identity", scale = 0.9, rel_min_height = 0.01) +
    scale_x_continuous(breaks = 0:23) + # Set breaks for each hour
  scale_y_discrete(limits = rev) + # Reverse order of days for better readability
  labs(title = "Call Volume by Hour and Day of Week",
       x = "Hour of Day",
       y = "Day of Week") +
  theme_ridges(font_size = 13, grid = FALSE)

ridge_plot
```

That code worked with some modifications. I will document that in the work notes later. 
