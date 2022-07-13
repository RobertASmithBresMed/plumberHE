#' main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import shinyFeedback ggplot2 gt
mod_main_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 4,
        #offset = 1,
        box(
          title = "Inputs",
          id = ns("inputs_box"),
          width = NULL,
          elevation = 3,
          collapsible = FALSE,
          
          fluidRow(
            column(
              width = 6,
              h6("State Trans Probs", style = "text-align: center; color: var(--secondary-grey)"),
              hr(),
              div(
                id = "state_trans_probs_1",
                selectInput(
                  inputId = ns("p_HS1_dist"),
                  label = "p(S1 | H): Distribution",
                  choices = c("beta", "gamma", "rlnorm", "fixed"),
                  selected = "beta"
                )
              ),
              numericInput(
                inputId = ns("p_HS1_v1"),
                label = "p(S1 | H): Parameter 1",
                min = 0,
                max = 200,
                value = 30
              ),
              numericInput(
                inputId = ns("p_HS1_v2"),
                label = "p(S1 | H): Parameter 2",
                min = 0,
                max = 200,
                value = 170
              )
            ),
            
            column(
              width = 6,
              h6("Utilities", style = "text-align: center; color: var(--secondary-grey)"),
              hr(),
              selectInput(inputId = ns("u_S1_dist"),
                          label = "Utility S1: Distribution",
                          choices = c("beta", "gamma", "rlnorm", "fixed"),
                          selected = "beta"),
              
              numericInput(inputId = ns("u_S1_v1"),
                           label = "Utility S1: Parameter 1",
                           min = 0,
                           max = 200,
                           value = 130),
              
              numericInput(inputId = ns("u_S1_v2"),
                           label = "Utility S1: Parameter 2",
                           min = 0,
                           max = 200,
                           value = 45)
              
            )
            
          ),  # end fluidRow
          
          br(),
          
          div(
            id = ns("go_button_div"),
            style = "text-align: center; display: block;",
            loadingButton(
              inputId = ns("run_model"),
              label = "Run Model",
              style = "width: 80%",
              loadingLabel = "Interacting with API",
              loadingSpinner = "cog",
              loadingStyle = "width: 80%"
            ) %>% shinyjs::disabled()
          )
          
          
        )  # end box
        
      ),  # end column-1
      
      column(
        width = 8,
        tabBox(
          width = NULL,
          type = "tabs",
          collapsible = FALSE,
          dropdownMenu = boxDropdown(
            icon = tagList(
              uiOutput(ns("api_status"))
            ),
            boxDropdownItem(
              "Connect to API",
              id = ns("api_connect_button")
            )
          ),
          elevation = 3,
          headerBorder = FALSE,
          tabPanel(
            "Model Output",
            fluidRow(
              column(
                width = 6,
                align = "center",
                
                gt::gt_output(ns("results_tab_q"))
                
                
                # h6("QALYs", style = "text-align: center; color: var(--secondary-grey)"),
                # tableOutput(ns("results_tab_q"))
              ),  # end column-1
              
              column(
                width = 6,
                align = "center",
                
                gt::gt_output(ns("results_tab_c"))
                
                # h6("Costs", style = "text-align: center; color: var(--secondary-grey)"),
                # tableOutput(ns("results_tab_c"))
              )  # end column-2
            )  # end fluidRow
          ),  # end tabPanel
          tabPanel(
            "CE Plane",
            plotOutput(ns("ce_plane"))
          ),
          tabPanel(
            "CEAC",
            plotOutput(ns("ceac"))
          )
        )
      )
      
    )
  )
}
    
