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


# Example: Embedding Altair & Hvplot Charts

This section will show examples of embedding interactive charts produced using [Altair](https://altair-viz.github.io) and [Hvplot](https://hvplot.pyviz.org/).

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
