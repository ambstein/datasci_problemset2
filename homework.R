#PSYC 259 Homework 3 - Data Transformation
#For full credit, provide answers for at least 7/11

#List names of students collaborating with: 
## Sarah & Dylan

### SETUP: RUN THIS BEFORE STARTING ----------

#Load packages
library(tidyverse)
ds <- read_csv("data_raw/rolling_stone_500.csv")

### Question 1 ----------

# Use a function to check the class of all of the variables in 'ds'
# Convert "Year" to a numeric, saving it back to 'ds'
# Use a function to check that your conversion succeeded

# ANSWER
glimpse(ds)
ds$Year <- as.numeric(ds$Year)
is.numeric(ds$Year)
glimpse(ds)

### Question 2 ----------

# Using a dplyr function,
# change ds so that all of the variables are lowercase

# ANSWER
ds <- ds %>%
  rename_with(tolower)
glimpse(ds)

### Question 3 ----------

# Use mutate to create a new variable in ds that has the decade of the year as a number
# For example, 1971 would become 1970, 2001 would become 2000
# Hint: read the documentation for ?floor and make sure year is numeric (from Question 1)

# ANSWER
?floor
ds <- ds %>%
  mutate(decade = floor(year / 10)) %>%
  mutate(decade = floor(decade * 10))

# trial and error led me to using 10.5 * 10 because /10 + *10 were resulting in
#  numbers that I didn't want. 10.5 * 10 solved my problem!

# HANG ON .... this actually didn't work because the decades are wrong
#  they're off by 100 years and also rounding up instead of down for decade?

# WELP I'm going to continue on and try to understand this later due to time :(

glimpse(ds) #THIS WORKED

### Question 4 ----------

# Sort the dataset by rank so that 1 is at the top

# ANSWER
ds <- ds %>%
  arrange(rank)

glimpse(ds)

### Question 5 ----------

# Use filter and select to create a new tibble called 'top10'
# That just has the artists and songs for the top 10 songs

# ANSWER
top10 <- ds %>%
  filter(rank < 11) %>%
  select(artist, song)
glimpse(top10)


### Question 6 ----------

# Use summarize to find the earliest, most recent, and average release year
# and save the results to a new tibble called "ds_sum"
# Hint, the function drop_na() might help. Read ?drop_na

# ANSWER
ds_sum <- ds %>%
  summarize(
    earliest_year = min(year, na.rm = T),
    most_recent_year = max(year, na.rm = T),
    avg_year = mean(year, na.rm = T)
  )
glimpse(ds_sum)

?drop_na
# OHH I see how this could have been useful so I wasn't re-typing na.rm = T

### Question 7 ----------

# Use filter on the original dataset 'ds' to find all of the artists/song titles from
# the min/max/mean years that you identified in 'ds_sum'
# Use one filter command only, and sort the responses by year
# Bonus: find a way to do it without hard coding the years (i.e. pull them from ds_sum)
# (this might take some searching to find functions that will help)

# ANSWER
# ds_filtered <- ds %>%
# filter(year == pull(ds_sum$earliest_year) |
#  year == pull(ds_sum$most_recent_year) |
#   year == pull(avg_year))

# I tried to use pull() but it says it can't be used on a numeric variable...

# I see online that left_join() might work but I unfortunately don't have time to play with it

ds_filtered <- ds %>%
  filter(year == 1879 | year == 2020 | year == 1980.301) %>%
  arrange(year)

glimpse(ds_filtered)

### Question 8 ----------

# There's an error here. The oldest song "Brass in Pocket"
# is from 1979! Use mutate and ifelse to fix the error in 'ds'
# then recalculate decade, and then
# recalculate the responses from Questions 6-7 to
# find the correct oldest, averag-ist, and most recent songs

# ANSWER
?ifelse
ds <- ds %>%
  mutate(year = ifelse(year == 1879, 1979, year))
glimpse(ds)

# hm

ds <- ds %>%
  mutate(decade = floor(year / 10)) %>%
  mutate(decade = floor(decade * 10))
glimpse(ds)

# UGH WHY ARE THEY A CENTURY OFF

### Question 9 ---------

# Use group_by and summarize to find the average rank and
# number of songs on the list by decade. To make things easier
# filter out the NA values from decade before summarizing
# You don't need to save the results anywhere
# Use the pipe %>% to string the commands together

# ANSWER
ds %>%
  drop_na() %>%
  group_by(year) %>%
  summarize(average_rank = mean(rank))


### Question 10 --------

# Look up the dplyr "count" function
# Use it to count up the number of songs by decade
# Then use slice_max() to pull the row with the most songs
# Use the pipe %>% to string the commands together
# Check against your answers from Question 9 to make sure it matches

# ANSWER
?count

ds %>%
  drop_na() %>%
  count(decade) %>%
  slice_max(n)
# why is tibble called "n"?


### Question 11 ------
# Use RStudio's styler to style all the code in your homework
library(styler)
