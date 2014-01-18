setwd("~/vikparuchuri/qs-ignite/scripts")

is_installed <- function(mypkg) is.element(mypkg, installed.packages()[,1])

load_or_install<-function(package_names)
{
  for(package_name in package_names)
  {
    if(!is_installed(package_name))
    {
      install.packages(package_name,repos="http://lib.stat.cmu.edu/R/CRAN")
    }
    options(java.parameters = "-Xmx8g")
    library(package_name,character.only=TRUE,quietly=TRUE,verbose=FALSE)
  }
}

rename_col <- function(old, new, frame){
  for(i in 1:length(old)){
    names(frame)[names(frame) == old[i]] = new[i]
  }
  frame
}

load_or_install(c("ggplot2","stringr","foreach","wordcloud","lsa","MASS","openNLP","tm","fastmatch","reshape","openNLPmodels.en",'e1071','gridExtra', 'XLConnect', 'reshape', 'plyr', 'RColorBrewer'))


