**********************************************************************************
* Do file for second-stage regression using the Afrobarometer (5 waves)
* Education attainment affect political participation
* Do file: 0.31 1st stage reg 2SLS with migration v2.do
* set directory - in 0.00
* Update; December 17 2022

**********************************************************************************

	set more off
	set matsize 800
	use ttt, clear
	
	corr migrant_ratio_1996_census migrant_rate_DHS migrant_rate_fichier
	sum migrant_ratio_1996_census migrant_rate_DHS migrant_rate_fichier
	local outcome "some_schooling educ_prim_completed educ_sec_some educ"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) keep(treat) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	local migvar "migrant_ratio_1996_census migrant_rate_DHS migrant_rate_fichier" 
	
	*** IV= treat
	forval gender = 0(1)1 {
		
	foreach mig in `migvar' {

	*1 No controls
	eststo clear
	foreach x of varlist `outcome' {
	eststo : quietly reghdfe `x' treat  `mig'  if male==`gender', absorb(round_elec) cluster(villageIDg)
	}
	esttab using "$hd/reg_compacta`gender'.tex", `options' replace coeflabel(treat "No cohort or locality controls") 
	*2 Year birth and province
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' treat  `mig' if male==`gender', absorb(year_birth provinceg round_elec) cluster(villageIDg) 
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' coeflabel(treat "Birth year, province") 

	filefilter "$hd/reg_compacta`gender'.tex" "$mkdropapp/App_tab/Tab_stg1_iv1_`mig'_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta`gender'.tex"
	}
	sleep 10000
	}

	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) keep(wei_dist_af) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	

	*** IV= weighted number of schools
	forval gender = 0(1)1 {
		
	foreach mig in `migvar' {

	*1 No controls
	eststo clear
	foreach x of varlist `outcome' {
	eststo : quietly reghdfe `x' wei_dist_af  `mig'  if male==`gender', absorb(round_elec) cluster(villageIDg)
	}
	esttab using "$hd/reg_compacta`gender'.tex", `options' replace coeflabel(wei_dist_af "No cohort or locality controls") 
	*2 Year birth and province
	est clear
	foreach x of varlist `outcome' {
	eststo: quietly reghdfe `x' wei_dist_af  `mig' if male==`gender', absorb(year_birth provinceg round_elec) cluster(villageIDg) 
	}
	esttab using "$hd/reg_compacta`gender'.tex", append `options' coeflabel(wei_dist_af "Birth year, province") 


	filefilter "$hd/reg_compacta`gender'.tex" "$mkdropapp/App_tab/Tab_stg1_iv2_`mig'_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta`gender'.tex"
	}
	sleep 10000
	}

