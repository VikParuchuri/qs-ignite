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

load_or_install(c("ggplot2","stringr","foreach","wordcloud","lsa","MASS","openNLP","tm","fastmatch","reshape","openNLPmodels.en",'e1071','gridExtra', 'XLConnect', 'reshape', 'plyr', 'RColorBrewer', 'rjson'))

happiness = read.csv("happsee_data.csv", stringsAsFactors=FALSE)
happiness$created = as.Date(happiness$created, "%Y-%m-%d %H:%M:%S")

p <- ggplot(happiness, aes(x=created,y=score))
p = p + geom_smooth(n=2000)
p

long_pairs = apply(happiness, 1, function(x){
  if(!is.na(x["longitude"])){
    as.vector(x[c("longitude", "latitude", "score")])
  }
})

long_pairs = long_pairs[!sapply(long_pairs, is.null)]
json = toJSON(long_pairs)

p <- ggplot(happiness, aes(x=created,y=score))
p = p + geom_smooth(n=2000)
p

negative_moods = c("Uncertain", "Tired", "Stressed", "Bored")
positive_moods = c("Energetic", "Relaxed", "Engaged", "Confident")
moods = c(negative_moods, positive_moods)
mood_data = happiness[,c(moods "created")]
mood_data[,moods][mood_data[,moods] == "Yes"] = 10
mood_data[,moods][mood_data[,moods] == ""] = 0
mood_data[,moods] = apply(mood_data[,moods],2,function(x){ as.numeric(x)})

mood_data_short <- melt(mood_data[,c(negative_moods, "created")], id="created")  # convert to long format

ggplot(data=mood_data_short,
       aes(x=created, y=value, colour=variable)) +
  geom_smooth(se=FALSE, size=2) +   theme(
                                          panel.grid.minor = element_blank(),
                                          panel.border = element_blank(),
                                          axis.title.x = element_blank(),
                                          axis.title.y = element_blank()) 

mood_data_short <- melt(mood_data[,c(positive_moods, "created")], id="created")  # convert to long format

ggplot(data=mood_data_short,
       aes(x=created, y=value, colour=variable)) +
  geom_smooth(se=FALSE, size=2) +   theme(
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank()) 