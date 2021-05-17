* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Run the IRT command 						   		   *
*				Unique ID											   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Runs the IRT command that creats the mle parameters
				  and merges the theta_mle estimates back into module 
				  3

       ** IDS VAR: country year unique_id 
       ** NOTES:
       ** WRITTEN BY: Michael Orevba
       ** Last date modified: April 8th 2021
 */
 
/******************************************
			IRT Specification 
*******************************************/

*Open module 3 dataset 
use "$EL_dtInt/Module 3/All_countries_mod_3.dta", clear 

*Drop observations that skipped all vignettes 
drop if num_skipped == 8 

*Create a unique_id that includes country year 
sort 	cy unique_id 
gen 	unique_id2 = cy + "_" + unique_id 

*Restrict to only variables needed for the IRT 
keep	cy provider_id	///
		unique_id2 *_history_* *_exam_*  
		
*Drop eclampsia since only Niger did this moddule 
drop 	eclampsia_*
 
*Remove variables where all responses are 0 
qui foreach v of varlist *_history_* *_exam_*  {
	sum `v'
	local mn = `r(mean)'
	local min = `r(min)'
	local max = `r(max)'
	if `mn'==0 & `min'==0 & `max'==0 {
		drop `v'
	}
}		
 	
*Run IRT command based on Benjamin Daniels' code from GitHub: "https://github.com/bbdaniels/stata/tree/master/dev/Statistics/EasyIRT" 
easyirt *_history_* *_exam_* using "$EL_dt/Final/IRT_parameters.dta", id(unique_id2) replace 

*twoway (hist treat1, yaxis(2)) (mspline treat1 theta_mle) if theta_mle <5
*twoway (hist treat1, yaxis(2)) (lfit treat1 theta_mle) if theta_mle <5

********************************** End of do-file **********************************************
