library(shiny)
library(plotly)
library(httr)


TEXT_AREA_START_HEIGHT <- 200
GET_AVAILABLE_TEXTS_URL <- 'http://127.0.0.1:8000/api/get_available_texts/'
GET_TEXT_BY_NAME_URL <- 'http://127.0.0.1:8000/api/get_text/'


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
  json_data = content(response, as='parsed')
  return(json_data$context)
}

get_text_by_name <- function(text_name) {
  url <- paste(GET_TEXT_BY_NAME_URL, text_name, sep='')
  response <- GET(url)
  json_data = content(response, as='parsed')
  return(json_data$context)
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
  
  output$wordsPlot <- renderPlotly({
    encoded_words = data.frame(X=c(1, 2, 3), Y=c(1, 2, 3), W=c('1', '2', '3'))
    plot_ly(encoded_words, x=~X, y=~Y, text=~W, 
            type='scatter', mode='markers', hoverinfo='test')
  })
}

shinyApp(ui, server)