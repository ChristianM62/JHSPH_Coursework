# set working directory
setwd("THE PATH TO WHERE YOUR DATA IS STORED")
# load data
load("nofault_divorce2014.Rdata")

# 8 Conduct a t-test to compare the pre-law divorce rates to the post-law divorce rates for the states that passed unilateral, no-fault divorce laws in 1972, and then another one for the comparison states.
nofault = divorce[divorce$nofault == 1,] 
t.test(nofault$div_rate[nofault$intervention==0],nofault$div_rate[nofault$intervention==1])
control = divorce[divorce$nofault == 0,]
t.test(control$div_rate[control$intervention==0],control$div_rate[control$intervention==1])

# 9 Use a simple OLS Difference in Difference-type model to estimate the effect of unilateral, no-fault divorce laws, ignoring the correlation of observations within a state.
library(plm)
summary(diff1 <- plm(div_rate ~ nofault + intervention + nofault:intervention, index = c("state", "year"), model="pooling", data = divorce))

# 14 Estimate the treatment effect using the model
install.packages("nlme")
library(nlme)
summary(diff2.gls <- gls(div_rate ~ nofault + intervention + nofault:intervention, correlation = corAR1(form=~1|state), data = divorce))

# 15 Fit a comparative interrupted time series model that incorporates a linear time trend to compare the impact of the unilateral, no-fault divorce laws on states that implemented these laws and those that did not.
gls(div_rate ~  year72 + nofault + intervention + year72:nofault + year72:intervention + nofault:intervention + year72:nofault:intervention, data = divorce, correlation = corAR1(form=~1|state))
