* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	GIS Mapping											   *
*				Facility ID											   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create maps of facility level GPS points 

       ** IDS VAR: country year facility_id  
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	Feb 10th 2021
	   
*****************************************************************/

/*****************************************
	Restrict Facility ID to each country 
*****************************************/

	*Open final facility level dataset 
	use "$EL_dtFin/Final_pl.dta", clear  

	*Restrict to only Kenya coordinates 
	keep if country == "KENYA"

	*Create rural indicate 
	gen			rural = 1 if fac_type == 1 | fac_type == 2 | fac_type == 3
	replace 	rural = 0 if fac_type == 4 | fac_type == 5 | fac_type == 6
	lab define  rur_lab 1 "Rural Health Facility" 0 "Urban Health Facility"
	label val 	rural rur_lab 

	gen			rural2 = 0 if fac_type == 1 | fac_type == 2 | fac_type == 3
	replace 	rural2 = 1 if fac_type == 4 | fac_type == 5 | fac_type == 6
	lab define  rur2_lab 0 "Rural Health Facility" 1 "Urban Health Facility"
	label val 	rural2 rur2_lab 

	gen 		rural_1 = 1 if rural == 1 
	gen 		urban_1 = 1 if rural == 0
	lab define  rural_1_lab 1 "Rural Health Facility" 
	lab define  urban_1_lab 1 "Urban Health Facility" 
	label val 	rural_1 rural_1_lab 
	label val 	urban_1 urban_1_lab 

	*Keep key variables need for mapping 
	keep unique_id rural rural2 rural_1 urban_1 facility_level gpslat_all gpslong_all 

	*Rename Unique ID variable 
	rename unique_id ID

	*Save GPS dataset 
	save "$EL_dtInt/GIS maps/GIS_pl_kenya.dta", replace  

/**********************************************
	Convert shape files to dta files 
***********************************************/	
	
	*Convert shapefile to Stata datafile for Kenya Adminstrative area
	shp2dta using "$EL_dtDeID/GIS/KEN_adm2.shp", ///
				database("$EL_dtInt/GIS maps/KEN_adm2.dta") ///
				coordinates ("$EL_dtInt/GIS maps/KEN_adm2_coor.dta") ///
				genid(ID) replace 

	*Convert shapefile to Stata datafile for Kenya roads
	shp2dta using "$EL_dtDeID/GIS/KEN_roads.shp", ///
				database("$EL_dtInt/GIS maps/KEN_roads.dta") ///
				coordinates ("$EL_dtInt/GIS maps/KEN_roads_coor.dta") ///
				genid(ID) replace 	
				
	*Convert shapefile to Stata datafile for Kenya popultation density 
	shp2dta using "$EL_dtDeID/GIS/ke_popd89lmb.shp", ///
				database("$EL_dtInt/GIS maps/ke_popd89lmb.dta") ///
				coordinates ("$EL_dtInt/GIS maps/ke_popd89lmb_coor.dta") ///
				genid(ID) replace 	
				
/**********************************************
	Create GEO Spatial maps of Kenya 
***********************************************/	
	
spmap using "$EL_dtInt/GIS maps/KEN_adm2_coor.dta", id(ID) 								///
	  line(data("$EL_dtInt/GIS maps/KEN_roads_coor.dta") co(gs9))						///
	  point(x(gpslong_all) y(gpslat_all) data( "$EL_dtInt/GIS maps/GIS_pl_kenya.dta") 	///
	  by(rural2) size(vtiny vtiny) oc(gold red) os(vthin vthin) fc(gold red) 	///
	  legenda(on) legcount legtitle("Legend")) 
exit 	  

*graph save "$EL_out/Final/Kenya_facility.gph", replace 	  
graph save "$EL_out/Final/Kenya_clinic_rur.gph", replace 	  
graph save "$EL_out/Final/Kenya_clinic_urb.gph", replace 	
graph save "$EL_out/Final/Kenya_clinic_reg.gph", replace	   		

*Combine all 3 graphs 			
graph combine 									///
		"$EL_out/Final/Kenya_clinic_urb.gph" 	///
		"$EL_out/Final/Kenya_clinic_rur.gph" 	///
		"$EL_out/Final/Kenya_clinic_reg.gph" 	///
		"$EL_out/Final/Kenya_facility.gph"		///
	,altshrink  graphregion(color(white)) 
graph export "$EL_out/Final/Kenya_clinic_reg_cb.png", replace as(png)
	
******************************* End of do-file *****************************
