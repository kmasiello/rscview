
library(shiny)
# library(htmltools)
#
# csvDownloadButton <- function(tableId, label = "Download as CSV", filename = "data.csv") {
#   htmltools::tags$button(
#     label,
#     onclick = sprintf("Reactable.downloadDataCSV('%s', '%s')", tableId, filename)
#   )
# }
#
# ui <- fluidPage(
#   reactableOutput("cars_table")
# )
#
# server <- function(input, output) {
#   output$cars_table <- renderReactable({
#     reactable(MASS::Cars93, onClick = "Reactable.downloadDataCSV('cars-table')")
#   })
# }
#
# shinyApp(ui = ui, server = server)
ui <- fluidPage(
  downloadButton("downloadData", "Download")
)

server <- function(input, output) {
  # Our dataset
  data <- mtcars

  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(data, file)
    }
  )
}

shinyApp(ui, server)
