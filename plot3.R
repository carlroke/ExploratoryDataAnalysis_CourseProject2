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

  # filter the data we are interested
  NEI<-subset(NEI,fips == "24510")
  
  #create plot file device
  plotfile="plot3.png"
  png(filename = plotfile,
      width = 960, 
      height = 960, 
      units = "px")
  
  #plot contains the sums of the years, with a regression line
  x <- aggregate(Emissions~year+type, data=NEI, sum)
  qplot(year, Emissions, data=x, 
        facets=.~type, 
        geom=c("point",  "smooth"),  
        method	=	"lm",
        ylab = "Total Baltimore Emissions (summed) in tons", 
        main="Plot/regression line for Baltimore PM25 by type from 1999-2008.")
  
#close device
dev.off()

  # ***** RESULTS *****
  # The emissions from 1999-2008:
  # - NON-ROAD decreases 89%
  # - NONPOINT decreases 35%
  # - ON-ROAD decreases  74%
  # - POINT increase     16%
  #  
  #   year    type      Sum of Emissions
  #   1  1999 NON-ROAD  522.94000
  #   2  2002 NON-ROAD  240.84692
  #   3  2005 NON-ROAD  248.93369
  #   4  2008 NON-ROAD   55.82356
  #   5  1999 NONPOINT  2107.62500
  #   6  2002 NONPOINT  1509.50000  
  #   7  2005 NONPOINT  1509.50000
  #   8  2008 NONPOINT  1373.20731
  #   9  1999  ON-ROAD  346.82000
  #   10 2002  ON-ROAD  134.30882
  #   11 2005  ON-ROAD  130.43038
  #   12 2008  ON-ROAD   88.27546
  #   13 1999    POINT   296.79500
  #   14 2002    POINT   569.26000
  #   15 2005    POINT  1202.49000
  #   16 2008    POINT  344.97518
  