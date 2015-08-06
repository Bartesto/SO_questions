setwd("Z:\\DOCUMENTATION\\BART\\R\\R_DEV\\SO_questions")

library(ggplot2)
# library(animation)
# library(grid)
# library(gridExtra)
library(raster)
# library(gpclib)
# library(rgeos)
library(rgdal)
# library(maptools)
# library(tools)
library(plyr)

##Raster data for satellite background
t.name <- list.files(pattern = ".tif")
mb_ras <- stack(t.name)
mb_ras <- stretch(x=mb_ras, minv=0, maxv=255)
mb_df <- raster::as.data.frame(mb_ras, xy=T)
mb_df <- data.frame(x=mb_df[,1], y=mb_df[,2], b1=mb_df[,3], b2=mb_df[,4], 
                    b3=mb_df[,5], b4=mb_df[,6], b5=mb_df[,7],
                    b6=mb_df[,8])
mb_df <- mb_df[complete.cases(mb_df),]
rdate <- format(as.Date(substr(t.name, 1,10), "%Y-%m-%d"), "%b %Y")

##Shape files for overlay
enclosure <- readOGR(dsn = ".", layer = "Enclosure")
enclosure@data$id <- rownames(enclosure@data)
enclosure.points <- fortify(enclosure, region = "id")
enclosure.df <- join(enclosure.points, enclosure@data, by = "id")

site1 <- readOGR(dsn = ".", layer = "LG_site1")
site1@data$id <- rownames(site1@data)
site1.points <- fortify(site1, region = "id")
site1.df <- join(site1.points, site1@data, by = "id")

site2 <- readOGR(dsn = ".", layer = "LG_site2")
site2@data$id <- rownames(site2@data)
site2.points <- fortify(site2, region = "id")
site2.df <- join(site2.points, site2@data, by = "id")

map <- ggplot() +
        coord_equal() + theme_bw() + 
        geom_tile(data=mb_df, aes(x=x, y=y, fill=rgb(b5,b4,b3, 
                                                     maxColorValue = 255))) + 
        scale_fill_identity() +
        scale_x_continuous(breaks=c(304000, 350000),
                           labels=c(304000, 350000), expand = c(0,0)) +
        scale_y_continuous(breaks=c(7090000, 7130000), 
                           labels=c(7090000, 7130000), expand = c(0,0)) +
        theme(panel.grid=element_blank(), plot.title = element_text(size = 25))+
        xlab("")+ ylab("")+
        labs(title=rdate)

p1 <- map + geom_path(data=enclosure.df, aes(x=long,y=lat,group=group), 
                      colour="yellow", size=1)+#enclosure
        geom_path(data=site1.df, aes(x=long,y=lat,group=group), 
                  colour="red", size=3)+#site 1
        geom_path(data=site2.df, aes(x=long,y=lat,group=group), 
                  colour="blue", size=3)#site 2
