rm(list=ls())
audubon_data <- read.table("/users/milandolezal/desktop/audubon_data.csv",header=TRUE,sep=",")
audubon_data <- as.data.frame(audubon_data)
audubon_data$Longitude <- as.numeric(substr(audubon_data$Longitude,2,nchar(audubon_data$Longitude)))
audubon_data$Latitude <- as.numeric(substr(audubon_data$Latitude,2,nchar(audubon_data$Latitude)))
audubon_data$Longitude <- (audubon_data$Longitude)*(-1)
audubon_data[audubon_data==""]<- NA
audubon_data$Survey_Type <- tolower(audubon_data$Survey_Type)
audubon_data$Survey_Type <- gsub(pattern="non", NA, audubon_data$Survey_Type)
audubon_data$Survey_Type[grep(pattern="transect",audubon_data$Survey_Type)] <- "transect"
audubon_data$Date <-as.Date(audubon_data$Date, format="%m/%d/%y")
audubon_data <- audubon_data[,c("Longitude", "Latitude", "Date", "Survey_Type")]

gw_data <- read.table("/users/milandolezal/desktop/gw_data_mac.csv",header=TRUE,sep=",")
gw_data[gw_data==""]<- NA
gw_data$Date <-as.Date(gw_data$Date, format="%d-%b-%y")
gw_data$Survey_Type <- tolower(gw_data$Survey_Type)
gw_data$Survey_Type[grep(pattern="transect",gw_data$Survey_Type)] <- "transect"
listicle<-strsplit(gw_data$Longitude, "°")
first <-as.numeric(sapply(listicle,"[[",1))
last <- sapply(listicle,"[[",2)
last<- (as.numeric(substr(last,1,nchar(last)-2))/60)
gw_data$Longitude  <- (first+last)*-1
listicle<-strsplit(gw_data$Latitude, "°")
first <-as.numeric(sapply(listicle,"[[",1))
last <- sapply(listicle,"[[",2)
last<- (as.numeric(substr(last,1,nchar(last)-2))/60)
gw_data$Latitude  <- (first+last)
gw_data <- gw_data[,c("Longitude", "Latitude", "Date", "Survey_Type")]

nat_geo_data <- read.table("/users/milandolezal/desktop/nat_geo_data.csv",header=TRUE,sep=",")
nat_geo_data[nat_geo_data==""]<- NA
nat_geo_data$Survey_Type <- tolower(nat_geo_data$Survey_Type)
nat_geo_data$Survey_Type[grep(pattern="transect",nat_geo_data$Survey_Type)] <- "transect"
nat_geo_data$Date <-as.Date(nat_geo_data$Date, format="%Y-%m-%d")
nat_geo_data <-nat_geo_data[,c("Longitude", "Latitude", "Date", "Survey_Type")]

clean_data <- rbind(audubon_data,nat_geo_data, gw_data)
clean_data <- subset(clean_data, Survey_Type=="transect")
clean_data <- subset(clean_data, Date>="2010-01-01")
row.names(clean_data) <- 1:nrow(clean_data)
write.csv(clean_data, file = "my_clean_data.csv", row.names = FALSE)

