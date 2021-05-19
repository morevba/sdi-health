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
       ** Last date modified: 	May 18th 2021
	   
 *************************************************************************/
 
		//Sections
		global sectionA		0 // table - Facilities surveyed replication
		global sectionB		0 // table - Facilities surveyed  
		global sectionC		0 // table - Providers survey 
		global sectionD		0 // table - Providers identity survey 
		global sectionE		0 // table - diagnostic knowledge summary 
		global sectionF		0 // table - treatment knowledge summary 
		global sectionG		1 // table - descriptive stats of providers 
		
/*****************************
		Provider level   
******************************/	
	
	*Open harmonized dataset 
	use  "$EL_dtFin/Final_pl.dta", clear   
				
	*Create rural/urban indicator 
	gen			rural = 1 if fac_type == 1 | fac_type == 2 | fac_type == 3
	replace 	rural = 0 if fac_type == 4 | fac_type == 5 | fac_type == 6
	lab define  rur_lab 1 "Rural" 0 "Urban"
	label val 	rural rur_lab
	
	*Recode variables 
	recode public (6/7=0)
	
	*Drop observations that skipped all vignettes 
	drop if num_skipped == 8 | num_skipped == .
	
/**********************************************************
				Facility & Provider Characteristics 
***********************************************************/		
  	
	*Restrict to key variables needed for table 
	keep	rural public facility_level facility_id				///
			provider_cadre1 provider_mededuc1 provider_male1 cy ///
			skip_* *_history_* *_exam_* *_test_* diag* treat*	///
			tb_antibio diar_antibio
			
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
			replace `disease'_questions = . if skip_`disease'==1 | skip_`disease'==. | `disease'_questions==0
			replace `disease'_questions_num = . if skip_`disease'==1 | skip_`disease'==. | `disease'_questions==0 | `disease'_questions==.

			lab var `disease'_questions "Number of possible `disease' history questions in survey" 
			lab var `disease'_questions_num "Number of `disease' history questions asked"
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
			replace `disease'_exams = . if skip_`disease'==1 | skip_`disease'==. | `disease'_exams==0
			replace `disease'_exams_num = . if skip_`disease'==1 | skip_`disease'==. | `disease'_exams==0 | `disease'_exams==.

			lab var `disease'_exams "Number of possible `disease' physical exams in survey"
			lab var `disease'_exams_num "Number of `disease' physical exams done"
		}
		local vexam = ""
	}
	
	*Create variables needed for table 
	egen 	total_questions		= rowtotal(*_questions_num)
	egen 	total_exams 		= rowtotal(*_exams_num)
	egen	total_tests 		= rowtotal(*_tests_num)
	lab var total_questions 	"Total number of history questions asked across all vignettes"
	lab var total_exams 		"Total number of physical exams done across all vignettes"
	lab var total_tests			"Total number of tests run all vignettes"
 
