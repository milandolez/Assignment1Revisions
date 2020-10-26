

#rm(list=ls()) removed from original file
#imports audubon data 
audubon_data <- read.table("audubon_data.csv",header=TRUE,sep=",")
audubon_data <- as.data.frame(audubon_data)
#converts longitude and latitude into decimal degrees
audubon_data$Longitude <- as.numeric(substr(audubon_data$Longitude,2,nchar(audubon_data$Longitude)))
audubon_data$Latitude <- as.numeric(substr(audubon_data$Latitude,2,nchar(audubon_data$Latitude)))
audubon_data$Longitude <- (audubon_data$Longitude)*(-1)
#converts blank spaces and nontransects to NA
audubon_data[audubon_data==""]<- NA
audubon_data$Survey_Type <- gsub(pattern="non", NA, audubon_data$Survey_Type)
#changes all transects to the same formatting
audubon_data$Survey_Type <- tolower(audubon_data$Survey_Type)
audubon_data$Survey_Type[grep(pattern="transect",audubon_data$Survey_Type)] <- "transect"
#changes date formatting
audubon_data$Date <-as.Date(audubon_data$Date, format="%m/%d/%y")
#constructs new data frame with only the necessary columns
audubon_data <- audubon_data[,c("Longitude", "Latitude", "Date", "Survey_Type")]

#imports gw data
gw_data <- read.table("gw_data_mac.csv",header=TRUE,sep=",")
#converts blank spaces and nontransects to NA 
gw_data[gw_data==""]<- NA
gw_data$Survey_Type <- gsub(pattern="non", NA, gw_data$Survey_Type) #added since "first commit"
#changes date formatting
gw_data$Date <-as.Date(gw_data$Date, format="%d-%b-%y")
#changes all transects to the same formatting
gw_data$Survey_Type <- tolower(gw_data$Survey_Type)
gw_data$Survey_Type[grep(pattern="transect",gw_data$Survey_Type)] <- "transect"
#converts longitude and latitude into decimal degrees
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
#constructs new data frame with only the necessary columns
gw_data <- gw_data[,c("Longitude", "Latitude", "Date", "Survey_Type")]

#imports nat geo data
nat_geo_data <- read.table("nat_geo_data.csv",header=TRUE,sep=",")
#converts blank spaces and nontransects to NA
nat_geo_data[nat_geo_data==""]<- NA
nat_geo_data$Survey_Type <- gsub(pattern="non", NA, nat_geo_data$Survey_Type) #added since "first commit"
#changes all transects to the same formatting
nat_geo_data$Survey_Type <- tolower(nat_geo_data$Survey_Type)
nat_geo_data$Survey_Type[grep(pattern="transect",nat_geo_data$Survey_Type)] <- "transect"
#changes date formatting
nat_geo_data$Date <-as.Date(nat_geo_data$Date, format="%Y-%m-%d")
#removes data points where longitude and latitude are swapped (new change since "first commit")
nat_geo_data$Latitude[which(nat_geo_data$Longitude >= 0)] <- NA
nat_geo_data <- na.omit(nat_geo_data)
#constructs new data frame with only the necessary columns
nat_geo_data <-nat_geo_data[,c("Longitude", "Latitude", "Date", "Survey_Type")]

#combines three data frames and subsets the transects only
clean_data <- rbind(audubon_data,nat_geo_data, gw_data)
clean_data <- subset(clean_data, Survey_Type=="transect")
#subsets only data points from on and after 2010-01-01
clean_data <- subset(clean_data, Date>="2010-01-01")
#renames subsetted data frame rows 
row.names(clean_data) <- 1:nrow(clean_data)
#writes a new csv file with the combined and cleaned data
write.csv(clean_data, file = "my_clean_data.csv", row.names = FALSE)
