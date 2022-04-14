# Living HTA with GitHub Actions & Plumber APIs

This repository was created for the [R-HTA](https://r-hta.org/) workshop, held in Oxford on Thursday 19th 2022. At the workshop, Robert Smith outlined work in collaboration with Paul Schneider from [Dark Peak Analytics](https://darkpeakanalytics.com/) and Praveen Thokala from the [University of Sheffield](https://www.sheffield.ac.uk/scharr/people/staff/praveen-thokala?msclkid=6c8d9a67bbfc11ec9f3b4d210bc93b92).

## Background


## Method
The materials demonstrate how economic models can be separated from any sensitive data on which they rely, allowing for companies to retain control of their data at all times and allowing models to be automatically updated as new data becomes available. There are three parts to achieving this:
- An API, generated using the R package [plumber](https://www.rplumber.io/?msclkid=b4faa783bbfc11ec93ded7f5b4523880/) is hosted on a client server. This API hosts all sensitive data, so that data does not have to be provided to the consultant. 
- An economic model, written in a script based programming language, is constructed by the consultant using pseudo data and hosted on GitHub. For this example we use the sick-sicker model created as a teaching tool by the [DARTH group](http://darthworkgroup.com/). 
- An automated workflow is created using GitHub actions. This workflow passes the model code to the client API, which runs the model within the client server and returns the results of the economic analysis. This workflow can be scheduled to run at certain time points (e.g. monthly), or when triggered by an event (e.g. an update to the model). A report is generated from the workflow using [RMarkdown](https://rmarkdown.rstudio.com/?msclkid=2f44ca56bbfe11eca6ec37c1951dc1f9).

A diagram of the method is shown below.

**< INSERT DIAGRAM HERE >**

## Results & Discussion

## Conclusion

## Project Organization

Show the project structure here, overwriting the default as necessary.

------------------------

```
├── data
│   ├── processed      <- Processed, cleaned data - likely not used here.
│   └── raw            <- Original, raw data - for where data is publicly available but not conveniently loaded.
│
├── docs               <- Documentation for internal use
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
├── LICENSE            <- if applicable for external publication
└── README.md          <- Top-level README - this file.
```

### List of contributors
- [RobertASmith](Robert.Smith@lumanity.com)
