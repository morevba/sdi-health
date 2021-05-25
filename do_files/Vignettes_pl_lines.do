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
       ** Last date modified: 	May 17th 2021
	   
 *************************************************************************/
 
		//Sections
		global sectionA 	1 // line graph - conditions treated correctly 
		global sectionB 	1 // line graph - scatter for provider age 
		global sectionC 	1 // line graph - scatter for provider knowledge
		global sectionD		1 // line graph - provider knowledge & age 
		
/*****************************
			Vignettes   
******************************/	
	
	*Open vignettes dataset 
	"$EL_dtFin/Vignettes_pl.dta", clear    
		
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

/*
	sum theta_mle, de
	replace theta_mle = . if theta_mle < `r(p1)'
	replace theta_mle = . if theta_mle > `r(p99)'
*/	
    gen theta_mle_17 = (theta_mle + 3) * 17	
 
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
	
	*Create locals for axis labels 
	local diag_axis " 0 `" "Vignette IRT Score" " " "Correct Diagnoses" "' 14 `" "-3" " " "`diag1'%"  "' 28 `" "-2" " " "`diag2'%"  "' 42 `" "-1" " " "`diag3'%"  "' 56 `" "0" " " "`diag4'%"  "' 70 `" "1" " " "`diag5'%" "' 84 `" "2" " " "`diag6'%" "' 100 `" "3" " " "`diag7'%"  "' "
	
	local treat_axis " 0 `" "Knowledge Score" " " "Correct Treatment" "' 14 `" "-3" " " "`treat1'%"  "' 28 `" "-2" " " "`treat2'%"  "' 42 `" "-1" " " "`treat3'%"  "' 56 `" "0" " " "`treat4'%"  "' 70 `" "1" " " "`treat5'%" "' 84 `" "2" " " "`treat6'%" "' 100 `" "3" " " "`treat7'%"  "' "

	local questions_axis " 0 `" "Vignette IRT Score" " " "Questions Asked" "' 14 `" "-3" " " "`qu1'%"  "' 28 `" "-2" " " "`qu2'%"  "' 42 `" "-1" " " "`qu3'%"  "' 56 `" "0" " " "`qu4'%"  "' 70 `" "1" " " "`qu5'%" "' 84 `" "2" " " "`qu6'%" "' 100 `" "3" " " "`qu7'%"  "' "
	
	local exams_axis " 0 `" "Vignette IRT Score" " " "Exams Done" "' 14 `" "-3" " " "`exam1'%"  "' 28 `" "-2" " " "`exam2'%"  "' 42 `" "-1" " " "`exam3'%"  "' 56 `" "0" " " "`exam4'%"  "' 70 `" "1" " " "`exam5'%" "' 84 `" "2" " " "`exam6'%" "' 100 `" "3" " " "`exam7'%"  "' "
	
	local outcome_axis_2 " 0 `" "Vignette IRT Score" " " "Correct Diagnoses" " " "Correct Treatment" " " "Number of Tests" " " "Inapprop. Antibiotics" "' 14 `" "-3" " " "`diag1'%" " " "`treat1'%" " " "`test1'" " " "`ab1'%" "' 28 `" "-2" " " "`diag2'%" " " "`treat2'%" " " "`test2'" " " "`ab2'%" "' 42 `" "-1" " " "`diag3'%" " " "`treat3'%" " " "`test3'" " " "`ab3'%" "' 56 `" "0" " " "`diag4'%" " " "`treat4'%" " " "`test4'" " " "`ab4'%" "' 70 `" "1" " " "`diag5'%" " " "`treat5'%" " " "`test5'" " " "`ab5'%" "' 84 `" "2" " " "`diag6'%" " " "`treat6'%" " " "`test6'" " " "`ab6'%" "' 100 `" "3" " " "`diag7'%" " " "`treat7'%" " " "`test7'" " " "`ab7'%" "' "
		
	local input_axis_2 " 0 `" "Vignette IRT Score" " " "Questions Asked" " " "Exams Done" "' 14 `" "-3" " " "`qu1'%" " " "`exam1'%" "' 28 `" "-2" " " "`qu2'%" " " "`exam2'%" "' 42 `" "-1" " " "`qu3'%" " " "`exam3'%"  "' 56 `" "0" " " "`qu4'%" " " "`exam4'%" "' 70 `" "1" " " "`qu5'%" " " "`exam5'%" "' 84 `" "2" " " "`qu6'%" " " "`exam6'%"  "' 100 `" "3" " " "`qu7'%" " " "`exam7'%"  "' "
	
	local outcome_axis_3 " 0 `" "Vignette IRT Score" " " "Correct Diagnoses" " " "Correct Treatment" " " "Inapprop. Antibiotics" "' 14 `" "-3" " " "`diag1'%" " " "`treat1'%" " " "`ab1'%" "' 28 `" "-2" " " "`diag2'%" " " "`treat2'%" " " "`ab2'%" "' 42 `" "-1" " " "`diag3'%" " " "`treat3'%" " " "`ab3'%" "' 56 `" "0" " " "`diag4'%" " " "`treat4'%" " " "`ab4'%" "' 70 `" "1" " " "`diag5'%" " " "`treat5'%" " " "`ab5'%" "' 84 `" "2" " " "`diag6'%" " " "`treat6'%" " " "`ab6'%" "' 100 `" "3" " " "`diag7'%" " " "`treat7'%" " " "`ab7'%" "' "	


