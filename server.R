suppressWarnings(library(tm))
suppressWarnings(library(stringr))
suppressWarnings(library(shiny))

# Set environment
setwd("C:/Users/xdriz/Desktop/Data Science/Capstone/Milestone Report")
# Load data
quadgram <- readRDS("MilestoneApp/fourgram.RData");
trigram <- readRDS("MilestoneApp/trigram.RData");
bigram <- readRDS("MilestoneApp/bigram.RData");
note <<- ""

# Cleaning of user input before predicting the next word

Predict <- function(words) {
    word_clean <- removeNumbers(removePunctuation(tolower(words)))
    splited_words <- strsplit(word_clean, " ")[[1]]
    
    if (length(splited_words)>= 3) {
        splited_words <- tail(splited_words,3)
        if (identical(character(0),head(quadgram[quadgram$unigram == splited_words[1] & quadgram$bigram == splited_words[2] & quadgram$trigram == splited_words[3], 4],1))){
            Predict(paste(splited_words[2],splited_words[3],sep=" "))
        }
        else {note <<- "Next word is predicted using Quadgram."; head(quadgram[quadgram$unigram == splited_words[1] & quadgram$bigram == splited_words[2] & quadgram$trigram == splited_words[3], 4],1)}
    }
    else if (length(splited_words) == 2){
        splited_words <- tail(splited_words,2)
        if (identical(character(0),head(trigram[trigram$unigram == splited_words[1] & trigram$bigram == splited_words[2], 3],1))) {
            Predict(splited_words[2])
        }
        else {note<<- "Next word is predicted using Trigram."; head(trigram[trigram$unigram == splited_words[1] & trigram$bigram == splited_words[2], 3],1)}
    }
    else if (length(splited_words) == 1){
        splited_words <- tail(splited_words,1)
        if (identical(character(0),head(bigram[bigram$unigram == splited_words[1], 2],1))) {note<<-"No match found. Most common word 'Just' is returned."; head("Just",1)}
        else {note <<- "Next word is predicted using Bigram."; head(bigram[bigram$unigram == splited_words[1],2],1)}
    }
}

shinyServer(function(input, output) {
    output$prediction <- renderPrint({
        result <- Predict(input$in_string)
        output$note <- renderText({note})
        result
    });
    
    output$text1 <- renderText({
        input$inputString});
}
)