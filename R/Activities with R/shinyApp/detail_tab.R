detail_tab <- tabItem(
  tabName = "detail",
  br(),
  column(
    width = 12,
    align = "center",
    h2("Detail Stats")
  ),
  fluidRow(
    boxPlus(
      title = "Number of Activities",
      width = 4, status = "success", solidHeader = FALSE,
      collapsible = TRUE,
      plotOutput("activities")
    ),
    boxPlus(
      title = "Number of Kilometers",
      width = 4, status = "success", solidHeader = FALSE,
      collapsible = TRUE,
      plotOutput("km")
    ),
    boxPlus(
      title = "Number of Calories",
      width = 4, status = "success", solidHeader = FALSE,
      collapsible = TRUE,
      plotOutput("calories")
    ),
    plotOutput("type")
  )
)