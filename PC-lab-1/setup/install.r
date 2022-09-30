install.packages(
  c(
    "ada",
    "caret",
    "corpustools",
    "data.table",
    "devtools",
    "doc2vec",
    "factoextra",
    "fastNaiveBayes",
    "fpc",
    "ggrepel",
    "ghql",
    "glmnet",
    "gutenbergr"
    "h2o",
    "httr",
    "IRkernel",
    "jsonlite",
    "languageserver",
    "lexicon",
    "lintr",
    "lsa",
    "naivebayes",
    "plot3D",
    "plotly",
    "qdap",
    "quanteda",
    "ranger",
    "RCurl",
    "readtext",
    "reticulate",
    "RSelenium",
    "rvest",
    "SentimentAnalysis",
    "sentimentr",
    "slam",
    "spacyr",
    "stringr",
    "styler",
    "text",
    "text2vec",
    "textclean",
    "tidytext",
    "tidyverse",
    "tm",
    "topicmodels",
    "twfy",
    "udpipe",
    "uwot",
    "wdman",
    "webdriver",
    "word2vec",
    "wordcloud",
    "xml2"
  ), dependencies = TRUE
)

## packages not on CRAN
devtools::install_github("bnosac/golgotha", INSTALL_opts = "--no-multiarch")

## Install the R notebook kernel If you want to use through the jupyter notebooks
## You need to install jupyter by installing anaconda or through python pip before doing so.
install.packages("IRkernel")
IRkernel::installspec()

