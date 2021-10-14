library(shiny)
library(shinydashboard)
library(crosstalk)
library(ggiraph)
library(dplyr)
library(rscview)
library(reactable)
library(pins)


# conn <- create_connection()
board <- pins::board_rsconnect()
groups_tbl <- board %>% pin_read("katie/group_members")
group_names <- get_group_names()
group_count <- length(group_names)
groups_data <- get_groups_tbl(conn)
groups_summary <- get_groups_summary(groups_tbl = groups_tbl)

#### UI #####
ui <- dashboardPage(
  dashboardHeader(title = "Groups on RStudio Connect"),
  dashboardSidebar(disable = TRUE ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),

      fluidRow(
      valueBoxOutput("total_groups"),
      box(
        title = "Groups",
        reactableOutput("groups_summary")
      )
    )

    ,

    fluidRow(
    ),

    fluidRow(

      box(width = 12,
          h3(textOutput("group_selection")),
          h2(textOutput("selected")),
          h2(textOutput("selectedgroup")),
          reactableOutput("users_in_group_tbl")
      )

    )

  ) #end dashboardBody
)

##### SERVER ######
server <- function(input, output) {

  output$total_groups <- renderValueBox({
    group_count %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Number of Groups")
  })

  output$groups_summary <- renderReactable({
    reactable(groups_summary, selection = "single", onClick = "select", highlight = TRUE)
  })

  selected <- reactive(getReactableState("groups_summary", "selected"))

  output$selected <- renderPrint({
    print(selected())
  })

  output$selectedgroup <- renderPrint({group_names[selected()]})

  output$users_in_group_tbl <- renderReactable({
    make_group_members_tbl(group_names[selected()])
  })

  # observe({
  #   # Filter data
  #   filtered <- if (length(selected()) > 0) {
  #     groups_data[groups_data$group_name %in% input$filter_type]
  #     data[data$Type %in% input$filter_type, ]
  #   } else {
  #     groups_data
  #   }
  #   updateReactable("table", data = filtered)
  # })


  output$users_in_group_tbl <- renderReactable({
    make_group_members_tbl(output$selected)
  })
}

shinyApp(ui, server)


      # selectInput("group_selection", label = h3("Select group"),
      #             choices = c("All",group_names))

  # output$group_selection <- renderText({
  #   paste("Members of:",input$group_selection)
  #   })
