*Lab 1 - demo of wisdom et al. data
********************************************************************************

clear all 

set more off, permanently
set scrollbufsize 2000000

cd "/Volumes/DISK_IMG/Econometrics/Lab 1"
capture log close 
log using "lab1demo$S_DATE", text replace 

use wisdometalwordeddata, clear

count
des

sum 

tab subjchoice

codebook
codebook, compact

tab age, m
help tab

count if age > 85 & age != . 


tab race, m

count if race == "Black"
count if substr(race, 1, 5) == "Black"
count if strpos(race, "Black")

tab afram, m

drop afram
gen afram = 0
replace afram = 1 if substr(race, 1, 5) == "Black"
tab afram,m

save wisdom_analysis1, replace









