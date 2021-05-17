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
       ** Last date modified: Jan 15th 2021
 */
 
 
/***************************************************************
Imports the harmonized data from recieved from the SDI team
****************************************************************/

*Open raw identified dataset provided by the World Bank SDI team
use "$EL_dtRaw/Module123_Indiv.dta", clear  

*Drop all variables that contain an individual's name
drop 	facility_name enum1_visit1_name enum2_visit1_name				///
		enum1_visit2_name enum2_visit2_name verif_a admin3_name 		///
		admin4_name admin5_name admin6_name admin2_name verif_h 		///
		provider_surname1 provider_name1 provider_surname2 				///
		provider_name2 provider_fullname1 provider_name 				///
		pregnant_history_husband


*Drop all GPS coordinates 
drop gps*

*Save de-identified version of the harmonized dataset 
save "$EL_dtDeID/Module123_Indiv_deid.dta", replace 

/******************************************************************
Imports the harmonized Kenya (2012) from recieved from the SDI team
*******************************************************************/

/**********
Module 1
***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Kenya 2012/SDI_Kenya-2012_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name enum2_visit1_name enum1_visit2_name	///
			enum2_visit2_name 

	*Drop all GPS coordinates 
	drop	gpslat_all gpslong_all

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Kenya_2012_deid.dta", replace 

/**********
Module 2
***********/	
	
	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Kenya 2012/SDI_Kenya-2012_Module2_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	provider_fullname1 provider_fullname2

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Kenya_2012_deid.dta", replace 

/**********
Module 3
***********/	
	
	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Kenya 2012/SDI_Kenya-2012_Module3_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_name

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Kenya_2012_deid.dta", replace 

/******************************************************************
Imports the harmonized Tanzania (2012) from recieved from the SDI team
*******************************************************************/	

	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Tanzania 2014/SDI_Tanzania-2014_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name enum1_visit1_name enum2_visit1_name	///
			enum1_visit2_name enum2_visit2_name verif_a

	*Drop all GPS coordinates 
	drop	gpslat_o gpslat_m gpslat_s gpslong_o gpslong_m gpslong_s

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Tanzania_2014_deid.dta", replace 

	/**********
	Module 2
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Tanzania 2014/SDI_Tanzania-2014_Module2_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_surname1 provider_name1 provider_surname2 provider_name2

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Tanzania_2014_deid.dta", replace 

	/**********
	Module 3
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Tanzania 2014/SDI_Tanzania-2014_Module3_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_name

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Tanzania_2014_deid.dta", replace 	
	
/******************************************************************
Imports the harmonized Malawi (2019) from recieved from the SDI team
*******************************************************************/	


	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Malawi 2019/Malawi_Indiv_Full.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	Fname A102b C404A1 C404A10 C404A11 C404A12 C404A13	///
			C404A14 C404A15 C404A16 C404A17 C404A2 C404A3 		///
			C404A4 C404A5 C404A6 C404A7 C404A8 C404A9 C404A__0 	///
			C404A__1 C404A__10 C404A__11 C404A__12 C404A__14 	///
			C404A__13 C404A__2 C404A__3 C404A__4 C404A__5 		///
			C404A__6 C404A__7 C404A__8 C404A__9 names AA301A 	///
			AA301 AA302 AA303 AA304 AB301 AB302 AB304 AB303 	///
			B205

	*Drop all GPS coordinates 
	drop	A109__Longitude A109__Latitude

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Malawi_2019_deid.dta", replace 
 

************************ End of do-file ****************************************

