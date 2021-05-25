* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Descriptive Stats									   *
*				Unique ID											   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create figures and graphs on the vignettes 

       ** IDS VAR: country year unique_id 
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	May 24th 2021
	   
 *************************************************************************/
 
		//Sections
		global sectionA 	1 // box plot  		- provider cadre & knowledge score 
		global sectionB 	1 // box plot  		- provider knowledge score 
		global sectionC 	1 // box plot  		- medical qualification 
		global sectionD 	1 // scatter plot  	- provider cadre & knowledge score
	
/*****************************
			Vignettes   
******************************/	
	
	*Open vignettes dataset 
	use "$VG_dtFin/Vignettes_pl.dta", clear   
		
/*************************************************************************
			Correct diagnosis 
***************************************************************************/

	egen 	num_answered = rownonmiss(diag1-diag7)
	lab var num_answered "Number of vignettes that were done"

	egen 	num_correctd = rowtotal(diag1-diag7)
	replace num_correctd = num_correctd/100
	gen 	percent_correctd = num_correctd/num_answered * 100
	lab var num_correctd "Number of conditions diagnosed correctly"
	lab var percent_correctd "Fraction of conditions diagnosed correctly"

/**************************************************************************
			Correct treatment 
***************************************************************************/

	//Adjust variable to go from 0 to 100
		foreach z of varlist treat1 - treat7 {
			replace `z' = `z' * 100
			lab val `z' vigyesnolab
		}

	egen	num_treated = rownonmiss(treat1 - treat7)
	lab var num_treated "Number of vignettes that had treatment coded"

	egen 	num_correctt = rowtotal(treat1 - treat7)
	replace num_correctt = num_correctt/100
	gen 	percent_correctt = num_correctt/num_treated * 100
	lab var num_correctt "Number of conditions treated correctly"
	lab var percent_correctt "Fraction of conditions treated correctly"
   
/****************************************************************************
		Create competence percentiles and deciles 
*****************************************************************************/

	*Encode country 
	encode cy, gen(countrycode)
 
	xtile pctile_overall = theta_mle, n(100)
	xtile decile_overall = theta_mle, n(10)

	lab var pctile_overall "Competence percentile calculated for all countries combined"
	lab var decile_overall "Competence decile calculated for all countries combined"

	levelsof countrycode
	foreach x in `r(levels)' {
		xtile pctile_comp_`x' = theta_mle if countrycode == `x', n(100) 
		xtile decile_comp_`x' = theta_mle if countrycode == `x', n(10)  
	}
	egen pctile_bycountry = rowmin(pctile_comp_*)
	egen decile_bycountry = rowmin(decile_comp_*)

	drop pctile_comp_* decile_comp_*

	lab var pctile_bycountry "Competence percentile calculated per country"
	lab var decile_bycountry "Competence decile calculated per country"	
	
