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
	{   //*Isolate the harmonized dataset 
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
			
			*Check that Tanzania facility level dataset is unique 
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
			
			*Check that Tanzania facility level dataset is unique 
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
			
			*Check that Tanzania facility level dataset is unique 
			isid country year facility_id 
			
			*Check the number of facilities 
			count // 130 health facilities 
			
			*Save Uganda facility level dataset 
			save "$EL_dtInt/GuineaBissau_facility_level.dta", replace 
	 	
		restore  // return dataset to the form before keep command line   	
}

/*********************************************************
	Create facility level datasets - Malawi 2019 dataset 
**********************************************************/

	**************************************
	  //Isolate the Malawi dataset 
	**************************************
	
	*Open de-identified dataset 
	use "$EL_dtDeID/Malawi_2019_deid.dta", clear    
	
	*Isolate the variables in which the dataset is unique 
	keep	facility_id facility_level Dist Resid	///
			public gpslat_all gpslong_all A210 A211 

	*Create key variables 
	gen			country 		= "MALAWI"
	gen			year 			= 2019
	gen 		cy = "MWI_2019", after(year)
	egen 		map_id = concat(cy facility_id), punct("_")
	decode 		Dist, gen(admin1_name)
	rename 		Dist			admin1
	recode 		Resid (2=0), gen(rural)
	rename 		A211 num_med
	rename 		A210 num_staff

	
	*Apply lables to isolated variables 
	lab var		country "Name of country"
	lab var 	year 	"Year survey was conducted" 
	lab var 	cy 		"Country + Year Code"
	lab var 	map_id	"Map ID for health facility"

	*Create fac_type variable 
	gen		fac_type	= 1 if rural == 1 & facility_level == 1 
	replace fac_type	= 2 if rural == 1 & facility_level == 2
	replace fac_type	= 3 if rural == 1 & facility_level == 3
	replace fac_type	= 4 if rural == 0 & facility_level == 1
	replace fac_type	= 5 if rural == 0 & facility_level == 2
	replace fac_type	= 6 if rural == 0 & facility_level == 3
	
	*Create value labels for facility variables 
	label var 	fac_type "Facility type"
	lab 		def fac_type_lab 	1 "Rural Hospital" 2 "Rural Clinic" 3 "Rural Health Post" ///
									4 "Urban Hospital" 5 "Urban Clinic" 6 "Urban Health Post"
	lab 		val fac_type fac_type_lab 
	
	lab 		def fac_level_lab 	1 "Hospital" 2 "Health Center" 3 "Health Post"
	lab 		val facility_level fac_level_lab 
	
	*Create fraction of med staff
	gen  med_frac = num_med / num_staff
	
	*Order GPS variables 
	order gps*, after(public)
 
	*Sort and order variables 
	order	country year facility_id 
	sort 	country year facility_id 
	
	*Remove duplicate facility ids - only need 1 facility id 
	bysort 	country year facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		
	
	drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
	drop 	facility_id_dup				// this variable is no longer needed 
	
	*Drop variables no longer 
	drop	Resid public rural 
 
	*Check if the dataset is unique at facility level 
	isid 	country year facility_id  // dataset is unique at the facility id level 
	
	*Check the number of facilities 
	count // 1,106 health facilities 
	
	*Save Malawi 2019 facility skinny dataset 
	save "$EL_dtInt/Malawi_2019_facility_level.dta", replace 

*************************** End of do-file **************************************
