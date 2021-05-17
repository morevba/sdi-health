* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Append module 3 dataset of each country		   		   *
*				Unique ID											   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Creates a dataset of all the module 3 section for each 
					country combined 

       ** IDS VAR: country year unique_id 
       ** NOTES:
       ** WRITTEN BY: Ruben Connor & Michael Orevba
       ** Last date modified: April 7th 2021
 */
 
/******************************************
		Append Module 3 datasets
*******************************************/

		/****************** 
		APPEND DATASETS
		*******************/
		
		*Open Kenya 2018 dataset 
		use "$EL_dtDeID/Module3_Kenya_2018_deid.dta", clear
		
		*Generate country-year variable 
		gen		cy	= "KEN_2018", after(year)
		
		*Append Kenya 2012 mod 3 dataset 
		appen using "$EL_dtDeID/Module3_Kenya_2012_deid.dta"
		
		*Generate country-year variable 
		replace	cy	= "KEN_2012" if cy == ""
		
		*Append Nigeria 2013 mod 3 dataset 
		append using "$EL_dtDeID/Module3_Nigeria_2013_deid.dta"
		
		*Generate country-year variable 
		replace cy 	= "NGA_2013" if cy == ""
		
		*Append Uganda 2013 mod 3 dataset 
		append using "$EL_dtDeID/Module3_Uganda_2013_deid.dta"
		
		*Generate country-year variable 
		replace cy 	= "UGA_2013" if cy == ""
	
		*Append Togo 2013 mod 3 dataset 
		append using "$EL_dtDeID/Module3_Togo_2013_deid.dta"    
		
		*Generate country-year variable 
		replace cy 	= "TGO_2013" if cy == ""
		
		*Append Mozamnique 2014 mod 3 dataset 
		append using "$EL_dtDeID/Module3_Mozambique_2014_deid.dta"       
		
		*Generate country-year variable 
		replace cy 	= "MOZ_2014" if cy == ""
		
		*Append Niger 2015 mod 3 dataset 
		append using "$EL_dtDeID/Module3_Niger_2015_deid.dta"      
		
		*Generate country-year variable 
		replace cy 	= "NER_2015" if cy == ""
		
		*Append Madagascar 2016 mod 3 dataset 
		append using "$EL_dtDeID/Module3_Madagascar_2016_deid.dta"       
		
		*Generate country-year variable 
		replace cy 	= "MDG_2016" if cy == ""
		
		*Append Tanazania 2016 mod 3 dataset 
		append using "$EL_dtDeID/Module3_Tanzania_2016_deid.dta"     
		
		*Generate country-year variable 
		replace cy 	= "TZN_2016" if cy == ""
		
		*Append Tanazania 2014 mod 3 dataset 
		append using "$EL_dtDeID/Module3_Tanzania_2014_deid.dta"     
		
		*Generate country-year variable 
		replace cy 	= "TZN_2014" if cy == ""
		
		*Append Sierra Leone 2018 mod 3 dataset 
		append using "$EL_dtDeID/Module3_SierraLeone_2018_deid.dta"       
		
		*Generate country-year variable 
		replace cy 	= "SLA_2018" if cy == "" 
		
		*Append Guinea Bissau 2018 mod 3 dataset 
		append using  "$EL_dtInt/Module 3/GuineaBissau_2018_mod_3.dta"       
	
		*Generate country-year variable 
		replace cy 	= "GNB_2018" if cy == "" 
		
		*Append Malawi 2019 mod 3 dataset 
		append using  "$EL_dtInt/Module 3/Malawi_2019_mod_3.dta"        
	
		*Generate country-year variable 
		replace cy 	= "MWI_2019" if cy == "" 
    
		/****************
			History taking
		*******************/
		
		** NOTE: DIFFERENT HISTORY TAKING QUESTIONS FOR DIFFERENT COUNTRIES SO CANNOT JUST SUM DIARRHEA_HISTORY_*
		egen nquest1	=	anycount(diarrhea_history_symp	diarrhea_history_duration	diarrhea_history_freq		///
									diarrhea_history_consist	diarrhea_history_blood diarrhea_history_vomiting	///
									diarrhea_history_breastfed	diarrhea_history_eating	diarrhea_history_cough		///
									diarrhea_history_fever		diarrhea_history_tears	diarrhea_history_food		///
									diarrhea_history_utensils	diarrhea_history_foodprep diarrhea_history_handwash	///
									diarrhea_history_othersick	diarrhea_history_deworm	diarrhea_history_med), val(1)
 							
		egen nquest2 	= 	anycount(pneumonia_history_symp	pneumonia_history_coughdur	pneumonia_history_sputum		///
									 pneumonia_history_spblood	pneumonia_history_chestpain	pneumonia_history_breath	///
									 pneumonia_history_appetit	pneumonia_history_fever	pneumonia_history_gen_cond		///
									 pneumonia_history_convulse	pneumonia_history_swallows	pneumonia_history_nose		///
									 pneumonia_history_med	pneumonia_history_measles	pneumonia_history_spcolor), val(1)
 								 
		egen nquest3 	= 	anycount(diabetes_history_symp	diabetes_history_fever	diabetes_history_convulse			///
									 diabetes_history_vomit	diabetes_history_appetite	diabetes_history_thirst			///
									 diabetes_history_diarrhea diabetes_history_cough	diabetes_history_breath			///
									 diabetes_history_med	diabetes_history_urine diabetes_history_numblimb			///
									 diabetes_history_smoke	diabetes_history_exercise	diabetes_history_checkups		///
									 diabetes_history_tbhiv	diabetes_history_diabetes	diabetes_history_hypertens		///
									 diabetes_history_sunkeyes diabetes_history_dizzy	diabetes_history_headache		///
									 diabetes_history_jointpain), val(1)
	 
		egen nquest4 	= 	anycount(tb_history_symp tb_history_coughdur tb_history_sputum tb_history_spblood		///
									 tb_history_breath tb_history_fever	tb_history_night_sweats	tb_history_tb_hh	///
									 tb_history_hiv	tb_history_weightloss tb_history_appetite tb_history_gen_cond	///
									 tb_history_cough_others tb_history_repeat tb_history_med tb_history_alcohol	///
									 tb_history_smoke tb_history_diet tb_history_profession	tb_history_sexbehavior	///
									 tb_history_chestpain tb_history_fevertype), val(1)
	 						 
		egen nquest5 	= 	anycount(malaria_history_feverdur malaria_history_fevertype	malaria_history_shiver		///
									 malaria_history_convulse malaria_history_vomit	malaria_history_appetite		///
									 malaria_history_diarrhea malaria_history_cough	malaria_history_sevcough		///
									 malaria_history_breath	malaria_history_sputum malaria_history_med				///
									 malaria_history_medamt	malaria_history_vacc malaria_history_sweat), val(1)
									 
		egen nquest6 	= 	anycount(pph_history_symp pph_history_blood_amt	pph_history_pads pph_history_parity			///
									 pph_history_labordur pph_history_placenta pph_history_augmented pph_history_pph	///
									 pph_history_fibroids pph_history_amniotic pph_history_anc pph_history_multiple		///
									 pph_history_praevia pph_history_hypertension pph_history_abruption), val(1)
 
		gen 	squest1 = nquest1 / 19
		lab var squest1 "Percent total acute diarrhea history questions asked"
		gen 	squest2 = nquest2 / 15
		lab var squest2 "Percent total pneumonia history questions asked"
		gen 	squest3 = nquest3 / 22
		lab var squest3 "Percent total diabetes mellitus history questions asked"
		gen 	squest4 = nquest4 / 22														
		lab var squest4 "Percent total pulmonary tuberculosis history questions asked"
		gen 	squest5 = nquest5 / 15
		lab var squest5 "Percent total malaria history questions asked"
		gen 	squest6 = nquest6 / 15
		lab var squest6 "Percent total postpartum hemorrhage history questions asked"
 
		/**********************************************************
		History taking - restricted to most important questions 
		**********************************************************/
		
		* Duration Fever Difficuly_breathing Measles?	/* NOTE: m3scq3 (able to drink) missing */
		egen nquest1_st = anycount(diarrhea_history_duration diarrhea_history_freq diarrhea_history_blood diarrhea_history_vomiting diarrhea_history_eating), val(1)
		egen nquest2_st = anycount(pneumonia_history_coughdur pneumonia_history_fever pneumonia_history_breath pneumonia_history_measles), val(1)		

		*Appetite thirst urinary_output exercise	
		egen nquest3_st = anycount(diabetes_history_appetite diabetes_history_thirst diabetes_history_urine diabetes_history_exercise), val(1)	
		
		* NOTE: has one additional var - WHAT DOES THIS MEAN?*/
		egen nquest4_st = anycount(tb_history_sputum tb_history_spblood tb_history_breath tb_history_nobreath tb_history_fever	///
								   tb_history_night_sweats tb_history_weightloss tb_history_appetite tb_history_gen_cond), val(1)								

		*Consciousness was also recommended, not available across countries */						   
		egen nquest5_st = anycount(malaria_history_feverdur malaria_history_convulse malaria_history_vomit), val(1) 
		egen nquest6_st = anycount(pph_history_symp	pph_history_blood_amt pph_history_pads pph_history_parity		///
								   pph_history_labordur	pph_history_placenta pph_history_augmented pph_history_pph	///
								   pph_history_fibroids	pph_history_amniotic pph_history_anc pph_history_multiple	///
								   pph_history_praevia	pph_history_hypertension pph_history_abruption), val(1)

		gen 	squest1_st = nquest1_st / 5
		lab var squest1_st "Percent most important acute diarrhea history questions asked"
		gen 	squest2_st = nquest2_st / 4
		lab var squest2_st "Percent most important pneumonia history questions asked"
		gen 	squest3_st = nquest3_st / 4
		lab var squest3_st "Percent most important diabetes mellitus history questions asked"
		gen 	squest4_st = nquest4_st / 11
		lab var squest4_st "Percent most important pulmonary tuberculosis history questions asked"
		gen 	squest5_st = nquest5_st / 3 
		lab var squest5_st "Percent total malaria history questions asked"	
		gen 	squest6_st = nquest6_st / 15
		lab var squest6_st "Percent most important postpartum hemorrhage history questions asked"
 
		*Physical examination
		egen nexam1 =	anycount(diarrhea_exam_gen_cond diarrhea_exam_temp diarrhea_exam_skin_pinch	///
								 diarrhea_exam_offer_drink diarrhea_exam_pallor 					///
								 diarrhea_exam_stiff_neck diarrhea_exam_ear_throat diarrhea_exam_rr ///
								 diarrhea_exam_weightloss diarrhea_exam_weight 						///
								 diarrhea_exam_sunkeyes diarrhea_exam_growthchart 					///
								 diarrhea_exam_feet_swell), val(1)
								 
		egen nexam2 = 	anycount(pneumonia_exam_rr pneumonia_exam_lowerchest pneumonia_exam_wheezing		///
								 pneumonia_exam_auscultate pneumonia_exam_nasalflare pneumonia_exam_temp 	///
								 pneumonia_exam_throat pneumonia_exam_ears pneumonia_exam_lymphs), val(1)
								 
		egen nexam3 = 	anycount(diabetes_exam_temp diabetes_exam_pulse diabetes_exam_abdomen 				///
								 diabetes_exam_weight diabetes_exam_height diabetes_exam_rr 				///
								 diabetes_exam_bp diabetes_exam_oral diabetes_exam_upperextrem 				///
								 diabetes_exam_lowerextrem diabetes_exam_fundoscopy), val(1)
								 
		egen nexam4 = 	anycount(tb_exam_temp tb_exam_weight tb_exam_height tb_exam_pulse tb_exam_rr 		///
								 tb_exam_auscultate tb_exam_movement tb_exam_bp), val(1)
								 
		egen nexam5 =	anycount(malaria_exam_pallor malaria_exam_sunkeyes malaria_exam_paleeyes 			///
								 malaria_exam_gen_cond malaria_exam_skin malaria_exam_temp 					///
								 malaria_exam_pulse malaria_exam_stiff_neck malaria_exam_puffy_face 		///
								 malaria_exam_feet_swell malaria_exam_abdomen malaria_exam_weight 			///
								 malaria_exam_rr), val(1)
								 
		egen nexam6 = 	anycount(pph_exam_temp pph_exam_pulse pph_exam_weight pph_exam_rr pph_exam_retained ///
								 pph_exam_bp pph_exam_ruptured pph_exam_tears pph_exam_palpation), val(1)
								 
		egen nexam7 = 	anycount(asphyxia_exam_hr asphyxia_exam_resp asphyxia_exam_muscle 					///
								 asphyxia_exam_reflex asphyxia_exam_color asphyxia_exam_apgar), val(1)
 
		gen 	sexam1 = nexam1 / 13
		lab var sexam1 "Percent total acute diarrhea physical examination questions asked"
		gen 	sexam2 = nexam2 / 9
		lab var sexam2 "Percent total pneumonia physical examination questions asked"
		gen 	sexam3 = nexam3 / 11
		lab var sexam3 "Percent total diabetes mellitus physical examination questions asked"
		gen 	sexam4 = nexam4 / 8
		lab var sexam4 "Percent total pulmonary tuberculosis physical examination questions asked"
		gen 	sexam5 = nexam5 / 13
		lab var sexam5 "Percent total malaria physical examination questions asked"
		gen 	sexam6 = nexam6 / 9
		lab var sexam6 "Percent total postpartum hemorrhage physical examination questions asked"
		gen 	sexam7 = nexam7 / 6
		lab var sexam7 "Percent total birth asphyxia physical examination questions asked"

		/*************************************************************
		 Physical examination- restricted to most important questions
		***************************************************************/
		
		egen nexam1_st =	anycount(diarrhea_exam_gen_cond diarrhea_exam_skin_pinch diarrhea_exam_offer_drink	///
									 diarrhea_exam_weight diarrhea_exam_sunkeyes diarrhea_exam_feet_swell), val(1)
									 
		*resp_rate lower_chest auscultate throat ears
		egen nexam2_st = 	anycount(pneumonia_exam_rr pneumonia_exam_lowerchest pneumonia_exam_auscultate		///
									 pneumonia_exam_throat pneumonia_exam_ears), val(1)
									 
		*bp height (weight?)_ abdomen/liver
		egen nexam3_st = 	anycount(diabetes_exam_abdomen diabetes_exam_weight diabetes_exam_bp), val(1)
		
		*temp pulse bp resp weight height auscultate retraction_movement
		egen nexam4_st = 	anycount(tb_exam_temp tb_exam_weight tb_exam_height tb_exam_pulse tb_exam_rr tb_exam_auscultate tb_exam_movement tb_exam_bp), val(1)

		*temp rr gen_cond palmor neck_stiff (yellow eyes was also recommended, not available across all surveys)
		egen nexam5_st = 	anycount(malaria_exam_pallor malaria_exam_gen_cond malaria_exam_temp malaria_exam_stiff_neck malaria_exam_rr), val(1)
		
		*pulse bp placenta uterus laceration (palor consciousness) palpation_uterus
		egen nexam6_st = 	anycount(pph_exam_pulse pph_exam_retained pph_exam_bp pph_exam_ruptured pph_exam_tears pph_exam_palpation), val(1)
	
		*pulse breathing muscle_tone reactivity color apgar
		egen nexam7_st = 	anycount(asphyxia_exam_hr asphyxia_exam_resp asphyxia_exam_muscle asphyxia_exam_reflex asphyxia_exam_color asphyxia_exam_apgar), val(1)

		gen 	sexam1_st = nexam1_st / 6
		lab var sexam1_st "Percent most important acute diarrhea physical examination questions asked"
		gen 	sexam2_st = nexam2_st / 5
		lab var sexam2_st "Percent most important pneumonia physical examination questions asked"
		gen 	sexam3_st = nexam3_st / 3
		lab var sexam3_st "Percent most important diabetes mellitus physical examination questions asked"
		gen 	sexam4_st = nexam4_st / 8
		lab var sexam4_st "Percent most important pulmonary tuberculosis physical examination questions asked"
		gen 	sexam5_st = nexam5_st / 5
		lab var sexam5_st "Percent most important malaria physical examination questions asked"
		gen 	sexam6_st = nexam6_st / 6
		lab var sexam6_st "Percent most important postpartum hemorrhage physical examination questions asked"
		gen 	sexam7_st = nexam7_st / 6
		lab var sexam7_st "Percent most important birth asphyxia physical examination questions asked"

		*Aggregate score of history taking and examination
		gen 	hisex1=(squest1+sexam1)/2
		lab var hisex1 "Aggregate score of history taking and examination for acute diarrhea case"
		gen 	hisex2=(squest2+sexam2)/2
		lab var hisex2 "Aggregate score of history taking and examination for pneumonia case"
		gen 	hisex3=(squest3+sexam3)/2
		lab var hisex3 "Aggregate score of history taking and examination for diabetes mellitus case"
		gen 	hisex4=(squest4+sexam4)/2
		lab var hisex4 "Aggregate score of history taking and examination for pulmonary tuberculosis case"
		gen 	hisex5=(squest5+sexam5)/2
		lab var hisex5 "Aggregate score of history taking and examination for malaria"
		gen 	hisex6=(squest6+sexam6)/2
		lab var hisex6 "Aggregate score of history taking and examination for post-partum hemorrhage case"
		gen 	hisex7=(sexam7) /* clinman */
		lab var hisex7 "Aggregate score of history taking and examination for birth asphyxia case"
	
		*Aggregate score of history taking and examination restricted to important questions
		gen 	hisex1_st=(squest1_st+sexam1_st)/2
		
		*lab var hisex1_st "Aggregate score of history taking and examination for acute diarrhea case"
		lab var hisex1_st "Diarrhea"
		gen 	hisex2_st=(squest2_st+sexam2_st)/2
		
		*lab var hisex2_st "Aggregate score of history taking and examination for pneumonia case"
		lab var hisex2_st "Pneumonia"
		gen 	hisex3_st=(squest3_st+sexam3_st)/2
		
		*lab var hisex3_st "Aggregate score of history taking and examination for diabetes mellitus case"
		lab var hisex3_st "Diabetes"
		gen 	hisex4_st=(squest4_st+sexam4_st)/2
		
		*lab var hisex4_st "Aggregate score of history taking and examination for pulmonary tuberculosis case"
		lab var hisex4_st "Tuberculosis"
		gen 	hisex5_st=(squest5_st+sexam5_st)/2
		
		*lab var hisex5_st "Aggregate score of history taking and examination for malaria"
		lab var hisex5_st "Malaria"
		gen 	hisex6_st=(squest6_st+sexam6_st)/2
		
		*lab var hisex6_st "Aggregate score of history taking and examination for post-partum hemorrhage case"
		lab var hisex6_st "PP hemorrhage"	
		gen 	hisex7_st=(sexam7_st)
		
		*lab var hisex7_st "Aggregate score of history taking and examination for birth asphyxia case"
		lab var hisex7_st "Asphyxia"	
	

		*Aggregate score provider knowledge patient case 1-5
		egen 	clinknow=rowmean(hisex1-hisex5)
		lab var clinknow "aggregate score of clinician knowledge of history and examination questions for cases 1-4"
		
		egen 	clinknow_st=rowmean (hisex1_st-hisex5_st)
		lab var clinknow_st "aggregate score of clinician knowledge of history and examination important questions for cases 1-4"

		*Aggregate share of history, examination and education, per patient
		egen 	squest_ave= rowmean(squest1 squest2 squest3 squest4 squest5)
		lab var squest_ave "aggregate score of clinician knowledge of history questions for cases 1-4"
		
		egen 	squest_st_ave=rowmean(squest1_st squest2_st  squest3_st  squest4_st squest5_st)
		lab var squest_st_ave "aggregate score of clinician knowledge of important history questions for cases 1-4"

		egen 	sexam_ave= rowmean(sexam1 sexam2 sexam3 sexam4 sexam5) 
		lab var sexam_ave "aggregate score of clinician knowledge of examination questions for cases 1-4"
		egen 	sexam_st_ave=rowmean(sexam1_st sexam2_st  sexam3_st  sexam4_st sexam5)
		lab var sexam_st_ave "aggregate score of clinician knowledge of important examination questions for cases 1-4"
		
		*Generata Score
		gen 	score_proc =(squest_ave + sexam_ave)/2 
		lab var score_proc "Aggregate process score: average score of history and examination questions"
		gen 	score_proc_st =(squest_st_ave + sexam_st_ave)/2 
		lab var score_proc_st "Aggregate process score-important: average score of important history and examination questions"

		replace score_proc = score_proc*100
		replace score_proc_st = score_proc_st*100
		
		/************************
			DIAGNOSIS ACCURACY	
		**************************/
	
		*Check which vignettes are present
		* local diseases = ""
		* foreach v of varlist skip_* {
			* local dis = substr("`v'", 6, .)
			* sum `v'
			* if `r(N)' != 0 {
				* local diseases = `" "`dis'" `diseases' "'
			* }
		* }
		* di in red `diseases'

		*Create diagnoses 
		isid country year facility_id provider_id // year needed to be added 
  
		*Diarrhea: they must diagnose as severe dehydration and either diarrhea or acute diarrhea 		
		gen 	diag1 = ((diarrhea_diag_sevdehydrtn == 1 | diarrhea_diag_dehydration == 1) & (diarrhea_diag_diarrhea == 1 | diarrhea_diag_acdiarrhea == 1)) 
		replace diag1 = 1 if diarrhea_diag_acdiar_sevdehydrtn == 1 | diarrhea_diag_diar_sevdehydrtn == 1 | diarrhea_diag_diar_moddehydrtn == 1
		replace diag1 = . if skip_diarrhea == . | skip_diarrhea == 1
		
		*Does severe dehydration count?
		gen 	diag1_alt = ((diarrhea_diag_sevdehydrtn == 1) & (diarrhea_diag_diarrhea == 1 | diarrhea_diag_acdiarrhea == 1)) 
		replace diag1_alt = 1 if diarrhea_diag_acdiar_sevdehydrtn == 1 | diarrhea_diag_diar_sevdehydrtn == 1
		replace diag1_alt = . if skip_diarrhea == . | skip_diarrhea == 1

		*Diarrhea with credit for just mentioning diarrhea
		gen 	diag1_simp = (diarrhea_diag_diarrhea == 1 | diarrhea_diag_acdiarrhea == 1)
		replace diag1_simp = 1 if diarrhea_diag_acdiar_sevdehydrtn == 1 | diarrhea_diag_diar_sevdehydrtn == 1 | diarrhea_diag_diar_moddehydrtn == 1
		replace diag1_simp = . if skip_diarrhea == . | skip_diarrhea == 1
				
		*Pneumonia: pretty simple
		gen 	diag2 = (pneumonia_diag_pneumonia == 1)
		replace diag2 = . if skip_pneumonia == . | skip_pneumonia == 1
		
		*Diabetes: Must identify as type 2. At least for Sierra Leone, providers frequently identify just as diabetes. 
		gen 	diag3 = (diabetes_diag_diabetes == 1 | diabetes_diag_diabetesii == 1 | diabetes_diag_sugar == 1)
		replace diag3 = . if skip_diabetes == . | skip_diabetes == 1 
	
		*Tuberculosis
		gen 	diag4 = tb_diag_tuberculosis
		replace diag4 = . if skip_tb == . | skip_tb == 1 | tb_diag_tuberculosis == . 

		*Malaria: Giving credit for malaria, simple malaria or severe malaria. Are these all correct?
		*Most people really lose credit for not diagnosing anemia, very few miss malaria of some type
		gen 	diag5 = (malaria_diag_anemia == 1 & (malaria_diag_malaria == 1 | malaria_diag_simpmalaria == 1))
		replace diag5 = 1 if malaria_diag_malaria_anemia == 1 & (country == "NIGERIA" | country == "TOGO" | country == "UGANDA")
		replace diag5 = . if skip_malaria == . | skip_malaria == 1 
		
		gen 	diag5_simp = (malaria_diag_malaria == 1 | malaria_diag_simpmalaria == 1)
		replace diag5_simp = 1 if malaria_diag_malaria_anemia == 1 
		replace diag5_simp = . if skip_malaria == . | skip_malaria == 1 

		*Madagascar module appears to be incorrect, only one provider diagnosed correctly
		replace diag5 = . if country == "MADAGASCAR" 
	
		*Post partum hemorrhage 
		gen 	diag6 = pph_diag_pph
		replace diag6 = . if skip_pph == . | skip_pph == 1 | pph_diag_pph == .
 
		*Neonatal asphyxia
		gen 	diag7 = asphyxia_diag_neo_asphyxia
		replace diag7 = 1 if asphyxia_diag_neo_respdis == 1 | asphyxia_diag_respdis == 1
		replace diag7 = 0 if (asphyxia_diag_neo_respdis == 0 | asphyxia_diag_respdis == 0) & diag7 == .
		replace diag7 = . if skip_asphyxia == . | skip_asphyxia == 1 | (asphyxia_diag_neo_asphyxia == . & asphyxia_diag_neo_respdis == . & asphyxia_diag_respdis == .)

		foreach var of varlist diag* {
			replace `var' = `var'*100
		}

		*List the countries that have each diagnosis code
		foreach var of varlist diarrhea_diag* diabetes_diag* pneumonia_diag* tb_diag* malaria_diag* pph_diag* asphyxia_diag* {
			di 	in red "`var'"
			tab country if `var' != .
		}
		foreach var of varlist diarrhea_diag* {
			di 	in red "`var'"
			tab country if `var' != .
		}
		foreach var of varlist diarrhea_diag* {
			di 	in red "`var'"
			tab `var' if country == "MADAGASCAR"
		}
		foreach var of varlist malaria_diag* {
			di 	in red "`var'"
			tab country if `var' != .
		}

		*Labels
		lab var diag1 "Diarrhea"
		lab var diag2 "Pneumonia"
		lab var diag3 "Diabetes"
		lab var diag4 "Tuberculosis"
		lab var diag5 "Malaria"
		lab var diag6 "PP hemorrhage"	
		lab var diag7 "Asphyxia"
	
		*Averages
		egen diag_accuracy = rowmean(diag1 diag2 diag3 diag4 diag5)
 
		/*************************
			TREATMENT ACCURACY
		***************************/
 
		*Diarrhea 
		*Uganda did not ask about ORS and instead has IV fluids as an option
		* replace diarrhea_treat_ors = 1 if diarrhea_treat_ivfluids == 1 & country == "UGANDA"
		gen 	treat1		=	(diarrhea_treat_ors == 1 & diarrhea_treat_zinc == 1) | ///
								(diarrhea_treat_ivfluids == 1 | diarrhea_treat_ngtube == 1 | diarrhea_treat_tubedose == 1)
		gen 	treat1_alt	=	(diarrhea_treat_ors == 1 & diarrhea_treat_zinc == 1) 
		gen 	treat1_alt2	=	(diarrhea_treat_ivfluids == 1 | diarrhea_treat_ngtube == 1)
		replace treat1		= 	. if skip_diarrhea == 1
		lab var treat1 			"Correct treatment for diarrhea and dehydration proposed"
		// Full compliance require ORS and Zinc. No credit given for IV rehydration. 
  
		*Pneumonia
		gen 	treat2pne = (pneumonia_treat_amoxycillin == 1 | pneumonia_treat_amoxy_dose == 1)
		replace treat2pne = . if (pneumonia_treat_amoxycillin == . & pneumonia_treat_amoxy_dose == .)
		lab var treat2pne 	"Correct treatment for pneumonia proposed"

		gen 	treat2fev = pneumonia_treat_antipyretics == 1 | pneumonia_treat_paractmol_dose == 1 | pneumonia_treat_paractml == 1
		replace treat2fev = . if pneumonia_treat_antipyretics == . & pneumonia_treat_paractmol_dose == . & pneumonia_treat_paractml == .
		lab var treat2fev 	"Correct treatment for fever proposed"

		gen 	treat2	=	(treat2pne == 1 & treat2fev == 1)
		replace treat2 	= . if treat2pne == . | treat2fev == .
		replace treat2 	= . if skip_pneumonia == 1
		lab var treat2 		"Correct treatment for pneumonia and fever proposed"

		*Diabetes
		*Kenya coded slightly different
		replace diabetes_refer_specialist = diabetes_treat_outpatient if country == "KENYA" 
		
		egen 	treat3	=	anycount(diabetes_treat_hypoglycmcs diabetes_treat_insulin diabetes_refer_specialist), val(1)
		replace treat3 	= 1 if treat3 >= 1 & treat3 != .
		replace treat3 	= . if diabetes_treat_hypoglycmcs == . & diabetes_treat_insulin == . & diabetes_refer_specialist == .
		replace treat3 	= . if skip_diabetes == 1
		lab var treat3 	"Correct treatment for diabetes mellitus proposed"
		*Hypoglycemics or insulin if hypo not effective.
		*Giving credit for either of those two or referral to another facility
		
		*TB
		*the questionnaire page 16 disaggregates the 4 treatment actions
		// Simple definition 
		gen treat4		=	(tb_treat_ctdurdose == 1 | tb_treat_ct == 1 | tb_treat_ctdrugs == 1 | ///
							 tb_treat_ctdur == 1 | tb_treat_ctdose == 1) // slightly different questions in different countries
							 
		replace treat4 	= 1 if tb_refer_tbclinic == 1 // Also giving credit for referral to clinic
		replace treat4 	= . if tb_treat_ctdurdose == . & tb_treat_ct == . & tb_treat_ctdrugs == . & tb_treat_ctdur == . & tb_treat_ctdose == . & tb_refer_tbclinic == .
		replace treat4 	= . if skip_tb == 1
		lab var treat4 	"Correct treatment for tuberculosis proposed"
		* to include the facility type at the beginning
		// Ashis suggests some places should refer... Unclear how to handle that
	
		*Malaria 
		*Malaria questions labeled differently across different countries 
		*Generally giving credit for any treatment with artemisin (ACT) or artemether-lumefantrin (coartem)
		egen 	maltreat	=	anycount(malaria_treat_artemisinin malaria_treat_al_wdose malaria_treat_al malaria_treat_al_dose malaria_treat_artesunateam), val(1)
		replace maltreat 	= . if malaria_treat_artemisinin 	== . & (country == "MADAGASCAR" | country == "NIGERIA")
		replace maltreat 	= . if malaria_treat_al_wdose 		== . & (country == "TOGO" | country == "UGANDA")
		replace maltreat 	= . if malaria_treat_al 			== . & (country == "MOZAMBIQUE" | country == "NIGER" | country == "SIERRALEONE" | country == "TANZANIA")
		replace maltreat 	= . if malaria_treat_al_dose		== . & (country == "MADAGASCAR" | country == "MOZAMBIQUE" | ///
																		country == "NIGER" | country == "SIERRALEONE" | country == "TANZANIA")
		replace maltreat 	= . if malaria_treat_artesunateam 	== . & (country == "NIGERIA")
 
		*Fever treatment - NOT REQUIRED 
		gen 	malfevtreat	= (maltreat == 1 & malaria_treat_paracetamol == 1)
		replace malfevtreat = . if maltreat == . | malaria_treat_paracetamol == .
		lab var malfevtreat "Correct treatment for malaria and fever proposed"
		
		*Anemia treatment
		gen 	anem_treat = (malaria_treat_iron == 1 | malaria_treat_iron_folicacid == 1)
		replace anem_treat = . if malaria_treat_iron == . & malaria_treat_iron_folicacid == .
		lab var anem_treat "Correct treatment for anemia proposed"
		
		*Actual variable
		gen 	treat5 = (maltreat == 1 & anem_treat == 1)
		
		*Nigeria and Uganda did not ask about iron so are ommitted. Kenya did not ask about malaria generally. 
		replace treat5 = . if maltreat == . | anem_treat == .
		replace treat5 = . if skip_malaria == 1
		
		*Madagascar module appears to be incorrect, only one provider diagnosed correctly
		replace treat5 = . if country == "MADAGASCAR" 
		lab var treat5 "Correct treatment for malaria and anemia proposed"

		*PPH
		foreach var of varlist 	pph_treat_oxytocin_wdose pph_treat_oxytocin_iv pph_treat_oxytocin_dose20	///
								pph_treat_oxytocin_ratedrops pph_treat_oxytocin pph_treat_oxytocin_im 		///
								pph_treat_oxytocine_doseim pph_treat_oxytocin_dose10 						///
								pph_treat_oxytocin_rateliter {
			tab country if `var' != .
			replace `var' = . if `var' == .a
		}
		replace pph_treat_oxytocin_dose20 = 0 if pph_treat_oxytocin_dose20 == 2 // Miscode
		
		*Togo and Uganda ONLY give credit for if dose of oxytocin was correct. No variable to note if they just mention oxytocin
		egen 	oxytoc =	anycount(pph_treat_oxytocin_wdose pph_treat_oxytocin_iv pph_treat_oxytocin_dose20	///
									 pph_treat_oxytocin_ratedrops pph_treat_oxytocin pph_treat_oxytocin_im 		///
									 pph_treat_oxytocine_doseim pph_treat_oxytocin_dose10 						///
									 pph_treat_oxytocin_rateliter), val(1)
		replace oxytoc = 1 if oxytoc >= 1 & oxytoc != .
		
		egen 	other_utero_proposed = anycount(pph_treat_prostaglandins pph_treat_misoprostol 					///
												pph_treat_ergometrine pph_treat_ergometrine_dose2 				///
												pph_treat_ergometrine_dose5), val(1)
		replace other_utero_proposed = 1 if other_utero_proposed >= 1 & other_utero_proposed != .
		
		gen 	any_oxytoc = (oxytoc == 1 | other_utero_proposed == 1)
		replace any_oxytoc = . if oxytoc == . & other_utero_proposed == .

		gen 	run_iv = (pph_treat_plasmion == 1 | pph_treat_iv == 1)
		replace run_iv = . if pph_treat_plasmion == . & pph_treat_iv == .

		*Five potential actions that we'll consider 
		egen 	pph_actions = rowtotal(pph_treat_cause pph_treat_catheter pph_treat_massage run_iv any_oxytoc)
		gen 	treat6		=(pph_actions == 5)
		replace treat6 		= . if skip_pph == 1
		lab var pph_actions "Number of correct actions for postpartum hemorrhage proposed"
		lab var treat6 		"Correct treatment for postpartum hemorrhage proposed"
	
		*Asphyxia
		*Ashis omitted Clear the airway, place baby in neutral position, continue at 30 per min, chest compressions and provide oxygen but I don't see reason to omit these
		*These variables were not consistenly asked across countries and are therefore ommitted: 	
		*aa_drybaby aa_airway aa_position aa_breathing aa_compress aa_oxygen aa_resus aa_check_c aa_slap aa_40breaths aa_position		
		rename  asphyxia_action_* aa_*

		*Nigeria and Uganda coded slightly differently, fixing that
		replace aa_30breaths = aa_30br_check if country == "NIGERIA" | country == "UGANDA" 
		replace aa_when_stop = aa_stop_oxygen if country == "NIGERIA" | country == "UGANDA" 
		
		*Multiple resuscitation variables
		gen 	resus = (aa_resusmask == 1 | aa_resus == 1)
		replace resus = . if aa_resusmask == . & aa_resus == .
		
		*Multiple check breathing variables 
		gen 	breathe = (aa_check_chest == 1 | aa_breathing == 1)
		replace breathe = . if aa_check_chest == . & aa_breathing == .
		
		*Seven actions that we'll consider
		egen 	asphyxia_actions = rowtotal(aa_call_help aa_drybaby aa_babywarm aa_position aa_heartrate breathe resus)  
		lab var asphyxia_actions "Number of correct actions for neonatal asphyxia proposed"
		gen 	treat7			=(asphyxia_actions == 7)
		replace treat7 			= . if skip_asphyxia == 1
		lab var treat7 "Correct treatment for neonatal asphyxia proposed"
 	
		*Unnecessary use of antibiotics or antimalarials 
		*Inappropriate antibiotic prescription for TB 
		gen 	tb_antibio 	= (tb_treat_macrolide == 1 | tb_treat_xpen == 1 | tb_treat_amoxicillin == 1)
		replace tb_antibio  = . if tb_treat_macrolide == . & tb_treat_xpen == .& tb_treat_amoxicillin == .

		*Inappropriate antibiotic prescription for diarrhea
		gen 	diar_antibio = diarrhea_treat_antibiotics
		
		*Inappropriate antibiotic prescription for both	
		gen 	bad_antibio = (tb_antibio == 1 | diar_antibio == 1)
		replace bad_antibio = . if tb_antibio == . & diar_antibio == .
	
		*Final prep
		local c = 1 
		foreach t in diarrhea pneumonia diabetes TB malaria PPH asphyxia {
			label variable diag`c' "Correct diagnosis for `t'" 
			local c = `c' + 1
		}
	
		egen 	treat_accuracy 	= rowmean(treat1 treat2 treat3 treat4 treat5)
		replace treat_accuracy 	= treat_accuracy*100
		gen 	pph_perc 		= (pph_actions/5)*100
		gen 	asphyxia_perc 	= (asphyxia_actions/7)*100
	
		/************************************************************
		Check relationship between clinical guidelines and diagnosis
		*************************************************************/
		
		/*logit diag1 diarrhea_history_symp	diarrhea_history_duration diarrhea_history_freq	diarrhea_history_consist			///
					  diarrhea_history_blood diarrhea_history_vomiting diarrhea_history_breastfed diarrhea_history_eating		///
					  diarrhea_history_cough diarrhea_history_fever	diarrhea_history_tears	diarrhea_history_food				///
					  diarrhea_history_utensils diarrhea_history_foodprep diarrhea_history_handwash 							///
					  diarrhea_history_othersick diarrhea_history_deworm diarrhea_history_med, or*/
				
		/*logit diag2  pneumonia_history_symp pneumonia_history_coughdur pneumonia_history_sputum 						///
					   pneumonia_history_spblood pneumonia_history_chestpain pneumonia_history_breath					///
					   pneumonia_history_appetit pneumonia_history_fever pneumonia_history_gen_cond						///
					   pneumonia_history_convulse pneumonia_history_swallows pneumonia_history_nose						///
					   pneumonia_history_med pneumonia_history_measles pneumonia_history_spcolor, or */
					  
		/*logit diag3  diabetes_history_symp diabetes_history_fever diabetes_history_convulse diabetes_history_vomit	///
					   diabetes_history_appetite diabetes_history_thirst diabetes_history_diarrhea						///
					   diabetes_history_cough diabetes_history_breath diabetes_history_med diabetes_history_urine 		///
					   diabetes_history_numblimb diabetes_history_smoke diabetes_history_exercise 						///
					   diabetes_history_checkups diabetes_history_tbhiv	diabetes_history_diabetes						///
					   diabetes_history_hypertens diabetes_history_sunkeyes diabetes_history_dizzy 						///
					   diabetes_history_headache diabetes_history_jointpain, or */
					  
		/*logit diag4 tb_history_symp tb_history_coughdur tb_history_sputum tb_history_spblood tb_history_breath		///
					  tb_history_fever tb_history_night_ tb_history_tb_hh tb_history_hiv tb_history_weight 				///
					  tb_history_appetite tb_history_gen_cond tb_history_cough_others tb_history_repeat					///
					  tb_history_med tb_history_alcohol	tb_history_smoke tb_history_diet tb_history_profes				///
					  tb_history_sexbeh	tb_history_chestp tb_history_fevert, or*/
					 
		/*logit diag5 malaria_history_feverdur malaria_history_fevertype malaria_history_shiver malaria_history_convulse 	///
					  malaria_history_vomit malaria_history_appetite malaria_history_diarrhea malaria_history_cough			///
					  malaria_history_sevcough malaria_history_breath malaria_history_sputum malaria_history_med			///
					  malaria_history_medamt malaria_history_vacc malaria_history_sweat, or*/
					 
		/*logit diag6 pph_history_symp pph_history_blood_amt pph_history_pads pph_history_parity pph_history_labor		///
					  pph_history_place pph_history_augme pph_history_pph pph_history_fibro pph_history_amnio			///
					  pph_history_anc pph_history_multi pph_history_praevia pph_history_hyper pph_history_abrup, or*/
					 
		/*logit diag1 diarrhea_exam_gen_cond diarrhea_exam_temp diarrhea_exam_skin_pinch diarrhea_exam_offer_drink 		///
					  diarrhea_exam_pallor diarrhea_exam_stiff_neck diarrhea_exam_ear_throat diarrhea_exam_rr 			///
					  diarrhea_exam_weightloss diarrhea_exam_weight diarrhea_exam_sunkeyes diarrhea_exam_growthchart 	///
					  diarrhea_exam_feet_swell, or*/
			   
		/*logit diag2 pneumonia_exam_rr pneumonia_exam_lowerchest pneumonia_exam_wheezing pneumonia_exam_auscultate 	///
					  pneumonia_exam_nasalflare pneumonia_exam_temp pneumonia_exam_throat pneumonia_exam_ears 			///
					  pneumonia_exam_lymphs, or*/
					 
		/*logit diag3 diabetes_exam_temp diabetes_exam_pulse diabetes_exam_abdomen diabetes_exam_weight 				///
					  diabetes_exam_height diabetes_exam_rr diabetes_exam_bp diabetes_exam_oral 						///
					  diabetes_exam_upperextrem diabetes_exam_lowerextrem diabetes_exam_fundoscopy, or*/
					 
		/*logit diag4 tb_exam_temp tb_exam_weight tb_exam_height tb_exam_pulse tb_exam_rr tb_exam_auscultate 			///
					  tb_exam_movement tb_exam_bp, or*/
		
		/*logit diag5 malaria_exam_pallor malaria_exam_sunkeyes malaria_exam_paleeyes malaria_exam_gen_cond 			///
					  malaria_exam_skin malaria_exam_temp malaria_exam_pulse malaria_exam_stiff_neck 					///
					  malaria_exam_puffy_face malaria_exam_feet_swell malaria_exam_abdomen malaria_exam_weight 			///
					  malaria_exam_rr, or*/
					 
		/*logit diag6 pph_exam_temp pph_exam_pulse pph_exam_weight pph_exam_rr pph_exam_retained pph_exam_bp 			///
					  pph_exam_ruptured pph_exam_tears pph_exam_palpation, or*/
					  
		*logit diag7 aa_sucker aa_babywarm aa_resusmask aa_maskuse aa_heartrate aa_improved aa_call_help aa_30breaths, or
	

		/*Attach IRT scores
		merge 1:1 provider_id facility_id country using "./IRT/irt_id_key.dta", nogen
		merge 1:1 id using ".\IRT\trait_param.dta", nogen
		reg diag_accuracy theta_eap
		rename theta_eap irt_score*/
	
		*Save appended module 3 dataset 
		save "$EL_dtInt/Module 3/All_countries_mod_3.dta", replace

***************************** End of do-file ************************************
