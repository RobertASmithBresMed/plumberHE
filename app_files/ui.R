source("./landing_div.R")

# Define UI for application that draws a histogram
ui <- fillPage(
  
  shiny::tags$head(
    tags$title(
      "PlumberHE demo"
    )
  ),
  # suppressDependencies("bootstrap"),
  tags$link(
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css",
    rel="stylesheet",
    integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC",
    crossorigin="anonymous"
  ),
  # tags$script(
  #   src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js",
  #   integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM",
  #   crossorigin="anonymous"
  # ),
  
  # enable shinyjs
  #useShinyjs(),
  # load js scripts
  includeScript("./www/utils.js"),
  # load custom css
  includeCSS("style.css"),
  
  waiter::use_waiter(),
  waiter::waiter_show_on_load(color = "", html = landingDiv()),
  
  # Application title
  titlePanel( h1("Living HTA - Demo Shiny App", 
                 align = "center",color = "#012d5c", style = "margin-bottom: 20px;")
  ),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
    sidebarPanel(
      
      tabsetPanel(
        
        tabPanel(title = "State Trans Probs", 
                 
                 #=====================================#
                 # Transition Prob from Healthy to Sick
                 #=====================================#
                 
                 selectInput(inputId = "p_HS1_dist",
                             label = "p(S1 | H): Distribution",
                             choices = c("beta", "gamma", "rlnorm", "fixed"),
                             selected = "beta"),
                 
                 numericInput(inputId = "p_HS1_v1",
                              label = "p(S1 | H): Parameter 1",
                              min = 0,
                              max = 200,
                              value = 30),
                 
                 numericInput(inputId = "p_HS1_v2",
                              label = "p(S1 | H): Parameter 2",
                              min = 0,
                              max = 200,
                              value = 170)
        ),
        
        tabPanel(title = "Utilities", 
                 #=====================================#
                 # Transition Prob from Healthy to Sick
                 #=====================================#
                 
                 selectInput(inputId = "u_S1_dist",
                             label = "Utility S1: Distribution",
                             choices = c("beta", "gamma", "rlnorm", "fixed"),
                             selected = "beta"),
                 
                 numericInput(inputId = "u_S1_v1",
                              label = "Utility S1: Parameter 1",
                              min = 0,
                              max = 200,
                              value = 130),
                 
                 numericInput(inputId = "u_S1_v2",
                              label = "Utility S1: Parameter 2",
                              min = 0,
                              max = 200,
                              value = 45)
        )
      ),
      
      
      
      
      
      # action button to run the model
      actionButton("runModel", "Run Model", class = "btn btn-primary btn-lg"),
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel(title = "Model Output",
                class = "p-3",
                 column(width = 6,align="center",
                        h2("QALYs"),
                        tableOutput(outputId = "ResultsTab_Q")),
                 column(width = 6,align="center",
                        h2("Costs"),
                        tableOutput(outputId = "ResultsTab_C"))),
        tabPanel(title = "CE Plane", 
                 class = "p-3",
                 plotOutput(outputId = "CEPlane")),
        tabPanel(title = "CEAC", 
                 class = "p-3",
                 plotOutput(outputId = "CEAC"))
      )
      
    )
  ),
  
  div(
    class = "card mt-3 mb-5 shadow-lg w-50 mx-auto",
    div(
      class = "card-header",
      "Why does this matter ... "
    ),
    div(
      class = "card-body",
      div(
        
        p(
          "The take-home from this very simple demo app is that the designer of the app
       does not need to have: the model code, any data, any knowledge of health economics.
       They just connect numeric inputs to JSON inputs to the model as requested by a health economist"
        )
      )), # end row
    
    
    
    div(
      class = "d-flex justify-content-center w-100 mb-4", 
      actionButton("code", "code", icon = icon("code"), class = "btn-info-2"),
    
      actionButton(
        "contact",
        "contact",
        icon = icon("envelope"),
        class = "btn-info-2"
      )
  )
  )
  
)