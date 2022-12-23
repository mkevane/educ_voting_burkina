**********************************************************************************
* Do file: 0.12 first stage regression - schools affect education Afrobarometer v2.do
* set directory - in 0.00

* Education attainment explained by whether village ever had school
* Do file for first-stage regression using the Afrobarometer (5 waves)
* Schools affect education attainment

* Update; August 26 2022
**********************************************************************************
	set more off
	set matsize 800

* Compact table of first stage regression results	--- birth year dummy variables
	* option f in esttab seems to suppress titles makes it a fragment useful for Latex
	* notice option keep(treat)
	* if want F-stat then scalar(F p_value)
	use ttt, clear
	local outcome "some_schooling educ_prim_completed educ_sec_some educ"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) keep(treat) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	use ttt, clear
	forval gender = 0(1)1 {
	*1 No controls
	eststo clear
	foreach x of varlist `outcome' {
	eststo : quietly reghdfe `x' treat if male==`gender', absorb(round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", `options' replace coeflabel(treat "No cohort or locality controls") 
	*2 Year birth and province
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth provinceg round_elec) cluster(villageIDg) 
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, province") 
	*3 5 yr cohort birth and commune
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth communeg round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, commune") 
	*4 5 yr birth and village
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth villageIDg round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, village") 

	filefilter "$mkdropapp/Main_tab/reg_compacta`gender'.tex" "$mkdropapp/Main_tab/Tab_stg1_compb1_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$mkdropapp/Main_tab/reg_compacta`gender'.tex"
	}
	sleep 10000
	
	forval gender = 0(1)1 {	
	*5 No controls distance 
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", replace `options' coeflabel(treat "No cohort or locality controls") 	
	restore
	*6 yr birth and province distance
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth provinceg round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, province")	
	restore
	*7 5 yr cohort birth and commune distance
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth communeg round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, commune")	
	restore
	*8 5 yr birth and village distance
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth villageIDg round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, village")	
	restore	
	filefilter "$mkdropapp/Main_tab/reg_compacta`gender'.tex" "$mkdropapp/Main_tab/Tab_stg1_compb2_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$mkdropapp/Main_tab/reg_compacta`gender'.tex"	
	}
	sleep 10000
	
	* Compact table of first stage regression results	--- 5 year cohort dummy variables

	use ttt, clear
	local outcome "some_schooling educ_prim_completed educ_sec_some educ"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) keep(treat) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	use ttt, clear
	forval gender = 0(1)1 {

	*2 Year birth and province
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade provinceg round_elec) cluster(villageIDg) 
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", replace `options' coeflabel(treat "5-year cohort, province") 
	*3 5 yr cohort birth and commune
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade communeg round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", append `options' coeflabel(treat "5-year cohort, commune") 
	*4 5 yr birth and village
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade villageIDg round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", append `options' coeflabel(treat "5-year cohort, village") 

	filefilter "$mkdropapp/Main_tab/reg_compacta`gender'.tex" "$mkdropapp/Main_tab/Tab_stg1_comphalfdecadeb1_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$mkdropapp/Main_tab/reg_compacta`gender'.tex"
	}
	sleep 10000
	
	forval gender = 0(1)1 {	
	
	*6 yr birth and province distance
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade provinceg round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", replace `options' coeflabel(treat "5-year cohort, province")	
	restore
	*7 5 yr cohort birth and commune distance
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade communeg round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", append `options' coeflabel(treat "5-year cohort, commune")	
	restore
	*8 5 yr birth and village distance
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade villageIDg round_elec) cluster(villageIDg)
	}
	esttab using "$mkdropapp/Main_tab/reg_compacta`gender'.tex", append `options' coeflabel(treat "5-year cohort, village")	
	restore	
	filefilter "$mkdropapp/Main_tab/reg_compacta`gender'.tex" "$mkdropapp/Main_tab/Tab_stg1_comphalfdecadeb2_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$mkdropapp/Main_tab/reg_compacta`gender'.tex"	
	}
	sleep 10000