/****************************************************************************
 			table of facility characteristics - replication 
*****************************************************************************/		
if $sectionA {	
	
preserve 	
	*Remove duplicate facility ids - only need 1 facility id 
	bysort 	cy facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		
	
	drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
	drop 	facility_id_dup				// this variable is no longer needed 	
		
	*Create dummy variables for each variable 
	tabulate rural, gen(r_)
		rename r_1 Rural
		rename r_2 Urban
	tabulate public, gen(p_)
		rename p_1 Public
		rename p_2 Private
	tabulate facility_level, gen(f_)
		rename f_1 Hospital 
		rename f_2 Health_Center
		rename f_3 Dispensary 
 
	eststo clear  
 
	estpost tabstat Rural Urban Public Private Hospital Health_Center Dispensary,	///
					by(cy) stat(sum n) column(statistics) nototal  
	 
	matrix colupct = e(sum) 	// create matrix with sums
	matrix rowpct  = e(count)	// create matrix with counts  
	
	*Divide the matrices to create row percentages 
	mata : st_matrix("perc", 100 * st_matrix("colupct") :/ st_matrix("rowpct"))
	
	*Input the new row percentages into the rowpct matrix  
	forvalue c = 1/91 {
		
		matrix rowpct[1,`c'] = perc[1,`c'] 
		
	}
	
	*Add row percentages to matrxi 
	estadd matrix rowpct // add matrix 'colupct' to stored estimates
 
	*Output the table with facility level descriptives 
	esttab  using "$EL_out/Final/Vignettes/table_1.csv",	///
		    cell((sum rowpct(fmt(%5.2f) par))) 				///
			modelwidth(10 10) collabels(none)				///
			unstack nonumbers nomtitles  replace 
restore 			
}

/****************************************************************************
 			Table of facility characteristics - new  
*****************************************************************************/	
if $sectionB {	
	
preserve 	
	*Remove duplicate facility ids - only need 1 facility id 
	bysort 	cy facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		
	
	drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
	drop 	facility_id_dup				// this variable is no longer needed 	
	
	*This creates the numbers for each row 
	forvalues num = 1/28 {
		
		estpost	tab cy rural 						// This creates the number stats for col 1 & 2
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	D`num'r = stat1[1,`num'] 
		di		`D`num'r'
		
		matrix	list e(rowpct)						// This stores the percentages in a local
		matrix 	stat2 = e(rowpct)  
		local 	P`num'r = string(stat2[1,`num'],"%9.0f")  
		di		`P`num'r'
	}
		
	forvalues num = 1/28 {		
		estpost	tab cy public 						// This creates the number stats for col 3 & 4
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	B`num'r = stat1[1,`num'] 
		di		`B`num'r'
		
		matrix	list e(rowpct)						// This stores the percentages in a local 
		matrix 	stat2 = e(rowpct)  
		local 	T`num'r = string(stat2[1,`num'],"%9.0f")  
		di		`T`num'r'
	}
	
	forvalues num = 1/56 {	
		estpost	tab cy facility_level 				// This creates the number stats for col 5,6 & 7
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	H`num'r = stat1[1,`num'] 
		di		`H`num'r'
		
		matrix	list e(rowpct)						// This stores the percentages in a local 
		matrix 	stat2 = e(rowpct)  
		local 	A`num'r = string(stat2[1,`num'],"%9.0f")  
		di		`A`num'r'
	}
	
	forvalues num = 1/13 {	
		estpost	tab cy  					// This creates the number stats for 8
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di		`N`num'r'
	}
	
	
	*Create and build out latex table 
	file open 	descTable using "$EL_out/Final/Tex files/vig_table_fac.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{9}{c}}" _n ///
	"\hline\hline" _n ///
	"&\multicolumn{2}{c}{Urban vs. Rural} &\multicolumn{2}{c}{Private vs. Public}  &\multicolumn{3}{c}{Facility Level}    \\\cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-8}" _n ///
	"&\multicolumn{1}{c}{Urban}&\multicolumn{1}{c}{Rural}&\multicolumn{1}{c}{Private}&\multicolumn{1}{c}{Public}&\multicolumn{1}{c}{Hospital}&\multicolumn{1}{c}{Health Center}&\multicolumn{1}{c}{Health Post}&\multicolumn{1}{c}{Total Facilities}&\\" _n ///
	"\hline" _n ///
	"Guinea Bissau&  	{`D1r'(`P1r'\%)}&	 {`D15r'(`P15r'\%)}&	{`B1r'(`T1r'\%)}&	 {`B15r'(`T15r'\%)}&	{`H1r'(`A1r'\%)}&		{`H15r'(`A15r'\%)}&		{`H29r'(`A29r'\%)}&		{`N1r'}\\" _n ///
	"Kenya 2012&  		{`D2r'(`P2r'\%)}&  	 {`D16r'(`P16r'\%)}&  	{`B2r'(`T2r'\%)}&	 {`B16r'(`T16r'\%)}&    {`H2r'(`A2r'\%)}&		{`H16r'(`A16r'\%)}&		{`H30r'(`A30r'\%)}&		{`N2r'}\\" _n ///
	"Kenya 2018&	    {`D3r'(`P3r'\%)}&  	 {`D17r'(`P17r'\%)}&  	{`B3r'(`T3r'\%)}&    {`B17r'(`T17r'\%)}&	{`H3r'(`A3r'\%)}&		{`H17r'(`A17r'\%)}&		{`H31r'(`A31r'\%)}&		{`N3r'}\\" _n ///
	"Madagascar&	    {`D4r'(`P4r'\%)}&  	 {`D18r'(`P18r'\%)}&  	{`B4r'(`T4r'\%)}&    {`B18r'(`T18r'\%)}&	{`H4r'(`A4r'\%)}&		{`H18r'(`A18r'\%)}&		{`H32r'(`A32r'\%)}&		{`N4r'}\\" _n ///
	"Mozambique&	    {`D5r'(`P5r'\%)}&  	 {`D19r'(`P19r'\%)}&  	{`B5r'(`T5r'\%)}&    {`B19r'(`T19r'\%)}&	{`H5r'(`A5r'\%)}&		{`H19r'(`A19r'\%)}&		{`H33r'(`A33r'\%)}&		{`N5r'}\\" _n ///
	"Malawi&	      	{`D6r'(`P6r'\%)}&  	 {`D20r'(`P20r'\%)}&  	{`B6r'(`T6r'\%)}&    {`B20r'(`T20r'\%)}&	{`H6r'(`A6r'\%)}&		{`H20r'(`A20r'\%)}&		{`H34r'(`A34r'\%)}&		{`N6r'}\\" _n ///
	"Niger&	      		{`D7r'(`P7r'\%)}&  	 {`D21r'(`P21r'\%)}&  	{`B7r'(`T7r'\%)}&    {`B21r'(`T21r'\%)}&	{`H7r'(`A7r'\%)}&		{`H21r'(`A21r'\%)}&		{`H35r'(`A35r'\%)}&		{`N7r'}\\" _n ///
	"Nigeria&	      	{`D8r'(`P8r'\%)}&	 {`D22r'(`P22r'\%)}&  	{`B8r'(`T8r'\%)}&    {`B22r'(`T22r'\%)}&	{`H8r'(`A8r'\%)}&		{`H22r'(`A22r'\%)}&		{`H36r'(`A36r'\%)}&		{`N8r'}\\" _n ///
	"Sierra Leone&	    {`D9r'(`P9r'\%)}&	 {`D23r'(`P23r'\%)}&  	{`B9r'(`T9r'\%)}&    {`B23r'(`T23r'\%)}&	{`H9r'(`A9r'\%)}&		{`H23r'(`A23r'\%)}&		{`H37r'(`A37r'\%)}&		{`N9r'}\\" _n ///
	"Togo&	      		{`D10r'(`P10r'\%)}&  {`D24r'(`P24r'\%)}&  	{`B10r'(`T10r'\%)}&  {`B24r'(`T24r'\%)}&	{`H10r'(`A10r'\%)}&		{`H24r'(`A24r'\%)}&		{`H38r'(`A38r'\%)}&		{`N10r'}\\" _n ///
	"Tanzania 2014&	    {`D11r'(`P11r'\%)}&  {`D25r'(`P25r'\%)}&  	{`B11r'(`T11r'\%)}&  {`B25r'(`T25r'\%)}&	{`H11r'(`A11r'\%)}&		{`H25r'(`A25r'\%)}&		{`H39r'(`A39r'\%)}&		{`N11r'}\\" _n ///
	"Tanzania 2016&	    {`D12r'(`P12r'\%)}&  {`D26r'(`P26r'\%)}&  	{`B12r'(`T12r'\%)}&  {`B26r'(`T26r'\%)}&	{`H12r'(`A12r'\%)}&		{`H26r'(`A26r'\%)}&		{`H40r'(`A40r'\%)}&		{`N12r'}\\" _n ///
	"Uganda&	      	{`D13r'(`P13r'\%)}&  {`D27r'(`P27r'\%)}&  	{`B13r'(`T13r'\%)}&  {`B27r'(`T27r'\%)}&	{`H13r'(`A13r'\%)}&		{`H27r'(`A27r'\%)}&		{`H41r'(`A41r'\%)}&		{`N13r'}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{9}{l}{\footnotesize Certain facilities contained missing data for the above categories}\\" _n ///
	"\end{tabular}"
	file close 	descTable	
restore 	
	}			
	 	
/****************************************************************************
 			Table of provider characteristics   
*****************************************************************************/	
if $sectionC {	
	
	*This creates the numbers for each row 
	forvalues num = 1/28 {
		
		estpost	tab cy rural 						// This creates the number stats for col 1 & 2
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	D`num'r = stat1[1,`num'] 
		di		`D`num'r'
		
		matrix	list e(rowpct)						// This stores the percentages in a local
		matrix 	stat2 = e(rowpct)  
		local 	P`num'r = string(stat2[1,`num'],"%9.0f")  
		di		`P`num'r'
	}
		
	forvalues num = 1/28 {		
		estpost	tab cy public 						// This creates the number stats for col 3 & 4
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	B`num'r = stat1[1,`num'] 
		di		`B`num'r'
		
		matrix	list e(rowpct)						// This stores the percentages in a local 
		matrix 	stat2 = e(rowpct)  
		local 	T`num'r = string(stat2[1,`num'],"%9.0f")  
		di		`T`num'r'
	}
	
	forvalues num = 1/56 {	
		estpost	tab cy facility_level 				// This creates the number stats for col 5,6 & 7
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	H`num'r = stat1[1,`num'] 
		di		`H`num'r'
		
		matrix	list e(rowpct)						// This stores the percentages in a local 
		matrix 	stat2 = e(rowpct)  
		local 	A`num'r = string(stat2[1,`num'],"%9.0f")  
		di		`A`num'r'
	}
	
	forvalues num = 1/13 {	
		estpost	tab cy  					// This creates the number stats for 8
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di		`N`num'r'
	}
	
	*Create and build out latex table 
	file open 	descTable using "$EL_out/Final/Tex files/vig_table_prov.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{9}{c}}" _n ///
	"\hline\hline" _n ///
	"&\multicolumn{2}{c}{Urban vs. Rural} &\multicolumn{2}{c}{Private vs. Public}  &\multicolumn{3}{c}{Facility Level}    \\\cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-8}" _n ///
	"&\multicolumn{1}{c}{Urban}&\multicolumn{1}{c}{Rural}&\multicolumn{1}{c}{Private}&\multicolumn{1}{c}{Public}&\multicolumn{1}{c}{Hospital}&\multicolumn{1}{c}{Health Center}&\multicolumn{1}{c}{Health Post}&\multicolumn{1}{c}{Total Providers}&\\" _n ///
	"\hline" _n ///
	"Guinea Bissau&  	{`D1r'(`P1r'\%)}&	 {`D15r'(`P15r'\%)}&	{`B1r'(`T1r'\%)}&	 {`B15r'(`T15r'\%)}&	{`H1r'(`A1r'\%)}&		{`H15r'(`A15r'\%)}&		{`H29r'(`A29r'\%)}&		{`N1r'}\\" _n ///
	"Kenya 2012&  		{`D2r'(`P2r'\%)}&  	 {`D16r'(`P16r'\%)}&  	{`B2r'(`T2r'\%)}&	 {`B16r'(`T16r'\%)}&    {`H2r'(`A2r'\%)}&		{`H16r'(`A16r'\%)}&		{`H30r'(`A30r'\%)}&		{`N2r'}\\" _n ///
	"Kenya 2018&	    {`D3r'(`P3r'\%)}&  	 {`D17r'(`P17r'\%)}&  	{`B3r'(`T3r'\%)}&    {`B17r'(`T17r'\%)}&	{`H3r'(`A3r'\%)}&		{`H17r'(`A17r'\%)}&		{`H31r'(`A31r'\%)}&		{`N3r'}\\" _n ///
	"Madagascar&	    {`D4r'(`P4r'\%)}&  	 {`D18r'(`P18r'\%)}&  	{`B4r'(`T4r'\%)}&    {`B18r'(`T18r'\%)}&	{`H4r'(`A4r'\%)}&		{`H18r'(`A18r'\%)}&		{`H32r'(`A32r'\%)}&		{`N4r'}\\" _n ///
	"Mozambique&	    {`D5r'(`P5r'\%)}&  	 {`D19r'(`P19r'\%)}&  	{`B5r'(`T5r'\%)}&    {`B19r'(`T19r'\%)}&	{`H5r'(`A5r'\%)}&		{`H19r'(`A19r'\%)}&		{`H33r'(`A33r'\%)}&		{`N5r'}\\" _n ///
	"Malawi&	      	{`D6r'(`P6r'\%)}&  	 {`D20r'(`P20r'\%)}&  	{`B6r'(`T6r'\%)}&    {`B20r'(`T20r'\%)}&	{`H6r'(`A6r'\%)}&		{`H20r'(`A20r'\%)}&		{`H34r'(`A34r'\%)}&		{`N6r'}\\" _n ///
	"Niger&	      		{`D7r'(`P7r'\%)}&  	 {`D21r'(`P21r'\%)}&  	{`B7r'(`T7r'\%)}&    {`B21r'(`T21r'\%)}&	{`H7r'(`A7r'\%)}&		{`H21r'(`A21r'\%)}&		{`H35r'(`A35r'\%)}&		{`N7r'}\\" _n ///
	"Nigeria&	      	{`D8r'(`P8r'\%)}&	 {`D22r'(`P22r'\%)}&  	{`B8r'(`T8r'\%)}&    {`B22r'(`T22r'\%)}&	{`H8r'(`A8r'\%)}&		{`H22r'(`A22r'\%)}&		{`H36r'(`A36r'\%)}&		{`N8r'}\\" _n ///
	"Sierra Leone&	    {`D9r'(`P9r'\%)}&	 {`D23r'(`P23r'\%)}&  	{`B9r'(`T9r'\%)}&    {`B23r'(`T23r'\%)}&	{`H9r'(`A9r'\%)}&		{`H23r'(`A23r'\%)}&		{`H37r'(`A37r'\%)}&		{`N9r'}\\" _n ///
	"Togo&	      		{`D10r'(`P10r'\%)}&  {`D24r'(`P24r'\%)}&  	{`B10r'(`T10r'\%)}&  {`B24r'(`T24r'\%)}&	{`H10r'(`A10r'\%)}&		{`H24r'(`A24r'\%)}&		{`H38r'(`A38r'\%)}&		{`N10r'}\\" _n ///
	"Tanzania 2014&	    {`D11r'(`P11r'\%)}&  {`D25r'(`P25r'\%)}&  	{`B11r'(`T11r'\%)}&  {`B25r'(`T25r'\%)}&	{`H11r'(`A11r'\%)}&		{`H25r'(`A25r'\%)}&		{`H39r'(`A39r'\%)}&		{`N11r'}\\" _n ///
	"Tanzania 2016&	    {`D12r'(`P12r'\%)}&  {`D26r'(`P26r'\%)}&  	{`B12r'(`T12r'\%)}&  {`B26r'(`T26r'\%)}&	{`H12r'(`A12r'\%)}&		{`H26r'(`A26r'\%)}&		{`H40r'(`A40r'\%)}&		{`N12r'}\\" _n ///
	"Uganda&	      	{`D13r'(`P13r'\%)}&  {`D27r'(`P27r'\%)}&  	{`B13r'(`T13r'\%)}&  {`B27r'(`T27r'\%)}&	{`H13r'(`A13r'\%)}&		{`H27r'(`A27r'\%)}&		{`H41r'(`A41r'\%)}&		{`N13r'}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{9}{l}{\footnotesize Certain providers contained missing data for the above categories}\\" _n ///
	"\end{tabular}"
	file close 	descTable	 	
	}			
		 
/****************************************************************************
 			Table of provider identity characteristics   
*****************************************************************************/	
if $sectionD {	


	*This creates the numbers for each row 
	forvalues num = 1/48 {
		estpost	tab cy provider_mededuc1 			// This creates the number stats for col 1 & 2
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	D`num'r = stat1[1,`num'] 
		di		`D`num'r'
		
		matrix	list e(rowpct)						// This stores the percentages in a local
		matrix 	stat2 = e(rowpct)  
		local 	P`num'r = string(stat2[1,`num'],"%9.0f")  
		di		`P`num'r'
	}
			
	forvalues num = 1/42 {		
		estpost	tab cy provider_cadre1 				// This creates the number stats for col 3 & 4
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	B`num'r = stat1[1,`num'] 
		di		`B`num'r'
		
		matrix	list e(rowpct)						// This stores the percentages in a local 
		matrix 	stat2 = e(rowpct)  
		local 	T`num'r = string(stat2[1,`num'],"%9.0f")  
		di		`T`num'r'
	}
	
	forvalues num = 1/28 {	
		estpost	tab cy provider_male1 				// This creates the number stats for col 5,6 & 7
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	H`num'r = stat1[1,`num'] 
		di		`H`num'r'
		
		matrix	list e(rowpct)						// This stores the percentages in a local 
		matrix 	stat2 = e(rowpct)  
		local 	A`num'r = string(stat2[1,`num'],"%9.0f")  
		di		`A`num'r'
	}
	
	forvalues num = 1/13 {	
		estpost	tab cy  							// This creates the number stats for 8
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di		`N`num'r'
	}
		
	*Create and build out latex table 
	file open 	descTable using "$EL_out/Final/Tex files/vig_table_prov_2.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{11}{c}}" _n ///
	"\hline\hline" _n ///
	"&\multicolumn{4}{c}{Medical Education} &\multicolumn{3}{c}{Profession}  &\multicolumn{2}{c}{Gender}    \\\cmidrule(lr){2-5}\cmidrule(lr){6-8}\cmidrule(lr){9-10}" _n ///
	"&\multicolumn{1}{c}{None}&\multicolumn{1}{c}{Certificate}&\multicolumn{1}{c}{Diploma}&\multicolumn{1}{c}{Masters+}&\multicolumn{1}{c}{Doctor}&\multicolumn{1}{c}{Nurse}&\multicolumn{1}{c}{Para-Professional}&\multicolumn{1}{c}{Female}&\multicolumn{1}{c}{Male}&\multicolumn{1}{c}{Total Providers}&\\" _n ///
	"\hline" _n ///
	"Guinea Bissau&  	{`D1r'(`P1r'\%)}&	 {`D13r'(`P13r'\%)}&	{`D25r'(`P25r'\%)}&		{`D37r'(`P37r'\%)}&		{`B1r'(`T1r'\%)}&	 {`B15r'(`T15r'\%)}&	{`B29r'(`T29r'\%)}&		{`H1r'(`A1r'\%)}&		{`H15r'(`A15r'\%)}&		{`N1r'}\\" _n ///
	"Kenya 2012&  		{n/a}&  	 		 {n/a}&  				{n/a}& 					{n/a}&					{`B2r'(`T2r'\%)}&	 {`B16r'(`T16r'\%)}&    {`B30r'(`T30r'\%)}&		{`H2r'(`A2r'\%)}&		{`H16r'(`A16r'\%)}&		{`N2r'}\\" _n ///
	"Kenya 2018&	    {`D2r'(`P2r'\%)}&  	 {`D14r'(`P14r'\%)}&  	{`D26r'(`P26r'\%)}& 	{`D38r'(`P38r'\%)}&		{`B3r'(`T3r'\%)}&    {`B17r'(`T17r'\%)}&	{`B31r'(`T31r'\%)}&		{`H3r'(`A3r'\%)}&		{`H17r'(`A17r'\%)}&		{`N3r'}\\" _n ///
	"Madagascar&	    {`D3r'(`P3r'\%)}&  	 {`D15r'(`P15r'\%)}&  	{`D27r'(`P27r'\%)}& 	{`D39r'(`P39r'\%)}&		{`B4r'(`T4r'\%)}&    {`B18r'(`T18r'\%)}&	{`B32r'(`T32r'\%)}&		{`H4r'(`A4r'\%)}&		{`H18r'(`A18r'\%)}&		{`N4r'}\\" _n ///
	"Mozambique&	    {`D4r'(`P4r'\%)}&  	 {`D16r'(`P16r'\%)}&  	{`D28r'(`P28r'\%)}& 	{`D40r'(`P40r'\%)}&		{`B5r'(`T5r'\%)}&    {`B19r'(`T19r'\%)}&	{`B33r'(`T33r'\%)}&		{`H5r'(`A5r'\%)}&		{`H19r'(`A19r'\%)}&		{`N5r'}\\" _n ///
	"Malawi&	      	{`D5r'(`P5r'\%)}&  	 {`D17r'(`P17r'\%)}&  	{`D29r'(`P29r'\%)}& 	{`D41r'(`P41r'\%)}&		{`B6r'(`T6r'\%)}&    {`B20r'(`T20r'\%)}&	{`B34r'(`T34r'\%)}&		{`H6r'(`A6r'\%)}&		{`H20r'(`A20r'\%)}&		{`N6r'}\\" _n ///
	"Niger&	      		{`D6r'(`P6r'\%)}&  	 {`D18r'(`P18r'\%)}&  	{`D30r'(`P30r'\%)}& 	{`D42r'(`P42r'\%)}&		{`B7r'(`T7r'\%)}&    {`B21r'(`T21r'\%)}&	{`B35r'(`T35r'\%)}&		{`H7r'(`A7r'\%)}&		{`H21r'(`A21r'\%)}&		{`N7r'}\\" _n ///
	"Nigeria&	      	{`D7r'(`P7r'\%)}&	 {`D19r'(`P19r'\%)}&  	{`D31r'(`P31r'\%)}& 	{`D43r'(`P43r'\%)}&		{`B8r'(`T8r'\%)}&    {`B22r'(`T22r'\%)}&	{`B36r'(`T36r'\%)}&		{`H8r'(`A8r'\%)}&		{`H22r'(`A22r'\%)}&		{`N8r'}\\" _n ///
	"Sierra Leone&	    {`D8r'(`P8r'\%)}&	 {`D20r'(`P20r'\%)}&  	{`D32r'(`P32r'\%)}& 	{`D44r'(`P44r'\%)}&		{`B9r'(`T9r'\%)}&    {`B23r'(`T23r'\%)}&	{`B37r'(`T37r'\%)}&		{`H9r'(`A9r'\%)}&		{`H23r'(`A23r'\%)}&		{`N9r'}\\" _n ///
	"Togo&	      		{`D9r'(`P9r'\%)}&  	 {`D21r'(`P21r'\%)}&  	{`D33r'(`P33r'\%)}& 	{`D45r'(`P45r'\%)}&		{`B10r'(`T10r'\%)}&  {`B24r'(`T24r'\%)}&	{`B38r'(`T38r'\%)}&		{`H10r'(`A10r'\%)}&		{`H24r'(`A24r'\%)}&		{`N10r'}\\" _n ///
	"Tanzania 2014&	    {`D10r'(`P10r'\%)}&  {`D22r'(`P22r'\%)}&  	{`D34r'(`P34r'\%)}& 	{`D46r'(`P46r'\%)}&		{`B11r'(`T11r'\%)}&  {`B25r'(`T25r'\%)}&	{`B39r'(`T39r'\%)}&		{`H11r'(`A11r'\%)}&		{`H25r'(`A25r'\%)}&		{`N11r'}\\" _n ///
	"Tanzania 2016&	    {`D11r'(`P11r'\%)}&  {`D23r'(`P23r'\%)}&  	{`D35r'(`P35r'\%)}& 	{`D47r'(`P47r'\%)}&		{`B12r'(`T12r'\%)}&  {`B26r'(`T26r'\%)}&	{`B40r'(`T40r'\%)}&		{`H12r'(`A12r'\%)}&		{`H26r'(`A26r'\%)}&		{`N12r'}\\" _n ///
	"Uganda&	      	{n/a}&  			 {n/a}&  				{n/a}&					{n/a}&					{`B13r'(`T13r'\%)}&  {`B27r'(`T27r'\%)}&	{`B41r'(`T41r'\%)}&		{`H13r'(`A13r'\%)}&		{`H27r'(`A27r'\%)}&		{`N13r'}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{11}{l}{\footnotesize Certain providers contained missing data for the above categories}\\" _n ///
	"\end{tabular}"
	file close 	descTable	
}

/*****************************************************************************
			Table of diagnostic knowledge summary 
******************************************************************************/
if $sectionE {	
	
	*Replace the missing 
	replace	skip_diarrhea  = . if skip_diarrhea  == 1 & cy == "MWI_2019"
	replace	skip_pneumonia = . if skip_pneumonia == 1 & cy == "MWI_2019"
	replace	skip_diabetes = .  if skip_diabetes  == 1 & cy == "MWI_2019"
	replace	skip_tb = .  	   if skip_tb  		 == 1 & cy == "MWI_2019"
	replace	skip_malaria = .   if skip_malaria   == 1 & cy == "MWI_2019"
	replace	skip_pph = . 	   if skip_pph   	 == 1 & cy == "MWI_2019"
	replace	skip_asphyxia = .  if skip_asphyxia  == 1 & cy == "MWI_2019"
 	
	*Code country year variable 
	encode cy, gen(cy_code)
	
	*This creates the numbers for each row - Number of health providers for each row  
	forvalues num = 1/13 {
		
		estpost	tab cy skip_diarrhea if skip_diarrhea == 0		// This creates the number stats for row 1
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	A`num'r = stat1[1,`num'] 
		di		`A`num'r'
		
		estpost	tab cy skip_diarrhea if skip_diarrhea == 1		// This creates the number stats for row 2
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	B`num'r = stat1[1,`num'] 
		di		`B`num'r'
		
		sum 	total_questions if skip_diarrhea == 0 & cy_code == `num'	// This creates the number stats for row 3
		local 	C`num'r = string(`r(mean)',"%9.2f") 
		di		`C`num'r'
		
		sum 	total_exams if skip_diarrhea == 0	& cy_code == `num'	// This creates the number stats for row 4
		local 	D`num'r = string(`r(mean)',"%9.2f") 
		di		`D`num'r'
	}
	
	forvalues num = 1/13 {
		
		estpost	tab cy skip_pneumonia if skip_pneumonia == 0		// This creates the number stats for row 5
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	E`num'r = stat1[1,`num'] 
		di		`E`num'r'
		
		estpost	tab cy skip_pneumonia if skip_pneumonia == 1		// This creates the number stats for row 6
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	F`num'r = stat1[1,`num'] 
		di		`F`num'r'
		
		sum 	total_questions if skip_pneumonia == 0 & cy_code == `num'	// This creates the number stats for row 7
		local 	G`num'r = string(`r(mean)',"%9.2f") 
		di		`G`num'r'
		
		sum 	total_exams if skip_pneumonia == 0	& cy_code == `num'	// This creates the number stats for row 8
		local 	H`num'r = string(`r(mean)',"%9.2f") 
		di		`H`num'r'
	}
	
	forvalues num = 1/13 {
		
		estpost	tab cy skip_diabetes if skip_diabetes == 0		// This creates the number stats for row 9
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	I`num'r = stat1[1,`num'] 
		di		`I`num'r'
		
		estpost	tab cy skip_diabetes if skip_diabetes == 1		// This creates the number stats for row 10
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	J`num'r = stat1[1,`num'] 
		di		`J`num'r'
		
		sum 	total_questions if skip_diabetes == 0 & cy_code == `num'	// This creates the number stats for row 11
		local 	K`num'r = string(`r(mean)',"%9.2f") 
		di		`K`num'r'
		
		sum 	total_exams if skip_diabetes == 0 & cy_code == `num'		// This creates the number stats for row 12
		local 	L`num'r = string(`r(mean)',"%9.2f") 
		di		`L`num'r'
	}

	forvalues num = 1/13 {
		
		estpost	tab cy skip_tb if skip_tb == 0			// This creates the number stats for row 13
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	M`num'r = stat1[1,`num'] 
		di		`M`num'r'
		
		estpost	tab cy skip_tb if skip_tb == 1			// This creates the number stats for row 14
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di		`N`num'r'
		
		sum 	total_questions if skip_tb == 0 & cy_code == `num'	// This creates the number stats for row 15
		local 	O`num'r = string(`r(mean)',"%9.2f") 
		di		`O`num'r'
		
		sum 	total_exams if skip_tb == 0	& cy_code == `num'	// This creates the number stats for row 16
		local 	P`num'r = string(`r(mean)',"%9.2f") 
		di		`P`num'r'
	}

	forvalues num = 1/13 {
		
		estpost	tab cy skip_malaria if skip_malaria == 0			// This creates the number stats for row 17
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	Q`num'r = stat1[1,`num'] 
		di		`Q`num'r'
		
		estpost	tab cy skip_malaria if skip_malaria == 1			// This creates the number stats for row 18
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	R`num'r = stat1[1,`num'] 
		di		`R`num'r'
	
		cap	sum 	total_questions if skip_malaria == 0 & cy_code == `num'		// This creates the number stats for row 19
		cap	local 	S`num'r = string(`r(mean)',"%9.2f") 
		di			`S`num'r'
		
		cap	sum 	total_exams if skip_malaria == 0	& cy_code == `num'			// This creates the number stats for row 20
		cap	local 	T`num'r = string(`r(mean)',"%9.2f") 
		di			`T`num'r'
	}
	
	forvalues num = 1/13 {
		
		estpost	tab cy skip_pph if skip_pph == 0			// This creates the number stats for row 21
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	W`num'r = stat1[1,`num'] 
		di		`W`num'r'
		
		estpost	tab cy skip_pph if skip_pph == 1			// This creates the number stats for row 22
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	X`num'r = stat1[1,`num'] 
		di		`X`num'r'
		
		sum 	total_questions if skip_pph == 0	& cy_code == `num'	// This creates the number stats for row 23
		local 	Y`num'r = string(`r(mean)',"%9.2f") 
		di		`Y`num'r'
		
		sum 	total_exams if skip_pph == 0	& cy_code == `num'		// This creates the number stats for row 24
		local 	Z`num'r = string(`r(mean)',"%9.2f") 
		di		`Z`num'r'
	}
	
	forvalues num = 1/13 {
		
		estpost	tab cy skip_asphyxia if skip_asphyxia == 0			// This creates the number stats for row 25
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	AA`num'r = stat1[1,`num'] 
		di		`AA`num'r'
		
		estpost	tab cy skip_asphyxia if skip_asphyxia == 1			// This creates the number stats for row 26
		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	BB`num'r = stat1[1,`num'] 
		di		`BB`num'r'
		
		sum 	total_questions if skip_asphyxia == 0 & cy_code == `num'		// This creates the number stats for row 27
		local 	CC`num'r = string(`r(mean)',"%9.2f") 
		di		`CC`num'r'
		
		sum 	total_exams if skip_asphyxia == 0 & cy_code == `num'			// This creates the number stats for row 28
		local 	DD`num'r = string(`r(mean)',"%9.2f") 
		di		`DD`num'r'
	}
	
	*Create and build out latex table 
	file open 	descTable using "$EL_out/Final/Tex files/diag_summ.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{15}{c}}" _n ///
	"\hline\hline" _n ///
	"         &\multicolumn{1}{c}{" "}&\multicolumn{1}{c}{Guinea Bissau}&\multicolumn{1}{c}{Kenya 2012}&\multicolumn{1}{c}{Kenya 2018}&\multicolumn{1}{c}{Madagascar}&\multicolumn{1}{c}{Mozambique}&\multicolumn{1}{c}{Malawi}&\multicolumn{1}{c}{Niger}&\multicolumn{1}{c}{Nigeria}&\multicolumn{1}{c}{Sierra Leone}&\multicolumn{1}{c}{Togo}&\multicolumn{1}{c}{Tanzania 2014}&\multicolumn{1}{c}{Tanzania 2016}&\multicolumn{1}{c}{Uganda}&\\" _n ///
	"\hline" _n ///
	" & 				 	{Number of Observations}&	{`A1r'}&	{`A2r'}&	{`A3r'}&	{`A4r'}&	{`A5r'}&	{`A6r'}&	{`A7r'}&	{`A8r'}&	{`A9r'}&	{`A10r'}&	{`A11r'}&	{`A12r'}&	{`A13r'}\\" _n ///
	"Child&  				{Did Not Do Vignette}&  	{`B1r'}&	{0}& 	    {0}&		{`B2r'}&    {0}&		{0}&		{`B3r'}&	{`B4r'}&	{0}&		{`B5r'}&	{0}&		{0}&		{0}\\" 		_n ///
	"Diarrhea&		      	{Mean Questions}&  			{`C1r'}&	{`C2r'}&    {`C3r'}&    {`C4r'}&	{`C5r'}&	{`C6r'}&	{`C7r'}&	{`C8r'}&	{`C9r'}&	{`C10r'}&	{`C11r'}&	{`C12r'}&	{`C13r'}\\" _n ///
	" &				      	{Mean Exams}&  				{`D1r'}&	{`D2r'}&    {`D3r'}&  	{`D4r'}&	{`D5r'}&	{`D6r'}&	{`D7r'}&	{`D8r'}&	{`D9r'}&	{`D10r'}&	{`D11r'}&	{`D12r'}&	{`D13r'}\\" _n ///
	"\hline" _n ///
	" &				      	{Number of Observations}&  	{`E1r'}&	{`E2r'}&    {`E3r'}&    {`E4r'}&	{`E5r'}&	{`E6r'}&	{`E7r'}&	{`E8r'}&	{`E9r'}&	{`E10r'}&	{`E11r'}&	{`E12r'}&	{`E13r'}\\" _n ///
	"Child&			      	{Did Not Do Vignette}&  	{`F1r'}&	{0}&	    {`F2r'}&	{`F3r'}&	{0}&		{0}&		{`F4r'}&	{`F5r'}&	{`F6r'}&	{`F7r'}&	{0}&		{0}&		{0}\\" 		_n ///
	"Pneumonia&		      	{Mean Questions}& 		 	{`G1r'}&	{`G2r'}&    {`G3r'}&    {`G4r'}&	{`G5r'}&	{`G6r'}&	{`G7r'}&	{`G8r'}&	{`G9r'}&	{`G10r'}&	{`G11r'}&	{`G12r'}&	{`G13r'}\\" _n ///
	" &			      		{Mean Exams}&  				{`H1r'}&	{`H2r'}&    {`H3r'}&    {`H4r'}&	{`H5r'}&	{`H6r'}&	{`H7r'}&	{`H8r'}&	{`H9r'}&	{`H10r'}&	{`H11r'}&	{`H12r'}&	{`H13r'}\\" _n ///
	"\hline" _n ///
	" &				      	{Number of Observations}&  	{`I1r'}&	{`I2r'}&    {`I3r'}&    {`I4r'}&	{`I5r'}&	{`I6r'}&	{`I7r'}&	{`I8r'}&	{`I9r'}&	{`I10r'}&	{`I11r'}&	{`I12r'}&	{`I13r'}\\" _n ///
	"Diabetes&	      		{Did Not Do Vignette}&  	{`J1r'}&	{`J2r'}&    {`J3r'}&    {`J4r'}&	{`J5r'}&	{0}&		{`J6r'}&	{`J7r'}&	{`J8r'}&	{`J9r'}&	{0}&		{0}&		{`J10r'}\\" _n ///
	"(Type II)&		      	{Mean Questions}& 		 	{`K1r'}&	{`K2r'}&  	{`K3r'}&    {`K4r'}&	{`K5r'}&	{`K6r'}&	{`K7r'}&	{`K8r'}&	{`K9r'}&	{`K10r'}&	{`K11r'}&	{`K12r'}&	{`K13r'}\\" _n ///
	" &			      		{Mean Exams}&  				{`L1r'}&	{`L2r'}&    {`L3r'}&    {`L4r'}&	{`L5r'}&	{`L6r'}&	{`L7r'}&	{`L8r'}&	{`L9r'}&	{`L10r'}&	{`L11r'}&	{`L12r'}&	{`L13r'}\\" _n ///
	"\hline" _n ///
	" &			      		{Number of Observations}&  	{`M1r'}&	{`M2r'}&    {`M3r'}&    {`M4r'}&	{`M5r'}&	{`M6r'}&	{`M7r'}&	{`M8r'}&	{`M9r'}&	{`M10r'}&	{`M11r'}&	{`M12r'}&	{`M13r'}\\" _n ///
	"Tuberculosis&	    	{Did Not Do Vignette}&  	{`N1r'}&	{0}&   		{`N2r'}&    {`N3r'}&	{0}&		{0}&		{`N4r'}&	{`N5r'}&	{`N6r'}&	{`N7r'}&	{0}&		{0}&		{`N8r'}\\" _n ///
	" &	    		  		{Mean Questions}&  			{`O1r'}&	{`O2r'}&    {`O3r'}&    {`O4r'}&	{`O5r'}&	{`O6r'}&	{`O7r'}&	{`O8r'}&	{`O9r'}&	{`O10r'}&	{`O11r'}&	{`O12r'}&	{`O13r'}\\" _n ///
	" &			      		{Mean Exams}&  				{`P1r'}&	{`P2r'}&    {`P3r'}&    {`P4r'}&	{`P5r'}&	{`P6r'}&	{`P7r'}&	{`P8r'}&	{`P9r'}&	{`P10r'}&	{`P11r'}&	{`P12r'}&	{`P13r'}\\" _n ///
	"\hline" _n ///
	" &			      		{Number of Observations}&  	{`Q1r'}&	{`Q2r'}&    {n/a}&    	{`Q4r'}&	{`Q5r'}&	{`Q6r'}&	{`Q7r'}&	{`Q8r'}&	{`Q9r'}&	{`Q10r'}&	{`Q11r'}&	{`Q12r'}&	{`Q13r'}\\" _n ///
	"Malaria&			    {Did Not Do Vignette}&  	{`R1r'}&	{0}& 	    {n/a}& 	  	{`R2r'}&	{0}&		{0}&		{`R3r'}&	{`R4r'}&	{`R5r'}&	{`R6r'}&	{0}&		{0}&		{`R7r'}\\" _n ///
	" &		      			{Mean Questions}& 			{`S1r'}&	{`S2r'}&    {n/a}&    	{`S4r'}&	{`S5r'}&	{`S6r'}&	{`S7r'}&	{`S8r'}&	{`S9r'}&	{`S10r'}&	{`S11r'}&	{`S12r'}&	{`S13r'}\\" _n ///
	" &			      		{Mean Exams}&  				{`T1r'}&	{`T2r'}&    {n/a}&    	{`T4r'}&	{`T5r'}&	{`T6r'}&	{`T7r'}&	{`T8r'}&	{`T9r'}&	{`T10r'}&	{`T11r'}&	{`T12r'}&	{`T13r'}\\" _n ///
	"\hline" _n ///
	" &			      		{Number of Observations}&  	{`W1r'}&	{`W2r'}&   	{`W3r'}&   	{`W4r'}&	{`W5r'}&	{`W6r'}&	{`W7r'}&	{`W8r'}&	{`W9r'}&	{`W10r'}&	{`W11r'}&	{`W12r'}&	{`W13r'}\\" _n ///
	"Post-Partum&	      	{Did Not Do Vignette}&  	{`X1r'}&	{0}& 	  	{`X2r'}&   	{`X3r'}&	{`X4r'}&	{0}&		{0}&		{`X5r'}&	{`X6r'}&	{0}&		{`X7r'}&	{0}&		{`X8r'}\\" _n ///
	"Hemorrhage&		    {Mean Questions}&  			{`Y1r'}&	{`Y2r'}&    {`Y3r'}&    {`Y4r'}&	{`Y5r'}&	{`Y6r'}&	{`Y7r'}&	{`Y8r'}&	{`Y9r'}&	{`Y10r'}&	{`Y11r'}&	{`Y12r'}&	{`Y13r'}\\" _n ///
	" &			      		{Mean Exams}&  				{`Z1r'}&	{`Z2r'}&    {`Z3r'}&    {`Z4r'}&	{`Z5r'}&	{`Z6r'}&	{`Z7r'}&	{`Z8r'}&	{`Z9r'}&	{`Z10r'}&	{`Z11r'}&	{`Z12r'}&	{`Z13r'}\\" _n ///
	"\hline" _n ///
	" &			      		{Number of Observations}&  	{`AA1r'}&	{`AA2r'}&   {`AA3r'}&   {`AA4r'}&	{`AA5r'}&	{`AA6r'}&	{`AA7r'}&	{`AA8r'}&	{`AA9r'}&	{`AA10r'}&	{`AA11r'}&	{`AA12r'}&	{`AA13r'}\\" _n ///
	"Neonatal&		      	{Did Not Do Vignette}&  	{`BB1r'}&	{`BB2r'}&   {`BB3r'}&   {`BB4r'}&	{`BB5r'}&	{0}&		{0}&		{`BB6r'}&	{`BB7r'}&	{`BB8r'}&	{0}&		{0}&		{`BB9r'}\\" _n ///
	"Asphyxia&			    {Mean Questions}&  			{`CC1r'}&	{`CC2r'}&   {`CC3r'}&   {`CC4r'}&	{`CC5r'}&	{`CC6r'}&	{`CC7r'}&	{`CC8r'}&	{`CC9r'}&	{`CC10r'}&	{`CC11r'}&	{`CC12r'}&	{`CC13r'}\\" _n ///
	" &		      			{Mean Exams}&  				{`DD1r'}&	{`DD2r'}&   {`DD3r'}&   {`DD4r'}&	{`DD5r'}&	{`DD6r'}&	{`DD7r'}&	{`DD8r'}&	{`DD9r'}&	{`DD10r'}&	{`DD11r'}&	{`DD12r'}&	{`DD13r'}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{15}{l}{\footnotesize Certain countries have missing data for some of the vignettes}\\" _n ///
	"\end{tabular}"
	file close 	descTable		
	}			
 
