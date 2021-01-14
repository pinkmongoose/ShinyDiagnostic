#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    theme="styles.css",
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
    "Darren Green (2021)",
    img(src='parasite_2.png',style="width: 64px; align: right; margin-left: 2em")
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    options(shiny.error = function() {
        stop("Incomplete data.")
    })
    
    
    Model <- reactive({
        tp <- input$sens*input$prev
        fn <- (1-input$sens)*input$prev
        tn <- input$spec*(1-input$prev)
        fp <- (1-input$spec)*(1-input$prev)
        ppv <- tp/(tp+fp)
        npv <- tn/(tn+fn)
        racc <- tp+tn
        ppos <- (tp+fp)*(tp+fn)
        pneg <- (tn+fn)*(tn+fp)
        pe <- ppos+pneg
        kappa <- (racc-pe)/(1-pe)
        list(tp=tp,fp=fp,tn=tn,fn=fn,ppv=ppv,npv=npv,racc=racc,kappa=kappa)
    })
    
    output$tp <- renderText({signif(Model()$tp,3)})
    output$fp <- renderText({signif(Model()$fp,3)})
    output$tn <- renderText({signif(Model()$tn,3)})
    output$fn <- renderText({signif(Model()$fn,3)})
    output$ppv <- renderText({signif(Model()$ppv,3)})
    output$npv <- renderText({signif(Model()$npv,3)})
    output$racc <- renderText({signif(Model()$racc,3)})
    output$kappa <- renderText({signif(Model()$kappa,3)})
    
    output$plot <- renderPlot({
        x <- matrix(c(Model()$tp,Model()$fp,Model()$fn,Model()$tn),c(2,2))
        q <- c("red","blue")
        colnames(x) <- c("+","-")
        rownames(x) <- c("+","-")
        mosaicplot(x,dir="v",xlab="disease",ylab="test",main=NULL,col=q,cex=2)
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
