* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Analysis											   *
*				Facility ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create figures and graphs on caseload 

       ** IDS VAR: country year facility_id 
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	Jan 11 2021
 */
 
		//Sections
		global sectionA		0 // K-density of caseload by facility level
		global sectionB		0 // K-density of caseload by region status 
		global sectionC		0 // K-density of caseload country group 
		global sectionD		1 // Box-plot of caseload by type of faciltiy 	
		global sectionE		1 // Box-plot of caseload by region status  
		global sectionF		1 // Box-plot of caseload by facility level 
		global sectionG		1 // Box-plot of caseload by country 
		global sectionH 	1 // Box-plot of caseload country group 
		global sectionI		0 // Bar graph of caseload by country 
		global sectionJ		0 // Bar graph of caseload country grouping 
		global sectionK		0 // Bar graph of caseload by country & facility level
		global sectionL		0 // Line graph of caseload by facility level 
 
/*************************************
		Facility level dataset 
**************************************/

	*Open de-identified dataset 
	use "$EL_dtFin/Final_fl.dta", clear    
      
/****************************************
Create kernel density graph for caseload 
****************************************/
 
	/***************************
	Caseload by facility level
	****************************/
	if $sectionA {	
	
    *Calculate caseload for each facility level 
    sum     caseload if facility_level  == 1,d
    local   hos = r(p50)
    sum     caseload if facility_level  == 2,d
    local   cen = r(p50)
	sum     caseload if facility_level  == 3,d
    local   pos = r(p50)
    
	*Graph kernel density 
    twoway  (kdensity caseload if facility_level == 1, color(red)) 		///
            (kdensity caseload if facility_level == 2, color(eltblue)) ///
			(kdensity caseload if facility_level == 3, color(edkblue)) ///
			, ///
            xline(`hos', lcolor(red) lpattern(dash)) 	///
            xline(`cen', lcolor(ebblue) lpattern(dash)) ///
			xline(`pos', lcolor(edkblue) lpattern(dash)) ///
            legend(order(1 "Hospital" 2 "Health Center" 3 "Health Post")) ///
            xtitle(Caseload: Outpatients per provider per day) ///
            ytitle(Density) ///
            bgcolor (white) graphregion(color(white))  ///
			legend(region(lwidth(none)))
	graph export "$EL_out/Final/k_den_caseload_fl.pdf", replace as(pdf)		
}
 

	/***************************
	Caseload by Urban/Rural 
	****************************/
	if $sectionB {	
		
	*Create a variable for Urban and Rural 
	gen 		region_stat = 0 if fac_type == 1 | fac_type == 2 | fac_type == 3 
	replace		region_stat = 1 if fac_type == 4 | fac_type == 5 | fac_type == 6
	label var 	region_stat "Rural or Urban"
	lab 		def region_stat_lab 0 "Rural" 1 "Urban"
	lab 		val region_stat region_stat_lab 
   
   *Calculate caseload for each region status 
	sum     caseload if region_stat  == 0, d
    local   rur = r(p50)
    sum     caseload if region_stat  == 1, d
    local   urb = r(p50)
	
	*Graph kernel density 
    twoway  (kdensity caseload if region_stat == 0, color(eltblue)) ///
			(kdensity caseload if region_stat == 1, color(edkblue)) ///
			, ///
            xline(`rur', lcolor(ebblue) lpattern(dash)) ///
			xline(`urb', lcolor(edkblue) lpattern(dash)) ///
            legend(order(1 "Rural" 2 "Urban")) 			///
            xtitle(Caseload: Outpatients per provider per day) ///
            ytitle(Density) 								///
            bgcolor (white) graphregion(color(white))  ///
			legend(region(lwidth(none)))
	graph export "$EL_out/Final/k_den_caseload_region.pdf", replace as(pdf)	
	
	drop region_stat 			// this variable is no longer needed 
	label drop region_stat_lab	// this value label is no longer needed 
	
	******************* Same graph but wihout Kenya or Nigeria *****************
	
	*Create a variable for Urban and Rural 
	gen 		region_stat = 0 if fac_type == 1 | fac_type == 2 | fac_type == 3 
	replace		region_stat = 1 if fac_type == 4 | fac_type == 5 | fac_type == 6
	label var 	region_stat "Rural or Urban"
	lab 		def region_stat_lab 0 "Rural" 1 "Urban"
	lab 		val region_stat region_stat_lab 
   
	*Drop Kenya and Nigeria 
	drop if country == "KENYA" | country == "NIGERIA"
   
   *Calculate caseload for each region status 
	sum     caseload if region_stat  == 0, d
    local   rur = r(p50)
    sum     caseload if region_stat  == 1, d
    local   urb = r(p50)
	
	*Graph kernel density 
    twoway  (kdensity caseload if region_stat == 0, color(eltblue)) ///
			(kdensity caseload if region_stat == 1, color(edkblue)) ///
			, ///
            xline(`rur', lcolor(ebblue) lpattern(dash)) ///
			xline(`urb', lcolor(edkblue) lpattern(dash)) ///
            legend(order(1 "Rural" 2 "Urban")) 			///
            xtitle(Caseload: Outpatients per provider per day) ///
            ytitle(Density) 								///
            bgcolor (white) graphregion(color(white))  ///
			legend(region(lwidth(none))) 
	graph export "$EL_out/Final/k_den_caseload_region_wKN.pdf", replace as(pdf)	
	
	drop region_stat 			// this variable is no longer needed 
	label drop region_stat_lab	// this value label is no longer needed 
	
}

	/***********************
	Caseload Country Group
	************************/
	if $sectionC { 
		
	*Create a variable that groups countries into high and low caseload amounts 
		gen			caseload_group = 0 if	country_num == 2 | country_num == 4 |	///
											country_num == 8 | country_num == 5 									
		replace 	caseload_group = 1 if	country_num == 1 | country_num == 3 |	///
											country_num == 6 | country_num == 7	|	///
											country_num == 9 
		label var 	caseload_group "High/low caseload"
		lab 		def caseload_group_lab 0 "Low caseload" 1 "High caseload"
		lab 		val caseload_group caseload_group_lab 

	*Calculate caseload for country group 
	sum     caseload if caseload_group  == 0, d
    local   low = r(p50)
    sum     caseload if caseload_group  == 1, d
    local   hig = r(p50)
	
	*Graph kernel density 
    twoway  (kdensity caseload if caseload_group == 0, color(eltblue)) ///
			(kdensity caseload if caseload_group == 1, color(edkblue)) ///
			, ///
            xline(`low', lcolor(ebblue) lpattern(dash)) ///
			xline(`hig', lcolor(edkblue) lpattern(dash)) ///
            legend(order(1 "Low caseload" 2 "High caseload")) 	///
            xtitle(Caseload: Outpatients per provider per day) 	///
            ytitle(Density) 								///
            bgcolor (white) graphregion(color(white))  ///
			legend(region(lwidth(none)))
	graph export "$EL_out/Final/k_den_caseload_group.pdf", replace as(pdf)	

	drop 		caseload_group 		// this variable is no longer needed 
	label drop	caseload_group_lab	// this value label is no longer needed	
	
	******************* Create graphs with Kenya or Nigeria ***********************
	 
	*Create a variable that groups countries into high and low caseload amounts 
		gen			caseload_group = 0 if	country_num == 2 | country_num == 4 |	///
											country_num == 8  									
		replace 	caseload_group = 1 if	country_num == 3 |						///
											country_num == 6 | country_num == 7	|	///
											country_num == 9 
		label var 	caseload_group "High/low caseload"
		lab 		def caseload_group_lab 0 "Low caseload" 1 "High caseload"
		lab 		val caseload_group caseload_group_lab 

	*Calculate caseload for country group 
	sum     caseload if caseload_group  == 0, d
    local   low = r(p50)
    sum     caseload if caseload_group  == 1, d
    local   hig = r(p50)
	
	*Graph kernel density 
    twoway  (kdensity caseload if caseload_group == 0, color(eltblue)) ///
			(kdensity caseload if caseload_group == 1, color(edkblue)) ///
			, ///
            xline(`low', lcolor(ebblue) lpattern(dash)) ///
			xline(`hig', lcolor(edkblue) lpattern(dash)) ///
            legend(order(1 "Low caseload" 2 "High caseload")) 	///
            xtitle(Caseload: Outpatients per provider per day) 	///
            ytitle(Density) 								///
            bgcolor (white) graphregion(color(white))  ///
			legend(region(lwidth(none)))
	graph export "$EL_out/Final/k_den_caseload_group_wKN.pdf", replace as(pdf)	

	drop 		caseload_group 		// this variable is no longer needed 
	label drop	caseload_group_lab	// this value label is no longer needed	
}

 
/************************************************
Create box plots for caseload by country 
*************************************************/

	/****************************
	Caseload by type of facility
	*******************************/
	if $sectionD {	
	
	preserve  
		*Sum caseload to obtain locals 
		sum	caseload, d  
		  
		*Store descriptive stats in locals 
		local me	= string(`r(p50)',"%9.1f")    
	   
		*Collapse caseload at different percentile levels 
		collapse	(p10) p10=caseload (p25) p25=caseload (p50) p50=caseload	///
					(p75) p75=caseload (p90) p90=caseload, 						///
					by(fac_type)
	 
		*Reshape dataset at each percentile level by country 
		reshape long p, i(fac_type) 
			
		*Gen a type of facility variable to include total number of facilties   	
		gen 	fac_type_2 = "Rural Hospital (N = 369)"		if fac_type == 1
		replace	fac_type_2 = "Rural Clinic (N = 1679)"		if fac_type == 2
		replace fac_type_2 = "Rural Health Post (N = 3228)" if fac_type == 3
		replace fac_type_2 = "Urban Hospital (N = 503)" 	if fac_type == 4
		replace fac_type_2 = "Urban Clinic (N = 1144)" 		if fac_type == 5
		replace fac_type_2 = "Urban Health Post (N = 887)" 	if fac_type == 6
			
		*Graph box plot of caseload percentiles 	
		graph	box p, 					///
				hor over(fac_type_2) 	///
				asy ytit("") note("")	///
				ylab(0 "0" `me' "Median" 10 "10" 20 "20" 30 "30" 40 "40", labsize(vsmall)) ///
				yline(`me' , lc(black) lp(dash)) 			///
				box(1, fi(0) lc(edkblue) lw(medthick)) 		///
				box(2, fi(0) lc(edkblue) lw(medthick)) 		///
				box(3, fi(0) lc(edkblue) lw(medthick)) 		///
				box(4, fi(0) lc(ebblue) lw(medthick)) 		///
				box(5, fi(0) lc(ebblue) lw(medthick)) 		///
				box(6, fi(0) lc(ebblue) lw(medthick)) 		///
				marker(4, mcolor(ebblue))					///
				bgcolor(white) graphregion(color(white))	///
				ylab(,angle(0) nogrid) showyvars  			///
				b1tit("Caseload: Outpatients per provider per day", size(small))	///
				legend(off) note ("The median across all facilities in the sample is `me'", size(vsmall))
		graph export "$EL_out/Final/box_plot_caseload_fl_region.pdf", replace as(pdf)	
	restore 
	
	********************** Create the same graph for each country **********************
	
	
	*Create a loop that stores the local of each country
	levelsof country, local(levels)
		foreach l of local levels 	{
			
	preserve 		
		*Keep one country at a time 
		keep if country == "`l'"
			 
		*Sum caseload to obtain locals 
		sum	caseload, d  
		  
		*Store descriptive stats in locals 
		local me	= string(`r(p50)',"%9.1f")   
		
		*Create locals for N size of facility type 
		sum fac_type 	if fac_type ==1
		local N1		= `r(N)'  
		sum fac_type 	if fac_type ==2
		local N2		= `r(N)'  
		sum fac_type 	if fac_type ==3
		local N3		= `r(N)'  
		sum fac_type 	if fac_type ==4
		local N4		= `r(N)' 
		sum fac_type 	if fac_type ==5
		local N5		= `r(N)'  
		sum fac_type	if fac_type ==6
		local N6		= `r(N)'  
	   
		*Collapse caseload at different percentile levels 
		collapse	(p10) p10=caseload (p25) p25=caseload (p50) p50=caseload	///
					(p75) p75=caseload (p90) p90=caseload, 						///
					by(fac_type)
	 
		*Reshape dataset at each percentile level by country 
		reshape long p, i(fac_type) 
			
		*Gen a type of facility variable to include total number of facilties   	
		gen 	fac_type_2 = "Rural Hospital (N = `N1')"		if fac_type == 1
		replace	fac_type_2 = "Rural Clinic (N = `N2')"			if fac_type == 2
		replace fac_type_2 = "Rural Health Post (N = `N3')" 	if fac_type == 3
		replace fac_type_2 = "Urban Hospital (N = `N4')" 		if fac_type == 4
		replace fac_type_2 = "Urban Clinic (N = `N5')" 			if fac_type == 5
		replace fac_type_2 = "Urban Health Post (N = `N6')" 	if fac_type == 6
			
		*Graph box plot of caseload percentiles 	
		graph	box p, 					///
				hor over(fac_type_2) 	///
				asy ytit("") note("")	///
				ylab(0 "0" `me' "Median" 10 "10" 20 "20" 30 "30" 40 "40" 50 "50", labsize(vsmall)) ///
				yline(`me' , lc(black) lp(dash)) 			///
				box(1, fi(0) lc(edkblue) lw(medthick)) 		///
				box(2, fi(0) lc(edkblue) lw(medthick)) 		///
				box(3, fi(0) lc(edkblue) lw(medthick)) 		///
				box(4, fi(0) lc(ebblue) lw(medthick)) 		///
				box(5, fi(0) lc(ebblue) lw(medthick)) 		///
				box(6, fi(0) lc(ebblue) lw(medthick)) 		///
				marker(1, mcolor(edkblue))					///
				marker(2, mcolor(edkblue))					///
				marker(3, mcolor(edkblue))					///
				marker(4, mcolor(ebblue))					///
				marker(5, mcolor(ebblue))					///
				marker(6, mcolor(ebblue))					///
				bgcolor(white) graphregion(color(white))	///
				ylab(,angle(45) nogrid) showyvars  			///
				b1tit("Caseload: Outpatients per provider per day", size(small))	///
				legend(off) note ("The median across all facilities in the country is `me'", size(vsmall))
		graph export "$EL_out/Final/box_plot_caseload_fl_region_`l'.pdf", replace as(pdf)	
	restore 
	}
	
}

	/*************************
	Caseload by Urban/Rural
	***************************/
	if $sectionE {   
   
	preserve 
		*Sum caseload to obtain locals 
		sum	caseload, d 
		
		*Store descriptive stats in locals 
		local me	= string(`r(p50)',"%9.1f")    
		
		*Create a variable for Urban and Rural 
		gen 		region_stat = 0 if fac_type == 1 | fac_type == 2 | fac_type == 3 
		replace		region_stat = 1 if fac_type == 4 | fac_type == 5 | fac_type == 6
		label var 	region_stat "Rural or Urabn"
		lab 		def region_stat_lab 0 "Rural" 1 "Urban"
		lab 		val region_stat region_stat_lab   
 
		*Collapse caseload at different percentile levels 
		collapse	(p10) p10=caseload (p25) p25=caseload (p50) p50=caseload	///
					(p75) p75=caseload (p90) p90=caseload, 						///
					by(region_stat)
	 
		*Reshape dataset at each percentile level by region  
		reshape long p, i(region_stat) 
			
		*Gen a region status variable to include total number of facilties   	
		gen 	region_stat_2	= "Rural (N = 5276)"	if region_stat == 0
		replace	region_stat_2	= "Urban (N = 2534)"	if region_stat == 1
			
		*Graph box plot of caseload percentiles 	
		graph	box p, 					///
				hor over(region_stat_2) ///
				asy ytit("") note("")	///
				ylab(0 "0" `me' "Median" 10 "10" 20 "20" 30 "30" 40 "40", labsize(vsmall)) ///
				yline(`me' , lc(black) lp(dash)) 			///
				box(1, fi(0) lc(edkblue) lw(medthick)) 		///
				box(2, fi(0) lc(ebblue) lw(medthick)) 		///
				intensity(0)								///
				bgcolor(white) graphregion(color(white))	///
				ylab(,angle(0) nogrid) showyvars  			///
				b1tit("Caseload: Outpatients per provider per day", size(small))	///
				legend(off) note ("The median across all facilities in the sample is `me'", size(vsmall))
		graph export "$EL_out/Final/box_plot_caseload_region.pdf", replace as(pdf)	
	restore  
	
	********************** Create graphs without Kenya and Nigeria *******************
	
	preserve 
		*Drop Kenya and Nigeria 
		drop if country == "KENYA" | country == "NIGERIA"
	
		*Sum caseload to obtain locals 
		sum	caseload, d 
		
		*Store descriptive stats in locals 
		local me	= string(`r(p50)',"%9.1f")    
		
		*Create a variable for Urban and Rural 
		gen 		region_stat = 0 if fac_type == 1 | fac_type == 2 | fac_type == 3 
		replace		region_stat = 1 if fac_type == 4 | fac_type == 5 | fac_type == 6
		label var 	region_stat "Rural or Urabn"
		lab 		def region_stat_lab 0 "Rural" 1 "Urban"
		lab 		val region_stat region_stat_lab   
 
		*Collapse caseload at different percentile levels 
		collapse	(p10) p10=caseload (p25) p25=caseload (p50) p50=caseload	///
					(p75) p75=caseload (p90) p90=caseload, 						///
					by(region_stat)
	 
		*Reshape dataset at each percentile level by region  
		reshape long p, i(region_stat) 
			
		*Gen a region status variable to include total number of facilties   	
		gen 	region_stat_2	= "Rural (N = 1592)"	if region_stat == 0
		replace	region_stat_2	= "Urban (N = 794)"	if region_stat == 1
			
		*Graph box plot of caseload percentiles 	
		graph	box p, 					///
				hor over(region_stat_2) ///
				asy ytit("") note("")	///
				ylab(0 "0" `me' "Median" 10 "10" 20 "20" 30 "30" 40 "40", labsize(vsmall)) ///
				yline(`me' , lc(black) lp(dash)) 			///
				box(1, fi(0) lc(edkblue) lw(medthick)) 		///
				box(2, fi(0) lc(ebblue) lw(medthick)) 		///
				intensity(0)								///
				bgcolor(white) graphregion(color(white))	///
				ylab(,angle(0) nogrid) showyvars  			///
				b1tit("Caseload: Outpatients per provider per day", size(small))	///
				legend(off) note ("The median across all facilities in the sample is `me'", size(vsmall))
		graph export "$EL_out/Final/box_plot_caseload_region_wKN.pdf", replace as(pdf)	
	restore  
}


	/*************************************************
	Caseload by facility level - Hospital/Post/Clinic
	***************************************************/
	if $sectionF {  	
	
	preserve  
		*Sum caseload to obtain locals 
		sum	caseload, d  
		  
		*Store descriptive stats in locals 
		local me	= string(`r(p50)',"%9.1f")    
	   
		*Collapse caseload at different percentile levels 
		collapse	(p10) p10=caseload (p25) p25=caseload (p50) p50=caseload	///
					(p75) p75=caseload (p90) p90=caseload, 						///
					by(facility_level)
	 
		*Reshape dataset at each percentile level by country 
		reshape long p, i(facility_level) 
			
		*Gen a facility level variable to include total number of facilties   	
		gen 	facility_level_2 = "Hospital (N = 872)"			if facility_level == 1
		replace	facility_level_2 = "Health Center (N = 2823)"	if facility_level == 2
		replace facility_level_2 = "Health Post (N = 4115)" 	if facility_level == 3
			
		*Graph box plot of caseload percentiles 	
		graph	box p, 					///
				hor over(facility_level_2) 		///
				asy ytit("") note("")	///
				ylab(0 "0" `me' "Median" 10 "10" 20 "20" 30 "30" 40 "40", labsize(vsmall)) ///
				yline(`me' , lc(black) lp(dash)) 				///
				box(1, fi(0) lc(edkblue) lw(medthick)) 			///
				box(2, fi(0) lc(eltblue) lw(medthick)) 			///
				box(3, fi(0) lc(edkblue) lw(medthick)) 			///
				bgcolor(white) graphregion(color(white))		///
				ylab(,angle(0) nogrid) showyvars				///
				b1tit("Caseload: Outpatients per provider per day", size(small))	///
				legend(off) note ("The median across all facilities in the sample is `me'", size(vsmall))
		graph export "$EL_out/Final/box_plot_caseload_fl.pdf", replace as(pdf)	
	restore  
}

	/*******************
	Caseload by country 
	*********************/
	if $sectionG {  		
	
	preserve 
		*Sum caseload to obtain locals 
		sum	caseload, d  
		  
		*Store descriptive stats in locals 
		local med	= string(`r(p50)',"%9.1f")
		local me	= string(`r(mean)',"%9.1f")  
		local sd1 	= (`r(mean)' + `r(sd)')
		local sd2 	= (`r(mean)' + (`r(sd)' * 2))
		local sd3	= (`r(mean)' + (`r(sd)' * 3))
		local sd_1	= (`r(mean)' - `r(sd)')
		  
		*Collapse caseload at different percentile levels 
		collapse	(p10) p10=caseload (p25) p25=caseload (p50) p50=caseload	///
					(p75) p75=caseload (p90) p90=caseload, 						///
					by(country)

		*Reshape dataset at each percentile level by country 
		reshape long p, i(country) 
			
		*Rename countries to include total number of facilities  	
		replace country = "Kenya (N = 3038)"		if country == "KENYA"
		replace country = "Madagascar (N = 444)"	if country == "MADAGASCAR"
		replace country = "Mozambique (N = 195)" 	if country == "MOZAMBIQUE"
		replace country = "Niger (N = 255)" 		if country == "NIGER"
		replace country = "Nigeria (N = 2385)" 		if country == "NIGERIA"
		replace country = "Sierra Leone (N = 536)" 	if country == "SIERRALEONE"
		replace country = "Tanzania (N = 383)" 		if country == "TANZANIA"
		replace country = "Togo (N = 180)" 			if country == "TOGO"
		replace country = "Uganda (N = 394)" 		if country == "UGANDA" 
			
		*Graph box plot of caseload percentiles 	
		graph	box p, 					///
				hor over(country) 		///
				asy ytit("") note("")	///
				ylab(0 "0" `med' "Median" 10 "10" 20 "20" 30 "30" 40 "40", labsize(vsmall)) ///
				yline(`med' , lc(black) lp(dash)) 			///
				box(1, fi(0) lc(edkblue) lw(medthick)) 		///
				box(2, fi(0) lc(edkblue) lw(medthick)) 		///
				box(3, fi(0) lc(edkblue) lw(medthick)) 		///
				box(4, fi(0) lc(ebblue) lw(medthick)) 		///
				box(5, fi(0) lc(ebblue) lw(medthick)) 		///
				box(6, fi(0) lc(ebblue) lw(medthick)) 		///
				box(7, fi(0) lc(edkblue) lw(medthick)) 		///
				box(8, fi(0) lc(edkblue) lw(medthick)) 		///
				box(9, fi(0) lc(edkblue) lw(medthick)) 		///
				marker(5, mcolor(eltblue))					///
				marker(2, mcolor(edkblue))					///
				bgcolor(white) graphregion(color(white))	///
				ylab(,angle(0) nogrid) showyvars 			///
				b1tit("Caseload: Outpatients per provider per day", size(small))	///
				legend(off) note ("The median across all facilities in the sample is `med'", size(vsmall))
		graph export "$EL_out/Final/box_plot_caseload_country.pdf", replace as(pdf)	
	restore   
}

	/***********************
	Caseload Country Group
	************************/
	if $sectionH {  
		
	preserve 		
		*Create a variable that groups countries into high and low caseload amounts 
		gen			caseload_group = 0 if	country_num == 2 | country_num == 4 |	///
											country_num == 8 | country_num == 5 									
		replace 	caseload_group = 1 if	country_num == 1 | country_num == 3 |	///
											country_num == 6 | country_num == 7	|	///
											country_num == 9 
		label var 	caseload_group "High/low caseload"
		lab 		def caseload_group_lab 0 "Low caseload" 1 "High caseload"
		lab 		val caseload_group caseload_group_lab 
 
		*Sum caseload to obtain locals 
		sum	caseload, d  
		  
		*Store descriptive stats in locals 
		local med	= string(`r(p50)',"%9.1f")
		local me	= string(`r(mean)',"%9.1f")  
		local sd1 	= (`r(mean)' + `r(sd)')
		local sd2 	= (`r(mean)' + (`r(sd)' * 2))
		local sd3	= (`r(mean)' + (`r(sd)' * 3))
		local sd_1	= (`r(mean)' - `r(sd)')
		  
		*Collapse caseload at different percentile levels 
		collapse	(p10) p10=caseload (p25) p25=caseload (p50) p50=caseload	///
					(p75) p75=caseload (p90) p90=caseload, 						///
					by(caseload_group)

		*Reshape dataset at each percentile level by country group  
		reshape long p, i(caseload_group) 
			
		*Rename countries to include total number of facilities  	
		gen 	caseload_group_2 = "Low caseload (N = 3264)"	if caseload_group == 0
		replace caseload_group_2 = "High caseload (N = 4546)"	if caseload_group == 1
			
		*Graph box plot of caseload percentiles 	
		graph	box p, 						///
				hor over(caseload_group_2) 	///
				asy ytit("") note("")		///
				ylab(0 "0" `med' "Median" 10 "10" 20 "20" 30 "30" 40 "40", labsize(vsmall)) ///
				yline(`med' , lc(black) lp(dash)) 			///
				box(1, fi(0) lc(edkblue) lw(medthick)) 		///
				box(2, fi(0) lc(ebblue) lw(medthick)) 		///
				marker(5, mcolor(ebblue))					///
				marker(2, mcolor(edkblue))					///
				bgcolor(white) graphregion(color(white))	///
				ylab(,angle(0) nogrid) showyvars 			///
				b1tit("Caseload: Outpatients per provider per day", size(small))	///
				legend(off) note("The median across all facilities in the sample is `med', size(vsmall)")
		graph export "$EL_out/Final/box_plot_caseload_group.pdf", replace as(pdf)	
	restore
	
****************** Create graph without Kenya or Nigeria ***************************

	preserve 		
		*Create a variable that groups countries into high and low caseload amounts 
		gen			caseload_group = 0 if	country_num == 2 | country_num == 4 |	///
											country_num == 8 									
		replace 	caseload_group = 1 if	country_num == 3 |	///
											country_num == 6 | country_num == 7	|	///
											country_num == 9 
		label var 	caseload_group "High/low caseload"
		lab 		def caseload_group_lab 0 "Low caseload" 1 "High caseload"
		lab 		val caseload_group caseload_group_lab 
 
		*Sum caseload to obtain locals 
		sum	caseload, d  
		  
		*Store descriptive stats in locals 
		local med	= string(`r(p50)',"%9.1f")
		local me	= string(`r(mean)',"%9.1f")  
		local sd1 	= (`r(mean)' + `r(sd)')
		local sd2 	= (`r(mean)' + (`r(sd)' * 2))
		local sd3	= (`r(mean)' + (`r(sd)' * 3))
		local sd_1	= (`r(mean)' - `r(sd)')
		  
		*Collapse caseload at different percentile levels 
		collapse	(p10) p10=caseload (p25) p25=caseload (p50) p50=caseload	///
					(p75) p75=caseload (p90) p90=caseload, 						///
					by(caseload_group)

		*Reshape dataset at each percentile level by country group  
		reshape long p, i(caseload_group) 
			
		*Rename countries to include total number of facilities  	
		gen 	caseload_group_2 = "Low caseload (N = 879)"	if caseload_group == 0
		replace caseload_group_2 = "High caseload (N = 1508)"	if caseload_group == 1
			
		*Graph box plot of caseload percentiles 	
		graph	box p, 						///
				hor over(caseload_group_2) 	///
				asy ytit("") note("")		///
				ylab(0 "0" `med' "Median" 10 "10" 20 "20" 30 "30" 40 "40", labsize(vsmall)) ///
				yline(`med' , lc(black) lp(dash)) 			///
				box(1, fi(0) lc(edkblue) lw(medthick)) 		///
				box(2, fi(0) lc(ebblue) lw(medthick)) 		///
				marker(5, mcolor(ebblue))					///
				marker(2, mcolor(edkblue))					///
				bgcolor(white) graphregion(color(white))	///
				ylab(,angle(0) nogrid) showyvars 			///
				b1tit("Caseload: Outpatients per provider per day", size(small))	///
				legend(off) note("The median across all facilities in the sample is `med', size(vsmall)")
		graph export "$EL_out/Final/box_plot_caseload_group_wKN.pdf", replace as(pdf)	
	restore
}
   
/************************************************
Create bar graphs for caseload by country 
*************************************************/ 

	/*******************
	Caseload by country 
	*********************/ 
	if $sectionI {
		
	*Graph caseload by country 
	qui graph	hbar caseload, ///
				over(country_num, sort(1) des) ///
				asy ///
				bargap(30) ///
				nofill ///
				blabel(bar, format(%9.1f)) ///
				bgcolor(white) ///
				bar(1,color(edkblue))	///
				bar(2,color(edkblue))	///	
				bar(3,color(edkblue))	///
				bar(4,color(edkblue))	///
				bar(5,color(edkblue))	///
				bar(6,color(edkblue))	///
				bar(7,color(edkblue))	///
				bar(8,color(edkblue))	///
				bar(9,color(edkblue))	///
				graphregion(color(white)) ///
				legend(off) ///
				showyvars	///
				ylab(0 "0" 10 "10" 20 "20" 30 "30" ,angle(0) nogrid) ///
				title("") ///
				ytit("Average Caseload") ///
				note ("Caseload is the average across all facilites in the country", size(vsmall))
	graph export "$EL_out/Final/bar_gr_caseload_country.pdf", replace as(pdf)	
}
		
	/***********************
	Caseload Country Group
	************************/
	if $sectionJ {
	
	*Create a variable that groups countries into high and low caseload amounts 
	gen			caseload_group = 0 if	country_num == 2 | country_num == 4 |	///
										country_num == 8 | country_num == 5 									
	replace 	caseload_group = 1 if	country_num == 1 | country_num == 3 |	///
										country_num == 6 | country_num == 7	|	///
										country_num == 9 
	label var 	caseload_group "High/low caseload"
	lab 		def caseload_group_lab 0 "Low caseload" 1 "High caseload"
	lab 		val caseload_group caseload_group_lab 
   	
	*Graph caseload by caseload country grouping 
	qui graph	hbar caseload, ///
				over(caseload_group, sort(1) des) ///
				asy ///
				bargap(30) ///
				nofill ///
				blabel(bar, format(%9.1f)) ///
				bgcolor(white) ///
				bar(1,color(edkblue))	///
				bar(2,color(ebblue))	///	
				graphregion(color(white)) ///
				legend(off) ///
				showyvars	///
				ylab(0 "0" 10 "10" 20 "20" 30 "30" ,angle(0) nogrid) ///
				title("") ///
				ytit("Average Caseload")
	graph export "$EL_out/Final/bar_gr_caseload_group.pdf", replace as(pdf)
}
	
	/*************************************
	Caseload by facility level & country
	**************************************/ 
	if $sectionK {
	
	*Graph caseload by country 
	qui graph	hbar caseload, ///
				over(country_num, label(labsize(vsmall)) sort(1) des) ///
				over(facility_level)	///
				asy ///
				bargap(30) ///
				nofill ///
				blabel(bar, format(%9.1f)) ///
				bgcolor(white) ///
				bar(1,color(edkblue))	///
				bar(2,color(edkblue))	///	
				bar(3,color(edkblue))	///
				bar(4,color(edkblue))	///
				bar(5,color(edkblue))	///
				bar(6,color(edkblue))	///
				bar(7,color(edkblue))	///
				bar(8,color(edkblue))	///
				bar(9,color(edkblue))	///
				graphregion(color(white)) ///
				legend(off) ///
				showyvars	///
				ylab(0 "0" 10 "10" 20 "20" 30 "30" ,angle(0) nogrid) ///
				title("") ///
				ytit("Average Caseload") ///
				note ("Caseload is the average across all facilites in the country", size(vsmall))	
	graph export "$EL_out/Final/bar_gr_caseload_fl_country.pdf", replace as(pdf)	
}

     
/*******************************
Create lines graph for caseload 
********************************/

	/***************************
	Caseload by facility level
	****************************/
	if $sectionL {
		
	*Collapse caseload at different percentile levels 
	collapse	(p10) p10=caseload (p25) p25=caseload (p50) p50=caseload	///
				(p75) p75=caseload (p90) p90=caseload, 						///
				by(facility_level)
	 
	*Reshape dataset at each percentile level by country 
	reshape long p, i(facility_level) 
		
	*Create a percental variable for each country 
	sort 		facility_level
	forvalues x = 1/3 {
			gen p_`x' = p if facility_level == `x'
		}
 
	*Create line graphs of caseload percentiles by facility level  
	twoway	(line _j p_1) || (line _j p_2) || (line _j p_3)	///
			,   ///
			graphregion(color(white))										///
			bgcolor(white) 													///
			legend(region(lwidth(none)))  									///
			ylab(0 "0" 25 "25" 50 "50" 75 "75" 100 "100",angle(0) nogrid)	///
			xlabel(0 "0" 10 "10" 20 "20" 30 "30" 40 "40" 50 "50")			///
			xscale(range(0(10)50)) ytitle("Percentiles")					///
			xtitle("Caseload") 	legend(order(1 "Hospitals" 2 "Health Center" 3 "Healt Post") cols(3))  
	graph export "$EL_out/Final/line_gr_caseload_fl.pdf", replace as(pdf)	
}
	
************************ End of do-file *****************************************


