################################################################################
## Filename: who.r
## Description:
## Author: Helge Liebert
## Created: Do Feb 27 17:18:06 2020
## Last-Updated: Do Feb 27 21:17:25 2020
################################################################################

## Load libraries
library(rvest)

## The site, main info: "http://apps.who.int/bloodproducts/snakeantivenoms/database/"
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

## Build header and write to file
header <- c("link", "category", "common name", "species name", "country")
write.table(t(header), "Data/who.csv", sep = ";",
            col.names = FALSE, row.names = FALSE)

## Get snake venom data for all countries in the list
for (opt in countries$value) {
## for (opt in countries$value[1:2]) {

  ## display some information
  print(paste0(which(opt == countries$value), "/",
               nrow(countries), " ",
               countries[countries$value == opt, "option"]))

  ## set option and submit form
  form <- html_form(html_node(session, "#form1"))
  form <- set_values(form, "ddlCountry" = opt)
  newpage <- submit_form(session, form)

  ## Alternative: Construct request URL in the following form.
  ## https://apps.who.int/bloodproducts/snakeantivenoms/database/SnakeAntivenomListFrm.aspx?@CountryID=2
  ## Check network monitoring in Browser developer tools to see.

  ## Collect mortality statistics table
  snakeinfo <- html_node(newpage, css = "#SnakesGridView")
  snakeinfo <- html_table(snakeinfo, fill = TRUE, header = TRUE)
  snakeinfo$country <- countries[countries$value == opt, "option"]
  snakeinfo

  ## append to file
  write.table(snakeinfo, "Data/who.csv", sep = ";", append = TRUE,
              col.names = FALSE, row.names = FALSE)

}

## Wait, what is this? Data as they should be vs. data as they are
system("head -n 20 Data/who-complete.csv")
system("head -n 20 Data/who-not-complete.csv")
system("tail -n 20 Data/who-complete.csv")
system("tail -n 20 Data/who-not-complete.csv")

##  Check for Zimbabwe/check link in Browser
form <- html_form(html_node(session, "#form1"))
form <- set_values(form, "ddlCountry" = 211)
zbpage <- submit_form(session, form)
snakeinfo <- html_node(zbpage, css = "#SnakesGridView")

## These links contain Javascript and can't be followed
p2link <- html_node(zbpage, css = "#SnakesGridView a") %>% html_text()
zbpage2 <- follow_link(zbpage, p2link)

p2link <- html_node(zbpage, css = "#SnakesGridView a") %>% html_attr("href")
zbpage2 <- jump_to(zbpage, p2link)

## Solutions:
## -- Reverse engineer the internal API and construct a specific POST? Patch the forms?
## -- Or use Selenium.
