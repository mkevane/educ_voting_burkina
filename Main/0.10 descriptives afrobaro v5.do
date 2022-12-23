**********************************************************************************
* Do file for descriptive statistics and graphs using the Afrobarometer (4 waves:  and 2018)
* Schools affect education attainment

* Updated: Feb 7 2021

* Do file: 0.10 descriptives afrobaro.do
* set directory - in 0.00
* analysis dataset created in "0.04 merge IGB Afrobarometer and school founding v6.do"

**********************************************************************************

* Load analysis sample
	set scheme uncluttered /* Gray Kimbraugh scheme https://gray.kimbrough.info/uncluttered-stata-graphs/ */
	set more off 
	use ttt, clear
	
* Table of "What is the highest level of education you have completed?"
	splitvallabels educ
	graph hbar, ///
	over(educ_ori, label(labsize(small))) ///
	ytitle("Percentage", size(small)) ///
	title("Original Afrobarometer" ///
	, span size(medium)) ///
	blabel(bar, format(%4.1f))  name(g1, replace) nodraw
	
	graph hbar, ///
	over(educ, label(labsize(small))) ///
	ytitle("Percentage", size(small)) ///
	title("Recoded for analysis" ///
	, span size(medium)) ///
	blabel(bar, format(%4.1f)) name(g2, replace) nodraw 
	
	graph combine g1 g2, ycommon
	graph export "$mkdropapp/Main_fig/Graphdistri_educ.png", replace 
	*graph export "$mkdropapp_bm/Graphdistri_educ.png", replace 
	
   *graph save Graph "$hd\Graphdistri_educ.gph", replace
   *graph export  "$hd\Graphdistri_educ.pdf", as(pdf) name("Graph") replace
	*graph hbar, ///
	*over(educ, label(labsize(small)) relabel(`r(relabel)')) ///
	*ytitle("Percentage", size(small)) ///
	*title("What is the highest level of education you have completed?" ///
	*, span size(medium)) ///
	*blabel(bar, format(%4.1f))  scheme(s2mono)  

* Table of descriptive statistics of means overall, by gender, simple just tabular
	local vars1 "year_birth treat wei_dist_af closest_school_km_af some_schooling educ_prim_completed educ_sec_some educ index_eng voted_yes part_comm_grp_dum part_meeting_dum part_join_issue_dum "
	eststo clear
	quietly eststo ttests: estpost ttest `vars1', by(male)
	quietly eststo summstats: estpost summarize `vars1'
	quietly eststo treated:  estpost  summarize `vars1' if male==1
	quietly eststo non_treated: estpost  summarize `vars1' if male==0
	esttab summstats             ///
		   treated               ///
		   non_treated           ///
		   ttests using "$mkdropapp/Main_tab/Tab_1.tex" ,               ///
		   cell(p(fmt(%6.3f)) &  ///
		   mean(fmt(%6.2f))      ///
		   sd(fmt(%6.3f) par))   ///
		   label replace         ///
		   mtitle("All"        ///
				  "Male"      ///
				  "Female"   ///
				  "p-value")     ///
	collabels(none)

* Table of descriptive statistics of means overall by school eligibility and access (male=0)
	use ttt, clear
	keep if male==0
	local vars1 "some_schooling educ_prim_completed educ_sec_some educ index_eng"
	eststo clear
	eststo ttests: estpost ttest `vars1', by(treat)
	eststo summstats: estpost summarize `vars1'
	eststo treated: estpost summarize `vars1' if treat==1
	eststo non_treated: estpost summarize `vars1'  if treat==0
	esttab summstats             ///
		   treated               ///
		   non_treated           ///
		   ttests using "$hd/Tab_2.0a.tex" ,               ///
		   cell(p(fmt(%6.3f)) &  ///
		   mean(fmt(%6.2f))      ///
		   sd(fmt(%6.3f) par))   ///
		   label replace  fragment         	   
    filefilter "$hd/Tab_2.0a.tex" "$hd/Tab_2_ax.tex", from("&\BSmulticolumn{1}{c}{(1)}&\BSmulticolumn{1}{c}{(2)}&\BSmulticolumn{1}{c}{(3)}&\BSmulticolumn{1}{c}{(4)}\BS\BS") to("")	replace
	filefilter "$hd/Tab_2_ax.tex" "$hd/Tab_2_ay.tex", from("&\BSmulticolumn{1}{c}{}&\BSmulticolumn{1}{c}{}&\BSmulticolumn{1}{c}{}&\BSmulticolumn{1}{c}{}\BS\BS") to("") replace
	filefilter "$hd/Tab_2_ay.tex" "$hd/Tab_2_az.tex", from("\BShline") to("") replace
    filefilter "$hd/Tab_2_az.tex" "$mkdropapp/Main_tab/Tab_2_w.tex", from("&   p/mean/sd&   p/mean/sd&   p/mean/sd&   p/mean/sd\BS\BS") to("")	replace
	sleep 10000
	erase "$hd/Tab_2.0a.tex"		
	erase "$hd/Tab_2_ax.tex"		
	erase "$hd/Tab_2_ay.tex"		
	erase "$hd/Tab_2_az.tex"		

* Table of descriptive statistics of means overall by school eligibility and access (male =1)
	use ttt, clear
	keep if male==1
	local vars1 "some_schooling educ_prim_completed educ_sec_some educ index_eng"
	eststo clear
	eststo ttests: estpost ttest `vars1', by(treat)
	eststo summstats: estpost summarize `vars1'
	eststo treated: estpost summarize `vars1' if treat==1
	eststo non_treated: estpost summarize `vars1'  if treat==0
	esttab summstats             ///
		   treated               ///
		   non_treated           ///
		   ttests using "$hd/Tab_2.0a.tex" ,               ///
		   cell(p(fmt(%6.3f)) &  ///
		   mean(fmt(%6.2f))      ///
		   sd(fmt(%6.3f) par))   ///
		   label replace fragment  
    filefilter "$hd/Tab_2.0a.tex" "$hd/Tab_2_ax.tex", from("&\BSmulticolumn{1}{c}{(1)}&\BSmulticolumn{1}{c}{(2)}&\BSmulticolumn{1}{c}{(3)}&\BSmulticolumn{1}{c}{(4)}\BS\BS") to("")	replace
	filefilter "$hd/Tab_2_ax.tex" "$hd/Tab_2_ay.tex", from("&\BSmulticolumn{1}{c}{}&\BSmulticolumn{1}{c}{}&\BSmulticolumn{1}{c}{}&\BSmulticolumn{1}{c}{}\BS\BS") to("") replace
	filefilter "$hd/Tab_2_ay.tex" "$hd/Tab_2_az.tex", from("\BShline") to("") replace
    filefilter "$hd/Tab_2_az.tex" "$mkdropapp/Main_tab/Tab_2_m.tex", from("&   p/mean/sd&   p/mean/sd&   p/mean/sd&   p/mean/sd\BS\BS") to("")	replace
	sleep 10000
	erase "$hd/Tab_2.0a.tex"		
	erase "$hd/Tab_2_ax.tex"		
	erase "$hd/Tab_2_ay.tex"		
	erase "$hd/Tab_2_az.tex"	
	
* Figure Schooling attainment in Afrobarometer over birth cohorts male and female
	use ttt, clear
	egen year_birth_cut = cut(year_birth), at(1950(3)2005)
	preserve
	separate some_schooling, by(male)
	collapse (mean) some_schooling0 some_schooling1 (count) n=some_schooling, by(year_birth_cut)
	scatter some_schooling0 some_schooling1  year_birth_cut [w=n] ///
	       if year_birth_cut>=1950 & year_birth<2005 & n>5  ,  ///
		   msymbol(circle_hollow Sh ) msize(medsmall medsmall) mlwidth(medthick medthick) legend(off) xtitle("") ylabel(0(.1).8, grid gmax labs(medsmall)) ///
		   xlabel( ,labs(medsmall)) ///
		   title("(a) Some schooling", size(*0.9)) subtitle("◯ = Women, ▢ = Men", size(*0.8)) name(g1, replace) nodraw 
	restore
	preserve
	separate educ, by(male)
	collapse (mean) educ0 educ1 (count) n=educ, by(year_birth_cut)
	scatter educ0 educ1  year_birth_cut [w=n] ///
			if year_birth_cut>=1950 & year_birth<2005 & n>5  ,   ///
		   msymbol(circle_hollow Sh ) msize(medsmall medsmall) mlwidth(medthick medthick) legend(off) xtitle("") ylabel(0(.5)2, grid gmax labs(medsmall)) ///
		   xlabel( ,labs(medsmall)) ///
		   title("(b) Education level", size(*0.9)) subtitle("◯ = Women, ▢ = Men", size(*0.8)) name(g2, replace) nodraw
	graph combine g1 g2
    graph export "$mkdropapp/Main_fig/School_attain_Afrobar_gender.png", replace
	restore
	
	* Boilerplate for figure 
	/*
	title("Figure : Completion rates for primary and secondary schooling", size(med)) ///
	subtitle("by birth year cohort, Afrobarometer survey", size(*0.8)) ///
	caption("Source: Author calculations using Afrobarometer data, various rounds. Respondents grouped into 3-year bins by birth year." ///
	         "Symbols sized by number of respondents; there are fewer respondents in the early and later years", size(*0.6)) 
    */
	

  * Figure Schooling attainment in Afrobarometer over birth cohorts and voting
  * Note, just the odd year labels are displayed
  * Note, hack to get labels to appear .03 to right of marker
	use ttt, clear
	keep if year_birth<2000
	keep  if male==0
	collapse (mean) educ index_eng (count) n=educ , by(year_birth) 
	gen educ2=round(educ,  0.001)
	gen odd = mod(year_birth,2)
	replace year_birth=. if year_birth<1990 & odd==1
	gen x2= educ2+0.03
	scatter  index_eng educ2  , ///
	msymbol(circle_hollow ) msize(medsmall) || scatter  index_eng x2, m(none) mlabel(year)  ///
	title("Women") ///
	 xtitle("Mean education level of birth cohort in sample") ylabel(0(.5)3, grid gmax labs(medsmall)) ///
	 ytitle("Mean of index of political engagement") xlabel(0(.3)2.2 ,labs(medsmall)) ///
		    name(g1, replace) 
			
	use ttt, clear
	keep if year_birth<2000
	keep  if male==1
	collapse (mean) educ index_eng (count) n=educ , by(year_birth) 
	gen educ2=round(educ,  0.001)
	gen odd = mod(year_birth,2)
	replace year_birth=. if year_birth<1990 & odd==1
	gen x2= educ2+0.03
	scatter  index_eng educ2  , ///
	msymbol(circle_hollow ) msize(medsmall) || scatter  index_eng x2, m(none) mlabel(year)  ///
	title("Men") ///
	xtitle("Mean education level of birth cohort in sample") ylabel(0(.5)3, grid gmax labs(medsmall)) ///
	 ytitle("Mean of index of political engagement") xlabel(0(.3)2.2 ,labs(medsmall)) ///    
	name(g2, replace) 		
	
	graph combine g1 g2, ycommon  	
	graph export "$mkdropapp/Main_fig/Schoolingattainment_voting_inAfrobar_title.png", replace width(6500) height(4500) 
  

