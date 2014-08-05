if("ggplot2" %in% rownames(installed.packages()) == FALSE) {
  install.packages("ggplot2")
}
if("gridExtra" %in% rownames(installed.packages()) == FALSE) {
  install.packages("gridExtra")
}
library(gridExtra);
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

# Prepare Baltimore and Los Angeles County data
if (is.null(d$Baltimore_LA_data)) {
  message(" * Selecting Baltimore and Los Angeles County data")
  
  B_LA_NEI <- d$NEI[d$NEI$fips %in% c("24510","06037"),];
  B_LA_NEI$City[B_LA_NEI$fips == "24510"] <- "Baltimore";
  B_LA_NEI$City[B_LA_NEI$fips == "06037"] <- "Los Angeles County";
  d$Baltimore_LA_data <- B_LA_NEI;
}

# Prepare Baltimore and LA vehicle data
if (is.null(d$Baltimore_LA_vehicle_data)) {
  message(" * Selecting baltimore vehicle data");
  # Select rows which has vehicle word in it
  subset <- grepl("vehicle", d$SCC$SCC.Level.Two, ignore.case=T);
  # filter rows by leaving only combustion and coal data
  subsetSCC <- d$SCC[subset,];
  # Select SCC_PM25 rows only where SCC value is in the subset created above
  d$Baltimore_LA_vehicle_data <- d$Baltimore_LA_data[d$Baltimore_LA_data$SCC %in% subsetSCC$SCC,];
  # Sort data by city name
  d$Baltimore_LA_vehicle_data <- d$Baltimore_LA_vehicle_data[order(d$Baltimore_LA_vehicle_data$City),]
}

message(" * Making plot 6.1");

png(filename = "plot6.png", width = 480, height = 480, units = "px");

g <- ggplot(d$Baltimore_LA_vehicle_data, aes(x=factor(year), y=Emissions, fill=City)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~City) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="year", y="Total PM2.5 Emissions") + 
  labs(title="PM2.5 Motor Vehicle Source Emissions in Baltimore and LA from 1999 to 2008")

message(" * Making plot 6.2")

g1 <- ggplot(d$Baltimore_LA_vehicle_data, aes(x=factor(year), y=Emissions, fill=City)) +
  geom_bar(stat="identity") +
  labs(x="year", y="Total PM2.5 Emissions")


grid.arrange(g,g1);
dev.off();

