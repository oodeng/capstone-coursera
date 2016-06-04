#setwd("/user/documents/github/capstone-coursera")
# source("BuildModel.R")
load('data/predict2hash.RData')
load('data/predict3hash.RData')
load('data/predict4hash.RData')

bigramPredict <- function(x) {
  xclean <- removeNumbers(removePunctuation(tolower(x)))
  xs <- tail(strsplit(xclean, " ")[[1]], 1)
  predict2hash[[xs]]
}

trigramPredict <- function(x) {
  xclean <- removeNumbers(removePunctuation(tolower(x)))
  xs <- tail(strsplit(xclean, " ")[[1]], 2)
  predict3hash[[paste(xs, sep="_", collapse='_')]]
}

quadgramPredict <- function(x) {
  xclean <- removeNumbers(removePunctuation(tolower(x)))
  xs <- tail(strsplit(xclean, " ")[[1]], 3)
  predict4hash[[paste(xs, sep="_", collapse='_')]]
}

predictAll <- function(x) {
  p4 <- quadgramPredict(x)
  if (!is.null(p4)) {
    p4
  } else {
    p3 <- trigramPredict(x)
    if (!is.null(p3)) {
      p3
    } else {
      p2 <- bigramPredict(x)
      if (!is.null(p2)) {
        p2
      } else {
        'the'
      }
    }
  }
}