/**********************************************************************
				Incorrect antibiotics 
***********************************************************************/

	*Adjust variable to go from 0 to 100	
		foreach z of varlist tb_antibio diar_antibio {
			replace `z' = `z' * 100
			lab val `z' vigyesnolab
		}	

	egen 	num_antibiotics = rownonmiss(tb_antibio diar_antibio)
	lab var num_antibiotics "Number of vignettes where incorrect antibiotics could be prescribed"

	egen 	num_antibiotict = rowtotal(tb_antibio diar_antibio)
	replace num_antibiotict = num_antibiotict/100
	gen 	percent_antibiotict = num_antibiotict/num_antibiotics * 100
	lab var num_antibiotict "Number of conditions where incorrect antiobiotics were prescribed"
	lab var percent_antibiotict "Fraction of conditions where incorrect antiobiotics were prescribed"	
 	
****************************************************************************
/* Create measures of effort (questions, exams, tests) */
*****************************************************************************
	
	local diseases = ""
	foreach v of varlist skip_* {
		local dis = substr("`v'", 6, .)
		sum `v'
		if `r(N)' != 0 {
			local diseases = `" "`dis'" `diseases' "'
		}
	}

	foreach disease in `diseases' {
		cap unab vhist : `disease'_history_*
		if "`vhist'" != "" {
			display "`counter'"
			egen `disease'_questions = rownonmiss(`disease'_history_*)
			egen `disease'_questions_num = anycount(`disease'_history_*), val(1)
			gen `disease'_questions_frac = `disease'_questions_num/`disease'_questions * 100
			replace `disease'_questions = . if skip_`disease'==1 | skip_`disease'==. | `disease'_questions==0
			replace `disease'_questions_num = . if skip_`disease'==1 | skip_`disease'==. | `disease'_questions==0 | `disease'_questions==.
			replace `disease'_questions_frac = . if skip_`disease'==1 | skip_`disease'==. | `disease'_questions==0 | `disease'_questions==.

			lab var `disease'_questions "Number of possible `disease' history questions in survey" 
			lab var `disease'_questions_num "Number of `disease' history questions asked"
			lab var `disease'_questions_frac "Fraction of possible `disease' history questions that were asked"
		}
		local vhist = ""
		
		cap unab vtest : `disease'_test_*
		if "`vtest'" != "" {
			egen `disease'_tests = rownonmiss(`disease'_test_*) 
			egen `disease'_tests_num = anycount(`disease'_test_*), val(1)
			gen `disease'_tests_frac = `disease'_tests_num/`disease'_tests * 100
			replace `disease'_tests = . if skip_`disease'==1 | skip_`disease'==. | `disease'_tests==0
			replace `disease'_tests_num = . if skip_`disease'==1 | skip_`disease'==. | `disease'_tests==0 | `disease'_tests==.
			replace `disease'_tests_frac = . if skip_`disease'==1 | skip_`disease'==. | `disease'_tests==0 | `disease'_tests==.

			lab var `disease'_tests "Number of possible `disease' tests in survey"
			lab var `disease'_tests_num  "Number of `disease' tests run"
			lab var `disease'_tests_frac "Fraction of possible `disease' tests that were run"
		}
		local vtest = ""

		cap unab vexam : `disease'_exam_*
		if "`vexam'" != "" {
			egen `disease'_exams = rownonmiss(`disease'_exam_*)
			egen `disease'_exams_num = anycount(`disease'_exam_*), val(1)
			gen `disease'_exams_frac = `disease'_exams_num/`disease'_exams * 100
			replace `disease'_exams = . if skip_`disease'==1 | skip_`disease'==. | `disease'_exams==0
			replace `disease'_exams_num = . if skip_`disease'==1 | skip_`disease'==. | `disease'_exams==0 | `disease'_exams==.
			replace `disease'_exams_frac = . if skip_`disease'==1 | skip_`disease'==. | `disease'_exams==0	| `disease'_exams==.

			lab var `disease'_exams "Number of possible `disease' physical exams in survey"
			lab var `disease'_exams_num "Number of `disease' physical exams done"
			lab var `disease'_exams_frac "Fraction of possible `disease' physical exams that were done"
		}
		local vexam = ""
	}
	
	egen total_questions	= rowtotal(*_questions_num)
	egen total_tests 		= rowtotal(*_tests_num)
	egen total_exams 		= rowtotal(*_exams_num)

	lab var total_questions "Total number of history questions asked across all vignettes"
	lab var total_tests		"Total number of tests run all vignettes"
	lab var total_exams 	"Total number of physical exams done across all vignettes"

	egen overall_questions_frac = rowmean(*_questions_frac)
	egen overall_exams_frac 	= rowmean(*_exams_frac)

	lab var overall_questions_frac 	"Average proportion of possible questions asked per vignette"
	lab var overall_exams_frac 		"Average proportion of possible physical exams done per vignette"
   	
