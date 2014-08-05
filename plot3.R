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

# Prepare baltimore data
if (is.null(d$baltimore_data)) {
  message(" * Selecting Baltimore data");
  d$baltimore_data <- d$NEI[d$NEI$fips == "24510",];
  d$baltimore_data <- d$baltimore_data[order(d$baltimore_data$type),];
}

message(" * Making plot 3.1");

png(filename = "plot3.png", width = 480, height = 480, units = "px");


g <- ggplot(d$baltimore_data,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  facet_grid(.~type) +
  labs(x="Year",  y="Total Emmisions") + 
  labs(title="Total Emmisions by type in Baltimore from 1999 to 2008")

message(" * Making plot 3.2");


qp <- qplot(x=factor(year), y=Emissions, fill=type,
            data=d$baltimore_data, geom="bar", stat="identity",
            position="dodge") + labs(x="Year",  y="Total Emmisions");


grid.arrange(g,qp);

dev.off();

message("Done");
