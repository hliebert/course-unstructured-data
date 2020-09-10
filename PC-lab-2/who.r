################################################################################
## Filename: who.r
## Description:
## Author: Helge Liebert
## Created: Do Feb 27 17:18:06 2020
## Last-Updated: Mi Jul 22 15:10:01 2020
################################################################################

## Load libraries
library(rvest)
library(xml2)

## The site
## More info: "http://apps.who.int/bloodproducts/snakeantivenoms/database/"
site <- "http://apps.who.int/bloodproducts/snakeantivenoms/database/SearchFrm.aspx"

## Initiate session on site
session <- html_session(site)

## Get all drop down options, value for submission and text
options <- html_nodes(session, css = "#ddlCountry > option")
countries <- data.frame(
  value  = html_attr(options, "value"),
  option = html_text(options)
)
countries <- countries[-1, ] # Trim first line

## Empty data frame to be filled
data <- data.frame(matrix(nrow = 0, ncol = 5))

## Get snake venom data for all countries in the list
for (opt in countries$value[1:2]) {

  ## display some information
  print(paste0(which(opt == countries$value), "/",
               nrow(countries), " ",
               countries[countries$value == opt, "option"]))

  ## set option and submit form
  form <- html_form(html_node(session, "#form1"))
  form <- set_values(form, "ddlCountry" = opt)
  newpage <- submit_form(session, form)

  ## Collect mortality statistics table
  snakeinfo <- html_node(newpage, css = "#SnakesGridView")
  snakeinfo <- html_table(snakeinfo, fill = TRUE, header = TRUE)
  snakeinfo$country <- countries[countries$value == opt, "option"]

  ## Append to data
  data <- rbind(data, snakeinfo[-1, ])
}

## Build header, add to data frame, write to file
header <- c("link", "category", "common name", "species name", "country")
names(data) <- header
write.table(t(header), "Data/who.csv", sep = ";",
            col.names = FALSE, row.names = FALSE)

## Look at data
head(data)

## Alternative to form submission: Construct request URL in the following form.
## https://apps.who.int/bloodproducts/snakeantivenoms/database/SnakeAntivenomListFrm.aspx?@CountryID=2
## Check network monitoring in Browser developer tools to see.

## Better alternative to collecting data in a data.frame (or any internal object):
## Write to disk immediately. Mitigates the risk of exhausting memory.
