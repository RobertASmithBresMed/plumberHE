# NOTE: BEFORE RUNNING THIS APP, PLEASE ENSURE YOU HAVE THE FOLLOWING SYS.ENV SET: 
#
# Sys.setenv(CONNECT_KEY = "")
# Sys.setenv(SERVER_URL = "")
#
rm(list = ls())

# source the UI and server files
#source("app_files/ui.R")
#source("app_files/server.R")
#source("report/makeCEAC.R")
#source("report/makeCEPlane.R")

#source("app_files/landing_div.R")

# Run the application 
runApp("app_files")
