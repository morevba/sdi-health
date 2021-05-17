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
			
	*Clean up GPS coordinates 
	gen 	gps_lat_temp = gpslat_all
	replace gps_lat_temp = subinstr(gps_lat_temp, "'", "-", .)
	split 	gps_lat_temp, gen(latz) parse(".", " ", "-") destring
	gen 	gps_lat = latz2 + latz3/100 + latz4/10000 + latz5/1000000
	replace gps_lat = gps_lat*-1 if latz1 == "S"
	drop 	latz* gps_lat_temp gpslat_all

	gen 	gps_lon_temp = gpslong_all
	replace gps_lon_temp = subinstr(gps_lon_temp, "'", "-", .)
	split 	gps_lon_temp, gen(lonz) parse(".", " ", "-") destring
	gen 	gps_lon = lonz2 + lonz3/100 + lonz4/10000 + lonz5/1000000
	replace gps_lon = gps_lon*-1 if lonz1 == "W"
	drop 	lonz* gps_lon_temp gpslong_all
	
	rename	gps_lat gpslat_all
	rename 	gps_lon gpslong_all

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
Imports the harmonized Kenya (2018) from recieved from the SDI team
*******************************************************************/

/**********
Module 1
***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Kenya 2018/SDI_Kenya-2018_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name  	 

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Kenya_2018_deid.dta", replace 

/**********
Module 2
***********/	
	
	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Kenya 2018/SDI_Kenya-2018_Module2_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	provider_surname1 provider_name1 provider_surname2 provider_name2

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Kenya_2018_deid.dta", replace 

/**********
Module 3
***********/	
	
	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Kenya 2018/SDI_Kenya-2018_Module3_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_name

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Kenya_2018_deid.dta", replace 	 
	
