**********************************************************************************
* Do file for second-stage regression using the Afrobarometer (5 waves)
* Education attainment affect political participation
* Do file: 0.13 2nd stage reg 2SLS - index engagement educ in columns ivreghdfe v4.do
* set directory - in 0.00
* Update; August 26 2022

* takes about 1 minute to do one dependent variable, for the 9 specifications.
**********************************************************************************

	set more off
	set matsize 800
	use ttt, clear

	* Compact table of second stage regression results	 -- 5 year cohort
	* First with treatment as school presence dummy, then with treatment as weighted number of schools
	* option f in esttab makes it a fragment 
	local depvar "index_eng" 
	local educvar "some_schooling educ_prim_completed educ_sec_some educ"
	global treatment "treat"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	

	forval gender = 0(1)1 {
	foreach var in `depvar' {

	*5 year cohort and province
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo: quietly ivreghdfe `var' (xx= $treatment) if male==`gender', absorb(round_elec halfdecade provinceg) cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS_`var'.tex", replace `options' keep(xx) coeflabel(xx "5-year cohort, province") 
	
	*5 year cohort and commune
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo: quietly ivreghdfe `var' (xx= $treatment) if male==`gender', absorb(round_elec halfdecade communeg) cluster(villageIDg)
    drop xx
	}
	esttab using "$hd/reg_compact2SLS_`var'.tex", append `options' keep(xx) coeflabel(xx "5-year cohort, commune") ///  
			
	filefilter "$hd/reg_compact2SLS_`var'.tex" "$mkdropapp/App_tab/Tab_stg2_comphalf_b1_`var'_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compact2SLS_`var'.tex"
	}
	sleep 10000
	}	
	
	sleep 10000
	
	use ttt, clear
	local depvar "index_eng " 
	local educvar "some_schooling educ_prim_completed educ_sec_some educ"
	global treatment "wei_dist_af"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	forval gender = 0(1)1 {
	foreach var in `depvar' {
	
	*5 year cohort and province
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly ivreghdfe `var' (xx= $treatment ) if male==`gender', absorb(round_elec halfdecade provinceg) cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS2_`var'.tex", replace `options' keep(xx) coeflabel(xx "5-year cohort, province") 
	
	*5 year cohort and commune 
	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly ivreghdfe `var' (xx= $treatment ) if male==`gender', absorb(round_elec halfdecade communeg)   cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS2_`var'.tex", append `options' keep(xx) coeflabel(xx "5-year cohort, commune") 

	filefilter "$hd/reg_compact2SLS2_`var'.tex" "$mkdropapp/App_tab/Tab_stg2_comphalf_b2_`var'_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compact2SLS2_`var'.tex"
	}
	sleep 10000
	}
	
	
	
