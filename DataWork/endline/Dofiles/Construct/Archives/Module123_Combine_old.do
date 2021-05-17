/*************** 
** COMBINE MODULES 1, 2 AND 3 
**************/

** SET UP **/

	clear all
	macro drop _all
	set more off
	cap log close
	global user WB553288
			
	cd "C:\Users\\$user\\WBG\Andres Yi Chang - SDI\Analytical Report\Clean\Health\Full Datasets"
	
	global graphs "C:\Users\\$user\\WBG\Andres Yi Chang - SDI\Analytical Report\GIS Analysis\Figures"
	
	
/***************************
** CREATE COMBINED DATASET **
**************************/

	// Mod3
		use "Module3_Prepped.dta", clear

		// Create facility level averages of variables
		collapse diag_accuracy diag1 diag2 diag3 diag4 diag5 diag6 diag7 treat_accuracy treat1 treat2 treat3 treat4 treat5 treat6 treat7 pph_actions pph_perc asphyxia_actions asphyxia_perc score_proc hisex*_st irt_score bad_antibio, by(country facility_id)

		lab var diag_accuracy "Facility average - Diagnostic accuracy"
		lab var diag1 "Facility average - Correct treatment for diarrhea and dehydration proposed"
		lab var diag2 "Facility average - Correct treatment for pneumonia and fever proposed"
		lab var diag3 "Facility average - Correct treatment for diabetes mellitus proposed"
		lab var diag4 "Facility average - Correct treatment for tuberculosis proposed"
		lab var diag5 "Facility average - Correct treatment for malaria and anemia proposed"
		lab var diag6 "Facility average - Correct treatment for postpartum hemorrhage proposed"
		lab var diag7 "Facility average - Correct treatment for neonatal asphyxia proposed"

		lab var treat_accuracy "Facility average - Treatment accuracy"
		lab var treat1 "Facility average - Correct treatment for diarrhea and dehydration proposed"
		lab var treat2 "Facility average - Correct treatment for pneumonia and fever proposed"
		lab var treat3 "Facility average - Correct treatment for diabetes mellitus proposed"
		lab var treat4 "Facility average - Correct treatment for tuberculosis proposed"
		lab var treat5 "Facility average - Correct treatment for malaria and anemia proposed"
		lab var pph_actions "Facility average - Number of correct actions for postpartum hemorrhage proposed"
		lab var pph_actions "Facility average - Percent of correct actions for postpartum hemorrhage proposed"		
		lab var treat6 "Facility average - Correct treatment for postpartum hemorrhage proposed"
		lab var asphyxia_actions "Facility average - Number of correct actions for neonatal asphyxia proposed"
		lab var asphyxia_actions "Facility average - Percent of correct actions for neonatal asphyxia proposed"
		lab var treat7 "Facility average - Correct treatment for neonatal asphyxia proposed"

		lab var hisex1_st "Facility - Aggregate score of history taking and examination for acute diarrhea case"
		lab var hisex2_st "Facility - Aggregate score of history taking and examination for pneumonia case"
		lab var hisex3_st "Facility - Aggregate score of history taking and examination for diabetes mellitus case"
		lab var hisex4_st "Facility - Aggregate score of history taking and examination for pulmonary tuberculosis case"
		lab var hisex5_st "Facility - Aggregate score of history taking and examination for malaria"
		lab var hisex6_st "Facility - Aggregate score of history taking and examination for post-partum hemorrhage case"
		lab var hisex7_st "Facility - Aggregate score of history taking and examination for birth asphyxia case"

		lab var score_proc "Facility average - Adherence to clinical protocol"
		lab var bad_antibio "Facility average - Inappropriate use of antibiotics"
		
		rename * fac_*
		rename fac_country country 
		rename fac_facility_id facility_id
		
		tempfile mod3
		save `mod3', replace
	
	// Mod2
		use "Module2_Prepped.dta", clear
		drop if facility_id == "300" & country == "TANZANIA" & num_med == .
		drop if facility_id == "201" & country == "MADAGASCAR" 
		// Implausibly high inpatient numbers
		replace num_med = num_staff - num_nonmed if country == "TOGO" 
		// Medical staff unavailable for Togo but easy to calculate
		replace num_staff = num_med + num_nonmed if country == "NIGERIA" 
		// Total staff unavailable but can calculate
		bysort country facility_id:	egen mean_abs = mean(absent)
		bysort country facility_id:	egen mean_unauth_abs = mean(absent_unauth)
		
		bysort country: tab provider_cadre1 is_out, row
		tab provider_cadre1 is_out, row
		// Large percentage of nurses report NOT doing outpatient consultations
		
		gen doctor = (provider_cadre1 == 1) 
		gen co = (provider_cadre1 == 2) 
		gen nurse = (provider_cadre1 == 3)	
		gen other = (provider_cadre1 == 4)
		gen x = 1
		* gen out_pres = (is_out == 1 & provider_present1 == 1)

		* replace provider_educ1 = provider_educ2 if 
		gen primary = (provider_educ1 == 1)
		gen secondary = (provider_educ1 == 2)
		gen postsecondary = (provider_educ1 == 3)
		
		bysort country facility_id: egen mod2 = total(x)
	
		collapse (mean) num_staff num_med mean_abs mean_unauth_abs mod2 perc_doc = doctor perc_nurse = nurse perc_co = co perc_other = other perc_primary = primary perc_secondary = secondary perc_postsecondary = postsecondary ///
		(sum) fac_doc = doctor fac_co = co fac_nurse = nurse fac_other = other fac_is_out = is_outpatient fac_primary = primary fac_secondary = secondary fac_postsecond = postsecondary, by(facility_id country)
		tempfile mod2
		save `mod2', replace
	
		// Quite a few facilities (38 in Moz, 90 in Nigeria, 43 in Tanzania & more) maxed out at 50 on roster
		tab country if mod2 == 50 & num_staff > 50
		// Weird number of places with MANY more med staff than report seeing outpatients. 
		// Assume this is just the number of staff there that day. But still, I think the ratio might be meaningful. 
		* scatter num_med is_out is_out if is_out < 50
		* scatter num_med is_out is_out if is_out < 50 & num_med < 100 & country != "NIGERIA", jitter(3)
		
		* gen nm_ratio = num_med / is_out
		// Two main explanations for this difference. 1) Staff not present currently and 2) Medically categorized staff that do not see outpatients
	
	// Merge all three modules 
		use "Module1_Prepped.dta", clear
		merge 1:1 facility_id country using `mod2', keep(3) nogen
		merge 1:1 facility_id country using `mod3', keep(3) nogen
		
		replace num_med = num_med2 if country == "UGANDA"
		replace num_staff = num_med2 + num_nonmed if country == "UGANDA" 
		gen num_med_pres = num_med*(1-mean_abs) 
		gen fac_is_out_pres = fac_is_out*(1-mean_abs) 			
		replace num_outpatient = . if num_outpatient == 0 & num_med >= 5 // Zero outpatients with more than 5 medical staff? Seems unlikely
		replace num_inpatient = . if num_inpatient < 0
		replace num_inpatient_beds = . if num_inpatient_beds < 0
		replace num_inpatient = 0 if num_inpatient == .
		replace num_inpatient_beds = 0 if num_inpatient_beds == .
		replace num_births = 0 if num_births == .
		foreach var of varlist num_out num_inpatient num_inpatient_beds beds_inpatient num_births {
			replace `var' = . if  `var' == 999
			replace `var' = . if  `var' == 9999
		}
		replace num_births = 0 if num_births == . & country == "UGANDA"

		gen med_frac = num_med / num_staff
		drop num_med2
		
	// Estimate occupancy
		destring beds_observation, replace
		gen beds_inp2 = beds_total - beds_maternity - beds_observation
		replace beds_inp2 = 0 if beds_inp2 < 0
		tab country if beds_inpatient == . & beds_inp2 >= 0 & beds_inp2 != .
		replace beds_inpatient = beds_inp2 if beds_inpatient == . & beds_inp2 >= 0 & beds_inp2 != . // Inpatient beds left blank for a few places in Kenya
		drop beds_inp2

		
		gen avg_stay = (num_inpatient_beds/num_inpatient)
		summ avg_stay
		replace num_inpatient = num_inpatient_beds / `r(mean)' if num_inpatient == 0 & num_inpatient_bed > 0 & num_inpatient_bed != . // Mostly a problem in Uganda
		replace num_inpatient_beds = num_inpatient*`r(mean)' if num_inpatient_bed == 0 & num_inpatient > 0 & num_inpatient != . // Mostly a problem in Nigeria
		drop avg_stay
		gen avg_stay = (num_inpatient_beds/num_inpatient)
		replace avg_stay = . if avg_stay > 20
		
		gen occup = (num_inpatient_beds / (beds_inpatient*90))
		replace occup = . if occup > 2
		replace occup = 1 if occup > 1 & occup != .
		replace occup = . if occup == 0
	
	// Caseload variables
		gen caseload = num_outpatient / (daysperwk*fac_is_out_pres*12) 
		replace caseload = . if caseload > 200 // Unrealistically high	
		gen total = 1 if caseload != .
		
		// Outpatients and inpatients per provider
		gen caseload2 = (num_outpatient + num_inpatient_beds*5 + num_births*5) / (daysperwk*num_med_pres*12)
		replace caseload2 = . if caseload2 > 200 // Unrealistically high
		
		// Different levels of inpatient
		* gen caseload_inp2 = (num_outpatient + num_inpatient_beds*2 + num_births*2) / (daysperwk*is_out*12)
		* replace caseload_inp2 = . if caseload3 > 100 // Unrealistically high
		
		* gen caseload_inp125 = (num_outpatient + num_inpatient_beds*12.5 + num_births*12.5) / (daysperwk*is_out*12)
		* replace caseload_inp125 = . if caseload3 > 100 // Unrealistically high		
		
		// Caseload categories
		gen case1 = (caseload < 2)
		gen case2 = (caseload >= 2 & caseload < 5)
		gen case3 = (caseload >= 5 & caseload < 10)
		gen case4 = (caseload >= 10 & caseload < 20)
		gen case5 = (caseload >= 20 & caseload != .)
		
		// Visits per day
		gen visits_day = (num_outpatient) / (daysperwk*12)
		replace visits_day = . if caseload > 200 // Unrealistically high
		
		gen visits_day2 = (num_outpatient + num_inpatient_beds*5 + num_births*5) / (daysperwk*12)
		replace visits_day2 = . if caseload > 200 // Unrealistically high
	
	// Labels
		label variable caseload "Facility - Caseload" 
		label variable med_avail "Facility - Medical availability"  
		label variable infra_avail "Facility - Infrastructure availability" 
		label variable equip_avail "Facility - Equipment availability" 
		label variable fac_treat_accuracy "Facility - Treatment accuracy" 
		label variable fac_diag_accuracy "Facility - Diagnostic accuracy" 
		label variable mean_abs "Facility - Absenteeism" 
		label variable perc_second "Facility - Providers with secondary education (%)" 
		label variable perc_primary "Facility - Providers with primary education (%)" 
		label variable fac_doc "Facility - Number of doctors" 
		label variable fac_nurse "Facility - Number of nurses" 
		label variable fac_co "Facility - Number of clinical officers" 
		label variable fac_other "Facility - Number of other staff" 
		label variable equip_func1 "Basic 4 pieces of equipment functional"
		label variable equip_func2 "Basic 4 pieces of equipment functional + sterilization"
		label variable equip_func3 "Basic 4 pieces of equipment functional + sterilization + fridge"
		label variable elec "Infrastructure - Electricity available"
		label variable water "Infrastructure - Water available"
		label variable toilet "Infrastructure - Toilet available"
		label variable two_of_three "Infrastructure - 2 of 3 infra items available"
		label variable one_of_three "Infrastructure - 1 of 3 infra items available"
		label variable none "Infrastructure - 0 of 3 infra items available"
		label variable num_med "Number of medical staff"
		label variable num_med_pres "Number of medical staff (adjusted for absence)"
		label variable fac_is_out "Facility - Number of staff who regularly do outpatient consultations"
		label variable fac_is_out_pres "Facility - Number of staff who regularly do outpatient consultations (adjusted for absence)"
		label variable med_frac "Fraction of staff who are medical"
		label variable avg_stay "Average length of inpatient stay (visits / beds)"
		label variable occup "Occupancy rate (inpatient bed days / theoretical max)"
		label variable caseload2 "Facility - Caseload (with inpatients)"
		label variable visits_day "Outpatient visits per day"
		label variable visits_day2 "Visits per day (includes inpatients and births at 5x)"
	
	
	
	// Last fixes
		encode country, gen(country_num)
		drop if rural == . | facility_level == . | facility_level == .c

		// Create facility + rural combo				
		gen fac_type = 1 if rural == 1 & facility_level == 1
		replace fac_type = 2 if rural == 1 & facility_level == 2
		replace fac_type = 3 if rural == 1 & facility_level == 3
		replace fac_type = 4 if rural == 2 & facility_level == 1
		replace fac_type = 5 if rural == 2 & facility_level == 2
		replace fac_type = 6 if rural == 2 & facility_level == 3
		label define fac_typez 1 "Rural Hospital" 2 "Rural Clinic" 3 "Rural Health Post" 4 "Urban Hospital" 5 "Urban Clinic" 6 "Urban Health Post"
		label values fac_type fac_typez		
		
		rename fac_score_proc fac_know_how
		
		gen public = publicpriv
		replace public = 0 if publicpriv == 2 | publicpriv == 3 | publicpriv == 4 | publicpriv == 5
		label define pubz 0 "Private/NGO" 1 "Public" 
		label values public pubz

		gen rural = ruralurban
		replace rural = 0 if ruralurban == 2
		label define rurz 0 "Urban" 1 "Rural" 
		label values rural rurz
		drop ruralurban
		
		label variable country_num "Country (encoded)"
		label variable fac_type "Facility type"
		label variable public "Public/private"
		label variable rural "Rural/urban"
	
	// Save
		save "Module123_Prepped.dta", replace
		
		
		
		
		