/****************************************************************************
 			Run regressions for IRT score 	
*****************************************************************************/

	*Correct treatment and IRT scores
	regress percent_correctt theta_mle
	margins, at(theta_mle = (-3(1)3))
		cap mat drop theResults
		mat theResults = r(b)
		mat theResults = theResults'
	forvalues i = 1/7 {
		local treat`i' = round(theResults[`i',1], 1)
		if `treat`i'' > 100 local treat`i' = 100
		if `treat`i'' < 0 local treat`i' = 0
	}

	*Correct diagnosis and IRT scores
	regress percent_correctd theta_mle
	margins, at(theta_mle = (-3(1)3))
		cap mat drop theResults
		mat theResults = r(b)
		mat theResults = theResults'
	forvalues i = 1/7 {
		local diag`i' = round(theResults[`i',1], 1)
		if `diag`i'' > 100 local diag`i' = 100
		if `diag`i'' < 0 local diag`i' = 0
	}

	*Total tests and IRT scores
	regress total_tests theta_mle
	margins, at(theta_mle = (-3(1)3))
		cap mat drop theResults
		mat theResults = r(b)
		mat theResults = theResults'
	forvalues i = 1/7 {
		local test`i' = round(theResults[`i',1], 0.1)
		display "`test`i''"
		local decplace = strpos("`test`i''", ".")
		if `decplace'==2 & `test`i''>=0 local test`i' = substr("`test`i''", 1, 3)
		if `decplace'==3 & `test`i''>=0 local test`i' = substr("`test`i''", 1, 4)
		if `decplace'==0 & `test`i''>=0 local test`i' = "`test`i''.0"
		if `decplace'==1 & `test`i''>=0 local test`i' = substr("`test`i''", 2, 2)
		if `decplace'==1 & `test`i''>=0 local test`i' = "0.`test`i''"
		if `test`i'' < 0 local test`i' = "0.0"	
	}

	*Appropriate antibiotics and IRT scores
	regress percent_antibiotict theta_mle
	margins, at(theta_mle = (-3(1)3))
		cap mat drop theResults
		mat theResults = r(b)
		mat theResults = theResults'
	forvalues i = 1/7 {
		local ab`i' = round(theResults[`i',1], 1)
		if `ab`i'' > 100 local ab`i' = 100
		if `ab`i'' < 0 local ab`i' = 0
	}
	
	*Overall questions and IRT scores
	regress overall_questions_frac theta_mle
	margins, at(theta_mle = (-3(1)3))
		cap mat drop theResults
		mat theResults = r(b)
		mat theResults = theResults'
	forvalues i = 1/7 {
		local qu`i' = round(theResults[`i',1], 1)
		if `qu`i'' > 100 local qu`i' = 100
		if `qu`i'' < 0 local qu`i' = 0
	}

	*Exams conducted and IRT scores
	regress overall_exams_frac theta_mle
	margins, at(theta_mle = (-3(1)3))
		cap mat drop theResults
		mat theResults = r(b)
		mat theResults = theResults'
	forvalues i = 1/7 {
		local exam`i' = round(theResults[`i',1], 1)
		if `exam`i'' > 100 local exam`i' = 100
		if `exam`i'' < 0 local exam`i' = 0
	}

	*Create local to store country sample sizes 
	forvalues x = 1/13 {
		count if theta_mle!=. & countrycode == `x'
		local N`x' = r(N) 
	}
	
	*Create locals for axis labels 
	local outcome_axis " -5 `" "Vignette IRT Score" " " "Correct Diagnoses" " " "Correct Treatment" " " "Number of Tests" " " "Inapprop. Antibiotics" "' -3 `" "-3" " " "`diag1'%" " " "`treat1'%" " " "`test1'" " " "`ab1'%" "' -2 `" "-2" " " "`diag2'%" " " "`treat2'%" " " "`test2'" " " "`ab2'%" "' -1 `" "-1" " " "`diag3'%" " " "`treat3'%" " " "`test3'" " " "`ab3'%" "' 0 `" "0" " " "`diag4'%" " " "`treat4'%" " " "`test4'" " " "`ab4'%" "' 1 `" "1" " " "`diag5'%" " " "`treat5'%" " " "`test5'" " " "`ab5'%" "' 2 `" "2" " " "`diag6'%" " " "`treat6'%" " " "`test6'" " " "`ab6'%" "' 3 `" "3" " " "`diag7'%" " " "`treat7'%" " " "`test7'" " " "`ab7'%" "' "
	
	local input_axis " -5 `" "Vignette IRT Score" " " "Questions Asked" " " "Exams Done" "' -3 `" "-3" " " "`qu1'%" " " "`exam1'%" "' -2 `" "-2" " " "`qu2'%" " " "`exam2'%" "' -1 `" "-1" " " "`qu3'%" " " "`exam3'%"  "' 0 `" "0" " " "`qu4'%" " " "`exam4'%" "' 1 `" "1" " " "`qu5'%" " " "`exam5'%" "' 2 `" "2" " " "`qu6'%" " " "`exam6'%"  "' 3 `" "3" " " "`qu7'%" " " "`exam7'%"  "' "
		
	*Create locals for country names 
	local crt_name 1 "Guinea Bissau (n=`N1')" 2 "Kenya 2012 (n=`N2')" 3 "Kenya 2018 (n=`N3')" 4 "Madagascar (n=`N4')" 5 "Mozambique (n=`N5')" 6 "Malawi (n=`N6')" 7 "Niger (n=`N7')" 8 "Nigeria (n=`N8')" 9 "Sierra Leone (n=`N9')" 10 "Togo (n=`N10')" 11 "Tanzania 2014 (n=`N11')" 12 "Tanzania 2016 (n=`N12')" 13 "Uganda (n=`N13')"
	
	local crt_name2 1 "Guinea Bissau" 2 "Kenya 2012" 3 "Kenya 2018" 4 "Madagascar" 5 "Mozambique" 6 "Malawi" 7 "Niger" 8 "Nigeria" 9 "Sierra Leone" 10 "Togo" 11 "Tanzania 2014" 12 "Tanzania 2016" 13 "Uganda"
	
 	

