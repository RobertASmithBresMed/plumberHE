#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
rm(list = ls())

library(shiny)

source("app_files/ui.R")
source("app_files/server.R")

# Run the application 
shinyApp(ui = ui, 
         server = server)
