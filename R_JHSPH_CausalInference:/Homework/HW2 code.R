#5

#Run the following two lines of code to install and load the WeightIt package
install.packages("WeightIt")
library(WeightIt)

#Run the following chunk of code to estimate propensity score weights using logistic regression and generalized boosted modeling. 
# Two notes: (1) the set.seed() command ensures that you will get the same results if you run the code multiple times; 
# (2) the code for gbm.ATT will take around 30 seconds to run.
set.seed(1234)
logreg.ATT <- weightit(exposure1~male+white+age+susp+mathG+readG+parentED+housesmoke,
                       data=df,
                       method="ps",
                       estimand="ATT")
gbm.ATT <- weightit(exposure1~male+white+age+susp+mathG+readG+parentED+housesmoke,
                    data=df,
                    method="twang",
                    stop.method="ks.mean",
                    estimand="ATT")

#Install and load the cobalt package to examine the resulting balance from these two methods.
install.packages("cobalt")
library(cobalt)

#Run the following chunk of code to examine whether one weighting method seems better than the other in this example (in terms of creating balance on the observed covariates).
logreg.balance <- bal.tab(logreg.ATT)
love.plot(logreg.balance, title="Covariate Balance (Logistic regression)")
gbm.balance <- bal.tab(gbm.ATT)
love.plot(gbm.balance, title="Covariate Balance (Generalized Boosted Modeling)")


#6

#Regardless of your answer to the previous question, pretend you have decided to use the generalized boosted modeling weights. Use the following code to examine the distribution of these weights.

hist(logreg.ATT$weights[gbm.ATT$treat==0])
summary(logreg.ATT$weights[gbm.ATT$treat==0])
summary(logreg.ATT$weights[gbm.ATT$treat==1])

#Do you have any concerns about these weights? Why or why not? Choose the best option.

#8
#To estimate the treatment effect and its standard error using the ATT weight, we will use the survey package. To install and load the survey package, run the following two lines of code:

install.packages("survey")
library(survey)

#Use the following code to fit the model for the treatment effect and to extract the odds ratio and its 95% confidence interval.
design.ATT <- svydesign(ids=~1, weights=gbm.ATT$weights, data=df)
glm.gbmweight <- svyglm(smoke1~exposure1,design=design.ATT,family=quasibinomial())
summary(glm.gbmweight)
exp(summary(glm.gbmweight)$coef[2])
exp(confint(glm.gbmweight))[2,]

#12
#Now that we have looked at propensity score weighting, we will turn to matching. Using the same ADDHEALTH dataset, we will use the R package MatchIt to perform full matching. Compare your results to what you obtained earlier when you used ATT weighting. Are the results the same? (Answer in 100 words or fewer)

install.packages("MatchIt")
install.packages("optmatch")
#Note: you need to also install the optmatch package for MatchIt to work properly
library(MatchIt)
library(optmatch)

match1 <- matchit(exposure1~ male+white+age+susp+mathG+readG+parentED+housesmoke,
                       data=df,
                       method="full")
fullmatch.balance <- bal.tab(match1)
love.plot(fullmatch.balance, title="Covariate Balance (Full matching)")

matched1 <- match.data(match1)
fullmodel <- glm(smoke1~exposure1+male+white+age+susp+mathG+readG+parentED+housesmoke,
                 data=matched1, 
                 weight=weights,
                 family=quasibinomial())
exp(fullmodel$coef[2])
exp(confint(fullmodel)[2,])