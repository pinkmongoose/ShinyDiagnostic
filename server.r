library(shiny)
library(epiR)
shinyServer(
  
  function(input,output) {
    
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
  
  
)
