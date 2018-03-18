# You should download the "lab0 wide.dta" and "lab0 long.dta"
# to a folder on your computer.

# In preparation for the lab, change the working directory 
# to the folder where you stored these files
setwd("pathname")

# Question 2:

wide = read.table("lab0 wide.csv",sep=",",header=T)
wide[1:2,]

long = read.table("lab0 long.csv",sep=",",header=T)
long[1:10,]

# Question 4:

wide = read.table("lab0 wide.csv",sep=",",header=T)
summary(wide)
apply(wide,2,FUN=function(x) sqrt(var(x)))

# Question 5:

# Reshape from wide to long
long <- reshape(wide,varying=1:5,ids=seq(1,100),direction="long",v.names="y")

# Reshape from long to wide
wide <- reshape(long,v.names="y", idvar= "id",timevar="time",direction="wide")

# Question 6:

long = read.table("lab0 long.csv",sep=",",header=T)
tapply(long$y,long$time,summary)
tapply(long$y,long$time,FUN=function(x) sqrt(var(x)))
long$counter = 
unlist(tapply(long$id,long$id,FUN=function(x) seq(1,length(x))))
summary(long[long$counter==1,c("age","gender","severity")])
apply(long[long$counter==1,c("age","gender","severity")],2,FUN=function(x) sqrt(var(x)))

