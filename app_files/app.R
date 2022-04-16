#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
rm(list = ls())

# source the UI and server files
#source("app_files/ui.R")
#source("app_files/server.R")
#source("report/makeCEAC.R")
#source("report/makeCEPlane.R")

#source("app_files/landing_div.R")

# Run the application 
shinyApp(ui = ui, 
         server = server)
