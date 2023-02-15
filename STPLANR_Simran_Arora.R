#Setup
rm(list = ls())

library(tidyverse)
library(stringr)
library(tidycensus)
library(sf)
library(ggplot2)
library(data.table)
library(stplanr)
library(qualtRics)
library(convertr)
census_api_key("2b0e9cda2f18e964549cc331f4b2af6a2cebc085")
options(tigris_use_cache = TRUE)
options(scipen=999)

#Importing O-D file for Pennsylvania, 2017

pa_od <- fread("pa_od_2017.csv")

##h_geocode: the origin census block
##w_geocode: destination census block
##jobs: the number of jobs in the destination block held by those who travel from the origin block

# 1: WORKER FLOWS TO UNIVERSITY CITY, PHILADELPHIA
##Aggregate by census tract from census block group
dat_uc <- pa_od %>%
  mutate(dest_tract = str_sub(w_geocode, 1,11),
         or_tract = str_sub(h_geocode, 1,11))

##Filter for census tracts in University City

dat_uc <- dat_uc[grepl(pattern = "42101008801|42101008802|42101009100|42101036900|42101980000|42101009000", x = dest_tract), ]

##Clean columns
dat_uc <- dat_uc %>% 
  select(dest_tract, or_tract, jobs)

# 2: SPATIAL DATA
##Read in tract centroid data
geo <- read.delim("pa_tract_geo.txt") 
geo <- geo%>%
  select (GEOID, INTPTLAT, INTPTLONG)
geo <- st_as_sf(geo, coords = c("INTPTLONG", "INTPTLAT"), crs = 4326, agr = "constant")
plot(st_geometry(geo))

##Read in Philly  and PA shapefile
phl <- st_read("https://opendata.arcgis.com/datasets/405ec3da942d4e20869d4e1449a2be48_0.geojson")
pa_shp <- st_read("https://gis.penndot.gov/arcgis/rest/services/opendata/countyboundary/MapServer/0/query?outFields=*&where=1%3D1&f=geojson")
phlct <- st_read("https://opendata.arcgis.com/datasets/8bc0786524a4486bb3cf0f9862ad0fbf_0.geojson")
ucity <- phlct %>% 
  filter(phlct$GEOID10 == "42101036900")
plot(st_geometry(phlct))
plot(st_geometry(ucity))
plot(st_geometry(phl))
plot(st_geometry(pa_shp))

##Create Desire Lines using STPLANR using centroids of census tracts
dat_desire <- od2line(flow = dat_uc, zones = geo)
#Setting the coordinate system
desire_proj <- st_transform(dat_desire, crs = 2272)
desire <- st_as_sf(dat_desire)
plot(st_geometry(desire))

# 3 : DESCRIPTIVE STATISTICS 
# Sorting by number of jobs, descending
dat_uc_stat<- dat_uc %>% 
  group_by(or_tract, dest_tract) %>% summarise(n_com = n())
data_sorted <- dat_uc_stat[order(dat_uc_stat$n_com,
                                decreasing = TRUE), ]
top10 <- head(data_sorted, n=10)
ggplot(dat_uc_stat, aes(x = dest_tract,
                        y = n_com)) +
  geom_bar(fill = "#69b3a2", color="#05705A", stat='identity', width=0.5) +
  theme(legend.position = "bottom") +
  ggtitle("Jobs in University City") +
  xlab("University City Census Tracts") + ylab("No. of Jobs") 

# 4 : CONTINUOUS METRICS 

## Distance
desire$dist_units <- st_length(desire)
desire$dist <- as.numeric(st_length(desire))
desire_proj$dist_ft<- st_length(desire_proj)

## Distance Scatterplot
p1 <- ggplot(desire, aes(x=dist)) +
  geom_density(fill="#69b3a2", color="#05705A",  alpha=0.8)+
  labs(x="Distance", y = "Density")

p1 + geom_vline(xintercept = 50000, linetype="dashed", 
                color = "blue", size=0.5)

### most origin tracts are within 0-50km of University City

furthest_tracts <- desire%>%
  slice_max(dist, n = 10)

map_furthest <- ggplot()+geom_sf(data=pa_shp)+geom_sf(data=phl)+geom_sf(data=furthest_tracts, col = "#69b3a2", lwd = 3) 
plot(map_furthest)

