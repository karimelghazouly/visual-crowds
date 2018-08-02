v<-reactiveValues(l1=39.7,lo1=21.3,l2=39.9,lo2=21.5)
source_python('python_modules/data_handler.py')
MyData <- read.csv(file="/home/karim/WorkSpace/R/Visual Crowds/Hajj Hackathon/python_modules/csv_work/Info.csv", header=TRUE, sep=",")
leng = nrow(MyData)

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
      data <- read.csv(file="python_modules/csv_work/geo_data.csv", header=TRUE, sep=",")
      print(data)
      m <- leaflet()
      m <- addTiles(m)
      m <- addMarkers(m, lng=data[['lng']], lat=data[['lat']], popup=data[['long']],   clusterOptions = markerClusterOptions())
      m <-fitBounds(m,v[["l1"]],v[["lo1"]],v[["l2"]],v[["lo2"]])
      return(m)
    })
    output$piligrim<-renderLeaflet({
      if(input[["search_choice"]]=="ID")
      {
        id=as.numeric(input[["input-srch"]])
        if(!is.na(id)&&!is.null(id)&&id<=leng)
        {
          loc=get_location_by_id(id)
          loc=unlist(loc)
          m <- leaflet()
          m <- addTiles(m)
          m <- addMarkers(m, lng=loc[2], lat=loc[1], popup=id)
        }
      }
      else
      {
        name=input[["input-srch"]]
        if(!is.na(name)&&!is.null(name)&&name!=''&&is.na(as.numeric(name)))
        {
          loc=get_location_by_name(name)
          loc=unlist(loc)
          m <- leaflet()
          m <- addTiles(m)
          m <- addMarkers(m, lng=loc[2], lat=loc[1], popup=name)
        }
      }
    })
}