rm(list=ls())

library(raster)
library(rgdal)
library(maptools)
library(animation)
library(tools)



red=5
green=4
blue=3
combo="543"

e <- extent(readOGR(dsn = "Z:\\DOCUMENTATION\\BART\\R\\R_DEV\\SO_questions", 
                    "SO_extent"))
ldata <- list.files(pattern = "*pre.ers")


for(i in 1:length(ldata)){
        date <- as.Date(substring(ldata[i], 14, 19),"%d%m%y")
        pname <- paste0(date, "-", combo, ".png")
        #fname <- paste0(here, "\\", pname)
        plab <- format(date, "%b %Y")
        b <- crop(brick(ldata[i]), e)
        png(filename = pname)#, width = 1800, height = 600
        #par(mar=c(8,6,4,2)+0.1)
        #         plotRGB(b, red, green, blue, stretch = 'lin', axes = TRUE, 
        #                 main = file_path_sans_ext(pname))
        plotRGB(b, red, green, blue, stretch = 'lin', axes = TRUE, 
                main = plab)
        dev.off()
        
}