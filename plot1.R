prepare_data <- function() {
  # Check if helper code for downloading/unzipping and reading data exists
  if (file.exists("load_data.R")) {
    # Load data can be found in git repository https://github.com/tadasdanielius/ExData_Plotting2
    if (!exists("load_data")) { source("load_data.R"); }
    d <- load_data();
  } else {
    # load_data.R not found. Then fallback to simple method to load data
    # Files must be downloaded unzipped and present in working directory
    message (" * Loading data. Simple way");
    d <- NULL;
    d$NEI <- NULL;
    d$SCC <- NULL;
    d$NEI <- readRDS("summarySCC_PM25.rds")
    d$SCC <- readRDS("Source_Classification_Code.rds")
  }
  d
}

# First check if we really need to load it as it takes abit of time
if (!exists("d") || is.null(d) || is.null(d$NEI)) {
  d <- prepare_data();
}

# to save some time check if we have done this
if (is.null(d$aggregated)) {
  message (" * Aggregating data.")
  d$aggregated <- aggregate(Emissions ~ year, d$NEI, sum);
}

message(" * Making plot 1");
par(mar = c(4,4,1,1));
png(filename = "plot1.png", width = 480, height = 480, units = "px");

plot(d$aggregated, 
     type = "l", 
     col="blue", 
     xlab = "Year", 
     main = "Total Emissions in US 1999 to 2008",  
     ylab = "Total PM2.5 emmision")

dev.off();
message("Done");
