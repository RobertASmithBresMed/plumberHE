#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny bs4Dash fresh
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    bs4Dash::bs4DashPage(
      dark = NULL,
      preloader = list(html = landing_div()),
      freshTheme = fresh::create_theme(
        fresh::bs4dash_status(
          primary = "#7D8C8F"
        ),
        fresh::bs4dash_button(
          default_background_color = "#18bc9c",default_color = "#fff"
        ),
        fresh::bs4dash_font(
          family_sans_serif = "Work Sans"
        ),
        fresh::bs4dash_vars(
          link_color = "#18bc9c"
        )
      ),
      
      header = dashboardHeader(
        
        title = h2(""),
        
        tagList(
          
          
          div(
            style = "display:inline-block",
            tags$a(
              href = "https://darkpeakanalytics.com",
              tags$img(src = "www/dpa_logo.png", height = 50, style = "margin: 9px"),
              target = "_blank"
            )
          ),
          div(
            style = "display:inline-block;",
            h5("Living HTA - Demo Shiny App", style = "color: #7D8C8F; margin-top: 9px;")
          )
          
          # tags$li(
          #   class = "dropdown",
          #   style = "margin-top: 11px;",
          #   actionLink("introduction", "Introduction")
          # )
        )
      ),
      
      sidebar = dashboardSidebar(
        sidebarMenu(
          id = "sidebar",
          menuItem(
            text = "Introduction",
            tabName = "intro"
          ),
          menuItem(
            text = "The model",
            tabName = "main_model"
          ),
          menuItem(
            text = "Report",
            tabName = "report"
          ),
          menuItem(
            text = "Information",
            tabName = "info"
          )
        ),
        
        customArea = tagList(
          div(
            style = "display:inline-block; margin-left: 13px;",
            tags$img(src = "www/sheffield_logo.png", height = 41)
          ),
          div(
            style = "display:inline-block;",
            tags$img(src = "www/lumanity_logo.png", height = 41)
          ),
          div(
            style = "display:inline-block;",
            tags$img(src = "www/dpa_logo.png", height = 41)
          )
        )
      ),
      
      body = dashboardBody(
        use_googlefont("Work Sans"),
        
        tabItems(
          tabItem(
            tabName = "intro",
            HTML(markdown::markdownToHTML(knitr::knit("inst/app/www/intro.Rmd", quiet=T),fragment.only = T))
            #includeMarkdown(path = "./inst/app/www/intro.Rmd")
          ),
          
          tabItem(
            tabName = "main_model",
            mod_main_ui("main")
          ),
          
          tabItem(
            tabName = "report",
            h5("Report tab")
          ),
          
          tabItem(
            tabName = "info",
            fluidRow(
              column(
                width = 6,
                box(
                  title = "Academic Paper",
                  width = NULL,
                  collapsible = FALSE,
                  maximizable = TRUE,
                  tags$iframe(
                    src="www/academic_paper.pdf",
                    width="100%",
                    height = "500"
                  )
                )
              ),
              
              column(
                width = 6,
                box(
                  title = "Video",
                  width = NULL,
                  maximizable = TRUE,
                  collapsible = FALSE
                )
              )
              
            )
          )
          
        )

      ),
      
      footer = dashboardFooter(
        fixed = TRUE,
        left = tagList(
          #tags$a(href = "mailto::shahreyar.abeer@gmail.com", "Why does this matter?")
          tippy::tippy(
            trigger = "click",
            theme = "light-border",
            interactive = TRUE,
            actionLink("why", "Why does this matter?"),
            
            tagList(
              h6("Why does this matter?"),
              p(
                "The take-home from this very simple demo app is that the designer of the app
                does not need to have:"
              ),
              tags$ol(
                style = "text-align: left;",
                tags$li("the model code"),
                tags$li("any data"),
                tags$li("any knowledge of health economics")
              ),
              tags$p("They just connect numeric inputs to JSON inputs to the model as requested by a health economist"),
              
              tags$a(
                actionButton("code", "code", icon = icon("code")),
                href = "https://github.com/RobertASmithBresMed/plumberHE/blob/main/report/academicpaper.pdf",
                target = "_blank"
              ),
              tags$a(
                actionButton("contact","contact",icon = icon("envelope")),
                href = "mailto:rsmith@darkpeakanalytics.com"
              )
              
            )
          )
        ),
        right = tagList(
          "By ",
          tags$a("Robert", href = "https://www.linkedin.com/in/robert-smith-53b28438/", target = "_blank"), ", ",
          tags$a("Paul", href = "https://www.linkedin.com/in/paul-schneider-204345131/", target = "_blank"), ", ",
          tags$a("Wael", href = "https://www.linkedin.com/in/wael-mohammed/", target = "_blank"),
          "& ", tags$a("Zauad", href = "https://bd.linkedin.com/in/zauad-shahreer", target = "_blank")
        )
      )
      
    ) # end bs4DashPage
    
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "livingHTA-demo"
    ),
    
    shinyjs::useShinyjs(),
    shinyFeedback::useShinyFeedback()
    
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
