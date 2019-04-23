function(){
  tabPanel("About this PLS Path Modeling Application",
           p(style="text-align:justify",'This online application was developed to assist PLS Path Modelers access the PLS path modeling 
             functions resident in R software, but in a more user-friendly way than the R console allows. We will develop a visual GUI interface to specify and draw your path model after we build out more of the path modeling functionality 
             for this online application. This functionality draws largely from the plspm and semPLS packages in R (see Reference Documentation below). Currently, the best means to input your path model is to use the popular 
             ',a("SmartPLS", href="http://SmartPLS.de/", target="_blank"),'path modeling tool and save your model (.splsm) file which can be directly uploaded into this application. Alternatively, one can directly upload two simple .csv files
             that separately specify: (1) your measurement model; and (2) your structural model. Please see the semPLS package documentation and examples of measure.csv and stucture.csv files provided with the materials for this application. '),
           p(style="text-align:justify",'However, because the application has been developed using the ',a("Shiny", href="http://www.rstudio.com/shiny/", target="_blank"),'package and ',a("R software", href="http://r-project.org/", target="_blank"),' 
             the mathematical extensibility is virtually unlimited. We hope that you find this online tool useful for your path modeling purposes !'),
           br(),
           
           HTML('<div style="clear: left;"><img src="Hubona-small-jpeg.jpg" alt="" style="float: left; margin-right:5px" /></div>'),
           strong('Author and Application Developer'),
           p('Dr. Geoffrey Hubona',br(),
             'Online Educator | PLS Path Modeler | R Enthusiast',br(),
             a('SEM-n-R Co-founder', href="http://sem-n-r.com/", target="_blank"),
             '|',
             a('About SEM-n-R', href="http://www.sem-n-r.com/About_Us.html", target="_blank")
           ),
           br(),
           
           div(class="row-fluid",
              # div(class="span3",strong('Other app versions'),
             #      p(HTML('<ul>'),
              #       HTML('<li>'),a("Version 1", href="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", target="_blank"),HTML('</li>'),
             #        HTML('<li>'),a("Version 2", href="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", target="_blank"),HTML('</li>'),
             #        HTML('<li>'),a("Version 3", href="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", target="_blank"),HTML('</li>'),
             #        HTML('</ul>')),
             #      strong('Code'),
            #       p('Source code available at',
            #         a('GitHub', href='https://github.com/ua-snap/shiny-apps/tree/master/RVdistsExampleAppV4')),
            #       br()
            #   ),
               
               div(class="span3", strong('SEM-n-R Principals'),
                   p(HTML('<ul>'),
                     HTML('<li>'),a("Dr. Geoffrey S. Hubona", href="http://tinyurl.com/mahd5j2/", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a("Dr. Christian M. Ringle", href="http://www.tuhh.de/hrmo/team/prof-dr-c-m-ringle.html", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a("Dr. Jorg Henseler", href="http://www.henseler.com/", target="_blank"),HTML('</li>'),
                     HTML('</ul>')),
                   br()
               ),
               
               div(class="span3", strong('Educational Resources'),
                   p(HTML('<ul>'),
                     HTML('<li>'),a("SEM-n-R Online", href="http://www.sem-n-r.com/", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a("PLS School (not online)", href="http://www.pls-sem.com/", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a("The Georgia R School Online", href="http://georgia-r-school.org/", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a("R-Data Mining Online", href="http://r-datamining.org/", target="_blank"),HTML('</li>'),
                     HTML('</ul>')),
                   br()
               ),
               
               div(class="span3",
                   strong('Reference Documentation'),
                   p(HTML('<ul>'),
                     HTML('<li>'),a('SmartPLS', href="http://SmartPLS.de", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a('A Primer on Partial Least Squares Structural Equation Modeling (PLS-SEM)', href="http://www.pls-sem.com/", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a('Handbook of Partial Least Squares', href="http://tinyurl.com/mculnnl", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a('PLS Path Modeling with R (free eBook)', href="http://tinyurl.com/nvjhnat", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a('plspm package in R', href="http://cran.r-project.org/web/packages/plspm/index.html", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a('semPLS package in R', href="http://cran.r-project.org/web/packages/semPLS/index.html", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a("shiny package in R", href="http://www.rstudio.com/shiny/", target="_blank"),HTML('</li>'),
                     HTML('<li>'),a('The R Project', href="http://www.r-project.org/", target="_blank"),HTML('</li>'),
                     HTML('</ul>'))
               )
           )
           )
}