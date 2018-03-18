##################
## :: TWANG :: ###
##################

#set working directory
# setwd("~/Dropbox/Causal Inference 2014")


library("twang")
data(lalonde)
summary(lalonde)

set.seed(121180) # set seed so you can replicate your results
ps.lalonde.ATT <- ps(treat ~ age + educ + black + hispan + nodegree + married + re74 + re75, 
                 data = lalonde, verbose=FALSE, estimand ="ATT")

summary(ps.lalonde.ATT$gbm.obj, n.trees = ps.lalonde.ATT$gbm.obj$n.trees, plot=TRUE)

balonde.balance.ATT <- bal.table(ps.lalonde.ATT)
print(balonde.balance.ATT)

plot(ps.lalonde.ATT)
plot(ps.lalonde.ATT, plots="boxplot") 
plot(ps.lalonde.ATT, plots="es") 
plot(ps.lalonde.ATT, plots="ks")
plot(ps.lalonde.ATT, plots="t")


##Twang produces two possible weights, based on two different stopping criteria
#to extract to weights use the get.weights() function and specify with stopping criteria to use
lalonde$w.ATT.ks <- get.weights(ps.lalonde.ATT,
                               estimand ="ATT", stop.method="ks.mean")


# to get the weights use the es.mean stopping criteria
#lalonde$w.ATT.es <- get.weights(ps.lalonde.ATT,estimand ="ATT", stop.method="es.mean")

#Examine the distribution of the weights:
par(mfrow=c(1,2))
hist(lalonde$w.ATT.ks[lalonde$treat==1]) 
hist(lalonde$w.ATT.ks[lalonde$treat==0]) 
summary(lalonde$w.ATT.ks[lalonde$treat==1]) 
summary(lalonde$w.ATT.ks[lalonde$treat==0])

## :: Estimate Treatment Effects :: ##
# will need to install the survey package first

##Options for printing R output
options(scipen=8) # bias against scientific notation
options(digits =8) #The digits option controls how many digits are printed (by default)


# JUST TREATMENT VARIABLE
design.att <- svydesign(ids=~1,weights=~w.ATT.ks, data=lalonde)
glm1 <- svyglm(re78 ~ treat,design=design.att)
summary(glm1)
glm1$coefficients
# Display confidence intervals
confint(glm1)

#DOUBLY ROBUST MODEL
glm2 <- svyglm(re78 ~ treat + age + educ + black + hispan + nodegree + married + re74 + re75, 
               design=design.att)
summary(glm2)
glm2$coefficients
# Display confidence intervals
confint(glm2)


## Estimating ATE Weights
set.seed(121180) # set seed so you can replicate your results
ps.lalonde.ATE <- ps(treat ~ age + educ + black + hispan + nodegree + married + re74 + re75, 
                     data = lalonde, verbose=FALSE, estimand ="ATE")
balonde.balance.ATE <- bal.table(ps.lalonde.ATE)
print(balonde.balance.ATE)

summary(ps.lalonde.ATE$gbm.obj, n.trees = ps.lalonde.ATE$gbm.obj$n.trees, plot=TRUE)

plot(ps.lalonde.ATE)
plot(ps.lalonde.ATE, plots="boxplot") 
plot(ps.lalonde.ATE, plots="es") 
plot(ps.lalonde.ATE, plots="ks")
plot(ps.lalonde.ATE, plots="t")


#extract to weights 
lalonde$w.ATE.ks <- get.weights(ps.lalonde.ATE,
                                estimand ="ATE", stop.method="ks.mean")


## :: Estimate Treatment Effects :: ##
# will need to install the survey package first

# JUST TREATMENT VARIABLE
design.ate <- svydesign(ids=~1,weights=~w.ATE.ks, data=lalonde)
glm3 <- svyglm(re78 ~ treat,design=design.ate)
summary(glm3)
glm3$coefficients
# Display confidence intervals
confint(glm3)

#DOUBLY ROBUST MODEL
glm4 <- svyglm(re78 ~ treat + age + educ + black + hispan + nodegree + married + re74 + re75, 
               design=design.ate)
summary(glm4)
glm4$coefficients
# Display confidence intervals
confint(glm4)