/****************************************************************************
 			Create line graph for conditions treated correctly second
*****************************************************************************/
if $sectionA {	
 
*Graph of line plot of fraction of conditions treated correctly 
	tw  (lowess percent_correctt pctile_bycountry if countrycode== 1, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 2, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 3, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 4, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 5, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 6, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 7, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 8, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 9, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 10, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 11, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 12, bwidth(1.2) lwidth(0.5))	///
		(lowess percent_correctt pctile_bycountry if countrycode== 13, bwidth(1.2) lwidth(0.5)),	///
		ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", angle(0) nogrid)  			///
		xlabel(1 "1st" 25 "25th" 50 "50th" 75 "75th" 99 "99th") 									///
		xtitle("Rank of Providers in Country", placement(left))	ytitle(" ") 						///
		xsize(7) graphregion(color(white)) xscale(noli titlegap(2)) yscale(noli) 					///
		bgcolor(white) legend(order(1 "Guinea Bissau" 2 "Kenya 2012" 3 "Kenya 2018"					///
		4 "Madagascar" 5 "Mozambique" 6 "Malawi" 7 "Niger" 8 "Nigeria" 9 "Sierra Leone"				///
		10 "Togo" 11 "Tanzania 2014" 12 "Tanzania 2016" 13 "Uganda") symy(2) symx(4) size(small) 	///
		c(1) ring(1) pos(3) region(lc(none) fc(none))) 												///
		title("Percent of Conditions Treated Correctly", size(medium) justification(left) color(black) span pos(11)) 
	graph export "$EL_out/Final/Vignettes/treat_percentile_lowess_2.png", replace as(png)	
}		 

