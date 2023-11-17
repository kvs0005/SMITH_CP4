#Getting things started! First, I need to set my working directory
setwd("C:/Users/kvsmi/OneDrive/Desktop/BIOL_5800/SMITH_CP4/SMITH_PartB")

#Load in death data
Death_Data=read.csv(file="C:/Users/kvsmi/Downloads/DeathData.csv", header=TRUE)

#Making JPG
#Width was found by doing (90mm/25.4mm)*dpi
#Height was found by doing (180mm/25.4mm)*dpi
jpeg("SMITH_Death_3.jpg", width = 1062.99213, height = 2125.98425, res = 300)
par(mfrow = c(2, 1))

#Subset data to get rid of DC info
condition <- Death_Data$X != "District of Columbia"
subset_Death_Data <- subset(Death_Data, condition)

####Creating region vectors
state.region

#Creating the column to input vector data
subset_Death_Data$Region <- NA

#Northeast Vector
Northeast <- c("Connecticut","Rhode Island","Massachusetts","New Hampshire","Maine ","Vermont","New York ","New Jersey ","Pennsylvania ")
subset_Death_Data$Region[subset_Death_Data$X %in% Northeast] <- "Northeast"

#South Vector
South <- c("Delaware","Florida","Georgia ","Maryland","North Carolina","South Carolina","Virginia","West Virginia","Alabama","Kentucky","Mississippi","Arkansas ","Louisiana","Oklahoma","Texas","Tennessee")
subset_Death_Data$Region[subset_Death_Data$X %in% South] <- "South"

#Midwest Vector
Midwest <-  c("Illinois","Indiana","Michigan","Ohio","Wisconsin","Iowa","Kansas","Minnesota","Missouri","Nebraska","North Dakota","South Dakota")
subset_Death_Data$Region[subset_Death_Data$X %in% Midwest] <- "Midwest"

#West Vector
West <-c("Arizona","Colorado","Idaho","Montana ","Nevada","New Mexico ","Utah ","Wyoming","Alaska","Oregon","Washington","Hawaii","California")
subset_Death_Data$Region[subset_Death_Data$X %in% West] <- "West"

#Calculating Regional Means
#NE Mean
NE_mean_total <- mean(subset_Death_Data$TOTAL[subset_Death_Data$Region == "Northeast"], na.rm = TRUE)
print(NE_mean_total)

#S Mean
S_mean_total <- mean(subset_Death_Data$TOTAL[subset_Death_Data$Region == "South"], na.rm = TRUE)
print (S_mean_total)

#Midwest Mean
MD_mean_total <- mean(subset_Death_Data$TOTAL[subset_Death_Data$Region == "Midwest"], na.rm = TRUE)
print (MD_mean_total)

#West
W_mean_total <- mean(subset_Death_Data$TOTAL[subset_Death_Data$Region == "West"], na.rm = TRUE)
print(W_mean_total)

####Anova test for MEAN DEATH RATE. Perform for each region (Northeast, South, Midwest, West)
#Northeast anova test
total_mean <- mean(subset_Death_Data$TOTAL, na.rm = TRUE)
northeast_mean <- mean(subset_Death_Data$TOTAL[subset_Death_Data$Region == "Northeast"], na.rm = TRUE)
subset_Death_Data$Northeast <- ifelse(subset_Death_Data$Region == "Northeast", "Northeast", "Other")
anova_result <- aov(TOTAL ~ Northeast, data = subset_Death_Data)
summary(anova_result)
NE_p_value <- (0.47)

#South anova test
South_mean <- mean(subset_Death_Data$TOTAL[subset_Death_Data$Region == "South"], na.rm = TRUE)
subset_Death_Data$South <- ifelse(subset_Death_Data$Region == "South", "South", "Other")
anova_result <- aov(TOTAL ~ South, data = subset_Death_Data)
summary(anova_result)
S_p_value <- (0.00663)

#Midwest anova test
Midwest_mean <- mean(subset_Death_Data$TOTAL[subset_Death_Data$Region == "Midwest"], na.rm = TRUE)
subset_Death_Data$Midwest <- ifelse(subset_Death_Data$Region == "Midwest", "Midwest", "Other")
anova_result <- aov(TOTAL ~ Midwest, data = subset_Death_Data)
summary(anova_result)
MW_p_value <- (0.415)

