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
    
  
  # ****RATIONALE for this data content****
  # using http://www.epa.gov/ttn/chief/net/2011nei/2011_nei_tsdv1_draft2_june2014.pdf as a reference,
  # the most straigtforward approach is to:
  #   - use the SCC$EI.Sector column
  #   - search for "Fuel Comb" and "Coal"
  #
  # I found this uniquely identified the combustible coal categories without going into more granular columns
  #
  
  #using combustible coal categoried in the EI.Sector, subset only these categories
  combustible_coal<-grep("fuel comb.+coal",unique(SCC$EI.Sector), ignore.case=TRUE, value=TRUE)
  SCC<-subset(SCC,EI.Sector %in% combustible_coal)
  
  #merge the two datasets by the SCC number (default)
  master<-merge(NEI, SCC)
  
  #create plot file device
  plotfile="plot4.png"
  png(filename = plotfile,
      width = 960, 
      height = 960, 
      units = "px")
  
  #plot contains the sums of the years, with a regression line
  x <- aggregate(Emissions~year, data=master, sum)
  qplot(year, Emissions, data=x, 
        #col=type, 
        geom=c("point",  "smooth"),  
        method	=	"lm",
        ylab = "Total Yearly US Emissions (summed) in tons", 
        main="Plot/regression line for US Combustion Related Coal PM25 by from 1999-2008.")
  
#close device
dev.off()

  # ***** RESULTS *****
  # The US county combustible coal emissions were reduced about 40% from 1999-2008
  #  
  #  year    Sum of Emissions
  #  1 1999  572126.5
  #  2 2002  546789.2
  #  3 2005  552881.5
  #  4 2008  343432.2  
