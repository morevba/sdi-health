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
	 *Isolate the harmonized dataset 
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
 	 
			*Save Guinea Bissau provider skinny dataset 
			save "$EL_dtInt/GuineaBissau_provider_level.dta", replace 
		   
		restore  // return dataset to the form before keep command line  
	
		*Malawi provider level dataset 
		preserve // keep the dataset in it's current form 
		
			keep if country == "MALAWI" 
			
			*Check uganda provider level dataset is unique 
			isid country year unique_id
			
			*Check the number of providers  
			count // 13,275 health providers   
 	  
			*Save Malawi 2019 provider skinny dataset 
			save "$EL_dtInt/Malawi_2019_provider_level.dta", replace 
		   
		restore  // return dataset to the form before keep command line  

***************************** End of do-file ********************************************
 
