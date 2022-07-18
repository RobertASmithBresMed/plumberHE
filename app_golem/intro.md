---
title: "Introduction"
output: html_document
date: '2022-07-06'
---



This example application was created for the <a href="https://r-hta.org/" target="_blank">R-HTA</a> workshop, held at Oxford University on Thursday 19th May 2022. The manuscript for this application is currently under review at Wellcome Open Research.

# **Automating a living health economic evaluation with GitHub Actions & Plumber APIs**

Robert Smith<sup>1,2,3</sup>, Paul Schneider<sup>1,3</sup> & Wael Mohammed<sup>1,3</sup>

<sup>1</sup> <a href="https://www.sheffield.ac.uk/scharr" target="_blank">University of Sheffield</a>, Sheffield, UK  
<sup>2</sup> <a href="https://lumanity.com/" target="_blank">Lumanity</a>, Sheffield, UK   
<sup>3</sup> <a href="https://darkpeakanalytics.com/" target="_blank">Dark Peak Analytics</a>, Sheffield, UK;

#### **Background**

The process of updating economic models is time-consuming and expensive, and often involves the transfer of sensitive data between parties. Here, we demonstrate how HEOR can be conducted in a way that allows clients to retain full control of their data, while automating reporting as new information becomes available.

#### **Methods**

We developed an automated analysis and reporting pipeline for health economic modelling and made the source code openly available on a GitHub repository. It consists of three parts:
 -	An economic model is constructed by the consultant using pseudo data (i.e. random data, which has the same format as the real data).
 -	On the company side, an application programming interface (API), generated using the R package plumber, is hosted on a server. An automated workflow is created. This workflow sends the economic model to the company API. The model is then run within the company server. The results are sent back to the consultant, and a (PDF) report is automatically generated using RMarkdown.
 - This API hosts all sensitive data, so that data does not have to be provided to the consultant.

#### **Results & Discussion**

The method is relatively complex, and requires a strong understanding of R, APIs, RMarkdown and GitHub Actions. However, the end result is a process, which allows the consultant to conduct health economic (or any other) analyses on company data, without having direct access – the company does not need to share their sensitive data. The workflow can be scheduled to run at defined time points (e.g. monthly), or when triggered by an event (e.g. an update to the underlying data or model code). Results are generated automatically and wrapped into a full report. Documents no longer need to be revised manually.

#### **Conclusions**

This example demonstrates that it is possible, within a HEOR setting, to separate the health economic model from the data, and automate the main steps of the analysis pipeline. We believe this is the first application of this procedure for a HEOR project.


## Diagram
![image](https://user-images.githubusercontent.com/41961614/177011969-3c272532-b8f8-4c2e-8b87-06a5f6737514.png)

## The API

The example plumber code used to generate the API can be found <a href="https://github.com/RobertASmithBresMed/plumberHE/tree/main/darthAPI" target="_blank">here</a>.

# The App
This app allows the user to query the model without access to the underlying data, in fact even those tasked with building the app did not have access to the underlying data. Within the app, the following code is executed to send a request to the API, which returns the results. Each time the `run model` button is pressed the following code runs in the app's server:

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

We thank you for your time, please send any feedback to rasmith3@sheffield.ac.uk.

Rob & Paul  
