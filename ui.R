library(shiny)
library(plotly)
library(shinythemes)
library(reticulate)
library(shinyjs)
library(gapminder)
library(leaflet)
library(profvis)
library(shinyjs)
source_python('python_modules/data_handler.py')
source_python('python_modules/csv_work/table_comper_places.py')
ui <- fluidPage(
  useShinyjs(),
  theme='theme.css',
  includeCSS('www/styles.css'),
  h1('Visual Crowds',style='margin-left:45%',class="text-success"),
  tabsetPanel(id='tabs',
              tabPanel(id='strt',title=h4('Street View'),
                       actionButton('OverAll',h3('OverAll'),class="btn btn-primary"),
                       actionButton('Makka',h3('Makka'),class="btn btn-primary"),
                       actionButton('Arafa',h3('Arafa'),class="btn btn-primary"),
                       actionButton('Mena',h3('Mena'),class="btn btn-primary"),
                       leafletOutput('street')
              ),
              tabPanel(id='srching',h4('Search For Pilgrim'),
                       fixedRow(
                         column(2,radioButtons('search_choice',h4("Search by : "),choices = c("ID","Name"))),
                         column(4,textInput('input-srch',h4('Enter Value :')))),
                       leafletOutput('piligrim')
              ),
              tabPanel(id='fac',h4("Facilities"),
                       leafletOutput('faclt')
                       )
  ),
  div( id='anal',class='jumbotron',style="margin-top:5%;",
       fixedRow(
         column(4,
                p('Warnings',class='text-danger'),
                uiOutput('warn')         
                ),
         column(6,
                p('Insights',class='text-success'),
                uiOutput('insights')
                )
       )
       

  )
  
  
)

# div(class="card text-white bg-danger mb-3",
#     style="max-width: 20rem; border-radius:10px;",
#     div(class="card-body",
#         h4(class="card-title",icon('exclamation-triangle',lib = "font-awesome",class="fa-2x"),"Makkah"),
#         p(class="card-text","There is more than 2 milion people in makkah right now")
#     ),
#     actionButton('W1','View',style="margin-left:40%;")
# )