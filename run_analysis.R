
library(data.table)

setwd("F:/8 Mile/Downloads/Getting and Cleaning Data by Johns Hopkins University/Project")

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file( url, destfile = "data.zip" )
unzip("data.zip")

trainfile <- list.files( "train", full.names = TRUE )[-1]
testfile  <- list.files( "test" , full.names = TRUE )[-1]

# Read in all six files
file <- c( trainfile, testfile )
data <- lapply( file, read.table, stringsAsFactors = FALSE, header = FALSE )


# Step 1 : Merges the training and the test sets 
data1 <- mapply ( rbind, data[ c(1:3) ], data[ c(4:6) ] )

data2 <- do.call( cbind, data1 )



featurenames <- fread( list.files()[2], header = FALSE, stringsAsFactor = FALSE )

# set the column names for data
setnames( data2, c(1:563), c( "subject", featurenames$V2, "activity" ) )

# Extract only the column that have mean() or std() 
measurements <- grep( "std|mean\\(\\)", featurenames$V2 ) + 1

data3 <- data2[, c( 1, measurements, 563 ) ]

#Use descriptive activity names 

activitynames <- fread( list.files()[1], header = FALSE, stringsAsFactor = FALSE )

data3$activity <- activitynames$V2[ match( data3$activity, activitynames$V1 ) ]


# creates independent tidy data set

data4 <- aggregate( . ~ subject + activity, data = data3, FUN = mean )


setwd("F:/8 Mile/Downloads/Getting and Cleaning Data by Johns Hopkins University/Project")
write.table( data4, "averagedata.txt", row.names = FALSE )



