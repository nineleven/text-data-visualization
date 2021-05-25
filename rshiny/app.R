library(shiny)
library(plotly)
library(httr)


TEXT_AREA_START_HEIGHT <- 200

GET_AVAILABLE_TEXTS_URL <- 'http://127.0.0.1:8000/api/get_available_texts/'
GET_TEXT_BY_NAME_URL <- 'http://127.0.0.1:8000/api/get_text/'
ENCODE_TEXT_URL <- 'http://127.0.0.1:8000/api/encode_text/'


ui <- pageWithSidebar(
  
  headerPanel('TextViz'),
  
  sidebarPanel(
    uiOutput('sample_text'),
    
    actionButton('load_sample_text', 'load sample'),
    
    textAreaInput('input_text', 'Your text:', height=TEXT_AREA_START_HEIGHT),
    
    actionButton('submit', 'Vizualize text')
  ),
  
  mainPanel(
    plotlyOutput('wordsPlot')
  )
)

get_available_texts <- function() {
  response <- GET(GET_AVAILABLE_TEXTS_URL)
  json_data <- content(response, as='parsed')
  return(json_data$context)
}

get_text_by_name <- function(text_name) {
  url <- paste(GET_TEXT_BY_NAME_URL, text_name, sep='')
  response <- GET(url)
  json_data <- content(response, as='parsed')
  return(json_data$context)
}

encode_text <- function(text) {
  response <- POST(ENCODE_TEXT_URL,
                   body = text)
  json_data <- content(response, as='parsed')
  return(json_data)
}

server <- function(input, output) {
  available_texts <- reactive({
    get_available_texts()
  })
  
  output$sample_text <- renderUI({
    selectInput('sample_text', 'Sample texts:', available_texts())
  })
  
  observeEvent(input$load_sample_text, {
    updateTextAreaInput(inputId='input_text', 
                        value=get_text_by_name(input$sample_text))
  })
  
  observeEvent(input$submit, {
    wordscodes <- encode_text(input$input_text)
    
    num_codes = length(wordscodes$codes)
    codes_matrix = matrix(unlist(wordscodes$codes), num_codes)
    
    pca_res = prcomp(x=codes_matrix, rank=2)
    
    reduced_codes = pca_res$x
    
    colnames(reduced_codes) <- c('X', 'Y')
    
    encoded_words = data.frame(reduced_codes)
    encoded_words$W = wordscodes$words
    
    output$wordsPlot <- renderPlotly({
      
      plot_ly(encoded_words, x=~X, y=~Y, text=~W, 
              type='scatter', mode='markers', hoverinfo='test')
    })
  })
  
}

shinyApp(ui, server)