**** 
** BRING IT ALL TOGETHER 
***


// settings
	clear all
	set more off
	set maxvar 32000
	cap restore, not
	
	if c(username) == "wb553288" { 
		global user wb553288
		global datdir "C:\Users\\$user\WBG\Andres Yi Chang - SDI\Analytical Report\Clean\Health\Full Datasets\"
		global graphs "C:\Users\\$user\WBG\Andres Yi Chang - SDI\Analytical Report\Figures\Health"
		global gisdat "C:\Users\\$user\WBG\Andres Yi Chang - SDI\Analytical Report\GIS Analysis\Data\GIS_Prepped.dta" 
	}
	else if c(username) == "wb528641" { 
		global user wb528641
		global datdir "C:\Users\\$user\WBG\Andres Yi Chang - SDI\Analytical Report\Clean\Health\Full Datasets\"
		global graphs "C:\Users\\$user\WBG\Andres Yi Chang - SDI\Analytical Report\Figures\Health"
		global gisdat "C:\Users\\$user\WBG\Andres Yi Chang - SDI\Analytical Report\GIS Analysis\Data\GIS_Prepped.dta" 

	}
	else if c(username) == "wb486079" { 
		global user wb486079
		global datdir "C:\Users\\$user\OneDrive - WBG\SDI\Analytical Report\Clean\Health\Full Datasets\"
		global graphs "C:\Users\\$user\OneDrive - WBG\SDI\Analytical Report\Figures\Health"
		global gisdat "C:\Users\\$user\OneDrive - WBG\SDI\Analytical Report\GIS Analysis\Data\GIS_Prepped.dta" 

	}
		
