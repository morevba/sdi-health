* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Merge variables										   *
*				Provider ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Merge variables to the appended 

       ** IDS VAR: country year facility_id provider_id
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	Apr 13th 2021
 */
 
/*************************************
		Harmonized dataset 
**************************************/

	*Open harmonized dataset 
	use  "$EL_dtInt/All_countries_harm.dta", clear    
  
	*Isolate the variables in which the dataset is unique 
	keep	country year facility_id provider_id unique_id	/// unique identifiers 
			admin1_name admin2_name med_frac num_med 		/// variales being added
			num_staff caseload skip_* *_history_* *_exam_*	///
			diag* *_test_* diag* treat* num_skipped			///
			public *_antibio avg_weight weight
				
	order	country year facility_id 
	sort 	country year facility_id provider_id unique_id

	*Apply lables to isolated variables 
	label var	country "Name of country"
	label var 	year 	"Year survey was conducted" 
	
	*Clean up counntry weights - these countries dont have weights yet 
	replace weight = . if country == "GUINEABISSAU"
	replace weight = . if country == "MOZAMBIQUE"
	replace weight = . if country == "MALAWI"
 
	*Check if the dataset is unique at provider level 
	isid country year facility_id provider_id // dataset is unique at provider id level 
  
	*Drop provider id variable 
	drop facility_id 						// this variable is no longer needed 
	sort country year provider_id unique_id	// sort dataset 
 	 
/*************************************
		Merge variables  
**************************************/	
	
	*Merge varibles needed to provider level dataset 
	merge 1:1 country year unique_id using "$EL_dtInt/All_countries_pl.dta"
	
	*Check that there are no unmatched observations 
	assert  _merge!= 1
	drop 	_merge 		// variable is no longer needed 	
  	
	/*****************************************************
	Merge povery rates variables to provider level dataset
	*******************************************************/
   
	gen		admin1_name_temp	= admin1_name
	replace	admin1_name_temp	= admin2_name		if country == "SIERRALEONE"
	replace	admin1_name_temp	= admin2_name		if country == "MALAWI"
	replace	admin1_name_temp	= admin2_name		if cy == "KEN_2012"
	replace admin1_name_temp	= "Nairobi City"	if cy == "KEN_2012"
	replace admin1_name_temp	= "Golfe/Lome"		if admin1 == 1 & country == "TOGO" 
	replace admin1_name_temp	= "Western" 		if admin1_name_temp == "Western Rural" | admin1_name_temp == "Western Urban" 
	replace admin1_name_temp 	= strproper(admin1_name_temp) if cy == "KEN_2012" // fix the casing of some states
	
	sort 	country admin1_name_temp
	merge m:1 country admin1_name_temp using "$EL_dtInt/Poverty rates/poverty_rates.dta"
	drop if _merge ==2	// drop unmatched poverty rates from using dataset 
	drop 	_merge 		// _merge no longer needed 
   
	*Drop admin variables no longer needed 
	drop admin1_name_temp  
 
	/*****************************************************
	Merge in IRT estimates to provider level dataset 
	*******************************************************/
	
	*Create a unique_id that includes country year needed for merge 
	sort 	cy unique_id 
	gen 	unique_id2 = cy + "_" + unique_id 
   
	sort 	unique_id2
	merge 	1:1 unique_id2 using "$EL_dt/Final/IRT_parameters.dta", keepusing(theta_mle) 
	drop 	if _merge == 2 		// drop providers that did not make the final merged module dataset 
	drop 	_merge unique_id2 	// these variables are not needed anymore 
	
	*Order the variables 
	sort	country year admin1_name unique_id 	
	order	country year admin1_name provider_id unique_id  
	
	*Save final dataset with new variables added 
	save "$EL_dtFin/Final_pl.dta", replace 
	
************************ End of do-file *****************************************	
