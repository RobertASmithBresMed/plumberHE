# remove all existing data from the environment.
rm(list = ls())

# run the model using the connect server API
results <- httr::content(
  httr::POST(
    url = Sys.getenv("SERVER_URL"),
    path = "rhta2022/runDARTHmodel",
    query = list(model_functions = "https://gist.githubusercontent.com/RobertASmithBresMed/09308560fffbe79a5e474e7dad54ea3e/raw/dfc518c7474fa577bf68bec2a60e0246fdbd4ec2/DARTHcode.R"),
    body = jsonlite::toJSON(data.frame(parameter = c("p_HS1","p_S1H"),
                                       distribution = c("beta","beta"),
                                       v1 = c(25, 50),
                                       v2 = c(150, 100))),
    httr::add_headers(Authorization = paste0("Key ", 
                                             Sys.getenv("CONNECT_KEY")))
  )
)

# write the results as a csv to the outputs folder...
write.csv(x = results,
          file = "outputs/darth_model_results.csv")

# render the markdown document from the report folder, passing the results from above
# to the report.
rmarkdown::render(input = "report/darthreport.Rmd",
                  params = list("df_results" = results),
                  output_dir = "outputs")