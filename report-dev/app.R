library(shiny)
library(gt)
library(tidyverse)

# Define sample data
iris_tibble <-
  iris %>%
  group_by(Species) %>%
  slice(1:3) %>%
  as_tibble() %>%
  ungroup()

ui <-
  fluidPage(
    gt_output("iris_example"),
    verbatimTextOutput("checkbox"),
    verbatimTextOutput("select"),
    verbatimTextOutput("text")
  )

checkbox_gt <- function(value, inputid,...){
  as.character(
    shiny::checkboxInput(
      inputId = paste0(value,inputid),
      ...
    )
  ) %>%
    gt::html()
}

selectinput_gt <- function(value, inputid,...){
  as.character(
    shiny::selectInput(
      paste0(value,inputid),
      ...
    )
  ) %>%
    gt::html()
}

textinput_gt <- function(value, inputid, ...){
  as.character(
    shiny::textInput(
      paste0(value,inputid),
      ...
    )
  ) %>%
    gt::html()
}


server <-
  function(input, output, session){

    output$iris_example <- render_gt(
      iris_tibble %>%
        rownames_to_column() %>%
        rowwise() %>%
        mutate(
          rowname = as.numeric(rowname),
          checkbox_column = map(rowname, .f = ~checkbox_gt(.x, "_checkbox",label = paste("My cb label", .x))),
          selectinput_column = map(rowname,.f = ~selectinput_gt(.x, "_selectinput", label = paste("My select label", .x),choices = c("Yes","No"), selected = "Yes")),
          textinput_column = map(rowname, .f = ~textinput_gt(.x,"_textinput", label = paste("My text label", .x)))
        ) %>%
        group_by(Species) %>%
        gt()
    )

    output$checkbox <- renderText({
      map_chr(
        .x = 1:nrow(iris_tibble),
        .f = ~input[[paste0(.x,"_checkbox")]]
      )
    })

    output$select <- renderText({
      map_chr(
        .x = 1:nrow(iris_tibble),
        .f = ~input[[paste0(.x,"_selectinput")]]
      )
    })

    output$text <- renderText({
      map_chr(
        .x = 1:nrow(iris_tibble),
        .f = ~input[[paste0(.x,"_textinput")]]
      )
    })

  }


shinyApp(ui,server)
