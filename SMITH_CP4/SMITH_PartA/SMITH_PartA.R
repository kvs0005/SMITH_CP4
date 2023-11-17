#Setting my working directory to Part A
setwd("C:/Users/kvsmi/OneDrive/Desktop/BIOL_5800/SMITH_CP4/SMITH_PartA")

#Loading in DOM and CAST lat/long data
DOM_data=read.csv(file="C:/Users/kvsmi/Downloads/DOM_lat_long (1).csv", header=FALSE)
CAST_data=read.csv(file="C:/Users/kvsmi/Downloads/CAST_lat_long.csv", header = FALSE)

##############Building my map##############

#First, load in "maps" package
install.packages("maps")
library(maps)

#Make .png
png("SMITH_MapA.png", width = 7 * 300, height = 4.5 * 300, res = 300)

#Add cast and dom data to the map
map("world",col = "lightgray", fill = TRUE, bg = "lightcyan")
points(CAST_data$V2, CAST_data$V1, col = "purple", pch = 16, cex = 0.8)
points(DOM_data$V2, DOM_data$V1, col = "orange", pch = 16, cex = 0.8)

#Add an axis to the map
axis(1, col = "black")
axis(2, col = "black")

#Add a title
title(main = "Distribution of M. domesticus vs M. casteneus", col.main = "black", font.main = 4)

#Add a legend
legend("bottomleft", legend = c("CAST", "DOM"), col = c("purple", "orange"), pch = 16, cex = 1.0, title = "Legend")

#Make lakes blue
map("lakes", col = "blue", fill = TRUE, add = TRUE, boundary = "black")

#Finish .png
dev.off()

