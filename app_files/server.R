# Define server logic required to draw a histogram
server <- function(input, output) {
  
  library(shiny)
  library(ggplot2)
  library(scales)
  library(reshape2)
  library(shinybusy)
  library(waiter)
  
  source("../report/makeCEAC.R")
  source("../report/makeCEPlane.R")
  source("../app_files/landing_div.R")
  
  list_results <- eventReactive(input$runModel, {
    
    # PS: error message when api key not provided? 
    # Is the API/key supposed accessible to everyone?
    if(Sys.getenv("CONNECT_KEY") == ""){
      shiny::showNotification(type = "error","Error: No API Key provided")
      return(NULL)
    }
    
    # convert inputs into a single data-frame to be passed to the API call
    df_input <- data.frame(
      parameter = c("p_HS1", "u_S1"),
      distribution = c(input$p_HS1_dist, input$u_S1_dist),
      v1 = c(input$p_HS1_v1, input$u_S1_v1),
      v2 = c(input$p_HS1_v2, input$u_S1_v2)
    )
    
    # show modal saying sending to API
    shinybusy::show_modal_gif(text = "Interacting with client API",
                   modal_size = "l",
                   width = "200px", 
                   height = "300px",
                   src = "bean.gif"
                  )
    
    # run the model using the connect server API
    results <- httr::content(
      httr::POST(
        # the Server URL can also be kept confidential, but will leave here for now 
        url = "https://connect.bresmed.com",
        # path for the API within the server URL
        path = "rhta2022/runDARTHmodel",
        # code is passed to the client API from GitHub.
        query = list(model_functions = "https://raw.githubusercontent.com/BresMed/plumberHE/main/R/darth_funcs.R"),
        # set of parameters to be changed ... we are allowed to change these but not some others...
        body = list(
          param_updates = jsonlite::toJSON(df_input)),
        # we include a key here to access the API ... like a password protection

        config = httr::add_headers(Authorization = paste0("Key ", 
                                                          Sys.getenv("CONNECT_KEY")))
      )
    )
    # insert debugging message
    message("API returned results")
    
    # show modal saying finished getting data from API
    shinybusy::remove_modal_gif()
    
    # rename the costs columns
    results_C <- results[,1:3]
    # same for qalys
    results_Q <- results[,4:6]
    # name all the columns the same
    colnames(results_C) <- colnames(results_Q) <- c("A", "B", "C")
    
    # create ceac based on brandtools package from lumanity...
    temp_cols <- c("#D8D2BF", "#001B2B", "#007B84")
    names(temp_cols) <- c("A", "B", "C")
    
    list("results_C" = results_C, 
         "results_Q" = results_Q,
         "temp_cols" = temp_cols)
    
  })
  
    output$CEPlane <- renderPlot({
      
      
      # create the CEP
      makeCEPlane(total_costs = list_results()$results_C,
                  total_qalys = list_results()$results_Q,
                  treatment = "B",
                  comparitor = "A",
                  thresh = 30000,
                  show_ellipse = T,
                  colors = list_results()$temp_cols)

    })
    
    
    output$CEAC <- renderPlot({
      
      makeCEAC(total_costs = list_results()$results_C,
               total_qalys = list_results()$results_Q,
               treatment = c("A", "B", "C"),
               lambda_min = 0,
               lambda_max = 100000,
               col = list_results()$temp_cols)
      
    })
    
    output$ResultsTab_C <- renderTable({
      head(list_results()$results_C)
      })
    
    output$ResultsTab_Q <- renderTable({
      head(list_results()$results_Q)
      })
}