v<-reactiveValues(l1=39.7,lo1=21.3,l2=39.9,lo2=21.5,z=2,vl=0,vlo=1)
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
lst_clck_lat=0
lst_clck_lng=1
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
  autoInvalidate <- reactiveTimer(10000)
  observe({
    
    if(input[["tabs"]]=="<h4>Facilities</h4>")hide('anal')
    else show('anal')
    #print("observing")
  })
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
  output$faclt<-renderPlot({
    par(bg='#222222')
    data=add_places_capacity('hospital','21.42287','39.826206')
    le=length(data)
    print(le)
    names=c()
    heig=c()
    for(i in 1:(le-1))
    {
      names=c(names,data[[i]][1])
      heig=c(heig,data[[i]][[4]])
    }
    barplot(heig,names.arg = names,ylab="Persons",xlab = "Hospital Name",col = '#226F57',col.lab='white',col.axis='white')
  })
  output$street<-renderLeaflet({
     autoInvalidate() 
    bounds=input$street_bounds  
    lo1=0
    lo2=0
    l1=0
    l2=0
    if(!is.null(bounds)) 
    {
      lo1=bounds$north
      lo2=bounds$south
      l1=bounds$west
      l2=bounds$east
    }
    remove_old_warn()
    find_warning()
    #manipulate_geo_data()
    data <- read.csv(file="python_modules/csv_work/geo_data.csv", header=TRUE, sep=",")
    m <- leaflet()
    m <- addTiles(m)
    m <- addMarkers(m, lng=data[['lng']], lat=data[['lat']], popup=data[['lng']],   clusterOptions = markerClusterOptions(zoomToBoundsOnClick = T,spiderfyOnMaxZoom = F),icon = personIcon )
    m <- addCircles(m,lng=data[['lng']], lat=data[['lat']])
    #print(v[['l1']])
    #print(v[['`']])
    #print(v[['l2']])
    #print(v[['lo2']])
    #if(l1!=0)m <- fitBounds(m,l1,lo1,l2,lo2)
    #m <- setView(m,v[['vlo']],v[['vl']],zoom=v[['z']])
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