* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Merge variables										   *
*				Facility ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Merge variables to the appended facility level dataset 

       ** IDS VAR: country year facility_id provider_id
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	Feb 4th 2021
 */
 
 
/*************************************
		Harmonized dataset 
**************************************/

	*Open harmonized dataset 
	use  "$EL_dtInt/All_countries_harm.dta", clear   
 
	*Isolate the variables in which the dataset is unique 
	keep	facility_id country year provider_id	/// unique identifiers 
			gps_utm	admin1_name admin2_name	num_med /// variales being added
			num_staff med_frac
			
	order	country year facility_id 
	sort 	country year facility_id provider_id

	*Apply lables to isolated variables 
	label var	country "Name of country"
	label var 	year 	"Year survey was conducted" 
 
	*Check if the dataset is unique at provider level 
	isid country year facility_id provider_id // dataset is unique at provider id level 
  
	*Drop provider id variable 
	drop provider_id // this variable is no longer needed 
	
	*Remove duplicate facility ids - only need 1 unique facility id 
	bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		
	
	drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
	drop 	facility_id_dup				// this variable is no longer needed 
	sort 	country year facility_id	// sort dataset 
	
/*************************************
		Merge variables  
**************************************/	
	
	*Merge varibles needed to facility level dataset 
	merge 1:1 country year facility_id using "$EL_dtInt/All_countries_fl.dta"
	
	*Check that there are no unmatched observations 
	assert  _merge!= 1
	drop 	_merge 		// variable is no longer needed 
  
	/*****************************************************
	Merge povery rates variables to facility level dataset
	*******************************************************/
  
	gen		admin1_name_temp	= admin1_name
	replace	admin1_name_temp	= admin2_name		if country == "SIERRALEONE"
	replace	admin1_name_temp	= admin2_name		if cy == "KEN_2012"
	replace admin1_name_temp	= "Nairobi City"	if cy == "KEN_2012" 
	replace admin1_name_temp	= "Golfe/Lome"		if admin1 == 1 & country == "TOGO" 
	replace admin1_name			= admin1_name_temp	if admin1 == 1 & country == "TOGO"  
	replace admin1_name_temp	= "Western" 		if admin1_name_temp == "Western Rural" | admin1_name_temp == "Western Urban" 
	replace admin1_name_temp 	= strproper(admin1_name_temp) if cy == "KEN_2012" // fix the caseing of some states
	
	sort 	country admin1_name_temp
	merge m:1 country admin1_name_temp using "$EL_dtInt/Poverty rates/poverty_rates.dta"
	drop if _merge ==2	// drop unmatched poverty rates from using dataset 
	drop 	_merge 		// _merge no longer needed 
 
	*Drop admin variables no longer needed 
	drop admin1_name_temp admin2_name 
 
	*Order the variables 
	order country year facility_id 
	
	*Save final dataset with new variables added 
	save "$EL_dtFin/Final_fl.dta", replace 
 
**************************** End of do-file ***************************************
