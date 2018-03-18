*Lab 3 demo
********************************************************************************
clear all 

cd "/Users/CHanson/Documents/Econometrics TA_Trujillo/Lab 3/"
capture log close 
log using "lab2demo$S_DATE", text replace 

use Medicarecleandata
**** 1. Graphically show discontinuity for use of mammograms at age 65 for 
****    those with less than a HS degree 

* Limit observations
drop if educa > 3

collapse (mean) mammo (count) n=mammo, by(age)

twoway  scatter mammo age, msymbol(Oh) mcolor(black) mfcolor(pink) xtitle("Age") xlabel(50(2)80) || ///
	line mammo age, xline(65) title("blah") subtitle("blah")
clear

use Medicarecleandata
gen agegrp1 = (age>=55 & age<=65)
gen agegrp2 = (age>=60 & age<=65)
gen agegrp3 = (age>=63 & age<=65)
gen agegrp4 = (age>=65 & age<=67)
gen agegrp5 = (age>=65 & age<=70)
gen agegrp6 = (age>=65 & age<=75)

forvalues g = 1/6 {
tabstat genhlth medicar2 smoke100 age marital educa income2 weight height hadmam howlong sex if agegrp`g'==1, stat(mean semean) columns(statistics) save
matrix a`g'=r(StatTotal)'
matrix list a`g'
}

*can also type in headings if you want (put matrix in B1, manually type in headings)
matrix A = a1,a2,a3,a4,a5,a6
putexcel set summarystats.xlsx, replace
putexcel A1= matrix(A), names

*Generate centered age variable
gen age65=age-65

* Generate program participation variable- indicating if person is in treatment group
gen p=0
replace p=1 if medicar2==1

* Generate dummy education if less than HS degree
gen lessthanhs=0
replace lessthanhs=1 if educa<4

reg mammo p age65 i._state i.orace i.year
outreg2 using decker.xlsx,  label title(TABLE 1- Simple Regression) replace
est store A

xi: reg mammo p age65 i.educcat i._state i.orace i.year
outreg2 using decker.xlsx,  label append
est store B

*interaction model
reg mammo p age65 i.p#c.age65 i._state i.orace i.year
est store C

xi:reg mammo p age65 i.p*age65 i._state i.orace i.year
est store D

*cubic model
gen age65_sq=age65^2

reg mammo p age65 age65_sq i.p#c.age65 i.p*#c.age65_sq i._state i.orace i.year
est store E

est stats A B C D E
*look at AIC and BIC values

lrtest D E


clear

use levinedata2

preserve
collapse (mean) pubhi1=pubhi insured1=insured privhi1=privhi if trend<6, by(a_age)
tempfile t1
save `t1'
restore

preserve
collapse (mean) pubhi2=pubhi insured2=insured privhi2=privhi if trend>8 & trend<15, by(a_age)
tempfile t2
save `t2'
restore

preserve
collapse (mean) pubhi3=pubhi insured3=insured privhi3=privhi if trend>14 , by(a_age)
tempfile t3
save `t3'
restore

clear
use `t1'
merge 1:1 a_age using `t2'
assert _merge==3
drop _merge

merge 1:1 a_age using `t3'
assert _merge==3
drop _merge

*Create Chart For Insurance coverage;
twoway scatter insured1 insured2 insured3 a_age

* Create chart for Public Health Insurance Coverage;
twoway scatter pubhi1 pubhi2 pubhi3 a_age

* Create chart for Private Health Insurance Coverage;
twoway scatter privhi1 privhi2 privhi3 a_age

clear

use levinedata2
* Column 2- Any insurance coverage;
reg insured elig_schip  i.stfips i.year i.a_age ur povratio povratio2 if a_age>=16 & a_age<=22


* Column 3- Public insurance coverage;
reg pubhi elig_schip  i.stfips i.year i.a_age ur povratio povratio2 if a_age>=16 & a_age<=22

* Column 4- Private insurance coverage;
reg privhi elig_schip  i.stfips i.year i.a_age ur povratio povratio2 if a_age>=16 & a_age<=22

**** This section recreates Regressions for the sample living with their parents and <150% of Pov Line****;

reg insured elig_schip i.stfips i.year i.a_age ur povratio povratio2 if pov==1.5 & withparent==1 & a_age>=16 & a_age<=22

**** This section recreates Regressions for the sample living with their parents and between 150% and 300% of Pov Line****;

reg insured elig_schip i.stfips i.year i.a_age ur povratio povratio2 if pov==3 & withparent==1 & a_age>=16 & a_age<=22

**** This section recreates Regressions for the sample living with their parents and above 300% of Pov Line****;

reg insured elig_schip i.stfips i.year i.a_age ur povratio povratio2 if pov==4 & withparent==1 & a_age>=16 & a_age<=22
