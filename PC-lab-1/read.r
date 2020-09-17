################################################################################
## Filename: read.r
## Description: 
## Author: Helge Liebert
## Created: Mi. Aug 26 14:44:17 2020
## Last-Updated: Mi. Sep 16 19:05:35 2020
################################################################################


#========================== reading all the txt files ==========================

library(stringr)
library(readr)

## get file names, w/ and w/o paths
files <- list.files(path = "txt/", pattern = "*.txt", full.names = TRUE)
names <- list.files(path = "txt/", pattern = "*.txt")

## read only first 100 bytes, to preserve memory
content <- lapply(files, function(f) readChar(f, nchars = 100))

## read all
## content <- lapply(files, readr::read_file)
## content <- lapply(files, function(f) readChar(f, nchars = file.info(f)$size))

# read as data
data <- as.data.frame(cbind(names, content))
head(data)

## regex to get author names
data$names <- gsub("\\.txt$", "", data$names)
data$author <- gsub(" - .*$", "", data$names)
head(data)

## cleaner, no false positives (check first obs)
data$author <- str_extract(data$names, "^.*?( - )")
data$author <- gsub(" - ", "", data$author)
head(data)

## same for year
data$year <- str_extract(data$names, " - (20|19)[0-9][0-9] - ")
data$year <- gsub(" - ", "", data$year)
head(data)

## same for title
data$title <- str_extract(data$names, " - .*$") ## not good, title may contain hyphen
data$title <- str_extract(data$names, " - (20|19)[0-9][0-9] - .*$")
data$title <- gsub("^ - (20|19)[0-9][0-9] - ", "", data$title)
head(data)

## trim whitespace everywhere
data$author <- trimws(data$author)
data$year <- trimws(data$year)
data$title <- trimws(data$title)
head(data)


#========================= reading the single txt file =========================

example <- read.table("example.csv", sep =";") 

options(scipen = 9999)
head(example)
dim(example)
stopifnot(ncol(example)==2)

names(example) <- c("id", "ad")
example$ad <- trimws(example$ad)
head(example)
head(example$ad)

# fix character encoding
Encoding(example$ad) <- "UTF-8"
head(example)
