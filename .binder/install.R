## install.packages(
##   c(
##     "twfy",
##     "jsonlite",
##     "xml2",
##     "httr",
##     "rvest",
##     "RSelenium",
##     "wdman",
##     "webdriver",
##     "tm",
##     "quanteda",
##     "spacyr",
##     "readtext",
##     "tidyverse",
##     "tidytext",
##     "wordcloud",
##     "SentimentAnalysis",
##     "naivebayes",
##     "h2o",
##     "fastNaiveBayes",
##     "slam",
##     "lsa",
##     "glmnet",
##     "lexicon",
##     "qdap",
##     "textclean",
##     "text2vec",
##     "uwot",
##     "udpipe",
##     "ggrepel",
##     "factoextra",
##     "fpc",
##     "caret",
##     "RCurl",
##     "data.table",
##     "IRkernel",
##     "corpustools",
##     "plotly",
##     "plot3D",
##     "devtools",
##     "ranger",
##     "reticulate",
##     "Rcpp",
##     "gtools",
##     "ada"
##   ),
##   dependencies = TRUE
## )

install.packages("SentimentAnalysis")
install.packages("twfy")
devtools::install_github("bnosac/word2vec", dependencies = TRUE)
devtools::install_github("bnosac/doc2vec", dependencies = TRUE)
devtools::install_github("bnosac/golgotha", INSTALL_opts = "--no-multiarch")