/****************************************************************************
 			Create scatter line graph for provider age 
*****************************************************************************/
if $sectionB {	
	
	replace provider_age1 = . if provider_age1>80 | provider_age1<=19

	lpoly percent_correctt provider_age1, 																					///
		degree(1) jitter(10) m(x) mc(black%10) lineopts(lw(thick)) graphregion(color(white)) 								///
		title("Percent of Conditions Treated Correctly", size(medium) justification(left) color(black) span pos(11)) 		///
		xtitle("Provider's age  {&rarr}", placement(left) justification(left)) xscale(titlegap(2)) 							///
		ylab(0 "0" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", angle(0) nogrid) yscale(noli) bgcolor(white) ytitle("") 	///
		note(" ") xscale(noli)
	graph export "$EL_out/Final/Vignettes/treat_scatter_age.png", width(2000) replace
	
	tw  (histogram provider_age1, freq bin(12)  lw(med) fc(gs16) lc(gs13) gap(10) yaxis(2)) || 	///
		(lpoly percent_correctt provider_age1 if countrycode== 1, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 2, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 3, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 4, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 5, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 6, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 7, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 8, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 9, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 10, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 11, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 12, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1 if countrycode== 13, bwidth(1.2) lwidth(0.5))		///
		(lpoly percent_correctt provider_age1, bwidth(1.2) lwidth(1.5) lcolor(cranberry)),		///
		ylabel(0 "0" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", labsize(small) angle(0) nogrid) 					///
		xlabel(20 "20" 40 "40" 60 "60" 80 "80", labsize(small)) ytitle("Frequency (Histogram)", axis(2) size(small))	///
		xtitle("Provider Age {&rarr}", size(small) placement(left))	ytitle(" ") yscale(noli axis(2))					///
		ytitle("Percent of Conditions Treated Correctly", size(small)) 													///
		xsize(7) graphregion(color(white)) xscale(noli titlegap(2)) yscale(noli) 										///
		yla(, axis(2) angle(0) nogrid labsize(vsmall))	yscale(alt) yscale(alt axis(2))									///
		bgcolor(white) legend(order(2 "Guinea Bissau" 3 "Kenya 2012" 4 "Kenya 2018"										///
		5 "Madagascar" 6 "Mozambique" 7 "Malawi" 8 "Niger" 9 "Nigeria" 10 "Sierra Leone"								///
		11 "Togo" 12 "Tanzania 2014" 13 "Tanzania 2016" 14 "Uganda" 15 "All Countries") symy(2) 						///
		symx(4) size(small) c(1) ring(1) pos(3) region(lc(none) fc(none))) 									
	graph export "$EL_out/Final/Vignettes/treat_scatter_age.png", width(2000) replace
}

/****************************************************************************
 			Create scatter line graph for provider knowledge  
*****************************************************************************/
if $sectionC {	
	
	lpoly percent_correctt theta_mle, ///
			degree(1) jitter(10) m(x) mc(black%10) lineopts(lw(thick)) graphregion(color(white)) 								///
			title("Percent of Conditions Treated Correctly", size(medium) justification(left) color(black) span pos(11)) 		///
			xtitle("Provider's knowledge score {&rarr}", placement(left) justification(left)) xscale(titlegap(2))	 			///
			ylab(0 "0" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", angle(0) nogrid) yscale(noli) bgcolor(white) ytitle("") 	///
			xlabel(-5 (1) 5) xscale(noli) note("")																				   
	graph export "$EL_out/Final/Vignettes/treat_scatter_knowledge.png", width(2000) replace	
}
 	
/****************************************************************************
 			Create line graph for provider knowledge & age  
*****************************************************************************/
if $sectionD {	
		
	replace provider_age1 = . if provider_age1>80 | provider_age1<=19
	
	tw  (histogram provider_age1, freq bin(12) lw(med) lc(gs13) fc(gs16) gap(10) yaxis(2)) || ///
		(lpoly theta_mle provider_age1 if countrycode== 1, bwidth(1.2) lwidth(0.5))		///
		(lpoly theta_mle provider_age1 if countrycode== 2, bwidth(1.2) lwidth(0.5))		///
		(lpoly theta_mle provider_age1 if countrycode== 3, bwidth(1.2) lwidth(0.5))		///
		(lpoly theta_mle provider_age1 if countrycode== 4, bwidth(1.2) lwidth(0.5))		///
		(lpoly theta_mle provider_age1 if countrycode== 5, bwidth(1.2) lwidth(0.5))		///
		(lpoly theta_mle provider_age1 if countrycode== 6, bwidth(1.2) lwidth(0.5))		///
		(lpoly theta_mle provider_age1 if countrycode== 7, bwidth(1.2) lwidth(0.5))		///
		(lpoly theta_mle provider_age1 if countrycode== 8, bwidth(1.2) lwidth(0.5))		///
		(lpoly theta_mle provider_age1 if countrycode== 9, bwidth(1.2) lwidth(0.5))		///
		(lpoly theta_mle provider_age1 if countrycode== 10, bwidth(1.2) lwidth(0.5))	///
		(lpoly theta_mle provider_age1 if countrycode== 11, bwidth(1.2) lwidth(0.5))	///
		(lpoly theta_mle provider_age1 if countrycode== 12, bwidth(1.2) lwidth(0.5))	///
		(lpoly theta_mle provider_age1 if countrycode== 13, bwidth(1.2) lwidth(0.5))	///
		(lpoly theta_mle provider_age1, bwidth(1.2) lwidth(1.5) lcolor(cranberry)),		///
		ylabel(-3(1)3, labsize(small) angle(0) nogrid)   												///
		xlabel(20 "20" 40 "40" 60 "60" 80 "80", labsize(small)) 										///
		xtitle("Provider Age {&rarr}", size(small) placement(left))	ytitle(" ") yscale(noli axis(2))	///
		ytitle("Knowledge Score", size(small)) ytitle("Frequency (Histogram)", axis(2) size(small))		///
		xsize(7) graphregion(color(white)) xscale(noli titlegap(2)) yscale(noli) 						///
		yla(, axis(2) angle(0) nogrid labsize(vsmall))	yscale(alt) yscale(alt axis(2))					///
		bgcolor(white) legend(order(2 "Guinea Bissau" 3 "Kenya 2012" 4 "Kenya 2018"						///
		5 "Madagascar" 6 "Mozambique" 7 "Malawi" 8 "Niger" 9 "Nigeria" 10 "Sierra Leone"				///
		11 "Togo" 12 "Tanzania 2014" 13 "Tanzania 2016" 14 "Uganda" 15 "All Countries") symy(2) 		///
		symx(4) size(small) c(1) ring(1) pos(3) region(lc(none) fc(none))) 								
	graph export "$EL_out/Final/Vignettes/treat_knowledge_score.png", width(2000) replace
	
}	
	
**************************************** End of do-file ************************************************
