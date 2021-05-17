* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Descriptive Stats									   *
*				Unique ID											   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create figures and graphs on caseload 

       ** IDS VAR: country year unique_id 
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	Feb 24th 2021
 */
 
		
/*************************************
		Provider level dataset 
**************************************/

	*Open final facility level dataset 
	use "$EL_dtFin/Final_pl.dta", clear    
	
	*Rename countries to removed capitalized letters   	
	replace country = "Kenya"			if country == "KENYA"
	replace country = "Madagascar"		if country == "MADAGASCAR"
	replace country = "Mozambique" 		if country == "MOZAMBIQUE"
	replace country = "Niger" 			if country == "NIGER"
	replace country = "Nigeria" 		if country == "NIGERIA"
	replace country = "Sierra Leone"	if country == "SIERRALEONE"
	replace country = "Tanzania" 		if country == "TANZANIA"
	replace country = "Togo" 			if country == "TOGO"
	replace country = "Uganda" 			if country == "UGANDA" 
	replace country = "Guinea Bissau"	if country == "GUINEABISSAU" 
	replace country = "Malawi"	 		if country == "MALAWI" 
	
	*Create rural/urban indicator 
	gen			rural = 1 if fac_type == 1 | fac_type == 2 | fac_type == 3
	replace 	rural = 0 if fac_type == 4 | fac_type == 5 | fac_type == 6
	lab define  rur_lab 1 "Rural" 0 "Urban"
	label val 	rural rur_lab
 
	*Create age group 
	gen			age_gr = 1 if provider_age1>= 15 & provider_age1<25
	replace		age_gr = 2 if provider_age1>= 25 & provider_age1<35
	replace		age_gr = 3 if provider_age1>= 35 & provider_age1<45
	replace		age_gr = 4 if provider_age1>= 45 & provider_age1<55
	replace		age_gr = 5 if provider_age1>= 55 & provider_age1<65
	replace		age_gr = 6 if provider_age1>= 65 & provider_age1<75
	replace		age_gr = 7 if provider_age1>= 75 & provider_age1<85
	replace		age_gr = 8 if provider_age1>= 85 & provider_age1<95	
	label var 	age_gr "Age Grouping"
	lab define  age_lab 1 "Age 15-25" 2 "Age 25-35" 3 "Age 35-45" 4 "Age 45-55"	///
						5 "Age 55-65" 6 "Age 65-75" 7 "Age 75-85" 8 "Age 85-95"
	label val 	age_gr age_lab 
 
	*Drop missing ages 
	drop if age_gr == .	
	
	gen 	doctors = 0 
	replace doctors = 1 if provider_cadre1 == 1
	by 		cy facility_id, sort: egen tot_doctors = total(doctors)
	
	*Create a variable for all female doctors 
	gen 	doctors_fem = 0 
	replace doctors_fem = 1 if provider_cadre1 == 1 & provider_male1 == 0
	by 		cy facility_id, sort: egen tot_doctors_fem = total(doctors_fem)
	
	*Create share of medical officers per all clinical staff
	gen 	med_fem_frac = tot_doctors_fem/tot_doctors
	
	*Drop missing observations 
	drop if med_fem_frac == .
 
	*Encode country year variable 
	encode  cy, gen(cy_coded)
	
	*Creat percentile categorical varible for provider age 
	sort   provider_age1
	xtile  pct_age = provider_age1, nq(10)
	lab define  pct_lab 1 "10th Percentile" 2 "20th Percentile" 3 "30th Percentile" 4 "40th Percentile"	///
						5 "50th Percentile" 6 "60th Percentile" 7 "70th Percentile" 8 "80th Percentile"	///
						9 "90th Percentile" 10 "99th Percentile"
	label val 	pct_age pct_lab 

	*Collapse to state level
	collapse	(mean)	med_fem_frac 	/// Share of medical officers 
				,by(cy_coded pct_age)
				
	*Create tick for max age percentile 
	summ 	pct_age
	gen		tick = 1 if pct_age == `r(max)'

	*Graph line graph of fraction female doctors by age percentile 
	 twoway ///
		 (line med_fem_frac pct_age if cy_coded==1, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==2, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==3, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==4, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==5, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==6, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==7, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==8, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==9, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==10, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==11, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==12, lp(solid)) ///
		 (line med_fem_frac pct_age if cy_coded==13, lp(solid)) ///
		 (scatter med_fem_frac pct_age if tick == 1, mcolor(black) mlabp(9) msymbol(point) mlabel(cy_coded) ///
				mlabp(9) mlabsize(half_tiny) mlabcolor(black)), ///
		 xlab(1 "10th percentile"  5 "50th Percentile" 9 "90th Percentile", labsize(small) angle(0)) yla(, angle(0)) ///
		 ytitle("Fraction of Female Doctors") ///
		 graphregion(color(white)) xtit("Provider Age") ///
		 legend(off) bgcolor (white)	 
	 graph export "$EL_out/Final/Line plots/med_fem_frac_1.png", replace as(png)   			  

/*
	*Set time series 
    xtset cy_coded pct_age 
	
	xtline med_fem_frac ///
	  ,overlay ///
	  addplot((scatter med_fem_frac pct_age if tick ==1, mcolor(black) msymbol(point) mlabel(cy_coded) mlabsize(half_tiny) mlabcolor(black))) ///
	  ttitle("Provider Age") ytitle("Fraction of Female Doctors") graphregion(color(white)) 			///
	  xlab(1 "10th percentile"  5 "50th Percentile" 9 "90th Percentile", labsize(small)) 				///
	  legend(off) legend(region(lwidth(none)))	 bgcolor (white)				 
	graph export "$EL_out/Final/Line plots/med_fem_frac_2.png", replace as(png) 
*/


	/***************************
	Pyramid of provider gender
	****************************/
	if $sectionI {	
 
	*Create age group 
	gen			age_gr = 1 if provider_age1>= 10 & provider_age1<20
	replace		age_gr = 2 if provider_age1>= 20 & provider_age1<30
	replace		age_gr = 3 if provider_age1>= 30 & provider_age1<40
	replace		age_gr = 4 if provider_age1>= 40 & provider_age1<50
	replace		age_gr = 5 if provider_age1>= 50 & provider_age1<60
	replace		age_gr = 6 if provider_age1>= 60 & provider_age1<70
	replace		age_gr = 7 if provider_age1>= 70 & provider_age1<80
	replace		age_gr = 8 if provider_age1>= 80 & provider_age1<90	
	label var 	age_gr "Age Grouping"
	lab define  age_lab 1 "Age 10-20" 2 "Age 20-30" 3 "Age 30-40" 4 "Age 40-50"	///
						5 "Age 50-60" 6 "Age 60-70" 7 "Age 70-80" 8 "Age 80-90"
	label val 	age_gr age_lab 
	
	*Drop missing ages 
	drop if age_gr == .	

	*Create a variable for male and female provides 
	gen		gen_male	= 1	if provider_male1 == 1
	gen  	gen_female  = 1 if provider_male1 == 0 
	gen		gen_male_per 	= gen_male 
	gen		gen_female_per 	= gen_female
	
	*Create data frames for region graphs 
	frame copy default region_urban_num
	frame copy default region_rural_num
	frame copy default region_urban_per
	frame copy default region_rural_per
	frame change default 
exit 
	preserve  
		*Collapse gender variables by age group 
		collapse	(count) gen_male gen_female				///
					(percent) gen_male_per gen_female_per	///
					,by(age_gr)	

		*Create a constant 
		gen zero = 0 	 
	 
		*Convert male count to negative values need for graphs 
		replace gen_male		= gen_male*(-1) 
		replace gen_male_per	= gen_male_per*(-1)  

		/****************************************
			All Countries - Numer of Providers
		*****************************************/
		
		*Graph pyramind of providers by gender - Number 
		qui twoway	bar gen_male age_gr,horizontal bfc("20 100 131"*0.6)  ||			///
				bar gen_female age_gr, horizontal bfc("226 174 156"*0.6) ||				///	
				scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)		///
				xtitle("Number of Providers") ytitle("Age Group Number")				///
				ytitle("") yscale(noline) ylabel(none)									///
				graphregion(color(white)) 												///
				legend(label(1 Male Providers) label(2 Female Providers) label(3 "") region(col(white)))	///
				xlabel( -20000 "20000" -15000 "15000" -10000 "10000" -5000 "5000" 0 "0" 5000(5000)20000, angle(45) labsize(vsmall))	  
		graph export "$EL_out/Final/Num_providers.png", replace as(png) 
	restore 
	
	/***************
		Doctors 
	***************/
	
	preserve
		*Restrict to only doctors 
		keep if provider_cadre1 == 1
	
		*Collapse gender variables by age group 
		collapse	(count) gen_male gen_female				///
					(percent) gen_male_per gen_female_per	///
					,by(age_gr)	

		*Create a constant 
		gen zero = 0 	 
	 
		*Convert male count to negative values need for graphs 
		replace gen_male		= gen_male*(-1) 
		replace gen_male_per	= gen_male_per*(-1)  

		/****************************************
			All Countries - Numer of Providers
		*****************************************/
		
		*Graph pyramind of providers by gender - Number 
		qui twoway	bar gen_male age_gr,horizontal bfc("20 100 131"*0.6)  ||			///
				bar gen_female age_gr, horizontal bfc("226 174 156"*0.6) ||				///	
				scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)		///
				xtitle("Number of Providers") ytitle("Age Group Number")				///
				ytitle("") yscale(noline) ylabel(none)									///
				graphregion(color(white)) 												///
				legend(label(1 Male Providers) label(2 Female Providers) label(3 "") region(col(white)))	///
				xlabel( -20000 "20000" -15000 "15000" -10000 "10000" -5000 "5000" 0 "0" 5000(5000)20000, angle(45) labsize(vsmall))	  
		graph export "$EL_out/Final/Num_providers_doc.png", replace as(png) 
	restore 
	
	
	/***************
		Nurses 
	***************/
	
	
	/****************************
		Other - Non Doctor/Nurses
	****************************/
	
	
  
	/***************
		By Region 
	***************/
	
	*Open urban data frame 
	frame change region_urban_num
	
	*Keep only urban provider 
	keep if rural == 0
	
	*Collapse gender variables by age group 
	collapse	(count) gen_male gen_female				///
				(percent) gen_male_per gen_female_per	///
				,by(age_gr)	

	*Create a constant 
	gen zero = 0 	 
 
	*Convert male count to negative values need for graphs 
	replace gen_male		= gen_male*(-1) 
	replace gen_male_per	= gen_male_per*(-1)  
	
	*Graph pyramind of providers by gender - Urban
	twoway	bar gen_male age_gr,horizontal bfc("20 100 131"*0.6)  ||				///
			bar gen_female age_gr, horizontal bfc("226 174 156"*0.6) ||				///	
			scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)		///
			xtitle("Number of Providers") ytitle("Age Group Number")				///
			ytitle("") yscale(noline) ylabel(none)									///
			graphregion(color(white)) 	title("Urban", color(black))				///
			legend(label(1 Male Providers) label(2 Female Providers) label(3 "") region(col(white)))	///
			xlabel(-10000 "10000" -5000 "5000" 0 "0" 5000(5000)10000, angle(45) labsize(vsmall))	 
	graph save "$EL_out/Final/Pyramid/Number_providers_urban.gph", replace 
	
	*Open rural data frame 
	frame change region_rural_num
	
	*Keep only rural provider 
	keep if rural == 1
	
	*Collapse gender variables by age group 
	collapse	(count) gen_male gen_female				///
				(percent) gen_male_per gen_female_per	///
				,by(age_gr)	

	*Create a constant 
	gen zero = 0 	 
 
	*Convert male count to negative values need for graphs 
	replace gen_male		= gen_male*(-1) 
	replace gen_male_per	= gen_male_per*(-1)  
	
	*Graph pyramind of providers by gender - Urban
	twoway	bar gen_male age_gr,horizontal bfc("20 100 131"*0.6)  ||				///
			bar gen_female age_gr, horizontal bfc("226 174 156"*0.6) ||				///	
			scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)		///
			xtitle("Number of Providers") ytitle("Age Group Number")				///
			ytitle("") yscale(noline) ylabel(none)									///
			graphregion(color(white)) title("Rural", color(black))					///
			legend(label(1 Male Providers) label(2 Female Providers) label(3 "") region(col(white)))	///
			xlabel(-10000 "10000" -5000 "5000" 0 "0" 5000(5000)10000, angle(45) labsize(vsmall))	 
	graph save "$EL_out/Final/Pyramid/Number_providers_rural.gph", replace
	
	
	/*******************************************
	Combine both graphs to use the same legend 
	******************************************/
	grc1leg ///
		"$EL_out/Final/Pyramid/Number_providers_urban.gph" 	///
		"$EL_out/Final/Pyramid/Number_providers_rural.gph" 	///
		,r(1) pos(6) imargin(0 0 0 0) 	///
		graphregion(color(white)) 
	graph export "$EL_out/Final/Num_providers_region.png", replace as(png) 

	/****************************************
	  All Countries - Percent of Providers
	*****************************************/
	
	*Open default data frame 
	frame change default 
 
	*Graph pyramind of providers by gender - Percentage 
	twoway	bar gen_male_per age_gr,horizontal bfc("20 100 131"*0.6)  ||			///
			bar gen_female_per age_gr, horizontal bfc("226 174 156"*0.6) ||			///	
			scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)		///
			xtitle("Number of Providers") ytitle("Age Group Number")				///
			ytitle("") yscale(noline) ylabel(none)									///
			graphregion(color(white)) 												///
			legend(label(1 Male Providers) label(2 Female Providers) label(3 "") region(col(white)))			///
			xlabel(-35 "35%" -30 "30%" -25 "25%" -20 "20%" -15 "15%" -10 "10%" -5 "5%" 0 "0" 					///
					35 "35%" 30 "30%" 25 "25%" 20 "20%" 15 "15%" 10 "10%" 5 "5%", angle(45) labsize(vsmall))			
	graph export "$EL_out/Final/Per_providers.png", replace as(png)  
	
	/***************
		By Region 
	***************/
	
	*Open urban data frame 
	frame change region_urban_per
	
	*Keep only urban provider 
	keep if rural == 0
	
	*Collapse gender variables by age group 
	collapse	(count) gen_male gen_female				///
				(percent) gen_male_per gen_female_per	///
				,by(age_gr)	

	*Create a constant 
	gen zero = 0 	 
 
	*Convert male count to negative values need for graphs 
	replace gen_male		= gen_male*(-1) 
	replace gen_male_per	= gen_male_per*(-1)  
	
	*Graph pyramind of providers by gender - Percentage & Urban
	twoway	bar gen_male_per age_gr,horizontal bfc("20 100 131"*0.6)  ||			///
			bar gen_female_per age_gr, horizontal bfc("226 174 156"*0.6) ||			///	
			scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)		///
			xtitle("Number of Providers") ytitle("Age Group Number")				///
			ytitle("") yscale(noline) ylabel(none)									///
			graphregion(color(white)) 	title("Urban", color(black))				///
			legend(label(1 Male Providers) label(2 Female Providers) label(3 "") region(col(white)))		///
			xlabel(-40 "40%" -35 "35%" -30 "30%" -25 "25%" -20 "20%" -15 "15%" -10 "10%" -5 "5%" 0 "0" 		///
					40 "40%"  35 "35%" 30 "30%" 25 "25%" 20 "20%" 15 "15%" 10 "10%" 5 "5%", angle(45) labsize(vsmall))
	graph save "$EL_out/Final/Pyramid/Per_providers_urban.gph", replace 
  
	
	*Open rural data frame 
	frame change region_rural_per
	
	*Keep only rural provider 
	keep if rural == 1
	
	*Collapse gender variables by age group 
	collapse	(count) gen_male gen_female				///
				(percent) gen_male_per gen_female_per	///
				,by(age_gr)	

	*Create a constant 
	gen zero = 0 	 
 
	*Convert male count to negative values need for graphs 
	replace gen_male		= gen_male*(-1) 
	replace gen_male_per	= gen_male_per*(-1)  
	
	*Graph pyramind of providers by gender - Percentage & Urban
	twoway	bar gen_male_per age_gr,horizontal bfc("20 100 131"*0.6)  ||			///
			bar gen_female_per age_gr, horizontal bfc("226 174 156"*0.6) ||			///	
			scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)		///
			xtitle("Number of Providers") ytitle("Age Group Number")				///
			ytitle("") yscale(noline) ylabel(none)									///
			graphregion(color(white)) 	title("Rural", color(black))				///
			legend(label(1 Male Providers) label(2 Female Providers) label(3 "") region(col(white)))			///
			xlabel(-40 "40%" -35 "35%" -30 "30%" -25 "25%" -20 "20%" -15 "15%" -10 "10%" -5 "5%" 0 "0" 			///
					40 "40%" 35 "35%" 30 "30%" 25 "25%" 20 "20%" 15 "15%" 10 "10%" 5 "5%", angle(45) labsize(vsmall)) 
	graph save "$EL_out/Final/Pyramid/Per_providers_rural.gph", replace 
	
	/*******************************************
	Combine both graphs to use the same legend 
	******************************************/
	grc1leg ///
		"$EL_out/Final/Pyramid/Per_providers_urban.gph" 	///
		"$EL_out/Final/Pyramid/Per_providers_rural.gph" 	///
		,r(1) pos(6) imargin(0 0 0 0) 	///
		graphregion(color(white)) 
	graph export "$EL_out/Final/Per_providers_region.png", replace as(png) 
	 
	}		
	
	
****************************** End do-file ********************************************
