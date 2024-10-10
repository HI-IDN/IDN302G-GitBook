# Hlaða inn nauðsynlegum pökkum
library(shiny)
library(DBI)
library(RSQLite)
library(DT)

# Búa til tengingu við SQLite gagnagrunn
con <- dbConnect(RSQLite::SQLite(), "../data/isfolkid.db")

# Sækja nöfn töflna úr gagnagrunninum
tables <- dbListTables(con)

# Shiny UI (notendaviðmót)
ui <- fluidPage(
  titlePanel("Shiny App tengt við gagnagrunn - Velja töflu og skoða gögn"),

  # Dropdown til að velja töflu
  selectInput("table_choice", "Veldu töflu:", choices = tables),

  # Searchable table output með DT
  DTOutput("table")
)

# Shiny Server (bakviðmót)
server <- function(input, output, session) {

  # Útdráttur gagna úr valinni töflu
  data_selected <- reactive({
    req(input$table_choice) # Gakktu úr skugga um að tafla hafi verið valin
    dbGetQuery(con, paste("SELECT * FROM", input$table_choice))
  })

  # Birta gagnatöflu sem er searchable og sortable
  output$table <- renderDT({
    datatable(data_selected(), options = list(pageLength = 10, searchHighlight = TRUE))
  })
}

# Keyra appið
shinyApp(ui = ui, server = server)
