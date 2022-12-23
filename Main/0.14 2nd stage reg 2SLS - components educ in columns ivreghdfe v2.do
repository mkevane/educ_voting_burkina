**********************************************************************************
* Do file for second-stage regression using the Afrobarometer (5 waves)
* Education attainment affect political participation
* Do file: 0.13 2nd stage reg - outcome var= each component
* set directory - in 0.00
* Update; 26 august 2022

**********************************************************************************

	set more off
	set matsize 800
	timer clear 1
	timer on 1

* Compact table of second stage regression results	
	* option f in esttab makes it a fragment 
	use ttt, clear
	local depvar "voted_yes part_comm_grp_dum part_join_issue_dum part_meeting_dum" 
	local educvar "some_schooling educ_prim_completed educ_sec_some educ"
	global treatment "treat"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	

	forval gender = 0(1)1 {
	*No controls 
	eststo clear
	foreach var in `depvar' {
	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly ivreghdfe `var' (xx= $treatment) if male==`gender', absorb(round_elec ) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compact2SLS_`var'.tex", replace `options' keep(xx) coeflabel(xx "No cohort or locality controls") 
	
	*Year birth and province
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo: quietly ivreghdfe `var' (xx= $treatment) if male==`gender', absorb(round_elec year_birth provinceg) cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS_`var'.tex", append `options' keep(xx) coeflabel(xx "Birth year, province") 
	
	*Year birth and commune
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo: quietly ivreghdfe `var' (xx= $treatment) if male==`gender', absorb(round_elec year_birth communeg) cluster(villageIDg)
    drop xx
	}
	esttab using "$hd/reg_compact2SLS_`var'.tex", append `options' keep(xx) coeflabel(xx "Birth year, commune") ///  
			
	filefilter "$hd/reg_compact2SLS_`var'.tex" "$mkdropapp/Main_tab/Tab_stg2_compb1_`var'_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compact2SLS_`var'.tex"
	}
	sleep 10000
	}	
	
	
	sleep 10000
	
	use ttt, clear
	local depvar "voted_yes part_comm_grp_dum part_join_issue_dum part_meeting_dum" 
	local educvar "some_schooling educ_prim_completed educ_sec_some educ"
	global treatment "wei_dist_af"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	forval gender = 0(1)1 {
	*No controls 
	eststo clear
	foreach var in `depvar' {
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly ivreghdfe `var'  (xx= $treatment ) if male==`gender', absorb(round_elec )  cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS2_`var'.tex", replace `options' keep(xx) coeflabel(xx "No cohort or locality controls") 
	est clear
	
	*Year birth and province
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly ivreghdfe `var' (xx= $treatment ) if male==`gender', absorb(round_elec year_birth provinceg) cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS2_`var'.tex", append `options' keep(xx) coeflabel(xx "Birth year, province") 
	
	*Year birth and commune 
	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly ivreghdfe `var' (xx= $treatment ) if male==`gender', absorb(round_elec year_birth communeg)   cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compact2SLS2_`var'.tex", append `options' keep(xx) coeflabel(xx "Birth year, commune") 

	filefilter "$hd/reg_compact2SLS2_`var'.tex" "$mkdropapp/Main_tab/Tab_stg2_compb2_`var'_`gender'.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compact2SLS2_`var'.tex"
	}
	sleep 10000
	}
	

