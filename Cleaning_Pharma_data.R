## Feb 2 2017 ## Read the data from excel, join the data and clean it ##
## pharma data 

setwd("C:\\Users\\karthik\\Google Drive\\Course_projects\\Sem 6\\other_files\\AIS student challenges\\")

library(readxl)
library(dplyr)
library(stringr)
library(zipcode)
library(sp)
library(maps)
library(rworldmap)

phr_master <- read_excel("ABDataSet(WithDataSetMaster).xlsx",sheet = 2, col_names = TRUE, col_types = NULL, na = "", skip = 0)

prod_master <- read_excel("ABDataSet(WithDataSetMaster).xlsx",sheet = 3, col_names = TRUE, col_types = NULL, na = "", skip = 0)
major_prod_cat <- read_excel("ABDataSet(WithDataSetMaster).xlsx",sheet = 4, col_names = TRUE, col_types = NULL, na = "", skip = 0)
prod_cat <- read_excel("ABDataSet(WithDataSetMaster).xlsx",sheet = 5, col_names = TRUE, col_types = NULL, na = "", skip = 0)
prod_subcat <- read_excel("ABDataSet(WithDataSetMaster).xlsx",sheet = 6, col_names = TRUE, col_types = NULL, na = "", skip = 0)
prod_seg <- read_excel("ABDataSet(WithDataSetMaster).xlsx",sheet = 7, col_names = TRUE, col_types = NULL, na = "", skip = 0)
trans <- read_excel("ABDataSet(WithDataSetMaster).xlsx",sheet = 8, col_names = TRUE, col_types = NULL, na = "", skip = 0)

trans_all <- read.csv("ABPOSTrans(Big).csv")

a1 <- left_join(trans,phr_master)
a2 <- left_join(a1,prod_master)
a3 <- left_join(a2,prod_cat)
a4 <- left_join(a3,major_prod_cat)
a5 <- left_join(a4,prod_subcat)
# a6 <- left_join(a5,prod_seg[-nrow(prod_seg),])

a5$Month <- substr(as.character(a5$SLS_DTE_NBR), 5, 6)
a5$Year <- substr(as.character(a5$SLS_DTE_NBR), 1, 4)
a5$Day <- substr(as.character(a5$SLS_DTE_NBR), 7, 8)

a5$Date <- as.Date(paste(a5$Day,"-",a5$Month,"-",a5$Year,sep=""), format='%d-%m-%Y')

a5$Zipcode <- as.factor(paste(a5$ZIP_3_CD,"10",sep=""))

a5 <- a5[,!names(a5) %in% c("")]

data(zipcode)
plotZip <- zipcode[a5$Zipcode, c("longitude", "latitude")]
a6 <- cbind(a5,plotZip)


# plot(0,type='n',axes=FALSE,ann=FALSE)
# print(plot(SpatialPoints(plotZip), pch=20, cex=0.75, add=TRUE, col="red"),newpage=F)

newmap <- getMap(resolution = "low")
# plot(newmap, xlim = c(15, -70), ylim = c(50, -60), asp = 1)
plot(newmap, asp = 1)
points(plotZip$latitude,plotZip$longitude, col = "red", cex = .6)

a7 <- a5[,!names(a5) %in% c("","ZIP_3_CD","Zipcode","BSKT_ID","SLS_DTE_NBR","Month","Year","Day")]
a7 <- as.data.frame(unclass(a7))
a7 <- a7[a7$SLS_QTY > 0,]
a7 <- a7[a7$EXT_SLS_AMT > 0,]

length(levels(a7$SUB_CAT_DESC))
length(levels(a7$CAT_DESC))
length(levels(a7$MAJOR_CAT_DESC))
length(levels(a7$PROD_DESC)) 

write.csv(a7,"For_tableau_viz.csv",na="",row.names=F)