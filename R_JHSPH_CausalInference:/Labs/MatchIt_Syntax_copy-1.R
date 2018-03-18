# Instructions for running matching methods in R using MatchIt
# Uses Lalonde data (from Dehejia and Wahba 1999), which is built into MatchIt
# treat = treatment indicator (0/1)
# Covariates available: age, educ (education), black, hispan, married, nodegree (no high school degree),
# 	re74 (real earnings in 1974), re75 (real earnings in 1975)
# Outcome: re78 (real earnings in 1978)

# Type this the first time you ever want to run MatchIt
# (take the "#" sign off from the beginning of the next line)
# install.packages("MatchIt")

# Type this next line every time you want to run MatchIt
library(MatchIt) 

# sets the working directory (optional)
#setwd("C:/mydata") 
#getwd() 

# Two other useful commands (not used here)
# To read in a program to R:
# source("programname.R")
# To send output to a file:
# sink("programname.out")
# See help(sink) or help(source) for more information

# Load in the data 
# (Lalonde data part of MatchIt; available once you load the  MatchIt package)
# Can also use read.table command to read a text file, e.g.:
# data1 <- read.table("matchitdata.csv", header=T, sep=",")
data(lalonde)

# MatchIt requires no missing values in the data
# Keep only observations/variables with non-missing values
# This not necessary for Lalonde data since all observed data
# But could use code something like:
# vars <- c("treat", "y", "x1", "x2", "x3") 
# (include all variables used in the matching or analyses in the above command)
# Now keep only the observations with fully observed values on all of those variables
# data <- data[!is.na(apply(data[,vars], 1, mean)),vars]

# Run MatchIt
#performs the matching, identifies the matching method
m.out <- matchit(treat ~ age + educ + black + hispan + married + re74 + re75, 
data = lalonde, method = "nearest", exact=c("nodegree")) 

print(m.out)
print("Objects in m.out object")
print(names(m.out))
print("Observations matched to each other (m.out$match.matrix[1:10,])")
print(m.out$match.matrix[1:10,])
print("Propensity scores (m.out$distance[1:10])")
print(m.out$distance[1:10])
print(summary(m.out, standardize=TRUE))
print(summary(m.out, interactions = TRUE, addlvariables = NULL, 
standardize = TRUE)) #shows additional output

pdf("Figures-Jitter.pdf")
plot(m.out, type = "jitter", interactive = FALSE)  
dev.off()
pdf("Figures-Hist.pdf")
plot(m.out, type = "hist")
dev.off()
pdf("Figures-QQ.pdf")
plot(m.out, type = "QQ", interactive = FALSE, which.xs = c("age", "re74", "re75"))  
dev.off()

s.out  <- summary(m.out, standardize=TRUE)
pdf("Figures-StdBias.pdf")
plot(s.out, interactive=FALSE)
dev.off()

matched.data <- match.data(m.out)  
print("Variables in matched.data dataframe")
print(names(matched.data))
# Output matched data to a text file
write.table(matched.data, file="data_match.txt")

# Outcome model (difference in means; like a t-test but done using linear regression
# with no predictors besides treatment status)
model1 <- lm(re78 ~ treat, data=matched.data)
print(summary(model1))

# Can also do regression adjustment on the matched samples
model1 <- lm(re78 ~ treat + age + educ + black + hispan + married + nodegree + re74 + re75, data=matched.data)
print(summary(model1))

###############################################################################
# Other possible matching commands
# Mahalanobis matching within propensity score calipers
m.out.mahal <- matchit(treat ~ age + educ + black + hispan + married + re74 + re75, 
data = lalonde, method = "nearest", mahvars=c("re74", "re75")) 
print(summary(m.out.mahal, standardize=TRUE))

# Full matching: see Stuart & Green (2008) for more code relevant to full matching
m.out.full <- matchit(treat ~ age + educ + black + hispan + married + re74 + re75, 
data = lalonde, method = "full") 
print(summary(m.out.full, standardize=TRUE))
# Impact estimation after using full matching
# (Note: Since these are more like frequency weights than survey sampling weights you 
# don't need to use the survey package)
# (Code would be very similar if you had done matching with replacement)
matched.data.full <- match.data(m.out.full)  
model1 <- lm(re78 ~ treat + age + educ + black + hispan + married + nodegree + re74 + re75, data=matched.data.full, weight=weights)
print(summary(model1))

# Subclassification
m.out.subclass <- matchit(treat ~ age + educ + black + hispan + married + re74 + re75, 
data = lalonde, method = "subclass") 
print(summary(m.out.subclass, standardize=TRUE))
# Outcome analysis after subclassification: estimation within subclasses
# Get matched data, with subclass indicators
data.subcl <- match.data(m.out.subclass)
# Create vectors to hold the subclass specific effects (effects) and variances (vars) and the
# number of people in each subclass (N.s)
# Note: This code weights subclasses by the total number of people in each subclass and so estimates the ATE
effects <- rep(NA, max(data.subcl$subclass))
vars <- rep(NA, max(data.subcl$subclass))
# Count how many total people in each subclass
N.s <- rep(NA, max(data.subcl$subclass))
# N = total number of people in data
N <- dim(data.subcl)[1]
# Run regression model within each subclass
for(s in 1:max(data.subcl$subclass)){
   tmp <- lm(re78 ~ treat + age + educ + black + hispan + married + re74 + re75, data=data.subcl, subset=subclass==s)
   effects[s] <- tmp$coef[2]
   vars[s] <- summary(tmp)$coef[2,2]^2
   N.s[s] <- sum(data.subcl$subclass==s)
}
# Calculate overall effects, averaging across subclasses
# Again, given the way the N.s and N numbers were calculated this will estimate the ATE
effect <- sum((N.s/N) * effects)
stderror <- sqrt(sum((N.s/N)^2*vars))
print("Subclass specific effects and variances")
print(effects)
print(vars)
print("Overall effect and standard error")
print(effect)
print(stderror)

# Subclassification after 1:1 nearest neighbor matching
m.out.11subclass <- matchit(treat ~ age + educ + black + hispan + married + re74 + re75, 
data = lalonde, method = "nearest", subclass=5) 
print(summary(m.out.11subclass, standardize=TRUE))

# To calculate IPTW weights
# These are true ITPW weights in the sense that they will estimate the ATE
# (They are NOT weights that do weighting by the odds, which would estimate the ATT)
m.out.iptw <- matchit(treat ~ age + educ + black + hispan + married + re74 + re75, 
data = lalonde, method = "subclass") 
data.iptw <- match.data(m.out.iptw)
# The line below this is the one that would need to change to do weighting by the odds to estimate the ATT
data.iptw$iptw.weights <- ifelse(data.iptw$treat==1, 1/data.iptw$distance, 1/(1-data.iptw$distance))
# Print histograms of the treated and control weights
pdf("IPTWWeights.pdf")
# Puts two plots  per page (2 rows, 1 column)
par(mfrow=c(2,1))
hist(data.iptw$iptw.weights[data.iptw$treat==1], main="Treated group IPTW weights", xlim=range(data.iptw$iptw.weights))
hist(data.iptw$iptw.weights[data.iptw$treat==0], main="Control group IPTW weights", xlim=range(data.iptw$iptw.weights))
dev.off()
# Run weighted regression
# Requires installation of "survey" package
library(survey)
design <- svydesign(ids =~1, weights=data.iptw$iptw.weights, data =data.iptw)
# By default, "svyglm" runs a linear regression
# For logistic, include option "family=binomial"
lm1 <- svyglm(re78 ~ treat + age + educ + black + hispan + married + re74 + re75, design=design)
print(summary(lm1))

