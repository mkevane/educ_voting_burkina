**********************************************************************************
* Do file for reduced form regressions using the Afrobarometer (5 waves)
* Access to primary schools affects the index of political engagement

* Update: sept 3 2022 Elodie

* Do file: 0.14 Reduced form Panel v3.do
* set directory - in 0.00

**********************************************************************************

* Education attainment explained by whether village ever had school
	set more off
	set matsize 800
	use ttt, clear

* Compact table of first stage regression results	
	* option f in esttab seems to suppress titles makes it a fragment useful for Latex
	* notice option keep(treat)

	local outcome "index_eng"
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) keep(treat) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	
	use ttt, clear

	** PANEL A: IV= treat 
	
	*No controls
	eststo clear
	foreach x of varlist `outcome' {
	eststo : quietly reghdfe `x' treat , absorb(round_elec) cluster(villageIDg)
	eststo : quietly reghdfe `x' treat if male==1, absorb(round_elec) cluster(villageIDg)
	eststo : quietly reghdfe `x' treat if male==0, absorb(round_elec) cluster(villageIDg)

	esttab using "$hd/reg_compacta.tex", `options' replace coeflabel(treat "No cohort or locality controls") 
	*Year birth and province
	eststo clear

	eststo: quietly reghdfe `x' treat , absorb(year_birth provinceg round_elec) cluster(villageIDg) 
	eststo: quietly reghdfe `x' treat if male==1, absorb(year_birth provinceg round_elec) cluster(villageIDg) 
	eststo: quietly reghdfe `x' treat if male==0, absorb(year_birth provinceg round_elec) cluster(villageIDg) 

	esttab using "$hd/reg_compacta.tex", append `options' coeflabel(treat "Birth year, province") 
	*Year birth and commune
	eststo clear

	eststo: quietly reghdfe `x' treat , absorb(year_birth communeg round_elec) cluster(villageIDg)
	eststo: quietly reghdfe `x' treat if male==1, absorb(year_birth communeg round_elec) cluster(villageIDg)
	eststo: quietly reghdfe `x' treat if male==0, absorb(year_birth communeg round_elec) cluster(villageIDg)

	esttab using "$hd/reg_compacta.tex", append `options' coeflabel(treat "Birth year, commune") 


	filefilter "$hd/reg_compacta.tex" "$mkdropapp/App_tab/Tab_RedF_treat.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta.tex"
	}
	sleep 10000
	
	
	** PANEL B: IV= wei_dist_af
	local options "f b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) keep(wei_dist_af) label booktabs nodep nonum nomtitles nolines noobs nonotes collabels(none) alignment(D{.}{.}{-1})"	

	*No controls
	eststo clear
	foreach x of varlist `outcome' {
	eststo : quietly reghdfe `x' wei_dist_af , absorb(round_elec) cluster(villageIDg)
	eststo : quietly reghdfe `x' wei_dist_af if male==1, absorb(round_elec) cluster(villageIDg)
	eststo : quietly reghdfe `x' wei_dist_af if male==0, absorb(round_elec) cluster(villageIDg)

	esttab using "$hd/reg_compacta.tex", `options' replace coeflabel(wei_dist_af "No cohort or locality controls") 
	*Year birth and province
	eststo clear

	eststo: quietly reghdfe `x' wei_dist_af , absorb(year_birth provinceg round_elec) cluster(villageIDg) 
	eststo: quietly reghdfe `x' wei_dist_af if male==1, absorb(year_birth provinceg round_elec) cluster(villageIDg) 
	eststo: quietly reghdfe `x' wei_dist_af if male==0, absorb(year_birth provinceg round_elec) cluster(villageIDg) 

	esttab using "$hd/reg_compacta.tex", append `options' coeflabel(wei_dist_af "Birth year, province") 
	*Year birth and commune
	eststo clear

	eststo: quietly reghdfe `x' wei_dist_af , absorb(year_birth communeg round_elec) cluster(villageIDg)
	eststo: quietly reghdfe `x' wei_dist_af if male==1, absorb(year_birth communeg round_elec) cluster(villageIDg)
	eststo: quietly reghdfe `x' wei_dist_af if male==0, absorb(year_birth communeg round_elec) cluster(villageIDg)

	esttab using "$hd/reg_compacta.tex", append `options' coeflabel(wei_dist_af "Birth year, commune") 


	filefilter "$hd/reg_compacta.tex" "$mkdropapp/App_tab/Tab_RedF_wei_dist_af.tex", from("\BSaddlinespace") to(" ")	replace
	erase "$hd/reg_compacta.tex"
	}
	sleep 10000
	
	
