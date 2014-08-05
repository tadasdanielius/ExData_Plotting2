zip_file <- "NEI_data.zip";
data_file1 <- "summarySCC_PM25.rds";
data_file2 <- "Source_Classification_Code.rds"
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip";

download <- function() {
  if (!file.exists(zip_file)) {
    message(" * downloading from original location")
    download.file(url,method="curl",destfile=zip_file);
  }
}

load_data <- function() {
  download();
  if(!(file.exists(data_file1) || file.exists(data_file2))) { 
    extract_archive();
  }
  message (" * Loading data");

  data <- NULL;
  data$SCC_PM25 <- NULL;
  data$SCC <- NULL;
  
  data$SCC_PM25 <- readRDS(data_file1);
  data$SCC <- readRDS(data_file2);
  data
  
}

extract_archive <- function() {
  message(" * Extracting data");
  unzip(zipfile = zip_file);
}
