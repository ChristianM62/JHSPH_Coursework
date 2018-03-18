
library(foreign)
card = read.dta("card.small.dta")

head(card)
table(card$educ)
table(card$nearc4)
plot(card$educ, card$lwage)

# Estimate the Association between Education and Wages
out1 = lm(lwage ~ educ + exper + expersq + black + south + 
            smsa + reg661 + reg662 + reg663 + reg664 + reg665 + 
            reg666 + reg667 + reg668 + smsa66, data = card)
summary(out1)

abline(out1, col = "red")


# Estimate the Association between proximity and education
out2<-lm(educ~nearc4 + exper+expersq+black+south+smsa+reg661+reg662
         +reg663+reg664+reg665+reg666+reg667+
           reg668+smsa66+nearc4, data = card)
summary(out2)

##AER is an R package with a two-stage least squares function
install.packages("AER")
library(AER)
out5 = ivreg(lwage~educ+exper+expersq+black+south+
               smsa+reg661+reg662+reg663+reg664+reg665+
               reg666+reg667+reg668+smsa66|nearc4+exper+
               expersq+black+south+smsa+reg661+reg662+reg663+
               reg664+reg665+reg666+reg667+reg668+smsa66, data = card)
summary(out3)




