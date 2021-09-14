################################################################################
## Filename: convert-and-read-txt.r
## Description:
## Author: Helge Liebert
## Created: Mo Sep  6 12:43:09 2021
## Last-Updated: Mo Sep  6 12:43:53 2021
################################################################################


#============= transform and read the single txt file from within R ============

## crude way of creating a readable file quickly using shell programs
## using sed to insert a ';' separator and line break such that ID and Text
## field can be read as a csv. you could also do this from the command line.
## note: this requires sed to be installed on your system.
## also, R requires double backslash escaping, and escaping nested quotations
## -- easier to do this in a shell, separate file provided.
## sed -e 's/^32[0-9]\{12\}$/"\n\0;"/' example-unix.txt > example.csv

## check structure
system("head input/example-unix.txt -n 100")

## match id, then replace with separator, linebreak, matched id, separator
system("sed -e 's/^32[0-9]\\{12\\}$/\"\\n\\0;\"/' input/example-unix.txt")

## piping doesn't work in R, workaround
# system("sed -e 's/^32[0-9]\\{12\\}$/\"\\n\\0;\"/' input/example-unix.txt > input/example.csv")
system("cp input/example-unix.txt input/example.csv")
system("sed -i -e 's/^32[0-9]\\{12\\}$/\"\\n\\0;\"/' input/example.csv")

# check and fix first/last row (could also do this in an editor)
system("head input/example.csv -n 10")
system("tail input/example.csv")

## -i operates on the file directly, 1d deletes the first line
system("sed -i '1d' input/example.csv")
# last row, $ selects last row, a appends the following characters
system("sed -i '$a\"' input/example.csv")

# check
system("head input/example.csv")
system("tail input/example.csv")


## Begin here: read csv
example <- read.table("input/example.csv", sep = ";")

options(scipen = 9999)
dim(example)
str(example)
head(example)
stopifnot(ncol(example) == 2)

names(example) <- c("id", "ad")
example$ad <- trimws(example$ad)
head(example)
head(example$ad)

# fix character encoding
Encoding(example$ad) <- "UTF-8"
head(example$ad)
