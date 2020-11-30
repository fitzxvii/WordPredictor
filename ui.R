suppressWarnings(library(shiny))
suppressWarnings(library(shinythemes))
suppressWarnings(library(markdown))

shinyUI( navbarPage("Word Predictor App",
                    theme = shinytheme("slate"),
                    tabPanel("Home",
                             fluidPage(
                                 titlePanel("Home"),
                                 sidebarLayout(
                                     sidebarPanel(

                                        h5("Sentence/Phrase input:"),  
                                        textInput("in_string", "Input words here:",value = ""),
                                        br()
                                        ),
                    mainPanel(
                        h3("Word Prediction"),
                        h4("Prediction:"),
                        h4(textOutput("prediction")),
                        br(),
                        h4("Note:"),
                        h4(textOutput('note'))
                        )
                    )
    
                )
),
tabPanel("About",
         h3("About Next Word Predict"),
         br(),
         div(h5("The Word Predictor App is a Shiny Web application that uses a text
prediction algorithm to predict the next word based on input words entered by the user user."),
             br(),
             h5("The prediction model for next word is based on the Katz Back-off algorithm."),
             br(),
             br(),
             h5("The flow of the algorithm as follows: "),
             br(),
             h6("1. Quadgram is the first assigned N-gram for the prection. The first three words of Quadgram are the last three words of the input sentence/words. "),
             br(),
             h6("2. If there is no Quadgram found, back off to Trigram to predict the next word. The first two words of Trigram are the last two words of the sentence/words."),
             br(),
             h6("3. If there is no Trigram found, back off to Bigram to predict the next word. The first word of Bigram is the last word of the sentence/word)"),
             br(),
             h6("4. If there is no Bigram found, back off to the most common word with highest frequency that I generated for the data ('Just') is returned."),
             br(),
             br(),
             h4("Created By: Fitz Gerald M. Villegas"),
         br()
        )

)
)
)



