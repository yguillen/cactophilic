
# Libraries required
install.packages("ggplot2")
install.packages("relaimpo")
install.packages("plyr")

library(ggplot)
library(relaimpo)
library(plyr)

#need non-US version relaimpo downloaded from 
#https://prof.beuth-hochschule.de/groemping/software/


### Data ###

#### Data table divergence_table.csv:
# Columns #
  # parameter: dn, ds or omega
  # chr: Chromosome 
  # position: bp position in Drosophila mojavensis 
  # value: value of dn, ds or omega
  # length: Protein lenght (in aminoacids) in Drosophila buzzatii genome
  # Exons: Number of exons in Drosophila buzzatii genome
  # FBgn: Flybase gene ID
  # FBpp: Flybase protein ID
  # state: Gene located within a rearranged (1) or non-rearranged (0) segment considering fixed inversions
  # recomb: Gene located within non-recombining chromosome 6 and 3-Mb centromeric region (1) or in regions with presumably normal levels of recombination (0)
  # type: X-linked (1) or autosomal (0) region
  # breadth: Number of life stages (0-5) in which each gene is expressed using a minimu FPKM threshold of 1
  # normexp: Maximum FPKM value observed across 5 life stages.

#### Data table divergence_window_100kb_table.csv:
# Columns #
# Position: bp position in Drosophila mojavensis 
# Chr: Chromosome 
# variable: dn, ds or omega
# value: value of dn, ds or omega

### ------------------------------------------------- ###

#import datasets
data_divergence<-read.delim("/Users/yolanda_guillen/Documents/Paper_PhD/Journal_of_Heredity/divergence_table.csv",sep=",",header=TRUE)
data_window_divergence<-read.delim("/Users/yolanda_guillen/Documents/Paper_PhD/Journal_of_Heredity/divergence_window_100kb_table.csv",sep=",",header=TRUE)

### ------------------------------------------------- ###

##### LINEAR REGRESSION MODELS ###
### including correlation coefficients ##

#For dn parameter
dn_expression<-subset(data_divergence,data_divergence$parameter=="dn")
# data table with info of dn 9017 genes --> dn_expression
modelo_dn_expression<-lm(formula = dn_expression$value ~ dn_expression$type + dn_expression$recomb +
     dn_expression$state + dn_expression$length + dn_expression$exons +
     dn_expression$breadth + dn_expression$normexp)
summary(modelo_dn_expression,correlation=TRUE)

#For ds parameter
ds_expression<-subset(data_divergence,data_divergence$parameter=="ds")
# data table with info of ds 9017 genes --> ds_expression
modelo_ds_expression<-lm(formula = ds_expression$value ~ ds_expression$type + ds_expression$recomb +
     ds_expression$state + ds_expression$length + ds_expression$exons +
     ds_expression$breadth + ds_expression$normexp)
summary(modelo_ds_expression,correlation=TRUE)

#For omega parameter
omega_expression<-subset(data_divergence,data_divergence$parameter=="omega")
# data table with info of omega 9017 genes --> omega_expression
modelo_omega_expression<-lm(formula = omega_expression$value ~ omega_expression$type +
     omega_expression$recomb + omega_expression$state + omega_expression$length +
     omega_expression$exons + omega_expression$breadth + omega_expression$normexp)
summary(modelo_omega_expression,correlation=TRUE)

### ------------------------------------------------- ###

## RELATIVE IMPORTANCE ##
calc.relimp(object = modelo_dn_expression,type = "pmvd")

### ------------------------------------------------- ###

#### Plots for dn, ds and omega accross 6 chromosomes in non-overlapping 100 kb windows ####


#Melt data
data_window_divergence<-melt(data_window_divergence,id.vars = c("Position","Chr"))

## GGPLOTS ##

#Removing outliers for plots
data_window_divergence_noout<-subset(data_window_divergence,data_window_divergence$value<=2)

ggplot(data_window_divergence_noout,aes(x=Position/1000000,y=value))+
  geom_point(aes(color=variable),size=1.5) + 
  facet_grid(variable~Chr,scales="free")+
  xlab("Genome position (Mb)")+
  ylab("")+
  theme(legend.position="none")+
  theme(axis.text.y = element_blank(),axis.text.x = element_blank())
