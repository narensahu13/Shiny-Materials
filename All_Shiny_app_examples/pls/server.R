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
    data <- read.csv(inFile1$datapath, 
                     header=input$header,
                     sep=input$sep)
    return(data)
  })
  
  output$columns <- renderUI({
    inFile1 <- input$file1
    if (is.null(inFile1))
      return(NULL)
    dat = read.csv(inFile1$datapath, 
                   header=input$header,
                   sep=input$sep)
    selectInput("grp", "Select a grouping variable with 2 levels:", 
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
  
  # reactively computes group difference summary 
  # with quasi-parametric t-test approach and barplot
  # and outputs as grpdb()[[1]] and grpdb()[[2]]
  grpdb <- reactive({
    out <- list()
    if (input$groups==F) return()
    pls=pls()
    group=as.factor(as.character(readd()[,as.character(input$grp)]))
    method="bootstrap"
    group.fit <- plspm.groups(pls,group,method,rep=as.numeric(input$boots))
    out[[1]] <- group.fit$test
    
    return(out)
  })
  
  # reactively computes group difference summary 
  # with quasi-parametric t-test approach and barplot
  # and outputs as grpdb()[[1]] and grpdb()[[2]]
  grpdp <- reactive({
    out <- list()
    if (input$groups==F) return()
    pls=pls()
    group=as.factor(as.character(readd()[,as.character(input$grp)]))
    method="permutation"
    group.fit <- plspm.groups(pls,group,method,rep=as.numeric(input$boots))
    out[[1]] <- group.fit$test
    
    return(out)
  })
  

  # ---------------------------------------------------------
  # Reactive functions that display data in the output tabs
  
  # display read-in data as "Raw Data" tab
  output$contents <- renderTable({
    readd()
  })
  
  # -------------------------------------------------
  # Reactive functions that compute summary output and
  # various data reports from PLS path modeling estimates
               
  # summarizes overview and computes
  # dimensionality with eigenvalues as output$inner
  output$inners <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else
    one=pls()$inner.sum
    two=pls()$unidim
    it=cbind(one[,1],two[,1:2],round(one[,4:7],3),round(two[,3:6],3))
    it <- it[c(2,1,3,4,7,8:9,5:6,10:11)]
    colnames(it)[1] <- "LV Mode"
    colnames(it)[2] <- "LV Type"
    colnames(it)[6] <- "Cron Alpha"
    colnames(it)[4] <- "R-Squared"
    colnames(it)[7] <- "DG Rho"
    colnames(it)[8] <- "Ave Comm"
    colnames(it)[9] <- "Ave Redun"
    colnames(it)[10] <- "1st Eigen"
    colnames(it)[11] <- "2nd Eigen"
    return(it)
  })
  
  # computes weights and loadings summary as output$wl
  output$outerm <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else
    wl <- do.call(rbind,pls()$outer.mod)
    colnames(wl) <- c("Weights","Loadings","Communality","Redundancy")
    return(wl)
  })
  
  # LV cross-correlations with square root of AVE in diagonal
  output$lvcor <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else
    lv.cor <- round(cor(pls()$latents),3)
    diag(lv.cor) <- (pls()$inner.sum["AVE"]^.5)
    return(lv.cor)
  })
  
  # computes loadings and cross loadings summary as output$outerc
  output$outerc <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else
    xl <- do.call(rbind,pls()$outer.cor)
    return(xl)
  })
  
  # direct and indirect effects
  output$eff <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else
    effs <- pls()$effects
    colnames(effs) <- c("Path Relationships",
                        "Direct Effects",
                        "Indirect Effects",
                        "Total Effects")
    return(effs)
  })
  
  # output scaled latent variable scores
  output$outlvs <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else
      latents <- pls()$latents
    return(latents)
  })
  
  # output latent variable scores if scaling is set to FALSE
  output$outulvs <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else
      scores <- pls()$scores
    return(scores)
  })
  
  # computes group difference summary with permutation
  # approach and output as output$groupdp
  output$groupdp <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if (input$groups==F) {
      return()
    } else if (input$groups==T){
    out <- grpdp()[[1]]
    colnames(out) <- c("Global Coefficient",
                       "1st Group",
                       "2nd Group",
                       "Absolute Difference",
                       "One-tailed t-test",
                       "Degrees of Freedom",
                       "p-value",
                       "Significant at 5%?")
    return(out)
    } else return()
  })
  
  # computes group difference summary with quasi-parametric
  # t-test approach and output as output$groupdb; 
  output$groupdb <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if (input$groups==F) {
      return()
    } else if (input$groups==T){
    out <- grpdb()[[1]]
    colnames(out) <- c("Global Coefficient",
                       "1st Group",
                       "2nd Group",
                       "Absolute Difference",
                       "One-tailed t-test",
                       "Degrees of Freedom",
                       "p-value",
                       "Significant at 5%?")
    return(out)
    } else return()
  })
  
  # --------------------------------------------------------
  # Reactive bootstrap reports functions
  
  
  # computes and returns bootstrap path coef CIs
  output$paths <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if (input$bval==T){
    pathCIs <- pls()$boot[[3]]
    colnames(pathCIs) <- c("Original Value",
                           "Mean Bootstrap",
                           "Standard Error",
                           "Lower 2.5%",
                           "Upper 97.5%")
    return(pathCIs)
    } else return()
  })
  
  # computes and returns bootstrap effects CIs
  output$effects <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if (input$bval==T){
    eff <- pls()$boot[[5]]
    colnames(eff) <- c("Original Value",
                       "Mean Bootstrap",
                       "Standard Error",
                       "Lower 2.5%",
                       "Upper 97.5%")
    return(eff)
    } else return()
  })
  
  # computes and returns bootstrap R-Square CIs
  output$rsq <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if (input$bval==T){
    rs <- pls()$boot[[4]]
    colnames(rs) <- c("Original Value",
                      "Mean Bootstrap",
                      "Standard Error",
                      "Lower 2.5%",
                      "Upper 97.5%")
    return(rs)
    } else return()
  })
  
  # computes and returns bootstrap outer loading CIs
  output$loads <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if (input$bval==T){
    outl <- pls()$boot[[2]]
    colnames(outl) <- c("Original Value",
                        "Mean Bootstrap",
                        "Standard Error",
                        "Lower 2.5%",
                        "Upper 97.5%")
    return(outl)
    } else return()
  })
  
  # computes and returns bootstrapped weight CIs
  output$weights <- renderTable({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if (input$bval==T){
    wght <- pls()$boot[[1]]
    colnames(wght) <- c("Original Value",
                        "Mean Bootstrap",
                        "Standard Error",
                        "Lower 2.5%",
                        "Upper 97.5%")
    return(wght)
    } else return()
  })
  
  # ------------------------------------------------------------
  # Reactive plot functions
  
  # plot path coefficients in inner model
  output$plotinner <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else
    plot(pls(), box.prop = 0.55, box.size = 0.10, box.cex = 1.5,
         box.col = "cadetblue1", lcol = "black",
         txt.col = "black", arr.pos = 0.5, cex.txt = 1.5)
  })
  
  # plot loadings in outer model
  output$plotload <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else
    plot(pls(), what="loadings", box.prop = 0.55, box.size = 0.10, box.cex = 1.5,
         box.col = "cadetblue1", lcol = "black",
         txt.col = "black", arr.pos = 0.5, cex.txt = 1.5)
  })
  
  # plot weights in outer model
  output$plotweight <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else
    plot(pls(), what="weights", box.prop = 0.55, box.size = 0.10, box.cex = 1.5,
         box.col = "cadetblue1", lcol = "black",
         txt.col = "black", arr.pos = 0.5, cex.txt = 1.5)
  })
  
  # standard scatterplot lv pairs in inner model
  output$lvplot1 <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else
      plot(splom(pls()[[3]]))
                
  })
  
  # augmented scatterplot matrix lv pairs in inner model
  output$lvplot2 <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else
      plot(splom(pls()[[3]],
                 panel=panel.hexbinplot,
                 colramp=BTC,
                 diag.panel = function(x, ...){
                   yrng <- current.panel.limits()$ylim
                   d <- density(x, na.rm=TRUE)
                   d$y <- with(d, yrng[1] + 0.95 * diff(yrng) * y / max(y) )
                   panel.lines(d)
                   diag.panel.splom(x, ...)
                 },
                 lower.panel = function(x, y, ...){
                   panel.hexbinplot(x, y, ...)
                   panel.loess(x, y, ..., col = 'red')
                 },
                 pscale=0, varname.cex=0.7
      ))
  })
  
  output$effplot <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else
      fit1 <- plspm(readd(),make.inner(modl=model),
                        make.outer(modl=model,d=readd()),
                        get.modes(modl=model),
                        scheme=input$scheme)
    
    path_effs <- as.matrix(fit1$effects[,1:3])
    rownames(path_effs) <- path_effs[, 1]
    path_effs <- path_effs[,-1]
    
    # setting margin size
    op = par(mar = c(8, 3, 1, 0.5))
    # barplots of total effects (direct + indirect)
    barplot(t(path_effs), 
            border = NA, col = c("#9E9AC8", "#DADAEB"),
            las = 2, cex.names = 0.8, cex.axis = 0.8, 
            legend = c("Direct","Indirect"), 
            args.legend = list(x = "top", 
                               ncol = 2, 
                               border = NA, 
                               bty = "n", 
                               title = " "))
    
    # resetting default margins
    par(op)
  })
  
  output$grpdbplot <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else if (input$groups==F) {
      return()
    } else if (input$groups==T){
    # path coefficients between group 1 and group 1
    barplot(t(as.matrix(grpdb()[[1]][, 2:3])), 
                        border = NA, beside = TRUE,
                        col = c("#FEB24C", "#74A9CF"), 
                        las = 2, ylim = c(-0.1, 1), 
                        cex.names = 0.8, col.axis = "gray30", 
                        cex.axis = 0.8)
    
    # add horizontal line
    abline(h = 0, col = "gray50")
    
    # add title
    title("Path coefficients of Group 1 and Group 2", 
          cex.main = 0.95,
          col.main = "gray30")
    
    # add legend
    legend("top", legend = c("group 1", "group 2"), pt.bg = c("#FEB24C", "#A6BDDB"),
           ncol = 2, pch = 22, col = c("#FEB24C", "#74A9CF"), bty = "n",
           text.col = "gray40")
    } else return()

  })
  
  output$hierplot <- renderPlot({
    # hierarchical cluster analysis of LV scores
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else
    hclus.plot = hclust(dist(pls()$latents), 
                       method = "ward")
    
    # plot dendrogram
    plot(hclus.plot, xlab = "", 
         sub = "", cex = 0.5)
    
  })
  
  # plots evolution of outer weights
  output$weightsevol <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else if (input$lvs==T){
      plot(readm()[[2]])
    } else plot(readmdl()[[2]])
  })
  
  # density plot of factor scores
  output$densplotf <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else if (input$lvs==T){
      latent.variables <- readm()[[2]]
      plot(densityplot(latent.variables,use="fscores"))
    } else 
      latent.variables <- readmdl()[[2]]
      plot(densityplot(latent.variables,use="fscores"))
  })
  
  # density plot of predictions
  output$densplotp <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else if (input$lvs==T){
      latent.variables <- readm()[[2]]
      plot(densityplot(latent.variables,use="prediction"))
    } else
      latent.variables <- readmdl()[[2]]
      plot(densityplot(latent.variables,use="prediction"))
  })
  
  # density plot of residuals
  output$densplotr <- renderPlot({
    if (is.null(input$file1)) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file3))) {
      return()
    } else if ((is.null(input$file2)) & (is.null(input$file4))) {
      return()
    } else if ((is.null(input$file4)) & (input$lvs==F)) {
      return()
    } else if ((is.null(input$file3)) & (input$lvs==F)) {
      return()
    } else if (input$lvs==T){
      latent.variables <- readm()[[2]]
      plot(densityplot(latent.variables,use="residuals"))
    } else 
      latent.variables <- readmdl()[[2]]
      plot(densityplot(latent.variables,use="residuals"))
  })
  
  # --------------------------------------------------------
  # These functions prepare and handle plots
  # and data summaries for downloading
  
  
  # Reactively collects up the data file reports
  # to download as .CSV when requested in ui.R
  dat <- reactive({
    if (input$downdata=="LV Overview") {
      one=pls()$inner.sum
      two=pls()$unidim
      it=cbind(one[,1],two[,1:2],round(one[,4:7],3),round(two[,3:6],3))
      it <- it[c(2,1,3,4,7,8:9,5:6,10:11)]
      colnames(it)[1] <- "LV Mode"
      colnames(it)[2] <- "LV Type"
      colnames(it)[6] <- "Cron Alpha"
      colnames(it)[4] <- "R-Squared"
      colnames(it)[7] <- "DG Rho"
      colnames(it)[8] <- "Ave Comm"
      colnames(it)[9] <- "Ave Redun"
      colnames(it)[10] <- "1st Eigen"
      colnames(it)[11] <- "2nd Eigen"
      return(it)
    } else if (input$downdata=="LV Cross Correlation Matrix") {
      lv.cor <- round(cor(pls()$latents),3)
      diag(lv.cor) <- (pls()$inner.sum["AVE"]^.5)
      return(lv.cor)
    } else if (input$downdata=="Loadings and Cross Loadings") {
      xl <- do.call(rbind,pls()$outer.cor)
      return(xl)
    } else if (input$downdata=="Direct, Indirect, and Total Effects") {
      effs <- pls()$effects
      colnames(effs) <- c("Path Relationships",
                          "Direct Effects",
                          "Indirect Effects",
                          "Total Effects")
      return(effs)
    } else if (input$downdata=="Latent Variable Scores") {
      latents <- pls()$latents
      return(latents)
    } else if (input$downdata=="Unscaled Latent Variable Scores") {
      scores <- pls()$scores
      return(scores)
    } else if (input$downdata=="Group Differences Permutation") {
      if (input$groups==F) return(NULL)
      out <- grpdp()[[1]]
      colnames(out) <- c("Global Coefficient",
                         "1st Group",
                         "2nd Group",
                         "Absolute Difference",
                         "One-tailed t-test",
                         "Degrees of Freedom",
                         "p-value",
                         "Significant at 5%?")
      return(out)
    } else if (input$downdata=="Group Differences Parametric") {
      if (input$groups==F) return(NULL)
      out <- grpdb()[[1]]
      colnames(out) <- c("Global Coefficient",
                         "1st Group",
                         "2nd Group",
                         "Absolute Difference",
                         "One-tailed t-test",
                         "Degrees of Freedom",
                         "p-value",
                         "Significant at 5%?")
      return(out)
    } else if (input$downdata=="Bootstrap: Path Model CIs") {
      pathCIs <- pls()$boot[[3]]
      colnames(pathCIs) <- c("Original Value",
                             "Mean Bootstrap",
                             "Standard Error",
                             "Lower 2.5%",
                             "Upper 97.5%")
      return(pathCIs)
    } else if (input$downdata=="Bootstrap: Loading CIs") {
      outl <- pls()$boot[[2]]
      colnames(outl) <- c("Original Value",
                          "Mean Bootstrap",
                          "Standard Error",
                          "Lower 2.5%",
                          "Upper 97.5%")
      return(outl)
    } else if (input$downdata=="Bootstrap: Weight CIs") {
      wght <- pls()$boot[[1]]
      colnames(wght) <- c("Original Value",
                          "Mean Bootstrap",
                          "Standard Error",
                          "Lower 2.5%",
                          "Upper 97.5%")
      return(wght)
    } else if (input$downdata=="Bootstrap: Effect CIs") {
      eff <- pls()$boot[[5]]
      colnames(eff) <- c("Original Value",
                         "Mean Bootstrap",
                         "Standard Error",
                         "Lower 2.5%",
                         "Upper 97.5%")
      return(eff)
    } else if (input$downdata=="Bootstrap: R-Squared CIs") {
      rs <- pls()$boot[[4]]
      colnames(rs) <- c("Original Value",
                        "Mean Bootstrap",
                        "Standard Error",
                        "Lower 2.5%",
                        "Upper 97.5%")
      return(rs)
    } else 
      wl <- do.call(rbind,pls()$outer.mod)
      colnames(wl) <- c("Weights","Loadings","Communality","Redundancy")
      return(wl)
  })
  
  
  # Reactively collects up the plots as png files
  # to download when requested in ui.R
  plt <- reactive({
    if (input$downplot=="Path Model Plot") {
      graph <- plot(pls(), box.prop = 0.55, box.size = 0.10, box.cex = 1.5,
                    box.col = "cadetblue1", lcol = "black",
                    txt.col = "black", arr.pos = 0.5, cex.txt = 1.5)
    } else if (input$downplot=="Outer Loadings Plot") {
      graph <- plot(pls(), what="loadings", box.prop = 0.55, box.size = 0.10, box.cex = 1.5,
                    box.col = "cadetblue1", lcol = "black",
                    txt.col = "black", arr.pos = 0.5, cex.txt = 1.5)
    } else if (input$downplot=="Outer Weights Plot") {
      graph <- plot(pls(), what="weights", box.prop = 0.55, box.size = 0.10, box.cex = 1.5,
                    box.col = "cadetblue1", lcol = "black",
                    txt.col = "black", arr.pos = 0.5, cex.txt = 1.5)
    } else if (input$downplot=="Standard Scatterplot: LV Scores") {
      graph <- plot(splom(pls()[[3]]))
    } else if (input$downplot=="Augmented Scatterplot: LV Scores") {
      graph <- plot(splom(pls()[[3]],
                          panel=panel.hexbinplot,
                          colramp=BTC,
                          diag.panel = function(x, ...){
                            yrng <- current.panel.limits()$ylim
                            d <- density(x, na.rm=TRUE)
                            d$y <- with(d, yrng[1] + 0.95 * diff(yrng) * y / max(y) )
                            panel.lines(d)
                            diag.panel.splom(x, ...)
                          },
                          lower.panel = function(x, y, ...){
                            panel.hexbinplot(x, y, ...)
                            panel.loess(x, y, ..., col = 'red')
                          },
                          pscale=0, varname.cex=0.7))
    } else if (input$downplot=="Path Group Differences Plot") {
      graph <- groupbar()
    } else if (input$downplot=="Hierarchical Cluster Analysis Plot") {
      hclus.plot = hclust(dist(pls()$latents), method = "ward")
      graph <- plot(hclus.plot, xlab = "Record Identifiers", sub = "", cex = 0.8)
    } else if ((input$downplot=="Outer Weights Evolution Plot")&(input$lvs==T)) {
      latent.variables <- readm()[[2]]
      graph <- plot(latent.variables)
    } else if ((input$downplot=="Outer Weights Evolution Plot")&(input$lvs==F)) {
      latent.variables <- readmdl()[[2]]
      graph <- plot(latent.variables)
    } else if ((input$downplot=="LV Scores Plot")&(input$lvs==T)) {
      latent.variables <- readm()[[2]]
      graph <- plot(densityplot(latent.variables,use="fscores"))
    } else if ((input$downplot=="LV Scores Plot")&(input$lvs==F)) {
      latent.variables <- readmdl()[[2]]
      graph <- plot(densityplot(latent.variables,use="fscores"))
    } else if ((input$downplot=="LV Predictions Plot")&(input$lvs==T)) {
      latent.variables <- readm()[[2]]
      graph <- plot(densityplot(latent.variables,use="prediction"))
    } else if ((input$downplot=="LV Predictions Plot")&(input$lvs==F)) {
      latent.variables <- readmdl()[[2]]
      graph <- plot(densityplot(latent.variables,use="prediction"))
    } else  if (input$lvs==T) {
      latent.variables <- readm()[[2]]
      graph <- plot(densityplot(latent.variables,use="residuals"))
    } else {
      latent.variables <- readmdl()[[2]]
      graph <- plot(densityplot(latent.variables,use="residuals"))
    }
    return(graph)
  })
  
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
