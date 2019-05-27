library(shiny)
shinyUI(
  
  fluidPage(
    titlePanel("Diagnostic test explorer"),
    h4("Test parameters"),
    fluidRow(
      column(3,"Test sensitivity / true positive rate"),
      column(3,numericInput("sens",NULL,0.8,min=0,max=1,step=0.01)),
      column(3,"Test specificity / true negative rate"),
      column(3,numericInput("spec",NULL,0.8,min=0,max=1,step=0.01))
    ),
    fluidRow(
      column(3,"Prevalence"),
      column(3,numericInput("prev",NULL,0.1,min=0,max=1,step=0.01))
    ),
    h4("Diagnostics"),
    fluidRow(
      column(3,"Proportion of true positives"),
      column(3,textOutput("tp")),
      column(3,"Proportion of false positives"),
      column(3,textOutput("fp"))
    ),
    fluidRow(
      column(3,"Propotion of true negatives"),
      column(3,textOutput("tn")),
      column(3,"Proportion of false negatives"),
      column(3,textOutput("fn"))
    ),
    fluidRow(
      column(3,"Positive predictive value"),
      column(3,textOutput("ppv")),
      column(3,"Negative predictive value"),
      column(3,textOutput("npv"))
    ),
    helpText("PPV can be visualised as the proportion of red on the left. NPV as the proportion of blue on the right."),
    fluidRow(
      column(3,"Rand accuracy"),
      column(3,textOutput("racc")),
      column(3,"Cohen's kappa"),
      column(3,textOutput("kappa"))
    ),
    plotOutput("plot",width="75%"),
    img(src='ioa_logo.png',style="width: 256px; align: left; margin-right: 2em"),
    "Darren Green (2019)",
    img(src='parasite_2.png',style="width: 64px; align: right; margin-left: 2em")
  )
  
)