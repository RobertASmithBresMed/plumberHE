# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Living HTA - Demo Shiny App"),
  
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
      actionButton("runModel", "Run Model"),
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel(title = "Model Output",
                 column(width = 6,align="center",
                        h2("QALYs"),
                        tableOutput(outputId = "ResultsTab_Q")),
                 column(width = 6,align="center",
                        h2("Costs"),
                        tableOutput(outputId = "ResultsTab_C"))),
        tabPanel(title = "CE Plane", 
                 plotOutput(outputId = "CEPlane")),
        tabPanel(title = "CEAC", 
                 plotOutput(outputId = "CEAC"))
      )
      
    )
  ),
  
  "Important take-home from this very simple demo app is that the designer of the app
       does not need to have: the model code, any data, any knowledge of health economics.
       They just connect numeric inputs to JSON inputs to the model as requested by a health economist"
)