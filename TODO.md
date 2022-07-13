# Main Functions for First Release

## Provides a table through connectapi

get_content_tbl - Get the Content table via the Connect API
get_users_tbl - Get the Users Table via the Connect API
get_group_members_tbl - Get the Groups Table via the Connect API

## Provides a table though a pin


get_group_names - List the names of groups on the Connect server


get_group_names - List the names of groups on the Connect server (gives a vector)
get_groups_summary - Get a Summary of the Groups Table (uses an intermediate table)
get_lock_history_tbl - Get Locking event history from audit logs
get_user_current_tbl - Get current user table (uses an intermediate table)
get_user_historical_tbl - Get historical user table based on Connect API user table (w/ users_tbl)
get_users_daysback - Get Users that have been active in the last `daysback` days
get_users_role - Get Users by role (uses the users_tbl)
make_group_members_tbl - 
