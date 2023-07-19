remotes::install_github("dushoff/checkPlots")
library(checkPlotR)
library(dplyr)
library(ggplot2)
library(purrr)

#  generate data
set.seed(7082)
numSims <- 1e4
n <- 100



sd<-4

## normal simulation
datNorm<-map_dfr(c(11,15,22,36), function(mymean){
  map_dfr(1:numSims, function(x){
    data.frame(mu=mymean, t(rnorm(n, mean=mymean, sd)))
  })
})

# binomial simulation
to_checkplot<-map_dfr(c(0.5, 0.75, 0.85, 0.9, 0.97), function(prob){
  dat <- rbinom(numSims, n, prob)
  k<-map_dfr(c("binom.test", "chisq"), function(testv){
    data.frame(multBinom(
      dat = dat, prob = prob, n = n, testv = testv)
      , testv
      , prob)
    
  })
  return(k)
})


# plots

to_checkplot <- to_checkplot %>% 
  mutate(testv=factor(c("Clopper-Pearson exact", "chi squared")[as.numeric(as.factor(testv))]
                      , levels=c("Clopper-Pearson exact", "chi squared")))

pdf("figures/tie_breaking.pdf", height=6, width = 11)
checkPlot(to_checkplot
          , facets = 10)+
  facet_grid(testv~prob, scales="free_y")+
  labs(x="nominal p-value", main = "uniform tie-breaking")+
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,100))+
  theme_classic() + 
  theme(panel.spacing.x = unit(2, "lines"))

to_checkplot_lower <- to_checkplot %>% mutate(p = cp)

checkPlot(to_checkplot_lower
          , facets = 10)+
  facet_grid(testv~prob, scales="free_y")+
  labs(x="nominal p-value", title = "conservative tie-breaking \n(less than)")+
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,100))+
  theme_classic() + 
  theme(panel.spacing.x = unit(2, "lines"))
dev.off()


##########
# do it again with normal data, continuous cdf
normtests<- map_dfr(1:length(datNorm$mu), function(samp){
  p<-t.test(datNorm[samp, -1], mu=datNorm[samp,1], alternative="l")$p.value
  ci<-t.test(datNorm[samp, -1], mu=datNorm[samp,1])
  lower<-ci$conf.int[1]
  upper<-ci$conf.int[2]
  est<-ci$estimate
  return(data.frame(p, lower, upper, est, tm=datNorm[samp,1]))
})

######
# some tests to determine how many reps is nice for checkplots

pdf("figures/norm_22_4.pdf", width=4, height=3)
checkPlot(normtests)+
  theme_classic()
dev.off()

png("figures/example_normal_slugplot_22_4.png", width=4, height=3, units="in", res=650)
rangePlot(normtests, title="slugplot: \nCIs for true mean  based on 100 deviates \nfrom norm(22,4)")
dev.off()

# ne<-normtests %>% mutate(fakemu=tm+3)
# rangePlot(ne)+
#   facet_wrap(~tm, scales="free_y")
# 
# rangePlot(ne, target = "fakemu")+
#   facet_wrap(~tm, scales="free_y")





# print(rangePlot(testaccept, orderFun=blob, opacity=0.02))
# print(rangePlot(testchisq, orderFun=blob, opacity=0.02))
# print(rangePlot(testjd, orderFun=blob, opacity=0.02))
# print(rangePlot(testwald, orderFun=blob, opacity=0.02))