#West anova test
West_mean <- mean(subset_Death_Data$TOTAL[subset_Death_Data$Region == "West"], na.rm = TRUE)
subset_Death_Data$West <- ifelse(subset_Death_Data$Region == "West", "West", "Other")
anova_result <- aov(TOTAL ~ West, data = subset_Death_Data)
summary(anova_result)
W_p_value <- (2.65e-06)

####Anova test for MEAN HEART DEATH RATE. Perform for each region (Northeast, South, Midwest, West)
#Northeast Heart Anova Test
heart_total_mean <- mean(subset_Death_Data$HEART, na.rm = TRUE)
heart_northeast_mean <- mean(subset_Death_Data$HEART[subset_Death_Data$Region == "Northeast"], na.rm = TRUE)
subset_Death_Data$Northeast <- ifelse(subset_Death_Data$Region == "Northeast", "Northeast", "Other")
anova_result <- aov(HEART ~ Northeast, data = subset_Death_Data)
summary(anova_result)
heart_NE_p <- (0.165)

#South Heart Anova Test
heart_south_mean <- mean(subset_Death_Data$HEART[subset_Death_Data$Region == "South"], na.rm = TRUE)
subset_Death_Data$South <- ifelse(subset_Death_Data$Region == "South", "South", "Other")
anova_result <- aov(HEART ~ South, data = subset_Death_Data)
summary(anova_result)
heart_S_p <- (0.0109)

#Midwest Heart Anova Test
heart_midwest_mean <- mean(subset_Death_Data$HEART[subset_Death_Data$Region == "Midwest"], na.rm = TRUE)
subset_Death_Data$Midwest <- ifelse(subset_Death_Data$Region == "Midwest", "Midwest", "Other")
anova_result <- aov(HEART ~ Midwest, data = subset_Death_Data)
summary(anova_result)
heart_MW_p <- (0.455)

#West Heart Anova Test
#Getting mean of the heart west region data
heart_west_mean <- mean(subset_Death_Data$HEART[subset_Death_Data$Region == "West"], na.rm = TRUE)
#Subsetting
subset_Death_Data$West <- ifelse(subset_Death_Data$Region == "West", "West", "Other")
#ANOVA test
anova_result <- aov(HEART ~ West, data = subset_Death_Data)
summary(anova_result)
#Making vector
heart_W_p <- (1.85e-07)

####Making Boxplot of Heart Death Rates per Region (NE, S, MW, W)
#Getting death rates due to heart attack for each region

#Northest
NE_H_total <- sum(subset_Death_Data$HEART[subset_Death_Data$Region == "Northeast"])
print (NE_H_total)

#South
S_H_total <- sum(subset_Death_Data$HEART[subset_Death_Data$Region == "South"])
print (S_H_total)

#Midwest
MW_H_total <- sum(subset_Death_Data$H[subset_Death_Data$Region == "Midwest"])
print (MW_H_total)

#West
W_H_total <- sum(subset_Death_Data$HEART[subset_Death_Data$Region == "West"])
print (W_H_total)

#Generating boxplot
#Making vectors to represent Region data and HEART data
Region <- subset_Death_Data$Region
Deaths <- subset_Death_Data$HEART

#Actually graphing my boxplot using the vectors I just created
boxplot(Deaths ~ Region, data = subset_Death_Data, main = "Heart Attack Deaths per Region", cex.main = 0.75, cex.axis = 0.65)

#Adding sample size information
text(0.5:4, max(Deaths) * 0.9, paste("n =", table(Region)), pos = 4, col = "blue", cex = 0.5)

#Adding in my p-values calculated from my ANOVA tests above
#Midwest p-value
text(1, min(Deaths) * 1.1, paste("p =", round(MW_p_value, 4)), col = "red", cex = 0.5)

#Northeast p-value
text(2, min(Deaths) * 1.1, paste("p =", round(NE_p_value, 4)), col = "red", cex = 0.5)

#South p-value
text(3, min(Deaths) * 1.1, paste("p =", round(S_p_value, 4)), col = "red", cex = 0.5)

#West p-value

text(4, min(Deaths) * 1.1, paste("p =", round(W_p_value, 8)), col = "red", cex = 0.5)

####Making Pie Chart
#First, calculating percentages of the causes of the death in the South
#I am taking the total of each cause of death and dividing it by the total number of deaths in the South region

