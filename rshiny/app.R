library(shiny)
library(plotly)

ui <- pageWithSidebar(
  
  headerPanel('TextViz'),
  
  sidebarPanel(
    selectInput('sample_texts', 'Sample texts:',
                c('Text1'='text one', 
                  'Text2'='text two')
                ),
    
    actionButton('load_sample_text', 'load sample'),
    
    textAreaInput('input_text', 'Your text:', height=200),
    
    actionButton('submit', 'Vizualize text'),
  ),
  
  mainPanel(
    plotlyOutput('wordsPlot')
  )
)

xs <- c(1, 2, 3, 4)
ys <- c(2, 3, 2, 5)
words <- c('w1', 'w2', 'w3', 'w4')
encoded_words <- data.frame(X=xs, Y=ys, W=words)

server <- function(input, output) {
  output$wordsPlot <- renderPlotly({
    req(encoded_words)
    plot_ly(encoded_words, x=~X, y=~Y, text=~W, type='scatter', mode='markers', hoverinfo='test')
  })
}

shinyApp(ui, server)