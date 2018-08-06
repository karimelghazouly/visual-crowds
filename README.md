# ***Visual Crowds***
## Introduction
Visual Crowds is a dashboard that help visualize and analyze the pilgrims movement during their hajj, It can get their address but attaching a gps module to their bracelets that share live location.
It helps security managers to detect the overcrowding problems early to avoid dangerous situations and get insights of the roads and movement flow, It creates warning whenever it finds an overcrowding in a place.
You can also search about a lost pilgrim by name or by id, It also gives insights about the hospitals capacity to choose the right one in case of emergency.  
## Demo 
[![Watch the video](https://github.com/karimelghazouly/visual-crowds/blob/master/www/icons/Video-Link.png)](https://www.youtube.com/watch?v=OmpYnkakREk)  
# Installation
you need R installed first you can download it from here
https://cran.r-project.org/mirrors.html

You need to downlaod the dependcies, To install package X in R 
```R
install.packages("X")
```
## Run
To run the app you can run it from Rstudio or using command line
````
R -e "shiny::runApp('visual-crowds')"
````
