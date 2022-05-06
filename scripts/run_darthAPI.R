# remove all existing data from the environment.
rm(list = ls())

library(ggplot2)
library(jsonlite)
library(httr)

# run the model using the connect server API
results <- httr::content(
  httr::POST(
    # the Server URL can also be kept confidential, but will leave here for now 
    url = "https://connect.bresmed.com",
    # path for the API within the server URL
    path = "rhta2022/runDARTHmodel",
    # code is passed to the client API from GitHub.
    query = list(model_functions = 
                   paste0("https://raw.githubusercontent.com/",
                          "BresMed/plumberHE/main/R/darth_funcs.R")),
    # set of parameters to be changed ... 
    # we are allowed to change these but not some others
    body = list(
      param_updates = jsonlite::toJSON(
        data.frame(parameter = c("p_HS1","p_S1H"),
                   distribution = c("beta","beta"),
                   v1 = c(25, 50),
                   v2 = c(150, 100))
      )
    ),
    # we include a key here to access the API ... like a password protection
    config = httr::add_headers(Authorization = paste0("Key ", 
                                                      Sys.getenv("CONNECT_KEY")))
  )
)

# write the results as a csv to the outputs folder...
write.csv(x = results,
          file = "outputs/darth_model_results.csv")

source("report/makeCEAC.R")
source("report/makeCEPlane.R")

# render the markdown document from the report folder, 
# passing the results dataframe to the report.
rmarkdown::render(input = "report/darthreport.Rmd",
                  params = list("df_results" = results),
                  output_dir = "outputs")