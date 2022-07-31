#Import the dataset and eliminate NULL values

setwd("C:/Users/cassi/Desktop/Academia/ITC/Big Geodata Processing/GroupProject/Data")
obs = read.table("finalobs.csv", sep = ",", header = T, dec = ".")
obs.nonull = obs[obs$observation != "NULL",]

#NON-STATIC VARIABLES

#For the explanatory analysis of non-static data (precipitation, temperature), generate
#histograms to understand the temporal variations in observations.

#First, convert the factors to numeric variables to enable the aggregaton function.

obs.nonull.num = lapply(obs.nonull, function(x) type.convert(as.character(x)))

#Aggregate the observations according to: (1) sum of observations per day; (2) average
#of precipitation per day; (3) average of temperature per day.

obs.agg.obs = aggregate(obs.nonull.num$observation, by=list(date=obs.nonull.num$obsdate), FUN=sum)
colnames(obs.agg.obs) <- c("Date", "Obs")
obs.agg.prec = aggregate(obs.nonull.num$precip, by=list(date=obs.nonull.num$obsdate), FUN=mean)
colnames(obs.agg.prec) <- c("Date", "Prec")
obs.agg.temp = aggregate(obs.nonull.num$temper, by=list(date=obs.nonull.num$obsdate), FUN=mean)
colnames(obs.agg.temp) <- c("Date", "Temp")

#Join the aggregated values into a new data frame.

install.packages("plyr")
library(plyr)
obs.nonstatic = join(obs.agg.obs, obs.agg.prec, by="Date")
obs.nonstatic = join(obs.nonstatic,obs.agg.temp, by="Date", type="left")

#STATIC VARIABLES

#For the explanatory analysis of static data (land use, road length), generate
#graphs to understand the spatial variations in observations.

#Extract information on land use and road length per block

obs.static.1 = obs.nonull[!duplicated(obs.nonull$block, fromLast=TRUE),]
obs.static.1 = obs.static.1[,-c(2,3,4,5,8)]
colnames(obs.static.1) <- c("Block", "Landuse","Roadlength")

#Aggregate the observations according to the sum of observations per block

obs.static.2 = aggregate(obs.nonull.num$observation, by=list(date=obs.nonull.num$block), FUN=sum)
colnames(obs.static.2) <- c("Block", "Obs")

#Join the values into a new data frame.

obs.static = join(obs.static.1, obs.static.2, by="Block")

#In the case of the land use, the observations will be aggregates according to the land use
#category. In this way, it will be possible to estimate the average number of observations
#per block for each land use class.

#First, a count column will be added to the data frame to represent the number of blocks
#per land use

obs.static$Count = 1

#Then, the observations and the count columns will be aggregated according to the land use.

obs.static.luse.1 = aggregate(obs.static$Count, by=list(landuse=obs.static$Landuse), FUN=sum)
colnames(obs.static.luse.1) <- c("Landuse", "NrBlocks")
obs.static.luse.2 = aggregate(obs.static$Obs, by=list(landuse=obs.static$Landuse), FUN=sum)
colnames(obs.static.luse.2) <- c("Landuse", "Observations")

#Join the values into a new data frame

obs.static.luse = join(obs.static.luse.1, obs.static.luse.2, by="Landuse")

#Calculate the average number of observations per block per land use category

obs.static.luse$Avg.obs = obs.static.luse$Observations/obs.static.luse$NrBlocks

#Export the results

write.table(obs.nonstatic, "obs.nonstatic.txt", sep = "\t", col.names = T, row.names = F)
write.table(obs.static, "obs.static.txt", sep = "\t", col.names = T, row.names = F)
write.table(obs.static.luse, "obs.static.luse.txt", sep = "\t", col.names = T, row.names = F)
