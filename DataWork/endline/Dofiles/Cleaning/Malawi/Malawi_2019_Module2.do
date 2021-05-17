* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Clean Malawi - Module 2 dataset	  		 			   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Clean module 2 version of dataset

       ** IDS VAR:       		fac_id interview__id      
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	April 1st 2021
 */

 
*****************************************************************************
* Preliminaries - Module 2 - Absenteeism
*****************************************************************************

	clear
	set more off

*****************************************************************************
* Clean Files
*****************************************************************************
	
	use		"$EL_dtDeID/Module2_Malawi_2019_deid.dta", clear  	
 
	rename 		Fcode fac_id
	tostring	fac_id, replace
	rename 		caseSimulation1__id provider_id
	tostring 	provider_id, replace
	isid 		fac_id provider_id
	sort 		fac_id provider_id
	
	
*****************************************************************************
* Adjust and Create Variables
*****************************************************************************

	gen 	has_roster = 1 if A214!=.
	gen 	has_absentee = 1 if A223!=.
	lab var has_roster "Provider was on roster during first visit"
	lab var has_absentee "Provider was included in absenteeism survey"
	
	*Create unique identifier
	tostring provider_id, replace
	tostring fac_id, replace
	gen		 unique_id = fac_id + "_" + provider_id
	lab var  unique_id "Unique provider identifier: facility ID + provider ID"
	lab var  fac_id 	"Facility unique identifier, as string"	
	lab var  provider_id "Provider unique identifier, as string"

	*Create country variable
	gen country = "MALAWI"
	gen year 	= 2019
	 
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
	recode 	A219 A221 A223 B207 HF7_Q409 HF7_Q411 (2=0) (.a =.)
	
	*Recode .a to missing variable 
	recode A220 HF7_Q408 HF7_Q410 (.a =.)
 	
	*Recode activity variable 
	recode B209 (99=9)
	
	*Recode provider post 
	recode A310 (4/7 10 =9) (8=4) (9=5)
	
	*Create reason absent variable 
	gen		absent_reason = . 
	replace absent_reason = 1	if B208__1 == 1 
	replace absent_reason = 2	if B208__2 == 1
	replace absent_reason = 3	if B208__3 == 1
	replace absent_reason = 4	if B208__4 == 1
	replace absent_reason = 5	if B208__5 == 1
	replace absent_reason = 6	if B208__6 == 1
	replace absent_reason = 7	if B208__7 == 1
	replace absent_reason = 8	if B208__8 == 1
	replace absent_reason = 9	if B208__9 == 1
	replace absent_reason = 10	if B208__10 == 1
	replace absent_reason = 12	if B208__11 == 1
	replace absent_reason = 99	if B208__99 == 1
	
	*Adjust provider cadre - 2
	recode	A312 (2/3 =1) (5 =2) (7/12 =3) (4 16/19 = 4)
	lab 	val A312 cadrelab 
	
	*Adjust provider education - 2
	recode	A311 (2/3 =2) (4/7=3) (9 .a=.) //education
	lab 	val A311 educlab
	
	*Destring variables 
	destring B206, replace force 
 
	*Create salary delayed variable 
	gen 	sala_delay = 0 
	replace sala_delay = 1 if HF7_Q408!=0
	replace sala_delay = . if HF7_Q408 ==.
	
	gen 	sala_delay_reas = 1	if HF7_Q412__1 == 1
	replace sala_delay_reas = 2 if HF7_Q412__2 == 1
	replace sala_delay_reas = 3 if HF7_Q412__3 == 1
	replace sala_delay_reas = 4 if HF7_Q412__4 == 1
	replace sala_delay_reas = 5 if HF7_Q412__5 == 1
	replace sala_delay_reas = 6 if HF7_Q412__6 == 1
	
	lab 	def reaslab 1 "Lack of funds" 2 "Systemic delay/Administrative problem"	///
						3 "Salary withheld to service outstanding debts" 			///
						4 "Non-payment was not explained" 							///
						5 "Related to performance/absence" 6 "Other"
	lab 	val sala_delay_reas reaslab
	
	*Recode contract type variable 
	recode A217 (4=5) (.a=.)
	
	*Recode who pays for salary 
	recode A216 (3=5)
	
	*Calculate annual salary 
	gen	annual_salary = HF7_Q402 * 12
	
	/***************************************
	Harmoninze modules with iecodebook
	***************************************/
 	
	*Apply codebook exel with updated variable names and labels 
	applyCodebook using "$EL/Documentation/Codebooks/Malawi 2019/malawi-2019_module2_codebook.xlsx", varlab rename `haslab' sheet("Sheet1") 	
 
	*Keep only the variables need for module 2
	keep	facility_id provider_id provider_educ2 provider_cadre2	///
			provider_mededuc1 provider_cadre1 salary_from 			///
			provider_contract provider_educ1 provider_male1 		///
			provider_age1 is_outpatient provider_present1 			///
			year_started provider_present2 absent_other1 			///
			provider_activity provider_activityoth salary_date 		///
			salary_delaylen salary_got salary_delaylen2 			///
			salary_got2 num_staff num_med num_nonmed has_roster 	///
			has_absentee provider_post1 unique_id country 			///
			year absent_reason1 salary_delay salary_reason 			///
			salary_amt
 
	*Save harmonized dataset
	isid 	unique_id
	sort 	unique_id
	order 	country year unique_id facility_id provider_id
	save 	"$EL_dtInt/Module 2/Malawi_2019_mod_2.dta", replace 

********************** End of do-file *********************************************