// data directories
	global facdat "$datdir/Module123_Prepped.dta"
	global mod1 "$datdir/Module1_Prepped.dta"
	global mod2 "$datdir/Module2_Prepped.dta"
	global mod3 "$datdir/Module3_Prepped.dta"
	global spenddat "C:\Users\\$user\WBG\Andres Yi Chang - SDI\Analytical Report\Clean\dom_gov_health_expend.dta"
	global makegraphs 0
	
	
/******************************************************************************/
// 					BRING IN GIS DATA
/******************************************************************************/
// just keep the GPS variables to merge in with SDI data below 
	use "$gisdat", clear
	keep year cy facility_id admin1 admin1_name gps_lat gps_lon admin2 admin3 mn_aggdp2010 -travel_cat
	tempfile gpsdat
	save `gpsdat', replace
	
	
/******************************************************************************/
// 					BRING IN HEALTH EXPENDITURE DATA
/******************************************************************************/
// source = WHO health expenditure database, year 2016
// rename and clarify
	use "$spenddat", clear
	
	gen country = "KENYA" if wbcode == "KEN"
	replace country = "MADAGASCAR" if wbcode == "MDG"
	replace country = "MOZAMBIQUE" if wbcode == "MOZ"
	replace country = "NIGER" if wbcode == "NER"
	replace country = "NIGERIA" if wbcode == "NGA"
	replace country = "SIERRALEONE" if wbcode == "SLE"
	replace country = "TOGO" if wbcode == "TGO"
	replace country = "UGANDA" if wbcode == "UGA"
	replace country = "TANZANIA" if wbcode == "TZA"
	
	tempfile money
	save `money', replace
	
	
