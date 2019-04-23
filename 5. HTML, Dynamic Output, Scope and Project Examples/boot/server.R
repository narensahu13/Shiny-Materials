## Interactive PLS Path Modeling Online application 
## server.R file with application logic

# Needed libraries are loaded in global.R

# Define server logic to Show PLSPM results
shinyServer(function(input, output) {
  
  # ----------------------------------------------
  # FUNCTIONS TO CREATE plspm() FUNCTION ARGUMENTS
  # FROM SmartPLS .splsm model file import
  
  # Non-reactive function to create inner_matrix
  # second argument for plspm() function 
  source("make_inner.R", local=TRUE)
  
  # Non-reactive function to create outer_list
  # third argument for plspm() function
  source("make_outer.R", local=TRUE)
  
  # Non-reactive function to strip out modes from
  # imported SmartPLS model file for each LV
  # and return them in an LV-named vector. Is the
  # fourth argument for plspm() function
  source("get_modes.R", local=TRUE)
  
  # -----------------------------------------------------
  # Reactive functions that read in input files

  # reactively read in CSV file 
  readd <- reactive({
    
    # input$file1 will be NULL initially. 
    # After the user selects and uploads a 
    # file, it will be a data frame with 
    # 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will 
    # contain the local filenames where the 
    # data can be found.
    
    inFile1 <- input$file1
    if (is.null(inFile1))
      return(NULL)
    data <- read.csv(inFile1$datapath, header=T)
    return(data)
  })
  
  output$columns <- renderUI({
    inFile1 <- input$file1
    if (is.null(inFile1))
      return(NULL)
    dat = read.csv(inFile1$datapath, header=T)
    selectInput("grp", "Variables in your dataset:", 
                names(dat))
    })
  
  # reactively read in SmartPLS model (.splsm) file
  # and runs semPLS with .splsm file present. This function
  # returns both the model (as readm()[[1]]) and the
  # semPLS-fit path model object as readm()[[2]]
  
  readm <- reactive({
    out <- list()
    inFile2 <- input$file2
    if (!is.null(inFile2)) {
      # put model as 1st component of output list
      out[[1]] <- read.splsm(inFile2$datapath)
    }

    # set inner weighting scheme
    # based on user input
    if (input$scheme=="path") {
      wschm <- "C"
      } else if (input$scheme=="factor"){
        wschm <- "B"
        } else wschm <- "A"
    # put semPLS.fit as 2st component of output list
    out[[2]] <- sempls(out[[1]], readd(), wscheme=wschm)
    return(out)
  })
  
  # reactively read in measure.csv file 
  # as measurement model
  readmm <- reactive({  
    inFile3 <- input$file3
    if (is.null(inFile3))
      return(NULL)
    mm <- read.csv(inFile3$datapath, header=F)
    return(mm)
  })
  
  # reactively read in structure.csv file 
  # as structural model
  readsm <- reactive({
    inFile4 <- input$file4
    if (is.null(inFile4))
      return(NULL)
    sm <- read.csv(inFile4$datapath, header=F)
    return(sm)
  })

  # Returns model as readmdl()[[1]]
  # Returns semPLS-fit path model object as readmdl()[[2]]
  # reactively read in plsm model and run semPLS 
  # if no SmartPLS .splsm file is made
  # available. Only runs with user-inputted
  # measurement and structural model .csv files.
  readmdl <- reactive({
    out <- list()
    # calls function that returns semPLS-fitted model object
    #model <- plsmdl()
    m.source <- as.character(readmm()[,1])
    m.target <- as.character(readmm()[,2])
    
    s.source <- as.character(readsm()[,1])
    s.target <- as.character(readsm()[,2])
    
    model <- plsm(readd(), 
                  cbind(source=s.source,target=s.target), 
                  cbind(source=m.source,target=m.target), 
                  order= "generic")
    out[[1]] <- model
    # set inner weighting scheme
    # based on user input
    if (input$scheme=="path"){
      wschm <- "C"
    } else if (input$scheme=="factor"){
      wschm <- "B"
    } else wschm <- "A"
    semPLS.fit <- sempls(model, readd(), wscheme=wschm)
    out[[2]] <- semPLS.fit
    # put semPLS.fit as 2st component of output list
    return(out)
  })
  
  # ------------------------------------------------
  # Reactive prime plspm package functions
  
  # reactively fit model using plspm package
  pls <- reactive({
    inFile1 <- input$file1
    if (is.null(inFile1))
      return()
    if (input$lvs==T) {
    plspm.fit <- plspm(readd(),
                       make_inner(modl=readm()[[1]]),
                       make_outer(modl=readm()[[1]],d=readd()),
                       get_modes(modl=readm()[[1]]),
                       scheme=input$scheme,
                       scaled=input$scl,
                       boot.val=input$bval,
                       br=as.numeric(input$boots))
    } else plspm.fit <- plspm(readd(),
                              make_inner(modl=readmdl()[[1]]),
                              make_outer(modl=readmdl()[[1]],d=readd()),
                              get_modes(modl=readmdl()[[1]]),
                              scheme=input$scheme,
                              scaled=input$scl,
                              boot.val=input$bval,
                              br=as.numeric(input$boots))
    return(plspm.fit)
  })
  
  # ---------------------------------------------------------
  # Reactive function to run bootstrapping with replacement
  
  bt <- reactive({
    #set up the bootstrap
    out <- list()
    SamSz <- input$boots
    # read in data
    dat <- readd()
    # read in the model
    mdl <- readm()[[1]]
    # number of manifest variables
    #nrw <- length(model$manifest)
    # n is the number of rows in the dataset
    n <- nrow(readd())
    # set up output matrix, is # col wide
    # and number of resamples deep
    W <- L <- matrix(ncol=length(mdl$manifest),nrow=SamSz)
    #E <- matrix(ncol=length(t(mdl$effects)),nrow=SamSz)
    for (i in 1:SamSz) {
      
      # randomly select the indices
      ndxs <- sample(1:n, size=n, replace = TRUE)
      fit <- plspm(dat[ndxs,],
                   make_inner(modl=readm()[[1]]),
                   make_outer(modl=readm()[[1]],d=dat),
                   get_modes(modl=readm()[[1]]),
                   scheme=input$scheme,
                   scaled=input$scl)
      W[i,] <- fit[[5]]
      L[i,] <- fit[[6]]
      out[[i]] <-fit[[11]]
      out[["calpha"]][i] <- fit[[12]]
      # manipulate direct, indirect and total effects output
      
    }
    W <- as.data.frame(W)
    L <- as.data.frame(L)
   
    colnames(W) <- mdl$manifest
    colnames(L) <- mdl$manifest
   
    out[["Weights"]] <- W
    out[["Loadings"]] <- L
    
    return(out)
    
    # gets se of each row
    #se.R <- numeric(dim(R)[2])
    #for (i in 1:(dim(R)[2])) {
    #  se.R[i] <- sd(R[,i])
   # }
  #out[[2]] <- se.R
  #return(out[[1]])
  })

  # ---------------------------------------------------------
  # Reactive functions that display data in the output tabs
  
  # display read-in data as "Raw Data" tab
  output$contents <- renderTable({
    readd()
  })
  
  
  # --------------------------------------------------------
  # Reactive bootstrap reports functions
  
  output$load <- renderTable({
    return(bt()[["Loadings"]])
  })
  
  output$wgt <- renderTable({
    return(bt()[["Weights"]])
  })
  
  output$drff <- renderTable({
    out <- matrix(nrow=input$boots,ncol=(nrow(bt()[[1]])))
    colnames(out) <- as.character(bt()[[11]][,1])
    for (i in 1:input$boots){
      out[i,] <- bt()[[i]][,2]
    }
    return(out)
  })
  
  output$inff <- renderTable({
    out <- matrix(nrow=input$boots,ncol=(nrow(bt()[[1]])))
    colnames(out) <- as.character(bt()[[11]][,1])
    for (i in 1:input$boots){
      out[i,] <- bt()[[i]][,3]
    }
    return(out)
  })
  
  output$toff <- renderTable({
    out <- matrix(nrow=input$boots,ncol=(nrow(bt()[[1]])))
    colnames(out) <- as.character(bt()[[11]][,1])
    for (i in 1:input$boots){
      out[i,] <- bt()[[i]][,4]
    }
    return(out)
  })
  
  output$calph <- renderTable({
    #out <- matrix(nrow=input$boots,ncol=(nrow(bt()[[1]])))
    #for (i in 1:input$boots){
    #  out[[i]] <- bt()[["calpha"]][i]
    #}
    #return(out[[1]])
  })
  
  # ------------------------------------------------------------
  # Reactive plot functions


 
  # --------------------------------------------------------
  # These functions prepare and handle plots
  # and data summaries for downloading
  
  
  # Reactively collects up the data file reports
  # to download as .CSV when requested in ui.R
  dat <- reactive({
   if (input$downdata=="Outer Weights") {
     return(bt()[["Weights"]])
   } else if (input$downdata=="Outer Loadings") {
     return(bt()[["Loadings"]])
   } else if (input$downdata=="Direct Effects") {
     out <- matrix(nrow=input$boots,ncol=(nrow(bt()[[1]])))
     colnames(out) <- as.character(bt()[[11]][,1])
     for (i in 1:input$boots){
       out[i,] <- bt()[[i]][,2]
     }
     return(out)
   } else if (input$downdata=="Indirect Effects") {
     out <- matrix(nrow=input$boots,ncol=(nrow(bt()[[1]])))
     colnames(out) <- as.character(bt()[[11]][,1])
     for (i in 1:input$boots){
       out[i,] <- bt()[[i]][,3]
     }
     return(out)
   } else if (input$downdata=="Total Effects") {
     out <- matrix(nrow=input$boots,ncol=(nrow(bt()[[1]])))
     colnames(out) <- as.character(bt()[[11]][,1])
     for (i in 1:input$boots){
       out[i,] <- bt()[[i]][,4]
     }
     return(out)
   } else return()
     
  })
  
  
  # Reactively collects up the plots as png files
  # to download when requested in ui.R
  plt <- reactive({
    
  })
  ?write.csv
  # Download Handler for data file report downloads
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$downdata, '-', Sys.Date(), '.csv', sep='')
    },
    content = function(file) {
      write.csv(x=dat(), file)
    })
  
  # Download Handler for png graphic files for plot downloads
  output$downloadPlot <- downloadHandler( 
    filename = function() { paste(input$downplot, '-', Sys.Date(), '.png', sep='') }, 
    content = function(file) { 
      png(file, width=800, height=800) 
      print(plt())
      dev.off() 
    })
})
