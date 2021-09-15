################################################################################
## Filename: read.r
## Description: 
## Author: Helge Liebert
## Created: Mi. Aug 26 14:44:17 2020
## Last-Updated: Mi Sep 15 14:56:01 2021
################################################################################


#========================== reading all the txt files ==========================

library("stringr")
library("readr")
## library("data.table")

## set encoding (may be necessary on Windows)
## options(encoding = "UTF-8")
## options(encoding = "latin-1")
## options(max.print = 10000)

## conversion can also be executed from within R
## system() executes the cmd via the system shell
## system("for file in pdf/*.pd; do pdftotext "$file"; done")

## unzip
## system("unzip txt-utf-8.zip -d txt/")
## system("unzip txt-latin-1.zip -d txt/")

## get file names, w/ and w/o paths
files <- list.files(path = "txt/", pattern = "*.txt", full.names = TRUE)
names <- list.files(path = "txt/", pattern = "*.txt")

## read all
## content <- lapply(files, readr::read_file)

## read only sample of 100 documents, faster on cluster
## content <- lapply(files[sample(length(files), 10)], readr::read_file)

## alternative using base, may need tweaking with encoding based on locale and OS
## content <- lapply(files, function(f) readChar(f, nchars = file.info(f)$size))

## read only limited part, to preserve memory (first 100 bytes, or 100 lines)
## content <- lapply(files, function(f) readChar(f, nchars = 100))
content <- lapply(files, function(f) readLines(f, n = 100))

# read as data
data <- as.data.frame(cbind(names, content))
names(data)
str(data)

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

#============================= Filter/clean content ============================

## remove supplementary material
data <- data[!grepl("^Supplemental", data$content), ]

## check initial metadata
head(data$content)
data$content[5]

## remove JSTOR metadata page
data$content <- gsub("^.* are collaborating with JSTOR to digitize.*?\\.", "", data$content)
head(data$content)
