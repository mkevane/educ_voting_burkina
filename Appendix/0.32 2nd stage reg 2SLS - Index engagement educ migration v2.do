**********************************************************************************
* Do file for second-stage regression using the Afrobarometer (5 waves)
* Education attainment affect political participation
* Do file: 0.32 2nd stage reg 2SLS -Index engagement educ migration v2.do
* set directory - in 0.00
* Update; December 17, 2022

**********************************************************************************

	set more off
	set matsize 800
	use ttt.dta, clear
	timer clear 1
	timer on 1

corr migrant_ratio_1996_census migrant_rate_DHS migrant_rate_fichier
sum migrant_ratio_1996_census migrant_rate_DHS migrant_rate_fichier


* Compact table of second stage regression results	----- birth year
	* option f in esttab makes it a fragment 
	*use ttt, clear
	local depvar "index_eng"
	local migvar "migrant_ratio_1996_census migrant_rate_DHS migrant_rate_fichier" 
	local educvar "some_schooling educ_prim_completed educ_sec_some educ"
	global treatment "treat"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	

	forval gender = 0(1)1 {
	*1 No controls 
	eststo clear
	foreach var in `depvar' {
	eststo clear
	
	foreach mig in `migvar' {
	eststo clear
	
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly ivreghdfe `var' `mig'  (xx= $treatment) if male==`gender', absorb(round_elec ) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compact2SLS_`var'_`mig'.tex", replace `options' keep(xx) coeflabel(xx "No cohort or locality controls") 
	
	*2 Year birth and province
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo: quietly ivreghdfe `var' `mig' (xx= $treatment) if male==`gender', absorb(round_elec year_birth provinceg) cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS_`var'_`mig'.tex", append `options' keep(xx) coeflabel(xx "Birth year, province") 

			
	filefilter "$hd/reg_compact2SLS_`var'_`mig'.tex" "$mkdropapp/App_tab/Tab_stg2_compb1_`var'_`gender'_`mig'.tex", from("\BSaddlinespace") to(" ")	replace
*	filefilter "$hd/reg_compact2SLS_`var'.tex" "$mkdropapp_bm/Tab_stg2_compb1_`var'_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compact2SLS_`var'_`mig'.tex"
	}
	sleep 10000
	}	
	}
	
	sleep 10000
	
	**** IV= weighted average, results stored in the letter
	
	local depvar "index_eng " 
	local migvar "migrant_ratio_1996_census migrant_rate_DHS migrant_rate_fichier" 
	local educvar "some_schooling educ_prim_completed educ_sec_some educ"
	global treatment "wei_dist_af"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	forval gender = 0(1)1 {
	*1 No controls 
	eststo clear
	foreach var in `depvar' {
	est clear
	
	foreach mig in `migvar' {
	eststo clear
	
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly ivreghdfe `var' `mig'  (xx= $treatment ) if male==`gender', absorb(round_elec )  cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS2_`var'_`mig'.tex", replace `options' keep(xx) coeflabel(xx "No cohort or locality controls") 
	est clear
	
	*2 Year birth and province
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly ivreghdfe `var' `mig'  (xx= $treatment ) if male==`gender', absorb(round_elec year_birth provinceg) cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS2_`var'_`mig'.tex", append `options' keep(xx) coeflabel(xx "Birth year, province") 
	

	filefilter "$hd/reg_compact2SLS2_`var'_`mig'.tex" "$mkdropapp/App_tab/Tab_stg2_compb2_`var'_`gender'_`mig'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compact2SLS2_`var'_`mig'.tex"
	}
	sleep 10000
	}
	}
	