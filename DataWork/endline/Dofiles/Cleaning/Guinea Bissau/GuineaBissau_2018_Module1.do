* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Clean Guinea Bissau - Module 1 dataset	   			   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Clean module 1 version of dataset

       ** IDS VAR:       fac_id interview__id      
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: Feb 3rd 2021
 */

*****************************************************************************
* Preliminaries - Module 1 - Facility Infrastructure and Supplies
*****************************************************************************

	*Open merged Guinea Bissau dataset  
	use	"$EL_dtDeID/Module124_GuineaBissau_2018_deid.dta", clear  	
 
	*Clean up facility id variables 
	rename		M1_A_6 fac_id
	tostring	fac_id, replace
	drop if 	fac_id == "" // these are missig surveys -  
	*isid 		fac_id	// fac_id is not unique in this dataset 
	sort fac_id

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
	gen year 	= 2018

	*Adjust rural-urban
	rename 	M1_A_7 location
	lab var	location "Urban/Rural"
 
	*Adjust facility classification
	recode	M1_B_8 (5/6=1)  (1/4=2) 
	lab 	define factypelab 1 "Hospital" 2 "Health Center" 3 "Health Post"
	lab 	val M1_B_8 factypelab // 132 facilities are missing 
 
	*Adjust region variable
	decode 		M1_A_3, gen(M1_A_3_string)	
	decode 		M1_A_3b, gen(M1_A_3b_string)
	
	*Format date variable 
	split	M1_A_10, p("-")
	rename	M1_A_101	M1_A_10_year
	rename  M1_A_102	M1_A_10_month
	rename  M1_A_103	M1_A_10_day 

	split	M1_A_14, p("-")
	rename	M1_A_141	M1_A_14_year
	rename  M1_A_142	M1_A_14_month
	rename  M1_A_143	M1_A_14_day 
	
	split	M1_A_12, p("T")
	split	M1_A_122, p(":")
	rename 	M1_A_1221	M1_A_12_hour
	rename  M1_A_1222	M1_A_12_minute
	
	
	split	M1_A_13, p("T")
	split	M1_A_132, p(":")
	rename 	M1_A_1321	M1_A_13_hour
	rename  M1_A_1322	M1_A_13_minute
	
	split	M1_A_16, p("T")
	split	M1_A_162, p(":")
	rename 	M1_A_1621	M1_A_16_hour
	rename  M1_A_1622	M1_A_16_minute
	
	split	M1_A_17, p("T")
	split	M1_A_172, p(":")
	rename 	M1_A_1721	M1_A_17_hour
	rename  M1_A_1722	M1_A_17_minute
	
	*Format time variables 
	split	M1_B_10, p("h")
	rename 	M1_B_101	M1_B_10_hour
	rename  M1_B_102	M1_B_10_minute
	
	split	M1_B_39, p("h")
	rename 	M1_B_391	M1_B_39_hour
	rename  M1_B_392	M1_B_39_minute
	
	split	M1_C_8, p("h")
	rename 	M1_C_81	M1_C_8_hour
	rename  M1_C_82	M1_C_8_minute
	
	split	M1_C_10, p("h")
	rename 	M1_C_101	M1_C_10_hour
	rename  M1_C_102	M1_C_10_minute
	
	*Destring some variables 
	destring	M1_A_11d M1_A_11b M1_A_18d M1_A_10_* M1_A_14_* 	///
				M1_A_13_hour M1_A_13_minute M1_A_12_hour 		///
				M1_A_12_minute M1_A_16_hour M1_A_16_minute		///
				M1_A_17_hour M1_A_17_minute M1_B_10_hour 		///
				M1_B_10_minute M1_C_8_hour M1_C_8_minute		///
				M1_C_10_hour M1_C_10_minute M1_B_39_hour 		///
				M1_B_39_minute, replace 
				
	*Create total distance variable 
	egen		M1_B_10_total = rowtotal(M1_B_10_hour M1_B_10_minute)
  
	*Recode variables
		*missing values
			ds *, has(type numeric)
			foreach v of varlist `r(varlist)' {
				recode `v' (-9=.b) (-99=.b) (-999=.b) (-99999=.b)
			}
 
		*Yes-No questions
			findname, vallabeltext("Yes")
			quietly foreach v of varlist `r(varlist)' {
				recode `v' (2=0)
			}

			*recode m1sbq96 (2=0)
			*lab drop M1SBQ96

		*Observed-not observed questions
			findname, vallabeltext("Yes and observed")
			quietly foreach v of varlist `r(varlist)' {
				recode `v' (3/4=0) (2=1) (1=2)
			}
 
			findname, vallabeltext("Yes-guides observed")
			quietly foreach v of varlist `r(varlist)' {
				recode `v' (3=0) (2=1) (1=2)
			}

			quietly foreach v of varlist M4_A_19 {
				recode `v' (3=0) (2=1) (1=2)
			}
 
		*Fridge temp
		*	replace m1sbq50a = m1sbq50a + m1sbq50b/10

		*Fridge power source
			recode M1_E_68 (4=5) (5=6)
 
		*Drug availability variables
			foreach v of varlist  M1_E_69-M1_E_81 {
				recode `v' (3=4)
			}	

	*Save cleaned Module 1 dataset 
	*isid 	fac_id	// does not unique idenitify in this dataset 
	sort 	fac_id
	order 	country year fac_id
	
	*Keep only completed surveys 
	drop if M1_A_18a == 1 | M1_A_18a == 2 | M1_A_18a == 3
	
	*Drop health facilities that did not give consent and is a duplicate 
	bysort 	fac_id: gen fac_dup = cond(_N==1,0,_n)
	
	*Investigate duplicates - some of them are completely empty surveys 
	drop if fac_dup > 0 & I_1 == .	// 12 obs were dropped - all missing survey  
	
	*Examine remaining duplicates now
	drop 	fac_dup
	bysort 	fac_id: gen fac_dup = cond(_N==1,0,_n)
	drop 	if fac_dup > 0 // Drop all duplicates now because it's hard to descern which survey to keep and which to drop 
							// this drops 2 obs
 
	*Keep only module 1 variables 
	keep 	country country year fac_id interview__id location I_1 I_2 totalStaff	///
			cutOff cutOff13 cor_teste _merge has_facility M1_* M1_A_3_string 		///
			M1_A_3b_string M1_A_10_* M1_A_14_* M1_B_10_* M1_C_8_hour M1_C_8_minute 	///
			M1_A_12_hour M1_A_12_minute M1_A_13_hour M1_A_13_minute 				///
			M1_A_16_hour M1_A_16_minute M1_A_17_hour M1_A_17_minute M1_B_10_hour 	///
			M1_B_10_minute M1_C_10_hour M1_C_10_minute M1_B_39_minute M1_B_39_hour	///
			gpslong_all	gpslat_all
 	
	/***************************************
	Harmoninze modules with iecodebook
	***************************************/

	*Modify facility general characteristics variables
		preserve
			import excel using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module1_codebook.xlsx", firstrow sheet("General") clear
			tab vallab
			if `r(N)'==0 local haslab = ""
			if `r(N)'>0 local haslab = "vallab"
		restore
	
	*Apply codebook exel with updated variable names and labels 
	applyCodebook using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module1_codebook.xlsx", varlab rename `haslab' sheet("General")
	
	*Modify infrastructure-services variables
	applyCodebook using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module1_codebook.xlsx", varlab rename vallab sheet("Infrastructure")

	*Modify drugs-supplies-tests-vaccines variables
	applyCodebook using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module1_codebook.xlsx", varlab rename vallab sheet("Drugs-Vaccines") 
 
  
	drop	M1_A_121 M1_A_122 M1_A_1223 M1_A_131 M1_A_132 M1_A_1323 M1_A_161	///
			M1_A_162 M1_A_1623 M1_A_171 M1_A_172 M1_A_1723 M1_A_8b M1_A_10		///
			M1_A_12 M1_A_14 M1_A_16 M1_B_3_esp M1_B_4_esp M1_B_5_esp 			///
			M1_B_6_esp M1_B_7_esp M1_B_8_esp M1_B_10 M1_B_38 M1_B_39 M1_C_1_esp	///
			M1_C_3 M1_C_5a M1_C_5b__9 M1_C_5b__1 M1_C_5b__2 M1_C_5b__3			///
			M1_C_6_esp M1_C_8 M1_C_10 M1_C_11_esp M1_C_11a M1_C_14a				///
			M1_C_14b_esp M1_C_17_esp M1_C_20_esp M1_C_33_esp M1_C_36_esp M1_D_8	///
			M1_C_33__9 M1_E_64 M1_A_13 M1_A_17 M1_A_18a M1_A_18b M1_D_17 		///
			M1_D_27 M1_D_37 M1_D_47 M1_E_942 M1_E_945 M1_E_952 M1_E_953 		///
			M1_E_954 M1_E_39 M1_E_310 M1_E_315 M1_E_316 M1_E_117 M1_E_317 		///
			M1_E_318 M1_E_119 totalStaff cutOff cutOff13 cor_teste _merge interview__id
	 		
	*Save harmonized dataset 
	save "$EL_dtInt/Module 1/GuineaBissau_2018_mod_1.dta", replace 

********************** End of do-file *********************************************
