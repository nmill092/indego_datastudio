library(tidyverse)
library(purrr)
library(lubridate)
library(googlesheets4)
library(sqldf)

# Read in previous year bike data

if(!dir.exists("indego_data")) {
  dir.create("indego_data")
}

data.links <- c("https://u626n26h74f16ig1p3pt0f2g-wpengine.netdna-ssl.com/wp-content/uploads/2021/04/indego-trips-2021-q1.zip", 
                "https://u626n26h74f16ig1p3pt0f2g-wpengine.netdna-ssl.com/wp-content/uploads/2021/07/indego-trips-2021-q2.zip", 
                "https://u626n26h74f16ig1p3pt0f2g-wpengine.netdna-ssl.com/wp-content/uploads/2021/10/indego-trips-2021-q3.zip", 
                "https://u626n26h74f16ig1p3pt0f2g-wpengine.netdna-ssl.com/wp-content/uploads/2022/01/indego-trips-2021-q4.zip")

# helper function to simplify using map with zip files... 

downloadUnz <- function(file) { 
  tf <- tempfile(".zip")
  download.file(file,tf)
  return(tf)
}



# create one big data frame with all of the trips csvs 

bike_data <- data.links %>% 
  map(downloadUnz) %>% 
  map(unzip,exdir="indego_data") %>% 
  map(~subset(.,subset = grepl("trips",.))) %>% 
  map(read_csv) %>% 
  map_dfr(~.)

bike_data$hour <- str_extract(bike_data$start_time,"[0-9]+(?=:)")
bike_data$day <- gsub("\\s.+","",bike_data$start_time)


#remove the downloaded csvs 
unlink("indego_data",recursive=T)

# split start_time into "time" and "hour" 


# Read in latest stations zip
stations <- read_csv("https://www.rideindego.com/wp-content/uploads/2022/04/indego-stations-2022-04-01.csv")

bike_yr_sum <- bike_data %>% 
  left_join(stations, by = c("start_station" = "Station_ID")) %>% 
  group_by(Station_Name) %>% 
  count(name = "rides") %>% 
  left_join(stations, by = "Station_Name") %>% 
  select(everything())

bike_yr_sum$ranking <- cut(bike_yr_sum$rides,
                            breaks=5,
                            labels = c("Not very popular",
                                       "A little popular",
                                       "Average",
                                       "Quite popular",
                                       "Extremely popular"))

# 2021 bike summary data -- average rides per station per hour 

bike.2021_month_totals <- bike_data %>% 
  filter(start_station != 3000) %>% 
  count(start_station,month) %>% 
  mutate(month = as.numeric(month)) %>% 
  arrange(month) %>% 
  left_join(stations, by = c("start_station" = "Station_ID"))



googlesheets4::write_sheet(data = bike.2021_month_totals,ss="https://docs.google.com/spreadsheets/d/1m-R7RlN8Tr35y65KrmtDxdGSRY-cX2ohZkGWSF-n_8g/edit#gid=429618982",sheet=3)

# googlesheets4::write_sheet(data = bike_yr_sum,ss="https://docs.google.com/spreadsheets/d/1m-R7RlN8Tr35y65KrmtDxdGSRY-cX2ohZkGWSF-n_8g/edit#gid=429618982",sheet=2)
# 
# write_csv(x = bike_hr_sum,file = "indego_2021_summary.csv")
