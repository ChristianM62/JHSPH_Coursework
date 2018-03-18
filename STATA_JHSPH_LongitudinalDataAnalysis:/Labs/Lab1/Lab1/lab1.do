* Set the random seed so we can replicate our generated data
set seed 12275
* Define the mean, standard deviation and correlation matrix
matrix m = (35, 38, 43, 49, 48)
matrix sd = (10,10,10,10,10)
matrix C = (1, 0.85, 0.80, 0.72, 0.69, 1, 0.85, 0.80, 0.72, 1, 0.85, 0.80, 1, 0.85, 1)
* Generate the k-variate normal data
drawnorm y0 y1 y2 y3 y4, n(100) corr(C) cstorage(upper) means(m) sds(sd)
gen id = _n

* Reshape from wide to long
reshape long y, i(id) j(time)

* Create a figure with boxplots at each timepoint
xtset id time
label define mytime 0 "Baseline" 1 "Month 1" 2 "Month 2" 3 "Month 3" 4 "Month 4"
label values time mytime
graph box y, over(time) ylab(0(25)75, angle(horizontal)) ytitle(SF-36 mental health scores)

* Create a spaghetti plot
bys time: egen mean_y = mean(y)
sort id time
twoway (line y time, c(L) lc(black) legend(off) xtitle(Time from hospital discharge (in months)) ytitle(SF-36 mental health score) ylab(0(25)75, angle(horizontal))) ///
(line mean_y time, sort c(l) lc(red) lw(thick))

