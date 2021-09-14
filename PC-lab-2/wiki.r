################################################################################
## Filename: wiki.r
## Description:
## Author: Helge Liebert
## Created: Di Jan  8 18:23:16 2019
## Last-Updated: Di Sep 14 17:29:43 2021
################################################################################


## install and load required library
## install.packages("rvest", dependencies = TRUE)
library(rvest)


#============================ SCRAPING A WIKI TABLE ============================

## 1) fetch and parse the website
page <- read_html("https://en.wikipedia.org/wiki/Infant_mortality")
## 2) extract the html node containing the table
table <- html_node(page, xpath = "//*[@id='mw-content-text']/div/table[3]")
## 3) extract the table as a data frame
mrates <- html_table(table)
mrates


#================== INVESTIGATING PAGE ELEMENTS AND NAVIGATION =================

## list table nodes
html_nodes(page, "table")
## using css selectors or xpath is equivalent
table <- html_node(page, xpath = "//*[@id='mw-content-text']/div/table[2]")
table <- html_node(page, css = "table.wikitable:nth-child(129)")
html_table(table)


## check out links in the next table
table <- html_node(page, css = "table.wikitable:nth-child(134)")
html_nodes(table, "a") %>% html_attr("href")

## piping is the same as nested function calls
html_nodes(table, "a") %>% html_text("href")
html_text(html_nodes(table, "a"), "href")

## Filter Somalia
tablelinks <- html_attr(html_nodes(table, "a"), "href")
link <- grep("Somalia", tablelinks, value = TRUE)
link

## looking at html elements and their attributes
html_nodes(page, "link")
html_nodes(page, "a")
html_nodes(page, "table a")
html_nodes(page, "a") %>% html_attr("href")
html_nodes(table, "a") %>% html_attr("href")

## looking at links from link and anchor tags
html_nodes(page, "link") %>% html_attr("href")
html_nodes(page, "a") %>% html_attr("href")
html_attr(html_nodes(page, "a"), "href")


## follwing a link to another page
session <- html_session("https://en.wikipedia.org/wiki/Infant_mortality")
session <- follow_link(session, "Somalia")
page <- read_html(session)
table <- html_node(page, css = "table.wikitable:nth-child(130)")
regions <- html_table(table)
regions


#=============================== REGEX FILTERING ===============================

## filtering links
session <- html_session("https://en.wikipedia.org/wiki/Infant_mortality")
## page <- read_html("https://en.wikipedia.org/wiki/Infant_mortality")
page <- read_html(session)
wikilinks <- html_attr(html_nodes(page, "a"), "href")

## regex examples
links <- grep("^/wiki", wikilinks, value = TRUE)
links <- grep("^/wiki.*[0-9][0-9]$", wikilinks, value = TRUE)
links <- grep("^/wiki.*File:.*", wikilinks, value = TRUE)
links <- grep("^(?!.*:)/wiki/.*Mortality", wikilinks, value = TRUE, perl = TRUE)
links <- grep("^(?!.*:)(/wiki/.*Mortality)|(/wiki/.*Somalia)", wikilinks, value = TRUE, perl = TRUE)
links

# sometimes easier to do it in multiple steps for readability
links <- grep("^/wiki/", wikilinks, value = TRUE)
links <- grep("Mortality|Somalia", links, value = TRUE)
links <- grep(":", links, value = TRUE, invert = TRUE)
links

# select only internal links matching with mortality or somalia, no files or category pages
links <- grep("^(?!.*:)(/wiki/.*Mortality)|(/wiki/.*Somalia)", wikilinks,
              ignore.case = TRUE, value = TRUE, perl = TRUE)
links <- unique(links)
links

# navigate to linked page
session <- jump_to(session, links[1])
## session <- follow_link(session, linktext) ## This function takes the link html_text() as the argument
page <- read_html(session)
html_nodes(page, "title")

# navigate to linked page
session <- jump_to(session, links[5])
page <- read_html(session)
html_nodes(page, "title")
