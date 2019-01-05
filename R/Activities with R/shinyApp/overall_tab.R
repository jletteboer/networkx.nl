overall_tab <- tabItem(
  tabName = "overall",
  br(),
  column(
    width = 12,
    h2("Overall Stats")
  ),
  fluidRow(
    valueBoxOutput(width = 4, "n_activities"),
    valueBoxOutput(width = 4, "n_km"),
    valueBoxOutput(width = 4, "n_calories")
  ),
  fluidRow(
    valueBoxOutput(width = 4, "n_time"),
    valueBoxOutput(width = 4, "n_steps"),
    valueBoxOutput(width = 4, "n_climb")
  ),
  fluidRow(
    boxPlus(
      width = 12, status = "success", solidHeader = FALSE,
      plotOutput("heatmap")
    )
  )
)