/******************************************************************************
			Table of treatment knowledge summary 
******************************************************************************/
if $sectionF {	
 	
	*Code country year variable 
	encode cy, gen(cy_code)
	
	*This creates the numbers for each row - Number of health providers for each row  
	forvalues num = 1/13 {
		
		sum 	percent_correctd if skip_diarrhea == 0 & cy_code == `num'	// This creates the number stats for row 1
		local 	A`num'r = string(`r(mean)',"%9.1f") 
		di		`A`num'r'
		
		sum 	percent_correctt if skip_diarrhea == 0 & cy_code == `num'	// This creates the number stats for row 2
		local 	B`num'r = string(`r(mean)',"%9.1f") 
		di		`B`num'r'
		
		sum 	percent_antibiotict if skip_diarrhea == 0 & cy_code == `num'	// This creates the number stats for row 3
		local 	C`num'r = string(`r(mean)',"%9.1f") 
		di		`C`num'r'
		
		sum 	total_tests if skip_diarrhea == 0	& cy_code == `num'			// This creates the number stats for row 4
		local 	D`num'r = string(`r(mean)',"%9.2f") 
		di		`D`num'r'
	}
	
	forvalues num = 1/13 {
		
		sum 	percent_correctd if skip_pneumonia == 0 & cy_code == `num'	// This creates the number stats for row 5
		local 	E`num'r = string(`r(mean)',"%9.1f") 
		di		`E`num'r'
		
		sum 	percent_correctt if skip_pneumonia == 0 & cy_code == `num'	// This creates the number stats for row 6
		local 	F`num'r = string(`r(mean)',"%9.1f")  
		di		`F`num'r'
		
		sum 	percent_antibiotict if skip_pneumonia == 0 & cy_code == `num'	// This creates the number stats for row 7
		local 	G`num'r = string(`r(mean)',"%9.1f") 
		di		`G`num'r'
		
		sum 	total_tests if skip_pneumonia == 0	& cy_code == `num'			// This creates the number stats for row 8
		local 	H`num'r = string(`r(mean)',"%9.2f") 
		di		`H`num'r'
	}
	
	forvalues num = 1/13 {
		
		sum 	percent_correctd if skip_diabetes == 0 & cy_code == `num'		// This creates the number stats for row 9
		local 	I`num'r = string(`r(mean)',"%9.1f") 
		di		`I`num'r'
		
		sum 	percent_correctt if skip_diabetes == 0 & cy_code == `num'		// This creates the number stats for row 10
		local 	J`num'r = string(`r(mean)',"%9.1f")  
		di		`J`num'r'
		
		sum 	percent_antibiotict if skip_diabetes == 0 & cy_code == `num'	// This creates the number stats for row 11
		local 	K`num'r = string(`r(mean)',"%9.1f") 
		di		`K`num'r'
		
		sum 	total_tests if skip_diabetes == 0 & cy_code == `num'			// This creates the number stats for row 12
		local 	L`num'r = string(`r(mean)',"%9.2f") 
		di		`L`num'r'
	}

	forvalues num = 1/13 {
		
		sum 	percent_correctd if skip_tb == 0 & cy_code == `num'		// This creates the number stats for row 13
		local 	M`num'r = string(`r(mean)',"%9.1f")
		di		`M`num'r'
		
		sum 	percent_correctt if skip_tb == 0 & cy_code == `num'		// This creates the number stats for row 14
		local 	N`num'r = string(`r(mean)',"%9.1f")
		di		`N`num'r'
		
		sum 	percent_antibiotict if skip_tb == 0 & cy_code == `num'	// This creates the number stats for row 15
		local 	O`num'r = string(`r(mean)',"%9.1f") 
		di		`O`num'r'
		
		sum 	total_tests if skip_tb == 0	& cy_code == `num'			// This creates the number stats for row 16
		local 	P`num'r = string(`r(mean)',"%9.2f") 
		di		`P`num'r'
	}

	forvalues num = 1/13 {
		
		cap sum 	percent_correctd if skip_malaria == 0 & cy_code == `num'		// This creates the number stats for row 17
		cap	local 	Q`num'r = string(`r(mean)',"%9.1f")
		di			`Q`num'r'
		
		cap sum 	percent_correctt if skip_malaria == 0 & cy_code == `num'		// This creates the number stats for row 18
		cap	local 	R`num'r = string(`r(mean)',"%9.1f")
		di			`R`num'r'
	
		cap	sum 	percent_antibiotict if skip_malaria == 0 & cy_code == `num'		// This creates the number stats for row 19
		cap	local 	S`num'r = string(`r(mean)',"%9.1f") 
		di			`S`num'r'
		
		cap	sum 	total_tests if skip_malaria == 0	& cy_code == `num'			// This creates the number stats for row 20
		cap	local 	T`num'r = string(`r(mean)',"%9.2f") 
		di			`T`num'r'
	}
	
	forvalues num = 1/13 {
		
		sum 	percent_correctd if skip_pph == 0	& cy_code == `num'		// This creates the number stats for row 21
		local 	W`num'r = string(`r(mean)',"%9.1f") 
		di		`W`num'r'
		
		sum 	percent_correctt if skip_pph == 0	& cy_code == `num'		// This creates the number stats for row 22
		local 	X`num'r = string(`r(mean)',"%9.1f") 
		di		`X`num'r'
		
		sum 	percent_antibiotict if skip_pph == 0	& cy_code == `num'	// This creates the number stats for row 23
		local 	Y`num'r = string(`r(mean)',"%9.1f") 
		di		`Y`num'r'
		
		sum 	total_tests if skip_pph == 0	& cy_code == `num'			// This creates the number stats for row 24
		local 	Z`num'r = string(`r(mean)',"%9.2f") 
		di		`Z`num'r'
	}
	
	forvalues num = 1/13 {
		
		sum 	percent_correctd if skip_asphyxia == 0 & cy_code == `num'		// This creates the number stats for row 25
		local 	AA`num'r = string(`r(mean)',"%9.1f") 
		di		`AA`num'r'
		
		sum 	percent_correctt if skip_asphyxia == 0 & cy_code == `num'		// This creates the number stats for row 26
		local 	BB`num'r = string(`r(mean)',"%9.1f")  
		di		`BB`num'r'
		
		sum 	percent_antibiotict if skip_asphyxia == 0 & cy_code == `num'	// This creates the number stats for row 27
		local 	CC`num'r = string(`r(mean)',"%9.1f") 
		di		`CC`num'r'
		
		sum 	total_tests if skip_asphyxia == 0 & cy_code == `num'			// This creates the number stats for row 28
		local 	DD`num'r = string(`r(mean)',"%9.2f") 
		di		`DD`num'r'
	}
	
	*Create and build out latex table 
	file open 	descTable using "$EL_out/Final/Tex files/treat_summ.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{15}{c}}" _n ///
	"\hline\hline" _n ///
	"         &\multicolumn{1}{c}{" "}&\multicolumn{1}{c}{Guinea Bissau}&\multicolumn{1}{c}{Kenya 2012}&\multicolumn{1}{c}{Kenya 2018}&\multicolumn{1}{c}{Madagascar}&\multicolumn{1}{c}{Mozambique}&\multicolumn{1}{c}{Malawi}&\multicolumn{1}{c}{Niger}&\multicolumn{1}{c}{Nigeria}&\multicolumn{1}{c}{Sierra Leone}&\multicolumn{1}{c}{Togo}&\multicolumn{1}{c}{Tanzania 2014}&\multicolumn{1}{c}{Tanzania 2016}&\multicolumn{1}{c}{Uganda}&\\" _n ///
	"\hline" _n ///
	" & 				 	{Correct Diagnosis}&		{`A1r'\%}&	{`A2r'\%}&	{`A3r'\%}&	{`A4r'\%}&	{`A5r'\%}&	{`A6r'\%}&	{`A7r'\%}&	{`A8r'\%}&	{`A9r'\%}&	{`A10r'\%}&	{`A11r'\%}&	{`A12r'\%}&	{`A13r'\%}\\" _n ///
	"Child&  				{Correct Treatmet}&  		{`B1r'\%}&	{`B2r'\%}& 	{`B3r'\%}&	{`B4r'\%}&  {`B5r'\%}&	{`B6r'\%}&	{`B7r'\%}&	{`B8r'\%}&	{`B9r'\%}&	{`B10r'\%}&	{`B11r'\%}&	{`B12r'\%}&	{`B13r'\%}\\" _n ///
	"Diarrhea&		      	{Gave In. Antibiotics}&  	{`C1r'\%}&	{`C2r'\%}&  {`C3r'\%}&  {`C4r'\%}&	{`C5r'\%}&	{`C6r'\%}&	{`C7r'\%}&	{`C8r'\%}&	{`C9r'\%}&	{`C10r'\%}&	{`C11r'\%}&	{`C12r'\%}&	{`C13r'\%}\\" _n ///
	" &				      	{Number of Tests Ordered}&  {`D1r'}&	{`D2r'}&    {`D3r'}&  	{`D4r'}&	{`D5r'}&	{`D6r'}&	{`D7r'}&	{`D8r'}&	{`D9r'}&	{`D10r'}&	{`D11r'}&	{`D12r'\%}&	{`D13r'}\\" _n ///
	"\hline" _n ///
	" &				      	{Correct Diagnosis}&  		{`E1r'\%}&	{`E2r'\%}&  {`E3r'\%}&  {`E4r'\%}&	{`E5r'\%}&	{`E6r'\%}&	{`E7r'\%}&	{`E8r'\%}&	{`E9r'\%}&	{`E10r'\%}&	{`E11r'\%}&	{`E12r'\%}&	{`E13r'\%}\\" _n ///
	"Child&			      	{Correct Treatmet}&  		{`F1r'\%}&	{`F2r'\%}&	{`F3r'\%}&	{`F4r'\%}&	{`F5r'\%}&	{`F6r'\%}&	{`F7r'\%}&	{`F8r'\%}&	{`F9r'\%}&	{`F10r'\%}&	{`F11r'\%}&	{`F12r'\%}&	{`F13r'\%}\\" _n ///
	"Pneumonia&		      	{Gave In. Antibiotics}&  	{`G1r'\%}&	{`G2r'\%}&  {`G3r'\%}&  {`G4r'\%}&	{`G5r'\%}&	{`G6r'\%}&	{`G7r'\%}&	{`G8r'\%}&	{`G9r'\%}&	{`G10r'\%}&	{`G11r'\%}&	{`G12r'\%}&	{`G13r'\%}\\" _n ///
	" &			      		{Number of Tests Ordered}&  {`H1r'}&	{`H2r'}&    {`H3r'}&    {`H4r'}&	{`H5r'}&	{`H6r'}&	{`H7r'}&	{`H8r'}&	{`H9r'}&	{`H10r'}&	{`H11r'}&	{`H12r'}&	{`H13r'}\\" _n ///
	"\hline" _n ///
	" &				      	{Correct Diagnosis}&  		{`I1r'\%}&	{`I2r'\%}&  {`I3r'\%}&  {`I4r'\%}&	{`I5r'\%}&	{`I6r'\%}&	{`I7r'\%}&	{`I8r'\%}&	{`I9r'\%}&	{`I10r'\%}&	{`I11r'\%}&	{`I12r'\%}&	{`I13r'\%}\\" _n ///
	"Diabetes&	      		{Correct Treatmet}&  		{`J1r'\%}&	{`J2r'\%}&  {`J3r'\%}&  {`J4r'\%}&	{`J5r'\%}&	{`J6r'\%}&	{`J7r'\%}&	{`J8r'\%}&	{`J9r'\%}&	{`J10r'\%}&	{`J11r'\%}&	{`J12r'\%}&	{`J13r'\%}\\" _n ///
	"(Type II)&		      	{Gave In. Antibiotics}&  	{`K1r'\%}&	{`K2r'\%}&  {`K3r'\%}&  {`K4r'\%}&	{`K5r'\%}&	{`K6r'\%}&	{`K7r'\%}&	{`K8r'\%}&	{`K9r'\%}&	{`K10r'\%}&	{`K11r'\%}&	{`K12r'\%}&	{`K13r'\%}\\" _n ///
	" &			      		{Number of Tests Ordered}&  {`L1r'}&	{`L2r'}&    {`L3r'}&    {`L4r'}&	{`L5r'}&	{`L6r'}&	{`L7r'}&	{`L8r'}&	{`L9r'}&	{`L10r'}&	{`L11r'}&	{`L12r'}&	{`L13r'}\\" _n ///
	"\hline" _n ///
	" &			      		{Correct Diagnosis}&  		{`M1r'\%}&	{`M2r'\%}&  {`M3r'\%}&  {`M4r'\%}&	{`M5r'\%}&	{`M6r'\%}&	{`M7r'\%}&	{`M8r'\%}&	{`M9r'\%}&	{`M10r'\%}&	{`M11r'\%}&	{`M12r'\%}&	{`M13r'\%}\\" _n ///
	"Tuberculosis&	    	{Correct Treatmet}&  		{`N1r'\%}&	{`N2r'\%}&  {`N3r'\%}&  {`N4r'\%}&	{`N5r'\%}&	{`N6r'\%}&	{`N7r'\%}&	{`N8r'\%}&	{`N9r'\%}&	{`N10r'\%}&	{`N11r'\%}&	{`N12r'\%}&	{`N13r'\%}\\" _n ///
	" &	    		  		{Gave In. Antibiotics}&  	{`O1r'\%}&	{`O2r'\%}&  {`O3r'\%}&  {`O4r'\%}&	{`O5r'\%}&	{`O6r'\%}&	{`O7r'\%}&	{`O8r'\%}&	{`O9r'\%}&	{`O10r'\%}&	{`O11r'\%}&	{`O12r'\%}&	{`O13r'\%}\\" _n ///
	" &			      		{Number of Tests Ordered}&  {`P1r'}&	{`P2r'}&    {`P3r'}&    {`P4r'}&	{`P5r'}&	{`P6r'}&	{`P7r'}&	{`P8r'}&	{`P9r'}&	{`P10r'}&	{`P11r'}&	{`P12r'}&	{`P13r'}\\" _n ///
	"\hline" _n ///
	" &			      		{Correct Diagnosis}&  		{`Q1r'\%}&	{`Q2r'\%}&  {n/a}&    	{`Q4r'\%}&	{`Q5r'\%}&	{`Q6r'\%}&	{`Q7r'\%}&	{`Q8r'\%}&	{`Q9r'\%}&	{`Q10r'\%}&	{`Q11r'\%}&	{`Q12r'\%}&	{`Q13r'\%}\\" _n ///
	"Malaria&			    {Correct Treatmet}&  		{`R1r'\%}&	{`R2r'\%}& 	{n/a}& 	  	{`R4r'\%}&	{`R5r'\%}&	{`R6r'\%}&	{`R7r'\%}&	{`R8r'\%}&	{`R9r'\%}&	{`R10r'\%}&	{`R11r'\%}&	{`R12r'\%}&	{`R13r'\%}\\" _n ///
	" &		      			{Gave In. Antibiotics}& 	{`S1r'\%}&	{`S2r'\%}&  {n/a}&    	{`S4r'\%}&	{`S5r'\%}&	{`S6r'\%}&	{`S7r'\%}&	{`S8r'\%}&	{`S9r'\%}&	{`S10r'\%}&	{`S11r'\%}&	{`S12r'\%}&	{`S13r'\%}\\" _n ///
	" &			      		{Number of Tests Ordered}&  {`T1r'}&	{`T2r'}&    {n/a}&    	{`T4r'}&	{`T5r'}&	{`T6r'}&	{`T7r'}&	{`T8r'}&	{`T9r'}&	{`T10r'}&	{`T11r'}&	{`T12r'}&	{`T13r'}\\" _n ///
	"\hline" _n ///
	" &			      		{Correct Diagnosis}&  		{`W1r'\%}&	{`W2r'\%}&  {`W3r'\%}&  {`W4r'\%}&	{`W5r'\%}&	{`W6r'\%}&	{`W7r'\%}&	{`W8r'\%}&	{`W9r'\%}&	{`W10r'\%}&	{`W11r'\%}&	{`W12r'\%}&	{`W13r'\%}\\" _n ///
	"Post-Partum&	      	{Correct Treatmet}&  		{`X1r'\%}&	{`X2r'\%}& 	{`X3r'\%}&  {`X4r'\%}&	{`X5r'\%}&	{`X6r'\%}&	{`X7r'\%}&	{`X8r'\%}&	{`X9r'\%}&	{`X10r'\%}&	{`X11r'\%}&	{`X12r'\%}&	{`X13r'\%}\\" _n ///
	"Hemorrhage&		    {Gave In. Antibiotics}&  	{`Y1r'\%}&	{`Y2r'\%}&  {`Y3r'\%}&  {`Y4r'\%}&	{`Y5r'\%}&	{`Y6r'\%}&	{`Y7r'\%}&	{`Y8r'\%}&	{`Y9r'\%}&	{`Y10r'\%}&	{`Y11r'\%}&	{`Y12r'\%}&	{`Y13r'\%}\\" _n ///
	" &			      		{Number of Tests Ordered}&  {`Z1r'}&	{`Z2r'}&    {`Z3r'}&    {`Z4r'}&	{`Z5r'}&	{`Z6r'}&	{`Z7r'}&	{`Z8r'}&	{`Z9r'}&	{`Z10r'}&	{`Z11r'}&	{`Z12r'}&	{`Z13r'}\\" _n ///
	"\hline" _n ///
	" &			      		{Correct Diagnosis}&  		{`AA1r'\%}&	{`AA2r'\%}& {`AA3r'\%}& {`AA4r'\%}&	{`AA5r'\%}&	{`AA6r'\%}&	{`AA7r'\%}&	{`AA8r'\%}&	{`AA9r'\%}&	{`AA10r'\%}& {`AA11r'\%}& {`AA12r'\%}&	{`AA13r'\%}\\" _n ///
	"Neonatal&		      	{Correct Treatmet}&  		{`BB1r'\%}&	{`BB2r'\%}& {`BB3r'\%}& {`BB4r'\%}&	{`BB5r'\%}&	{`BB6r'\%}&	{`BB7r'\%}&	{`BB8r'\%}&	{`BB9r'\%}&	{`BB10r'\%}& {`BB11r'\%}& {`BB12r'\%}&	{`BB13r'\%}\\" _n ///
	"Asphyxia&			    {Gave In. Antibiotics}&  	{`CC1r'\%}&	{`CC2r'\%}& {`CC3r'\%}& {`CC4r'\%}&	{`CC5r'\%}&	{`CC6r'\%}&	{`CC7r'\%}&	{`CC8r'\%}&	{`CC9r'\%}&	{`CC10r'\%}& {`CC11r'\%}& {`CC12r'\%}&	{`CC13r'\%}\\" _n ///
	" &		      			{Number of Tests Ordered}&  {`DD1r'}&	{`DD2r'}&   {`DD3r'}&   {`DD4r'}&	{`DD5r'}&	{`DD6r'}&	{`DD7r'}&	{`DD8r'}&	{`DD9r'}&	{`DD10r'}&	 {`DD11r'}&	  {`DD12r'}&	{`DD13r'}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{15}{l}{\footnotesize Certain countries have missing data for some of the vignettes}\\" _n ///
	"\end{tabular}"
	file close 	descTable		
	}			

