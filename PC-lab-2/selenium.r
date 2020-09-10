################################################################################
## Filename: selenium.r
## Description: Options of running selenium server
## Author: Helge Liebert
## Created: Di Mär  3 13:11:44 2020
## Last-Updated: Do. Sep 10 17:26:48 2020
################################################################################

## Variant 1 for running selenium is preferred, 2 and 3 are discouraged.


#================================== Libraries ==================================

library(RSelenium)
library(wdman)


#================================== Variant 1 ==================================

## Connect to browser running in docker container. This is the preferred option.

## Run selenium in a docker container
## docker run -d -p 4445:4444 selenium/standalone-chrome
## docker run -d -p 4445:4444 selenium/standalone-firefox
## to see the browser
## docker run -d -p 5901:5900 -p 127.0.0.1:4445:4444 --link http-server selenium/standalone-firefox-debug:2.53.1
## provides info
## docker ps

## Connect to server
remDr <- RSelenium::remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox"
)
remDr$open()


#================================== Variant 2 ==================================

## Initiate binary (ff, chrome, phantomjs) provided by library(wdman) using
## rsDriver(). Could also run this headless using the appropriate options,
## faster as it does not show the browser window.
rD <- RSelenium::rsDriver(browser = "firefox", port = 4567L)
remDr <- rD$client


#================================== Variant 3 ==================================

## Download and run Selenium binary directly, not recommended
## (but unlike the others, this works on binder, only relevant for teaching)

## Run in terminal:
## curl -O https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar
## java -jar selenium-server-standalone-3.141.59.jar -port 4445

## And connect
remDr <- RSelenium::remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox"
)
remDr$open()

## Headless preferred (required on binder)
remDr <- RSelenium::remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox",
  extraCapabilities = list(
    "moz:firefoxOptions" = list(
      args = list(
        "--headless",
        "--window-size=1920x1080"
      )
    )
  )
)
remDr$open()


#=============================== Test navigation ===============================

## Navigate to site, print title
site <- "https://www.unibas.ch"
remDr$navigate(site)
remDr$getTitle()
remDr$screenshot(display = TRUE)

# Find link and click it
link <- remDr$findElement(using = "link text", "Studium")
link$clickElement()

remDr$getTitle()
remDr$screenshot(display = TRUE)

## Close session
remDr$close()

## Stop selenium server (docker or jar) by ending the terminal process
## (using CTRL + c).

## If using rsDriver(), stop selenium server from R.
## rD$server$stop()
