if("ggplot2" %in% rownames(installed.packages()) == FALSE) {
  install.packages("ggplot2")
}
library(ggplot2);

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

# Prepare Baltimore data
if (is.null(d$baltimore_data)) {
  message(" * Selecting Baltimore data")
  d$baltimore_data <- d$NEI[d$NEI$fips == "24510",]
  d$baltimore_data <- d$baltimore_data[order(d$baltimore_data$type),];
}


# Prepare vehicle data
if (is.null(d$baltimore_vehicle_data)) {
  message(" * Selecting baltimore vehicle data");
  # Select rows which has vehicle word in it
  subset <- grepl("vehicle", d$SCC$SCC.Level.Two, ignore.case=T);
  # filter rows by leaving only combustion and coal data
  subsetSCC <- d$SCC[subset,];
  # Select SCC_PM25 rows only where SCC value is in the subset created above
  d$baltimore_vehicle_data <- d$baltimore_data[d$baltimore_data$SCC %in% subsetSCC$SCC,];
}

message(" * Making plot 5");

png(filename = "plot5.png", width = 480, height = 480, units = "px");

g <- ggplot(d$baltimore_vehicle_data,aes(factor(year),Emissions)) +
  geom_bar(stat="identity", fill="blue") +
  labs(x="year", y="Total PM2.5 Emission") + 
  labs(title="Motor Vehicle Source Emissions in Baltimore (1999-2008)");

print(g);

dev.off();
message("Done");
