**********************************************************************************
* Do file for second-stage regression using the Afrobarometer (5 waves)
* Education attainment affect political participation
* Do file: 0.20 additional reg OLS v4.do
* set directory - in 0.00
* Update; dec 12 2022
************************************************** 
**********************************************************************************
* Create dataset to be used for estimation
	set more off
	set matsize 800
	use ttt, clear
	timer clear 1
	timer on 1

* Compact table of second stage regression results	
	* option f in esttab makes it a fragment 
	use ttt, clear
	local educvar "some_schooling educ_prim_completed educ_sec_some educ"
	local depvar "index_eng voted_yes part_comm_grp_dum part_join_issue_dum part_meeting_dum" 
	global treatment "treat"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	

	*1 index_eng 
	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe index_eng xx if male==1 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", replace `options' keep(xx)  coeflabel(xx "1. Index, male sample") 

	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe index_eng xx if male==0 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", append `options' keep(xx)  coeflabel(xx "1. Index, female sample") 

	*2 voted_yes
	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe voted_yes xx if male==1 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", append `options' keep(xx)  coeflabel(xx "2. Voting, male sample") 

	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe voted_yes xx if male==0 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", append `options' keep(xx)  coeflabel(xx "2. Voting, female sample") 
	
	*4 part_join_issue_dum 
	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe part_join_issue_dum xx if male==1 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", append `options' keep(xx)  coeflabel(xx "3. Joining issue, male sample") 

	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe part_join_issue_dum xx if male==0 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", append `options' keep(xx)  coeflabel(xx "3. Joining issue, female sample") 

	
	*5 part_meeting_dum
	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe part_meeting_dum xx if male==1 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", append `options' keep(xx)  coeflabel(xx "4. Part. meeting, male sample") 

	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe part_meeting_dum xx if male==0 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", append `options' keep(xx)  coeflabel(xx "4. Part. meeting, female sample") 

	*3 part_comm_grp_dum
	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe part_comm_grp_dum xx if male==1 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", append `options' keep(xx)  coeflabel(xx "5. Part. in community group, male sample") 

	eststo clear
	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe part_comm_grp_dum xx if male==0 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", append `options' keep(xx)  coeflabel(xx "5. Part. in community group, female sample") 
	
	filefilter "$hd/reg_compactOLS.tex" "$mkdropapp/App_tab/Tab_ols_compact.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compactOLS.tex"


x88888888888888888888888888888888888888888888888888888888888888	

	*1 index_eng 
	eststo clear
	foreach var in `depvar' {
	eststo clear

	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe index_eng xx if male==1 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", replace `options' keep(xx)  coeflabel(xx "1. `var', men sample") 

	foreach x in `educvar' { 
	gen xx=`x'
 	eststo: quietly reghdfe index_eng xx if male==0 , absorb(round_elec) cluster(villageIDg)
	drop xx
	}
	esttab using "$hd/reg_compactOLS.tex", append `options' keep(xx)  coeflabel(xx "1. `var', women sample") 

	*2 Year birth and province
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo: quietly reghdfe `var' male xx, absorb(round_elec year_birth provinceg) cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compactOLS_`var'.tex", append `options' keep(xx) coeflabel(xx "2. Birth year, province") 
	
	*3 5 yr cohort birth and commune
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo: quietly reghdfe `var' male xx, absorb(round_elec halfdecade communeg) cluster(villageIDg)
    drop xx
	}
	esttab using "$hd/reg_compactOLS_`var'.tex", append `options' keep(xx) coeflabel(xx "3. 5-year cohort, commune") ///  
			
	*4 5 yr cohort birth and commune drop partially treated
	est clear
	foreach x in `educvar' { 
	gen xx=`x'
	eststo : quietly reghdfe `var' male xx if yrs_fr_eligsch_to_schl_fndg<-4 | yrs_fr_eligsch_to_schl_fndg>-1, absorb(round_elec halfdecade communeg) cluster(villageIDg) 
	drop xx
	}
	esttab using "$hd/reg_compactOLS_`var'.tex", append `options' keep(xx) coeflabel(xx "4. 5-year cohort, commune, drop partial") 
	
	*erase "$hd/reg_compactOLS_`x'.tex"
	}
	timer off 1
	timer list 1
	beep
	
	
