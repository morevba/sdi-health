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
       ** Last date modified: 	Mar 19th 2021
 */
 
		clear all
 
		//Sections
		global sectionA		0 // Histogram of providers age  
	    global sectionB		0 // Boxplot of providers age 
	    global sectionC		0 // Bar graph of staffing of clinics by region 
		global sectionD		0 // Bar graph of staffing of clinics by facility type  
		global sectionE		0 // Bar graph of clinics by region
		global sectionF		0 // Bar graph of staff gender by facility type 
		global sectionG		1 // Pyramid of provider gender 
		global secitonH		1 // Fraction of female doctors 

/*************************************
		Provider level dataset 
**************************************/

	*Open final provider level dataset 
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

	/***************************
	Histogram of provider age
	****************************/
	if $sectionA {	
	
	tw histogram	provider_age1 if provider_cadre1 == 1, 								///
					title("Doctors in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%")							///
					ytit("Share of Doctors") xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_doc.gph", replace 		
	
	tw histogram	provider_age1 if provider_cadre1 == 3, 								///
					title("Nurses in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%")							///
					ytit("Share of Nurses")	xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_nur.gph", replace 
	
	graph combine 								///
			"$EL_out/Final/Hist/age_doc.gph" 	///
			"$EL_out/Final/Hist/age_nur.gph" 	///
			, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/Hist_age_all.png", replace as(png)
	
	
	*Create histograms for each country 
	foreach cry in	KEN_2012 KEN_2018 MDG_2016 MOZ_2014	///
					NGA_2013 TGO_2013 TZN_2014 TZN_2016	///
					UGA_2013 {
				
	tw histogram	provider_age1 if provider_cadre1 == 1 & cy == "`cry'", 				///
					title("Doctors in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%")							///
					ytit("Share of Doctors") xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_doc_`cry'.gph", replace 
	
	tw histogram	provider_age1 if provider_cadre1 == 3 & cy == "`cry'", 				///
					title("Nurses in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%")							///
					ytit("Share of Nurses")	xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_nur_`cry'.gph", replace 
		}
		
	*Create histograms for each country 
	foreach cry2 in MWI_2019 NER_2015 SLA_2018	 {
		
	tw histogram	provider_age1 if provider_cadre1 == 1 & cy == "`cry2'", 			///
					title("Doctors in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%" .25 "25%")			///
					ytit("Share of Doctors") xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_doc_`cry2'.gph", replace 
	
	tw histogram	provider_age1 if provider_cadre1 == 3 & cy == "`cry2'", 			///
					title("Nurses in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%" .25 "25%")			///
					ytit("Share of Nurses")	xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_nur_`cry2'.gph", replace 
		}	
		
	tw histogram	provider_age1 if provider_cadre1 == 1 & cy == "GNB_2018", 				///
					title("Doctors in Health Facilties: Age", color(black) size(med))		///
					frac lc(black) fc(gs14) gap(10) xoverhang 								///
					ylab(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%" .6 "60%")		///
					ytit("Share of Doctors") xtit(" ")										///
					bgcolor(white) graphregion(color(white))  								///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_doc_GNB_2018.gph", replace 
	
	tw histogram	provider_age1 if provider_cadre1 == 3 & cy == "GNB_2018", 			///
					title("Nurses in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%" .25 "25%")			///
					ytit("Share of Nurses")	xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_nur_GNB_2018.gph", replace 			

	*Combine the two graphs for each country 
	{ // create bracket to close commands below 	
		
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_GNB_2018.gph" 	///
			"$EL_out/Final/Hist/age_nur_GNB_2018.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Guinea Bissau 2018", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_GNB_2018.gph", replace 
	graph export "$EL_out/Final/Hist_age_4.png", replace as(png)
			
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_MWI_2019.gph" 	///
			"$EL_out/Final/Hist/age_nur_MWI_2019.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Malawi 2019", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_MWI_2019.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_NER_2015.gph" 	///
			"$EL_out/Final/Hist/age_nur_NER_2015.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Niger 2015", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_NER_2015.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_SLA_2018.gph" 	///
			"$EL_out/Final/Hist/age_nur_SLA_2018.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Sierra Leone 2018", size(small) color(black))		
	graph save "$EL_out/Final/Hist/age_SLA_2018.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_UGA_2013.gph" 	///
			"$EL_out/Final/Hist/age_nur_UGA_2013.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Uganda 2013", size(small) color(black))			
	graph save "$EL_out/Final/Hist/age_UGA_2013.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_TZN_2016.gph" 	///
			"$EL_out/Final/Hist/age_nur_TZN_2016.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Tanzania 2016", size(small) color(black))		
	graph save "$EL_out/Final/Hist/age_TZN_2016.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_TZN_2014.gph" 	///
			"$EL_out/Final/Hist/age_nur_TZN_2014.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Tanzania 2014", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_TZN_2014.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_TGO_2013.gph" 	///
			"$EL_out/Final/Hist/age_nur_TGO_2013.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Togo 2013", size(small) color(black))		
	graph save "$EL_out/Final/Hist/age_TGO_2013.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_NGA_2013.gph" 	///
			"$EL_out/Final/Hist/age_nur_NGA_2013.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Nigeria 2013", size(small) color(black))			
	graph save "$EL_out/Final/Hist/age_NGA_2013.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_KEN_2012.gph" 	///
			"$EL_out/Final/Hist/age_nur_KEN_2012.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Kenya 2012", size(small) color(black))	
	graph save "$EL_out/Final/Hist/age_KEN_2012.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_KEN_2018.gph" 	///
			"$EL_out/Final/Hist/age_nur_KEN_2018.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Kenya 2018", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_KEN_2018.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_MDG_2016.gph" 	///
			"$EL_out/Final/Hist/age_nur_MDG_2016.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Madagascar 2016", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_MDG_2016.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_MOZ_2014.gph" 	///
			"$EL_out/Final/Hist/age_nur_MOZ_2014.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Mozambique 2014", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_MOZ_2014.gph", replace 
	
	graph combine 									///
			"$EL_out/Final/Hist/age_MWI_2019.gph"	///
			"$EL_out/Final/Hist/age_NER_2015.gph"	///
			"$EL_out/Final/Hist/age_SLA_2018.gph"	///
			"$EL_out/Final/Hist/age_UGA_2013.gph"	///
			,altshrink graphregion(color(white)) 
	graph export "$EL_out/Final/Hist_age_1.png", replace as(png)
	
	graph combine 									///
			"$EL_out/Final/Hist/age_TZN_2016.gph"	///
			"$EL_out/Final/Hist/age_TZN_2014.gph"	///
			"$EL_out/Final/Hist/age_TGO_2013.gph"	///
			"$EL_out/Final/Hist/age_NGA_2013.gph"	///
			,altshrink graphregion(color(white)) 
	graph export "$EL_out/Final/Hist_age_2.png", replace as(png)
	
	graph combine 									///
			"$EL_out/Final/Hist/age_KEN_2012.gph"	///
			"$EL_out/Final/Hist/age_KEN_2018.gph"	///
			"$EL_out/Final/Hist/age_MDG_2016.gph"	///
			"$EL_out/Final/Hist/age_MOZ_2014.gph"	///
			,altshrink graphregion(color(white)) 
	graph export "$EL_out/Final/Hist_age_3.png", replace as(png)
	}	


}

	/***************************
	Boxplot of provider age
	****************************/
	if $sectionB {	
	
	*Boxplot of provider age by each country 
	graph	hbox provider_age1, over(country) noout									///
			ylab(,angle(0) nogrid) showyvars 										///
			ytit("Age") title("Age of Health Providers", color(black) size(med))	///	
			bgcolor(white) graphregion(color(white))  								///
			legend(region(lwidth(none))) 											///
			note(" ") asy legend(off)
	graph export "$EL_out/Final/Boxplot_age.pdf", replace as(pdf)
	
	*Boxplot of provider age in rural clinics by each country 
	graph	hbox provider_age1 if rural == 1, over(country) noout					///
			ylab(,angle(0) nogrid) showyvars 										///
			ytit("Age") title("Rural Health Providers", color(black) size(med))		///	
			bgcolor(white) graphregion(color(white))  								///
			legend(region(lwidth(none))) 											///
			note(" ") asy legend(off)
	graph save "$EL_out/Final/Box plot/Boxplot_agereg1.gph", replace 	
	
	*Boxplot of provider age in urban clinics by each country 
	graph	hbox provider_age1 if rural == 0, over(country) noout					///
			ylab(,angle(0) nogrid) showyvars 										///
			ytit("Age") title("Urban Health Providers", color(black) size(med))		///	
			bgcolor(white) graphregion(color(white))  								///
			legend(region(lwidth(none))) 											///
			note(" ") asy legend(off)
	graph save "$EL_out/Final/Box plot/Boxplot_agereg2.gph", replace
 	
	*Combine both graphs to they are side by side
	graph combine 									///
			"$EL_out/Final/Boxplot_agereg1.gph" 	///
			"$EL_out/Final/Boxplot_agereg2.gph" 	///
			, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/Boxplot_age_cb.pdf", replace as(pdf)
	}	
	
	/**********************************
	Bar graph of clinic staff by region
	***********************************/
	if $sectionC {	
 
	preserve 
		*Create country binary variables 
		foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016	///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
			
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
				
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
				 
			*Create horizontal bar graph of provider occupation by country  
			betterbarci	c_*																										///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) barcolor(edkblue eltblue ebblue)					///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%")  graphregion(color(white)) format(%9.1f)
			graph export "$EL_out/Final/Staff_all.png", replace as(png)
	restore  
  
	preserve 
			*Restrict to only rural health facilities 
			keep if rural == 1
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
			
			*Create variable labels for each country 		
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
		 
		   *Create horizontal bar graph of provider occupation by country and rural clinics 
			betterbarci	c_*																										///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) title("Rural") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Staff_rural.gph", replace 
	restore 
	
	preserve 
			*Restrict to only urban health facilities 
			keep if rural == 0
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of provider occupation by country and urban clinics 
			betterbarci	c_* 																									///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) title("Urban") barcolor(edkblue eltblue ebblue) 	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Staff_urban.gph", replace 
	restore 		 
  
	*Combine both graphs to use the same legend 
	grc1leg ///
		"$EL_out/Final/Bar/Staff_rural.gph" ///
		"$EL_out/Final/Bar/Staff_urban.gph" ///
		,r(1) pos(12) imargin(0 0 0 0) 	///
		graphregion(color(white)) 
	graph export "$EL_out/Final/Staff_reg.png", replace as(png)
	}	 
 
	/*****************************************
	Bar graph of clinic staff by facility type 
	*******************************************/
	if $sectionD {	
  
	preserve 
			*Restrict to only hospitals  
			keep if facility_level == 1
			
			*Relable cadre variable 
			labdtch 	provider_cadre1
			lab define  cad_lab 1 "Doctor" 3 "Nurse" 4 "Para-Professional"
			label val 	provider_cadre1 cad_lab
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
			
			*Create variable labels for each country 		
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
		 
		   *Create horizontal bar graph of provider occupation by country and rural clinics 
			betterbarci	c_*																											///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) title("Hospitals") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))		///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f) xscale(noli) 			///
						 yscale(noli) bgcolor(white)	
			graph save "$EL_out/Final/Bar/Staff_hos.gph", replace 
	restore 
	
	preserve 
			*Restrict to only health centers  
			keep if facility_level == 2
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of provider occupation by country and urban clinics 
			betterbarci	c_* 																											///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) title("Health Centers") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 			///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f) xscale(noli) yscale(noli) 	///
						 bgcolor(white)	
			graph save "$EL_out/Final/Bar/Staff_hc.gph", replace 
	restore
	
	preserve 
			*Restrict to only health posts   
			keep if facility_level == 3
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of provider occupation by country and urban clinics 
			betterbarci	c_* 																											///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) title("Health Posts") barcolor(edkblue eltblue ebblue) 	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 			///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f) xscale(noli) yscale(noli) 	///
						 bgcolor(white)	
			graph save "$EL_out/Final/Bar/Staff_hp.gph", replace 
	restore 		 
  
	*Combine both graphs to use the same legend 
	grc1leg ///
		"$EL_out/Final/Bar/Staff_hos.gph" ///
		"$EL_out/Final/Bar/Staff_hc.gph" ///
		"$EL_out/Final/Bar/Staff_hp.gph" ///
		,r(1) pos(12) imargin(0 0 0 0) 	///
		graphregion(color(white)) 	
 	graph export "$EL_out/Final/Staff_fl.png", replace as(png)
	}	 	
 	
	/***************************
	Bar graph of clinics
	****************************/
	if $sectionE {	
 
	preserve 
		*Create country binary variables 
		foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016	///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				distinct facility_id	if cy == "`cry'"
				return list 
				local N_`cry' `r(ndistinct)'
			} 
			
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(facility_level)	
				
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
				 
			*Create horizontal bar graph of facility level by country  
			betterbarci	c_*																										///
						,over(facility_level) barlab pct xoverhang scale(0.7) barcolor(edkblue eltblue ebblue)					///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%")  graphregion(color(white)) format(%9.1f)
			graph export "$EL_out/Final/Clinic_all.png", replace as(png)
	restore  
  
	preserve 
			*Restrict to only rural health facilities 
			keep if rural == 1
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				distinct facility_id	if cy == "`cry'"
				return list 
				local N_`cry' `r(ndistinct)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(facility_level)	
			
			*Create variable labels for each country 		
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
		 
		   *Create horizontal bar graph of facility level and rural clinics 
			betterbarci	c_*																										///
						,over(facility_level) barlab pct xoverhang scale(0.7) title("Rural") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Clinic_rural.gph", replace 
	restore 
	
	preserve 
			*Restrict to only urban health facilities 
			keep if rural == 0
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				distinct facility_id	if cy == "`cry'"
				return list 
				local N_`cry' `r(ndistinct)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(facility_level)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of facility level and urban clinics 
			betterbarci	c_* 																									///
						,over(facility_level) barlab pct xoverhang scale(0.7) title("Urban") barcolor(edkblue eltblue ebblue) 	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Clinic_urban.gph", replace 
	restore 		 
  
	*Combine both graphs to use the same legend 
	grc1leg ///
		"$EL_out/Final/Bar/Clinic_rural.gph" ///
		"$EL_out/Final/Bar/Clinic_urban.gph" ///
		,r(1) pos(12) imargin(0 0 0 0) 	///
		graphregion(color(white)) 
 	graph export "$EL_out/Final/Clinic_reg.png", replace as(png)
	}	

	/*****************************************
	Bar graph of staff gender by facility type 
	*******************************************/
	if $sectionF {	
   
	preserve 
			*Restrict to only hospitals  
			keep if facility_level == 1
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_male1)	
			
			*Create variable labels for each country 		
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
		 
		   *Create horizontal bar graph of provider occupation by country and rural clinics 
			betterbarci	c_*																											///
						,over(provider_male1) barlab pct xoverhang scale(0.7) title("Hospitals") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))		///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Gender_hos.gph", replace 
	restore 
 
	preserve 
			*Restrict to only health centers  
			keep if facility_level == 2
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_male1)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of provider occupation by country and urban clinics 
			betterbarci	c_* 																											///
						,over(provider_male1) barlab pct xoverhang scale(0.7) title("Health Centers") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 			///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Gender_hc.gph", replace 
	restore
	
	preserve 
			*Restrict to only health posts   
			keep if facility_level == 3
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_male1)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of provider occupation by country and urban clinics 
			betterbarci	c_* 																											///
						,over(provider_male1) barlab pct xoverhang scale(0.7) title("Health Posts") barcolor(edkblue eltblue ebblue) 	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 			///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Gender_hp.gph", replace 
	restore 		 
 
	*Combine both graphs to use the same legend 
	grc1leg ///
		"$EL_out/Final/Bar/Gender_hos.gph" ///
		"$EL_out/Final/Bar/Gender_hc.gph" ///
		"$EL_out/Final/Bar/Gender_hp.gph" ///
		,r(1) pos(12) imargin(0 0 0 0) 	///
		graphregion(color(white)) 
 	graph export "$EL_out/Final/Gender_fl.png", replace as(png)
	}	 	
	
	/***************************
	Pyramid of provider gender
	****************************/
	if $sectionG {	
 
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
	gen		gen_male		= 1	if provider_male1 == 1
	gen  	gen_female  	= 1 if provider_male1 == 0 
	gen		gen_male_per 	= gen_male 
	gen		gen_female_per 	= gen_female
	gen 	provider_cadre1_per = provider_cadre1
	
	*Create data frames for region graphs 
	frame copy default region_urban_per
	frame copy default region_rural_per
	frame change default 
	
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
		  All Countries - Percent of Providers
		*****************************************/
	 
		*Graph pyramind of providers by gender - Percentage 
		twoway	bar gen_male_per age_gr,horizontal bfc("20 100 131"*0.6)  ||			///
				bar gen_female_per age_gr, horizontal bfc("226 174 156"*0.6) ||			///	
				scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)		///
				xtitle("Percentage") ytitle("Age Group Number")				///
				ytitle("") yscale(noline) ylabel(none)									///
				graphregion(color(white)) 												///
				legend(label(1 Male Providers) label(2 Female Providers) label(3 "") region(col(white)))			///
				xlabel(-35 "35%" -30 "30%" -25 "25%" -20 "20%" -15 "15%" -10 "10%" -5 "5%" 0 "0" 					///
						35 "35%" 30 "30%" 25 "25%" 20 "20%" 15 "15%" 10 "10%" 5 "5%", angle(45) labsize(vsmall))			
		graph export "$EL_out/Final/Per_providers.png", replace as(png)  
	restore 

	/***************
		Doctors 
	***************/
	
	preserve  
		*Restrict to only doctors 
		keep if provider_cadre1 == 1
	
		*Collapse gender variables by age group 
		collapse	(count)  provider_cadre1			///
					(percent)  provider_cadre1_per		///
					,by(age_gr)	

		*Create a constant 
		gen zero = 0 	 
  
		*Graph pyramind of providers by gender - Percentage 
		twoway	bar provider_cadre1_per age_gr,horizontal bfc("20 100 131"*0.6)  ||		///
				scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)		///
				xtitle("Percentage") ytitle("Age Group Number")							///
				ytitle("") yscale(noline) ylabel(none)									///
				graphregion(color(white)) title("Doctors", color(black))				///
				xlabel(0 "0" 40 "40%" 35 "35%" 30 "30%" 25 "25%" 20 "20%" 15 "15%" 		///
				10 "10%" 5 "5%", angle(45) labsize(vsmall))								///
				legend(off)				
		graph export "$EL_out/Final/Pyramid/Per_providers_doc.png", replace as(png)
		graph save "$EL_out/Final/Pyramid/Per_providers_doc.gph", replace 
	restore 
 
	/***************
		Nurses 
	***************/

	preserve  
		*Restrict to only nurses 
		keep if provider_cadre1 == 3
	
		*Collapse gender variables by age group 
		collapse	(count)  provider_cadre1			///
					(percent)  provider_cadre1_per		///
					,by(age_gr)	

		*Create a constant 
		gen zero = 0 	 
	 
		*Graph pyramind of providers by gender - Percentage 
		twoway	bar provider_cadre1_per age_gr, horizontal bfc("226 174 156"*0.6) lcolor("226 174 156")  ||	///
				scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)							///
				xtitle("Percentage") ytitle("Age Group Number")												///
				ytitle("") yscale(noline) ylabel(none)														///
				graphregion(color(white)) title("Nurses", color(black))										///				
				xlabel(0 "0" 40 "40%" 35 "35%" 30 "30%" 25 "25%" 20 "20%" 15 "15%" 							///
				10 "10%" 5 "5%", angle(45) labsize(vsmall))													///
				legend(off)					
		graph export "$EL_out/Final/Pyramid/Per_providers_nurs.png", replace as(png) 
		graph save "$EL_out/Final/Pyramid/Per_providers_nurs.gph", replace 
	restore 	
  
	/****************************
		Other - Non-Doctors/Nurses
	****************************/
	
	preserve  
		*Relable cadre variable 
		labdtch 	provider_cadre1
		lab define  cad_lab 1 "Doctor" 3 "Nurse" 4 "Para-Professional"
		label val 	provider_cadre1 cad_lab

		*Restrict to only nurses 
		keep if provider_cadre1 == 4
	
		*Collapse gender variables by age group 
		collapse	(count)  provider_cadre1			///
					(percent)  provider_cadre1_per		///
					,by(age_gr)	

		*Create a constant 
		gen zero = 0 	 
 
		*Graph pyramind of providers by gender - Percentage 
		twoway	bar provider_cadre1_per age_gr,horizontal bfc("20 100 131"*0.6)  ||		///
				scatter age_gr zero, mlabel(age_gr) mlabcolor(black) msymbol(none)		///
				xtitle("Percentage") ytitle("Age Group Number")							///
				ytitle("") yscale(noline) ylabel(none)									///
				graphregion(color(white)) title("Para-Professional", color(black))		///
				xlabel(0 "0" 40 "40%" 35 "35%" 30 "30%" 25 "25%" 20 "20%" 15 "15%" 		///
				10 "10%" 5 "5%", angle(45) labsize(vsmall))								///
				legend(off)					
		graph export "$EL_out/Final/Pyramid/Per_providers_other.png", replace as(png)
		graph save "$EL_out/Final/Pyramid/Per_providers_other.gph", replace 
	restore 	
  
	/*******************************************
	Combine both graphs to use the same legend 
	******************************************/
	graph combine ///
		"$EL_out/Final/Pyramid/Per_providers_doc.gph" 		///
		"$EL_out/Final/Pyramid/Per_providers_nurs.gph" 		///
		"$EL_out/Final/Pyramid/Per_providers_other.gph" 	///
		,r(1) imargin(0 0 0) graphregion(color(white))  	///
		 note("Notes: These plots illustrate the proportion of provider age reported by their profession title. The proportion of doctors is defined as any provider who "" identified his/herself as doctor or medical officer. The proportion of nurses is any provider who identified his/herself as a nurse or midewife. The "" proportion of para-professional staff is defined as any provider who identified him/herself as any of the following: medical (nursing) assistants, "" patient aides, matrons, medical aides, radiographers, physiotherapists, environmental health officers, health surveillance assistants, and pharmacists.", size(vsmall))
	graph export "$EL_out/Final/Per_providers_occ.png", replace as(png)  	
	
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
			xtitle("Percentage") 													///
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
			xtitle("Percentage") 													///
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
	
	/***************************
	Fraction of female doctors 
	****************************/
	if $secitonH {	

	preserve 
	
		*Dont include Guinea Bissau given the small number of female doctors 
		drop if cy == "GNB_18"
	
		*Create an all doctors variable  	
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
		
		*Drop observatiobs with missing age 
		drop if missing(provider_age1)
		
		*Drop if age is over 60+
		drop if provider_age1> 60
		
		*Collapse to state level
		collapse	(mean)	med_fem_frac 	/// Share of medical officers 
					,by(cy_coded provider_age1)	
				
		*Create tick for max age  
		summ 	provider_age1
		gen		tick = 1 if provider_age1 == `r(max)'

		*Graph line graph of fraction female doctors by age percentile 
		 twoway ///
			 (histogram provider_age1, frac bin(18)  lw(med) fc(gs16) gap(10) yaxis(2)) || ///
			 (mspline med_fem_frac provider_age1 if cy_coded==2, lc(gs2) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==3, lc(gs3) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==4, lc(gs4) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==5, lc(gs5) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==6, lc(gs6) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==7, lc(gs7) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==8, lc(gs8) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==9, lc(gs9) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==10, lc(gs10) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==11, lc(gs11) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==12, lc(gs12) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1 if cy_coded==13, lc(gs13) lw(thin) lp(solid) yaxis(1)) ///
			 (mspline med_fem_frac provider_age1, lc(edkblue) lw(vvthick) lp(solid) yaxis(1)), 			///
			 yla(0 "0" .10 "10%" .20 "20%" .30 "30%" .40 "40%" .50 "50%" .60 "60%", angle(0) nogrid labsize(vsmall))	///
			 xla(15 "15" 25 "25" 35 "35" 45 "45" 55 "55", angle(0) nogrid labsize(vsmall)) 								///
			 yla(, axis(2) angle(0) nogrid labsize(vsmall))	yscale(alt) yscale(alt axis(2))								///
			 ytitle("Fraction of Female Doctors", size(small)) ytitle("Share of Age", axis(2) size(small)) 				///
			 graphregion(color(white)) xtit("Provider Age", size(small)) xscale(noli) yscale(noli) yscale(noli axis(2))	///
			 legend(off) bgcolor(white)																///
			text(.49 22 "Kenya '12", size(tiny)) text(.30 22 "Kenya '18", size(tiny))					///
			text(.42 23 "Madagascar", size(tiny)) text(.32 20 "Mozambique", size(tiny))					///
			text(.05 19 "Malawi", size(tiny)) text(0 22 "Niger", size(tiny))							///
			text(.13 19 "Nigeria", size(tiny)) text(.26 20 "Sierra Leone", size(tiny))					///
			text(.12 23 "Togo", size(tiny)) text(.20 22 "Tanzania '14", size(tiny))						///
			text(.28 18 "Tanzania '16", size(tiny)) text(.24 22 "Uganda", size(tiny)) 					///
			 note("Notes: These plots depict the fraction of female doctors in each country and overall. The fraction of female doctors is defined as "" the total number of female doctors divided by the total number of doctors in each health facility. The thick blue line plot represents "" the fraction of female doctors of all countries minus Guinea Bissau. Guinea Bissau is not include in this figure because it only has "" 2 female doctors in its country sample of 130 providers.", size(vsmall))
		 graph export "$EL_out/Final/Line plots/med_fem_frac.png", replace as(png)  
	restore 
}
	 	
	
********************************** End of do-file ************************************
