* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Clean Guinea Bissau - Module 3 dataset	   			   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Clean module 3 version of dataset

       ** IDS VAR:     fac_id interview__id        
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: Feb 10th 2021
 */


*****************************************************************************
* Preliminaries - Module 3 - Vignettes
*****************************************************************************

	*Open module 3 dataset 
	use "$EL_dtDeID/Module3_GuineaBissau_2018_deid.dta", clear  
  
*****************************************************************************
* Adjust and Create Variables
*****************************************************************************
	
	*Create vignettes variable 
	gen 	has_vignette = 1
	lab var has_vignette "Provider completed vignette module"

	*Create country variable
	gen country = "GUINEABISSAU"
	gen year 	= 2018

	*Adjust provider cadre
	recode	M3_A_7 M2_A_7 M2_B_4 (1/5=1) (11=2) (8/9=3) (15/16=3) (99=4) //cadre
	recode	M3_A_5 (1/4=1) (6=2) (7/8=3) (99 9=4) //cadre
	lab 	def cadrelab 1 "Doctor" 2 "Clinical Officer" 3 "Nurse" 4 "Other"
	lab 	val M3_A_7 M2_A_7 M2_B_4 M3_A_5 cadrelab

	*Adjust provider education
	recode	M3_A_6 M2_A_8 M2_B_5 (1/2=1) (3/4=2) (5/7=3) (99=.c) //education
	lab 	def educlab 1 "Primary" 2 "Secondary" 3 "Post-Secondary" 
	lab 	val M3_A_6 M2_A_8 M2_B_5 educlab

	*Adjust provider medical education
	recode	M3_A_8 M2_A_9  (1/2=4) (3 7 =3) (4/5 8/9=2) (99=.c) // medical education
	recode	M2_B_6  (1=4) (2 6 =3) (3/5 7/8 =2) (99=.) // medical education
	lab 	def mededuclab 1 "None" 2 "Certificate" 3 "Diploma" 4 "Advanced"
	lab 	val M3_A_8 M2_A_9 M2_B_6 mededuclab
	
	*Format time variables 
	split	inicio_D_1, p("T")
	split	inicio_D_12, p(":")
	rename 	inicio_D_121	inicio_D_121_hour
	rename  inicio_D_122	inicio_D_122_minute
	
	split	end_case1, p("T")
	split	end_case12, p(":")
	rename 	end_case121	end_case121_hour
	rename  end_case122	end_case122_minute
	
	split	inicio_D_2, p("T")
	split	inicio_D_22, p(":")
	rename 	inicio_D_221	inicio_D_221_hour
	rename  inicio_D_222	inicio_D_222_minute
	
	split	end_case2, p("T")
	split	end_case22, p(":")
	rename 	end_case221	end_case221_hour
	rename  end_case222	end_case222_minute
	
	split	inicio_D_3, p("T")
	split	inicio_D_32, p(":")
	rename 	inicio_D_321	inicio_D_321_hour
	rename  inicio_D_322	inicio_D_322_minute
	
	split	end_case3, p("T")
	split	end_case32, p(":")
	rename 	end_case321	end_case321_hour
	rename  end_case322	end_case322_minute
	
	split	inicio_D_4, p("T")
	split	inicio_D_42, p(":")
	rename 	inicio_D_421	inicio_D_421_hour
	rename  inicio_D_422	inicio_D_422_minute
	
	split	end_case4, p("T")
	split	end_case42, p(":")
	rename 	end_case421	end_case421_hour
	rename  end_case422	end_case422_minute
	
	split	inicio_D_5, p("T")
	split	inicio_D_52, p(":")
	rename 	inicio_D_521	inicio_D_521_hour
	rename  inicio_D_522	inicio_D_522_minute
	
	split	end_case5, p("T")
	split	end_case52, p(":")
	rename 	end_case521	end_case521_hour
	rename  end_case522	end_case522_minute
	
	split	inicio_D_6, p("T")
	split	inicio_D_62, p(":")
	rename 	inicio_D_621	inicio_D_621_hour
	rename  inicio_D_622	inicio_D_622_minute
	
	split	end_case6, p("T")
	split	end_case62, p(":")
	rename 	end_case621	end_case621_hour
	rename  end_case622	end_case622_minute
	
	split	inicio_D_7, p("T")
	split	inicio_D_72, p(":")
	rename 	inicio_D_721	inicio_D_721_hour
	rename  inicio_D_722	inicio_D_722_minute
	
	split	end_case7, p("T")
	split	end_case72, p(":")
	rename 	end_case721	end_case721_hour
	rename  end_case722	end_case722_minute
	
	split	inicio_D_8, p("T")
	split	inicio_D_82, p(":")
	rename 	inicio_D_821	inicio_D_821_hour
	rename  inicio_D_822	inicio_D_822_minute
	
	split	end_case8, p("T")
	split	end_case82, p(":")
	rename 	end_case821	end_case821_hour
	rename  end_case822	end_case822_minute

	*Capture whether vignette was skipped
	foreach z in "1" "2" "3" "4" "5" "6" "7" "8" {
		ds 		case`z'_*, has(type numeric)
		local 	vl "`r(varlist)'"
		egen 	did_v`z' = anycount(`vl'), val(1 3)
		gen 	missing_v`z' = 1 if did_v`z' == 0
		replace missing_v`z' = 0 if missing_v`z' == .
		drop	did_v`z'
	} 

	*Recode values that were answered "No" 
	findname, vallabeltext("Yes")
	quietly foreach v of varlist `r(varlist)' {
		recode `v' (2=0)
		recode `v' (3=.a)
	} 

	*Remove observations that are missing all vignettes
	egen	number_missing = anycount(missing_v*), val(1)
	tab 	number_missing 
	drop if number_missing==6  //12 observations were dropped
	 
	*Drop Mod 2 variables and no longer needed start/endtime variables 
	drop	M2_* inicio_D_1 fim_D_1 end_case1 end_case11 end_case12 end_case123	///
			inicio_D_2 end_case2 end_case21 end_case22 end_case223 end_case3 	///
			end_case31 end_case32 end_case323 inicio_D_4 end_case4 end_case41 	///
			end_case42 end_case423 inicio_D_5 end_case5 end_case51 end_case52 	///
			end_case523 inicio_D_6 end_case6 end_case61 end_case62 end_case623	///
			inicio_D_7 end_case7 end_case71 end_case72 end_case723 inicio_D_8	///
			end_case8 end_case81 end_case82 end_case823 inicio_D_8 end_case8	///
			end_case81 end_case82 end_case823 inicio_D_11 inicio_D_12 			///
			inicio_D_123 inicio_D_21 inicio_D_22 inicio_D_223 inicio_D_31 		///
			inicio_D_32 inicio_D_323 inicio_D_41 inicio_D_42 inicio_D_423 		///
			inicio_D_51 inicio_D_52 inicio_D_523 inicio_D_61 inicio_D_62 		///
			inicio_D_623 inicio_D_71 inicio_D_72 inicio_D_723 inicio_D_81 		///
			inicio_D_82 inicio_D_823  fim_D_*
			
	*Destring time variables 
	destring inicio_D_* end_case*, replace
  
	/***************************************
	Harmoninze modules with iecodebook
	***************************************/

	*Modify provider level characteristics data
	applyCodebook using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module3_codebook.xlsx", varlab rename vallab sheet("General")
		
	*Modify each vignette
	
	*Create a local for each disaease 
	local diseases	Diarrhea Pneumonia Diabetes TB Malaria PPH Asphyxia Pregnant
		foreach disease in  `diseases' {
		
			applyCodebook using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module3_codebook.xlsx", varlab rename vallab sheet("`disease'")
			
			local lowerdisease = lower("`disease'")
			foreach x in "history" "exam" "test" "diag" "treat" "educate" "refer" "action" "stop" "failed" {
				cap rename `x'* `lowerdisease'_`x'*
			}
		}
			 
	
	*Drop unwanted variables - they dont match up with anything in the codebook
	drop 	case1* case2* case3* case4* case5* case6* case7* case8*	///
			M3_A_11 M3_A_12 O P exemploOK listPos M3_A_3 M3_A_4 	///
			M3_A_4obs M3_A_5_esp M3_A_7_esp M3_A_9a M3_A_9b 		///
			M3_A_9b_esp M3_A_9c M3_A_10b
			
			
	/********************************************************************************
	 Merge in facility ID variable from Mod 2 - since it is missing in this dataset 
	******************************************************************************/
 	
	preserve 
		*Open mod 2 harmonized dataset 
		use "$EL_dtInt/Module 2/GuineaBissau_2018_mod_2.dta", clear 
			
		*Keep only facility and interview id variable 
		keep	facility_id interview__id
		
		*Create and save tempfile 
		sort		interview__id
		tempfile 	mod_2_fac 
		save 		`mod_2_fac'
	restore	
	
	*Merge in facility id from mod 2 
	sort	interview__id respondendoVignettes0__id
	merge	m:1 interview__id using `mod_2_fac'
 	
	*Drop observations from using data 
	drop	if _merge == 2
 
	*Create provider id  and unique id variable 
	bysort		facility_id (interview__id):	gen	 provider_id = _n
	tostring 	provider_id, replace 
	gen 		unique_id = facility_id + "_" + provider_id
	lab var 	unique_id 	"Unique provider identifier: facility ID + provider ID"
	
	*These variables are no longer needed 
	drop respondendoVignettes0__id M3_A_1 M3_A_7 _merge interview__id

	*Save module 3 file 
	order 	country year 
	
	*Save harmonized dataset 
	save "$EL_dtInt/Module 3/GuineaBissau_2018_mod_3.dta", replace

************************ End of do-file *********************************************
