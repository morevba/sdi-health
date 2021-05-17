* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Harmonize Guinea Bissau modules				   		   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Harmonize all modules of the Guinea Bissau dataset 

       ** IDS VAR:       fac_id interview__id      
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: Feb 2md 2021
 */

/***************************************
	Harmoninze modules with iecodebook
***************************************/

	/******************************
	Apply Module 1 corrections 
	*******************************/

	*Open cleaned module 1 of the Guniea Bissau datasest 
	use "$EL_dtInt/Module 1/GuineaBissau_2018_mod_1.dta", replace 
   
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
	
	*Drop wanted variables 
	drop 	M1_B_34 M1_B_39 M1_C_5b__9 M1_C_12 M1_C_20_esp M1_C_25 M1_C_33_esp	///
			M1_C_35 M1_E_64 M1_D_8 M1_C_36 M1_D_11-M1_D_75 M1_E_740-M1_E_955 	///
			M1_E_11-M1_E_639 totalStaff cutOff cutOff13 cor_teste _merge 		///
			M1_A_3_string
	 
	*Save harmonized dataset 
	save "$EL_dtInt/Module 1/GuineaBissau_2018_mod_1.dta", replace 
	
	/*
	.         append using "$EL_dtInt/Module 1/GuineaBissau_2018_mod_1.dta", force 
(note: variable admin1_name was byte in the using data, but will be str15 now)
(note: variable admin2_name was int in the using data, but will be str16 now)
(note: variable date_visit1_d was str10 in the using data, but will be byte now)
(note: variable enum1_visit1_code was str2 in the using data, but will be long now)
(note: variable enum2_visit1_code was str2 in the using data, but will be long now)
(note: variable arrival_visit1_hr was str19 in the using data, but will be byte now)
(note: variable date_visit2_d was str10 in the using data, but will be byte now)
(note: variable arrival_visit2_hr was str19 in the using data, but will be byte now)
(note: variable transport_central_hr was str5 in the using data, but will be byte now)
(note: variable water_c was str7 in the using data, but will be int now)
(note: variable water_e was str7 in the using data, but will be byte now)
(note: variable fridge_temp was str8 in the using data, but will be double now)
(note: variable depart_visit1_hr was str19 in the using data, but will be byte now)
(note: variable depart_visit2_hr was str19 in the using data, but will be byte now)
(note: variable verif_b was str1 in the using data, but will be long now)
(note: variable country was str11, now str13 to accommodate using data's values)

	*/
exit 
	 
	/******************************
	Apply Module 2 corrections 
	*******************************/
/*
	*Open cleaned module 2 of the Guniea Bissau datasest 
	use "$EL_dtInt/Module 2/GuineaBissau_2018_mod_2.dta", replace 
 	
	*Modify facility general characteristics variables
		preserve
			import excel using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module2_codebook.xlsx", firstrow sheet("General") clear
			tab vallab
			if `r(N)'==0 local haslab = ""
			if `r(N)'>0 local haslab = "vallab"
		restore
 	
	*Modify provider level characteristics data
	applyCodebook using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module2_codebook.xlsx", varlab rename `haslab' sheet("General")
	
	*Drop unwanted variables 
	drop cutOff cutOff13 cor_teste _merge has_facility has_roster has_absentee
	
	*Save harmonized dataset 
	save "$EL_dtInt/Module 2/GuineaBissau_2018_mod_2.dta", replace 
*/
 
	/******************************
	Apply Module 3 corrections 
	*******************************/

	*Open cleaned modules of the Guniea Bissau datasest 
	use "$EL_dtInt/Module 3/GuineaBissau_2018_mod_3.dta", replace 
 	
	*Modify provider level characteristics data
	applyCodebook using "$EL/Documentation/Codebooks/Guinea Bissau 2018/guineabissau-2018_module3_codebook.xlsx", varlab rename vallab sheet("General") 

	*Drop variables that are not needed 
	drop	respondendoVignettes0__id M3_A_1 listPos M3_A_3 M3_A_4 M3_A_4obs M3_A_9a	///
			M3_A_9b M3_A_9b_esp M3_A_9c M3_A_10b M3_A_11 M3_A_12 O P exemploOK 			///
			inicio_D_1  case1* case2* case3* case4* case5* case6* case7* case8* fim_*	///
			end_* inicio_* M2_A_6 M2_A_7_esp M2_A_8_esp M2_A_9_esp M2_A_13_esp 			///
			M2_A_14_esp M2_A_16 M2_A_19 M2_A_20 M2_B_2a M2_B_3 M2_B_3_esp

	*Save harmonized dataset 
	save "$EL_dtInt/Module 3/GuineaBissau_2018_mod_3.dta", replace

*********************************** End of do-file **********************************************
