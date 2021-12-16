library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(tidyverse)
library(rscview)
library(reactable)
library(pins)
library(lubridate)
library(ggplot2)
library(ggiraph)



board <- pins::board_rsconnect()

pins_used <- c("katie/logs", "katie/user-info")
pin_freshness_tbl <- pin_freshness_tbl(board, pins_used)
pin_freshness_str <- pin_freshness_str(pin_freshness_tbl = pin_freshness_tbl)


logs <- board %>% pin_read("katie/logs")
users_tbl <- board %>% pin_read("katie/user-info")

historical_users <- get_user_historical_tbl(users_tbl = users_tbl)
current_users <- get_user_current_tbl(user_historical_tbl = historical_users)
users_licensed <- current_users %>%
  count() %>%
  pull()

#users by roles
users_admins <- current_users %>%
  get_users_role("administrator")

users_pubs <- current_users %>%
  get_users_role("publisher")

users_viewers <- current_users %>%
  get_users_role("viewer")



lock_history <- logs %>% get_lock_history_tbl()

# user creation history -- I'm doing this from the get_user dataframe and not from the audit logs because the audit logs can show user creation under the events of "add_user" or "add_group_member" depending on the auth mechanism. Colorado has this split in the data in how users are added.
creation_history <- historical_users %>%
  select(username, created_time) %>%
  mutate(event = "created") %>%
  dplyr::rename("event_time" = created_time) %>%
  arrange(event_time)


#when do users drop off the NU count? Identify date they no longer counted.
drop_off_history <- historical_users %>%
  select(username, days_since_active, active_time) %>%
  filter(as_date(active_time) < (today() - dyears(1))) %>%
  mutate(event_time = as_date(active_time) + dyears(1)) %>%
  select(-days_since_active, -active_time) %>%
  mutate(event = "dropped")

event_history <- bind_rows(creation_history, lock_history, drop_off_history) %>%
  left_join(select(historical_users, username, active_time), by = "username" ) %>%
  arrange(event_time) %>%
  mutate(event_date = as.Date(event_time)) %>%
  # mutate(active_last_year = case_when(as_date(active_time) < (today() - dyears(1)) ~ FALSE,
  #                                   as_date(active_time) >= (today() - dyears(1)) ~ TRUE)) %>%
  mutate(active_last_year = case_when(
    as_date(active_time) < (event_time - dyears(1)) ~ FALSE,
    as_date(active_time) >= (event_time - dyears(1)) ~ TRUE)) %>%
  group_by(username) %>%
  arrange(username, event_time) %>%
  mutate(multiple_events = case_when(
    n() > 1 ~ TRUE,
    TRUE ~ FALSE)) %>%
  mutate(effect = event) %>%
  mutate(prior_effect =
           case_when(
             row_number() == 1 ~ event,
             multiple_events == T & active_last_year == T & row_number() > 1 ~ lag(event, 1),
             multiple_events == T & active_last_year == F ~ "dropped")) %>%
  mutate(result = case_when(
    prior_effect == "created" & effect == "created" ~ 1,
    prior_effect == "created" & effect == "dropped" ~ -1,
    prior_effect == "created" & effect == "locked" ~ -1,
    prior_effect == "created" & effect == "unlocked" ~ 0,
    prior_effect == "dropped" & effect == "created" ~ 1,
    prior_effect == "dropped" & effect == "dropped" ~ 0,
    prior_effect == "dropped" & effect == "locked" ~ 0,
    prior_effect == "dropped" & effect == "unlocked" ~ 0,
    prior_effect == "locked" & effect == "created" ~ 1,
    prior_effect == "locked" & effect == "dropped" ~ 0,
    prior_effect == "locked" & effect == "locked" ~ 0,
    prior_effect == "locked" & effect == "unlocked" ~ 1,
    prior_effect == "unlocked" & effect == "created" ~ 0,
    prior_effect == "unlocked" & effect == "dropped" ~ -1,
    prior_effect == "unlocked" & effect == "locked" ~ -1,
    prior_effect == "unlocked" & effect == "unlocked" ~ 0)) %>%
  relocate(effect, .after = prior_effect) %>%
  ungroup() %>%
  arrange(event_time) %>%
  mutate(usercount = cumsum(result))

