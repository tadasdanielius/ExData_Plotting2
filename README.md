# Exploratory Data Analysis #

Learn the essential exploratory techniques for summarizing data. This is the fourth course in the Johns Hopkins Data Science Specialization

Course is available [online](https://www.coursera.org/course/exdata "Exploratory Data Analysis") at [coursera](http://www.coursera.com)

## Course Project 2 ##

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

### Questions ###

1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the **base** ###### Plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

###### Data Preparation

```r
d$aggregated <- aggregate(Emissions ~ year, d$NEI, sum);
```

###### Plotting

```r
plot(d$aggregated, 
     type = "l", 
     col="blue", 
     xlab = "Year", 
     main = "Total Emissions in US 1999 to 2008",  
     ylab = "Total PM2.5 emmision")
```

![alt text](https://raw.githubusercontent.com/tadasdanielius/ExData_Plotting2/master/plot1.png "Plot 1")


2. Have total emissions from PM2.5 decreased in the **Baltimore City**, Maryland (```fips == "24510"```) from 1999 to 2008? Use the **base** ###### Plotting system to make a plot answering this question.

###### Data Preparation

```r
# Select only Baltimore
  d$baltimore_data <- d$NEI[d$NEI$fips == "24510",]
  
# Aggregate
d$aggregated <- aggregate(Emissions ~ year, d$NEI, sum);
```

###### Plotting

```r
barplot(d$baltimore_aggregated$Emissions, 
        names.arg = d$baltimore_aggregated$year,
        col="blue", 
        xlab = "Year", 
        main = "Total Emissions in Baltimore 1999 to 2008",  
        ylab = "Total PM2.5 emmision");

```

![alt text](https://raw.githubusercontent.com/tadasdanielius/ExData_Plotting2/master/plot2.png "Plot 2")


3. Of the four types of sources indicated by the ```type``` (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for **Baltimore City**? Which have seen increases in emissions from 1999–2008? Use the **ggplot2** ###### Plotting system to make a plot answer this question.

###### Data Preparation

```r
# Select only Baltimore
  d$baltimore_data <- d$NEI[d$NEI$fips == "24510",]
```

###### Plotting

```r
g <- ggplot(d$baltimore_data,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  facet_grid(.~type) +
  labs(x="Year",  y="Total Emmisions") + 
  labs(title="Total Emmisions by type in Baltimore from 1999 to 2008")

qp <- qplot(x=factor(year), y=Emissions, fill=type,
            data=d$baltimore_data, geom="bar", stat="identity",
            position="dodge") + labs(x="Year",  y="Total Emmisions");


grid.arrange(g,qp);
```

![alt text](https://raw.githubusercontent.com/tadasdanielius/ExData_Plotting2/master/plot3.png "Plot 3")

4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

###### Data Preparation

```r
  # Select only Baltimore
  # Select combustion and coal data
  subset <- (grepl("combustion", d$SCC$SCC.Level.One, ignore.case=T) & 
           grepl("coal", d$SCC$SCC.Level.Four, ignore.case=T));
  # filter rows by leaving only combustion and coal data
  subsetSCC <- d$SCC[subset,];
  # Select SCC_PM25 rows only where SCC value is in the subset created above
  d$combustion_data <- d$NEI[d$NEI$SCC %in% subsetSCC$SCC,];


```

###### Plotting

```r
g <- ggplot(d$combustion_data,aes(factor(year),Emissions)) +
  geom_bar(stat="identity", fill="blue") +
  labs(x="year", y="Total PM2.5 Emission") + 
  labs(title="Coal Combustion Source Emissions in US 1999-2008");
```

![alt text](https://raw.githubusercontent.com/tadasdanielius/ExData_Plotting2/master/plot4.png "Plot 4")

5. How have emissions from motor vehicle sources changed from 1999–2008 in **Baltimore City**?

###### Data Preparation

```r
# Prepare Baltimore data
d$baltimore_data <- d$NEI[d$NEI$fips == "24510",]

# Prepare vehicle data
# Select rows which has vehicle word in it
subset <- grepl("vehicle", d$SCC$SCC.Level.Two, ignore.case=T);
# filter rows by leaving only combustion and coal data
subsetSCC <- d$SCC[subset,];
# Select SCC_PM25 rows only where SCC value is in the subset created above
d$baltimore_vehicle_data <- d$baltimore_data[d$baltimore_data$SCC %in% subsetSCC$SCC,];
```

###### Plotting

```r
g <- ggplot(d$baltimore_vehicle_data,aes(factor(year),Emissions)) +
  geom_bar(stat="identity", fill="blue") +
  labs(x="year", y="Total PM2.5 Emission") + 
  labs(title="Motor Vehicle Source Emissions in Baltimore (1999-2008)");
```

![alt text](https://raw.githubusercontent.com/tadasdanielius/ExData_Plotting2/master/plot5.png "Plot 5")

6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in **Los Angeles County**, California (```fips == "06037"```). Which city has seen greater changes over time in motor vehicle emissions?

###### Data Preparation

```r
# Prepare Baltimore and Los Angeles County data
B_LA_NEI <- d$NEI[d$NEI$fips %in% c("24510","06037"),];
B_LA_NEI$City[B_LA_NEI$fips == "24510"] <- "Baltimore";
B_LA_NEI$City[B_LA_NEI$fips == "06037"] <- "Los Angeles County";
d$Baltimore_LA_data <- B_LA_NEI;

# Select rows which has vehicle word in it
subset <- grepl("vehicle", d$SCC$SCC.Level.Two, ignore.case=T);
# filter rows by leaving only combustion and coal data
subsetSCC <- d$SCC[subset,];
# Select SCC_PM25 rows only where SCC value is in the subset created above
d$Baltimore_LA_vehicle_data <- d$Baltimore_LA_data[d$Baltimore_LA_data$SCC %in% subsetSCC$SCC,];
# Sort data by city name
d$Baltimore_LA_vehicle_data <- d$Baltimore_LA_vehicle_data[order(d$Baltimore_LA_vehicle_data$City),]
```

###### Plotting

```r
g <- ggplot(d$Baltimore_LA_vehicle_data, aes(x=factor(year), y=Emissions, fill=City)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~City) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="year", y="Total PM2.5 Emissions") + 
  labs(title="PM2.5 Motor Vehicle Source Emissions in Baltimore and LA from 1999 to 2008")

g1 <- ggplot(d$Baltimore_LA_vehicle_data, aes(x=factor(year), y=Emissions, fill=City)) +
  geom_bar(stat="identity") +
  labs(x="year", y="Total PM2.5 Emissions")
  
grid.arrange(g,g1);
```

![alt text](https://raw.githubusercontent.com/tadasdanielius/ExData_Plotting2/master/plot6.png "Plot 6")
