*Lab 6 demo
********************************************************************************
clear all 

cd "/Users/CHanson/Documents/Econometrics TA_Trujillo/Lab 6/"
capture log close 
log using "lab6demo$S_DATE", text replace 

***Part IIA***
insheet using assignment_5.csv, comma

*before running, state hypothesis

tab year

*Question 1
*regular pooled ols regression
regress mrdrte exec unem d93 if year!=87

*Question 2
*first difference
*note difference in data structure compared to last week...it's long, but change variables are still in there
*w/ missing data for years!=93
regress cmrdrte cexec cunem if year==93

*Question 3
*can find the state with the largest number of executions any number of ways...sort, list, egen rank, etc

*Question 4
*add state!="TX" to command from Q2

*Question 5
xtset id year
xtreg mrdrte exec unem i.year if state!="TX", fe

*Question 6 
xtreg mrdrte exec unem i.year, fe

*Question 7
help xtreg postestimation
predict u, u
predict xbu, xbu

scalar constant=_b[_cons]
gen ai=u+_b[_cons]
list ai if state=="CA"

reg mrdrte exec unem i.year i.id
predict xb
lincom _b[5.id] + _b[_cons]

assert xbu==xb

*Question 8
sort id year
bysort id: gen mrdrte_1=mrdrte[_n-1]
reg mrdrte exec unem mrdrte_1 if year==93


***PART IIB***
clear
use Riphan2003

*generate age categories
gen age2535=0
replace age2535=1 if age>=25 & age<35
gen age3545=0
replace age3545=1 if age>=35 & age<45
gen age4555=0
replace age4555=1 if age>=45 & age<55
gen age5565=0
replace age5565=1 if age>=55 & age<65

*Question 4
reg docvis age age2 i.year newhsat handdum handper married educ hhninc hhkids self beamt bluec public addon if female==1, robust

*Question 6
xtset id year 
xtreg docvis age age2 i.year newhsat handdum handper married educ hhninc hhkids self beamt bluec public addon if female==1, fe  robust