# Historical named user plot
plot_NU <- ggplot(event_history, aes(x = event_time, y = usercount, color = event)) +
  geom_step(color = "#4C8187") +
  geom_point(alpha = 0.6) +
  labs(x = "Date", y = "Named Users", title = "Historical Named Users") +
  theme(legend.position="bottom") +
  geom_hline(yintercept = users_licensed)


add_history <- creation_history %>%
  mutate(user_add_num = row_number()) %>%
  mutate(active_in_last_year = case_when(username %in% drop_off_history$username ~ FALSE,
                                         TRUE ~ TRUE))

# Historical user additions
plot_historical <- ggplot(add_history, aes(x = event_time, y = user_add_num, color = active_in_last_year)) +
  geom_point_interactive(aes(tooltip=paste(username, "\n", event_time), data_id=username)) +
  geom_step(color = "#4C8187") +
  labs(x = "Date", y = "Number of Users Added to Server", title = "Historical User Additions") +
  theme_minimal() +
  theme(legend.position="bottom")

# girafe(ggobj = plot_historical) <- for dev troubleshooting


plot <- ggplot(mtcars, aes(x=mpg, y=hp)) + geom_point()


# Additions by role
history_role <- add_history %>% left_join(select(historical_users, username, user_role), by = "username")

plot_role <- ggplot(history_role, aes(x = event_time, y = user_add_num, color = active_in_last_year)) +
  facet_grid(. ~ user_role) +
  geom_step(color = "#4C8187") +
  geom_point(alpha = 0.3) +
  labs(x = "Date", y = "Number of Users Added to Server", title = "Historical User Additions") +
  theme_minimal() +
  theme(legend.position="bottom")

####### LEFT OFF HERE #########
# time_options <- c("1 year", "2 year", "3 year", "all time")
#
# timespan <- year(max(event_history$event_date)) - year(min(event_history$event_date))
#
# if(timespan < 3){
#
# }
#########


#### UI #####
ui <-
  tagList(
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$style(HTML(
      "html {position: relative;
             min-height: 100%;}
           body {margin-bottom: 60px;} /* Margin bottom by footer height */
           .footer {
             position: absolute;
             bottom: 0;
             width: 100%;
             height: 60px; /* Set the fixed height of the footer here */
             background-color: #f5f5f5;
           }"))),
  navbarPage(
    title = "Users on RStudio Connect",
    header = tagList(
      useShinydashboard()
    ),
    tabPanel(
      title = "Overview",
      fluidRow(valueBoxOutput("users_licensed", width = 3),
               valueBoxOutput("users_admins", width = 3),
               valueBoxOutput("users_pubs", width = 3),
               valueBoxOutput("users_viewers", width = 3)
      ),

      fluidRow(
        box("All Time User Additions to Server/Cluster",
            girafeOutput("plot_historical_interactive")),
        box("By Role",
            plotOutput("plot_role"))
      )

    ),
    tabPanel(
      title = "Licensed User Details",
      fluidRow(
        box("Licensed Named Users",
                           plotOutput("plot_NU")))
    )
    ), #end navbarPage
  tags$footer(paste("Data sourced from:",pin_freshness_str), class = "footer")
)


##### SERVER ######
server <- function(input, output) {

  # Reactive elements

  # Outputs
  output$users_licensed <- renderValueBox({
    users_licensed %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Named Users")
  })

  output$users_admins <- renderValueBox({
    nrow(users_admins) %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Administrators")
  })

  output$users_pubs <- renderValueBox({
    nrow(users_pubs) %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Publishers")
  })

  output$users_viewers <- renderValueBox({
    nrow(users_viewers) %>%
      prettyNum(big.mark = ",") %>%
      valueBox(subtitle = "Viewers")
  })


  output$plot_historical <- renderPlot({plot_historical})

  output$plot_historical_interactive <- renderGirafe({girafe(ggobj = plot_historical)})


  output$plot_role <- renderPlot({plot_role})

  output$plot_NU <- renderPlot({plot_NU})


}

shinyApp(ui, server)


