** Open the exercise therapy trial to obtain the 
** "guestimates" for the simulation of data from
** a mixed model
use "exercise therapy.dta", clear
mixed y time i.trt#c.time || id: time, cov(uns)

** Generate data that you may see in a larger version 
** of the exercise therapy trial
clear

********************************************************************
** Step 1: Generate the random intercept and slope for each subject
********************************************************************
* Set the random seed so we can replicate our generated data
set seed 12275
* Define the mean, standard deviation and correlation between the random effects
matrix m = (0,0)
matrix sd = (sqrt(9.7),sqrt(0.03))
matrix C = (1, -0.02, 1)
* Generate the bivariate normal random intercept and slope
drawnorm b0 b1, n(500) corr(C) cstorage(upper) means(m) sds(sd)
gen id = _n
gen trt = 1
replace trt = 0 if id >= 251

********************************************************************
** Step 2: Compute the mean strength measure at each time for 
** each subject
********************************************************************
foreach i of numlist 0 2 4 6 8 10 12 {
	gen mu`i' = (81 + b0) + (0.11 + b1) * `i' + 0.06 * `i' * trt
}

********************************************************************
** Step 3: Reshape the data and calculate Y_ij
********************************************************************
reshape long mu, i(id) j(time)
gen e = rnormal(0,sqrt(0.65))
gen y = mu + e


** Fit the mixed model to the simulated trial data
mixed y time i.trt#c.time || id: time, cov(uns)


** Create a binary outcome: an indicator for improvement in strength from baseline
sort id time
by id: gen baseliney = y[1]
gen biny = 1 if y > baseliney
replace biny = 0 if y <= baseliney

** Fit the mixed logistic model, use the default number of integration points 7.
meqrlogit biny time i.trt#c.time if time > 0 || id: time, cov(uns) intp(7)
