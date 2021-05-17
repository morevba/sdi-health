* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	De-identify Dataset		   			              	   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Creates a de-identified version of a dataset

       ** IDS VAR:             
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: Jan 21st 2021
 */


/******************************************************************
Imports the translated Guinea Bissau (2018) from recieved from the SDI team
*******************************************************************/

	/**************
	Module 1,2,4 
	***************/
 
	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Guinea Bissau 2018/Translated/Module 1 2 and 4_FINAL_tran.dta", clear   
 
	*Drop all variales that contain identifiers
	drop	M1_A_5 M1_A_11a M1_A_11c M1_A_15a M1_A_15c M1_B_1 	///
			M1_B_40 M1_A_18c nome_comite1 nome_comite2 			///
			nome_comite3 nome_comite4 nome_comite5 nome_comite6	///
			M1_B_2 M1_A_8__Accuracy M1_A_8__Altitude 			///
			M1_A_8__Timestamp M2_A_4__*
			
	*Rename all GPS coordinates 
	rename 	M1_A_8__Longitude gpslong_all
	rename	M1_A_8__Latitude  gpslat_all		
			
	*Save de-identified version of the raw dataset 
	save	"$EL_dtDeID/Module124_GuineaBissau_2018_deid.dta", replace 		
	
	/**************
	Module A 1
	***************/
			
	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Guinea Bissau 2018/Translated/Adult patients_tran.dta", clear   
 
	*Drop adult patients that did not give consent
	drop if M3_B_1_1 != 1 // drops 1600 observations and only 282 observations remain 
	
	*Save de-identified version of the raw dataset 
	save	"$EL_dtDeID/ModuleA1_GuineaBissau_2018_deid.dta", replace 
	
	/**************
	Module A 2
	***************/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Guinea Bissau 2018/Translated/Adult exit surveys_tran.dta", clear   
 
	*Drop all variales that contain identifiers
	drop	 M5_A_2	
	
	*Drop adult patients that did not give consent
	drop if M5_A_0 == . | M5_A_0 == .a // drops 1,626 observations and only 256 observations remain
	
	*Save de-identified version of the raw dataset 
	save	"$EL_dtDeID/ModuleA2_GuineaBissau_2018_deid.dta", replace 
	
	/**************
	Module C 1
	***************/
	
	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Guinea Bissau 2018/Translated/Child patients_tran.dta", clear  
	
	*Drop if parents of child did not give consent
	drop if M3_B_2_1 != 1 // drops 1,648 observations and only 234 observations remain 
	
	*Save de-identified version of the raw dataset 
	save	"$EL_dtDeID/ModuleC1_GuineaBissau_2018_deid.dta", replace 
	
	/**************
	Module C 2
	***************/
 
	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Guinea Bissau 2018/Translated/Child exit surveys_tran.dta", clear  
	
	*Drop all variales that contain identifiers
	drop	 M5_B_2	
	
	*Drop if parents of child did not give consent
	drop if M5_B_0 == . | M5_B_0 == .a // drops 1,675 observations and only 207 observations remain
	
	*Save de-identified version of the raw dataset 
	save	"$EL_dtDeID/ModuleC2_GuineaBissau_2018_deid.dta", replace 
	
	/**************
	Module 3
	***************/
	
	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Guinea Bissau 2018/Translated/responseVignettes0_tran.dta", clear  
	
	*Drop all variales that contain identifiers
	drop	M3_A_2 M2_B_1a M2_B_1b M2_A_4 M2_A_6_esp M3_A_3a M2_A_5b M2_B_2b
	
	*Drop if health facility did not give consent
	drop if M3_A_11 != 1 // drops 704 observations and only 237 observations remain 
	
	*Save de-identified version of the raw dataset 
	save	"$EL_dtDeID/Module3_GuineaBissau_2018_deid.dta", replace 		
	
************************ End of do-file ****************************************
 
