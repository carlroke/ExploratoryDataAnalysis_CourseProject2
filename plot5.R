  # Clean up workspace
  rm(list=ls())
  library (ggplot2)
  
  # load.extract the zip
  zipfile<-'FNEI_data.zip'
  if (!file.exists(zipfile)) {
    url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
    download.file(url, destfile=zipfile, method='curl')
    unzip(zipfile)
  }
  # read data files
  NEI <- readRDS("summarySCC_PM25.rds")
  #6497651 observations
  SCC <- readRDS("Source_Classification_Code.rds")
  #11717 observations

  # ****RATIONALE for motor vehicle data content****
  # using http://www.epa.gov/ttn/chief/net/2011nei/2011_nei_tsdv1_draft2_june2014.pdf as a reference,
  # 
  # I started by searching ALL the SCC columns for "motor", there were 3 columns containing it
  #   - SCC$Short.Name - good matches, mentions rockets, but its still motor related
  #   - SCC.Level.Three - one match for motocycles
  #   - SCC.Level.Four - one match for rockets, but its still motor related
  #
  # I took all the matches for these 3 categories and use these cases
  
  motor_veh<-c(grep("motor",unique(SCC$Short.Name), ignore.case=TRUE, value=TRUE))
  motor_veh_df<-subset(SCC,Short.Name %in% motor_veh)
  motor_veh<-c(grep("motor",unique(SCC$SCC.Level.Four), ignore.case=TRUE, value=TRUE))
  motor_veh_df<-rbind(subset(SCC,SCC.Level.Four %in% motor_veh),motor_veh_df)
  motor_veh<-c(grep("motor",unique(SCC$SCC.Level.Three), ignore.case=TRUE, value=TRUE))
  motor_veh_df<-rbind(subset(SCC,SCC.Level.Three %in% motor_veh),motor_veh_df)
  SCC<-motor_veh_df
  
  # filter the data we are interested
  NEI<-subset(NEI,fips == "24510") #Baltimore
    
  #merge the two datasets by the SCC number (default)
  master<-merge(NEI, SCC)
  
  #create plot file device
  plotfile="plot5.png"
  png(filename = plotfile,
      width = 960, 
      height = 960, 
      units = "px")
  
  #plot contains the sums of the years, with a regression line
  x <- aggregate(Emissions~year, data=master, sum)
  qplot(year, Emissions, data=x, 
        geom=c("point",  "smooth"),  
        method	=	"lm",
        ylim = c(.9, 21.5),
        ylab = "Total Yearly Emissions (summed) in tons", 
        main="Plot/regression line for Baltimore Motor vehicle related PM25 by from 1999-2008.")

  #close device
  dev.off()
  
# ***** RESULTS *****
# The results were very close, with the emissions reducing 14.8% from 1999-2008
# I changed the graph y limites to emphasize in on the decrease, here are the actual values:
#  
#  year  Emissions
#  1 1999  1.1200000
#  2 2002 21.0367887
#  3 2005 20.4481368
#  4 2008  0.9544111
  
  
