*Lab - analysis file
********************************************************************************
clear all 

set more off, permanently
set scrollbufsize 2000000

cd "/Volumes/DISK_IMG/Econometrics/Lab 1"
*for more complex projects, good idea to have subfolders for data, output, etc
capture log close 
log using "lab1demo_analysis$S_DATE", text replace 

use wisdom_analysis1, clear


sum sandwichcal
tab sandwichcal

reg sandwichcal female

reg sandwichcal healthymenu unhealthymenu

tab healthymenu, m

tab unhealthymenu, m

tab healthymenu unhealthymenu, m

mean sandwichcal if unhealthymenu == 0 & healthymenu==0

gen regular = 0
replace regular = 1 if unhealthymenu == 0 & healthymenu==0


reg sandwichcal healthymenu unhealthymenu 
est store A

/*
note -- estimates store stores in memory
can use estimates save to save results to a file
(useful for models that take a long time to run, that you will want to return to later)
*/


reg sandwichcal healthymenu unhealthymenu age female afram
est store B

ssc install outreg2
help outreg2

outreg2 [A B] using results1.xls, label replace 

outreg2 [A B] using results1, excel  replace 

outreg2 [A B] using results1, word  replace 

reg sandwichcal healthymenu unhealthymenu age female afram height 
est store C

outreg2 [C] using results1.xls, append ci 

estimates restore A
reg

