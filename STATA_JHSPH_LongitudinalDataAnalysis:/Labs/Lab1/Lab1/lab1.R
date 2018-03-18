# Lab 1 code in R


# generate data
# Install the mvtnorm package if you need it.
# install.packages("mvtnorm")
library(mvtnorm)

# Set the random seed so we could replicate the data generation
set.seed(12275)
# Define the mean, correlation and variance matrix
mm <- c(35, 38, 43, 49, 48)
vv <- 100
C <- matrix(c(1,0.85,0.80,0.72,0.69,0.85,1,0.85,0.80,0.72,0.80,0.85,1, 0.85,0.80,0.72,0.80,0.85,1,0.85,0.69,0.72,0.80,0.85,1),nrow=5) 
# Sigma defines the variance/covariance matrix
sigma <- C * vv
# Generate the matrix of y, note y has dimension 100 x 5
y <- rmvnorm(n = 100, mean=mm, sigma=sigma)
id <- seq(1:100)

# reshape data
dat <- as.data.frame(cbind(y,id))
names(dat) <- c("y0","y1","y2","y3","y4","id")	
long <- reshape(dat,varying=1:5,idvar="id",direction="long",v.names="y")

# Figure 1: trends in the mean and variance of the SF-36 mental health scores over time
png("Figure1.png")
boxplot(y[,1], xlim=c(0.5,5.5), ylim = c(min(y),max(y)),ylab="SF-36 mental health score",xlab=" ",las=1)
for(i in 2:ncol(y)) {
	boxplot(y[,i], at = i, add = TRUE,las=1)
}
axis(1, at = 1:5, labels = c("Baseline",paste0("Month ",1:4)))
dev.off()

# Figure 2: spaghetti plots
png("Figure2.png")
plot(NA, type = 'n', xlim = c(1,5), ylim = c(min(y),max(y)),ylab="SF-36 mental health score",
	xaxt ='n',xlab=" ",las=1)
time = 1:5
for(i in 1:nrow(y)) {
	lines(as.numeric(y[i,]) ~ time)
}
axis(1, at= 1:5, labels = c("Baseline",paste0("Month ",1:4)))
lines(1:5,apply(y,2,mean), col = "red", lwd = 2)
dev.off()

