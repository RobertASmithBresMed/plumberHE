This repository was created for the [R-HTA](https://r-hta.org/) workshop, held in Oxford on Thursday 19th 2022. 

# **Automating a living health economic evaluation with GitHub Actions & Plumber APIs**

Robert Smith<sup>1,2,3</sup>,  Paul Schneider<sup>2,3</sup> & Praveen Thokala<sup>2</sup>

<sup>1</sup> [Lumanity](https://lumanity.com/), Sheffield, UK; 
<sup>2</sup> [University of Sheffield](https://www.sheffield.ac.uk/scharr), University of Sheffield, Sheffield, UK; 
<sup>3</sup> [Dark Peak Analytics](https://darkpeakanalytics.com/), Sheffield, UK;

#### **Background**

The process of updating economic models is time-consuming and expensive, and often involves the transfer of sensitive data between parties.
However, recent advances in data and computing sciences can be combined with script based health economic models to provide living health economic analysis, that is, analysis
that is continually being updated as new evidence, and our understanding of the world, emerge.
Allowing clients to retain control of their data, while automating much of the health economic analysis, would be a desirable step forward for HEOR.
The following describes a simple worked example of an automated health economic evaluation which is run monthly, or as new data emerges.


#### **Methods**

The materials demonstrate how economic models can be separated from any sensitive data on which they rely, allowing for companies to retain control of their data at all times and allowing models to be automatically updated as new data becomes available. There are three parts to achieving this:
- An API, generated using the R package [plumber](https://www.rplumber.io/?msclkid=b4faa783bbfc11ec93ded7f5b4523880/) is hosted on a client server (on RStudio Connect). This API hosts all sensitive data, so that data does not have to be provided to the consultant. 
- An economic model, written in a script based programming language, is constructed by the consultant using pseudo data and hosted on GitHub. For this example we use the sick-sicker model created as a teaching tool by the [DARTH group](http://darthworkgroup.com/). 
- An automated workflow is created using GitHub actions. This workflow passes the model code to the client API, which runs the model within the client server and returns the results of the economic analysis. This workflow can be scheduled to run at certain time points (e.g. monthly), or when triggered by an event (e.g. an update to the model). A report is generated from the workflow using [RMarkdown](https://rmarkdown.rstudio.com/?msclkid=2f44ca56bbfe11eca6ec37c1951dc1f9).

A diagram of the method is shown below.

**< INSERT DIAGRAM HERE >**

#### **Results & Discussion**

The method is relatively complex, and would require a strong understanding of R, APIs, RMarkdown and GitHub Actions.
However, the end result is a process by which a client never needs to release their sensitive data to a consultant, reducing concerns about data-security.
The entire process is automated, such that it can be triggered by a client if data is provided ad-hoc, or run on a schedule if data is continually updated.
As far as we are aware this is the first application of this process anywhere for a HEOR project.

#### **Conclusions**

This example demonstrates that it is possible to separate an algorithm (a code base for a health economic model) from the data used by the model. 
By using new open source tools data never left the client's server, yet analysis was undertaken and updated when necessary as new data was input by the client.

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

### List of contributors
- [RobertASmith](Robert.Smith@lumanity.com)
- [Paul Schneider](pschneider@darkpeakanalytics.com)
