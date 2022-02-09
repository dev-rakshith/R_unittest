#R 3.6.3
#Rtools35
#ggplot 3.0.0
#tembo 2.33.0

#Tembo 2.33.0 link: https://artifactory.intra.infineon.com/artifactory/cran-tembo-local/src/contrib/

install.packages(c("Cairo","IRdisplay","png"))
renv::restore()

packageVersion("ggplot2")
packageVersion("tembo")

find.package("tembo")

View(old.packages())
renv::dependencies()

#----Example Data:----
set.seed(12345)
dat <- data.frame(IVS_28V = c(rnorm(1000),rnorm(1000)+1,rnorm(1000)+2,rnorm(1000)+0.2,rnorm(1000)+1.2,rnorm(1000)+2.2),
                  product_variant = c(rep("200mm",3000),rep("300mm",3000)),
                  cond_tambient = c(rep(-40,1000),rep(25,1000),rep(150,1000),rep(-40,1000),rep(25,1000),rep(150,1000)),
                  stringsAsFactors = FALSE)

dat$IVS_30V = c(rnorm(1000)*0.2,rnorm(1000)*0.2+2,rnorm(1000)*0.2+3,rnorm(1000)*0.2+1.2,rnorm(1000)*0.2+2.2,rnorm(1000)*0.3+3.2)

currentLimits <- data.frame(name = rep("IVS_28V",12), limit_type = c(rep("spec",6),rep("test",6)), 
                            min = rnorm(12,sd=4)-15, max = rnorm(12,sd=4) + 15, cond_tambient = rep(c(-40,25,150),4), 
                            product_variant = c(rep("200mm",3),rep("300mm",3),rep("200mm",3),rep("300mm",3)),
                            stringsAsFactors = FALSE)
currentLimits <- rbind(currentLimits,
                       data.frame(name = rep("IVS_30V",12), limit_type = c(rep("spec",6),rep("test",6)), 
                                  min = rnorm(12,sd=4)-15, max = rnorm(12,sd=4) + 15, cond_tambient = rep(c(-40,25,150),4), 
                                  product_variant = c(rep("200mm",3),rep("300mm",3),rep("200mm",3),rep("300mm",3)),
                                  stringsAsFactors = FALSE))

currentLimits$unit[currentLimits$name=="IVS_28V"] <- "V"
currentLimits$unit[currentLimits$name=="IVS_30V"] <- "V"
currentLimits$scale[currentLimits$name=="IVS_28V"] <- 3
currentLimits$scale[currentLimits$name=="IVS_30V"] <- 3
dat$IVS_28V <- dat$IVS_28V / 10^3
dat$IVS_30V <- dat$IVS_30V / 10^3
currentLimits$min <- currentLimits$min / 10^3
currentLimits$max <- currentLimits$max / 10^3

colnames(dat)


#---- Box Plot----
options(jupyter.plot_mimetypes=c("image/png"))
options(repr.plot.height=4)
options(repr.plot.width=7)


##Default values
xName <- ""
yName <- "cond_tambient"

grouping <- NULL
colour <- NULL

facets <- NULL

xName <- 'product_variant'

currentTemboBoxPlot<-tembo::temboPlot$new()
currentTemboBoxPlot$addData(dat)
currentTemboBoxPlot$addLimits(currentLimits)

currentTemboBoxPlot$plotType<-'boxplot'
if(!is.null(grouping)){
  if(xName!=""){
    grouping <- paste(xName, grouping, sep=",")
  }
}

currentTemboBoxPlot$setAesthetics(x=xName, y=yName, facets=facets, grouping=grouping, colour=colour)
currentTemboBoxPlot$addToPlot(ggplot2::geom_boxplot())
currentTemboBoxPlot$setTitle( 'Histogram' )
currentTemboBoxPlot$setXLabel('Prod_variant')
currentTemboBoxPlot$setYLabel('Count')

currentTemboBoxPlot$show()
pixelAxisMapping<-currentTemboBoxPlot$.pixelAxisMapping
if(exists("currentTableHtml")){
  rm(currentTableHtml)
}

