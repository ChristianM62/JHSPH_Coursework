* You should download the "lab0 wide.dta" and "lab0 long.dta"
* to a folder on your computer.

* In preparation for the lab, change the working directory 
* to the folder where you stored these files
cd "pathname"

* Question 2:

use "lab0 wide", clear
list in 1/2

use "lab0 long", clear
list in 1/10

* Question 4:

use "lab0 wide", clear
summ

* Question 5:

* Reshape from wide to long
reshape long y, i(id) j(time)

* Reshape from long to wide
reshape wide y, i(id) j(time)

* Question 6:

use "lab0 long", clear
bys time: summ y

sort id time
by id: gen counter = _n
summ age gender severity if counter==1 