/***********************************************************************
Imports the harmonized Madagascar (2016) from recieved from the SDI team
************************************************************************/	

	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Madagascar 2016/SDI_Madagascar-2016_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name  
	
	*Create GPS coordinates 
	gen 	gpslat_all = .
	gen 	gpslong_all = .
	lab var gpslat_all "GPS position latitude (full coordinates)"
	lab var gpslong_all "GPS position longitude (full coordinates)"

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Madagascar_2016_deid.dta", replace 

	/**********
	Module 2
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Madagascar 2016/SDI_Madagascar-2016_Module2_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_surname1 provider_name1 provider_surname2 provider_name2

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Madagascar_2016_deid.dta", replace 

	/**********
	Module 3
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Madagascar 2016/SDI_Madagascar-2016_Module3_Harmonized.dta", clear   
 
	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Madagascar_2016_deid.dta", replace 	
	
/***********************************************************************
Imports the harmonized Mozambique (2014) from recieved from the SDI team
************************************************************************/	

	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Mozambique 2014/SDI_Mozambique-2014_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name  
	
	*Destring GPS variables 
	destring gpslong_all gpslat_all, replace 
	
	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Mozambique_2014_deid.dta", replace 

	/**********
	Module 2
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Mozambique 2014/SDI_Mozambique-2014_Module2_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_surname1 provider_name1 provider_surname2 provider_name2

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Mozambique_2014_deid.dta", replace 

	/**********
	Module 3
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Mozambique 2014/SDI_Mozambique-2014_Module3_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_name

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Mozambique_2014_deid.dta", replace 	
		
 
/***********************************************************************
Imports the harmonized Niger (2015) from recieved from the SDI team
************************************************************************/	

	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Niger 2015/SDI_Niger-2015_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name  enum1_visit1_name enum2_visit1_name	///
			enum1_visit2_name enum2_visit2_name verif_h verif_a
			
	*Rename GPS coordinates 
	gen 	gpslat_all = substr(gps_both, 1, 8)
	gen 	gpslong_all = substr(gps_both, 9, 7)
	lab var gpslat_all  "GPS position latitude (full coordinates)"
	lab var gpslong_all "GPS position longitude (full coordinates)"
	drop 	gps_both
	destring gpslong_all gpslat_all, replace 

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Niger_2015_deid.dta", replace 

	/**********
	Module 2
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Niger 2015/SDI_Niger-2015_Module2_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_surname1 provider_name1 provider_surname2 provider_name2

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Niger_2015_deid.dta", replace 

	/**********
	Module 3
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Niger 2015/SDI_Niger-2015_Module3_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_name

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Niger_2015_deid.dta", replace 	
			
/***********************************************************************
Imports the harmonized Nigeria (2013) from recieved from the SDI team
************************************************************************/	

	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Nigeria 2013/SDI_Nigeria-2013_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name  enum1_visit1_name enum2_visit1_name	///
			enum1_visit2_name enum2_visit2_name  verif_a
		
	*Clean up GPS coordinates 
	gen 		first = substr(gpslat_all, 1, 2)
	destring 	first, replace force
	gen 		dd = (first == 10 | first == 11 | first == 12)
	gen 		gps_lat = real(substr(gpslat_all,1,2) + "." + substr(gpslat_all,3,.)) if dd == 1
	replace 	gps_lat = real(substr(gpslat_all,1,1) + "." + substr(gpslat_all,2,.)) if dd == 0
	drop 		first dd 
	gen 		first = substr(gpslong_all, 1, 2)
	destring 	first, replace force
	gen 		dd = (first == 10 | first == 11 | first == 12)
	gen 		gps_lon = real(substr(gpslong_all,1,2) + "." + substr(gpslong_all,3,.)) if dd == 1
	replace 	gps_lon = real(substr(gpslong_all,1,1) + "." + substr(gpslong_all,2,.)) if dd == 0
	lab var 	gps_lat "GPS position latitude (full coordinates)"
	lab var 	gps_lon "GPS position longitude (full coordinates)" 
	drop 		first dd gpslat_all gpslong_all
	rename		gps_lat gpslat_all 
	rename 		gps_lon gpslong_all	
	
	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Nigeria_2013_deid.dta", replace 

	/**********
	Module 2
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Nigeria 2013/SDI_Nigeria-2013_Module2_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_surname1 provider_name1 provider_surname2 provider_name2

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Nigeria_2013_deid.dta", replace 

	/**********
	Module 3
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Nigeria 2013/SDI_Nigeria-2013_Module3_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_name

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Nigeria_2013_deid.dta", replace 	

/***********************************************************************
Imports the harmonized Sierra Leone (2018) from recieved from the SDI team
************************************************************************/	

	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Sierra Leone 2018/SDI_SierraLeone-2018_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name enum1_visit1_name
 
	*Destring GPS variables 
	destring gpslong_all gpslat_all, replace 

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_SierraLeone_2018_deid.dta", replace 

	/**********
	Module 2
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Sierra Leone 2018/SDI_SierraLeone-2018_Module2_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_surname1 provider_name1 provider_surname2 provider_name2

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_SierraLeone_2018_deid.dta", replace 

	/**********
	Module 3
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Sierra Leone 2018/SDI_SierraLeone-2018_Module3_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_name

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_SierraLeone_2018_deid.dta", replace 
	
/******************************************************************
Imports the harmonized Tanzania (2016) from recieved from the SDI team
*******************************************************************/	

	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Tanzania 2016/SDI_Tanzania-2016_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name enum1_visit1_name enum2_visit1_name	///
			enum1_visit2_name enum2_visit2_name verif_a
			
	*Clean up GPS coordinates 
	foreach var of varlist gps*{
		replace `var' = . if `var' == -8
		replace `var' = . if gpslat_o > 10 // Some random bad readings
		replace `var' = . if gpslong_o == 0 | gpslong_o == 1 // Some random bad readings
	}
	gen 	gpslat_all 	= gpslat_o + (gpslat_m/60) + (((gpslat_s/1000)*60)/3600)
	replace gpslat_all 	= gpslat_all*-1 
	gen 	gpslong_all	= gpslong_o + (gpslong_m/60) + (((gpslat_s/1000)*60)/3600)
	lab var gpslat_all  "GPS position latitude (full coordinates)"
	lab var gpslong_all "GPS position longitude (full coordinates)"
	drop	gpslat_o gpslat_m gpslat_s gpslong_o gpslong_m gpslong_s
 
	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Tanzania_2016_deid.dta", replace 

	/**********
	Module 2
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Tanzania 2016/SDI_Tanzania-2016_Module2_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_surname1 provider_name1 provider_surname2 provider_name2

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Tanzania_2016_deid.dta", replace 

	/**********
	Module 3
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Tanzania 2016/SDI_Tanzania-2016_Module3_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_name

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Tanzania_2016_deid.dta", replace 		
	
/******************************************************************
Imports the harmonized Tanzania (2014) from recieved from the SDI team
*******************************************************************/	

	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Tanzania 2014/SDI_Tanzania-2014_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name enum1_visit1_name enum2_visit1_name	///
			enum1_visit2_name enum2_visit2_name verif_a
			
	*Clean up GPS coordinates 
	foreach var in gpslat_o gpslat_m gpslat_s gpslong_o gpslong_m gpslong_s {
		replace `var' = . if inlist(`var',-99,-88,99,999,0)
		replace `var' = . if gpslong_o < 10 // Some facilities have a GPS longitude less than 10 which puts them in the Atlantic
	}
	
	gen 	gpslat_all 	= gpslat_o + (gpslat_m/60) + (((gpslat_s/1000)*60)/3600)
	replace gpslat_all 	= gpslat_all*-1 
	gen 	gpslong_all	= gpslong_o + (gpslong_m/60) + (((gpslat_s/1000)*60)/3600)
	lab var gpslat_all  "GPS position latitude (full coordinates)"
	lab var gpslong_all "GPS position longitude (full coordinates)"
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

/***********************************************************************
Imports the harmonized Togo (2013) from recieved from the SDI team
************************************************************************/	

	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Togo 2013/SDI_Togo-2013_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name 
	
	*Clean GPS coordinates 
	rename	gpslong_o gpslong_m
	rename 	gpslat_s gpslong_o
	gen 	gpslat_all = gpslat_o + (gpslat_m/60) // format is decimal degrees
	gen 	gpslong_all = gpslong_o + (gpslong_m/60) // format is decimal degrees
	lab var gpslat_all  "GPS position latitude (full coordinates)"
	lab var gpslong_all "GPS position longitude (full coordinates)"
	drop	gpslat_o gpslat_m gpslong_o gpslong_m

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Togo_2013_deid.dta", replace 

	/**********
	Module 2
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Togo 2013/SDI_Togo-2013_Module2_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_surname1 provider_name1 provider_surname2 provider_name2

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Togo_2013_deid.dta", replace 

	/**********
	Module 3
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Togo 2013/SDI_Togo-2013_Module3_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_name

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Togo_2013_deid.dta", replace 		

/***********************************************************************
Imports the harmonized Uganda (2013) from recieved from the SDI team
************************************************************************/	

	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Uganda 2013/SDI_Uganda-2013_Module1_Harmonized.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	facility_name enum1_visit1_name enum1_visit2_name
	
	*Clean up GPS variables 
	replace 	gpslat_all = subinstr(gpslat_all,".","",.)
	replace 	gpslong_all = subinstr(gpslong_all,".","",.)

	gen 		switch_ind2 = (real(substr(gpslat_all,1,3))>real(substr(gpslong_all,1,3)))
	clonevar	gpslat_correct = gpslat_all 
	clonevar 	gpslon_correct = gpslong_all 
	replace 	gpslat_correct = gpslong_all if switch_ind2==1
	replace 	gpslon_correct = gpslat_all if switch_ind2==1

	gen 		extra_zeros = (real(substr(gpslon_correct,1,3))<29)
	replace 	gpslon_correct = subinstr(gpslon_correct,"00","",1) if extra_zeros==1

	gen lat_deg = real(substr(gpslat_correct,1,2))
	gen lat_min = real(substr(gpslat_correct,3,2))
	gen lat_sec = real(substr(gpslat_correct,5,4))/100

	gen lon_deg = real(substr(gpslon_correct,1,3))
	gen lon_min = real(substr(gpslon_correct,4,2))
	gen lon_sec = real(substr(gpslon_correct,6,4))/100

	gen gps_lat1 = lat_deg + lat_min/60 + lat_sec/3600
	gen gps_lon1 = lon_deg + lon_min/60 + lon_sec/3600
	gen gps_lat2 = real(substr(gpslat_correct,1,2) + "." + substr(gpslat_correct,3,.))
	gen gps_lon2 = real(substr(gpslon_correct,1,3) + "." + substr(gpslon_correct,4,.))

	replace gps_lat1 = . if gps_lat1<-1 | gps_lat1>4
	replace gps_lat2 = . if gps_lat2<-1 | gps_lat2>4
	replace gps_lon1 = . if gps_lon1<29 | gps_lon1>35 
	replace gps_lon2 = . if gps_lon2<29 | gps_lon2>35 

	rename gps_lat1 gps_lat
	rename gps_lon1 gps_lon
	
	*Drop unwanted GPS coordinates 
	drop 	gpslat_all gpslong_all gpslat_correct gpslon_correct
	drop	gps_lat2 gps_lon2 // these are viable coordinates but dropping them for now
	
	*Rename remaining GPS coordinates 
	rename	gps_lat	gpslat_all
	rename 	gps_lon	gpslong_all
	lab var gpslat_all  "GPS position latitude (full coordinates)"
	lab var gpslong_all "GPS position longitude (full coordinates)"
	 
	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Uganda_2013_deid.dta", replace 

	/**********
	Module 2
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Uganda 2013/SDI_Uganda-2013_Module2_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_fullname1 

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Uganda_2013_deid.dta", replace 

	/**********
	Module 3
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Uganda 2013/SDI_Uganda-2013_Module3_Harmonized.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	provider_name

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Uganda_2013_deid.dta", replace 	
		
	
/******************************************************************
Imports the harmonized Malawi (2019) from recieved from the SDI team
*******************************************************************/	

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Malawi 2019/Q2_facility.dta", clear   
	
	*rename key variables 
	rename Fcode facility_id
	
	*Keep only variables wanted
	keep facility_id A210 A211 A212
	
	*Save mod2 variables 
	tempfile mod2_vars
	save	`mod2_vars', replace  

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
			B205 _merge 

	*Rename all GPS coordinates 
	rename 	A109__Longitude gpslong_all
	rename	A109__Latitude  gpslat_all
	lab var gpslat_all  "GPS position latitude (full coordinates)"
	lab var gpslong_all "GPS position longitude (full coordinates)"
	
	*Merge in key variables from mod 2 
	merge m:1 facility_id using `mod2_vars'
	drop if _merge == 2
	drop 	_merge  
	
	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Malawi_2019_deid.dta", replace 
	
	/**********
	Module 1
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Malawi 2019/Q1.dta", clear   

	*Drop all variables tha contain identifiers 
	drop	Fname A102b Zonename C404A1 C404A10 C404A11 C404A12 C404A13	///
			C404A14 C404A15 C404A16 C404A17 C404A2 C404A3 C404A4 C404A5 ///
			C404A6 C404A7 C404A8 C404A9 C404A__0 C404A__1 C404A__10 	///
			C404A__11 C404A__12 C404A__13 C404A__14 C404A__2 C404A__3 	///
			C404A__4 C404A__5 C404A__6 C404A__7 C404A__8 C404A__9
			
	*Rename all GPS coordinates 
	rename 	A109__Longitude gpslong_all
	rename	A109__Latitude  gpslat_all
	lab var gpslat_all  "GPS position latitude (full coordinates)"
	lab var gpslong_all "GPS position longitude (full coordinates)"

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module1_Malawi_2019_deid.dta", replace 

	/**********
	Module 2
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Malawi 2019/Q2_facility.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	Fname A102b names__*

	*Save temp file 
	tempfile 	q2_fac
	sort 		Fcode
	save		`q2_fac', replace  

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Malawi 2019/Q2_caseSimulation1.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	Fname A102b names _merge

	*Save temp file 
	tempfile 	q2_sim
	sort 		Fcode
	save		`q2_sim', replace  
	
	*Merge the two module 2 datasets 
	use	`q2_sim', clear 
	merge m:1 Fcode using `q2_fac'
	drop if _merge == 2
	drop 	_merge 
	
	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module2_Malawi_2019_deid.dta", replace 

	/**********
	Module 3
	***********/

	*Open raw identified dataset provided by the World Bank SDI team
	use		"$EL_dtRaw/Malawi 2019/Q3.dta", clear   
 
	*Drop all variables tha contain identifiers 
	drop	Fname A102b Zonename HF5A006 HF5A101

	*Rename all GPS coordinates 
	rename 	A109__Longitude gpslong_all
	rename	A109__Latitude  gpslat_all
	lab var gpslat_all  "GPS position latitude (full coordinates)"
	lab var gpslong_all "GPS position longitude (full coordinates)"

	*Save de-identified version of the harmonized dataset 
	save	"$EL_dtDeID/Module3_Malawi_2019_deid.dta", replace 
 
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