/******************************************************************************
			Table of descriptive stats of providers 
******************************************************************************/
if $sectionG {	
 	
	*Code country year variable 
	encode cy, gen(cy_code)
	
	*Create urban variable binary 
	gen 	urban = (rural ==0)
	replace urban = . if missing(rural)
	
	*Create facility level binaries 
	gen 	hospital  = (facility_level ==1)
	gen 	health_ce = (facility_level ==2)
	gen 	health_po = (facility_level ==3)
	
	*Create provider cadre binaries 
	gen 	doctor	= 	(provider_cadre1 ==1)
	replace doctor  = . if missing(provider_cadre1) 
	gen 	nurse 	= 	(provider_cadre1 ==3)
	replace nurse  	= . if missing(provider_cadre1)
	gen 	other 	= 	(provider_cadre1 ==4)
	replace other 	 = . if missing(provider_cadre1)
	
	*Create medical education binaries 
	gen 	advanced	= 	(provider_mededuc1 ==4)
	replace advanced  	= . if missing(provider_mededuc1) 
	gen 	diploma 	= 	(provider_mededuc1 ==3)
	replace diploma  	= . if missing(provider_mededuc1)
	gen 	certificate = 	(provider_mededuc1 ==2)
	replace certificate = . if missing(provider_mededuc1)
	
	*This creates the numbers for each row - Number of health providers for each row  
	forvalues num = 1/13 {
		
		count if  cy_code == `num'	// This creates the number stats for row 1
		local 	A`num'r = string(`r(N)',"%9.0f") 
		di		`A`num'r'
		
	}
	
	forvalues num = 1/13 {
		sum 	rural  if	cy_code == `num', d	// This creates the number stats for row 2
		local 	C`num'r = string(`r(mean)',"%9.2f") 
		di		`C`num'r'
	
		sum 	urban if	cy_code == `num', d	// This creates the number stats for row 3
		local 	D`num'r = string(`r(mean)',"%9.2f") 
		di		`D`num'r'
	}
	
	forvalues num = 1/13 {
		
		sum 	hospital if cy_code == `num'	// This creates the number stats for row 4
		local 	E`num'r = string(`r(mean)',"%9.2f") 
		di		`E`num'r'
		
		sum 	health_ce if cy_code == `num'	// This creates the number stats for row 5
		local 	F`num'r = string(`r(mean)',"%9.2f")  
		di		`F`num'r'
		
		sum 	health_po if cy_code == `num'	// This creates the number stats for row 6
		local 	G`num'r = string(`r(mean)',"%9.2f") 
		di		`G`num'r'
	}
	
	forvalues num = 1/13 {
		
		sum 	doctor	if cy_code == `num'		// This creates the number stats for row 7
		local 	I`num'r = string(`r(mean)',"%9.2f") 
		di		`I`num'r'
		
		sum 	nurse	if cy_code == `num'		// This creates the number stats for row 8
		local 	K`num'r = string(`r(mean)',"%9.2f") 
		di		`K`num'r'
		
		sum 	other	if cy_code == `num'		// This creates the number stats for row 9
		local 	L`num'r = string(`r(mean)',"%9.2f") 
		di		`L`num'r'
	}

	forvalues num = 1/13 {
		
	cap	sum 	advanced if cy_code == `num'		// This creates the number stats for row 10
	cap	local 	M`num'r = string(`r(mean)',"%9.2f")
		di		`M`num'r'
		
	cap	sum 	diploma if cy_code == `num'		// This creates the number stats for row 11
	cap	local 	N`num'r = string(`r(mean)',"%9.2f")
		di		`N`num'r'
		
	cap	sum 	certificate if cy_code == `num'	// This creates the number stats for row 12
	cap	local 	O`num'r = string(`r(mean)',"%9.2f") 
		di		`O`num'r'
	}
	
	*Create and build out latex table 
	file open 	descTable using "$EL_out/Final/Tex files/prov_summ.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{14}{c}}" _n ///
	"\hline\hline" _n ///
	"&\multicolumn{1}{c}{Guinea Bissau}&\multicolumn{1}{c}{Kenya 2012}&\multicolumn{1}{c}{Kenya 2018}&\multicolumn{1}{c}{Madagascar}&\multicolumn{1}{c}{Mozambique}&\multicolumn{1}{c}{Malawi}&\multicolumn{1}{c}{Niger}&\multicolumn{1}{c}{Nigeria}&\multicolumn{1}{c}{Sierra Leone}&\multicolumn{1}{c}{Togo}&\multicolumn{1}{c}{Tanzania 2014}&\multicolumn{1}{c}{Tanzania 2016}&\multicolumn{1}{c}{Uganda}&\\" _n ///
	"\hline" _n ///
	"Total Surveyed&			{`A1r'}&	{`A2r'}&  {`A3r'}&	{`A4r'}&	{`A5r'}&	{`A6r'}&	{`A7r'}&	{`A8r'}&	{`A9r'}&	{`A10r'}&	{`A11r'}&	{`A12r'}&	{`A13r'}\\" _n ///
	"  &  {""}\\" _n ///
	"Works at rural facility&	{`C1r'}&	{`C2r'}&  {`C3r'}&  {`C4r'}&	{`C5r'}&	{`C6r'}&	{`C7r'}&	{`C8r'}&	{`C9r'}&	{`C10r'}&	{`C11r'}&	{`C12r'}&	{`C13r'}\\" _n ///
	"Works at public facility&  {`D1r'}&	{`D2r'}&  {`D3r'}&  {`D4r'}&	{`D5r'}&	{`D6r'}&	{`D7r'}&	{`D8r'}&	{`D9r'}&	{`D10r'}&	{`D11r'}&	{`D12r'}&	{`D13r'}\\" _n ///
	" &   {""}\\" _n ///
	"Works at hospital&  		{`E1r'}&	{`E2r'}&  {`E3r'}&  {`E4r'}&	{`E5r'}&	{`E6r'}&	{`E7r'}&	{`E8r'}&	{`E9r'}&	{`E10r'}&	{`E11r'}&	{`E12r'}&	{`E13r'}\\" _n ///
	"Works at health center&  	{`F1r'}&	{`F2r'}&  {`F3r'}&	{`F4r'}&	{`F5r'}&	{`F6r'}&	{`F7r'}&	{`F8r'}&	{`F9r'}&	{`F10r'}&	{`F11r'}&	{`F12r'}&	{`F13r'}\\" _n ///
	"Works at health post&  	{`G1r'}&	{`G2r'}&  {`G3r'}&  {`G4r'}&	{`G5r'}&	{`G6r'}&	{`G7r'}&	{`G8r'}&	{`G9r'}&	{`G10r'}&	{`G11r'}&	{`G12r'}&	{`G13r'}\\" _n ///
	" &   {""}\\" _n ///
	"Is medical officer&  		{`I1r'}&	{`I2r'}&  {`I3r'}&  {`I4r'}&	{`I5r'}&	{`I6r'}&	{`I7r'}&	{`I8r'}&	{`I9r'}&	{`I10r'}&	{`I11r'}&	{`I12r'}&	{`I13r'}\\" _n ///
	"Is nurse&  				{`K1r'}&	{`K2r'}&  {`K3r'}&  {`K4r'}&	{`K5r'}&	{`K6r'}&	{`K7r'}&	{`K8r'}&	{`K9r'}&	{`K10r'}&	{`K11r'}&	{`K12r'}&	{`K13r'}\\" _n ///
	"Is other profession& 	 	{`L1r'}&	{`L2r'}&  {`L3r'}&  {`L4r'}&	{`L5r'}&	{`L6r'}&	{`L7r'}&	{`L8r'}&	{`L9r'}&	{`L10r'}&	{`L11r'}&	{`L12r'}&	{`L13r'}\\" _n ///
	"&   {""}\\" _n ///
	"Has advanced med. ed.&  	{`M1r'}&	{`M2r'}&  {`M3r'}&  {`M4r'}&	{`M5r'}&	{`M6r'}&	{`M7r'}&	{`M8r'}&	{`M9r'}&	{`M10r'}&	{`M11r'}&	{`M12r'}&	{`M13r'}\\" _n ///
	"Has diploma&  				{`N1r'}&	{`N2r'}&  {`N3r'}&  {`N4r'}&	{`N5r'}&	{`N6r'}&	{`N7r'}&	{`N8r'}&	{`N9r'}&	{`N10r'}&	{`N11r'}&	{`N12r'}&	{`N13r'}\\" _n ///
	"Has certificate&  			{`O1r'}&	{`O2r'}&  {`O3r'}&  {`O4r'}&	{`O5r'}&	{`O6r'}&	{`O7r'}&	{`O8r'}&	{`O9r'}&	{`O10r'}&	{`O11r'}&	{`O12r'}&	{`O13r'}\\" _n ///
	"\hline" _n ///
	"\end{tabular}"
	file close 	descTable		
	}			

	

***************************************** End of do-file *********************************************
