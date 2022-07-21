[![DOI](https://zenodo.org/badge/481174680.svg)](https://zenodo.org/badge/latestdoi/481174680)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.png?v=103)](https://opensource.org/licenses/mit-license.php)

This repository was originally created for the [R-HTA](https://r-hta.org/) workshop, held in Oxford on Thursday 19th May 2022.

An academic paper has been submitted to Wellcome Open Research, the pre-print under review can be found [here](https://wellcomeopenresearch.org/articles/7-194/v1#ref-6). Please reference as:

>Smith RA, Schneider PP and Mohammed W. Living HTA: Automating Health Technology Assessment with R [version 1; peer review: awaiting peer review]. Wellcome Open Res 2022, 7:194 (https://doi.org/10.12688/wellcomeopenres.17933.1)

# **Living HTA: Automating Health Technology Assessment with R**

Robert Smith<sup>1,2,3</sup>, Paul Schneider<sup>1,3</sup> & Wael Mohammed<sup>1,3</sup>

<sup>1</sup> [University of Sheffield](https://www.sheffield.ac.uk/scharr), University of Sheffield, Sheffield, UK   
<sup>2</sup> [Lumanity](https://lumanity.com/), Sheffield, UK    
<sup>3</sup> [Dark Peak Analytics](https://darkpeakanalytics.com/), Sheffield, UK;

>#### **Background**
>
>Requiring access to sensitive data can be a significant obstacle for the development of health models in the Health Economics & Outcomes Research (HEOR) setting. We demonstrate how health economic evaluation can be conducted with minimal transfer of data between parties, while automating reporting as new information becomes available.
>
>#### **Methods**
>
>We developed an automated analysis and reporting pipeline for health economic modelling and made the source code openly available on a GitHub repository. The pipeline consists of three parts: An economic model is constructed by the consultant using pseudo data. On the data-owner side, an application programming interface (API) is hosted on a server. This API hosts all sensitive data, so that data does not have to be provided to the consultant. An automated workflow is created, which calls the API, retrieves results, and generates a report.
>
>#### **Results & Discussion**
>
>The application of modern data science tools and practices allows analyses of data without the need for direct access – negating the need to send sensitive data. In addition, the entire workflow can be largely automated: the analysis can be scheduled to run at defined time points (e.g. monthly), or when triggered by an event (e.g. an update to the underlying data or model code); results can be generated automatically and then be exported into a report. Documents no longer need to be revised manually.
>
>#### **Conclusions**
>
>This example demonstrates that it is possible, within a HEOR setting, to separate the health economic model from the data, and automate the main steps of the analysis pipeline.


## Diagram
<img src='app_files/www/process_diagram.PNG' height="300" align="center"/>


## Creating the API

The example plumber code used to generate the API can be found in the `darthAPI` folder. This is a development version of the code.

## Using the API

The file `scripts/run_darthAPI.R` is the file run by the automated workflow.

Within this file is a call to the API, shown below, undertaken using the `httr` package.

It is not possible to run this function yourself, since it requires the API key, which I have stored as an environment variable `CONNECT_KEY`. However the code used to call the API can be seen below:

```
# function to call API to run the model
httr::content(
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

```

## Example App

An example app can be found in the `app files` folder. This contains a very simple R shiny application which allows users to query the API for different variable inputs.


## Creating the automated workflow

The automated workflow is run on GitHub actions at 00:01 at the first of each month, and can be found in `.github/workflows/auto_model_run.yml`.

