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
 
	
/*****************************
			Vignettes   
******************************/	
	
	*Open vignettes dataset 
	use "$VG_dtFin/Vignettes_construct.dta", clear   
	
*****************************************************************************
/* Regression results using wide data */
*****************************************************************************	
 
	*Run regressions and save regression estimates 
	reg 	theta_mle i.provider_cadre provider_age1 advanced diploma certificate, vce(cluster survey_id)
	eststo 	theta_mle1
	estadd  local hascout	"No"
	
	reg 	theta_mle i.provider_cadre provider_age1 advanced diploma certificate i.facility_level_rec i.rural_rec i.public_rec, vce(cluster survey_id)
	eststo 	theta_mle2
	estadd  local hascout	"No"
	
	areg 	theta_mle i.provider_cadre provider_age1 advanced diploma certificate i.facility_level_rec i.rural_rec i.public_rec, ab(countrycode) cluster(survey_id)
	eststo 	theta_mle3
	estadd  local hascout	"Yes"
    
*****************************************************************************
/* Regression results using long data */
*****************************************************************************

	*Keep only the variables needed for the regression analysis 
	keep countrycode survey_id countryfac_id diag* treat* provider_cadre	///
		 provider_age1 facility_level_rec rural_rec public_rec advanced 	///
		 diploma certificate
 
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
	reg 	treat i.provider_cadre provider_age1 advanced diploma certificate, vce(cluster survey_id)
	eststo 	treat1
	estadd  local hascout	"No"
	
	reg 	treat i.provider_cadre provider_age1 advanced diploma certificate i.facility_level_rec i.rural_rec i.public_rec,  vce(cluster survey_id)
	eststo 	treat2
	estadd  local hascout	"No"
	
	areg 	treat i.provider_cadre provider_age1 advanced diploma certificate i.facility_level_rec i.rural_rec i.public_rec, ab(countrycode) cluster(survey_id)
	eststo 	treat3
	estadd  local hascout	"Yes"
	
	reg 	diag i.provider_cadre provider_age1 advanced diploma certificate, vce(cluster survey_id)
	eststo 	diag1
	estadd  local hascout	"No"
	
	reg	diag i.provider_cadre provider_age1 advanced diploma certificate i.facility_level_rec i.rural_rec i.public_rec, vce(cluster survey_id)
	eststo 	diag2
	estadd  local hascout	"No"
	
	areg	diag i.provider_cadre provider_age1 advanced diploma certificate i.facility_level_rec i.rural_rec i.public_rec, ab(countrycode) cluster(survey_id)
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
			mgroups("Knowledge Score" "Treats Condition Correctly" "Diagnose Condition Correctly", pattern(1 0 0 1 0 0 1 0 0)) ///
			csv label se(3) collabels(none)  nobaselevels  mtitles("" "" "" "" "" "" "" "" "")	///
			nodepvars nocons star( * 0.1 ** 0.05 *** 0.01)	

	esttab 	theta_mle1 theta_mle2 theta_mle3											///
			treat1 treat2 treat3  														///
			diag1 diag2 diag3  														 	///
			using "$VG_out/tables/Regression_Results.tex",						///
			label  replace 																///			
			stats(hascout N r2,  fmt(0 0 3) 											///
			labels("Country fixed effects" "Observations" "R2"))			    		///
			mgroups("Knowledge Score" "Treats Condition Correctly" "Diagnose Condition Correctly", pattern(1 0 0 1 0 0 1 0 0)) ///
			se(3) coll(none) nobaselevels  nomtitles nogaps  noeqlines 	///
			style(tex) nodepvars nocons star( * 0.1 ** 0.05 *** 0.01) nonotes compress	
	
	
************************************* End of do-file *****************************************
