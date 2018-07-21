
# libraries required
install.packages("tidyverse")
install.packages("qgraph")
library(tidyverse)
library(qgraph)

#Data values

data=data.frame(
  individual=c('1.47',	'2.33',	'0.9',
               '0.36',	'9.31',	'0.09',
               '0.02',	'0.66',	'0',
               '0.4',	'22.95',	'8.08',
               '25.15',	'46.6',	'14.37',
               '72.58',	'16',	'76.49',
               '0.02',	'2.15',	'0.07'),
  group=c( rep('A', 3), rep('B', 3), rep('C', 3), 
           rep('D', 3), rep('E', 3), rep('F', 3), rep('G', 3)) ,
  value=c(1.47,	2.33,	0.9,
          0.36,	9.31,	0.09,
          0.02,	0.66,	0,
          0.4,	22.95,	8.08,
          25.15,	46.6,	14.37,
          72.58,	16,	76.49,
          0.02,	2.15,	0.07)
)

# Set a number of 'empty bar' to add at the end of each group
empty_bar=3
to_add = data.frame( matrix(NA, empty_bar*nlevels(data$group), ncol(data)) )
colnames(to_add) = colnames(data)
to_add$group=rep(levels(data$group), each=empty_bar)
data=rbind(data, to_add)
data=data %>% arrange(group)
data$id=seq(1, nrow(data))

# Get the name and the y position of each label
label_data=data
number_of_bar=nrow(label_data)
angle= 90 - 360 * (label_data$id-0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)
label_data$hjust<-ifelse( angle < -90, 1, 0)
label_data$angle<-ifelse(angle < -90, angle+180, angle)

# prepare a data frame for base lines
base_data=data %>% 
  group_by(group) %>% 
  summarize(start=min(id), end=max(id) - empty_bar) %>% 
  rowwise() %>% 
  mutate(title=mean(c(start, end)))

# prepare a data frame for grid (scales)
grid_data = base_data
grid_data$end = grid_data$end[ c( nrow(grid_data), 1:nrow(grid_data)-1)] + 1
grid_data$start = grid_data$start - 1
grid_data=grid_data[-1,]

# Make the plot
svg(file="Figure3_circular.svg")
p = ggplot(data, aes(x=as.factor(id), y=value, fill=group)) +       # Note that id is a factor. If x is numeric, there is some space between the first bar
  
  geom_bar(aes(x=as.factor(id), y=value, fill=group), stat="identity", alpha=0.5) +
  
  # Add a val=100/75/50/25 lines. I do it at the beginning to make sur barplots are OVER it.
  geom_segment(data=grid_data, aes(x = end, y = 80, xend = start, yend = 80), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 60, xend = start, yend = 60), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 40, xend = start, yend = 40), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 20, xend = start, yend = 20), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  
  # Add text showing the value of each 100/75/50/25 lines
  annotate("text", x = rep(max(data$id),4), y = c(20, 40, 60, 80), label = c("20", "40", "60", "80") , color="grey", size=3 , angle=0, fontface="bold", hjust=1) +
  
  geom_bar(aes(x=as.factor(id), y=value, fill=group), stat="identity", alpha=0.5) +
  ylim(-100,120) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.margin = unit(rep(-1,4), "cm") 
  ) +
  coord_polar() + 
  geom_text(data=label_data, aes(x=id, y=value+10, label=individual, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=2.5, angle= label_data$angle, inherit.aes = FALSE ) +
  
  # Add base line information
  geom_segment(data=base_data, aes(x = start, y = -5, xend = end, yend = -5), colour = "black", alpha=0.8, size=0.6 , inherit.aes = FALSE )  +
  geom_text(data=base_data, aes(x = title, y = -18, label=group), colour = "black", alpha=0.8, size=4, fontface="bold", inherit.aes = FALSE) # hjust=c(1,1,0,0), hjust=c(1,1,0,0), 

p
dev.off()


B = matrix(c(sqrt(1), sqrt(0.0107), -sqrt(0.1194), -sqrt(0.0099), -sqrt(0.0333), sqrt(0.0069), -sqrt(0.0099), sqrt(0.0107), sqrt(1), -sqrt(0.2511), sqrt(0.0052), sqrt(0.002), sqrt(0.0136), sqrt(0.0017), -sqrt(0.1194), -sqrt(0.2511), sqrt(1), sqrt(0.0124), sqrt(0.0078), -sqrt(0.0233), -sqrt(0.022), -sqrt(0.0099), sqrt(0.0052), sqrt(0.0124), sqrt(1), sqrt(0.6719), sqrt(0.0546), -sqrt(0.0789), -sqrt(0.0333), sqrt(0.002), sqrt(0.0078), sqrt(0.6719), sqrt(1), sqrt(0.0872), -sqrt(0.0482), sqrt(0.0069), sqrt(0.0136), -sqrt(0.0233), sqrt(0.0546), sqrt(0.0872), sqrt(1), sqrt(0.0566), -sqrt(0.0099), sqrt(0.0017), -sqrt(0.022), -sqrt(0.0789), -sqrt(0.0482), sqrt(0.0566), sqrt(1)), nrow=7, ncol=7)
svg(file="Figure3.svg")
qgraph(B,
     label.font=6,
     color="gray90",
     border.width=2.5,
     border.color="gray40",
     title="Correlations",
     palette="pastel",
     details=TRUE,
     borders=FALSE,
     shape="ellipse",
     vsize=12,
     vsize2=5)
dev.off()

