#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source("global.R")

header <- dashboardHeaderPlus(
  fixed = TRUE,
  title = tagList(
  span(class = "logo-lg", "Activities"), 
  img(src = "running-solid-white.svg")),
  left_menu = tagList(
    dropdownBlock(
      id = "mydropdown",
      title = "Sliders",
      sliderInput("year", 
                  "Year", 
                  sep = "", 
                  min = min(unique(runkeeper$year)), 
                  max = max(unique(runkeeper$year)),
                  value = max(unique(runkeeper$year)))
    )
  )
)

runkeeper <- read.csv("../data/cardioActivities.csv", stringsAsFactors=FALSE)
steps <- read.csv("../data/StepCount.csv", stringsAsFactors = FALSE)

runkeeper$year <- year(as.Date(runkeeper$Date, origin = '1900-01-01')) 
steps$year <- year(as.Date(steps$endDate, origin = '1900-01-01')) 

runkeeper$Duration <- ifelse(nchar(runkeeper$Duration) < 6, 
                             paste0("0:", runkeeper$Duration), runkeeper$Duration)
runkeeper$lub <- hms(runkeeper$Duration, roll = TRUE)
runkeeper$time_minutes <- hour(runkeeper$lub)*60 + 
  minute(runkeeper$lub) + 
  second(runkeeper$lub)/60

grouped_runkeeper_year <- runkeeper %>%
  group_by(year) %>%
  summarise(cnt = n(), 
            km = sum(Distance..km.),
            climb = sum(Climb..m.),
            calories = sum(Calories.Burned),
            duration = sum(time_minutes, na.rm = TRUE))

grouped_runkeeper <- runkeeper %>% 
  group_by(year,Type) %>% 
  summarise(cnt = n())

grouped_steps_year <- steps %>%
  group_by(year) %>%
  summarise(cnt = sum(value))

calendar_heatmap <- runkeeper %>% 
  select(Date,time_minutes,year) %>% 
  filter(year >= year(now()) - 3) %>%
  mutate(
    week = week(as.Date(Date)),
    wday = wday(as.Date(Date), week_start = 1),
    month = month(as.Date(Date), label = TRUE, abbr = TRUE),
    day = weekdays(as.Date(Date))
  )

# Sidebar content of the dashboard
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboards", icon = icon("dashboard"), startExpanded = FALSE,
             menuSubItem("Overall", tabName = "overall", icon = icon("circle-o")),
             menuSubItem("Detail", tabName = "detail", icon = icon("circle-o"))
    )
  )
)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "theme.css"),
    tags$link(rel = "stylesheet", 
              type = "text/css", 
              href="https://use.fontawesome.com/releases/v5.6.3/css/all.css", 
              integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/", 
              crossorigin="anonymous")
    ),
  
  tabItems(
    overall_tab,
    detail_tab
  )
)

ui <- dashboardPagePlus(title = 'Activities Data', 
                        header, 
                        sidebar, 
                        body, 
                        skin='yellow')

# Define server logic required to draw a histogram
server <- function(input, output, session) {

   output$activities <- renderPlot({
     grouped_runkeeper_year %>%
       ggplot(aes(x=year, y=cnt )) + 
       geom_bar(stat = "identity", col="white", fill="#ee8300") +
       geom_text(aes(label=cnt), hjust=1.2, color="white", size=3.5) +
       labs(x="", y="") + # title="Number activities by Year") +
       scale_x_continuous(breaks=seq(min(grouped_runkeeper$year), max(grouped_runkeeper$year),1)) + 
       coord_flip() +
       theme_bw()
     })
   output$km <- renderPlot({
     grouped_runkeeper_year %>%
       ggplot(aes(x=year, y=km )) + 
       geom_bar(stat = "identity", col="white", fill="#ee8300") +
       geom_text(aes(label=km), hjust=1.2, color="white", size=3.5) +
       labs(x="", y="") + #, title="Number kilometer by Year") +
       scale_x_continuous(breaks=seq(min(grouped_runkeeper$year), max(grouped_runkeeper$year),1)) + 
       coord_flip() +
       theme_bw()
   })
   output$calories <- renderPlot({
     grouped_runkeeper_year %>%
       ggplot(aes(x=year, y=calories)) + 
       geom_bar(stat = "identity", col="white", fill="#ee8300") +
       geom_text(aes(label=round(calories, digits = 1)), hjust=1.2, color="white", size=3.5) +
       labs(x="", y="") + #, title="Number kilometer by Year") +
       scale_x_continuous(breaks=seq(min(grouped_runkeeper$year), max(grouped_runkeeper$year),1)) + 
       coord_flip() +
       theme_bw()
   })
   output$type <- renderPlot({
     grouped_runkeeper %>%
       filter(year == input$year) %>% 
       ggplot(aes(x=reorder(Type, cnt), y=cnt )) + 
       geom_bar(stat = "identity", col="white", fill="#ee8300") + 
       geom_text(aes(label=cnt), hjust=1.2, color="white", size=3.5) +
       coord_flip() +
       theme_bw()
   })
   output$n_activities <- renderValueBox({
     n <- grouped_runkeeper_year %>% filter(year == input$year) %>% pull(cnt)
     
     valueBox(color = "orange",
       value = formatC(n, digits = 0, format = "f"),
       subtitle = "Activities",
       icon = icon("running")
       #color = if (downloadRate >= input$rateThreshold) "yellow" else "aqua"
     )
   })
   output$n_km <- renderValueBox({
     n <- grouped_runkeeper_year %>% filter(year == input$year) %>% pull(km)
     
     valueBox(color = "orange",
       value = formatC(n, digits = 0, format = "f"),
       subtitle = "Distance (km)",
       icon = icon("road")
     )
   })
   output$n_calories <- renderValueBox({
     n <- grouped_runkeeper_year %>% filter(year == input$year) %>% pull(calories)
     
     valueBox(color = "orange",
       value = formatC(n, digits = 0, format = "f"),
       subtitle = "Calories Burned",
       icon = icon("fire")
     )
   })
   output$n_time <- renderValueBox({
     n <- grouped_runkeeper_year %>% filter(year == input$year) %>% pull(duration)
     
     valueBox(color = "orange",
              value = hms::as.hms(n * 60),
              subtitle = "Time spent",
              icon = icon("far fa-clock")
     )
   })
   output$n_steps <- renderValueBox({
     n <- grouped_steps_year %>% filter(year == input$year) %>% pull(cnt)
     
     valueBox(color = "orange",
              value = formatC(n, digits = 0, format = "f"),
              subtitle = "Steps",
              icon = icon("fas fa-shoe-prints")
     )
   })
   output$n_climb <- renderValueBox({
     n <- grouped_runkeeper_year %>% filter(year == input$year) %>% pull(climb)
     
     valueBox(color = "orange",
              value = formatC(n, digits = 0, format = "f"),
              subtitle = "Elevation Climb (m)",
              icon = icon("fas fa-mountain")
     )
   })
   output$heatmap <- renderPlot({
     cols <- rev(rev(brewer.pal(7,"Oranges"))[1:5])
     
     ggplot(calendar_heatmap, aes(month, reorder(day, -wday), fill = time_minutes)) +
       geom_tile(colour = "white") +
       scale_fill_gradientn('Activity \nMinutes',
                            colours = cols) +
       facet_wrap(~ year, ncol = 1) +
       theme_classic() +
       theme(strip.text.x = element_text(size = 16, face = "bold", colour = "orange")) +
       ylab("") + 
       xlab("")
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

