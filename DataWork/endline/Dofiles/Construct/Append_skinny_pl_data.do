* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Append provider level country dataset		   		   *
*				Provider ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Creates a skinny dataset of provider level information 

       ** IDS VAR: country year provider_id unique_id 
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: Feb 3rd 2021
 */
 
/******************************************
		Append provider level datasets
*******************************************/

	*Open Kenya provider level dataset 
	use "$EL_dtInt/Kenya_provider_level.dta", clear  
	
	*Append all provider level datasets 
	append using	"$EL_dtInt/Madagascar_provider_level.dta"		///
					"$EL_dtInt/Mozambique_provider_level.dta"		///
					"$EL_dtInt/Niger_provider_level.dta"			///
					"$EL_dtInt/Nigeria_provider_level.dta"			///
					"$EL_dtInt/Sierra_leone_provider_level.dta"		///
					"$EL_dtInt/Tanzania_provider_level.dta"			///
					"$EL_dtInt/Togo_provider_level.dta"				///
					"$EL_dtInt/Uganda_provider_level.dta"			///
					"$EL_dtInt/GuineaBissau_provider_level.dta"		///
					"$EL_dtInt/Malawi_2019_provider_level.dta"
					
	*Sort variables 
	sort 	country year admin1_name unique_id 
 
	*Number of providers across countries 
	count // 87,153 health providers  		
	  
	*Delete provider level datasets for each country - they are no longer needed 
	erase	"$EL_dtInt/Kenya_provider_level.dta"	
	erase	"$EL_dtInt/Madagascar_provider_level.dta"		
	erase	"$EL_dtInt/Mozambique_provider_level.dta"		
	erase	"$EL_dtInt/Niger_provider_level.dta"			
	erase	"$EL_dtInt/Nigeria_provider_level.dta"			
	erase	"$EL_dtInt/Sierra_leone_provider_level.dta"		
	erase	"$EL_dtInt/Tanzania_provider_level.dta"			
	erase	"$EL_dtInt/Togo_provider_level.dta"				
	erase	"$EL_dtInt/Uganda_provider_level.dta"			
	erase	"$EL_dtInt/GuineaBissau_provider_level.dta"		
	erase	"$EL_dtInt/Malawi_2019_provider_level.dta"	
	
	*Save appended dataset of provider level 
	save "$EL_dtInt/All_countries_pl.dta", replace 
	
************************ End of do-file ********************************