/******************************************************************************/
// 					BRING IN FACILITY DATA
/******************************************************************************/
	use "$facdat", clear
	
	destring facility_id, replace
	
// merge on GIS data
	merge 1:1 cy facility_id using `gpsdat'
// 1230 obs reflects hte 5 countries without GPS data; the 6580 merged reflect the 6 countries with GPS data (KEN, MOZ, NER, NGA, SLE, TGO)
	drop _m
	
// merge on health spending data
	merge m:1 country using `money'
	drop _m
	

// add a variable from WHO GHO on Medical doctors (per 10 000 population)
// Data source: WHO Global Health Observatory data repository http://apps.who.int/gho/data/node.main.HWFGRP_0020?lang=en
	gen drs_per_10k = .
	replace drs_per_10k = 1.988 if country == "KENYA"
	replace drs_per_10k = 1.812 if country == "MADAGASCAR"
	replace drs_per_10k = 0.735 if country == "MOZAMBIQUE"
	replace drs_per_10k = 0.5 if country == "NIGER"
	replace drs_per_10k = 3.827 if country == "NIGERIA"
	replace drs_per_10k = 0.25 if country == "SIERRALEONE"
	replace drs_per_10k = 0.487 if country == "TOGO"
	replace drs_per_10k = 0.908 if country == "UGANDA"
	replace drs_per_10k = 0.399 if country == "TANZANIA"
	
	
