* I. Working directory

	* What is the current working directory
	pwd

	* What files are in the current working directory
	dir
	ls

	* You can change the working directory to the folder where you have data stored
	cd "C:\data"
	
* II. Do files
	*the path and name of the files are specific to your computer; 
	*change the directory to where you have saved the files for use in lab 1 
	cd "C:\Users\ejohnson\Documents\LDA2013" 
 
	log using "lab1.log", replace 
	insheet using "pigs.csv" 
	save "pigs.dta", replace

* III. Reading Data

	* Read in existing dataset
	use pigs, clear
	
	* Read in .raw or .data files
	infile weight1 weight2 weight3 weight4 weight5 weight6 weight7 weight8 weight9 Id using "pigs.raw.txt", clear
	
	* Read in .csv files from packages such as Excel 
	insheet using "pigs.csv", comma clear 

* IV. ADO files

	adopath
	** Use the pigs data in the long format
	use pigs.dta, clear
	reshape long weight, i(id) j(time)
	** Declare the data a panel dataset
	xtset id time
	** run xtgraph.ado in the do-file editor FIRST 
	xtgraph weight, ti("Mean trend vs time") bar(ci)
	
* V. Convert data from wide to long format, and vice versa

	* Demonstration of the reshape command
	use pigs.dta, clear
	* List the first two observations
	list in 1/2 
	* Reshape to a long format
	reshape long weight, i(id) j(time)
	list in 1/5
	* Reshape back to long format
	reshape wide weight, i(id) j(time) 

* Part B: Longitudinal data analysis commands to get started	
	
* I. xtset

	use "endoflifemedicarecosts20032007_long", clear
	*Check to see if stata recognizes data as longitudinal  
 	xtset 
 	*Set data as longitudinal using xtset command
	xtset statenum year 
	* What does xtset know now?
	xtset 
	
* II. xtdes
	use "endoflifemedicarecosts20032007_long", clear 
	xtset statenum year
	xtdes

* III: xtgraph
xtgraph cost, av(median) bar(iqr) t1("median, iqr")

