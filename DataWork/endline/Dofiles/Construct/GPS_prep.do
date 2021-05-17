* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Format GPS coordinates 						   		   *
*				Facility ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Cleans up the gps coordinates and merges them with 
				  the facility and provider level datasets 
       ** IDS VAR: country year facility_id 
       ** NOTES:
       ** WRITTEN BY:	Ruben Connor & Michael Orevba
       ** Last date modified: Feb 4th 2021
 */
 
/******************************************
		Format GSP coordinates 
*******************************************/

	*Open all harmonized dataset 
	clear all
	use "$EL_dtInt/All_countries_harm.dta", clear 
  
/******************* 
	Kenya 2018 
********************/

preserve 

	*Keep only Kenya 2018
	keep if cy == "KEN_2018"

	*Removing a few nonsensical points 
	replace gpslat_all 	= . if gpslat_all > 6
	replace gpslong_all = . if gpslat_all > 6
	replace gpslong_all = . if gpslong_all < 33
	replace gpslat_all 	= . if gpslong_all < 33
	
	*Order GPS variables 
	order gps_*, after(public)
	
	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_ken_2018
	save		`gps_ken_2018'
	
restore 
 
/******************* 
	Kenya 2012
********************/

preserve 

	*Keep only Kenya 2012
	keep if cy == "KEN_2012"

	*Removing a few nonsensical points (way too far west, unclear where they should be)
	replace gpslong_all = . if gpslong_all < 33
	replace gpslat_all 	= . if gpslong_all == .
 
	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_ken_2012
	save		`gps_ken_2012'
restore 

/*********************
	Nigeria  2013
**********************/

preserve 

	*Keep only Nigeria 2013
	keep if cy == "NGA_2013"

	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_nga_2013
	save		`gps_nga_2013'
	
restore 
 
/*********************
	Uganda  2013
**********************/

preserve 

	*Keep only Uganda 2013
	keep if cy == "UGA_2013"

	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_uga_2013
	save		`gps_uga_2013' 
	
restore 

/*********************
	Togo  2013
**********************/

preserve 

	*Keep only Togo 2013
	keep if cy == "TGO_2013"

	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_tgo_2013
	save		`gps_tgo_2013'

restore 

/*********************
	Tanzania  2014
**********************/

preserve 

	*Keep only Tanzania 2014
	keep if cy == "TZN_2014"
	
	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_tzn_2014
	save		`gps_tzn_2014'

restore 

/*********************
	Mozambique  2014
**********************/

preserve 

	*Create dataframe of current dataset 
	frame copy default Moz_task 

	*Format GPS Coordinates
	*Import csv file containing GPS coordinates provided by the SDI team 
	insheet using "$EL/Documentation/mapping_coords.csv", clear comma names
	
	*Keep only Mozambique coordinates 
	keep if country == "MOZAMBIQUE"
	
	*Rename lat and lon variables 
	rename	gps_lat	gpslat_all
	rename	gps_lon	gpslong_all

	*Order GPS variables 
	order gps*, after(publicprivate)
	
	*Drop unwanted variables 
	drop	admin1 admin1_name ruralurban map_id admin2 admin3	///
			admin2_name admin3_name admin4_name publicprivate cy
			
	*Create and save tempfile 
	sort		country facility_id
	tempfile 	Moz_GPS
	save		`Moz_GPS'
	
	*Switch back to previous saved dataframe
	frame change Moz_task     
	
	*Keep only Mozambique 2014
	keep if cy == "MOZ_2014"
	
	*Merge in GPS coordinates to Mozambique health facilties  
	keep	country year facility_id provider_id
	sort 	country facility_id
	merge	m:1 country facility_id using `Moz_GPS', keep(3) nogen
	
	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_moz_2014
	save		`gps_moz_2014'
	
	*Switch back to default data frame 
	frame change default
	frame drop	Moz_task // data frame not needed anymore 

restore 

/*********************
	Niger  2015
**********************/

preserve 

	*Keep only Niger 2015
	keep if cy == "NER_2015"
	
	*Clean up GPS coordinates 
	replace gpslat_all = gpslat_all / 100000
	replace gpslong_all = gpslong_all / 100000

	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_ner_2015
	save		`gps_ner_2015'

restore 

/***********************
	Madagascar  2016
***********************/

preserve

	*Keep only Madagascar 2016
	keep if cy == "MDG_2016"

	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_mdg_2016
	save		`gps_mdg_2016'

restore 

/***********************
	Tanzania  2016
***********************/

preserve 

	*Keep only Tanzania 2016
	keep if cy == "TZN_2016"

	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_tzn_2016
	save		`gps_tzn_2016'

restore 

/************************
	Sierra Leone  2018
************************/

preserve 

	*Keep only Sierra Leone 2018
	keep if cy == "SLA_2018"

	*Format GPS Coordinates
	replace gpslat_all 	= . if gpslong_all == 0
	replace gpslong_all = . if gpslong_all == 0

	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_sla_2018
	save		`gps_sla_2018'

restore 

/************************
	Guinea Bissau  2018
************************/

preserve 

	*Keep only Guinea Bissau 2018
	keep if cy == "GNB_2018"

	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_gnb_2018
	save		`gps_gnb_2018'

restore


/************************
	Malawi  2019
************************/

preserve 

	*Keep only Malawi 2019
	keep if cy == "MWI_2019"

	*Order GPS variables 
	order gps_*, after(public)

	*Keep key identifiers 
	keep	country year facility_id provider_id gpslat_all gpslong_all
	
	*Create and save tempfile 
	tempfile	gps_mwi_2019
	save		`gps_mwi_2019'
 
restore 
 
/************************************* 
	Bring all the GIS data together 
*************************************/

	*Open Kenya 2018 GIS tempfile 
	use				`gps_ken_2018', clear 
	
	*Append all GIS country tempfiles 
	append using	`gps_ken_2012'
	append using	`gps_nga_2013'
	append using	`gps_uga_2013' 
	append using	`gps_tgo_2013'
	append using	`gps_tzn_2014'
	append using	`gps_ner_2015'
	append using	`gps_mdg_2016'
	append using	`gps_tzn_2016'
	append using	`gps_sla_2018'
	append using	`gps_gnb_2018'
	append using	`gps_moz_2014'
	append using	`gps_mwi_2019'

	*Create variable labels 
	lab var country	"Name of country"
	lab var year	"Year survey was conducted"
	
	*Create and save tempfile with all GIS datapoints 
	sort 		country year facility_id provider_id
	tempfile	GIS_all
	save		`GIS_all'
 
/**********************************************************
Merge GIS information with the all countries harm dataset 
**********************************************************/
	
	*Open all country harmonized dataset 
	use "$EL_dtInt/All_countries_harm.dta", clear 
	
	*Drop uncleaned GPS coordinates
	drop gpslat_all gpslong_all 
	
	*Merge in cleaned GPS coordinates 
	sort 	country year facility_id provider_id
	merge	1:1 country year facility_id provider_id using `GIS_all'
	
	*Create variable label for map id 
	lab var map_id	"Map ID for health facility"
	
	*Save updated all countries harmonized dataset with cleaned GPS coordinates
	save "$EL_dtInt/All_countries_harm.dta", replace  

******************************** End of do-file *********************************************