## Jobs
dat_uc_jobs <- dat_uc %>% 
  group_by(dest_tract) %>% 
  summarise(jobs = sum(jobs))

top10geo <- od2line(flow = top10, zones = geo)
top10geocrs <- st_transform(top10geo, crs = 2272)
map0 <- ggplot()+geom_sf(data=phl)+geom_sf(data=top10geocrs, col = "#69b3a2") 
plot(map0)

top100 <- head(data_sorted, n=100)
top100geo <- od2line(flow = top100, zones = geo)
top100geocrs <- st_transform(top100geo, crs = 2272)
map00 <- ggplot()+geom_sf(data=phl)+geom_sf(data=top100geocrs, col = "#69b3a2") 
plot(map00)

#All jobs
map1 <- ggplot()+geom_sf(data=pa_shp)+geom_sf(data=desire, col = "#69b3a2")
plot(map1)

#Using tidycensus to get data for the tracts. Starting by getting data tables.

lookup <- load_variables(year = 2017, dataset = "acs5")

data_table = c("B06011_001", #Median household income
         "B05004_001", #Median age
         "B08006_008" #% of people using public transit
)


df = get_acs(geography = "tract", state = 'PA',  
             variables = data_table, geometry = FALSE, year = 2017, cache_table = TRUE)

df_income = subset(df, df$variable == "B06011_001")
names(df_income)[1] <- "or_tract"
names(df_income)[4] <- "income"
df_age = subset(df, df$variable == "B05004_001")
names(df_age)[1] <- "or_tract"
names(df_age)[4] <- "age"
df_pt = subset(df, df$variable == "B08006_008")
names(df_pt)[1] <- "or_tract"
names(df_pt)[4] <- "pt"


data_frame_merge <- merge(desire, df_income,
                          by = 'or_tract', all.x = TRUE)
data_frame_merge <- merge(data_frame_merge, df_age,
                          by = 'or_tract', all.x = TRUE)
data_frame_merge <- merge(data_frame_merge, df_pt,
                          by = 'or_tract', all.x = TRUE)


colnames(data_frame_merge)

dat_cleaned <- data_frame_merge[,c("or_tract","dest_tract","jobs", "dist_units", "dist", "income", "age", "pt")]

dat_cleaned$or_tract <- as.numeric(dat_cleaned$or_tract)
dat_cleanedphl <- dat_cleaned %>% 
  filter(dat_cleaned$or_tract > 42101000100 & dat_cleaned$or_tract < 42101989100)
dat_cleanedphl <- dat_cleanedphl %>% 
  filter(dat_cleanedphl$dest_tract == 42101036900)

# 6 : MAKING MAPS!

map1 <-ggplot()+geom_sf(data=phl) + geom_sf(data=dat_cleaned, aes(color=income), inherit.aes = FALSE) +
  geom_sf(data=pa_shp, fill=NA, color = "black")+geom_sf(data=ucity, fill=NA, color = "red") + scale_color_gradient2( low = "red", mid = "yellow",
                                                                                                                  high = "purple", space = "Lab" )
plot(map1)

map2 <-ggplot()+geom_sf(data=phl) + geom_sf(data=dat_cleanedphl, aes(color=income), inherit.aes = FALSE) +
  geom_sf(data=phl, fill=NA, color = "blue")+geom_sf(data=ucity, fill=NA, color = "red") + scale_color_gradient2( low = "red", mid = "white",
                                                                                                                high = "purple", space = "Lab" )
plot(map2)

map3 <-ggplot()+geom_sf(data=phl) + geom_sf(data=dat_cleanedphl, aes(color=age), inherit.aes = FALSE) +
  geom_sf(data=phl, fill=NA, color = "blue") +geom_sf(data=ucity, fill=NA, color = "red") + scale_color_gradient2( low = "red", mid = "white",
                                                                                                                  high = "red", space = "Lab" )
plot(map3)

map4 <-ggplot()+geom_sf(data=phl) + geom_sf(data=dat_cleanedphl, aes(color=pt), inherit.aes = FALSE) +
  geom_sf(data=phl, fill=NA, color = "blue") + scale_color_gradient2( low = "red", mid = "lightgreen",
                                                                      high = "darkgreen", space = "Lab" )
plot(map4)



