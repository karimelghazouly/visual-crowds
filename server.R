v<-reactiveValues(l1=39.7,lo1=21.3,l2=39.9,lo2=21.5,z=2,vl=0,vlo=1,change=1)
source_python('python_modules/data_handler.py')
source_python('python_modules/csv_work/table_comper_places.py')
MyData <- read.csv(file="python_modules/csv_work/Info.csv", header=TRUE, sep=",")
leng = nrow(MyData)
idx=1
idx2=1
ss=1
l1=39.7
lo1=21.3
l2=39.9
lo2=21.5
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
remove_old_insi = function()
{
  for(i in 1:(idx2-1))
  {
    sel=paste("#insights",i,sep='')
    removeUI(
      selector = sel
    )    
  }
  idx2<<- 1
}

find_insi=function(){
  names=c('makka','mena','muzdalifah','arafa')
  for( i in names){
    ret=find_number_in_city(i)
    if(!is.null(ret))
    {
      add_insi(i,ret[2],ret[1])

    }
    
  }
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
add_insi=function(place,max,cur)
{
  
  insertUI(
    selector = "#insights",
    where = "afterEnd",
    ui=div(class="card text-white bg-success mb-3",
           style="max-width: 20rem; border-radius:10px; margin-left:25px;",
           div(class="card-body",
               h4(class="card-title",icon('check-circle',lib = "font-awesome",class="fa-2x"),place),
               p(class="card-text",paste('Every thing is good at ',place,' it can 
handle',max,'and now it has',cur,'pilgrims'))
           ),
           actionButton('W1','View',style="margin-left:40%;"),
           id=paste('insights',idx2,sep='')
    )
  )
  idx2<<- idx2+1
}
server <- function(input, output,session) {
  autoInvalidate <- reactiveTimer(30000)
  observe({
    bounds=input$street_bounds
    if(!is.null(bounds)&&bounds$west!=isolate(v[["l1"]])&&bounds$east!=isolate(v[["l2"]])&&bounds$south!=isolate(v[["lo1"]])&&bounds$north!=isolate(v[["lo2"]]))
    {
      l1<<- bounds$west
      l2<<- bounds$east
      lo1<<- bounds$south
      lo2<<- bounds$north
    }
    if(input[["tabs"]]=="<h4>Facilities</h4>")hide('anal')
    else show('anal')
  })
  observeEvent(input[["Makka"]],{
    l1 <<- 39.825000
    lo1 <<-21.421300
    l2 <<- 39.827260
    lo2 <<- 21.426360
    v[["change"]]=ss+1
    ss<<- ss+1
  })
  observeEvent(input[["Arafa"]],{
    #21.3549, 39.9841
    l1<<-39.9840
    lo1<<- 21.3548
    l2 <<- 39.9841
    lo2<<- 21.3549
    v[["change"]]=ss+1
    ss<<- ss+1
  })
  observeEvent(input[["Mena"]],{
    l1<<-39.8880
    lo1<<- 21.4172
    l2<<-39.8939
    lo2<<- 21.4172
    v[["change"]]=ss+1
    ss<<- ss+1
  })
  observeEvent(input[["OverAll"]],{
    l1 <<-39.7
    lo1 <<- 21.3
    l2 <<- 39.9
    lo2 <<- 21.5
    v[["change"]]=ss+1
    ss<<- ss+1
  })
  observeEvent(input[["insert"]],{
  })
  observeEvent(input[["refresh"]],{
    autoInvalidate()
    remove_old_warn()
    remove_old_insi()
    find_warning()
    find_insi()
    manipulate_geo_data()
  })
  output$faclt<-renderPlot({
    par(bg='#222222')
    data=add_places_capacity('hospital','21.42287','39.826206')
    le=length(data)
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
    remove_old_warn()
    remove_old_insi()
    find_warning()
    find_insi()
    manipulate_geo_data()
    if(v[["change"]])
    {
      data <- read.csv(file="python_modules/csv_work/geo_data.csv", header=TRUE, sep=",")
      m <- leaflet()
      m <- addTiles(m)
      m <- addMarkers(m, lng=data[['lng']], lat=data[['lat']], popup=data[['lng']],   clusterOptions = markerClusterOptions(zoomToBoundsOnClick = T,spiderfyOnMaxZoom = F),icon = personIcon )
      m <- addCircles(m,lng=data[['lng']], lat=data[['lat']])
      m <- fitBounds(m,l1,lo1,l2,lo2)
      return(m)  
    }
    
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