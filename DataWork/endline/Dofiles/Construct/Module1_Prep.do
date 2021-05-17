* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Append module 1 dataset of each country		   		   *
*				Facility ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Creates a dataset of all the module 1 section for each 
					country combined 

       ** IDS VAR: country year facility_id 
       ** NOTES:
       ** WRITTEN BY:	Ruben Connor & Michael Orevba
       ** Last date modified: Fed 2nd 2021
 */
 
/******************************************
		Append Module 1 datasets
*******************************************/

	/****************
	 Kenya 2018
	*****************/

	*Open dataset 
	use "$EL_dtDeID/Module1_Kenya_2018_deid.dta", clear

	gen		cy = "KEN_2018", after(year)
	lab var cy "Country + Year Code"
	egen 	map_id = concat(cy facility_id), punct("_")

	// Last fixes
	destring enum1_visit1_code, replace force ignore("Enumerator 1 of team ")
	
	*Check duplicates 
	isid facility_id 
	
	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/Kenya_2018_mod_1.dta", replace 

	/****************
	 Kenya 2012
	*****************/

	*Open dataset 
	use "$EL_dtDeID/Module1_Kenya_2012_deid.dta", clear

	gen 	cy = "KEN_2012", after(year)
	lab var cy "Country + Year Code"

	* keep country cy facility_id gpslong_all gpslat_all rural public admin1 admin2 admin3 admin1_name admin2_name admin3_name
	egen 	map_id = concat(cy facility_id), punct("_")

	// Last fixes
	destring enum2_visit2_code transport_central_tpt, replace force
	
	*Check duplicates 
	isid facility_id
 
	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/Kenya_2012_mod_1.dta", replace

	/****************
	 Nigeria 2013
	*****************/

	*Open dataset 
	use "$EL_dtDeID/Module1_Nigeria_2013_deid.dta", clear

	gen 	cy = "NGA_2013", after(year)
	lab var cy "Country + Year Code"

	* keep country cy facility_id gpslat_all gpslong_all rural public admin1 admin1_name admin2 admin3
	egen 	map_id = concat(cy facility_id), punct("_")
	
	*Check duplicates 
	isid facility_id
 
	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/Nigeria_2013_mod_1.dta", replace

	/****************
	 Uganda 2013
	*****************/

	*Open dataset 
	use "$EL_dtDeID/Module1_Uganda_2013_deid.dta", clear
	
	gen		cy = "UGA_2013", after(year)
	lab var cy "Country + Year Code"
	
	*keep country cy facility_id gpslat_all gpslong_all rural public admin1 admin1_name admin3 admin3_name // No admin2, not clear why
	egen 	map_id = concat(cy facility_id), punct("_")
	
	*Check duplicates 
	isid facility_id
	
	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/Uganda_2013_mod_1.dta", replace

	/****************
	 Togo 2013
	*****************/	

	*Open dataset 
	use "$EL_dtDeID/Module1_Togo_2013_deid.dta", clear
	
	gen 	cy = "TGO_2013", after(year)
	lab var cy "Country + Year Code"

	* keep country cy facility_id gpslat_o gpslat_m gpslong_o gpslong_m rural public admin1 admin1_name admin2 admin2_name
	egen 	map_id = concat(cy facility_id), punct("_")
	
	*Check duplicates 
	isid facility_id
	
	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/Togo_2013_mod_1.dta", replace

	/****************
	 Tanazania 2014
	*****************/	
	
	*Open dataset 
	use "$EL_dtDeID/Module1_Tanzania_2014_deid.dta", clear
	
	gen 	cy = "TZN_2014", after(year)
	lab var cy "Country + Year Code"
	
	*keep country cy facility_id gpslat_o gpslat_m gpslat_s gpslong_o gpslong_m gpslong_s rural public admin1 admin1_name admin2
	egen 	map_id = concat(cy facility_id), punct("_")

	tostring admin5_name, replace
	destring facility_cntryid, replace ignore("D") force
	
	*Check duplicates 
	isid facility_id
	
	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/Tanzania_2014_mod_1.dta", replace

	/****************
	 Mozambique 2014
	*****************/	

	*Open dataset 
	use "$EL_dtDeID/Module1_Mozambique_2014_deid.dta", clear
	
	gen 	cy = "MOZ_2014", after(year)
	lab var cy "Country + Year Code"
	
	*keep country cy facility_id rural public admin1 admin2
	isid facility_id
	egen map_id = concat(cy facility_id), punct("_")
	
	*Check duplicates 
	isid facility_id
	
	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/Mozambique_2014_mod_1.dta", replace

	/****************
	 Niger 2015
	*****************/	

	*Open dataset 
	use "$EL_dtDeID/Module1_Niger_2015_deid.dta", clear

	gen 	cy = "NER_2015", after(year)
	lab var cy "Country + Year Code"
	*keep country cy facility_id rural public admin1 admin1_name admin2 gps_both
	egen 	map_id = concat(cy facility_id), punct("_")
	
	*Check duplicates 
	isid facility_id

	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/Niger_2015_mod_1.dta", replace
	
	/****************
	 Madagascar 2016
	*****************/	
	
	* GPS POINTS MISSING FOR MADAGASCAR 

	*Open dataset 
	use "$EL_dtDeID/Module1_Madagascar_2016_deid.dta", clear
	
	gen 	cy = "MDG_2016", after(year)
	lab var cy "Country + Year Code"
	
	*Check duplicates 
	isid facility_id
	
	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/Madagascar_2016_mod_1.dta", replace

	/****************
	 Tanzania 2016
	*****************/	
	
	*Open dataset 
	use "$EL_dtDeID/Module1_Tanzania_2016_deid.dta", clear

	gen 	cy = "TZN_2016", after(year)
	lab var cy "Country + Year Code"
	
	*keep country cy facility_id rural public admin1 admin1_name admin2 gps*
	egen 	map_id = concat(cy facility_id), punct("_")

	tostring admin5_name, replace
	destring facility_cntryid, replace ignore("D") force
	
	*Check duplicates 
	isid facility_id
	
	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/Tanzania_2016_mod_1.dta", replace

	/*******************
	 Sierra Leone 2018
	********************/	
	
	*Open dataset 
	use "$EL_dtDeID/Module1_SierraLeone_2018_deid.dta", clear

	gen 	cy = "SLA_2018", after(year)
	lab var cy "Country + Year Code"
	
	*keep country cy facility_id rural public admin1 admin1_name admin2 admin2_name admin3_name admin4_name gpslat gpslong
	egen 	map_id = concat(cy facility_id), punct("_")
	
	*Check duplicates 
	isid facility_id
	
	*Save harmonized module 1 dataset 
	save "$EL_dtInt/Module 1/SierraLeone_2018_mod_1.dta", replace
  
	/*******************
	 Guinea Bissau 2018
	********************/	
	
	*Open dataset 
	use "$EL_dtInt/Module 1/GuineaBissau_2018_mod_1.dta", clear

	gen 	cy = "GNB_2018", after(year)
	lab var cy "Country + Year Code"
	
	*keep country cy facility_id rural public admin1 admin1_name admin2 admin2_name admin3_name admin4_name gpslat gpslong
	egen 	map_id = concat(cy facility_id), punct("_")
	
	*Check duplicates 
	isid facility_id
	
	*Save harmonized module 1 dataset 
	tempfile GNB_2018
	save 	`GNB_2018'
	
	/*******************
	 Malawi 2019
	********************/	
	
	*Open dataset 
	use "$EL_dtInt/Module 1/Malawi_2019_mod_1.dta", clear

	gen 	cy = "MWI_2019", after(year)
	lab var cy "Country + Year Code"
	
	*keep country cy facility_id rural public admin1 admin1_name admin2 admin2_name admin3_name admin4_name gpslat gpslong
	egen 	map_id = concat(cy facility_id), punct("_")
	
	*Check duplicates 
	isid facility_id
	
	*Save harmonized module 1 dataset 
	tempfile MWI_2019
	save 	`MWI_2019' 

	/**************************
	 Append all the datasets
	***************************/	
	 
	*Open Nigeria 2013 dataset to start the append process 
	use 		 "$EL_dtInt/Module 1/Nigeria_2013_mod_1.dta", clear  
	append using "$EL_dtInt/Module 1/Kenya_2018_mod_1.dta"
	append using "$EL_dtInt/Module 1/Uganda_2013_mod_1.dta"
	append using "$EL_dtInt/Module 1/Togo_2013_mod_1.dta"
	append using "$EL_dtInt/Module 1/Mozambique_2014_mod_1.dta"
	append using "$EL_dtInt/Module 1/Niger_2015_mod_1.dta"
	append using "$EL_dtInt/Module 1/Madagascar_2016_mod_1.dta"
	append using "$EL_dtInt/Module 1/Tanzania_2016_mod_1.dta"
	append using "$EL_dtInt/Module 1/SierraLeone_2018_mod_1.dta"
	append using "$EL_dtInt/Module 1/Kenya_2012_mod_1.dta"
	append using "$EL_dtInt/Module 1/Tanzania_2014_mod_1.dta" 
	append using "`GNB_2018'", force
	append using "`MWI_2019'", force  
  
	/*******************************
		ASSUMPTIONS FOR MODULE 1 
	********************************/	
  
	*Basic cleaning *
	drop  	num_med num_staff 	// Uganda has this variable for some reason in mod 1 so they are dropped   
	drop if facility_level == 7 // Two mistakes in Kenya 2018
 	
	*Fix bed variable for TANZANIA	
	gen 	bedz 			= beds_inpatient
	replace beds_inpatient 	= beds_total 	if country == "TANZANIA"
	replace beds_total 		= bedz 			if country == "TANZANIA"
	drop 	bedz
 
	/*******************************
		EQUIPMENT AVAILABILITY
	********************************/
	
	*Fridge
	gen 	fridge_a = 0 if has_fridge == 0
	replace fridge_a = 1 if has_fridge == 1 | has_fridge == 2 | has_fridge == 3
	
	gen 	fridge_b = fridge_a
	replace fridge_b = 0 if has_fridge == 1
		
	// In some countries, vaccine_store1 determines if the has_fridge question is asked. 
	// Hence there a high number of places with missing fridge info. We assume they don't have fridges. 
	// In Nigeria, they asked about fridges anyhow and found that 18% of facilities not offering vaccines still had a fridge
		
	*Replace as simple binary rather than categorical
		foreach t in a b {
			foreach var of varlist thermometer_`t' stethoscope_`t' sphgmeter_`t' adultscale_`t' childscale_`t' infantscale_`t' autoclave_`t' steamer_`t' dryheat_`t' nonelectric_`t' fridge_`t' {
				codebook `var'
				replace `var' = 1 if `var' == 2
			}
		}

	*Scale
	gen scale_a		= (adultscale_a == 1 | childscale_a == 1 | infantscale_a == 1)
	gen scale_b 	= (adultscale_b == 1 | childscale_b == 1 | infantscale_b == 1)
	gen sterile_a 	= (autoclave_a == 1 | steamer_a == 1 | dryheat_a == 1 | nonelectric_a == 1)
	gen sterile_b 	= (autoclave_b == 1 | steamer_b == 1 | dryheat_b == 1 | nonelectric_b == 1)
	
	*Equipment avail total
	gen equip_avail1	= (thermometer_a == 1 & stethoscope_a == 1 & sphgmeter_a == 1 & scale_a == 1)
	gen equip_func1 	= (thermometer_b == 1 & stethoscope_b == 1 & sphgmeter_b == 1 & scale_b == 1)

	gen equip_avail2 	= (thermometer_a == 1 & stethoscope_a == 1 & sphgmeter_a == 1 & scale_a == 1 & sterile_a == 1)
	gen equip_func2 	= (thermometer_b == 1 & stethoscope_b == 1 & sphgmeter_b == 1 & scale_b == 1 & sterile_b == 1)

	gen equip_avail3 	= (thermometer_a == 1 & stethoscope_a == 1 & sphgmeter_a == 1 & scale_a == 1 & sterile_a == 1 & fridge_a == 1)
	gen equip_func3 	= (thermometer_b == 1 & stethoscope_b == 1 & sphgmeter_b == 1 & scale_b == 1 & sterile_b == 1 & fridge_b == 1)
	
	gen equip_avail = equip_func1
	
	drop equip_avail1 equip_avail2 equip_avail3 
	
	foreach var of varlist equip_avail thermometer_a stethoscope_a sphgmeter_a scale_a sterile_a fridge_a equip_func* {
		replace `var' = `var'*100
	}

	/*******************************
		INFRASTRUCTURE AVAILABILITY
	********************************/
	
	*Electricity variable - Counting everything other than "none"
	gen 	elec = (power_a != 1)
	replace elec = 0 if power_a == .
	tab 	power_a elec
	
	*Water variable - No credit for unprotected sources, cart with small tank, surface water or buy from vendors
	gen 	water = (water_a == 2 | water_a == 3 | water_a == 4 | water_a == 5 | water_a == 7 | water_a == 9 |	///
					 water_a == 10 | water_a == 12) 
	tab 	water_a water
	
	*Sanitation variable 
	gen 	toilet = (toilet_opt_a == 4 | toilet_opt_a == 6 | toilet_opt_a == 7 | toilet_opt_a == 8 |	///
					  toilet_opt_a == 9 | toilet_opt_a == 10)
	tab 	toilet_opt_a toilet
	
	*Infrastructure score:
	gen infra_avail = toilet == 1 & water == 1 & elec == 1
	
	egen totes = rowtotal(elec water toilet)
	gen two_of_three = (totes == 2)
	gen one_of_three = (totes == 1)
	gen none = (totes == 0)
	drop totes

	foreach var of varlist infra_avail elec water toilet two_of_three one_of_three none {
		replace `var' = `var'*100
	}

	/*******************************
		DRUG AVAILABILITY
	********************************/

	*Mother drug availability
	*Per the Answers document: 
	*Oxytocin (injectable), misoprostol (cap/tab), sodium chloride (saline solution) (injectable solution), azithromycin (cap/tab or oral liquid), calcium gluconate (injectable), cefixime (cap/tab), magnesium sulfate (injectable), benzathine benzylpenicillin powder (for injection), ampicillin powder (for injection), betamethasone or dexamethasone (injectable), gentamicin (injectable) nifedipine (cap/tab), metronidazole (injectable), medroxyprogesterone acetate (Depo-Provera) (injectable), iron supplements (cap/tab) and folic acid supplements (cap/tab).
	
	*Iron and folic acid asked differently in a few countries
	gen 	ironandfol = (ironfolic_a == 1)
	replace ironandfol = 1 if irona_a == 1 & folic_a == 1
	replace ironandfol = . if ironfolic_a == . & irona_a == . & folic_a == . 

	*Paracetamol
	gen 	paracetamol = (paracetamol3_a == 1 | paracetamol1_a == 1 | paracetamol3_b == 1 | paracetamol3_c == 1)	
	replace paracetamol = . if paracetamol3_a == . & paracetamol1_a == . & paracetamol3_b == . & paracetamol3_c == .	

	*ACTs
	gen 	act = (act_a == 1 | dihydroartemisinine_a == 1) 
	replace act = . if act_a == . & dihydroartemisinine_a == .

	*Amoxicillin
	gen 	amox = (amoxicillin4_a == 1 | amoxicillin3_a == 1 | amoxicillin2_a == 1 | amoxicillin1_a == 1)
	replace amox = . if amoxicillin4_a == . & amoxicillin3_a == . & amoxicillin2_a == . & amoxicillin1_a == .
		
	*Ceftriaxone
	gen 	ceftriaxone = (ceftriaxone_a == 1 | ceftriaxone2_a == 1)
	replace ceftriaxone = . if ceftriaxone_a == . & ceftriaxone2_a == .
		
	*Diazepam	
	gen 	diazepam = (diazepam1a_a == 1 | diazepam1b_a == 1 | diazepam3_a == 1)
	replace diazepam = . if diazepam1a_a == . & diazepam1b_a == . & diazepam3_a == .
		
	*Cotrimoxazole 
	gen 	cotrimoxazole = (cotrimoxazole1_a == 1 | cotrimoxazole2_a == 1 | cotrimoxazole3_a == 1)
	replace cotrimoxazole = . if cotrimoxazole1_a == . & cotrimoxazole2_a == . & cotrimoxazole3_a == .
		
	*Uterotonics
	gen 	other_utero = (misoprostol_a == 1 | ergometrine_a == 1)
	replace other_utero = . if misoprostol_a == . & ergometrine_a == .
	
	gen 	utero = (oxytocin_a == 1 | other_utero == 1)
	replace utero = . if oxytocin_a == . & other_utero == .
	
	*TB drugs - giving the benefit of the doubt here and assuming the presence of one means combination therapy is likely available
	*They are very frequently available together. 
	gen 	tb_combo = (rifampicin_a == 1 | pyrazinam_a == 1 | ethambutol_a == 1 | isoniazid_a == 1)
	replace tb_combo = . if rifampicin_a == . & pyrazinam_a == . & ethambutol_a == . & isoniazid_a == .
	
	*Small fix for Kenya. Skip pattern means that mothers drugs were not asked about where they weren't provided. 
	foreach var of varlist 	oxytocin_a misoprostol_a nacl_a azithromycin_a	///
							calgluc_a cefixime_a magsulf_a benzathine_a 	///
							ampicillin_a methasone_a gentamycin_a 			///
							nifedipine2_a metronidazole_a depo_a {
			di in red "`var'"
			tab country if `var' == .
			replace `var' = 5 if `var' == . & country == "KENYA" // Skip patterns mean var is frequently missing in Kenya. Assume never available. 
		}
 
	*Create variable for 14 minimum essential
	foreach var of varlist 	amitriptyline_a amox atenolol_a captopril_a ceftriaxone ciproflox_a	///
							diazepam diclofenac_a glibenclam_a omeprazole_a paracetamol 		///
							salbutamol_a simvastatin_a cotrimoxazole {
			replace `var' = 0 if `var' != 1 & `var' != .
			replace `var' = 99 if `var' == .
		}		
	
	egen count14 		= anycount(amitriptyline_a amox atenolol_a captopril_a	///
								  ceftriaxone ciproflox_a diazepam diclofenac_a ///
								  glibenclam_a omeprazole_a paracetamol 		///
								  salbutamol_a simvastatin_a cotrimoxazole), val(1, 99)
								  
	gen med_avail 		= count14/14
	replace med_avail 	= . if country == "KENYA" | country == "NIGERIA" | country == "UGANDA"
		
	*Label variables
	label variable ironandfol "Medicines - Iron and folic acid availability (constructed variable)"
	label variable act "Medicines - ACT availability (constructed variable)"
	label variable amox "Medicines - Amoxicillin available (constructed variable)"
	label variable ceftriaxone "Medicines - Ceftriaxone available (constructed variable)"
	label variable diazepam "Medicines - Diazepam available (constructed variable)"
	label variable cotrimoxazole "Medicines - Cotrimoxazole available (constructed variable)"
	label variable other_utero "Medicines - Uterotonic available - not oxytocin (constructed variable)"
	label variable utero "Medicines - Oxytocin or other uterotonic available (constructed variable)"
	label variable tb_combo "Medicines - Any drugs for TB combo therapy available (constructed variable)"

	label variable count14 "Count of 14 SARA essential medicines available"
	label variable med_avail "Medical availability - of 14 SARA essential medicines available"
		
	*Create mother variable
	egen 	mother_drugs = anycount(oxytocin_a misoprostol_a nacl_a azithromycin_a	///
									calgluc_a cefixime_a magsulf_a benzathine_a 	///
									ampicillin_a methasone_a gentamycin_a 			///
									nifedipine2_a metronidazole_a depo_a ironandfol), val(1)
	gen 	mother_avail = mother_drugs/15
	replace mother_avail = mother_avail*15/14 if country == "NIGERIA" // cefixime_a missing for Nigeria
	replace mother_avail = mother_avail*15/14 if country == "KENYA" // depo_a missing for Kenya
	replace mother_avail = mother_avail*100

	*Child drug availability
	*For children: Amoxicillin (syrup/suspension), oral rehydration salts (ORS sachets), zinc (tablets), ceftriaxone (powder for injection), artemisinin combination therapy (ACT), artesunate (rectal or injectable), benzylpenicillin (powder for injection), vitamin A (capsules)
	*We take out of analysis of the child tracer medicines two medicines (Gentamicin and ampicillin powder) that are included in the mother and in the child tracer medicine list to avoid double counting.  		
	
	*Create child variable
	egen 	child_drugs = anycount(amoxicillin3_a ors_a zinctabs_a ceftriaxone2_a	///
								   act_a artesunate_a benzylpenicillin_a vitamina_a), val(1)
	gen 	child_avail = child_drugs/7 
	replace child_avail = child_drugs/8 if country == "MOZAMBIQUE" | country == "UGANDA" // Countries with ceftriaxone2_a. Nigeria also has it but they are missing artesunate
	replace child_avail = child_drugs/4 if country == "KENYA"
	replace child_avail = child_avail*100

	foreach var of varlist amoxicillin3_a ors_a zinctabs_a ceftriaxone2_a act_a artesunate_a benzylpenicillin_a vitamina_a {
		di in red "`var'"
		tab country if `var' == . 
		}
		
	*Stock outs
	egen	mother_stock_out	= anycount(oxytocin_a misoprostol_a nacl_a azithromycin_a	///
										   calgluc_a cefixime_a magsulf_a benzathine_a 		///
										   ampicillin_a methasone_a gentamycin_a 			///
										   nifedipine2_a metronidazole_a depo_a ironandfol), val(5)
	replace mother_stock_out 	= . if country == "KENYA"		
	egen 	child_stock_out 	= anycount(amoxicillin3_a ors_a zinctabs_a ceftriaxone2_a 	///
										   act_a artesunate_a benzylpenicillin_a vitamina_a), val(5)
	gen 	stock_out 			= mother_stock_out + child_stock_out
	
	*Minimum essential 
	gen 	min_med = (amox == 1 & ors_a == 1 & act_a == 1)
	replace min_med = 100 if min_med == 1
	
	/*******************************
			WEIGHTS
	********************************/
	
	*Create normalized weights 
	drop 	weight // Leftover var in Kenya
	bysort 	country: egen avg_weight = mean(ipw)
	gen 	weight = ipw/avg_weight
	
	*Do not want to drop observations because of missing weight. Assume they are 1 if missing. 
	*This is a big assumption for Mozambique where we were not able to locate the weights. 
	*Also missing for about 5% of the Nigeria sample
	replace weight = 1 if weight == .	
	
	/*******************************
			COUNTRY GDP
	********************************/
 	
	*GDP variable that captures ranking of countries (low to high) by GDP
	*GDP values were taken from: https://data.worldbank.org/indicator/NY.GDP.PCAP.PP.CD
	
	gen 	gdp = .
	replace gdp = 965 	if country == "NIGER" 
	replace gdp = 1106 	if country == "MALAWI" 
	replace gdp = 1381 	if country == "MOZAMBIQUE"
	replace gdp = 1431 	if country == "TOGO"
	replace gdp = 1602 	if country == "SIERRALEONE"
	replace gdp = 1757 	if country == "UGANDA"
	replace gdp = 1759 	if country == "MADAGASCAR"
	replace gdp = 1997 	if country == "GUINEABISSAU"
	replace gdp = 2926 	if country == "TANZANIA"
	replace gdp = 3468 	if country == "KENYA"
	replace gdp = 5698 	if country == "NIGERIA"

	// 2019 values
	* gen gdp = .
	* replace gdp = 1270 if country == "NIGER" 
	* replace gdp = 1334 if country == "MOZAMBIQUE"
	* replace gdp = 1662 if country == "TOGO"
	* replace gdp = 1790 if country == "SIERRALEONE"
	* replace gdp = 2271 if country == "UGANDA"
	* replace gdp = 1714 if country == "MADAGASCAR"
	* replace gdp = 2771 if country == "TANZANIA"
	* replace gdp = 4509 if country == "KENYA"
	* replace gdp = 5348 if country == "NIGERIA"

	gen 	gdp_rank = 1 if country == "NIGER"
	replace gdp_rank = 2 if country == "MALAWI"
	replace gdp_rank = 3 if country == "MOZAMBIQUE"
	replace gdp_rank = 4 if country == "TOGO"
	replace gdp_rank = 5 if country == "SIERRALEONE"
	replace gdp_rank = 6 if country == "UGANDA"
	replace gdp_rank = 7 if country == "MADAGASCAR"
	replace gdp_rank = 8 if country == "GUINEABISSAU"
	replace gdp_rank = 9 if country == "TANZANIA"
	replace gdp_rank = 10 if country == "KENYA"
	replace gdp_rank = 11 if country == "NIGERIA"

	label values gdp_rank country
	labmask gdp_rank, values(country)
	
	*Save appended module 1 dataset 
	save "$EL_dtInt/Module 1/All_countries_mod_1.dta", replace

************************* End of do-file *************************************
