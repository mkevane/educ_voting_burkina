
**********************************************************************************
* Do file: 
* set directory - in 0.00

* Do file for first-stage regression and second stage regressions dropping the partially treated using the Afrobarometer (5 waves)

* Update; August 26 2022
**********************************************************************************
	set more off
	set matsize 800

* Compact table of first stage regression results	

	use ttt, clear
	
	drop if yrs_fr_eligsch_to_schl_fndg==-1
	drop if yrs_fr_eligsch_to_schl_fndg==-2
	drop if yrs_fr_eligsch_to_schl_fndg==-3
	
	
	local outcome "some_schooling educ_prim_completed educ_sec_some educ"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) keep(treat) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	forval gender = 0(1)1 {
	*No controls
	eststo clear
	foreach x of varlist `outcome' {
	eststo : quietly reghdfe `x' treat if male==`gender' , absorb(round_elec) cluster(villageIDg)
	}
	esttab using "$hd/reg_compacta`gender'partial.tex", `options' replace coeflabel(treat "No cohort or locality controls, drop partial") 
	*Year birth and province
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender' , absorb(year_birth provinceg round_elec) cluster(villageIDg) 
	}
	esttab using "$hd/reg_compacta`gender'partial.tex", append `options' coeflabel(treat "Birth year, province, drop partial") 
	*Year birth and commune
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender' , absorb(year_birth communeg round_elec) cluster(villageIDg)
	}
	esttab using "$hd/reg_compacta`gender'partial.tex", append `options' coeflabel(treat "Birth year, commune, drop partial") 
	*Year birth and village
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender' , absorb(year_birth villageIDg round_elec) cluster(villageIDg)
	}
	esttab using "$hd/reg_compacta`gender'partial.tex", append `options' coeflabel(treat "Birth year, village, drop partial") 

	filefilter "$hd/reg_compacta`gender'partial.tex" "$mkdropapp/App_tab/Tab_stg1_compb1_`gender'partial.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta`gender'partial.tex"
	}
	sleep 10000
	
	forval gender = 0(1)1 {	
	*5 No controls distance 
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender' , absorb(round_elec) cluster(villageIDg)
	}
	esttab using "$hd/reg_compacta`gender'partial.tex", replace `options' coeflabel(treat "No cohort or locality controls, drop partial") 	
	restore
	
	*6 yr birth and province distance
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth provinceg round_elec) cluster(villageIDg)
	}
	esttab using "$hd/reg_compacta`gender'partial.tex", append `options' coeflabel(treat "Birth year, province, drop partial")	
	restore
	*7 5 yr cohort birth and commune distance
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender' , absorb(year_birth communeg round_elec) cluster(villageIDg)
	}
	esttab using "$hd/reg_compacta`gender'partial.tex", append `options' coeflabel(treat "Birth year, commune, drop partial")	
	restore
	*8 5 yr birth and village distance
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender' , absorb(year_birth villageIDg round_elec) cluster(villageIDg)
	}
	esttab using "$hd/reg_compacta`gender'partial.tex", append `options' coeflabel(treat "Birth year, village, drop partial")	
	restore	
	filefilter "$hd/reg_compacta`gender'partial.tex" "$mkdropapp/App_tab/Tab_stg1_compb2_`gender'partial.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta`gender'partial.tex"	
	}
	sleep 10000
	


* Compact table of second stage regression results	
	local depvar "index_eng" 
	local educvar "some_schooling educ_prim_completed educ_sec_some educ"
	global treatment "treat"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	

	forval gender = 0(1)1 {
	*1 No controls 
	eststo clear
	foreach var in `depvar' {
	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly ivreghdfe `var' (xx= $treatment) if male==`gender' , absorb(round_elec ) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compact2SLS_`var'partial.tex", replace `options' keep(xx) coeflabel(xx "No cohort or locality controls, drop partial") 
	
	*2 Year birth and province
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo: quietly ivreghdfe `var' (xx= $treatment) if male==`gender' , absorb(round_elec year_birth provinceg) cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS_`var'partial.tex", append `options' keep(xx) coeflabel(xx "Birth year, province, drop partial") 
	
	*3 5 yr cohort birth and commune
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo: quietly ivreghdfe `var' (xx= $treatment) if male==`gender' , absorb(round_elec year_birth communeg) cluster(villageIDg)
    drop xx
	}
	esttab using "$hd/reg_compact2SLS_`var'partial.tex", append `options' keep(xx) coeflabel(xx "Birth year, commune, drop partial") ///  
			
	filefilter "$hd/reg_compact2SLS_`var'partial.tex" "$mkdropapp/App_tab/Tab_stg2_compb1_`var'_`gender'partial.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compact2SLS_`var'partial.tex"
	}
	sleep 10000
	}	
	
	
	sleep 10000
	
	local depvar "index_eng " 
	local educvar "some_schooling educ_prim_completed educ_sec_some educ"
	global treatment "wei_dist_af"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	forval gender = 0(1)1 {
	*1 No controls 
	eststo clear
	foreach var in `depvar' {
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly ivreghdfe `var'  (xx= $treatment ) if male==`gender', absorb(round_elec )  cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS2_`var'partial.tex", replace `options' keep(xx) coeflabel(xx "No cohort or locality controls, drop partial") 
	est clear
	
	*2 Year birth and province
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly ivreghdfe `var' (xx= $treatment ) if male==`gender' , absorb(round_elec year_birth provinceg) cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS2_`var'partial.tex", append `options' keep(xx) coeflabel(xx "Birth year, province, drop partial") 
	
	*5 yr cohort birth and commune distance
	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly ivreghdfe `var' (xx= $treatment ) if male==`gender' , absorb(round_elec year_birth communeg)   cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS2_`var'partial.tex", append `options' keep(xx) coeflabel(xx "Birth year, commune, drop partial") 

	filefilter "$hd/reg_compact2SLS2_`var'partial.tex" "$mkdropapp/App_tab/Tab_stg2_compb2_`var'_`gender'partial.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compact2SLS2_`var'partial.tex"
	}
	sleep 10000
	}
	


