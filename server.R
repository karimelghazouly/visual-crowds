v<-reactiveValues(l1=39.7,lo1=21.3,l2=39.9,lo2=21.5)
server <- function(input, output,session) {
  observeEvent(input[["Makka"]],{
    v[["l1"]] =39.825000
    v[["lo1"]] =21.421300
    v[["l2"]] =39.827260
    v[["lo2"]] =21.426360
  })
  observeEvent(input[["Arafa"]],{
    #21.3549, 39.9841
    v[["l1"]] =39.9840
    v[["lo1"]] =21.3548
    v[["l2"]] =39.9841
    v[["lo2"]] =21.3549
  })
  #[21.4146,39.8946]]
  observeEvent(input[["Mena"]],{
    v[["l1"]] =39.8880
    v[["lo1"]] =21.4172
    v[["l2"]] =39.8939
    v[["lo2"]] =21.4172
  })
  observeEvent(input[["OverAll"]],{
    v[["l1"]] =39.7
    v[["lo1"]] =21.3
    v[["l2"]] =39.9
    v[["lo2"]] =21.5
  })
    output$visual<-renderPlotly({
      MyData <- read.csv(file="/home/karim/geo_data.csv", header=TRUE, sep=",")
       testing = data.frame( 
         id = c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4),
         lat = c(1, 2, 3, 4, 5, 6, 5, 4, 6, 1 , 4, 3),
         long = c(1, 2, 3, 4, 5, 6, 4, 1, 2, 5, 4, 8),
         city = c('arafa','makka','makka','arafa','arafa','makka','makka','arafa','arafa','makka','arafa','arafa'),
         time = c(1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3),
         pop = c(3, 3, 3, 3, 3, 3,3,3,3,3,3,3)
         )

       #print(MyData)
       p <- ggplot(data = MyData, aes(lat, long ,col='red')) +
         geom_point(data = MyData,aes(size = 3, frame = time , ids = id))+
         scale_x_log10()
       p <- ggplotly(p)
       return(p)
    })
    output$street<-renderLeaflet({
      data <- read.csv(file="/home/karim/geo_data.csv", header=TRUE, sep=",")
      #print(data)
      #print(data[['long']])
      m <- leaflet()
      m <- addTiles(m)
      m <- addMarkers(m, lng=data[['long']], lat=data[['lat']], popup=data[['long']],   clusterOptions = markerClusterOptions())
      #m <- setView(m,21.422487,39.826206,zoom = 10)
      m <-fitBounds(m,v[["l1"]],v[["lo1"]],v[["l2"]],v[["lo2"]])
      return(m)
    })
}