#HEART Attack Percentage
#Subsetting South data into a new dataframe
south_data <- subset(subset_Death_Data, Region == "South")
#I kept getting an error that HOMICIDE contained non-numeric numbers. To fix this, I used the command "as.numeric" to ensure only numeric characters were included
south_data$HOMICIDE <- as.numeric(as.character(south_data$HOMICIDE))
#Same issue with AIDS column, fixed by as.numeric
south_data$AIDS <- as.numeric(as.character(south_data$AIDS))
#Getting total number of South deaths
S_total <- sum(south_data$HEART, south_data$CANCER, south_data$STROKE, south_data$RESPIR, south_data$ACCID, south_data$VEHICLE, south_data$DIABETES, south_data$ALZHEIM, south_data$FLU, south_data$NEPHRITIS, south_data$SUICIDE, south_data$HOMICIDE, south_data$AIDS)
print (S_total)
S_Heart <- sum(south_data$HEART)
##Getting average
SH_per <- (S_Heart / S_total) * 100
print (SH_per)

#CANCER Percentage
S_Cancer <- sum(south_data$CANCER)
SC_per <- (S_Cancer / S_total) * 100
print (SC_per)

#STROKE Percentage
S_Stroke <- sum(south_data$STROKE)
SS_per <- (S_Stroke / S_total) * 100
print (SS_per)

#RESPIR Percentage
S_Respir <- sum(south_data$RESPIR)
SR_per <- (S_Respir / S_total) * 100
print (SR_per)

#ACCID Percentage
S_Accid <- sum(south_data$ACCID)
SA_per <- (S_Accid / S_total) * 100
print (SA_per)

#VEHICLE Percentage
S_Vehicle <- sum(south_data$VEHICLE)
SV_per <- (S_Vehicle / S_total) * 100
print (SV_per)

#DIABETES Percentage
S_Dia <- sum(south_data$DIABETES)
SD_per <- (S_Dia / S_total) * 100
print (SD_per)

#ALZHEIM Percentage
S_Alz <- sum(south_data$ALZHEIM)
SAlz_per <- (S_Alz / S_total) * 100
print (SAlz_per)

#FLU Percentage
S_Flu <- sum(south_data$FLU)
SF_per <- (S_Flu / S_total) * 100
print (SF_per)

#NEPHRITIS Percentage
S_Neph <- sum(south_data$NEPHRITIS)
SN_per <- (S_Neph / S_total) * 100
print (SN_per)

#SUICIDE Percentage
S_Sui <- sum(south_data$SUICIDE)
SSu_per <- (S_Sui / S_total) * 100
print (SSu_per)

#HOMICIDE Percentage
#Here, I was getting an error that non-numeric characters were in the homicide
#To fix this issue, I used the "as.numeric" command to ensure only numeric characters were included
south_data$HOMICIDE <- as.numeric(as.character(south_data$HOMICIDE))
S_Hom <- sum(south_data$HOMICIDE)
SHom_per <- (S_Hom / S_total) * 100
print (SHom_per)

#AIDS Percentage
#Same issue and solution as with HOMOCIDE
south_data$AIDS <- as.numeric(as.character(south_data$AIDS))
S_Aids <- sum(south_data$AIDS)
SAids_per <- (S_Aids / S_total) * 100
print (SAids_per)

#Putting my percentages into a pie chart
#Making a categories vector to store all the different death causes
categories <- c("Heart", "Cancer", "Stroke", "Respir", "Accid", "Vehicle", "Diabetes", "Alzheim", "Flu", "Nephritis", "Suicide", "Homicide", "AIDS")

#Making a percentages vector
percentages <- c(33.11679, 27.84334, 7.677199, 6.230869, 6.436637, 2.910516, 3.905347, 3.226821, 2.846745, 2.426706, 1.664002, 0.9854772, 0.7295422)

#Making a colours vector to add colour 
colors <- c("red", "orange", "green", "blue", "purple", "salmon","turquoise","springgreen4","magenta1","lightskyblue1","lavenderblush","thistle","grey14")

#Putting it all together. I use the pie command and my vectors to create my pie chart
pie(percentages, labels = sprintf("%0.3f%%", percentages), col = colors, main = "Heart Attack Deaths", cex = 0.4, cex.main = 0.75)

#Adding a legend to my pie chart
legend("bottomleft", legend = categories, fill = colors, title = "Legend", cex = 0.3)

dev.off()





