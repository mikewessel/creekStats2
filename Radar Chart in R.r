
#*******************************************************************************************;
#
#                   JANICKI ENVIRONMENTAL, INC.
#
#
#
# Project        : Tidal Creeks
#
# Program name   : Radar Charts
#
# Date           : 5/12/21
#
# Description    : Create Radar cahrts in R
#
# Input datasets :  gradar_input.sas7bdat
#
# Output datasets:  none
#
# Programmer(s)  :   Mike Wessel
#
#
#*******************************************************************************************;
#
# History: V1
#
#
#*******************************************************************************************



# get working directory
getwd() 
setwd("Q:/Qdrive/SBEP/For Publication/Management Framework/Submitted Version 082020/Final Figures/Final Tables and Figures/Fig 9")

install.packages("rmarkdown")

# my standard package load
library(tidyverse)
library(haven)
library(rkt)
library(broom)
library(gapminder)
library(forecast)
library(zoo)
library(pracma)
library(xts)
library(lmtest)
library(devtools)
library(Rcpp)
library(lubridate)
#library(install_github)
library(EnvStats)
library(imputeTS)
library(car)
library(rmarkdown)


# libraries
# read in SAS dataset just prior to plotting
SAS_input<-read_sas("gradar_input.sas7bdat")
str(SAS_input)

#R package for radar plots
#install.packages("fmsb")
library(fmsb)

#requires wide format
columns<-SAS_input%>%select(JEI,indicator,PERCENT)%>%spread(indicator,PERCENT)

# just pull one creek with some exceedences for multiple params
# plot code doesnt want any categorical inputs e.g. creek so need to remove that column

cc18<-columns%>% filter(JEI=="CC18")
cc18x<-cc18[,2:7]  

# name the row so it ends up on the plot
rownames(cc18x) <- paste("cc18") # 

# To use the fmsb package, you have to add 2 lines to the dataframe: the max and min of each topic to show on the plot!
jei_dat <- rbind(rep(100,6) , rep(0,6) , cc18x)


# Stats for cc18
#   Chla agm    Chla_ratio     DO Exceed    Nitrate Ratio       TN AGM        TSI Score
#   18.18182	      0	          72.72727	     0	              18.18182  	18.18182

# simple chart not filled - this generates a plot without fill and all indicators look right except DOsat which is supposed to be 72
# a more custion chart is attempted next
radarchart(jei_dat)

??radarchart

# Customizable chart
# axistype = 3 is used to label all inner radii and seg=5 is used to creae radii from 0 to 100

# control fill attributes
colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9), rgb(0.7,0.5,0.1,0.9) )
colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )

# plot with defined options:
radarchart( jei_dat, axistype=3 , 
            #custom polygon
            pcol=colors_border , pfcol=colors_in , plwd=5 , plty=1,seg=5,
            #custom the grid
            cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,100,20), cglwd=1,
            #custom labels
            vlcex=0.8 
)

# Add a legend - currently this doesnt work but is mostly used when overlaying multiple creeks on same plot which we probably wont do.  
legend(x=0.7, y=1, legend = rownames(jei_dat[-c(1,2),]), bty = "n", pch=20 , col=colors_in , text.col = "grey", cex=1.2, pt.cex=3)


utils::edit(radarchart)  # looks to be old style coding- pre ggplot?












