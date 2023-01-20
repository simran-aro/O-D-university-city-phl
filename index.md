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

![chart2]({{ site.url }}{{ site.baseurl }}/assets/img/jobsdensity.png)

Taking a quick look at where the furthest census tracts are, the 10 farthest tracts were isolated based on distance. The map below shows the same. This has no impact on the analysis- this was done for visualization purposes.

![chart3]({{ site.url }}{{ site.baseurl }}/assets/img/farthest.png)

# Part 4: Jobs!

Where are most of University City's workers coming from? Aggregating by jobs and then isolating the top 10 and top 100 origin census tracts, the following maps were made. These census tracts have the highest density of people working in University census. Most of the these are in the Western suburbs of Philadelphia, Center City Philadelphia and some wealthy neighborhoods like Fishtown, Old City and Passyunk. The households incomes of these census tracts are much higher than the city's median- which makes sense, since jobs in healthcare and education and professional services, the major industries in University City, pay more.

![chart4]({{ site.url }}{{ site.baseurl }}/assets/img/top1100.png)

**Top Ten Census Tracts with High Density of Residents Working in University City**

![chart5]({{ site.url }}{{ site.baseurl }}/assets/img/top100.png)

**Top Hundred Census Tracts with High Density of Residents Working in University City**

## Altair Example

Below is a chart of the incidence of measles since 1928 for the 50 US states.

<div id="altair-chart-1"></div>

This was produced using Altair and embedded in this static web page. Note that you can also display Python code on this page:

```python
import altair as alt
alt.renderers.enable('notebook')
```

## HvPlot Example

Lastly, the measles incidence produced using the HvPlot package:

<div id="hv-chart-1"></div>

## Notes

- See the [lecture 13A slides](https://musa-550-fall-2021.github.io/slideslecture-13A.html) for the code that produced these plots.

**Important: When embedding charts, you will likely need to adjust the width/height of the charts before embedding them in the page so they fit nicely when embedded.**

# Example: Embedding Folium charts

This post will show examples of embedding interactive maps produced using [Folium](https://github.com/python-visualization/folium).

## OSMnx and Street Networks

The shortest route between the Art Museum and the Liberty Bell:

<div id="folium-chart-1"></div>

<br/>

## Percentage of Households without Internet

The percentage of households without internet by county:

<div id="folium-chart-2"></div>

See the [lecture 9B slides](https://musa-550-fall-2021.github.io/slides/lecture-9B.html) and the [lecture 10A slides](https://musa-550-fall-2021.github.io/slides/lecture-10A.html) for the code that produced these plots.