// this file also contains unweighted averages of provider knowledge, absenteeism, etc. by facility 

// save a facility-level file
	tempfile facildat
	save `facildat', replace
	

	
/******************************************************************************/
//				BRING IN MODULE 2 DATA TO GET PROVIDER DEMOGRAPHICS
/******************************************************************************/
	use "$mod2", clear
// make a variable for whether absenteeism was assessed in this individual
	gen did_abs = 1 if  provider_present2 != .
	
// merge on module 3
	merge 1:1 cy unique_id using "$mod3"
// 7 observations don't merge from module 3
	
// don't keep ones that didn't merge from module 3
	drop if _m == 2
	
// make an indicator for which people were measured for absenteeism
	gen did_module2 = 1
	
// make an indicator for which people did vignettes 
	gen did_vignette = 1 if _m == 3
	
	drop _m
	
	destring facility_id, replace
	
	tempfile indiv
	save `indiv', replace 
	

/******************************************************************************/
//				MERGE FACILITY-LEVEL AND INDIVIDUAL-LEVEL (PROVIDER) DATA 
/******************************************************************************/
// bring facility-level data back in 
	use `facildat', clear
	
// merge on indiv-level data (module 2 + 3)
	merge 1:m cy facility_id using `indiv'
// 2381 (of 66151) didn't merge - these are module 2 that didn't have a correct facility ID to link to facility data 
	drop if _m == 2
	drop _m
	
