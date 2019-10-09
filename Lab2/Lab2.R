#tutorial = http://r-statistics.co/ggplot2-Tutorial-With-R.html
#importing library and setting diamonds data to a local variable diam
library(ggplot2)
diam <- diamonds


#example 1, none of these show any data since none of them have geoms
ggplot(diam) #if only the dataset is known
ggplot(diam, aes(x=carat)) #if only the x-axis is knows, the y axis can be specified in respective geoms
ggplot(diam, aes(x=carat, y=price)) #if both X and Y axis are fixed for all layers
ggplot(diam, aes(x=carat, color=cut)) #each value in cut will be given a destinct colour, once a geom is added
ggplot(diam, aes(x=carat), color="steelblue") #changes the colours of the graph


#example 2
ggplot(diam, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() #adding scatterplot geom(layer1) and smoothing geom(layer2)
ggplot(diam) + geom_point(aes(x=carat, y=price, color=cut)) + geom_smooth(aes(x=carat, y=price, color=cut)) #same as above but specifing aesthetics instead of geoms
ggplot(diam) + geom_point(aes(x=carat, y=price, color=cut)) + geom_smooth(aes(x=carat,y=price)) #remove colour from geom_smooth
ggplot(diam, aes(x=carat, y=price)) + geom_point(aes(color=cut)) + geom_smooth() #same but simpler
ggplot(diam, aes(x=carat, y=price, color=cut, shape=color)) + geom_point() #adds shape based on colour


#example 3
example3 <- ggplot(diam, aes(x=carat, y=price, color=cut)) + geom_point() + labs(title="scatterplot", x="Carat", y="Price") #adds labels and plot title
print(example3)


#example 4
example4 <- example3 + theme(plot.title=element_text(size=30, face="bold"), #add title and axis textm change legent title
                             axis.text.x=element_text(size=15),
                             axis.text.y=element_text(size=15),
                             axis.title.x=element_text(size=25),
                             axis.title.y=element_text(size=25))+
  scale_color_discrete(name="Cut of Diamonds")
print(example4)


#example 5
example3 + facet_wrap(~ cut, ncol=3) #columns defined by cut, different graphs based on cut
example3 + facet_wrap(color ~ cut) #row: color, column: cut
example3 + facet_wrap(color ~ cut, scales="free") #scales arent identical
example3 + facet_grid(color ~ cut) #in a grid


#example6
#6.1 make a time series plot
library(ggfortify)
autoplot(AirPassengers) + labs(title="Air Passengers")  # where AirPassengers is a 'ts' object

#6.2 multiple timeseries on same ggplot
#approach 1
data(economics, package="ggplot2") #init data
economics <- data.frame(economics) #convert to dataframe
ggplot(economics) + geom_line(aes(x=date, y=pce, color="pcs")) + geom_line(aes(x=date, y=unemploy, col="unemploy")) + scale_color_discrete(name="legend") + labs(title="economics") #plot numtiple series using geom_lines
#approach 2
library(reshape2)
df <- melt(economics[, c("date", "pce", "unemploy")], id="date")
ggplot(df) + geom_line(aes(x=date, y=value, color=variable)) + labs(title="economics") #plot multiple time series by melting
#approach 3
library(reshape2)
df <- melt(economics[, c("date", "pce", "unemploy")], id="date")
ggplot(df) + geom_line(aes(x=date, y=value, color=variable)) + facet_wrap(~ variable, scales="free")

#6.3 bar chart
plot1 <- ggplot(mtcars, aes(x=cyl)) + geom_bar() + labs(title="frequency bar chart") #Y axis derived from ocunts of X item
print(plot1)
df <- data.frame(var=c("a", "b", "c"), nums=c(1:3))
plot2 <- ggplot(df, aes(x=var, y=nums)) + geom_bar(stat="identity") #Y axis is explicit 'stat=identity'
print(plot2)

#6.4 custom layout
library(gridExtra)
grid.arrange(plot1, plot2, ncol=2)

#6.5 flipping coordinates
df <- data.frame(var=c("a", "b", "c"), nums=c(1:3))
ggplot(df, aes(x=var, y=nums)) + geom_bar(stat="identity") + coord_flip() + labs(title="Coordinates are flipped")

#6.6 adjusitng X/Y axis limits
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + coord_cartesian(ylim=c(0, 1000)) + labs(title="coord_cartesian zoomed in")
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + ylim(c(0, 1000)) + labs(title="Datapoints deleted: note the change in smoothing lines")

#6.7 equal coordinates
ggplot(diamonds, aes(x=price, y=price+runif(nrow(diamonds), 100, 1000), color=cut)) + geom_point() + geom_smooth() + coord_equal()

#6.8 change theme
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + theme_bw() + labs(title="bw theme")

#6.9 legend - deleting and changing position 
p1 <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + theme(legend.position="none") + labs(title="legend.position=none") #remove legend
p2 <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + theme(legend.position="top") + labs(title="legend.position=top") #legend at top
p3 <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + theme(legend.position="bottom") + labs(title="legend.position=bottom") #legend at bottom
grid.arrange(p1, p2, p3, ncol=3)

#6.10 grid lines
ggplot(mtcars, aes(x=cyl)) + geom_bar(fill='darkgoldenrod2') + theme(panel.background = element_rect(fill = 'steelblue'), panel.grid.major = element_line(color = "firebrick", size=3), panel.grid.minor = element_line(color="blue", size=1))

#6.11 plot margin and background
ggplot(mtcars, aes(x=cyl)) + geom_bar(fill="firebrick") + theme(plot.background = element_rect(fill = "steelblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) #top, right, bottom, left

#6.12 annotation
library(grid)
my_grob = grobTree(textGrob("This text is at x=0.1 and y=0.9, relative!\n Anchor point is at 0,0", x=0.1,  y=0.9, hjust=0, gp=gpar(col="firebrick", fontsize=25, fontface="bold")))
ggplot(mtcars, aes(x=cyl)) + geom_bar() + annotation_custom(my_grob) + labs(title="Annotation Example")

#6.13 saving ggplot
plot1 <- ggplot(mtcars, aes(x=cyl)) + geom_bar()
ggsave("myggplot.png") #saves the last plot
ggsave("myggplot1.png", plot=plot1) #save a stored plot
