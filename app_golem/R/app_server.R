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
  
  r = reactiveValues(
    api_connected = FALSE,
    api_key = NULL
  )
  
  mod_main_server("main", r)
  
  observeEvent(input$introduction, {
    showModal(
      modalDialog(
        id = 'intro_modal',
        size = 'l',
        title = "Introduction",
        easyClose = FALSE,
        footer = tagAppendAttributes(id = 'intro_button', modalButton(label = 'Done')),
        fade = TRUE,
        
        fluidRow(
          tags$iframe(src="www/academic_paper.pdf", 
                      width="1200", 
                      height="500")
        )
      )
    )
  })
  
 
}
