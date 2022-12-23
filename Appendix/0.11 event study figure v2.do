
*==========================================================================================
* event study type graphs of impact of school on education outcomes
* for Afrobarometer data Burkina Faso
* https://stackoverflow.com/questions/41622943/stata-event-study-graph-code
* read in foranalysis1.dta
* select all in sample in 20 year window of school founding
* this means most urban people in sample dropped (ie in Bobo or ouaga, schools founded in 1904, 1920,
* so everyone in urban sample is outside of 20 years window (so just dropped all urban)
* the variable yrs_fr_eligsch_to_schl_fndg is years from year that person was eligible for schooling
* = (birth year + 7_ - (year school founded)
* so a person born in 1982 in a village where school was founded in 1992 is yrs_fr_eligsch_to_schl_fndg = 82+7-92 = -3
* in language of leads-lags, they are "observed as born" three years before the event
* they were eligible for schooling three years before school founded, so they "missed" the school founding

* Notes: Note that sample for graphs is about 1900. Error bars are quite wide. 
* Strategies: Try to find repertoires d'ecoles avec date d'ouverture for other countries, for 2005-2020 Burkina
* get DHS data and map to schools geoloation so can run this first stage
* determine if there is IV to timing of school construction across regions, so then can estimate
* effect of school availability through IV rather than event study framework (which compares those before school with those
* after school, but samples in each location are very small (often just 8 people)
*==========================================================================================

    set more off
    set scheme uncluttered
	use ttt, clear
	replace yrs_fr_eligsch_to_schl_fndg=. if sch_fnd_yr==2010
	eventdd educ male, timevar(yrs_fr_eligsch_to_schl_fndg) method(ols) accum leads(10) lags(10) noline level(95)  baseline(-10) ///
	  graph_op(ylabel(-.5(.3).9) xlabel(-10 "{&le} -10"  -5 "-5" 0 "0" 5 "5"  10 "{&ge} 10") legend(off) xtitle(" " "Coefficients on lags and leads of year of age of school eligibility" ///
	  "minus year of school establishment, no controls")) ///
	   coef_op(msymbol(Oh)) endpoints_op(msymbol(O) saving(g1x, replace))
    eventdd educ male, timevar(yrs_fr_eligsch_to_schl_fndg) method(hdfe, absorb(year_birth provinceg)) accum leads(10) lags(10) noline level(95)  baseline(-10) ///
	  graph_op(ylabel(-.5(.3).9) xlabel(-10 "{&le} -10"  -5 "-5" 0 "0" 5 "5"  10 "{&ge} 10")  legend(off) xtitle(" " "Coefficients on lags and leads of year of age of school eligibility" ///
	  "minus year of school establishment, year of birth and province controls")) ///
	  coef_op(msymbol(Oh)) endpoints_op(msymbol(O) saving(g3, replace))
	  eventdd educ male, timevar(yrs_fr_eligsch_to_schl_fndg) method(hdfe, absorb(year_birth communeg)) accum leads(10) lags(10) noline level(95)  baseline(-10) ///
	  graph_op(ylabel(-.5(.3).9) xlabel(-10 "{&le} -10"  -5 "-5" 0 "0" 5 "5"  10 "{&ge} 10") legend(off) xtitle(" " "Coefficients on lags and leads of year of age of school eligibility" ///
	  "minus year of school establishment, year of birth and commune controls")) ///
	   coef_op(msymbol(Oh)) endpoints_op(msymbol(O) saving(g4, replace))

    graph combine g1x.gph g3.gph g4.gph, cols(1)
	graph export "$mkdropapp/App_fig/F_eventstudy_coeff.png", replace
    *graph export "$tbl/Figure 5 Event study graph of schooling attainment in Afrobarometer.png", replace
