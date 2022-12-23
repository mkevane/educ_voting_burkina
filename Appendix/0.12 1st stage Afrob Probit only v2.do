**********************************************************************************
* Do file: 0.12 Probit first stage regression - schools affect education Afrobarometer.do
* set directory - in 0.00

* Education attainment explained by whether village ever had school
* Do file for first-stage regression using the Afrobarometer (5 waves) with Probit
* Schools affect education attainment

* Update; August 26 2022
**********************************************************************************
	set more off
	set matsize 800

	timer clear 1
	timer on 1
	
* Compact table of first stage regression results	
	* option f in esttab seems to suppress titles makes it a fragment useful for Latex
	* notice option keep(treat)
	* if want F-stat then scalar(F p_value)
	use ttt, clear
	local outcome "some_schooling educ_prim_completed educ_sec_some"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) keep(treat) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	

	use ttt, clear
	forval gender = 0(1)1 {
	*No controls
	eststo clear
	foreach x of varlist `outcome'  {
	quietly probit `x' treat i.round_elec if male==`gender', cluster(villageIDg)
	eststo: quietly margins, dydx(treat) predict() post 
	}
	esttab  using "$hd/reg_compacta`gender'.tex", `options' replace coeflabel(treat "No cohort or locality controls") 
	*Year birth and province
	est clear
	foreach x of varlist `outcome' {
	quietly probit `x' treat i.round_elec i.year_birth i.provinceg if male==`gender', cluster(villageIDg) 
	eststo: quietly margins, dydx(treat) predict() post 
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, province") 
	*Year birth and commune
	est clear
	foreach x of varlist `outcome' {
	quietly probit `x' treat i.round_elec i.year_birth i.communeg if male==`gender', cluster(villageIDg)
	eststo: quietly margins, dydx(treat) predict() post 
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, commune") 
	*Year birth and village
	est clear
	foreach x of varlist `outcome' {
	quietly probit `x' treat i.round_elec i.year_birth i.villageIDg if male==`gender', cluster(villageIDg)
	eststo: quietly margins, dydx(treat) predict() post 
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, village") 

	
	filefilter "$hd/reg_compacta`gender'.tex" "$mkdropapp/App_tab/Tab_stg1_prob_compb1_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta`gender'.tex"
	}
	sleep 10000
	
	forval gender = 0(1)1 {	
	*No controls  
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	quietly probit `x' treat i.round_elec if male==`gender', cluster(villageIDg)
	eststo: quietly margins, dydx(treat) predict() post 
	}
	esttab using "$hd/reg_compacta`gender'.tex", replace `options' coeflabel(treat "No cohort or locality controls") 	
	restore
	
	*Year birth and province
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	quietly probit `x' treat i.round_elec i.year_birth i.provinceg if male==`gender', cluster(villageIDg)
	eststo: quietly margins, dydx(treat) predict() post 
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, province")	
	restore
	*Year birth and commune 
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	quietly probit `x' treat i.round_elec i.year_birth i.communeg if male==`gender', cluster(villageIDg)
	eststo: quietly margins, dydx(treat) predict() post 
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, commune")	
	restore
	*Year birth and village
	est clear
	preserve
	replace treat=wei_dist_af
	foreach x of varlist `outcome' {
	quietly probit `x' treat i.round_elec i.year_birth i.villageIDg if male==`gender', cluster(villageIDg)
	eststo: quietly margins, dydx(treat) predict() post 
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, village")	
	restore	
	filefilter "$hd/reg_compacta`gender'.tex" "$mkdropapp/App_tab/Tab_stg1_prob_compb2_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta`gender'.tex"	
	}
	sleep 10000
	
	
