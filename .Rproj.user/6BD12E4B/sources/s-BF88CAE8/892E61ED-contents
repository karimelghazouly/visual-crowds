library(shiny)
library(plotly)

ui <- fluidPage(
   titlePanel("Old Faithful Geyser Data"),
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30)
      ),
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      
   })
}
shinyApp(ui = ui, server = server)

