* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Append facility level country dataset		   		   *
*				Facility ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Creates a skinny dataset of facility level information 

       ** IDS VAR: country year facility_id 
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: Feb 3rd 2021
 */
 
/******************************************
		Append facility level datasets
*******************************************/

	*Open Kenya facility level dataset 
	use "$EL_dtInt/Kenya_facility_level.dta", clear  
	
	*Append all facility level datasets 
	append using	"$EL_dtInt/Madagascar_facility_level.dta"		///
					"$EL_dtInt/Mozambique_facility_level.dta"		///
					"$EL_dtInt/Niger_facility_level.dta"			///
					"$EL_dtInt/Nigeria_facility_level.dta"			///
					"$EL_dtInt/Sierra_leone_facility_level.dta"		///
					"$EL_dtInt/Tanzania_facility_level.dta"			///
					"$EL_dtInt/Togo_facility_level.dta"				///
					"$EL_dtInt/Uganda_facility_level.dta"			/// 
					"$EL_dtInt/GuineaBissau_facility_level.dta"		/// 
					"$EL_dtInt/Malawi_2019_facility_level.dta"
					
	*Sort variables 
	sort country year facility_id
	
	*Number of facilities across countries 
	count // 9,697 health facilities 
	
	*Delete facility level datasets for each country - they are no longer needed 
	erase 	"$EL_dtInt/Madagascar_facility_level.dta"		
	erase	"$EL_dtInt/Mozambique_facility_level.dta"		
	erase	"$EL_dtInt/Niger_facility_level.dta"			
	erase	"$EL_dtInt/Nigeria_facility_level.dta"			
	erase	"$EL_dtInt/Togo_facility_level.dta"				
	erase	"$EL_dtInt/Uganda_facility_level.dta"			
	erase	"$EL_dtInt/Malawi_2019_facility_level.dta"		
	erase	"$EL_dtInt/Kenya_facility_level.dta"
	erase	"$EL_dtInt/Tanzania_facility_level.dta"
	erase	"$EL_dtInt/Sierra_leone_facility_level.dta"
	erase	"$EL_dtInt/GuineaBissau_facility_level.dta"
	
	*Save appended dataset of facility level 
	save "$EL_dtInt/All_countries_fl.dta", replace 
	
************************ End of do-file ********************************		
	
