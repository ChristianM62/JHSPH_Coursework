*Lab 7 demo
********************************************************************************
clear all 

cd "/Users/CHanson/Documents/Econometrics TA_Trujillo/Lab 7/"
capture log close 
log using "lab7demo$S_DATE", text replace 

use assignment6_smoking_6.dta

tabstat dbirwt smoke male age agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3, statistics (count mean sd min max)

*outcome variables - lowbirthwt, gestat, dbirwt (need to do ols, fe, re for all 3 outcomes)


reg dbirwt smoke male age agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3 i.stateres i.year i.nlbnl, r

xtset momid1
xtreg dbirwt smoke male age agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3 i.stateres i.year i.nlbnl, fe 
est store fixed1

xtreg dbirwt smoke male age agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3 i.stateres i.year i.nlbnl, re 
est store random1


*easy to do all these models using a loop

hausman fixed1 random1

*can use xtoverid for a test that works with clustered errors
*good idea to re-do your models with cluster robust errors

clear

import excel Assignment_6_WHO.xls, firstrow

drop if small!=0

tabstat ldale lhexp lhc lhc2 lgdpc lpopden, statistics(mean sd count)

reg ldale lhexp lhc lhc2 lgdpc lpopden i.year 

reg ldale lhexp lhc lhc2 lgdpc lpopden i.year i.country 

****notice that we are not using year in these********

xtreg ldale lhexp lhc lhc2 lgdpc lpopden, fe i(country)
est store A

xtreg ldale lhexp lhc lhc2 lgdpc lpopden, re i(country)
est store B

hausman A B
