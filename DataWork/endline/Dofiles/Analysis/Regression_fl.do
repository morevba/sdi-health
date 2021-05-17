* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Regression Outputs									   *
*				Facility ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create figures and graphs on caseload 

       ** IDS VAR: country year facility_id 
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	Marc 1st 2021
	   
**************************************************************************/
 
		//Sections
		global sectionA		0 // Share of medical providers per facility
		global sectionB		0 // Share of non-medical providers per facility
		
/*************************************
		Facility level dataset 
**************************************/
	
	*Open final facility level dataset 
	use "$EL_dtFin/Final_fl.dta", clear   
	
	*Drop Kenya 2012 because no medical staff numbers were collected for that year 
	drop if cy == "KEN_2012"
	
	*Drop if admin 1 name is missing 
	drop if admin1_name == ""
	
	*Creat fraction of non-medical staff 
	gen		num_nonmed	= num_staff - num_med
	gen 	nonmed_frac = num_nonmed/num_staff
	replace nonmed_frac = 1 if nonmed_frac > 1 
 
	*Collapse to state level
	collapse	(firstnm) poor190_ln 			/// poverty rate at the $1.9 level 
				(mean) med_frac	nonmed_frac		/// average share of medical providers per facility 
				,by(cy country admin1_name)
 		
 
	/****************************************
	Share of medical providers per facility
	*****************************************/
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
			reg med_frac poor190_ln
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
			(lfitci  med_frac poor190_ln, lc(black) lp(dash) acolor(gs14) alp(none) ) ///
			(lpoly   med_frac poor190_ln, lw(thick) lc(maroon) ) ///
			(scatter med_frac poor190_ln, m(.) mc(black) mlab(admin1_name) mlabangle(20) mlabc(black) mlabpos(9) msize(vtiny) mlabsize(tiny)) ///
				,	ytit("Share of Medical Providers", placement(left) justification(left)) ///		
					xtit("Poverty rate at $1.9 (not in pct) in the area (2011 ICP)") 		///
					graphregion(color(white)) title("`cnt_name'", color(black)) 			///
					note("Regression Coefficient: `b1' (p=`p1', R{superscript:2}=`r1')") legend(off)
			graph save "$EL_out/Final/Scatter/Poverty_`l'.gph", replace   
	restore 
	}

	*Combine the graphs together
	graph combine 										///
		"$EL_out/Final/Scatter/Poverty_KEN_2018.gph" 	///
		"$EL_out/Final/Scatter/Poverty_MWI_2019.gph" 	///
		"$EL_out/Final/Scatter/Poverty_TZN_2014.gph" 	///
		"$EL_out/Final/Scatter/Poverty_TZN_2016.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_1.png", replace as(png)
			
	*Combine the graphs together
	graph combine 										///
		"$EL_out/Final/Scatter/Poverty_GNB_2018.gph" 	///
		"$EL_out/Final/Scatter/Poverty_NER_2015.gph" 	///
		"$EL_out/Final/Scatter/Poverty_MDG_2016.gph" 	///
		"$EL_out/Final/Scatter/Poverty_NGA_2013.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_2.png", replace as(png)
			
	*Combine the graphs together
	graph combine 											///
		"$EL_out/Final/Scatter/Poverty_TGO_2013.gph" 	///
		"$EL_out/Final/Scatter/Poverty_UGA_2013.gph" 	///
		"$EL_out/Final/Scatter/Poverty_SLA_2018.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_3.png", replace as(png)
	}	
	
	/******************************************
	Share of non-medical providers per facility
	*******************************************/
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
			reg nonmed_frac poor190_ln
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
			(lfitci  nonmed_frac poor190_ln, lc(black) lp(dash) acolor(gs14) alp(none) ) ///
			(lpoly   nonmed_frac poor190_ln, lw(thick) lc(maroon) ) ///
			(scatter nonmed_frac poor190_ln, m(.) mc(black) mlab(admin1_name) mlabangle(20) mlabc(black) mlabpos(9) msize(vtiny) mlabsize(tiny)) ///
				,	ytit("Share of Non-Medical Providers", placement(left) justification(left)) ///		
					xtit("Poverty rate at $1.9 (not in pct) in the area (2011 ICP)") 		///
					graphregion(color(white)) title("`cnt_name'", color(black)) 			///
					note("Regression Coefficient: `b1' (p=`p1', R{superscript:2}=`r1')") legend(off)
			graph save "$EL_out/Final/Scatter/Poverty_`l'_non.gph", replace   
	restore 
	}
 
	*Combine the graphs together
	graph combine 											///
		"$EL_out/Final/Scatter/Poverty_KEN_2018_non.gph" 	///
		"$EL_out/Final/Scatter/Poverty_MWI_2019_non.gph" 	///
		"$EL_out/Final/Scatter/Poverty_TZN_2014_non.gph" 	///
		"$EL_out/Final/Scatter/Poverty_TZN_2016_non.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_1_non.png", replace as(png)
			
	*Combine the graphs together
	graph combine 										///
		"$EL_out/Final/Scatter/Poverty_GNB_2018_non.gph" 	///
		"$EL_out/Final/Scatter/Poverty_NER_2015_non.gph" 	///
		"$EL_out/Final/Scatter/Poverty_MDG_2016_non.gph" 	///
		"$EL_out/Final/Scatter/Poverty_NGA_2013_non.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_2_non.png", replace as(png)
			
	*Combine the graphs together
	graph combine 											///
		"$EL_out/Final/Scatter/Poverty_TGO_2013_non.gph" 	///
		"$EL_out/Final/Scatter/Poverty_UGA_2013_non.gph" 	///
		"$EL_out/Final/Scatter/Poverty_SLA_2018_non.gph" 	///
		, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/poverty_fl_3_non.png", replace as(png)
	}
	 
****************************** end of do-file ******************************************
