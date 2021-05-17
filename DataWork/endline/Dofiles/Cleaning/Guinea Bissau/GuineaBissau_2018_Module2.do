* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Clean Guinea Bissau - Module 2 dataset	   			   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Clean module 2 version of dataset

       ** IDS VAR:     fac_id interview__id        
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: Feb 10th 2021
 */

*****************************************************************************
* Preliminaries - Module 2 - Absenteeism
*****************************************************************************

	*Open merged Guinea Bissau dataset  
	use	"$EL_dtDeID/Module124_GuineaBissau_2018_deid.dta", clear  	

*****************************************************************************
* Clean Files
*****************************************************************************
	
	
	*Clean up facility id variables 
	rename		M1_A_6 fac_id
	tostring	fac_id, replace
	drop if 	fac_id == "" // these are missig surveys -  
	*isid 		fac_id	// fac_id is not unique in this dataset 
	sort fac_id
	
	*Create a staff id variables 
	bysort		fac_id (interview__id):	gen	 staff_id = _n
	tostring	staff_id, replace
	isid 		fac_id staff_id
	sort 		fac_id staff_id
	
*****************************************************************************
* Adjust and Create Variables
*****************************************************************************

	*Gen has facility variable
	gen 	has_facility = 1 if fac_id!="" | fac_id!="."
	lab var has_facility "Facility was included in infrastructure-supplies survey"

	*Create unique identifier
	tostring 	fac_id, replace 
	lab var		fac_id "Facility unique identifier, as string"	
		
	*Create country variable
	gen country = "GUINEABISSAU"
	gen year = 2018
 
	*Adjust rural-urban
	rename 	M1_A_7 location
	lab var	location "Urban/Rural"
 
	*Adjust facility classification
	recode	M1_B_8 (5/6=1)  (1/4=2) 
	lab 	define factypelab 1 "Hospital" 2 "Health Center" 3 "Health Post"
	lab 	val M1_B_8 factypelab // 132 facilities are missing 

	gen 	has_roster 		= 1 if M1_A_11b!=""
	gen 	has_absentee	= 1 if M4_A_26==1
	lab var has_roster 		"Provider was on roster during first visit"
	lab var has_absentee 	"Provider was included in absenteeism survey"
 
	*Create unique identifier
	tostring 	staff_id, replace
	tostring 	fac_id, replace
	gen 		unique_id = fac_id + "_" + staff_id
	lab var 	unique_id 	"Unique provider identifier: facility ID + provider ID"
	lab var 	fac_id 		"Facility unique identifier, as string"	
	lab var 	staff_id 	"Provider unique identifier, as string"

	*Adjust provider cadre
	recode	M1_B_3 (1/4=1) (5/6=2) (7/8=3) (9=4) (99=4) //cadre
	lab 	def cadrelab 1 "Doctor" 2 "Clinical Officer" 3 "Nurse" 4 "Other"
	lab 	val M1_B_3 cadrelab
  
	*Keep the variables needed for module 2 
	keep	interview__id fac_id location staff_id	///
			has_facility country year has_roster has_absentee unique_id M2_*  
 			
	/********************************************************************************
	There are module 2 variables in the mod 3 dataset so they need to be merged to 
	the mod 2 dataset before creating a final clean version 
	*******************************************************************************/
  	
	preserve 
		*Open mod 3 dataset 
		use "$EL_dtDeID/Module3_GuineaBissau_2018_deid.dta", clear  
		
		*Keep Mod 2 variables and key identifiers 
		keep interview__id M2_* 
		
		*Delete duplicates before merge 
		bysort 	interview__id: gen pr_dup = cond(_N==1,0,_n)
		fre 	pr_dup
		drop if pr_dup>1	// this drops 105 obs
		drop	pr_dup 		// variable is not needed anymore 
 
		*Sort identifier variable 
		isid interview__id
		sort interview__id
 
		*Create and save tempfile
		tempfile 	mod2_vars
		save		`mod2_vars'
	restore 
 	
	*Merge Mod 2 variables to the Mod 2 dataset 
	sort	interview__id fac_id
	merge	1:1 interview__id using "`mod2_vars'"
	drop 	_merge 		// this variable is not needed anymore  
 
	*Recode variables
	recode  M2_A_12 M2_A_10 M2_B_8 M2_B_13 M2_B_10 M2_A_16 (2=0) 
 
	/***************************************
	Harmoninze modules with iecodebook
	***************************************/

	*Modify facility general characteristics variables
		preserve
			import excel using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module2_codebook.xlsx", firstrow sheet("General") clear
			tab vallab
			if `r(N)'==0 local haslab = ""
			if `r(N)'>0 local haslab = "vallab"
		restore
 	
	*Modify provider level characteristics data
	applyCodebook using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module2_codebook.xlsx", varlab rename `haslab' sheet("General")
	
	*Recode provider level characteristics 
	recode	provider_mededuc1 (1=3) (2 7 =4) (3=3) (4/5 8=2) (99 9=.) // medical education
	lab 	def mededuclab 1 "None" 2 "Certificate" 3 "Diploma" 4 "Advanced"
	lab 	val  provider_mededuc1 mededuclab
	
	recode	provider_mededuc2 (2 6=3) (3/5 7/8 =2) (99 9=.) // medical education
	lab 	val  provider_mededuc2 mededuclab
	
	recode	provider_educ1 provider_educ2 (1/2=1) (3/4=2) (5/8=3) (99 0=.) //education
	lab 	val provider_educ1 provider_educ2 educlab
	
	recode	provider_cadre1 provider_cadre2 (1/5=1) (7/16=3) (99=4) // occupation 
	lab 	val provider_cadre1 provider_cadre1 cadrelab
	
	recode	provider_male1 provider_male2 (2=0) (.a=.)
	lab 	def gender_pr 0 "Female" 1 "Male" 
	lab 	val  provider_male1 provider_male2 gender_pr
 	 
	*Drop unwanted variables specify other variables
	drop	M2_B_6_esp M2_B_5_esp M2_B_4_esp M2_B_3_esp M2_B_2a M2_A_20	///
			M2_A_19 M2_A_14_esp M2_A_13_esp M2_A_9_esp M2_A_8_esp 		///
			M2_A_7_esp M2_A_4a 
  
	*Drop missing surveys 
	drop if  num_staff == .
	
	*Save final file
	isid 	unique_id
	sort 	interview__id
	order 	country year unique_id facility_id provider_id
	
	*Save harmonized dataset 
	save "$EL_dtInt/Module 2/GuineaBissau_2018_mod_2.dta", replace  

************************ End of do-file *********************************************
