# BuildModel
#setwd("/user/documents/github/capstone_project")
# source("/user/documents/github/capstone_project/BuildModel.R")
suppressWarnings(library(stringi))
suppressWarnings(library(stringr))
suppressMessages(library(tm))
suppressMessages(library(caTools))
suppressMessages(library(RWeka))
suppressMessages(library(hash))
suppressMessages(library(reshape))

data_zip_uri="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
data_zip_filename <- "Coursera-SwiftKey.zip"
if (!file.exists(data_zip_filename)) {
  download.file(data_zip_uri, destfile=data_zip_filename, method="curl")
  unzip(data_zip_filename)
}

blogs_filename = "final/en_US/en_US.blogs.txt.0.01"
news_filename = "final/en_US/en_US.news.txt.0.01"
twitter_filename = "final/en_US/en_US.twitter.txt.0.01"

UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))

dirSource <- DirSource(directory='final/en_us',
                       encoding='utf-8',
                       pattern='en_US.twitter.split.aa')
corpus <- Corpus(dirSource)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, content_transformer(removePunctuation))
corpus <- tm_map(corpus, content_transformer(removeNumbers))
#corpus_stemmed <- tm_map(corpus, content_transformer(stemDocument))
#corpus <- tm_map(corpus_stemmed, content_transformer(stemCompletion), dictionary=corpus)
#corpus_nostop <- tm_map(corpus, removeWords, stopwords("english"))

# Sets the default number of threads to use; see http://stackoverflow.com/questions/17703553/bigrams-instead-of-single-words-in-termdocument-matrix-using-r-and-rweka
options(mc.cores=1)

tdm1gram <- TermDocumentMatrix(corpus, control = list(tokenize = UnigramTokenizer))
tdm2gram <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer))
tdm3gram <- TermDocumentMatrix(corpus, control = list(tokenize = TrigramTokenizer))
tdm4gram <- TermDocumentMatrix(corpus, control = list(tokenize = QuadgramTokenizer))
#tdm1gram_nostop <- TermDocumentMatrix(corpus, control = list(tokenize = UnigramTokenizer))
#tdm2gram_nostop <- TermDocumentMatrix(corpus_nostop, control = list(tokenize = BigramTokenizer))
#tdm3gram_nostop <- TermDocumentMatrix(corpus_nostop, control = list(tokenize = TrigramTokenizer))

dfToHash <- function(df) {
  hash <- new.env(hash=TRUE, parent=emptyenv())
  for (ii in rev(seq(nrow(df)))) {
    key <- gsub(" ", "_", df[ii, 'predictor'])
    value <- df[ii, 'prediction']
    #cat (key, "<-", value, "\n")
    hash[[key]] <- value
  }
  hash
}

df1gram <- as.data.frame(inspect(tdm1gram))
df1gram$num <- rowSums(df1gram)
df1gram <- subset(df1gram, num > 1)
df1gram$prediction <- row.names(df1gram)
df1gram$predictor <- ""
df1gram <- subset(df1gram, select=c('predictor', 'prediction', 'num'))
df1gram <- df1gram[order(df1gram$predictor,-df1gram$num),]
row.names(df1gram) <- NULL

df2gram <- as.data.frame(inspect(tdm2gram))
df2gram$num <- rowSums(df2gram)
df2gram <- subset(df2gram, num > 1)
df2gram[c('predictor', 'prediction')] <- subset(str_match(row.names(df2gram), "(.*) ([^ ]*)"), select=c(2,3))
df2gram <- subset(df2gram, select=c('predictor', 'prediction', 'num'))
df2gram <- df2gram[order(df2gram$predictor,-df2gram$num),]
row.names(df2gram) <- NULL

predict2hash <- dfToHash(df2gram)

df3gram <- as.data.frame(inspect(tdm3gram))
df3gram$num <- rowSums(df3gram)
df3gram <- subset(df3gram, num > 1)
df3gram[c('predictor', 'prediction')] <- subset(str_match(row.names(df3gram), "(.*) ([^ ]*)"), select=c(2,3))
df3gram <- subset(df3gram, select=c('predictor', 'prediction', 'num'))
df3gram <- df3gram[order(df3gram$predictor,-df3gram$num),]
row.names(df3gram) <- NULL

predict3hash <- dfToHash(df3gram)

df4gram <- as.data.frame(inspect(tdm4gram))
df4gram$num <- rowSums(df4gram)
df4gram <- subset(df4gram, num > 1)
df4gram[c('predictor', 'prediction')] <- subset(str_match(row.names(df4gram), "(.*) ([^ ]*)"), select=c(2,3))
df4gram <- subset(df4gram, select=c('predictor', 'prediction', 'num'))
df4gram <- df4gram[order(df4gram$predictor,-df4gram$num),]
row.names(df4gram) <- NULL

predict4hash <- dfToHash(df4gram)

#save(predict2hash, file='predict2hash.RData')
#save(predict3hash, file='predict3hash.RData')
#save(predict4hash, file='predict4hash.RData')
