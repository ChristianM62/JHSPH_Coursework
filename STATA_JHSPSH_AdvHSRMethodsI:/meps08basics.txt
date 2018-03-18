*MEPS 2008 HC-121 data set
  *Stata basics

use "c:\.......\meps08.dta", clear /*reads in the data set, fill in with current location of the file meps08.dta in the quotes ""*/


svyset varpsu [pweight = perwt08f], strata(varstr) /*Declares survey design for the dataset, type "help svyset" for more info*/


describe /*describe gives that information of the data set and the variables*/

describe wagep08x ttlp08x educyr /*can use for specified variables as well*/
summarize wagep08x ttlp08x educyr /*summary statistics*/
summarize wagep08x ttlp08x educyr, detail /*more detailed statistics*/
help summarize /*more information on the summarize command*/


/*Going to edit educyr by creating another variable*/

/*Defining formats*/
/*Apologies formats did not convert from SAS to stata data set
for now formats available in codebook: http://www.meps.ahrq.gov/mepsweb/data_stats/download_data_files_codebook.jsp?PUFId=H121*/

label define sexn 1  "Male" 2 "Female" /*called label name s*/
label values sex sexn /*set label name sexn to the variable sex*/

label define racexn 1  "White" 2 "Black" 3 "American Indian/Alaska Native" 4 "Asian" 5 "Native Hawaiian/PI" 6 "Other" /*called label name racexn*/
label values racex racexn /*set label name racexn to the variable racex*/
help label /*more information on the label command*/


tabulate sex 
tabulate racex 
tabulate sex racex /*two way tabulations*/
tabulate sex racex, chi2 /*option to compute chi square statistic*/
help tabulate /*more information on the tabulate command*/

svy: tabulate sex  /*"svy:" survey design tabulation*/
svy: tabulate sex racex

/*Going to edit sex by creating a dummy variable*/
gen Female = 1 if sex == 2
replace Female = 0 if sex == 1
   /*Note 1 equal sign "=" is an assignment operator, other operators & (and), | (or), ! (not), != (not equal), == (equal)*/
   /*gen-generates the variable, once you generate a variable you can only replace its value with the "replace" statement*/
