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
	tostring provider_id, replace
	tostring fac_id, replace
	gen		 unique_id = fac_id + "_" + provider_id
	lab var  unique_id "Unique provider identifier: facility ID + provider ID"
	lab var  fac_id 	"Facility unique identifier, as string"	
	lab var  provider_id "Provider unique identifier, as string"
	
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

	rename 		B_Q47 	diarrhea_diag_diarrhea
	rename 		B_Q48 	diarrhea_diag_acdiarrhea
	rename 		B_Q49 	diarrhea_diag_dehydration
	rename 		B_Q50 	diarrhea_diag_sevdehydrtn
	rename 		C_Q41 	pneumonia_diag_pneumonia
	rename 		D_Q42 	diabetes_diag_diabetes
	rename 		D_Q43 	diabetes_diag_diabetesii
	rename 		E_Q40 	tb_diag_tuberculosis
	rename 		F_Q53 	malaria_diag_malaria
	rename 		F_Q54 	malaria_diag_simpmalaria
	rename 		F_Q55 	malaria_diag_sevmalaria
	rename 		F_Q56 	malaria_diag_anemia
	rename 		G_Q39 	pph_diag_pph
	rename 		I_Q30 	asphyxia_diag_neo_asphyxia
	rename 		I_Q31 	asphyxia_diag_respdis
	rename 		B_Q53 	diarrhea_treat_ors
	rename 		B_Q54 	diarrhea_treat_ngtube
	rename 		B_Q55 	diarrhea_treat_ivfluids
	rename 		B_Q58 	diarrhea_treat_zinc
	rename 		C_Q45 	pneumonia_treat_amoxycillin
	rename 		C_Q46 	pneumonia_treat_amoxy_dose
	rename 		C_Q48 	pneumonia_treat_antipyretics
	rename 		C_Q49 	pneumonia_treat_paractml
	rename 		C_Q50 	pneumonia_treat_paractmol_dose
	rename 		D_Q46 	diabetes_treat_hypoglycmcs
	rename 		D_Q47 	diabetes_treat_insulin
	rename 		D_Q48 	diabetes_refer_specialist
	rename 		E_Q45 	tb_treat_ct
	rename 		E_Q46 	tb_treat_ctdur
	rename 		E_Q47 	tb_treat_ctdose
	rename 		E_Q51 	tb_refer_tbclinic
	rename 		F_Q59 	malaria_treat_al
	rename 		F_Q60 	malaria_treat_al_wdose
	rename 		F_Q61 	malaria_treat_mono
	rename 		F_Q62 	malaria_treat_artesunateam
	rename 		F_Q67 	malaria_treat_iron
	rename 		F_Q68 	malaria_treat_iron_folicacid
	rename 		G_Q44 	pph_treat_iv
	rename 		G_Q44_a pph_treat_oxytocin
	rename 		G_Q44_b pph_treat_oxytocin_im
	rename 		G_Q45 	pph_treat_oxytocin_iv
	rename 		G_Q45_a pph_treat_oxytocin_dose10
	rename 		G_Q46 	pph_treat_oxytocin_dose20
	rename 		G_Q47 	pph_treat_oxytocin_ratedrops
	rename 		G_Q47_a pph_treat_oxytocin_rateliter
	rename 		G_Q48 	pph_treat_plasmion
	rename 		G_Q47_b pph_treat_ergometrine		
	rename 		G_Q47_c pph_treat_ergometrine_dose5
	rename 		G_Q50 	pph_treat_prostaglandins
	rename 		G_Q51 	pph_treat_misoprostol
	rename 		G_Q42 	pph_treat_cause
	rename 		G_Q43	pph_treat_massage
	rename 		G_Q54 	pph_treat_catheter
	rename 		I_Q8	aa_call_help
	rename 		I_Q9 	aa_drybaby
	rename 		I_Q10 	aa_babywarm
	rename 		I_Q12 	aa_position1
	rename 		I_Q15 	aa_position2
	rename 		I_Q18 	aa_heartrate
	rename 		I_Q16 	aa_resusmask
	rename 		I_Q14 	aa_resus
	rename 		I_Q19 	aa_breathing
	rename 		E_Q49 	tb_treat_macrolide
	rename 		E_Q50 	tb_treat_amoxicillin
	rename 		B_Q56 	diarrhea_treat_antibiotics
	
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
 
	*Diarrhea: they must diagnose as severe dehydration and either diarrhea or acute diarrhea 		
	gen 	diag1 = ((diarrhea_diag_sevdehydrtn == 1 | diarrhea_diag_dehydration == 1) & (diarrhea_diag_diarrhea == 1 | diarrhea_diag_acdiarrhea == 1)) 
	replace diag1 = . if diarrhea_diag_diarrhea == . | diarrhea_diag_diarrhea == .a
	
	*Diarrhea with credit for just mentioning diarrhea
	gen 	diag1_simp = (diarrhea_diag_diarrhea == 1 | diarrhea_diag_acdiarrhea == 1)
	replace diag1_simp = . if diarrhea_diag_diarrhea == . | diarrhea_diag_diarrhea == .a
			
	*Pneumonia
	gen 	diag2 = (pneumonia_diag_pneumonia == 1)
	replace diag2 = . if pneumonia_diag_pneumonia == . | pneumonia_diag_pneumonia == .a
	
	*Diabetes
	gen 	diag3 = (diabetes_diag_diabetes == 1 | diabetes_diag_diabetesii == 1)
	replace diag3 = . if diabetes_diag_diabetes == . | diabetes_diag_diabetes == .a

	*Tuberculosis
	gen 	diag4 = (tb_diag_tuberculosis == 1)
	replace diag4 = . if tb_diag_tuberculosis == . | tb_diag_tuberculosis == .a

	*Malaria: Giving credit for malaria, simple malaria or severe malaria. 
	*Most people lose credit for not diagnosing anemia, very few miss malaria of some type
	gen 	diag5 = (malaria_diag_anemia == 1 & (malaria_diag_malaria == 1 | malaria_diag_simpmalaria == 1 | malaria_diag_sevmalaria == 1))
	replace diag5 = . if malaria_diag_malaria == . | malaria_diag_malaria == .a
	
	*Malaria - credit for just malaria
	gen 	diag5_simp = (malaria_diag_malaria == 1 | malaria_diag_simpmalaria == 1 | malaria_diag_sevmalaria == 1)
	replace diag5_simp = . if malaria_diag_malaria == . | malaria_diag_malaria == .a

	*Post partum hemorrhage 
	gen 	diag6 = (pph_diag_pph == 1)
	replace diag6 = . if pph_diag_pph == . | pph_diag_pph == .a
	
	*Neonatal asphyxia
	gen 	diag7 = (asphyxia_diag_neo_asphyxia == 1 | asphyxia_diag_respdis == 1)
	replace diag7 = . if asphyxia_diag_neo_asphyxia == . | asphyxia_diag_neo_asphyxia == .a
		
	*Labels
	lab var diag1 "Correct diagnosis for Diarrhea"
	lab var diag2 "Correct diagnosis for Pneumonia"
	lab var diag3 "Correct diagnosis for Diabetes"
	lab var diag4 "Correct diagnosis for Tuberculosis"
	lab var diag5 "Correct diagnosis for Malaria"
	lab var diag6 "Correct diagnosis for PP hemorrhage"	
	lab var diag7 "Correct diagnosis for Asphyxia"
	
	*Averages
	egen 	diag_accuracy = rowmean(diag1 diag2 diag3 diag4 diag5)
	lab var diag_accuracy "Diagnostic accuracy"
	
	foreach var of varlist diag* {
		replace `var' = `var'*100
		di in red `var'
		summ `var' 
		}	
	
	*Diarrhea 
	*Full compliance require ORS and Zinc. Alternately, IV or NGtube
	gen 	treat1 = (diarrhea_treat_ors == 1 & diarrhea_treat_zinc == 1) | (diarrhea_treat_ivfluids == 1 | diarrhea_treat_ngtube == 1)
	replace treat1 = . if diarrhea_treat_ors == . | diarrhea_treat_ors == .a
	lab var treat1 "Correct treatment for diarrhea and dehydration proposed"
	
	*Pneumonia
	gen 	treat2pne = (pneumonia_treat_amoxycillin == 1 | pneumonia_treat_amoxy_dose == 1)
	replace treat2pne = . if (pneumonia_treat_amoxycillin == . & pneumonia_treat_amoxy_dose == .)
	lab var treat2pne "Correct treatment for pneumonia proposed"

	gen 	treat2fev = pneumonia_treat_antipyretics == 1 | pneumonia_treat_paractmol_dose == 1 | pneumonia_treat_paractml == 1
	replace treat2fev = . if pneumonia_treat_antipyretics == . & pneumonia_treat_paractmol_dose == . & pneumonia_treat_paractml == .
	lab var treat2fev "Correct treatment for fever proposed"

	gen 	treat2 = (treat2pne == 1 & treat2fev == 1)
	replace treat2 = . if treat2pne == . | treat2fev == .
	lab var treat2 "Correct treatment for pneumonia and fever proposed"

	*Diabetes		
	*Hypoglycemics or insulin if hypo not effective.
	*Giving credit for either of those two or referral to another facility
	egen 	treat3 = anycount(diabetes_treat_hypoglycmcs diabetes_treat_insulin diabetes_refer_specialist), val(1)
	replace treat3 = 1 if treat3 >= 1 & treat3 != .
	replace treat3 = . if diabetes_treat_hypoglycmcs == . & diabetes_treat_insulin == . & diabetes_refer_specialist == .
	lab var treat3 "Correct treatment for diabetes mellitus proposed"

	*TB
	*Simple definition 
	gen 	treat4 = (tb_treat_ct == 1 | tb_treat_ctdur == 1 | tb_treat_ctdose == 1) 
	replace treat4 = 1 if tb_refer_tbclinic == 1 // Also giving credit for referral to clinic
	replace treat4 = . if tb_treat_ct == . & tb_treat_ctdur == . & tb_treat_ctdose == . & tb_refer_tbclinic == .
	lab var treat4 "Correct treatment for tuberculosis proposed"
	
	*Malaria 
	*Malaria questions labeled differently across different countries 
	*Generally giving credit for any treatment with artemisin (ACT) or artemether-lumefantrin (coartem)
	egen 	maltreat = anycount(malaria_treat_mono malaria_treat_al_wdose malaria_treat_al malaria_treat_artesunateam), val(1)
	replace maltreat = 1 if maltreat > 1 & maltreat != .
	replace maltreat = . if malaria_treat_mono == . & malaria_treat_al_wdose == . & malaria_treat_al == . & malaria_treat_artesunateam == .  

	*Anemia treatment
	gen 	anem_treat = (malaria_treat_iron == 1 | malaria_treat_iron_folicacid == 1)
	replace anem_treat = . if malaria_treat_iron == . & malaria_treat_iron_folicacid == .
	lab var anem_treat "Correct treatment for anemia proposed"
	
	*Actual variable
	gen 	treat5 = (maltreat == 1 & anem_treat == 1)
	replace treat5 = . if maltreat == . | anem_treat == .
	lab var treat5 "Correct treatment for malaria and anemia proposed"

	*PPH
	egen 	oxytoc = anycount(pph_treat_oxytocin_iv pph_treat_oxytocin pph_treat_oxytocin_im	///
							  pph_treat_oxytocin_dose20 pph_treat_oxytocin_ratedrops 			///
							  pph_treat_oxytocin_dose10 pph_treat_oxytocin_rateliter), val(1)
	replace oxytoc = 1 if oxytoc >= 1 & oxytoc != .
	replace oxytoc = . if pph_treat_oxytocin_iv == . & pph_treat_oxytocin == . & 			///
						  pph_treat_oxytocin_im == . & pph_treat_oxytocin_dose20 == . & 	///
						  pph_treat_oxytocin_ratedrops == . & 								///
						  pph_treat_oxytocin_dose10 == . & pph_treat_oxytocin_rateliter == . 
	
	egen 	other_utero_proposed = anycount(pph_treat_prostaglandins pph_treat_misoprostol 	///
								  pph_treat_ergometrine pph_treat_ergometrine_dose5), val(1)
	replace other_utero_proposed = 1 if other_utero_proposed >= 1 & other_utero_proposed != .
	replace other_utero_proposed = . if pph_treat_prostaglandins == . & 					///
										pph_treat_misoprostol == . & 						///
										pph_treat_ergometrine == . & pph_treat_ergometrine_dose5 == .  
	
	gen 	any_oxytoc = (oxytoc == 1 | other_utero_proposed == 1)
	replace any_oxytoc = . if oxytoc == . & other_utero_proposed == .

	gen 	run_iv = (pph_treat_plasmion == 1 | pph_treat_iv == 1)
	replace run_iv = . if pph_treat_plasmion == . & pph_treat_iv == .

	*Five potential actions that we'll consider 
	egen 	pph_actions = rowtotal(pph_treat_cause pph_treat_catheter pph_treat_massage run_iv any_oxytoc)
	gen 	treat6=(pph_actions == 5)
	lab var pph_actions "Number of correct actions for postpartum hemorrhage proposed"
	lab var treat6 "Correct treatment for postpartum hemorrhage proposed"

	*Asphyxia
	*Multiple position variables
	gen 	aa_position = (aa_position1 == 1 | aa_position2 == 1)
	replace aa_position = . if aa_position1 == . & aa_position2 == .
	
	*Multiple resuscitation variables
	gen 	resus = (aa_resusmask == 1 | aa_resus == 1)
	replace resus = . if aa_resusmask == . & aa_resus == .

	*Seven actions that we'll consider
	egen 	asphyxia_actions = rowtotal(aa_call_help aa_drybaby aa_babywarm aa_position aa_heartrate aa_breathing resus)  
	lab var asphyxia_actions "Number of correct actions for neonatal asphyxia proposed"
	gen 	treat7=(asphyxia_actions == 7)
	lab var treat7 "Correct treatment for neonatal asphyxia proposed"

	*Convert to percentile
	*Averages
	foreach var of varlist treat* {
		replace `var' = `var'*100
		di in red `var'
		summ `var' 
		}	
	
	egen 	treat_accuracy = rowmean(treat1 treat2 treat3 treat4 treat5)
	replace treat_accuracy = treat_accuracy*100
	gen 	pph_perc = (pph_actions/5)*100
	gen 	asphyxia_perc = (asphyxia_actions/7)*100
	lab var treat_accuracy "Treatment accuracy"
	lab var pph_perc "Percent of PPH actions"
	lab var asphyxia_perc "Percent of asphyxia actions"

	*Unnecessary use of antibiotics or antimalarials ***
	*Inappropriate antibiotic prescription for TB 
	gen 	tb_antibio = (tb_treat_macrolide == 1 | tb_treat_amoxicillin == 1)
	replace tb_antibio  = . if tb_treat_macrolide == . & tb_treat_amoxicillin == .

	*Inappropriate antibiotic prescription for diarrhea
	gen diar_antibio = diarrhea_treat_antibiotics
	
	*Inappropriate antibiotic prescription for both	
	gen 	bad_antibio = (tb_antibio == 1 | diar_antibio == 1)
	replace bad_antibio = . if tb_antibio == . & diar_antibio == .
	replace bad_antibio = bad_antibio*100
	lab var bad_antibio "Inappropriate antibiotic prescription"
exit 
 
/*
	*Remove observations that are missing all vignettes
	egen 	number_missing = anycount(missing_v*), val(1)
	tab 	number_missing 
	drop if number_missing==6  //195 observations were dropped

	*Recode observations in missing vignettes from no to missing
	foreach x in "b" "c" "d" "e" "g" "h" {
		ds m3s`x'q*, has(type numeric)
		local vl "`r(varlist)'"
		foreach var of var `vl' {
			replace `var' = . if `var' == 0 & missing_v`x' == 1
			replace `var' = 0 if `var' == . & missing_v`x' == 0
		}
	}
*/ 

	*Save harmonized dataset
	isid 	unique_id
	sort 	unique_id
	order 	country year unique_id facility_id provider_id
	save	"$EL_dtInt/Module 3/Malawi_2019_mod_3.dta", replace 

************************** End of do-file **************************************
