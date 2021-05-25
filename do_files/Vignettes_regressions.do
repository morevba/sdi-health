* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Regression Outputs									   *
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
		global sectionA		0 // Reg table 	
	  
	
/*****************************
			Vignettes   
******************************/	
	
	*Open vignettes dataset 
	use "$VG_dtFin/Vignettes_pl.dta", clear   
	
	*Encode country 
	encode cy, gen(countrycode)
	
	*Create survey id variable 
	gen 		countrycode_str = countrycode
	tostring 	countrycode_str, replace force 
	gen 		survey_id = countrycode_str + "_" + unique_id
	drop 		countrycode_str // this variable is no longer needed 
	
	*Relabel key variables 
	label var provider_age1	"Provider age"
	
	*Recode key variables 
	gen 		public_rec = 0 if public == 1
	replace 	public_rec = 1 if public == 0 
	lab define  public_lab 1 "Private" 0 "Public"
	label val 	public_rec public_lab
	
	gen 		rural_rec = 0 if rural == 1
	replace 	rural_rec = 1 if rural == 0 
	lab define  rural_lab 1 "Urban" 0 "Rural"
	label val 	rural_rec rural_lab
	
	gen 		facility_level_rec = 1 if facility_level == 3
	replace 	facility_level_rec = 2 if facility_level == 1 
	replace 	facility_level_rec = 3 if facility_level == 2 
	lab define  facility_level_lab 1 "Health Post" 2 "Hospital" 3 "Health Center"
	label val 	facility_level_rec facility_level_lab
	
	gen 		provider_cadre = .
	replace 	provider_cadre = 1 if provider_cadre1 == 4 
	replace 	provider_cadre = 2 if provider_cadre1 == 1 
	replace 	provider_cadre = 3 if provider_cadre1 == 3
	lab define  prov_lab 1 "Other" 2 "Doctor" 3 "Nurse"
	label val 	provider_cadre prov_lab
	 
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

*****************************************************************************
/* Regression results using wide data */
*****************************************************************************	

	areg percent_correctd, a(countrycode)
	areg percent_correctd theta_mle, a(countrycode)
	margins, at(theta_mle=(-2.12651  -0.66355 0.621643 1.58764))

	areg percent_correctt, a(countrycode)
	areg percent_correctt theta_mle, a(countrycode)
	margins, at(theta_mle=(-2.12651  -0.66355 0.621643 1.58764))

	areg percent_antibiotict, a(countrycode)
	areg percent_antibiotict theta_mle, a(countrycode)
	margins, at(theta_mle=(-2.12651  -0.66355 0.621643 1.58764))
 	
	eststo clear

	replace 	provider_cadre	= . if provider_cadre==. // recode other to missing for now 
	replace 	provider_age1	= . if provider_age1>=75 | provider_age1<15
	tostring 	facility_id, replace 
	tostring 	countrycode, replace force 
	gen 		countryfac_id = countrycode + "_" + facility_id
 
	*Run regressions and save regression estimates 
	reg 	theta_mle i.provider_cadre provider_age1, vce(cluster survey_id)
	eststo 	theta_mle1
	estadd  local hascout	"No"
	
	reg 	theta_mle i.provider_cadre provider_age1 i.facility_level_rec i.rural_rec i.public_rec, vce(cluster survey_id)
	eststo 	theta_mle2
	estadd  local hascout	"No"
	
	areg 	theta_mle i.provider_cadre provider_age1 i.facility_level_rec i.rural_rec i.public_rec, ab(countrycode) cluster(survey_id)
	eststo 	theta_mle3
	estadd  local hascout	"Yes"
    
*****************************************************************************
/* Regression results using long data */
*****************************************************************************

	*Keep only the variables needed for the regression analysis 
	keep countrycode survey_id countryfac_id diag* treat* provider_cadre provider_age1 facility_level_rec rural_rec public_rec
 
	drop treat_guidelines* treat_accuracy treat_observed /// these variables are not needed 
		 diag_accuracy treat_guidedate 
  
	*Rename treat and antibio variables 
	rename treat* treat*_
	rename diag*  diag*_
	
	*Reshape dataset from wide to long 
	reshape long treat diag, i(survey_id) j(disease) string
	replace disease = subinstr(disease, "_", "", .)

	replace diag 	= 1 if diag==100
	replace treat 	= 1 if treat==100

	*Run regressions and save regression estimates 
	reg 	treat i.provider_cadre provider_age1, vce(cluster survey_id)
	eststo 	treat1
	estadd  local hascout	"No"
	
	reg 	treat i.provider_cadre provider_age1 i.facility_level_rec i.rural_rec i.public_rec,  vce(cluster survey_id)
	eststo 	treat2
	estadd  local hascout	"No"
	
	areg 	treat i.provider_cadre provider_age1 i.facility_level_rec i.rural_rec i.public_rec, ab(countrycode) cluster(survey_id)
	eststo 	treat3
	estadd  local hascout	"Yes"
	
	reg 	diag i.provider_cadre provider_age1, vce(cluster survey_id)
	eststo 	diag1
	estadd  local hascout	"No"
	
	reg	diag i.provider_cadre provider_age1 i.facility_level_rec i.rural_rec i.public_rec, vce(cluster survey_id)
	eststo 	diag2
	estadd  local hascout	"No"
	
	areg	diag i.provider_cadre provider_age1 i.facility_level_rec i.rural_rec i.public_rec, ab(countrycode) cluster(survey_id)
	eststo 	diag3
	estadd  local hascout	"Yes"

*****************************************************************************
/* Output regression results */
*****************************************************************************

	esttab 	theta_mle1 theta_mle2 theta_mle3								///
			treat1 treat2 treat3  											///
			diag1 diag2 diag3  												///
			using "$VG_out/tables/Regression_Results.csv", replace ///
			stats(hascout N r2,  fmt(0 0 3) 								///
			labels("Country fixed effects" "Observations" "R2"))			///
			mgroups("Knowledge Score" "Treats Condition Correctly" "Diagnosis Condition Correctly", pattern(1 0 0 1 0 0 1 0 0)) ///
			csv label se(3) collabels(none)  nobaselevels  mtitles("" "" "" "" "" "" "" "" "")	///
			nodepvars nocons star( * 0.1 ** 0.05 *** 0.01)	

	esttab 	theta_mle1 theta_mle2 theta_mle3											///
			treat1 treat2 treat3  														///
			diag1 diag2 diag3  														 	///
			using "$VG_out/tables/Regression_Results.tex",						///
			label  replace 																///			
			stats(hascout N r2,  fmt(0 0 3) 											///
			labels("Country fixed effects" "Observations" "R2"))			    		///
			mgroups("Knowledge Score" "Treats Condition Correctly" "Diagnosis Condition Correctly", pattern(1 0 0 1 0 0 1 0 0)) ///
			se(3) coll(none) nobaselevels  nomtitles nogaps  noeqlines 	///
			style(tex) nodepvars nocons star( * 0.1 ** 0.05 *** 0.01) nonotes compress	
	
	
************************************* End of do-file *****************************************
