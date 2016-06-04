# LoadJavaModel

library(rJava)
.jinit(classpath=paste0(getwd(), '/java/lib/NGramPredict.jar'))
#.jaddClassPath(paste0(getwd(), '/java/lib/NGramPredict.jar'))
jPredict <- function(predictor, inputText) {
  rWrapper <- .jnew('io.shinyapps.russ.ngram.predict.PredictMain', predictor)
  .jcall(rWrapper, "S", 'predict', inputText)
}
