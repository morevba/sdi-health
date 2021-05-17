* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Create simple datasets for each country		   		   *
*				Facility ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Creates a skinny dataset of facility level information 

       ** IDS VAR: country year facility_id 
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: Feb 4th 2021
 */

/*************************************
		Harmonized dataset 
**************************************/

	*Open harmonized dataset 
	use  "$EL_dtInt/All_countries_harm.dta", clear  
	
	*Isolate the variables in which the dataset is unique 
	keep	facility_id country year provider_id	/// 	unique identifiers
			facility_level fac_type admin1_name  	///  	key facility variables wanted 
			map_id gpslat_all gpslong_all rural		///
			admin1 map_id cy
			
	order	country year facility_id 
	sort 	country year facility_id provider_id

	*Apply lables to isolated variables 
	label var	country "Name of country"
	label var 	year 	"Year survey was conducted" 
 
	*Check if the dataset is unique at provider level 
	isid country year facility_id provider_id // dataset is unique at provider id level 
 
/********************************************************
	Create facility level datasets - Harmanized datasets
*********************************************************/

	**************************************
	   *Isolate the harmonized dataset 
	*************************************
	
	*Drop provider id variable 
	drop provider_id // this variable is not needed for facility level datasets 
	
	*Create a facility level dataset for each country in the dataset 

		*Kenya facility level dataset 
		preserve // keep the dataset in it's current form 
			
			keep if country == "KENYA" 
 			
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		
			
			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup				// this variable is no longer needed 
			
			*Check kenya facility level dataset is unique 
			isid country year facility_id
			
			*Check the number of facilities 
			count // 3324 health facilities 
 			
			*Save Kenya facility skinny dataset 
			save "$EL_dtInt/Kenya_facility_level.dta", replace 
			
		restore  // return dataset to the form before keep command line  
  
		*Madagascar facility level dataset 
		preserve // keep the dataset in it's current form  
		
			keep if country == "MADAGASCAR"
			
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		
			
			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup				// this variable is no longer needed 
			
			*Check that Madagascar facility level dataset is unique 
			isid country year facility_id
			
			*Check the number of facilities 
			count // 444 health facilities 
			
			*Save Madagascar facility level dataset 
			save "$EL_dtInt/Madagascar_facility_level.dta", replace 
		
		restore // return dataset to the form before keep command line  

 
		*Mozambique facility level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "MOZAMBIQUE"
	 
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		
			
			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup				// this variable is no longer needed 
			
			*Check that Mozambique facility level dataset is unique 
			isid country year facility_id
			
			*Check the number of facilities 
			count // 195 health facilities 
			
			*Save Mozambique facility level dataset 
			save "$EL_dtInt/Mozambique_facility_level.dta", replace 
		
		restore // return dataset to the form before keep command line  

		*Niger facility level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "NIGER"
			
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		

			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup
			
			*Check that Niger facility level dataset is unique 
			isid country year facility_id
			
			*Check the number of facilities 
			count // 255 health facilities 
			
			*Save Niger facility level dataset 
			save "$EL_dtInt/Niger_facility_level.dta", replace 
		
		restore // return dataset to the form before keep command line  
		 
		*Nigeria facility level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "NIGERIA"
			
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		
	 
			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup
			
			*Check that Nigeria facility level dataset is unique 
			isid country year facility_id
			
			*Check the number of facilities 
			count //  2,385 health facilities 
			
			*Save Nigeria facility level dataset 
			save "$EL_dtInt/Nigeria_facility_level.dta", replace 
		
		restore // return dataset to the form before keep command line  

 
		*Sierra Leone facility level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "SIERRALEONE"
			
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		 

			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup
			
			*Check that Sierra Leone facility level dataset is unique 
			isid country year facility_id
			
			*Check the number of facilities 
			count //  536 health facilities 
		
			*Save Sierra Leone facility level dataset 
			save "$EL_dtInt/Sierra_leone_facility_level.dta", replace 
		
		restore // return dataset to the form before keep command line  


		*Tanzania facility level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "TANZANIA"
			
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		 
	 
			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup
			
			*Check that Tanzania facility level dataset is unique 
			isid country year facility_id 
			
			*Check the number of facilities 
			count // 763 health facilities 
			
			*Save Tanzania facility level dataset 
			save "$EL_dtInt/Tanzania_facility_level.dta", replace 
		
		restore  // return dataset to the form before keep command line  
		
		*Togo facility level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "TOGO"
			
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		 
	 
			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup
			
			*Check that Togo facility level dataset is unique 
			isid country year facility_id 
			
			*Check the number of facilities 
			count // 180 health facilities 
			
			*Save Togo facility level dataset 
			save "$EL_dtInt/Togo_facility_level.dta", replace 
		
		restore  // return dataset to the form before keep command line 		
		 
		*Uganda facility level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "UGANDA"
	 
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		 
	  
			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup
			
			*Check that Uganda facility level dataset is unique 
			isid country year facility_id 
			
			*Check the number of facilities 
			count // 394 health facilities 
			
			*Save Uganda facility level dataset 
			save "$EL_dtInt/Uganda_facility_level.dta", replace 
	 	
		restore  // return dataset to the form before keep command line  
		
		*Guinea Bissau facility level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "GUINEABISSAU"
	 
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		 
	  
			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup
			
			*Check that Guinea Bissau facility level dataset is unique 
			isid country year facility_id 
			
			*Check the number of facilities 
			count // 130 health facilities 
			
			*Save Guinea Bissau facility level dataset 
			save "$EL_dtInt/GuineaBissau_facility_level.dta", replace 
	 	
		restore  // return dataset to the form before keep command line  
		
		*Malawi facility level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "MALAWI"
	 
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		 
	  
			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup
			
			*Check that Malawi facility level dataset is unique 
			isid country year facility_id 
			
			*Check the number of facilities 
			count // 1,091 health facilities 
	 
			*Save Malawi 2019 facility skinny dataset 
			save "$EL_dtInt/Malawi_2019_facility_level.dta", replace 
	 	
		restore  // return dataset to the form before keep command line 

*************************** End of do-file **************************************
