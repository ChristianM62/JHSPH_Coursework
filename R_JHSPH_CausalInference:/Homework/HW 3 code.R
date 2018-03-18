#7 Estimate the causal effect of having one's first two children be of the same sex on having a third child 
model <- glm(morekids~samesex,data=dat,family="binomial")
exp(model$coef[2])
exp(confint(model)[2,])

#Pre8 Perform a crosstab of the instrument and exposure that reports the relative frequency of each row within each column
crosstab <- table(factor(dat$morekids,levels=c(1,0)),factor(dat$samesex,levels=c(1,0)))
t(t(crosstab)/rowSums(t(crosstab)))

#11-14 Estimate the effect of having two children of the same sex on maternal income 
summary(lm(incomem~samesex,data=dat))

#15 Estimate the effect of having a third kid 
# Calulate the "per protocol" (compares mothers who had two kids of the same sex and then had a third child 
# with those who had two kids of different sexes and did not have a third child) estimate of the effect on maternal income
summary(lm(incomem~morekids,data=dat))
summary(lm(incomem~morekids,data=dat[dat$morekids==1 & dat$samesex==1 | dat$morekids==0 & dat$samesex==0,]))

#17 Estimate the instrumental variable estimate of the treatment effect
summary(lm(incomem~samesex,data=dat))$coef[2]/(1-t(t(crosstab)/rowSums(t(crosstab)))[1,2]-t(t(crosstab)/rowSums(t(crosstab)))[2,1])

#19 Estimate the instrumental variable effect using two stage least squares using the "tsls" command from the "sem" package in R
install.packages("sem")
library(sem)
summary(tsls(incomem ~ morekids, instruments = ~ samesex, data=dat))
