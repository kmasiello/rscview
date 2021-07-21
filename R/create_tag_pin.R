

pins::pin(x, name = name, description = description, board = "rsconnect")


tag_name <- "Server Audit"
tag_parent <- "Projects and Presentations"

#create the tag -- will not give message if tag already exists.
create_tag_tree(conn, tag_parent, tag_name)

pins::pin(df_users, name = "user-info", description = "Results pulled from `connectapi::get_users()`", board = "rsconnect")
my_content <- content_item(conn = create_connection(), pins::pin_info("katie/user-info", board = "rsconnect")$guid)
# tag it
set_content_tag_tree(my_content, tag_parent, tag_name)
# set_content_tags(pin_users, all_tags$`Projects and Presentations`$`Server Audit`)

create_tag_pin <- function(pin_id, tag_name, conn = create_connection()) {
  tag_tree = connectapi::create_tag_tree(conn, tag_parent, tag_name)

}
