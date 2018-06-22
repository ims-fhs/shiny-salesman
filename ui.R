library(shiny)
if (!exists("all_cities")) all_cities = readRDS("data/cities.rds")
if (!exists("usa_cities")) usa_cities = readRDS("data/usa_cities.rds")

shinyUI(fluidPage(
  tags$head(
    tags$link(rel="stylesheet", type="text/css", href="custom_styles.css")
  ),
  
  title = "Traveling Salesman with Simulated Annealing, Shiny, and R",
  
  tags$h2(tags$a(href="/traveling-salesman", "Traveling Salesman", target="_blank")),
  
  plotOutput("map", height="550px"),
  
  fluidRow(
    column(5,
      tags$ol(
        tags$li("Karte auswählen"),
        tags$li("Anpassen der Simulationsparameter"),
        tags$li("Die 'Lösen'-Schaltfläche clicken!")
      )
    ),
    column(3,
      tags$button("LÖSEN", id="go_button", class="btn btn-info btn-large action-button shiny-bound-input")
    ),
    column(3,
      HTML("<button id='set_random_cities_2' class='btn btn-large action-button shiny-bound-input'>
              <i class='fa fa-refresh'></i>
              Städte zufällig wählen
            </button>")
    ), class="aaa"
  ),
  
  hr(),
  
  fluidRow(
    column(5,
      h4("Karte und Städte der Tour auswählen"),
      selectInput("map_name", NA, c("Welt", "USA", "Schweiz"), "Schweiz", width="120px"),
      p("Wählen Sie Städte durch Tippen in der Liste oder ", actionButton("set_random_cities", " zufällige Auswahl", icon=icon("refresh"))),
      selectizeInput("cities", NA, all_cities$full.name, multiple=TRUE, width="100%",
                     options = list(maxItems=30, maxOptions=100, placeholder="Start typing to select some cities...",
                                    selectOnTab=TRUE, openOnFocus=FALSE, hideSelected=TRUE)),
      checkboxInput("label_cities", "Städte auf der Karte beschriften", TRUE)
    ),
    
    column(2,
      h4("Simulated Annealing Parameter"),
      inputPanel(
        numericInput("s_curve_amplitude", "Amplitude der S-Kurve", 4000, min=0, max=10000000),
        numericInput("s_curve_center", "Zentrum der S-Kurve", 0, min=-1000000, max=1000000),
        numericInput("s_curve_width", "Breite der S-Kurve", 3000, min=1, max=1000000),
        numericInput("total_iterations", "Anzahl Iterationen", 25000, min=0, max=1000000),
        numericInput("plot_every_iterations", "Karte alle N Iterationen zeichnen", 1000, min=1, max=1000000)
      ),
      class="numeric-inputs"
    ),
    
    column(5,
      plotOutput("annealing_schedule", height="260px"),
      plotOutput("distance_results", height="260px")
    )
  )
))
