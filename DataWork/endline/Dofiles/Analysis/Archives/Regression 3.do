	
	
	*Open final provider level dataset 
	use "$EL_dtFin/Final_pl.dta", clear   
	
	*Create variable of all doctors 
	gen 	doctors = 0 
	replace doctors = 1 if provider_cadre1 == 1
	
	*Create share of medical officers per all clinical staff
	gen 	one_med_cli_frac = doctors/num_staff
	
	*Collapse to state level
	collapse	(firstnm) poor190_ln 				///
				(mean) med_frac	one_med_cli_frac	/// average share of medical providers per facility 
				(sum) doctors 						///
				,by(cy country admin1_name)
 		
	*Drop Kenya 2012 because no medical staff count was collected for that year 
	 drop if cy == "KEN_2012"
	
	*Drop if admin 1 name is missing 
	 drop if admin1_name == ""
  
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
		reg one_med_cli_frac poor190_ln
			mat a = r(table)
			local b1 = a[1,1]
			local p1 = a[4,1]
			local r1 = e(r2)

		foreach param in b1 p1 b2 p2 r1 r2 {
		  local `param' : di %3.2f ``param''
		}
 
		*Graph scatter points with linegraphs 
		tw ///
		(lfitci  one_med_cli_frac poor190_ln, lc(black) lp(dash) acolor(gs14) alp(none) ) ///
		(lpoly   one_med_cli_frac poor190_ln, lw(thick) lc(maroon) ) ///
		(scatter one_med_cli_frac poor190_ln, m(.) mc(black) mlab(admin1_name) mlabangle(20) mlabc(black) mlabpos(9) msize(vtiny) mlabsize(tiny)) ///
			,	ytit("Share of clinics that have a medical officer", placement(left) justification(left)) ///		
				xtit("Poverty rate at $1.9 (not in pct) in the area (2011 ICP)") 		///
				graphregion(color(white)) title("`cnt_name'", color(black)) 			///
				note("Regression Coefficient: `b1' (p=`p1', R{superscript:2}=`r1')") legend(off)
		graph save "$EL_out/Final/Scatter/Poverty_`l'_medone.gph", replace   

restore 
	 }
 
exit 
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
			
			
			
	 
	 
****************************** end of do-file ******************************************