// make an indicator variable for just 1 facility observation
	bysort cy facility_id: gen facility_obs = _n
	replace facility_obs = . if facility_obs > 1
	
	
// make a variable that captures ranking of countries (low to high) by GDP
/*
	gen gdp_rank = 1 if country == "NIGER"
	replace gdp_rank = 2 if country == "SIERRALEONE"
	replace gdp_rank = 3 if country == "MADAGASCAR"
	replace gdp_rank = 4 if country == "MOZAMBIQUE"
	replace gdp_rank = 5 if country == "TOGO"
	replace gdp_rank = 6 if country == "UGANDA"
	replace gdp_rank = 7 if country == "TANZANIA"
	replace gdp_rank = 8 if country == "KENYA"
	replace gdp_rank = 9 if country == "NIGERIA"
	
	label values gdp_rank country

	labmask gdp_rank, values(country)
	*/
	
// make some helpful variables for use later
	gen log_popdesn2010 = log(mn10kpopden2010)  // logged population density
	gen log_ntl = log(mn_ntlrad2010)  // logged night lights
	
// make a country-facility code so that each facility is 
	gen ctry_fac = (cy) + string(facility_id)
	replace med_avail = med_avail*100
	replace bad_antibio = bad_antibio*100
	replace provider_cadre1 = 1 if provider_cadre1 == 2 
	
	replace absent = absent*100
	drop log_popdesn
	gen log_lights = ln(mn_ntlrad2010+1)
	gen log_travel = log(travel+1)
	gen log_popdens = log(mn10kpopden2010+1)
	label variable log_lights "Log of night-time lights (NTL)"
	label variable log_popdens "Log of pop. density"
	label variable log_travel "Log of travel time to facility"
	
// Sierra Leone	
	gen poverty_sl = .
	replace poverty_sl = 64.9 if admin2_name == "Bo" & country == "SIERRALEONE"
	replace poverty_sl = 65.9 if admin2_name == "Bombali" & country == "SIERRALEONE"
	replace poverty_sl = 82.5 if admin2_name == "Bonthe" & country == "SIERRALEONE"
	replace poverty_sl = 77.6 if admin2_name == "Kailahun" & country == "SIERRALEONE"
	replace poverty_sl = 77.3 if admin2_name == "Kambia" & country == "SIERRALEONE"
	replace poverty_sl = 62.4 if admin2_name == "Kenema" & country == "SIERRALEONE"
	replace poverty_sl = 86.5 if admin2_name == "Koinadugu" & country == "SIERRALEONE"
	replace poverty_sl = 65.9 if admin2_name == "Kono" & country == "SIERRALEONE"
	replace poverty_sl = 83.7 if admin2_name == "Moyamba" & country == "SIERRALEONE"
	replace poverty_sl = 70.9 if admin2_name == "Port Loko" & country == "SIERRALEONE"
	replace poverty_sl = 87.2 if admin2_name == "Pujehun" & country == "SIERRALEONE"
	replace poverty_sl = 85.4 if admin2_name == "Tonkolili" & country == "SIERRALEONE"
	replace poverty_sl = 53.0 if admin2_name == "Western Rural" & country == "SIERRALEONE"
	replace poverty_sl = 28.5 if admin2_name == "Western Urban" & country == "SIERRALEONE"

	save "$datdir/Module123_Indiv.dta", replace
	

			
		
		
		