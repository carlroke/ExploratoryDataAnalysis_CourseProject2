  # Clean up workspace
  rm(list=ls())
  
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
 
  #create plot file device
  plotfile="plot1.png"
  png(filename = plotfile,
      width = 960, 
      height = 960, 
      units = "px")
  
  #plot contains the sums of the years, with a regression line
  x <- aggregate(Emissions~year, data=NEI, sum)
  plot(x$year,
       x$Emissions,
       xlab = "year",
       ylab = "Total US Emissions (summed) in tons")
  y <- lm(Emissions~year, x)
  abline(y, lwd = 2)  
  title(main="Plot/regression line showing decreasing PM25 from 1999-2008.")
  
  
#close device
dev.off()
  
  # ***** RESULTS *****
  # The emissions were reduced about 52.8% from 1999-2008
  #  
  #  year    Sum of Emissions
  #  1 1999  7332967
  #  2 2002  5635780
  #  3 2005  5454703
  #  4 2008  3464206
  