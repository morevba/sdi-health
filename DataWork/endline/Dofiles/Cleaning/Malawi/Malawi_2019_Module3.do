* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Clean Malawi - Module 3 dataset	  		 			   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Clean module 3 version of dataset

       ** IDS VAR:      		 fac_id interview__id      
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	April 5th 2021
 */

  	
*****************************************************************************
* Preliminaries - Module 3 - Vignettes
*****************************************************************************

	clear
	set more off

*****************************************************************************
* Clean File
*****************************************************************************

	*Open vignettes module 
	use			"$EL_dtDeID/Module2_Malawi_2019_deid.dta", clear  	
 
	rename 		Fcode fac_id
	tostring	fac_id, replace
	rename 		caseSimulation1__id provider_id
	tostring 	provider_id, replace
	isid 		fac_id provider_id
	sort 		fac_id provider_id
	
	*Create unique identifier
	tostring 	provider_id, replace
	tostring 	fac_id, replace
	gen		 	unique_id = fac_id + "_" + provider_id
	lab var  	unique_id "Unique provider identifier: facility ID + provider ID"
	lab var  	fac_id 	"Facility unique identifier, as string"	
	lab var  	provider_id "Provider unique identifier, as string"
	
*****************************************************************************
* Adjust and Create Variables
*****************************************************************************
	
	gen has_vignette = 1
	lab var has_vignette "Provider completed vignette module"

	*Create country variable
	gen country = "MALAWI"
	gen year 	= 2019

	*Adjust rural-urban
	gen 	rural = (Resid == 1)
	lab var rural "Rural"

	*Adjust facility classification
	rename 	Ftype_analysis	facility_level
	recode 	facility_level (5=3) (4=2) 
	lab 	define factypelab 1 "Hospital" 2 "Health Center" 3 "Health Post"
	lab val facility_level factypelab
	lab var facility_level "Facility level"
	
	*Public/private
	gen 	public = (Mowner_analysis == 1) 
	lab var public "Public"

	/*****************************************
	Rename key variables 
	******************************************/
	
	*Adjust provider cadre - 1
	recode	A215 (2/3 = 1) (5 =2) (7/9 11/12 17 23/24 =3) (4 10 13/16 18/22 25/99 = 4)
	lab 	def cadrelab 1 "Doctor" 2 "Clinical Officer" 3 "Nurse" 4 "Other"
	lab 	val A215 cadrelab 
	
	*Adjust provider education - 1
	recode	A218 (0 1 100=1) (2/3 44=2) (4/7=3) (9 .a=.) //education
	lab 	def educlab 1 "Primary" 2 "Secondary" 3 "Post-Secondary" 
	lab 	val A218 educlab

	*Adjust provider medical education - 1
	recode	A313 (3/5=3) (6/7=4) (9 .a =.) // medical education
	lab 	def mededuclab 1 "None" 2 "Certificate" 3 "Diploma" 4 "Advanced"
	lab 	val A313 mededuclab
	
	*Recode Nos to zeroes variable 
	recode 	A219 (2=0) (.a =.)
	
	*Recode .a to missing variable 
	recode	A220 (.a =.)
	
	*Recode consult variable 
	recode	A314 (.=0)
	
	*Recode activity variable 
	recode B209 (99 =9)
	
	*Format time and date variables 
	split	B_Q1, p("T")  gen(B_Q1_) 
	split   B_Q1_2, p(":")
	rename  B_Q1_21	B_Q1_21_hr 
	rename  B_Q1_22	B_Q1_22_mn
	
	split	B_Q70, p("T")  gen(B_Q70_) 
	split   B_Q70_2, p(":")
	rename  B_Q70_21 B_Q70_21_hr 
	rename  B_Q70_22 B_Q70_22_mn
	
	split	C_Q1, p("T")  gen(C_Q1_) 
	split   C_Q1_2, p(":")
	rename  C_Q1_21	C_Q1_21_hr 
	rename  C_Q1_22	C_Q1_22_mn
	
	split	C_Q61, p("T") gen(C_Q61_) 
	split   C_Q61_2, p(":")
	rename  C_Q61_21 C_Q61_21_hr 
	rename  C_Q61_22 C_Q61_22_mn
	
	split	D_Q1, p("T")  gen(D_Q1_) 
	split   D_Q1_2, p(":")
	rename  D_Q1_21	D_Q1_21_hr 
	rename  D_Q1_22	D_Q1_22_mn
	
	split	D_Q58, p("T") gen(D_Q58_) 
	split   D_Q58_2, p(":")
	rename  D_Q58_21 D_Q58_21_hr 
	rename  D_Q58_22 D_Q58_22_mn
	
	split	AE_Q1, p("T") gen(AE_Q1_) 
	split   AE_Q1_2, p(":")
	rename  AE_Q1_21	AE_Q1_21_hr 
	rename  AE_Q1_22	AE_Q1_22_mn
	
	split	AE_Q98, p("T") gen(AE_Q98_) 
	split   AE_Q98_2, p(":")
	rename  AE_Q98_21 AE_Q98_21_hr 
	rename  AE_Q98_22 AE_Q98_22_mn
	
	split	E_Q1, p("T")  gen(E_Q1_) 
	split   E_Q1_2, p(":")
	rename  E_Q1_21	E_Q1_21_hr 
	rename  E_Q1_22	E_Q1_22_mn
	
	split	E_Q57, p("T") gen(E_Q57_) 
	split   E_Q57_2, p(":")
	rename  E_Q57_21 E_Q57_21_hr 
	rename  E_Q57_22 E_Q57_22_mn
	
	split	F_Q1, p("T")  gen(F_Q1_) 
	split   F_Q1_2, p(":")
	rename  F_Q1_21	F_Q1_21_hr 
	rename  F_Q1_22	F_Q1_22_mn
	
	split	F_Q80, p("T") gen(F_Q80_) 
	split   F_Q80_2, p(":")
	rename  F_Q80_21 F_Q80_21_hr 
	rename  F_Q80_22 F_Q80_22_mn
	
	split	G_Q1, p("T")  gen(G_Q1_) 
	split   G_Q1_2, p(":")
	rename  G_Q1_21	G_Q1_21_hr 
	rename  G_Q1_22	G_Q1_22_mn
	
	split	G_Q58, p("T") gen(G_Q58_) 
	split   G_Q58_2, p(":")
	rename  G_Q58_21 G_Q58_21_hr 
	rename  G_Q58_22 G_Q58_22_mn
	
	split	I_Q1, p("T")  gen(I_Q1_) 
	split   I_Q1_2, p(":")
	rename  I_Q1_21	I_Q1_21_hr 
	rename  I_Q1_22	I_Q1_22_mn
	
	split	I_Q34, p("T") gen(I_Q34_) 
	split   I_Q34_2, p(":")
	rename  I_Q34_21 I_Q34_21_hr 
	rename  I_Q34_22 I_Q34_22_mn
	
	
	*Capture whether vignette was skipped
	foreach z in "B" "C" "D" "AE" "E" "F" "G" "I" {
		ds 		`z'_Q*, has(type numeric)
		local 	vl "`r(varlist)'"
		egen 	did_v`z' = anycount(`vl'), val(1 3)
		gen 	missing_v`z' = 1 if did_v`z' == 0
		replace missing_v`z' = 0 if missing_v`z' == .
		drop	did_v`z'
	} 

	*Recode values that were answered "After" 
	findname, vallabeltext("After")
	quietly foreach v of varlist `r(varlist)' {
		recode `v' (2=0)
		recode `v' (3=.)
	}
 	
	*Remove observations that are missing all vignettes
	egen	number_missing = anycount(missing_v*), val(1)
	tab 	number_missing 
	drop if number_missing==6  //12 observations were dropped
 
	/***************************************
	Harmoninze modules with iecodebook
	***************************************/
 
	*Modify provider level characteristics data
	applyCodebook using "$EL/Documentation/Codebooks/Malawi 2019/malawi-2019_module3_codebook.xlsx", varlab rename vallab sheet("General")
	
	*Create a local for each disaease 
	local diseases	Diarrhea Pneumonia Diabetes TB Malaria PPH Asphyxia Pregnant
		foreach disease in  `diseases' {
		
			applyCodebook using "$EL/Documentation/Codebooks/Malawi 2019/malawi-2019_module3_codebook.xlsx", varlab rename vallab sheet("`disease'")
			
			local lowerdisease = lower("`disease'")
			foreach x in "history" "exam" "test" "diag" "treat" "educate" "refer" "action" "stop" "failed" {
				cap rename `x'* `lowerdisease'_`x'*
			}
		}
		
	*Clean certain variables 
	replace year_hired = "" if year_hired == "##N/A##"
	
	*Destring variables 
	destring start_* end_* year_hired, replace  

	*Drop unwamted variables 
	drop	A1* AA* A3* newfacility Zonename Dist Ftype Resid Mowner*	///
			A2* B2* HF7_Q4* K_Q3_* A_comments B_* C_* D_* E_* F_* G_* 	///
			I_* AE_* AB* J_* sssys_irnd comment interview__status 		///
			ssSys_IRnd EndSectionK_* StartSectionK* SecK_HW_* 			///
			interview__key K_* staff_survey_q 
	
	*Save harmonized dataset
	isid 	unique_id
	sort 	unique_id
	order 	country year unique_id facility_id provider_id
	save	"$EL_dtInt/Module 3/Malawi_2019_mod_3.dta", replace 

************************** End of do-file **************************************
