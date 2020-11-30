#Set environment
setwd("C:/Users/xdriz/Desktop/Data Science/Capstone/Milestone Report")

#Initialize libraries
library(data.table)
library(stringi) 
library(magrittr) 
library(ngram) 
library(stringr)

#Load data and save as .RDS
con <- file("dataset/final/en_US/en_US.blogs.txt", "r")
blogs <- readLines(con); close(con)
con <- file("dataset/final/en_US/en_US.news.txt", "r")
news <- readLines(con); close(con)
con <- file("dataset/final/en_US/en_US.twitter.txt", "r")
twitter <- readLines(con); close(con)

saveRDS(blogs,file="dataset/final/en_US/blogs_data.RDS")
saveRDS(news,file="dataset/final/en_US/news_data.RDS")
saveRDS(twitter,file="dataset/final/en_US/twitter_data.RDS")

#Data Sampling
#Load data
blog <- readRDS("dataset/final/en_US/blogs_data.RDS")
news <- readRDS("dataset/final/en_US/news_data.RDS")
twitter <- readRDS("dataset/final/en_US/twitter_data.RDS")
corpus <- c(blog,news,twitter)
rm(list=c('blog','news','twitter'))

#Get sample corpus
set.seed(123)
n <- length(corpus)
sample_size <- 0.001 # 1% sample
corpus <- sample(corpus, n*sample_size, replace = FALSE, prob = NULL)

#Data Cleaning and parsing
source('MilestoneApp/parse.R') #The parsing function source
word_count <- function(string) length(strsplit(unlist(string),' ')[[1]])
corpus <- parse(corpus)
corpus <- corpus[unlist(lapply(corpus, function(x) word_count(x)>=5))]

#Convert corpus to N-gram
unigram <- ngram(corpus, 1)
bigram <- ngram(corpus, 2)
trigram <- ngram(corpus, 3)
fourgram <- ngram(corpus, 4)

#Convert N-gram to data table
unigram <- data.table(get.phrasetable(unigram))
bigram <- data.table(get.phrasetable(bigram))
trigram <- data.table(get.phrasetable(trigram))
fourgram <- data.table(get.phrasetable(fourgram))

setDT(unigram)[,prop:=NULL]
setDT(bigram)[,prop:=NULL]
setDT(trigram)[,prop:=NULL]
setDT(fourgram)[,prop:=NULL]

#For Unigram 
setDT(unigram)[,`:=`(ngrams = stri_replace_all(ngrams, regex = "^ +|(?<= ) +| +$", replacement = ""))]
setnames(unigram, c("uni","n1"))

#For Bigram
setDT(bigram)[,`:=`(ngrams = stri_replace_all(ngrams, regex = "^ +|(?<= ) +| +$", replacement = ""),
                    uni = word(ngrams, 1,1),
                    word =  word(ngrams, 2,2))]
setDT(bigram)[,`:=`(ngrams = NULL)]
setcolorder(bigram, c("uni","word","freq"))
setnames(bigram, c("unigram","bigram","freq"))

#For Trigrams
setDT(trigram)[,`:=`(ngrams = stri_replace_all(ngrams, regex = "^ +|(?<= ) +| +$", replacement = ""),
                     uni = word(ngrams, 1,1),
                     bi = word(ngrams, 2,2),
                     word =  word(ngrams, 3,3))]
setDT(trigram)[,`:=`(ngrams = NULL)]
setcolorder(trigram, c("uni","bi", "word", "freq"))
setnames(trigram, c("unigram","bigram", "trigram", "freq"))

#For Quadgrams
setDT(fourgram)[,`:=`(ngrams = stri_replace_all(ngrams, regex = "^ +|(?<= ) +| +$", replacement = ""),
                      uni = word(ngrams, 1,1),
                      bi = word(ngrams, 2,2),
                      tri = word(ngrams, 3,3),
                      word =  word(ngrams, 4,4))]
setDT(fourgram)[,`:=`(ngrams = NULL)]
setcolorder(fourgram, c("uni","bi","tri","word","freq"))
setnames(fourgram, c("unigram","bigram", "trigram","quadgram","freq"))

#Save as .Rdata for ShinyApp
saveRDS(unigram,file = "MilestoneApp/unigram.RData",compress=TRUE)
saveRDS(bigram,file = "MilestoneApp/bigram.RData",compress=TRUE)
saveRDS(trigram,file = "MilestoneApp/trigram.RData",compress=TRUE)
saveRDS(fourgram,file = "MilestoneApp/fourgram.RData",compress=TRUE)
