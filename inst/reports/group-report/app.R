library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(dplyr)
library(rscview)
library(reactable)
library(pins)

board <- board_rsconnect()
group_members_tbl <- board %>% pin_read("katie.masiello/group_members_tbl")
group_names_tbl <- board %>% pin_read("katie.masiello/group_names_tbl") %>% arrange(group_name)
group_count <- group_names_tbl %>% select(group_name) %>% unique() %>% nrow()
groups_summary <- get_groups_summary(group_names_tbl = group_names_tbl, group_members_tbl=group_members_tbl) %>%
  arrange(`Group Name`)

pins_used <- c("katie.masiello/group_members_tbl", "katie.masiello/group_names_tbl")
pin_freshness_tbl <- pin_freshness_tbl(board, pins_used)
pin_freshness_str <- pin_freshness_str(pin_freshness_tbl = pin_freshness_tbl)

#### UI #####
ui <- dashboardPage(
  dashboardHeader(title = "Groups on RStudio Connect",
                  titleWidth = 400),
  dashboardSidebar(disable = TRUE ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    column(4,
           fluidRow(valueBoxOutput("total_groups", width=NULL)),
           fluidRow(
             # h2(textOutput("selectedgroup")),

             box(width = NULL,
               title = "Groups",
               reactableOutput("groups_summary")
             )
           )
           ),
    column(8,
           box(width = 12,
               h3(textOutput("selectedgroup")),
               reactableOutput("users_in_group_tbl")
           ))



  ), #end dashboardBody
  footer = dashboardFooter(
    left = paste("Data sourced from:",pin_freshness_str))
  )

##### SERVER ######
server <- function(input, output) {

  # Reactive elements
  selected <- reactive(getReactableState("groups_summary", "selected"))

  selectedgroup <- reactive({
    group_names_tbl$group_name[selected()]
  })

  nothingselected <- reactive({if(is.null(selected())){TRUE}else{FALSE}})

  # Outputs

  output$selected <- renderText({paste("selected row is:",selected())})

  output$total_groups <- renderValueBox({
    group_count %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Number of Groups")
  })

  output$selectedgroup <- renderText({
    if(length(selectedgroup()>0)){
      paste("Members of:",group_names_tbl$group_name[selected()])
      # paste("Members of:",group_names_tbl$group_name[selected()],"testing - selected row is",selected())
      }else{
        paste("Make a group selection to filter table, or use search to find all groups a user is a member of.")
      }
  })


  output$groups_summary <- renderReactable({
    reactable(groups_summary, selection = "single", onClick = "select", highlight = TRUE,
              showPageSizeOptions = TRUE, defaultPageSize = 15, searchable = TRUE)
  })

  output$users_in_group_tbl <- renderReactable({

    if(nothingselected()==TRUE){
      reactable::reactable(
        group_members_tbl, searchable = TRUE, highlight = TRUE,
        filterable = TRUE, width = "100%"
      )
    }else

      reactable::reactable(
        dplyr::filter(group_members_tbl, group_name == selectedgroup()), searchable = TRUE, highlight = TRUE,
        filterable = TRUE, width = "100%"
      )


  })



}

shinyApp(ui, server)