#---XY Plot----
options(jupyter.plot_mimetypes=c("image/png"))
options(repr.plot.height=4)
options(repr.plot.width=7)

currentTemboXYPlot<-tembo::temboPlot$new()
currentTemboXYPlot$addData(dat)
currentTemboXYPlot$addLimits(currentLimits)
currentTemboXYPlot$filterLimits(product_variant)
currentTemboXYPlot$plotType<-'xyplot'

currentTemboXYPlot$setAesthetics( x="product_variant", 
                                  y="IVS_28V",
                                  
                                  grouping="cond_tambient,cond_tambient",
                                  shape="cond_tambient",
                                  colour="cond_tambient",
                                  
)

currentTemboXYPlot$addToPlot(ggplot2::geom_line())
currentTemboXYPlot$addToPlot(ggplot2::geom_point())
currentTemboXYPlot$doLimitHandling()
currentTemboXYPlot$setTitle( 'XY Plot' )

currentTemboXYPlot$show()
pixelAxisMapping<-currentTemboXYPlot$.pixelAxisMapping
if(exists("currentTableHtml")){
  rm(currentTableHtml)
}


#----Downgrade dependency package version----
packageVersion("ggplot2")
devtools::unload("ggplot2")

find.package("ggplot2")
packageVersion("ggplot2")

#Negotiate commit history
renv::history()

#If older version is associated with this commit(3.0.0)
renv::revert(commit="fec757cee728802800bac382e055f79a4b2f4a1d")
renv::restore()

#Version downgraded
packageVersion("ggplot2")


#Save the histogram plot
png("tests/XY_3.0.0.png")
currentTemboXYPlot$show()
Sys.sleep(5)
#Pause for 5seconds
dev.off()
dev.off()

#Save the box plot
png("tests/boxplot_3.0.0.png")
currentTemboBoxPlot$show()
Sys.sleep(5)
#Pause for 5seconds
dev.off()

#If newer version is associated with this commit(3.3.5)
#Restore the environment
renv::revert(commit="e1900161bc1f581139ea152cabdbc0e71dd46e9b")
renv::restore()

#Version upgraded
packageVersion("ggplot2")

#After upgrading to ggplot 3.3.5, run the scripts for XYplot & boxplot again

#Save the XY plot
png("tests/XY_3.3.5.png")
currentTemboXYPlot$show()
Sys.sleep(5)
#Pause for 5seconds
dev.off()

#Save the box plot
png("tests/boxplot_3.3.5.png")
currentTemboBoxPlot$show()
#Pause for 5seconds
Sys.sleep(5)
dev.off()

#----Test----
testthat::test_that("Both plots sharing same data'",{
  testthat::expect_false(ggplot2::is.ggplot(currentTemboXYPlot$.self))
  testthat::expect_identical(currentTemboXYPlot$data, currentTemboBoxPlot$data)
})

#devtools::install_github("MangoTheCat/visualTest")

#Histogram created from different versions of "ggplot2" are similar.
visualTest::getFingerprint(file = "tests/XY_3.0.0.png")
visualTest::getFingerprint(file = "tests/XY_3.3.5.png")

visualTest::isSimilar(file = "tests/XY_3.3.5.png",
                      fingerprint = visualTest::getFingerprint(file = "tests/XY_3.0.0.png"),
                      threshold = 0.1
)

#Boxplot created from different versions of "ggplot2" are similar.
visualTest::getFingerprint(file = "tests/boxplot_3.0.0.png")
visualTest::getFingerprint(file = "tests/boxplot_3.3.5.png")

visualTest::isSimilar(file = "tests/boxplot_3.3.5.png",
                      fingerprint = visualTest::getFingerprint(file = "tests/boxplot_3.0.0.png"),
                      threshold = 0.1
)

#Boxplot generated in different versions of ggplo2 are giving similar output.
#But XY plot objects, from different versions of ggplot2, are not similar.




