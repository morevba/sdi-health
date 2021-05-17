* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Append module 2 dataset of each country		   		   *
*				Unique ID											   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Creates a dataset of all the module 2 section for each 
					country combined 

       ** IDS VAR: country year unique_id 
       ** NOTES:
       ** WRITTEN BY:	Ruben Connor & Michael Orevba
       ** Last date modified: Fed 2nd 2021
 */
 
/******************************************
		Append Module 2 datasets
*******************************************/

	/************
	Last fixes
	***************/
	
	*Open Madagascar 2016 dataset 
	use "$EL_dtDeID/Module2_Madagascar_2016_deid.dta", clear
	
	destring year_started, replace
	save "$EL_dtDeID/Module2_Madagascar_2016_deid.dta", replace

	/****************** 
	APPEND DATASETS
	*******************/
	
	*Open Kenya 2018 dataset 
	use "$EL_dtDeID/Module2_Kenya_2018_deid.dta", clear
	
	*Generate country-year variable 
	gen		cy	= "KEN_2018", after(year)
	
	*Append Kenya 2012 mod 2 dataset 
	appen using "$EL_dtDeID/Module2_Kenya_2012_deid.dta"
	
	*Generate country-year variable 
	replace		cy	= "KEN_2012" if cy == ""
	
	*Append Nigeria 2013 mod 2 dataset 
	append using "$EL_dtDeID/Module2_Nigeria_2013_deid.dta"
	
	*Generate country-year variable 
	replace cy 	= "NGA_2013" if cy == ""
	
	*Append Uganda 2013 mod 2 dataset 
	append using "$EL_dtDeID/Module2_Uganda_2013_deid.dta"
	
	*Generate country-year variable 
	replace cy 	= "UGA_2013" if cy == ""
	
	*Append Togo 2013 mod 2 dataset 
	append using "$EL_dtDeID/Module2_Togo_2013_deid.dta"    
	
	*Generate country-year variable 
	replace cy 	= "TGO_2013" if cy == ""
	
	*Append Mozamnique 2014 mod 2 dataset 
	append using "$EL_dtDeID/Module2_Mozambique_2014_deid.dta"       
	
	*Generate country-year variable 
	replace cy 	= "MOZ_2014" if cy == ""
	
	*Append Niger 2015 mod 2 dataset 
	append using "$EL_dtDeID/Module2_Niger_2015_deid.dta"      
	
	*Generate country-year variable 
	replace cy 	= "NER_2015" if cy == ""
	
	*Append Madagascar 2016 mod 2 dataset 
	append using "$EL_dtDeID/Module2_Madagascar_2016_deid.dta"       
	
	*Generate country-year variable 
	replace cy 	= "MDG_2016" if cy == ""
	
	*Append Tanazania 2016 mod 2 dataset 
	append using "$EL_dtDeID/Module2_Tanzania_2016_deid.dta"     
	
	*Generate country-year variable 
	replace cy 	= "TZN_2016" if cy == ""
	
	*Append Tanazania 2014 mod 2 dataset 
	append using "$EL_dtDeID/Module2_Tanzania_2014_deid.dta"     
	
	*Generate country-year variable 
	replace cy 	= "TZN_2014" if cy == ""
	
	*Append Sierra Leone 2018 mod 2 dataset 
	append using "$EL_dtDeID/Module2_SierraLeone_2018_deid.dta"       
	
	*Generate country-year variable 
	replace cy 	= "SLA_2018" if cy == "" 
	
	*Append Guinea Bissau 2018 mod 2 dataset 
	append using  "$EL_dtInt/Module 2/GuineaBissau_2018_mod_2.dta",       
	
	*Generate country-year variable 
	replace cy 	= "GNB_2018" if cy == "" 
	
	*Append Malawi 2019 mod 2 dataset 
	append using  "$EL_dtInt/Module 2/Malawi_2019_mod_2.dta",       
	
	*Generate country-year variable 
	replace cy 	= "MWI_2019" if cy == "" 
   
	/**********************************
	CREATING TRUE ABSENCE VARIABLES
	*********************************/
	
	*Absentee variable
	gen 	absent 			= (provider_present2 == 0)
	replace absent 			= . if provider_present2 == .
	replace absent_reason2 	= . if absent == 0 // Some places listed as present but have a reason for absence. Assume they are absent. 

	*Rename old absenteeism variable
	rename absent x_absent
		
	*Make a new absent variable that reflects the accurate denominator - you shouldn't be calculated in the denominator if you are not supposed to be working in any capacity
	gen 	absent = (provider_present2 == 0)
	replace absent = . if provider_present2 == .
	replace absent = . if absent_reason2 == 5 // "on-call" means you shouldn't be in the facility - remove from denominator
	replace absent = . if absent_reason2 == 12 // "not his/her shift" means you shouldn't be in the facility - remove from denominator
	
		
	*Make a variable for authorized vs unauthorized absence
	gen 	auth_absent 	= (absent_reason2 < 5 | absent_reason2 == 6 | absent_reason2 == 10 | absent_reason2 == 11)
	replace auth_absent		= . if absent_reason2 == . | absent_reason2 == 99 | absent_reason2 == 5 | absent_reason2 == 8 | absent_reason2 == 9 | absent_reason2 == 12
	replace auth_absent 	= . if absent == .

	gen 	unauth_absent 	= (absent_reason2 == 7)
	replace unauth_absent 	= . if absent_reason2 == . | absent_reason2 == 99 | absent_reason2 == 5 | absent_reason2 == 8 | absent_reason2 == 9 | absent_reason2 == 12
	replace unauth_absent 	= . if absent == .

	gen 	absent_unauth 	= 0
	replace absent_unauth 	= 1 if absent_reason2 == 7 // Count as present if they have an authorized reason
	replace absent_unauth 	= . if absent == .
		
	*Clean up reasons for absenteeism
	gen 	absent_reason_clean = absent_reason2
	replace absent_reason_clean = 2 if absent_reason2 == 11 | absent_reason2 == 6 // "Internal organization" counts as a "meeting"; "internship" counts as training 
	replace absent_reason_clean = 99 if absent_reason2 == 8 | absent_reason2 == 9 // Grouping collecting salary and on strike into "other"	
	replace absent_reason_clean = . if absent_reason2 == 5 | absent_reason2 == 12 // doesn't count as absent if you're not on shift or you're on call (not supposed to be working)
		
	*Make variables to be able to make stacked bar
	gen abz1 = (absent_reason_clean == 1) // sick/maternity
	gen abz2 = (absent_reason_clean == 2) // training/mtg
	gen abz3 = (absent_reason_clean == 3) // official mission
	gen abz4 = (absent_reason_clean == 10) // fieldwork
	gen abz5 = (absent_reason_clean == 4) // authorized
	gen abz6 = (absent_reason_clean == 99) // other
	gen abz7 = (absent_reason_clean == 7) // unauth
	
	forvalues n = 1/7 {
			replace abz`n' = . if absent_reason_clean == . 
		}
		
	gen total = 1 if absent != .	
	
	*Age categories **
	replace provider_age1 = . if provider_age1 == 99
	replace provider_age1 = . if provider_age1 < 15
	
	gen 	age_cat = 1 if provider_age1 < 30
	replace age_cat = 2 if provider_age1 >= 30 & provider_age1 < 40
	replace age_cat = 3 if provider_age1 >= 40 & provider_age1 < 50
	replace age_cat = 4 if provider_age1 >= 50 & provider_age1 != .	
	
	label define age_catz 1 "20 - 30 y/o" 2 "30 - 40 y/o" 3 "40 - 50 y/o" 4 "50+ y/o"
	label values age_cat age_catz
 
	*Drop merge variable from Kenya 2018
	drop _merge
	
	*Save appended module 2 dataset 
	save "$EL_dtInt/Module 2/All_countries_mod_2.dta", replace

***************************** End of do-file ************************************