#' main Server Functions
#'
#' @noRd 
mod_main_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # observeEvent(input$p_HS1_v1, {
    #   print("go")
    #   addTooltip(
    #     id = "go_button_div",
    #     options = list(
    #       title = "Please insert API key",
    #       placement = "auto"
    #     ),
    #     session = session
    #   )
    # })
    
    output$api_status = renderUI({
      api = r$api_connected
      color = ifelse(api == TRUE, "var(--vibrant-green)", "var(--primary-green)")
      text = ifelse(api == TRUE, "API: Connected", "API: Not connected")
      div(
        icon("wrench"),
        style = paste0("color:", color),
        text
      )
    })
    
    observeEvent(input$api_connect_button, {
      
      if (r$api_connected == FALSE | r$api_connected == TRUE) {
        showModal(
          modalDialog(
            id = ns('api_modal'),
            size = 'm',
            title = "Connect to API",
            easyClose = FALSE,
            footer = NULL,
            fade = TRUE,
            
            passwordInput(ns("api_key"), "Please insert the API key", width = "100%"),
            div(
              style = "text-align: center",
              modalButton("Cancel") %>% tagAppendAttributes(class = "bg-primary"),
              shinyFeedback::loadingButton(
                inputId = ns("api_go"),
                label = "Connect",
                loadingLabel = "Checking credentials",
                style = "background: var(--vibrant-green); width: 50%",
                loadingStyle = "width: 50%",
                loadingSpinner = "circle-notch"
                
              )
            )
          )
        )
      }
      # else {
      #   toast(
      #     title = "",
      #     body = "You are already connected, there's no need to connect again",
      #     options = list(
      #       autohide = TRUE,
      #       class = "bg-primary",
      #       delay = 3000,
      #       close = FALSE
      #     )
      #   )
      # }
      
      
      
    })
    
    observeEvent(input$api_go, {
      
      if (input$api_key == "") {
        shinyFeedback::resetLoadingButton("api_go")
        
        showFeedbackWarning(
          inputId = "api_key",
          text = "Are you sure? This API Key is very short!"
        )
      } else {
        try_connect = check_api(input$api_key)
        r$api_connected = try_connect
        shinyFeedback::resetLoadingButton("api_go")
        if (isTRUE(try_connect)) {
          
          shinyFeedback::showToast(
            title = "Connected!",
            message = "You now have access to the API!",
            type = "success",
            .options = list(
              positionClass = "toast-top-right",
              progressBar = FALSE
            )
          )
          
          r$api_key = input$api_key
          removeModal()
          shinyjs::enable(id = "run_model")
          
        } else {
          showFeedbackDanger(
            inputId = "api_key",
            text = "Sorry, key did not match"
          )
        }
      }
    })
    
    observeEvent(input$api_key, {
      hideFeedback("api_key")
    })
    
    
    observeEvent(input$run_model, {
      req(r$api_connected)
      
      inputs_df = make_input_df(
        input$p_HS1_dist, 
        input$p_HS1_v1,
        input$p_HS1_v2,
        input$u_S1_dist,
        input$u_S1_v1,
        input$u_S1_v2
      )
      
      r$results = get_data_from_api(inputs_df, r$api_key)
      
      
    })
    
    observeEvent(r$results, {
      #print(r$results)
      resetLoadingButton("run_model")
      
      # rename the costs columns
      r$results_c <- r$results[,1:3]
      # same for qalys
      r$results_q <- r$results[,4:6]
      # name all the columns the same
      colnames(r$results_c) <- colnames(r$results_q) <- c("A", "B", "C")
      
      # create ceac based on brandtools package from lumanity...
      temp_cols <- c("#D8D2BF", "#001B2B", "#007B84")
      names(temp_cols) <- c("A", "B", "C")
      
      r$temp_cols = temp_cols
    })
    

    # outputs -----------------------------------------------------------------
    
    output$results_tab_c = gt::render_gt({
      req(r$results_c)
      head(r$results_c) %>% 
        gt::gt() %>% 
        gt::tab_header(
          title = "Costs"
        ) %>% 
        gt::fmt_number(
          columns = everything()
        ) %>% 
        gt::opt_table_outline(width = px(1))
    })
    
    output$results_tab_q = gt::render_gt({
      req(r$results_q)
      head(r$results_q) %>% 
        gt::gt() %>% 
        gt::tab_header(
          title = "QALYs"
        ) %>% 
        gt::fmt_number(
          columns = everything()
        ) %>% 
        gt::opt_table_outline(width = px(1))
    })
    
    output$ce_plane <- renderPlot({
      
      req(r$results_c, r$results_q)
      
      makeCEPlane(total_costs = r$results_c,
                  total_qalys = r$results_q,
                  treatment = "B",
                  comparitor = "A",
                  thresh = 30000,
                  show_ellipse = T,
                  colors = r$temp_cols)
      
    })
    
    output$ceac <- renderPlot({
      
      req(r$results_c, r$results_q)
      makeCEAC(total_costs = r$results_c,
               total_qalys = r$results_q,
               treatment = c("A", "B", "C"),
               lambda_min = 0,
               lambda_max = 100000,
               col = r$temp_cols)
      
    })
    
    
  })
}
    
## To be copied in the UI
# mod_main_ui("main_1")
    
## To be copied in the server
# mod_main_server("main_1")