/****************************************************************************
 			Create box plot for provider cadre & knowledge score 	
*****************************************************************************/	
if $sectionA {	
	
	
	*Create local od knowledge score based on Kenya Nurses 2012 
	summarize  	theta_mle if cy == "KEN_2012" & provider_cadre1 == 3, d
	local 		ken_med  = `r(p50)' 

	graph box theta_mle, 																					///
		over(provider_cadre1, reverse axis(noli) label(nolabel)) 											///
		over(countrycode, sort(1)  relabel(`crt_name2') axis(noli) label(labsize(small))) 					///
		noout box(1, fcolor(none) lcolor(navy*0.6)) 														///
		box(2, fcolor(none) lcolor(navy*0.9)) 																///
		box(3, fcolor(none) lcolor(navy*1.3)) 																///
		graphregion(color(white)) ytitle(, placement(left) justification(left)) ylabel(, angle(0) nogrid) 	///
		legend(label(1 "Doctor") label(2 "Nurse") label(3 "Para-Professional") 								///
		order(1 2 3) pos(11) ring(0) cols(1) region(lwidth(0.2) fc(none)) symx(4) symy(2) size(vsmall)) 	///
		yscale(range(-3 3) titlegap(2)) bgcolor(white) asyvars showyvars horizontal 						///
		ylabel(-3 "-3" -1 "-1" 0 "0" 1 "1" 3 "3" , labsize(small)) 											///
		yline(`ken_med', lwidth(0.3) lcolor(green) lpattern(dash)) 											///
		ytitle("Provider knowledge score {&rarr}", size(small)) allcategories	note("")							
	graph export "$VG_out/figs/cadre_knowledge.png", replace as(png)	

	 
	*Create local od knowledge score based on Kenya Nurses 2012 
	summarize  	theta_mle if cy == "KEN_2012" & provider_cadre1 == 3, d
	local 		ken_med  = `r(p50)' 
	
	preserve 
		*Create an all providers variable  	
		gen 	all_prov = 0 
		replace all_prov = 1 if !missing(provider_cadre1)
		by 		cy facility_id, sort: egen tot_providers = total(all_prov)
		
		*Create a variable for all female doctors 
		gen 	prov_kenya 	= 0 
		replace prov_kenya  = 1 if theta_mle>= `ken_med'
		by 		cy facility_id, sort: egen tot_prov_kenya = total(prov_kenya)
		
		*Create share of providers better than the median score of the Kenya 2012 nurse 
		gen 	prov_frac = tot_prov_kenya/tot_providers
		
		*Drop missing observations 
		drop if prov_frac == .
	 
		betterbar prov_frac, 																						///
				over(provider_cadre1) by(countrycode) pct	scale(0.7) 												///
				graphregion(color(white)) ytitle(, placement(left) justification(left)) 							///
				xlabel(0 "0" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1 "100%", labsize(small))						/// 
				legend(label(1 "Doctor") label(2 "Nurse") label(3 "Para-Professional") 								///
				order(1 2 3) pos(1) ring(0) cols(1) region(lwidth(0.2) fc(none)) symx(4) symy(2) size(vsmall)) 		///
				yscale(range(0 3) titlegap(2)) bgcolor(white) yscale(noli) xscale(noli)								///
				barcolor(navy*1.3 navy*0.9 navy*0.6 )  																///
				ylabel(41 "Togo" 29 "Tanzania 2014" 149 "Guinea Bissau" 137 "Kenya 2012" 							///
						17 "Tanzania 2016" 125 "Kenya 2018" 5 "Uganda" 113 "Madagascar" 							///
						101 "Mozambique" 89 "Malawi" 77 "Niger" 65 "Nigeria" 53 "Sierra Leone"						///
						, labsize(med) angle(0) nogrid) xtitle("Share of Providers {&rarr}", size(small))
		graph export "$VG_out/figs/cadre_knowledge_bar.png", replace as(png)	
	restore 	
}		
  
/****************************************************************************
 			Create box plot for knowledge score 	
*****************************************************************************/			
if $sectionB {	
	 	
	graph box theta_mle, ///
		over(countrycode, sort(1) descending axis(noli) relabel(`crt_name2') label(labsize(small)))		///
		box(1, fcolor(none) lcolor(navy) lwidth(0.4)) marker(1, msize(vsmall) mcolor(navy)) 			///
		box(2, fcolor(none) lcolor(cranberry) lwidth(0.4)) marker(2, msize(vsmall) mcolor(cranberry))	///
		box(3, fcolor(none) lcolor(gold*1.2) lwidth(0.4)) marker(3, msize(vsmall) mcolor(gold*1.2)) 	///
		box(4, fcolor(none) lcolor(purple) lwidth(0.4)) marker(4, msize(vsmall) mcolor(purple)) 		///
		box(5, fcolor(none) lcolor(chocolate) lwidth(0.4)) marker(5, msize(vsmall) mcolor(chocolate)) 	///
		box(6, fcolor(none) lcolor(orange) lwidth(0.4)) marker(6, msize(vsmall) mcolor(orange)) 		///
		box(7, fcolor(none) lcolor(midgreen) lwidth(0.4)) marker(7, msize(vsmall) mcolor(midgreen)) 	///
		box(8, fcolor(none) lcolor(midblue) lwidth(0.4)) marker(8, msize(vsmall) mcolor(midblue)) 		///
		box(9, fcolor(none) lcolor(emerald) lwidth(0.4)) marker(9, msize(vsmall) mcolor(emerald)) 		///
		box(10, fcolor(none) lcolor(lavender) lwidth(0.4)) marker(10, msize(vsmall) mcolor(lavender)) 	///
		box(11, fcolor(none) lcolor(purple) lwidth(0.4)) marker(11, msize(vsmall) mcolor(purple)) 		///
		box(12, fcolor(none) lcolor(red) lwidth(0.4)) marker(12, msize(vsmall) mcolor(red)) 			///
		box(13, fcolor(none) lcolor(brown) lwidth(0.4)) marker(13, msize(vsmall) mcolor(brown)) 		///
		yline(0, lwidth(0.3) lcolor(gs12) lpattern(dash)) 												///
		ylabel(-5(1)5, labsize(small) angle(0) nogrid) 													///
		ytitle("Provider's knowledge score {&rarr}", placement(left) justification(left) size(small)) 	///
		legend(off) yscale(range(-5 5) titlegap(2)) bgcolor(white) graphregion(color(white)) asyvars 	///
		showyvars horizontal																			
	graph export "$VG_out/figs/prov_knowledge.png", replace as(png)	
}

/****************************************************************************
 			Create box plot for medical education  	
*****************************************************************************/	
if $sectionC {	
	
	*Create a new countrycode 
	gen 		countrycode2 = countrycode
	labdtch 	countrycode2
	lab define  countrycode_lab  1 "Guinea Bissau" 3 "Kenya 2018" 4 "Madagascar" 5 "Mozambique"	///
								 6 "Malawi" 7 "Niger" 8 "Nigeria" 9 "Sierra Leone" 10 "Togo" 	///
								 11 "Tanzania 2014" 12 "Tanzania 2016"
	label val 	countrycode2 countrycode_lab
	
	*Create local od knowledge score based on Kenya Nurses 2012 
	summarize  	theta_mle if cy == "KEN_2012" & provider_cadre1 == 3, d
	local 		ken_med  = `r(p50)' 

	graph box theta_mle, ///
		over(provider_mededuc1, reverse axis(noli) label(labsize(tiny))) 									///
		over(countrycode2, sort(1) axis(noli) label(labsize(small))) 										///
		noout box(1, fcolor(none) lcolor(navy*0.3)) box(2, fcolor(none) lcolor(navy*0.6))					///
		box(3, fcolor(none) lcolor(navy*0.9)) box(4, fcolor(none) lcolor(navy*1.3)) 						///
		title(, size(medium) justification(left) color(black) span pos(11)) 								///
		graphregion(color(white)) ytitle(, placement(left) justification(left)) ylabel(, angle(0) nogrid) 	///
		yscale(range(-3 3) titlegap(2)) bgcolor(white) asyvars showyvars horizontal 						///
		ylabel(-3 "-3" -1 "-1" 0 "0" 1 "1" 3 "3" , labsize(small)) legend(off) 								///
		yline(`ken_med', lwidth(0.3) lcolor(green) lpattern(dash)) 											///
		ytitle("Provider knowledge score {&rarr}", size(small)) note("")											
	graph export "$VG_out/figs/prov_mededu.png", replace as(png)	
 	
	*Create local od knowledge score based on Kenya Nurses 2012 
	summarize  	theta_mle if cy == "KEN_2012" & provider_cadre1 == 3, d
	local 		ken_med  = `r(p50)' 
	
	preserve 
		*Create an all providers variable  	
		gen 	all_prov = 0 
		replace all_prov = 1 if !missing(provider_cadre1)
		by 		cy facility_id, sort: egen tot_providers = total(all_prov)
		
		*Create a variable for all female doctors 
		gen 	prov_kenya 	= 0 
		replace prov_kenya  = 1 if theta_mle>= `ken_med'
		by 		cy facility_id, sort: egen tot_prov_kenya = total(prov_kenya)
		
		*Create share of providers better than the median score of the Kenya 2012 nurse 
		gen 	prov_frac = tot_prov_kenya/tot_providers
		
		*Drop missing observations 
		drop if prov_frac == .		
		drop if missing(provider_mededuc1)	
	 
		betterbar prov_frac, 																						///
				over(provider_mededuc1) by(countrycode2) pct	scale(0.7) 											///
				graphregion(color(white)) ytitle(, placement(left) justification(left)) 							///
				xlabel(0 "0" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1 "100%", labsize(small))						/// 
				legend(label(1 "Advanced") label(2 "Diploma") label(3 "Certificate") label(4 "None") 				///
				order(1 2 3 4) pos(1) ring(0) cols(1) region(lwidth(0.2) fc(none)) symx(4) symy(2) size(vsmall)) 	///
				yscale(range(0 3) titlegap(2)) bgcolor(white) yscale(noli) xscale(noli)								///
				barcolor(navy*0.3 navy*0.6 navy*0.9 navy*1.3)  														///
				ylabel(41 "Togo" 29 "Tanzania 2014" 149 "Guinea Bissau" 137 "Kenya 2012" 							///
						17 "Tanzania 2016" 125 "Kenya 2018" 5 "Uganda" 113 "Madagascar" 							///
						101 "Mozambique" 89 "Malawi" 77 "Niger" 65 "Nigeria" 53 "Sierra Leone"						///
						, labsize(med) angle(0) nogrid) xtitle("Share of Providers {&rarr}", size(small))
		graph export "$VG_out/figs/prov_mededu_bar.png", replace as(png)	 	
	restore 	
}
 
/****************************************************************************
 			Create scatter plot for provider cadre & knowledge score 	
*****************************************************************************/	
if $sectionD {	 
 
	tostring countrycode, replace force 
	
	replace	countrycode = "Guinea Bissau" 	if countrycode == "1"
	replace	countrycode = "Kenya 2012" 		if countrycode == "2"
	replace	countrycode = "Kenya 2018" 		if countrycode == "3"
	replace	countrycode = "Madagascar" 		if countrycode == "4"
	replace	countrycode = "Mozambique" 		if countrycode == "5"
	replace	countrycode = "Malawi" 			if countrycode == "6"
	replace	countrycode = "Niger" 			if countrycode == "7"
	replace	countrycode = "Nigeria" 		if countrycode == "8"
	replace	countrycode = "Sierra Leone" 	if countrycode == "9"
	replace	countrycode = "Togo" 			if countrycode == "10"
	replace	countrycode = "Tanzania 2014" 	if countrycode == "11"
	replace	countrycode = "Tanzania 2016" 	if countrycode == "12"
	replace	countrycode = "Uganda"	 		if countrycode == "13"
	
	*Create new provider cadre 
	gen		provider_cadre1_new = .
	replace provider_cadre1_new = 1 if provider_cadre1 == 4	// Para-professional 
	replace provider_cadre1_new = 2 if provider_cadre1 == 3	// Nurse
	replace provider_cadre1_new = 3 if provider_cadre1 == 1 // Doctor
	
	lab define  prov_lab 1 "Para-Professional" 2 "Nurse" 3 "Doctor"
	label val 	provider_cadre1_new prov_lab
	
	*Create local od knowledge score based on Kenya Nurses 2012 
	summarize  	theta_mle if cy == "KEN_2012" & provider_cadre1_new == 2, d
	local 		ken_med  = `r(p50)' 
 
	local colors = "navy navy navy"
	local intensities = "0.6 0.9 1.3"
	
	foreach x in "provider_cadre1_new" {
		levelsof `x'
		foreach z in `r(levels)' {
			local maincolor : word 1 of `colors'
			local intensity : word `z' of `intensities'
			local color`x'`z' = "`maincolor'*`intensity'"
			display "`color`x'`z''"
			display "color`x'`z'"
		}
	}  
  
	local counter = 0
	
	foreach filter in  "provider_cadre1_new" {
		preserve
			collapse (mean) mean = theta_mle (sd) sd=theta_mle (count) n=theta_mle, by(countrycode `filter')
			drop if countrycode==""
			drop if `filter'==.
			gen hi = mean + invttail(n-1,0.025) * (sd/sqrt(n)) if n>2
			gen lo = mean - invttail(n-1,0.025) * (sd/sqrt(n)) if n>2
			gen filter = "`filter'"

			if `counter' == 0 {
				tempfile theX
				save `theX', replace
			}

			if `counter' > 0 {
				append using `theX', force
				save `theX', replace
			}
		restore
		local ++counter
	}

	use `theX', clear

	gen id = .
	levelsof filter
	foreach x in `r(levels)' {

		replace id = `x' if filter == "`x'"
		levelsof `x'
		local maxlev = substr("`r(levels)'", -1, 1)
		local offset = `maxlev' + 1
		
		local theLabels = ""
		local theDividers = ""
		local counter = 0
		levelsof countrycode if filter=="`x'" 
		foreach y in `r(levels)' {
			local placename = subinstr("`y'", "-", " ", .)
			replace id = `offset' * `counter' + id if filter=="`x'" & countrycode=="`y'"

			sum id if filter=="`x'" & countrycode=="`y'"
			local theLocation = `r(mean)'
			if `r(mean)'==`r(min)' local theLocation = (`r(min)' + `r(min)' + `maxlev' - 1)/2
			if "`r(max)'"!=substr("`r(levels)'", -1, 1) local theLocation = (`r(min)' + `r(min)' + `maxlev' - 1)/2
			local theDivide = `r(min)' - 1
			local theDividers = "`theDividers' `theDivide'"
			local theNextLabel = `" `theLocation' "`placename'" "'
			local theLabels = `" `theLabels' `theNextLabel' "'
			local ++counter
		}

		local theScatters = ""
		local theLines = ""
		local theLegends = ""
		local counter1 = 1
		
		levelsof `x'
			
		foreach z in `r(levels)' {
			
			local theNextScatter = `" (scatter id mean if `x'==`z' & filter=="`x'", color(`color`x'`z'') msize(small)) "'
			local theScatters = `" `theScatters' `theNextScatter' "'
			
			local theNextLine = `" (rspike hi lo id if `x'==`z' & filter=="`x'", horizontal lcolor(`color`x'`z'') lwidth(0.2)) "'
			local theLines = `" `theLines' `theNextLine' "'

			local labname : label (`x') `z'
			local theNextLegend = `" `counter1' "`labname'" "'
			local theLegends = `" `theNextLegend' `theLegends' "'

			local ++counter1
		}

		twoway	`theScatters' `theLines', ///
			yline(`theDividers', lcolor(gs14) lpattern(dash)) ///
			legend(order(`theLegends') region(lc(none) fc(none)))  ///
			xtitle("Provider's knowledge score {&rarr}", size(small) placement(left) justification(left)) xscale(titlegap(2)) ytitle("") ///
			ylabel(`theLabels', angle(0) tstyle(major_notick) labsize(small) nogrid) yscale(noli)	///
			xline(`ken_med', lwidth(0.3) lcolor(green) lpattern(dash)) 								///
			xlabel(-3(1)3, labsize(small) angle(0) nogrid) xscale(noli)  							///
			legend(size(small) cols(1) ring(1) pos(2)) 												///
			bgcolor(white) graphregion(color(white)) ysize(4) 										
		graph export "$VG_out/figs/scatter_cadre_knowledge.png", replace as(png)		
	}
	
	 
}
	
*************************** End of do-file *****************************************
