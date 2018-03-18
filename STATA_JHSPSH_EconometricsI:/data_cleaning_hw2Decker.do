*Processing for Assignment 2
*Econometric Methods of Impact Evaluation

capture log close
set mem 100m
set more off

use Medicare_assignmentmultiyear, clear

*1. Create variable labels
lab var genhlth "General health status"
lab var medicar2 "Do you have medicare?"
lab var typcovr1 "Type of health coverage"
lab var typcovr2 "Type of health coverage"
lab var nocov12 "Any period of no coverage in past year"
lab var smoke100 "Smoke more than 100 cigarettes in life"
label var orace "Race"
label var hispanic "Are you hispanic"
label var educa "Education"
label var income2 "Income Category"

*Recode DK and refused to missing for all vars in question 2
recode genhlth medicar2 nocov12 smoke100 age orace hispanic marital educa hadmam howlong (7 9=.)
recode typcovr1 typcovr2 income2 (77 99=.) (88=0)
recode weight height (777 999=.)

*Labeling race
label define race 1 "White" 2 "Black" 3 "Asian, Pacific Islander" ///
	4 "American Indian, Alaska Native" 5 "Other" 
label values orace race

*Label education
recode educa (6=0 "College") (1 2 3=1 "Some HS") (4 5=2 "HS"), into(educcat) label(educ)

*Create dummies for missing values
local allvars "_state genhlth medicar2 typcovr1 typcovr2 nocov12 smoke100 age orace hispanic marital educa income2 weight height sex hadmam howlong"
foreach x of local allvars {
	gen `x'_miss=1 if `x'==.
}

*Label variables with yes and no
label define yesno 1 "Yes" 2 "No"

foreach x in medicar2 nocov12 smoke100 hispanic hadmam {
	label val `x' yesno
}

*Create variable for mammogram in past 2 years
gen mammo=0
replace mammo=1 if hadmam==1 & howlong<=2
replace mammo=. if hadmam==. | howlong==.

*Cleaning up Medicare coverage variable
replace medicar2 = 1 if typcovr1==4|typcovr2==4


*Create variable for uninsured
gen uninsured = 0 
replace uninsured = 1 if typcovr1==.&typcovr2==.&medicar2!=1
replace uninsured=1 if typcovr1==0 & (typcovr2==0 | typcovr2==.)

* Limit Observations to age group 50-80
drop if age>80
drop if age<50

save Medicarecleandata, replace