* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Create simple datasets for each country		   		   *
*				Provider ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Creates a skinny dataset of provider level information 

       ** IDS VAR: country year provider_id 
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: Jan 22nd 2021
 */
 	
/*************************************
		Harmonized dataset 
**************************************/

	*Open harmonized dataset 
	use  "$EL_dtInt/All_countries_harm.dta", clear  

	*Isolate the variables in which the dataset is unique 
	keep	facility_id country year provider_id	///		unique identifiers
			provider_cadre1 provider_educ1 			///		key variables wanted 
			provider_mededuc1 provider_male1 		///
			provider_age1 admin1_name unique_id cy	///
			gpslat_all gpslong_all fac_type map_id	///
			admin1_name admin1 facility_level 
			
	order	country year facility_id 				// order the variables 
	sort 	country year facility_id provider_id	// sort the dataset 

	*Apply lables to isolated variables 
	label var	country "Name of country"
	label var 	year 	"Year survey was conducted" 
 
	*Check if the dataset is unique at provider level 
	isid country year facility_id provider_id // dataset is unique at provider id level 
 
/************************************
	Create provider level datasets 
*************************************/

	**************************************
	{   //*Isolate the harmonized dataset 
	**************************************

	*Sort and order key variables 
	sort 	country year admin1_name unique_id 				// sort dataset 
	order	country year admin1_name unique_id provider_id	// order the dataset 
	
	*Create a provider level dataset for each country in the dataset 

		*Kenya provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "KENYA" 
			
			*Check kenya provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count // 27,542 health providers  
 	 
			*Save Kenya provider skinny dataset 
			save "$EL_dtInt/Kenya_provider_level.dta", replace 
			
		restore  // return dataset to the form before keep command line  	
		
		*Madagascar provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "MADAGASCAR" 
			
			*Check madagascar provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count // 2,200 health providers  
 	 
			*Save Madagascar provider skinny dataset 
			save "$EL_dtInt/Madagascar_provider_level.dta", replace 
		 
		restore  // return dataset to the form before keep command line  
		
		*Mozambique provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "MOZAMBIQUE" 
			
			*Check mozambique provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count //  2,972 health providers  
 	 
			*Save Mozambique provider skinny dataset 
			save "$EL_dtInt/Mozambique_provider_level.dta", replace 
		  
		restore  // return dataset to the form before keep command line  
		
		*Niger provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "NIGER" 
			
			*Check niger provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count // 1,331 health providers  
 	 
			*Save Niger provider skinny dataset 
			save "$EL_dtInt/Niger_provider_level.dta", replace 
		   
		restore  // return dataset to the form before keep command line  
		
		*Nigeria provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "NIGERIA" 
			
			*Check nigeria provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count // 21,318 health providers  
 	 
			*Save Nigeria provider skinny dataset 
			save "$EL_dtInt/Nigeria_provider_level.dta", replace 
		   
		restore  // return dataset to the form before keep command line  
		
		*Sierra Leone provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "SIERRALEONE" 
			
			*Check sierra leone provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count // 5,055 health providers  
 	 
			*Save Sierra Leone provider skinny dataset 
			save "$EL_dtInt/Sierra_leone_provider_level.dta", replace 
		   
		restore  // return dataset to the form before keep command line  
		
		*Tanzania provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "TANZANIA" 
			
			*Check tanzania provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count // 9,619 health providers  
 	 
			*Save Tanzania provider skinny dataset 
			save "$EL_dtInt/Tanzania_provider_level.dta", replace 
		   
		restore  // return dataset to the form before keep command line
		
		*Togo provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "TOGO" 
			
			*Check togo provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count // 1,364 health providers  
 	 
			*Save Togo provider skinny dataset 
			save "$EL_dtInt/Togo_provider_level.dta", replace 
		   
		restore  // return dataset to the form before keep command line  
		
		*Uganda provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "UGANDA" 
			
			*Check uganda provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count // 2,347 health providers  
 	 
			*Save Uganda provider skinny dataset 
			save "$EL_dtInt/Uganda_provider_level.dta", replace 
		   
		restore  // return dataset to the form before keep command line  
		
		*Guinea Bissau provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "GUINEABISSAU" 
			
			*Check uganda provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count // 260 health providers  
 	 
			*Save Uganda provider skinny dataset 
			save "$EL_dtInt/GuineaBissau_provider_level.dta", replace 
		   
		restore  // return dataset to the form before keep command line  
	}
	


