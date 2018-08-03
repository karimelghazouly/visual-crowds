v<-reactiveValues(l1=39.7,lo1=21.3,l2=39.9,lo2=21.5)
source_python('python_modules/data_handler.py')
source_python('python_modules/csv_work/table_comper_places.py')
MyData <- read.csv(file="/home/karim/WorkSpace/R/Visual Crowds/Hajj Hackathon/python_modules/csv_work/Info.csv", header=TRUE, sep=",")
leng = nrow(MyData)
idx=1
useShinyjs()
personIcon=makeIcon(
  iconUrl = 'www/icons/circle1.png',
  iconWidth = 10, iconHeight = 10
)

find_warning = function()
{
  prob=compare_place_to_people_in()
  for(i in prob)
  {
    add_warning(i[[1]],i[[2]],i[[3]])
  }
}

remove_old_warn = function()
{
  for(i in 1:(idx-1))
  {
    sel=paste("#warn",i,sep='')
    removeUI(
      selector = sel
    )    
  }
  idx<<-1
}

add_warning=function(place,max,cur)
{
  insertUI(
    selector = "#warn",
    where = "afterEnd",
    ui=div(class="card text-white bg-danger mb-3",
           style="max-width: 20rem; border-radius:10px; margin-left:25px;",
           div(class="card-body",
               h4(class="card-title",icon('exclamation-triangle',lib = "font-awesome",class="fa-2x"),place),
               p(class="card-text",paste(place,' can only handle',max,'and now it has',cur,'pilgrim please consider taking an action as soon as possible to avoid over crowding'))
           ),
           actionButton('W1','View',style="margin-left:40%;"),
    id=paste('warn',idx,sep='')
    )
  )
  idx<<-idx+1
}
server <- function(input, output,session) {
  observe({
    if(input[["tabs"]]=="<h4>Facilities</h4>")hide('anal')
    else show('anal')
  })
  autoInvalidate <- reactiveTimer(5000)
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
  observeEvent(input[["insert"]],{
  })
  output$faclt<-renderLeaflet({
    data=add_places_capacity('hospital','21.42287','39.826206')
    #print(data)
    m <- leaflet()
    m <- addTiles(m)
    le=length(data)
    x=(data)
    print(x)
    
    #barplot(c(1,2,3))
  })
  output$street<-renderLeaflet({
      remove_old_warn()
      find_warning()
      autoInvalidate()
      manipulate_geo_data()
      data <- read.csv(file="python_modules/csv_work/geo_data.csv", header=TRUE, sep=",")
      #print(data)
      m <- leaflet()
      m <- addTiles(m)
    # m <- addMarkers(m,lng = data[['lng']],lat=data[['lat']],popup = data[['lng']],icon = personIcon)
      m <- addMarkers(m, lng=data[['lng']], lat=data[['lat']], popup=data[['lng']],   clusterOptions = markerClusterOptions(zoomToBoundsOnClick = T,spiderfyOnMaxZoom = F),icon = personIcon )
      m <- addCircles(m,lng=data[['lng']], lat=data[['lat']])
      m <- fitBounds(m,v[["l1"]],v[["lo1"]],v[["l2"]],v[["lo2"]])
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