* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Regression outputs									   *
*				Provider ID											   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create figures and graphs on caseload 

       ** IDS VAR: country year unique_id 
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	March 1st 2021
 */
		clear all 
 
		//Sections
		global sectionA		0 // Share of medical officers per all medical staff
		global sectionB		0 // Share of clinics with a medical officer 
		global sectionC 	0 // Share of clinics with a nurse or paramedical staff
		global sectionD 	0 // Share of clinics with a medical officer - all countries
		global sectionE 	1 // Share of clinics with a medical officer - region
		global sectionF		0 // Regression tabel with & without country fixed effects

/*************************************
		Provider level dataset 
**************************************/	
	
	*Open final provider level dataset 
	use "$EL_dtFin/Final_pl.dta", clear    
	
	*Drop Kenya 2012 because no variable on total medical staff count was collected for that year 
	drop if cy == "KEN_2012"
	
	*Drop if admin 1 name is missing 
	drop if admin1_name == ""
	
	*Create a variable of all doctors 
	gen 	doctors = 0 
	replace doctors = 1 if provider_cadre1 == 1
	by 		cy facility_id, sort: egen tot_doctors = total(doctors)
	gen 	fac_hasdoctors = 1 if tot_doctors != 0
	
	*Create a variable for all nurses or "other"
	gen		nurse_other = 0 
	replace nurse_other = 1 if provider_cadre1 == 3 | provider_cadre1 == 4
	by 		cy facility_id, sort: egen tot_nurseother = total(nurse_other)
	gen 	fac_hasnurseother = 1 if tot_nurseother != 0
	
	*Clean up total staff and total medical staff variables 
	recode	num_med num_staff (0 .a = .) 
	gen 	all_med = 0
	replace	all_med = 1 if provider_cadre1 == 1 | provider_cadre1 == 3 | provider_cadre1 == 4
	by 		cy facility_id, sort: egen tot_all_med = total(all_med)
	replace num_med 	= tot_all_med  if num_med   == . 
	replace num_staff 	= tot_all_med  if num_staff == . 
	drop 	all_med tot_all_med // these variables are no longer needed 
	
	*Create share of medical officers per all clinical staff
	gen 	med_cli_frac = tot_doctors/num_med
	
	*Remove duplicate facility ids - only need 1 facility id 
	bysort 	cy facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		
	drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
	drop 	facility_id_dup				// this variable is no longer needed 
 
	*Create rural/urban indicator  
	gen			rural = 1 if fac_type == 1 | fac_type == 2 | fac_type == 3
	replace 	rural = 0 if fac_type == 4 | fac_type == 5 | fac_type == 6
	lab define  rur_lab 1 "Rural" 0 "Urban"
	label val 	rural rur_lab
	label var 	rural "Urban/Rural Facilites"
	
	*Needed to match the name of the admin area mentioned in the GDP data receieved from the World Bank's poverty team 
	replace	admin1_name	= admin2_name		if country == "SIERRALEONE"
	replace	admin1_name	= admin2_name		if country == "MALAWI"
 
	*Create a dataframe to be used in the region graphs
	frame copy default region_urban
	frame copy default region_rural
	frame change default 
  
	*Collapse to state level
	collapse	(firstnm) 	poor190_ln 										/// poverty rate at the $1.9 level
				(mean)		med_cli_frac 									/// Share of medical officers 
				(count)		fac_hasdoctors fac_hasnurseother facility_id	/// percent at the admin level of all facilities 
				,by(country cy admin1_name)
      	
	*Create share of clinics that have a medical officer per admin level 
	replace	fac_hasdoctors = fac_hasdoctors/facility_id
	
	*Create share of clinics that have a nurse or paramedical staf per admine level
	replace fac_hasnurseother = fac_hasnurseother/facility_id
      
	/*************************************************
	Share of medical officers  per all clinical staff
	************************************************/
	if $sectionA {	 
 
	*Restrict to each country	
     levelsof cy, local(levels)
     foreach l in `levels' {
    
	preserve 
			*Keep each country 
			keep if cy == "`l'"
			
			*Store country name
			replace country	= strproper(country)
			fre		country 
			return	list 
			local	cnt_name = `r(lab_valid)' 

			*Calculate regression coefficients
			reg med_cli_frac poor190_ln
				mat a = r(table)
				local b1 = a[1,1]
				local p1 = a[4,1]
				local r1 = e(r2)

			*Store coefficients in locals 
			foreach param in b1 p1 b2 p2 r1 r2 {
			  local `param' : di %3.2f ``param''
			}
	 
			/************************************
			Graph scatter points with linegraphs 
			************************************/
			tw ///
			(lfitci  med_cli_frac poor190_ln, lc(black) lp(dash) acolor(gs14) alp(none) ) ///
			(lpoly   med_cli_frac poor190_ln, lw(thick) lc(maroon) ) ///
			(scatter med_cli_frac poor190_ln, m(.) mc(black) mlab(admin1_name) mlabangle(20) mlabc(black) mlabpos(9) msize(vtiny) mlabsize(tiny)) ///
				,	ytit("Share of Medical officers of all clinical staff", placement(left) justification(left)) ///		
					xtit("Poverty rate at $1.9 (not in pct) in the area (2011 ICP)") 		///
					graphregion(color(white)) title("`cnt_name'", color(black)) 			///
					note("Regression Coefficient: `b1' (p=`p1', R{superscript:2}=`r1')") legend(off)
			graph save "$EL_out/Final/Scatter/Poverty_`l'_medoff.gph", replace   
	restore 
	}
 
	*Combine the graphs together
	graph combine 												///
		"$EL_out/Final/Scatter/Poverty_KEN_2018_medoff.gph" 	///
		"$EL_out/Final/Scatter/Poverty_MWI_2019_medoff.gph" 	///
		"$EL_out/Final/Scatter/Poverty_TZN_2014_medoff.gph" 	///
		"$EL_out/Final/Scatter/Poverty_TZN_2016_medoff.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_1_medoff.png", replace as(png)
			
	*Combine the graphs together
	graph combine 										///
		"$EL_out/Final/Scatter/Poverty_GNB_2018_medoff.gph" 	///
		"$EL_out/Final/Scatter/Poverty_NER_2015_medoff.gph" 	///
		"$EL_out/Final/Scatter/Poverty_MDG_2016_medoff.gph" 	///
		"$EL_out/Final/Scatter/Poverty_NGA_2013_medoff.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_2_medoff.png", replace as(png)
			
	*Combine the graphs together
	graph combine 											///
		"$EL_out/Final/Scatter/Poverty_TGO_2013_medoff.gph" 	///
		"$EL_out/Final/Scatter/Poverty_UGA_2013_medoff.gph" 	///
		"$EL_out/Final/Scatter/Poverty_SLA_2018_medoff.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_3_medoff.png", replace as(png)
	}			
	
	/****************************************
	Share of clinics with a medical officer 
	*****************************************/
	if $sectionB {	
		
	*Restrict to each country	
     levelsof cy, local(levels)
     foreach l in `levels' {
    
	preserve 
			*Keep each country 
			keep if cy == "`l'"
			
			*Store country name
			replace country	= strproper(country)
			fre		country 
			return	list 
			local	cnt_name = `r(lab_valid)' 

			*Calculate regression coefficients
			reg fac_hasdoctors poor190_ln
				mat a = r(table)
				local b1 = a[1,1]
				local p1 = a[4,1]
				local r1 = e(r2)

			*Store coefficients in locals 
			foreach param in b1 p1 b2 p2 r1 r2 {
			  local `param' : di %3.2f ``param''
			}
	 
			/************************************
			Graph scatter points with linegraphs 
			************************************/ 
			tw ///
			(lfitci  fac_hasdoctors poor190_ln, lc(black) lp(dash) acolor(gs14) alp(none) ) ///
			(lpoly   fac_hasdoctors poor190_ln, lw(thick) lc(maroon) ) ///
			(scatter fac_hasdoctors poor190_ln, m(.) mc(black) mlab(admin1_name) mlabangle(20) mlabc(black) mlabpos(9) msize(vtiny) mlabsize(tiny)) ///
				,	ytit("Share of clinics that have a medical officer", placement(left) justification(left)) ///		
					xtit("Poverty rate at $1.9 (not in pct) in the area (2011 ICP)") 		///
					graphregion(color(white)) title("`cnt_name'", color(black)) 			///
					note("Regression Coefficient: `b1' (p=`p1', R{superscript:2}=`r1')") legend(off)
			graph save "$EL_out/Final/Scatter/Poverty_`l'_medone.gph", replace   
	restore 
		 }
 
	*Combine the graphs together
	graph combine 												///
		"$EL_out/Final/Scatter/Poverty_KEN_2018_medone.gph" 	///
		"$EL_out/Final/Scatter/Poverty_MWI_2019_medone.gph" 	///
		"$EL_out/Final/Scatter/Poverty_TZN_2014_medone.gph" 	///
		"$EL_out/Final/Scatter/Poverty_TZN_2016_medone.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_1_medone.png", replace as(png)
			
	*Combine the graphs together
	graph combine 										///
		"$EL_out/Final/Scatter/Poverty_GNB_2018_medone.gph" 	///
		"$EL_out/Final/Scatter/Poverty_NER_2015_medone.gph" 	///
		"$EL_out/Final/Scatter/Poverty_MDG_2016_medone.gph" 	///
		"$EL_out/Final/Scatter/Poverty_NGA_2013_medone.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_2_medone.png", replace as(png)
			
	*Combine the graphs together
	graph combine 											///
		"$EL_out/Final/Scatter/Poverty_TGO_2013_medone.gph" 	///
		"$EL_out/Final/Scatter/Poverty_UGA_2013_medone.gph" 	///
		"$EL_out/Final/Scatter/Poverty_SLA_2018_medone.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_3_medone.png", replace as(png)
	}
	
	/*************************************************
	Share of clinics with a nurse or paramedical staff
	**************************************************/
	if $sectionC {	
		
	*Restrict to each country	
     levelsof cy, local(levels)
     foreach l in `levels' {
    
	preserve 
			*Keep each country 
			keep if cy == "`l'"
			
			*Store country name
			replace country	= strproper(country)
			fre		country 
			return	list 
			local	cnt_name = `r(lab_valid)' 

			*Calculate regression coefficients
			reg fac_hasnurseother poor190_ln
				mat a = r(table)
				local b1 = a[1,1]
				local p1 = a[4,1]
				local r1 = e(r2)

			*Store coefficients in locals 
			foreach param in b1 p1 b2 p2 r1 r2 {
			  local `param' : di %3.2f ``param''
			}
	 
			/************************************
			Graph scatter points with linegraphs 
			************************************/ 
			tw ///
			(lfitci  fac_hasnurseother poor190_ln, lc(black) lp(dash) acolor(gs14) alp(none) ) ///
			(lpoly   fac_hasnurseother poor190_ln, lw(thick) lc(maroon) ) ///
			(scatter fac_hasnurseother poor190_ln, m(.) mc(black) mlab(admin1_name) mlabangle(20) mlabc(black) mlabpos(9) msize(vtiny) mlabsize(tiny)) ///
				,	ytit("Share of clinics that have a nurse or paramedical staff", placement(left) justification(left)) ///		
					xtit("Poverty rate at $1.9 (not in pct) in the area (2011 ICP)") 		///
					graphregion(color(white)) title("`cnt_name'", color(black)) 			///
					note("Regression Coefficient: `b1' (p=`p1', R{superscript:2}=`r1')") legend(off)
			graph save "$EL_out/Final/Scatter/Poverty_`l'_mednurs.gph", replace   
	restore 
		 }
  
	*Combine the graphs together
	graph combine 												///
		"$EL_out/Final/Scatter/Poverty_KEN_2018_mednurs.gph" 	///
		"$EL_out/Final/Scatter/Poverty_MWI_2019_mednurs.gph" 	///
		"$EL_out/Final/Scatter/Poverty_TZN_2014_mednurs.gph" 	///
		"$EL_out/Final/Scatter/Poverty_TZN_2016_mednurs.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_1_mednurs.png", replace as(png)
 		
	*Combine the graphs together
	graph combine 										///
		"$EL_out/Final/Scatter/Poverty_GNB_2018_mednurs.gph" 	///
		"$EL_out/Final/Scatter/Poverty_NER_2015_mednurs.gph" 	///
		"$EL_out/Final/Scatter/Poverty_MDG_2016_mednurs.gph" 	///
		"$EL_out/Final/Scatter/Poverty_NGA_2013_mednurs.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_2_mednurs.png", replace as(png)
			
	*Combine the graphs together
	graph combine 												///
		"$EL_out/Final/Scatter/Poverty_TGO_2013_mednurs.gph" 	///
		"$EL_out/Final/Scatter/Poverty_UGA_2013_mednurs.gph" 	///
		"$EL_out/Final/Scatter/Poverty_SLA_2018_mednurs.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_3_mednurs.png", replace as(png)
	}
	
	/********************************************************
	Share of clinics with a medical officer - all countries 
	*******************************************************/
	if $sectionD {	
		
	preserve 
			*Calculate regression coefficients
			reg fac_hasdoctors poor190_ln
				mat a = r(table)
				local b1 = a[1,1]
				local p1 = a[4,1]
				local r1 = e(r2)

			*Store coefficients in locals 
			foreach param in b1 p1 b2 p2 r1 r2 {
			  local `param' : di %3.2f ``param''
			}
	 
			/************************************
			Graph scatter points with linegraphs 
			************************************/ 
			tw ///
			(lfitci  fac_hasdoctors poor190_ln, lc(black) lp(dash) acolor(gs14) alp(none)) ///
			(lpoly   fac_hasdoctors poor190_ln, lw(thick) lc(maroon)) ///
			(scatter fac_hasdoctors poor190_ln if cy == "GNB_2018", m(O) mc(red) 		mlc(red) 		msize(tiny)) 	///
			(scatter fac_hasdoctors poor190_ln if cy == "KEN_2018", m(O) mc(green) 	mlc(green) 		msize(tiny))  		///
			(scatter fac_hasdoctors poor190_ln if cy == "MDG_2016", m(O) mc(ebblue) 	mlc(ebblue) 	msize(tiny)) 	///
			(scatter fac_hasdoctors poor190_ln if cy == "MWI_2019", m(O) mc(dkorange) mlc(dkorange)	msize(tiny)) 		///
			(scatter fac_hasdoctors poor190_ln if cy == "NER_2015", m(O) mc(yellow) 	mlc(yellow) 	msize(tiny)) 	///
			(scatter fac_hasdoctors poor190_ln if cy == "NGA_2013", m(O) mc(gray) 	mlc(gray) 		msize(tiny)) 		///
			(scatter fac_hasdoctors poor190_ln if cy == "SLA_2018", m(O) mc(eltblue) 	mlc(eltblue)	msize(tiny)) 	///
			(scatter fac_hasdoctors poor190_ln if cy == "TGO_2013", m(O) mc(eltgreen)	mlc(eltgreen) 	msize(tiny)) 	///
			(scatter fac_hasdoctors poor190_ln if cy == "TZN_2014", m(O) mc(edkblue) 	mlc(edkblue) 	msize(tiny)) 	///
			(scatter fac_hasdoctors poor190_ln if cy == "TZN_2016", m(O) mc(black) 	mlc(black) 		msize(tiny)) 		///
			(scatter fac_hasdoctors poor190_ln if cy == "UGA_2013", m(O) mc(brown) 	mlc(brown) 	msize(tiny)) 			///
				,ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%", angle(0) nogrid labsize(vsmall))			///
				 xlabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%", angle(0) nogrid labsize(vsmall))			///
				ytit("Share of clinics that have a medical officer", placement(left) justification(left) size(small)) 	///		
				 xtit("Poverty rate at $1.9 (not in pct) in the area (2011 ICP)", size(small)) 							///
				 graphregion(color(white)) 	xscale(noli) yscale(noli) 													///
				 legend(order(4 5 6 7 8 9 10 11 12 13 14) label(4 "Guinea Bissau") label(5 "Kenya 2018") label(6 "Madagascar")	///
					label(7 "Malawi") label(8 "Niger") label(9 "Nigeria") label(10 "Sierra Leone")								///
					label(11 "Togo") label(12 "Tazania 2014") label(13 "Tanzania 2016") 										///
					label(14 "Uganda") symy(2) symx(4) size(small) c(1) ring(1) pos(3) region(lc(none) fc(none)))				///
					note("Notes: This plot shows the share of clinics that have a doctor by the proverty rate at the top adminstrative level. The share of clinics "" with a doctor is defined as the total number of doctors and medical officiers at the top administrative level divided by the total "" number of clinics in the adminstrative level. The poverty rate is at the $1.9 rate per day for the 2011 year in each country.", size(vsmall))
			graph export "$EL_out/Final/Poverty_medone_allcountries.png", replace as(png) 	
	restore 
		 }
    
	/***********************************************
	Share of clinics with a medical officer - region
	*************************************************/
	if $sectionE {	
	
	/*******************************************
	 Open dataframe created for urban facilties  
	********************************************/
	frame change region_urban
					
	*Collapse to state level
	collapse	(firstnm) 	poor190_ln 										/// poverty rate at the $1.9 level
				(count)		fac_hasdoctors fac_hasnurseother facility_id	/// percent at the admin level of all facilities 
				,by(country cy admin1_name rural)
				
	*Create share of clinics that have a medical officer per admin level 
	replace	fac_hasdoctors = fac_hasdoctors/facility_id	

	*Restrict to only urban facilities 
	keep if rural == 0
	
	*Drop Kenya 2012 because no medical staff count was collected for that year 
	drop if cy == "KEN_2012"
	
	*Drop if admin 1 name is missing 
	drop if admin1_name == ""

	*Calculate regression coefficients
	reg fac_hasdoctors poor190_ln
		mat a = r(table)
		local b1 = a[1,1]
		local p1 = a[4,1]
		local r1 = e(r2)

	*Store coefficients in locals 
	foreach param in b1 p1 b2 p2 r1 r2 {
	  local `param' : di %3.2f ``param''
	}

	/************************************
	Graph scatter points with linegraphs 
	************************************/ 
	tw ///
	(lfitci  fac_hasdoctors poor190_ln, lc(black) lp(dash) acolor(gs14) alp(none) ) ///
	(lpoly   fac_hasdoctors poor190_ln, lw(thick) lc(maroon) ) ///
	(scatter fac_hasdoctors poor190_ln if cy == "GNB_2018", m(O) mc(red) 		mlc(red) 		msize(tiny)) 	///
	(scatter fac_hasdoctors poor190_ln if cy == "KEN_2018", m(O) mc(green) 	mlc(green) 		msize(tiny))  		///
	(scatter fac_hasdoctors poor190_ln if cy == "MDG_2016", m(O) mc(ebblue) 	mlc(ebblue) 	msize(tiny)) 	///
	(scatter fac_hasdoctors poor190_ln if cy == "MWI_2019", m(O) mc(dkorange) mlc(dkorange)	msize(tiny)) 		///
	(scatter fac_hasdoctors poor190_ln if cy == "NER_2015", m(O) mc(yellow) 	mlc(yellow) 	msize(tiny)) 	///
	(scatter fac_hasdoctors poor190_ln if cy == "NGA_2013", m(O) mc(gray) 	mlc(gray) 		msize(tiny)) 		///
	(scatter fac_hasdoctors poor190_ln if cy == "SLA_2018", m(O) mc(eltblue) 	mlc(eltblue)	msize(tiny)) 	///
	(scatter fac_hasdoctors poor190_ln if cy == "TGO_2013", m(O) mc(eltgreen)	mlc(eltgreen) 	msize(tiny)) 	///
	(scatter fac_hasdoctors poor190_ln if cy == "TZN_2014", m(O) mc(edkblue) 	mlc(edkblue) 	msize(tiny)) 	///
	(scatter fac_hasdoctors poor190_ln if cy == "TZN_2016", m(O) mc(black) 	mlc(black) 		msize(tiny)) 		///
	(scatter fac_hasdoctors poor190_ln if cy == "UGA_2013", m(O) mc(brown) 	mlc(brown) 	msize(tiny)) 			///
		,ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%", angle(0) nogrid labsize(vsmall))			///
		 xlabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%", angle(0) nogrid labsize(vsmall))			///
		 ytit("Share of clinics that have a medical officer", placement(left) justification(left) size(small))  ///		
		 xtit("Poverty rate at $1.9 (not in pct) in the area (2011 ICP)", size(small))  						///
		 graphregion(color(white)) title("Urban Facilties", color(black)) xscale(noli) yscale(noli) 			///
		 legend(order(4 5 6 7 8 9 10 11 12 13 14) label(4 "Guinea Bissau") label(5 "Kenya 2018") label(6 "Madagascar")	///
							 label(7 "Malawi") label(8 "Niger") label(9 "Nigeria") label(10 "Sierra Leone")				///
							 label(11 "Togo") label(12 "Tazania 2014") label(13 "Tanzania 2016") 						///
							 label(14 "Uganda") symy(2) symx(4) size(small) cols(5) region(lc(none) fc(none)))			
	graph save "$EL_out/Final/Scatter/Poverty_medone_urban.gph", replace   
  
	*Change back to default dataframe 
	frame change default
	frame drop region_urban 
 	
	/*******************************************
	*Open dataframe created for rural facilities
	********************************************/
	frame change region_rural 
	
	*Collapse to state level
	collapse	(firstnm) 	poor190_ln 										/// poverty rate at the $1.9 level
				(count)		fac_hasdoctors fac_hasnurseother facility_id	/// percent at the admin level of all facilities 
				,by(country cy admin1_name rural)
				
	*Create share of clinics that have a medical officer per admin level 
	replace	fac_hasdoctors = fac_hasdoctors/facility_id	

	*Restrict to only rural facilities 
	keep if rural == 1
	
	*Drop Kenya 2012 because no medical staff count was collected for that year 
	drop if cy == "KEN_2012"
	
	*Drop if admin 1 name is missing 
	drop if admin1_name == ""

	*Calculate regression coefficients
	reg fac_hasdoctors poor190_ln
		mat a = r(table)
		local b1 = a[1,1]
		local p1 = a[4,1]
		local r1 = e(r2)

	*Store coefficients in locals 
	foreach param in b1 p1 b2 p2 r1 r2 {
	  local `param' : di %3.2f ``param''
	}

	/************************************
	Graph scatter points with linegraphs 
	************************************/ 
	tw ///
	(lfitci  fac_hasdoctors poor190_ln, lc(black) lp(dash) acolor(gs14) alp(none) )	 									///
	(lpoly   fac_hasdoctors poor190_ln, lw(thick) lc(maroon) ) 															///
	(scatter fac_hasdoctors poor190_ln if cy == "GNB_2018", m(O) mc(red) 		mlc(red) 		msize(tiny)) 			///
	(scatter fac_hasdoctors poor190_ln if cy == "KEN_2018", m(O) mc(green) 	mlc(green) 		msize(tiny))  				///
	(scatter fac_hasdoctors poor190_ln if cy == "MDG_2016", m(O) mc(ebblue) 	mlc(ebblue) 	msize(tiny)) 			///
	(scatter fac_hasdoctors poor190_ln if cy == "MWI_2019", m(O) mc(dkorange) mlc(dkorange)	msize(tiny)) 				///
	(scatter fac_hasdoctors poor190_ln if cy == "NER_2015", m(O) mc(yellow) 	mlc(yellow) 	msize(tiny)) 			///
	(scatter fac_hasdoctors poor190_ln if cy == "NGA_2013", m(O) mc(gray) 	mlc(gray) 		msize(tiny)) 				///
	(scatter fac_hasdoctors poor190_ln if cy == "SLA_2018", m(O) mc(eltblue) 	mlc(eltblue)	msize(tiny)) 			///
	(scatter fac_hasdoctors poor190_ln if cy == "TGO_2013", m(O) mc(eltgreen)	mlc(eltgreen) 	msize(tiny)) 			///
	(scatter fac_hasdoctors poor190_ln if cy == "TZN_2014", m(O) mc(edkblue) 	mlc(edkblue) 	msize(tiny)) 			///
	(scatter fac_hasdoctors poor190_ln if cy == "TZN_2016", m(O) mc(black) 	mlc(black) 		msize(tiny)) 				///
	(scatter fac_hasdoctors poor190_ln if cy == "UGA_2013", m(O) mc(brown) 	mlc(brown) 	msize(tiny)) 					///
		,ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%", angle(0) nogrid labsize(vsmall))					///
		 xlabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%", angle(0) nogrid labsize(vsmall))					///
		 ytit("Share of clinics that have a medical officer", placement(left) justification(left) size(small))  		///		
		 xtit("Poverty rate at $1.9 (not in pct) in the area (2011 ICP)", size(small))  								///
		 graphregion(color(white)) title("Rural Facilities", color(black)) xscale(noli) yscale(noli) 					///
		 legend(order(4 5 6 7 8 9 10 11 12 13 14) label(4 "Guinea Bissau") label(5 "Kenya 2018") label(6 "Madagascar")	///
							 label(7 "Malawi") label(8 "Niger") label(9 "Nigeria") label(10 "Sierra Leone")				///
							 label(11 "Togo") label(12 "Tazania 2014") label(13 "Tanzania 2016") 						///
							 label(14 "Uganda") symy(2) symx(4) size(small) cols(5) region(lc(none) fc(none)))				
	graph save "$EL_out/Final/Scatter/Poverty_medone_rural.gph", replace   
 
	*Change back to default dataframe 
	frame change default
	frame drop region_rural  
	
	/******************************
	 Combine the graphs together
	******************************/
	
	*Combine both graphs to use the same legend 
	grc1leg ///
		"$EL_out/Final/Scatter/Poverty_medone_urban.gph" 	///
		"$EL_out/Final/Scatter/Poverty_medone_rural.gph" 	///
		, r(1) pos(7) graphregion(color(white)) 			///
		note("Notes: These plots shows the share of clinics that have a doctor by the proverty rate at the top adminstrative level and by region. The share of clinics "" with a doctor is defined as the total number of doctors and medical officiers at the top administrative level divided by the total number of clinics in "" the adminstrative level. The poverty rate is at the $1.9 rate per day for the 2011 year in each country.", size(vsmall))
	graph export "$EL_out/Final/Poverty_medone_region.png", replace as(png)
	}
 	 	
	/***********************************************
	Regression tabel with & without country fixed effects
	*************************************************/
	if $sectionF {
	
	/**********************
		All countries 
	***********************/
	
	*Encode country variable 
	encode cy, gen(cy_coded) 
	label var poor190_ln "Poverty rate at 1.9"
	
	*Create binary variables for the facility type 
	gen 		facility_hos = 0 
	replace 	facility_hos = 1 if facility_level == 1
	label var 	facility_hos "Hospitals"
	
	*Relabel rural for regressions 
	label var 		rural "Urban/Rural Facilities (1=Rural)"
	
	*Run regression of poverty on share of clinics with medical officers  
	eststo clear
	
	eststo:	reg fac_hasdoctors poor190_ln, r 								// OLS
	estadd 	local hascount "NO"
	
	eststo: reg fac_hasdoctors poor190_ln i.cy_coded, r							// country fixed effects
	estadd 	local hascount "YES"
	
	eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 				// rural/urban and facility type controls  
	estadd 	local hascount "NO"
	
	eststo: reg fac_hasdoctors poor190_ln facility_hos rural i.cy_coded, r	// rural/urban and country fixed effects 
	estadd 	local hascount "YES"
	
	*Output regression results 
	esttab _all using "$EL_out/Final/Tex files/Poverty_reg.tex", keep(poor190_ln facility_hos rural)	///
	order(poor190_ln facility_hos rural) cells(b(fmt(3) star) se(fmt(3) par)) ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	eqlabels(, lhs("Share of clinics 1)")) mtitles("Simple" "Fixed Effects" "Rural/Urban" "All Effects") ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) label replace	 
 	
	/**********************
		Each Country 
	***********************/ 
	
	*Encode admin level 1 variable 
	encode admin1_name, gen(admin1_name_code)
	
	/*******************************/
	 { // First set of regressions		
	/********************************/
	
	preserve 
		keep if cy_coded == 1

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 
		est 	store gb1
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	 
		est 	store gb3
		
	restore 

	preserve 
		keep if cy_coded == 2

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 	
		est 	store ken1
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	
		est 	store ken3
		
	restore 

	preserve 
		keep if cy_coded == 3

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 	
		est 	store mdg1
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	
		est 	store mdg3
		
	restore 

	}

	*Guinea Bissau panel
	esttab gb1 gb3 using "$EL_out/Final/Tex files/Poverty_reg_A.tex", ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline") ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Guinea Bissau}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	mtitles("Simple" "Rural/Urban") ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps ///
	label compress ///
	replace 
	eststo clear
	 
	*Kenya panel
	esttab ken1 ken3 using "$EL_out/Final/Tex files/Poverty_reg_A.tex", ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Kenya}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps  ///
	append ///
	nomtitles nonumbers nolines ///
	prefoot("\hline") ///
	label compress 
	eststo clear

	*Madagascar panel
	esttab mdg1 mdg3 using "$EL_out/Final/Tex files/Poverty_reg_A.tex", ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Madagascar}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps  ///
	append ///
	nomtitles nonumbers nolines ///
	prefoot("\hline") ///
	postfoot("\hline\hline \end{tabular}") ///
	label compress 
	eststo clear
  
	/*******************************/
	 { // Second set of regressions		
	/*********************************/
	
	preserve 
		keep if cy_coded == 4

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 	
		est 	store mwi1
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	
		est 	store mwi3
		
	restore 
	
	preserve 
		keep if cy_coded == 5

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 	
		est 	store ner1
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	
		est 	store ner3
		
	restore 
	
	preserve 
		keep if cy_coded == 6

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 	
		est 	store nga1
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	
		est 	store nga3
	restore 

	}

	*Malawi panel
	esttab mwi1 mwi3 using "$EL_out/Final/Tex files/Poverty_reg_B.tex", ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline") ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Malawi}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	mtitles("Simple" "Rural/Urban") ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps ///
	label compress ///
	replace
	eststo clear
	 
	*Niger panel
	esttab ner1 ner3 using "$EL_out/Final/Tex files/Poverty_reg_B.tex", ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Niger}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps  ///
	append ///
	nomtitles nonumbers nolines ///
	prefoot("\hline") ///
	label compress 
	eststo clear

	*Nigeria panel
	esttab nga1 nga3 using "$EL_out/Final/Tex files/Poverty_reg_B.tex", ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Nigeria}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps  ///
	append ///
	nomtitles nonumbers nolines ///
	prefoot("\hline") ///
	postfoot("\hline\hline \end{tabular}") ///
	label compress 
	eststo clear

	/*******************************/
	 { // Third set of regressions		
	/*********************************/
	
	preserve 
		keep if cy_coded == 7

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 	
		est 	store sla1
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	
		est 	store sla3
	restore 
	
	preserve 
		keep if cy_coded == 8

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 	
		est 	store tgo1
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	
		est 	store tgo3
	restore 
	
	preserve 
		keep if cy_coded == 11

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 	
		est 	store uga1
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	
		est 	store uga3
	restore 
	}

	*Sierra Leone panel
	esttab sla1 sla3 using "$EL_out/Final/Tex files/Poverty_reg_C.tex", ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline") ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Sierra Leone}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	mtitles("Simple" "Rural/Urban") ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps ///
	label compress ///
	replace
	eststo clear
	 
	*Togo panel
	esttab tgo1 tgo3 using "$EL_out/Final/Tex files/Poverty_reg_C.tex", ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Togo}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps  ///
	append ///
	nomtitles nonumbers nolines ///
	prefoot("\hline") ///
	label compress 
	eststo clear

	*Uganda panel
	esttab uga1 uga3 using "$EL_out/Final/Tex files/Poverty_reg_C.tex", ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Uganda}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps  ///
	append ///
	nomtitles nonumbers nolines ///
	prefoot("\hline") ///
	postfoot("\hline\hline \end{tabular}") ///
	label compress 
	eststo clear

	/*******************************/
	 { // Fourth set of regressions			
	/********************************/	
		
	preserve 
		keep if cy_coded == 9

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 	
		est 	store tzn1
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	
		est 	store tzn3
	restore 
	
	preserve 
		keep if cy_coded == 10

		*Run regression of poverty on share of clinics with medical officers  
		eststo:	reg fac_hasdoctors poor190_ln, r 	
		est 	store tzn5
		
		eststo:	reg fac_hasdoctors poor190_ln facility_hos rural, r 	
		est 	store tzn7
	restore 
	}

	*Tanzania 2014 panel
	esttab tzn1 tzn3 using "$EL_out/Final/Tex files/Poverty_reg_D.tex", ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline") ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Tanzania 2014}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	mtitles("Simple" "Rural/Urban") ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps ///
	label compress ///
	replace
	eststo clear

	*Tanzania 2016 panel
	esttab tzn5 tzn7 using "$EL_out/Final/Tex files/Poverty_reg_D.tex", ///
	posthead("\hline \\ \multicolumn{3}{c}{\textbf{Tanzania 2016}} \\\\[-1ex]") ///
	fragment ///
	keep(poor190_ln facility_hos rural) ///
	order(poor190_ln facility_hos rural) ///
	s(N r2, fmt(0 2) labels("Observations" "R-squared"))  ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	style(tex) coll(none) nogaps  ///
	append ///
	nomtitles nonumbers nolines ///
	prefoot("\hline") ///
	postfoot("\hline\hline \end{tabular}") ///
	label compress 
	eststo clear
	}	
	
	

****************************** en d of do-file ******************************************