/*****************************************************
	Create provider level datasets - Malawi 2019 dataset 
*******************************************************/

	**************************************
   //Isolate the Malawi dataset 
	**************************************
	
	*Open de-identified dataset 
	use "$EL_dtDeID/Malawi_2019_deid.dta", clear   
  
	*Isolate the variables in which the dataset is unique 
	keep	facility_id provider_id A220 facility_level		///
 			Dist A219 Resid public gpslat_all gpslong_all	///
			A215 A311 A313 A210 A211 

	*Create key variables 
	gen			country 		= "MALAWI"
	gen			year 			= 2019
	gen 		provider_age1	=int(A220)
	gen 		cy = "MWI_2019", after(year)
	egen 		map_id = concat(cy facility_id), punct("_")
	decode 		Dist, gen(admin1_name) 
	egen 		unique_id = concat(facility_id provider_id), punct(_)
	gen			provider_male1 	= 0 if A219 == 2
	replace 	provider_male1	= 1 if A219 == 1
	rename 		Dist			admin1
	recode 		Resid (2=0), gen(rural)
	rename 		A211 num_med
	rename 		A210 num_staff
	*rename 	A212 num_nonmed
	
	*Create fac_type variable 
	gen			fac_type	= 1 if rural == 1 & facility_level == 1 
	replace 	fac_type	= 2 if rural == 1 & facility_level == 2
	replace 	fac_type	= 3 if rural == 1 & facility_level == 3
	replace 	fac_type	= 4 if rural == 0 & facility_level == 1
	replace 	fac_type	= 5 if rural == 0 & facility_level == 2
	replace 	fac_type	= 6 if rural == 0 & facility_level == 3
	
	*Create value labels for facility variables 
	label var 	fac_type "Facility type"
	lab 		def fac_type_lab 	1 "Rural Hospital" 2 "Rural Clinic" 3 "Rural Health Post" ///
									4 "Urban Hospital" 5 "Urban Clinic" 6 "Urban Health Post"
	lab 		val fac_type fac_type_lab 
	
	lab 		def fac_level_lab 	1 "Hospital" 2 "Health Center" 3 "Health Post"
	lab 		val facility_level fac_level_lab 
	
	*Create value labels for gender 
	label var 	provider_male1 "Provider is male, first visit"
	lab 		def provider_male1_lab 0 "Female" 1 "Male"
	lab 		val provider_male1 provider_male1_lab 
	
	*Create value labels for provider occupation 
	recode	  	A215 (2 3 5 = 1) ( 7/9 11/12 17 23/24 = 3) (4 10 13/16 18/22 25/99 = 4) 
	gen			provider_cadre1 = A215
	lab 		def cadrelab 1 "Doctor" 2 "Clinical Officer" 3 "Nurse" 4 "Other"
	lab 		val provider_cadre1 cadrelab
	
	*Adjust provider education
	rename 		A311 provider_educ1
	recode		provider_educ1 (1=1) (2/3=2) (4/7=3) (9 0=.) 
	lab 		def educlab 1 "Primary" 2 "Secondary" 3 "Post-Secondary" 
	lab 		val provider_educ1 educlab
	
	*Adjust provider medical education
	rename 		A313 provider_mededuc1
	recode		provider_mededuc1 (1=1) (2=2) (3 5=3) (4 6/7 =4) (9 0=.) 
	lab 		def mededuclab 1 "None" 2 "Certificate" 3 "Diploma" 4 "Advanced"
	lab 		val provider_mededuc1 mededuclab
	
	*Create fraction of med staff
	gen  med_frac = num_med / num_staff
	
	*Apply lables to isolated variables 
	lab var	country 		"Name of country"
	lab var year 			"Year survey was conducted" 
	lab var	unique_id 		"Unique provider identifier: facility ID + provider ID"
	lab var provider_age1	"Provider's age, first visit"
	lab var cy 				"Country + Year Code"
	lab var map_id			"Map ID for health facility"
 
	*Order and sort variables 
	order 	gps*, after(public)
	order	country year unique_id 	// order the variables 
	sort 	country year unique_id 	// sort the dataset 
	
	*Drop unwanted variables 
	drop A220 A219 Resid public rural A215
 
	*Drop observations with missing provider id 
	drop if provider_id == . // this drops 13 observations
	
	*String provider id variable 
	tostring provider_id, replace 
	
	*Check if the dataset is unique at provider level 
	isid country year unique_id  // dataset is unique at provider id level 
	
	*Check the number of providers  
	count // 13,277 health providers  
 	 
	*Save Kenya 2012 provider skinny dataset 
	save "$EL_dtInt/Malawi_2019_provider_level.dta", replace 

***************************** End of do-file ********************************************
 
