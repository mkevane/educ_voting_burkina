**********************************************************************************
* F-stats for first stage regression
* Education attainment explained by whether village ever had school
* Do file for first-stage regression using the Afrobarometer (5 waves)
* Schools affect education attainment

* Update; August 26 2022

* Do file: 0.12 first stage regression - schools affect education Afrobarometer.do
* set directory - in 0.00

**********************************************************************************
	set more off
	set matsize 800

* Compact table of first stage regression results	ONLY F-stat ---- birth year 
	* option f in esttab seems to suppress titles makes it a fragment useful for Latex
	* notice option keep(treat)
	* if want F-stat then scalar(F p_value)
	forval gender = 0(1)1 {
	local outcome "some_schooling educ_prim_completed educ_sec_some educ"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) drop(*) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	use ttt, clear
	*1 No controls
	eststo clear
	foreach x of varlist `outcome' {
	eststo : quietly reghdfe `x' treat if male==`gender', absorb(round_elec) cluster(villageIDg)
	quietly test treat
	estadd r(F), replace
	}
	esttab ,`options' stats(F, labels("No cohort or locality controls"))
	esttab using "$hd/reg_compacta`gender'.tex", `options' replace stats(F, labels("No cohort or locality controls") fmt(%9.1f))
	*2 Year birth and province
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth provinceg round_elec) cluster(villageIDg) 
	quietly test treat
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' stats(F, labels("Birth year, province") fmt(%9.1f))
	*3 5 yr cohort birth and commune
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth communeg round_elec) cluster(villageIDg)
	quietly test treat
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' stats(F, labels("Birth year, commune") fmt(%9.1f))
	*4 year birth and village
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth villageIDg round_elec) cluster(villageIDg)
	quietly test treat
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' stats(F, labels("Birth year, village") fmt(%9.1f))

	filefilter "$hd/reg_compacta`gender'.tex" "$mkdropapp/App_tab/Tab_stg1_compbFstat1_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta`gender'.tex"	
	}
	sleep 5000
	
	forval gender = 0(1)1 {
	*5 No controls
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(round_elec) cluster(villageIDg)
	quietly test treat 
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", replace `options' stats(F, labels("No cohort or locality controls") fmt(%9.1f))	
	restore
	
	*6 5 yr birth and province
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth provinceg round_elec) cluster(villageIDg)
	quietly test treat 
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' stats(F, labels("Birth year, province") fmt(%9.1f))	
	restore
	*7 5 yr cohort birth and commune
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth communeg round_elec) cluster(villageIDg)
	quietly test treat 
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' stats(F, labels("Birth year, commune") fmt(%9.1f))	
	restore
	*8 5 yr birth and village
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(year_birth villageIDg round_elec) cluster(villageIDg)
	quietly test treat 
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' stats(F, labels("Birth year, village")	fmt(%9.1f))
	restore
	
	filefilter "$hd/reg_compacta`gender'.tex" "$mkdropapp/App_tab/Tab_stg1_compbFstat2_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta`gender'.tex"		
	}
	
	
	* Compact table of first stage regression results	ONLY F-stat -- halfdecade
	* option f in esttab seems to suppress titles makes it a fragment useful for Latex
	* notice option keep(treat)
	* if want F-stat then scalar(F p_value)
	forval gender = 0(1)1 {
	local outcome "some_schooling educ_prim_completed educ_sec_some educ"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) drop(*) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	use ttt, clear

	*2 Year birth and province
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade provinceg round_elec) cluster(villageIDg) 
	quietly test treat
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", replace `options' stats(F, labels("5-year cohort, province") fmt(%9.1f))
	*3 5 yr cohort birth and commune
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade communeg round_elec) cluster(villageIDg)
	quietly test treat
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' stats(F, labels("5-year cohort, commune") fmt(%9.1f))
	*4 year birth and village
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade villageIDg round_elec) cluster(villageIDg)
	quietly test treat
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' stats(F, labels("5-year cohort, village") fmt(%9.1f))

	filefilter "$hd/reg_compacta`gender'.tex" "$mkdropapp/App_tab/Tab_stg1_compbhalfdecade_Fstat1_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta`gender'.tex"	
	}
	sleep 5000
	
	forval gender = 0(1)1 {
	
	*6 5 yr birth and province
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade provinceg round_elec) cluster(villageIDg)
	quietly test treat 
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", replace `options' stats(F, labels("5-year cohort, province") fmt(%9.1f))	
	restore
	*7 5 yr cohort birth and commune
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade communeg round_elec) cluster(villageIDg)
	quietly test treat 
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' stats(F, labels("5-year cohort, commune") fmt(%9.1f))	
	restore
	*8 5 yr birth and village
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat if male==`gender', absorb(halfdecade villageIDg round_elec) cluster(villageIDg)
	quietly test treat 
	estadd r(F), replace
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' stats(F, labels("5-year cohort, village")	fmt(%9.1f))
	restore
	
	filefilter "$hd/reg_compacta`gender'.tex" "$mkdropapp/App_tab/Tab_stg1_compbhalfdecade_Fstat2_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta`gender'.tex"		
	}
	
	
