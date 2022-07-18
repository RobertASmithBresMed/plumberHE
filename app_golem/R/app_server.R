#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  #shinyjs::runjs("$('#p_HS1_dist').tooltip({ placement: 'top', title: 'Please enter API', html: false, trigger: 'hover', delay: {show: 700, hide: 100} });")
  
  Sys.sleep(1)
  
  httr::set_config(httr::config(ssl_verifypeer = 0L))
  
  r = reactiveValues(
    api_connected = FALSE,
    api_key = NULL,
    sidebar = NULL
  )
  
  mod_main_server("main", r)
  
  observeEvent(input$sidebar, {
    req(input$sidebar)
    r$sidebar = input$sidebar
  })
  
 
}
