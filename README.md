This repository was created for the [R-HTA](https://r-hta.org/) workshop, held in Oxford on Thursday 19th May 2022. 

# **Automating a living health economic evaluation with GitHub Actions & Plumber APIs**

Robert Smith<sup>1,2,3</sup> &  Paul Schneider<sup>2,3</sup> 

<sup>1</sup> [Lumanity](https://lumanity.com/), Sheffield, UK    
<sup>2</sup> [University of Sheffield](https://www.sheffield.ac.uk/scharr), University of Sheffield, Sheffield, UK    
<sup>3</sup> [Dark Peak Analytics](https://darkpeakanalytics.com/), Sheffield, UK;

>#### **Background**
>
>The process of updating economic models is time-consuming and expensive, and often involves the transfer of sensitive data between parties. Here, we demonstrate how HEOR can be conducted in a way that allows clients to retain full control of their data, while automating reporting as new information becomes available.
>
>#### **Methods**
>
>We developed an automated analysis and reporting pipeline for health economic modelling and made the source code openly available on a GitHub repository. It consists of three parts:
> -	An economic model is constructed by the consultant using pseudo data (i.e. random data, which has the same format as the real data).
> -	On the client side, an application programming interface (API), generated using the R package plumber, is hosted on a server. An automated workflow is created. This workflow sends the economic model to the client API. The model is then run within the client server. The results are sent back to the consultant, and a (PDF) report is automatically generated using RMarkdown.
> - This API hosts all sensitive data, so that data does not have to be provided to the consultant.
>
>#### **Results & Discussion**
>
>The method is relatively complex, and requires a strong understanding of R, APIs, RMarkdown and GitHub Actions. However, the end result is a process, which allows the consultant to conduct health economic (or any other) analyses on client data, without having direct access – the client does not need to share their sensitive data. The workflow can be scheduled to run at defined time points (e.g. monthly), or when triggered by an event (e.g. an update to the underlying data or model code). Results are generated automatically and wrapped into a full report. Documents no longer need to be revised manually.
>
>#### **Conclusions**
>
>This example demonstrates that it is possible, within a HEOR setting, to separate the health economic model from the data, and automate the main steps of the analysis pipeline. We believe this is the first application of this procedure for a HEOR project.


## Diagram

[!Diagram]('app_files/www/process_diagram.PNG')

## Project Organization

Show the project structure here, overwriting the default as necessary.

------------------------

```
├── data
│   └── processed      <- Processed, cleaned data - likely not used here.
│
├── outputs            <- Generated outputs (reports, figures, etc)
│
├── report             <- Write up for external use. Rmarkdown files, bibtex etc.. include templates if not in BresMed package.
│
├── R                  <- Source code for use in this project, all functions.
│
├── tests              <- Tests for this project - e.g. testthat.
│
├── scripts            <- Scripts that may run specific analyses
│
├── app_files          <- Folder for Shiny App content, includes file app.R.
│  └── UI              <- folder with UI content.
│  └── server          <- folder containing server file.
│  └── www             <- other content.
│
├──.github 
│  └── workflows       <- contains all workflows for github actions.
│
├── .gitignore         <- indicating which files should be ignored by git
│
└── README.md          <- Top-level README - this file.
```

## Instructions for using the API only

The file `scripts/run_darthAPI.R` is the file run by the automated workflow.
Within this file is a call to the API, shown below, undertaken using the `httr` package.
To run this function you will need the api key, which I have stored as an environment variable `CONNECT_KEY`.

```
# function to call API to run the model
httr::content(
  httr::POST(
    # the Server URL can also be kept confidential, but will leave here for now 
    url = "https://connect.bresmed.com",
    # path for the API within the server URL
    path = "rhta2022/runDARTHmodel",
    # code is passed to the client API from GitHub.
    query = list(model_functions = "https://raw.githubusercontent.com/BresMed/plumberHE/main/R/darth_funcs.R"),
    # set of parameters to be changed ... we are allowed to change these but not some others...
    body = jsonlite::toJSON(data.frame(parameter = c("p_HS1","p_S1H"),
                                       distribution = c("beta","beta"),
                                       v1 = c(25, 50),
                                       v2 = c(150, 100))),
    # we include a key here to access the API ... like a password protection
    config = httr::add_headers(Authorization = paste0("Key ", 
                                             Sys.getenv("CONNECT_KEY")))
  )
)

```

The example plumber code used to generate the API can be found in `darthAPI`. This is a development version of the code.

### List of contributors
- [RobertASmith](Robert.Smith@lumanity.com)
- [Paul Schneider](pschneider@darkpeakanalytics.com)
