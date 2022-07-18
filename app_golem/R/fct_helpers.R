#' helpers 
#'
#' @description Functions required in the app
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd


check_api = function(api) {
  
  
  api_checker_val <- unlist(httr::content(
    httr::GET(
      # the Server URL can also be kept confidential, but will leave here for now
      url = "https://connect.bresmed.com",
      # path for the API within the server URL
      path = "rhta2022/checkAPIkey",
      # we include a key here to access the API ... like a password protection
      config = httr::add_headers(Authorization = paste0("Key ", api))
    )
  ))
  
  return(isTRUE(api_checker_val))
  
}


# convert inputs into a single data-frame to be passed to the API call
make_input_df = function(
    p_HS1_dist, p_HS1_v1, p_HS1_v2,
    u_S1_dist, u_S1_v1, u_S1_v2
  ) {
  df_input <- data.frame(
    parameter = c("p_HS1", "u_S1"),
    distribution = c(p_HS1_dist, u_S1_dist),
    v1 = c(p_HS1_v1, u_S1_v1),
    v2 = c(p_HS1_v2, u_S1_v2)
  )
  
  jsonlite::toJSON(df_input)
}

# run the model using the connect server API
get_data_from_api = function(df_input, api_key) {
  
  results <- httr::content(
    httr::POST(
      url = "https://connect.bresmed.com",
      path = "rhta2022/runDARTHmodel",
      query = list(model_functions = "https://raw.githubusercontent.com/BresMed/plumberHE/main/R/darth_funcs.R"),
      body = list(param_updates = df_input),
      config = httr::add_headers(Authorization = paste0("Key ", api_key))
    )
  )
  
  results
  
}

