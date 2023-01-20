---
layout: default
---

# Introduction

[STPLANR](https://cran.r-project.org/web/packages/stplanr/vignettes/stplanr.html) is a package that can be used for travel behavior analysis using spatil data. An example of travel behavior is looking at **who** is travelling to where jobs are. This can answer several questions and help plan for public transit, demand and so on. This project looks at origin-destination data of Pennsylvania from 2017, and visualizes the demographics of travellers.

# Part 1: Defining the Study Area

For this project the study area is University City, a neighborhood in West Philadelphia consisting of University of Pennsylvania (Penn), Drexel University as well as hospitals associated with Penn and housing, restaurants and other amenities. The unit of analysis was by census tract level. The census tracts used for this study are shown in the map below, and include the entire neighborhood of University City, with some extending beyond. Census Tract 42101980000 has a large boundary that includes Fairmount Park, but was used in this analysis since it captures the northeast part of University City. Additionally, a small number of households (if at all) are in Fairmount Park, thus too many outliers are not expected by including it.

The methodology is explained in every part.

![ucityct]({{ site.url }}{{ site.baseurl }}/assets/img/uc_ct.png)

The census tracts were subset based on their location, as well as their attribute of being the destination census tracts. Thus, for the following analyses, the dataset was trimmed using destination census tracts. 

# Part 2: Spatial Data

To plot the origin-destination lines, the centroids of every census tract are plotted. The following image shows the same:

![centroid]({{ site.url }}{{ site.baseurl }}/assets/img/pa_ct_centroid.png)

Once the centroids were plotted, the 'od2line' function was used to plot the O-D lines. The data table for this shows the origin and destination census tracts. It is visualized as follows.

![ODPA]({{ site.url }}{{ site.baseurl }}/assets/img/all_jobs.png)

The map above is confusing to read but according to it people from all over Pennsylvania come to work at University City. This might be because the data contains daily and monthly trips, or because people might enter their home as another place. To counter this, and to get a clearer picture, only census tracts in Philadephia are visualized in the following section.

# Part 3: Initial Analysis

Where in University City are most of the jobs? Some tracts chosen in the area, like the one that contains Fairmount Park, would have fewer jobs. A higher density of those would be around the universities and hospitals. Aggregating the data by jobs, the following chart shows which census tract has most jobs:

![chart1]({{ site.url }}{{ site.baseurl }}/assets/img/jobs.png)

Census Tract 42101039600 has the University of Pennsylvania, Drexel University as well as the hospitals. It is also the largest tract. Next, distances of O-D tracts were recorded and the density was tracts. The following tract shows the distance and number of jobs. **Most people working in University City live within 50km of the neighborhood**.

![jobs]({{ site.url }}{{ site.baseurl }}/assets/img/jobsdensity.png)

Taking a quick look at where the furthest census tracts are, the 10 farthest tracts were isolated based on distance. The map below shows the same. This has no impact on the analysis- this was done for visualization purposes.

![farthest]({{ site.url }}{{ site.baseurl }}/assets/img/farthest.png)

# Part 4: Jobs!

Where are most of University City's workers coming from? Aggregating by jobs and then isolating the top 10 and top 100 origin census tracts, the following maps were made. These census tracts have the highest density of people working in University census. Most of the these are in the Western suburbs of Philadelphia, Center City Philadelphia and some wealthy neighborhoods like Fishtown, Old City and Passyunk. The households incomes of these census tracts are much higher than the city's median- which makes sense, since jobs in healthcare and education and professional services, the major industries in University City, pay more.

**Top Ten Census Tracts with High Density of Residents Working in University City**

![top10]({{ site.url }}{{ site.baseurl }}/assets/img/top1100.png)

**Top Hundred Census Tracts with High Density of Residents Working in University City**

![top100]({{ site.url }}{{ site.baseurl }}/assets/img/top100.png)

# Part 5: Continuous Metrics- Exploring demographics of origin census tracts

Tidycensus is a package in R that allows one to pull data tables based on geographies, years and units of analysis. Using this package, data for income, median age, and percentage of transit users was downloaded to figure out more about the workers fr University City. First, this was plotted for all the O-D pairs in the dataset provided.

![PAincome]({{ site.url }}{{ site.baseurl }}/assets/img/cross.png)

Plotting it for Pennsylvania can be dense. Even with a diverging color scheme, it's difficult to really see any patterns. Thus, census tracts only within Philadelphia were considered to hyperfocus on the Philadelphia County.

**Median Household Income**

![Phlincome]({{ site.url }}{{ site.baseurl }}/assets/img/phl_inc.png)

In Philadelphia, a large number of people come from North and Northwast Philadelphia, Chestnut Hill, Olc City and West Philadelphia. Chestnut Hill (northwest Philadelphia) and Old City (East Philadelphia) are neighborhoods consisting census tracts with the highest median household income. If isolated by jobs, it is likely that residents of these neighborhoods work in hospitals as doctors or administrators, or in education as administrators.

**Median Age**

![Phlage]({{ site.url }}{{ site.baseurl }}/assets/img/phl_age.png)

High income neighborhoods have a high correlation with age, according to this map. The median age in Philadelphia is 34.6. Older residents come from Northwest, Northeast Philadelphia and Old City, while younger workers are from North Philadelphia and West Philadelphia. West Philly's younger residents on this map may represent the high student population, including graduate, doctoral and post-doctoral students.

**Percentage of Public Transit Users**

![Phlpt]({{ site.url }}{{ site.baseurl }}/assets/img/phl_pt.png)

West and South Philadelphians have a high share of transit users. This has a correlation with younger residents, and lower income residents. These areas are also served with SEPTA, so that might be a reason as so why North Philadelphians don't often take transit. 

# Conclusion

This project was done to experiment with STPLANR and see its uses. In case of University City in Philadelphia, the O-D lines were used to visualize the demographics of its workers. It is a more granular and spatial way of general demographic analysis. Looking at median household income, age and % of transit users of workers in University City might've not given so much information about where they are coming from, and it connects their origin neighborhoods with their jobs in University City.



