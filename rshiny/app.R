library(shiny)
library(plotly)
library(httr)


source('config.R')
TEXT_AREA_START_HEIGHT <- 200


ui <- pageWithSidebar(
  
  headerPanel('TextViz'),
  
  sidebarPanel(
    uiOutput('sample_text'),
    
    uiOutput('load_sample_text'),
    
    textAreaInput('input_text', 'Your text:', 
                  height = TEXT_AREA_START_HEIGHT),
    
    actionButton('submit', 'Vizualize text')
  ),
  
  mainPanel(
    plotlyOutput('wordsPlot')
  )
)


get_available_texts <- function() {
  "Requests a list of available sample texts"
  response <- GET(GET_AVAILABLE_TEXTS_URL)
  json_data <- content(response, as='parsed')
  names <- sapply(json_data, function(elem){return(elem$name)})
  return(names)
}

get_text_by_name <- function(text_name) {
  "Requests a sample text by it\'s name"
  no_spaces_name = gsub(' ', '+', text_name)
  url <- GET_TEXT_BY_NAME_URL
  response <- GET(url, query=list(name=no_spaces_name))
  json_data <- content(response, as='parsed')
  return(json_data$text)
}

encode_text <- function(text) {
  "Accesses API that encodes the text"
  response <- POST(ENCODE_TEXT_URL,
                   body = text)
  json_data <- content(response, as = 'parsed')
  return(json_data)
}


server <- function(input, output) {
  available_texts <- reactive({
    texts <- get_available_texts()
    
    output$load_sample_text <- renderUI({
      actionButton('load_sample_text', 'load sample')
    })
  
    return(texts)
  })
  
  output$sample_text <- renderUI({
    selectInput('sample_text', 'Sample texts:', available_texts())
  })
  
  observeEvent(input$load_sample_text, {
    text <- tryCatch({
      get_text_by_name(input$sample_text)
    }, error= function(e){
      showModal(modalDialog(
        title = "Error",
        paste('Connection error:', e),
        easyClose = TRUE,
        footer = NULL
      ))
    })
    if (is.null(text)) {
      return()
    }

    updateTextAreaInput(inputId = 'input_text', 
                        value = text)
  })
  
  observeEvent(input$submit, {
    wordscodes <- tryCatch({
      encode_text(input$input_text)
    }, error = function(e){
      showModal(modalDialog(
        title = "Error",
        paste('Connection error:', e),
        easyClose = TRUE,
        footer = NULL
      ))
    })
    if (is.null(wordscodes)) {
      return()
    }
    
    num_codes <- length(wordscodes$codes)
    
    if (num_codes < 2) {
      showModal(modalDialog(
        title = "Error",
        paste('Please, enter at leat two words'),
        easyClose = TRUE,
        footer = NULL
      ))
      return()
    }
    
    codes_matrix <- matrix(data = unlist(wordscodes$codes), 
                           nrow = num_codes, byrow = TRUE)
    
    res.pca <- prcomp(x = codes_matrix, rank = 2)
    
    reduced_codes = res.pca$x
    colnames(reduced_codes) <- c('X', 'Y')
    
    encoded_words <- data.frame(reduced_codes)
    encoded_words$W <- wordscodes$words
    
    output$wordsPlot <- renderPlotly({
      
      plot_ly(encoded_words, x = ~X, y = ~Y, text = ~W, 
              type = 'scatter', mode = 'markers')
    })
  })
  
}

shinyApp(ui, server)