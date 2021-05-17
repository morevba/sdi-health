* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Translates the Guinea Bissau dataset 				   *
*				Facility & Provider ID								   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Translates the Guinea Bissau dataset from French to 
				  English 
       ** IDS VAR: country year facility id provider id  
       ** NOTES:
       ** WRITTEN BY: Michael Orevba
       ** Last date modified: Jan 25th 2021
 */

/**********************************************
	Install Google translate program command 
***********************************************/

*Run the Google translation command - obtained from "https://gist.github.com/bbdaniels/9d8f6e0df0a7f444b027895914e6be6a"
cap prog drop gtrans
	prog def gtrans , rclass
	
	syntax anything
	preserve
		qui {
			local theText = subinstr("`anything'"," ","%20",.) // HTML for whitespace
					
			import delimited using ///
			"https://translation.googleapis.com/language/translate/v2?q=`theText'&target=en&format=text&source=pt&model=nmt&key=AIzaSyCovfJgmflks7Mnrgt_O5Ey-JR2uKZSriE", clear
				
			keep v1
				keep if regexm(v1,"translated")
				replace v1 = substr(v1,strpos(v1,":")+1,.)
				replace v1 = subinstr(v1,`"""',"",.)
				replace v1 = subinstr(v1,",","",.)
				replace v1 = trim(v1)
				local theNewText = v1 in 1
				
				return local text = "`theNewText'"
		}	
	end

/*********************
	All merge dataset 
***********************/

	*Open Guinea Bissau all merge dataset  
	use	"$EL_dtRaw/Guinea Bissau 2018/Module 1 2 and 4_FINAL.dta", clear  
	
	/**********************************************
		Translate all variable labels 
	***********************************************/
	 
	*Create loop to translate all variables 
		foreach v of varlist _all  {
			local varlabel `"`: var label `v''"' // Store all variable labels in a local
		
		cap	gtrans	`varlabel'					// gtrans command translates all the variable labels stored in the local
			
			return list 						// return the translated word into Englosh 
			local new_label "`r(text)'"
			label var `v' "`new_label'"			// Label variabel with translated English word 
	}

	/**********************************************
		Translate all the value labels
	***********************************************/
	
	*List all value labels in the dataset 
	label dir 

	*Create and replace new value labels 
	label define 	M4_D_4f_lab	1 "Appointed by the local authority" 2 "Community electoral process" 						///
								3 "Chosen on the advice of the Minister" 4 "Appointed by the union of health professionals"	///
								5 "Other"
	label values 	M4_D_4f2 M4_D_4f3 M4_D_4f4 M4_D_4f5 M4_D_4f6 M4_D_4f_lab


	label define 	yesno 		1 "Yes" 2 "No"
	label values 	M4_D_4e* M1_D_5* M1_D_6* M1_D_7* I_1 M1_B_14 M1_B_21 M1_B_22 M1_B_23 M1_B_24 M1_B_25 M1_B_26 M1_B_27	///
					M1_B_28 M1_B_29	M1_B_30 M1_B_31 M1_B_32 M1_B_33 M1_B_38 M1_C_2 M1_C_5a M1_C_14a M1_C_21 M1_C_23 		///
					M1_C_25 M1_C_26b M1_C_27b M1_C_28b M1_C_29b M1_C_30b M1_C_31b M1_C_32b M1_C_34 M1_C_35 M1_E_62 			///
					M1_E_63 M1_E_64 M4_A_15 M4_A_16 M4_A_17 M4_A_26 M4_A_23 M4_A_29 M4_A_31 M4_A_32 M4_A_34 M4_A_40 		///
					M4_A_43 M4_A_45 M4_B_30a M4_B_31a M4_B_32a M4_B_33a M4_B_34a M4_B_35a M4_B_36a M4_B_37a M4_B_38a 		///
					M4_B_38_1a M4_B_41 M4_B_43 M4_B_46 M4_B_48 M4_B_50 M4_B_51 M4_B_52 M4_B_53 M4_B_54 M4_B_55 M4_B_57 		///
					M4_B_58 M4_B_59 M4_B_60 M4_B_61 M4_B_64 M4_C_4 M4_C_5 M4_C_7 M4_C_8 M4_C_9 M4_C_10 M4_D_1 M4_D_5 M4_D_7 ///
					M4_D_10 M4_D_11 M4_D_12 M4_D_14 M4_D_16 M4_D_18 M4_D_20 M4_D_21	M4_D_23 M1_D_1* M1_D_2* M1_D_3*  yesno

	label define 	M4_D_4d_lab	0 "None (Never went to school)" 1 "Basic education not complete (1st to 5th)"	///
								2 "Complete Basic Education (6th year)" 3 "Non Completed Secondary (7 ° to 10 °)"	///
								4 "Complete Secondary (11 °)" 5 "Professional / Medium Technical Certificate"	///
								6 "Complete University Level" 7 "Diploma of University Post-Graduation"		///
								8 "Coranica School Only" 99 "Other (specify)"
	labe values 	M4_D_4d1 M4_D_4d2 M4_D_4d3 M4_D_4d4 M4_D_4d5 M4_D_4d6 M4_D_4d_lab

	label define 	gender 	1 "Male" 2 "Female"
	label values 	M4_D_4b* gender 

	label define 	M1_E_4_lab	1 "Seen at least one (E unexpired)" 2 "Seen at least one (MAS expired)"	///
								3 "Available MAS not seen (not expired)" 4 "Not available on the day"	///
								5 "Never available"
	label values 	M1_E_42* M1_E_43*  M1_E_4_lab


	label define 	M1_E_5_lab 1 "As indicated" 2 "Other"
	label values 	M1_E_52* M1_E_53* M1_E_62* M1_E_63* M1_E_94* M1_E_95* M1_E_84* M1_E_85* M1_E_5_lab

	label define 	M1_E_7_lab 	1 "Seen at least one (E unexpired)" 2 "Seen at least one (MAS expired)"	///
								3 "Available MAS not seen (not expired)" 4 "Not available on the day"	///
								5 "Never available"
	label values 	M1_E_7* M1_E_7_lab

	label define 	rural_labl 1 "Rural" 2 "Urban"
	label values	M1_A_7 rural_labl


	label define 	M1_B_3_lab 	1 "Director" 2 "Deputy Director" 3 "Head of service / Head of department"	///
								4 "Deputy Head of Service / Head of Department" 5 "Supervisor"				///
								6 "Agent" 7 "Head Nurse" 8 "Deputy Chief Nurse" 9 "Without post"			///
								99 "Other (specify)"
	label values 	M1_B_3 M1_B_3_lab


	label define 	M1_B_4_lab 	1 "Government (Public)" 2 "Private non-profit / NGO" 					///
								3 "Private non-profit / religious organization" 4 "Private for-profit"	///
								9 "Other (specify)"
	label values 	M1_B_4 M1_B_5 M1_B_6 M1_B_7 M1_B_4_lab


	label define 	M1_B_8_lab 	1 "Type A health center" 2 "Type B health center" 3 "Type C health center"	///
								4 "Maternal and Child Center" 5 "Regional hospital" 6 "Reference Hospital"	///
								7 "General hospital" 8 "National/Central Hospital" 9 "Specialized hospital"	///
								99 "Other (specify)"
	label values 	M1_B_8 M1_B_8_lab


	label define 	M1_B_9_lab 	1 "Car" 2 "Motorized (includes motorized canoe)" 3 "Bicycle" 4 "On foot"	///
								5 "In Canoe" 6 "The unit is in the same building as the regional headquarters"
	label values 	M1_B_9* M1_B_9_lab


	label define 	M1_C_1_lab 	1 "Has no power" 2 "Electricity network (EAGB)" 3 "Fuel generator"	///
								4 "Battery powered generator" 5 "Solar panel" 6 "Other (specify)"

	label define 	M1_C_6_lab	1 "Has no water supply" 2 "Channeled in the building (EAGB)"		///
								3 "Public fountain" 4 "Natural well/bore" 5 "Protected dug well/hole"	///
								6 "Unprotected well/bore" 7 "Protected spring" 8 "Unprotected source"	///
								9 "Rain water" 10 "Bottled water" 11 "Wagon with small tank" 			///
								12 "Tank truck" 13 "Surface waters" 14 "Other (specify)"
	label values 	M1_C_6 M1_C_6_lab


	label define 	M1_C_11_lab	1 "No bathroom/in the bush" 2 "Bathroom not working"		///
								3 "Open pit latrine without slab (outside the building)"	///
								4 "Open pit latrine with slab (outside the building)"		///
								5 "Covered pit latrine without slab (outside the building)"	///
								6 "Pit latrine covered with slab (outside the building)"	///
								7 "VIP latrine (ventilation) (outside the building)"		///
								8 "Toilet with compost septic tank"							///
								9 "Toilet with septic tank plus discharge without water"	///
								10 "Toilet with septic tank plus water discharge"			///
								99 "Other (specify)"
	label values 	M1_C_11 M1_C_11_lab


	label define 	M1_C_14b_lab	1 "There is no toilet/in the bush" 2 "Toilet that is not working"		///
									3 "Open pit latrine without slab" 4 "Open pit latrine with slab"		///
									5 "Covered pit latrine without slab" 6 "Pit latrine covered with slab"	///
									7 "VIP latrine (ventilation)" 8 "Retrete com compostagem" 				///
									9 "Toilet with flush without water" 10 "Water flushing toilet"			///
								99 "Other (specify)"
	label values 	M1_C_14b M1_E_81 M1_E_82 M1_E_83 M1_E_84 M1_E_85 M1_C_14b_lab

	label define 	M1_C_18_lab 1 "Not visible waste" 2 "Visible waste plus protected area"	///
								3 "Visible waste plus unprotected area" 4 "Site not inspected"
	label values 	M1_C_18 M1_C_21 M1_C_18_lab

	label define 	M1_C_24_lab 1 "Yes-guides observed" 2 "Yes-guides not observed" 3 "No"
	label values 	M1_C_24 M1_C_26a M1_C_27a M1_C_28a M1_C_29a M1_C_30a M1_C_31a M1_C_32a	///
					M1_C_24_lab

	label define 	M1_C_36_lab 1 "To transport a patient" 2 "To get medicines and other materials"	///
								3 "To transport a health professional to another post" 9 "Other (specify)"
	label values 	M1_C_36 M1_C_36_lab

	label define 	M1_E_65_lab	1 "Yes and observed" 2 "Yes but not observed" 3 "Does not work"	///
								4 "Not available"
	label values 	M1_E_65 M1_E_67 M1_E_65_lab

	label define 	M1_E_68_lab	1 "Electricity network" 2 "Generator" 3 "Batteries (car)" 4 "Gasoline"	///
								5 "Gas" 6 "Solar panel" 9 "Other (specify)"
	label values 	M1_E_68 M1_E_68_lab

	label define 	M1_E_69_lab	1 "Seen at least one (E unexpired)" 2 "Seen at least one (MAS expired)"	///
								3 "Available MAS not seen (not expired)" 4 "Not available on the day"	///
								5 "Never available"
	label values 	M1_E_69 M1_E_70 M1_E_71 M1_E_72 M1_E_73 M1_E_74 M1_E_75 M1_E_76 M1_E_77 M1_E_78		///
					M1_E_79 M1_E_80 M1_E_69_lab



	label define 	M4_A_2_a_lab 	1 "National level government agencies" 2 "Regional level government agencies"			///
									3 "Sector-level government agencies" 4 "Inspectors" 									///
									5 "Director/Head of the health unit" 6 "Health Unit/Hospital Management Committee"		///
									7 "Clinical Director" 8 "Doctors" 9 "Funcionários da unidade sanitária" 				///
									10 "Community/NGOs" 11 "Faith-based organizations (OBF)" 12 "Politicians"				///
									13 "Donors" 14 "Private companies" 99 "Other (specify)"
	label values 	M4_A_2_a M4_A_3_a M4_A_4_a M4_A_5_a M4_A_8_a M4_A_9_a M4_A_2_a_lab

	label define 	M4_A_2_b_lab 1 "None" 2 "Some" 3 "Lots of"
	label values 	M4_A_2_b M4_A_3_b M4_A_4_b M4_A_5_b M4_A_6_b M4_A_7_b M4_A_8_b M4_A_9_b M4_A_10_b M4_A_2_b_lab

	label define 	M4_A_19_lab 1 "Yes; visa" 2 "Yes; not seen" 3 "Not"
	label values 	M4_A_19 M4_A_19_lab

	label define 	M4_A_25_a_lab 	1 "Approves your absence and finds a replacement for those days"																	///
									2 "Tell him that this is not acceptable and that, if this behavior persists, he will have to start handling papers to dismiss him" 	///
									3 "Try to provide transportation and reduce the time you are away from the center"													///
									4 "Approves your absence but speak to the person and asks him to work more hours the rest of the week to reset Monday"
	label values 	M4_A_25_a M4_A_25_a_lab


	label define 	M4_A_25_b_lab	1 "Request the transfer of the health professional."										///
									2 "It requires you to improve your performance. If it doesn't improve, request a transfer." ///
									3 "It gives you the freedom to set your own goals and does not put pressure on you."		///
									4 "He sends you for additional training and then supervises your progress. If it doesn't improve, request a transfer."
	label values 	M4_A_25_b M4_A_25_b_lab


	label define 	M4_A_25_c_lab	1 "Buy medicines in the city with your own money and make them available for purchase by patients who need them"	///
									2 "He instructs his clinical staff to ask patients to buy the drugs at a pharmacy in the city."						///
									3 "It requests more supplies from the government and/or asks for help from the other health unit."					///
									4 "It requests more supplies from the government and/or asks for help from the other health unit."
	label values 	M4_A_25_c M4_A_25_c_lab


	label define 	M4_A_44_lab	1 "A short course (less than a month)" 2 "A short course (more than a month)"	///
								3 "One or more courses as part of my medical training" 4 "Medium level in management"	///
								5 "Degree in management" 6 "Postgraduate in Management" 9 "Other (specify)"
	label values 	M4_A_44 M4_A_44_lab

	label define 	M4_B_1_lab 1 "Yes" 2 "No" 98 "The sanitary unit does not charge user fees"
	label values 	M4_B_1 M4_B_1_lab

	label define 	M4_B_45_lab 1 "Monthly visit" 2 "Quarterly" 3 "Bimonthly" 4 "Semester" 5 "Never"
	label values 	M4_B_45 M4_B_45_lab

	label define 	M4_B_47_lab 1 "Frame" 2 "Meetings" 3 "Posters" 4 "Other (specify)"
	label values 	M4_B_47 M4_B_47_lab

	label define 	M4_B_49_lab 1 "Monthly" 2 "Quarterly" 3 "Bimonthly" 4 "Semester" 5 "Yearly"
	label values 	M4_B_49 M4_B_56 M4_B_49_lab

	label define 	M4_B_65_lab 1 "Unit delay submitting PIT" 2 "Min Saude did not approve the PIT"
	label values 	M4_B_65 M4_B_65_lab

	label define 	M4_C_1a_lab 1 "pull" 2 "pushes"
	label values 	M4_C_1a M4_C_1a_lab

	label define 	M4_C_13_lab 1 "Monthly" 2 "Quarterly" 3 "Bimonthly" 4 "Semester" 5 "Yearly" 6 "Never"
	label values 	M4_C_13  M4_C_13_lab

	label define 	M4_D_6_lab 	1 "Appointed by the local authority" 2 "Community electoral process"	///
								3 "Chosen on the advice of the Minister" 4 "There are no community members"
	label values 	M4_D_6 M4_D_6_lab

	label define 	M1_A_18a_lab 1 "Completed survey" 2 "Incomplete questionnaire" 3 "Unit closed" 4 "Declined"
	label values 	M1_A_18a M1_A_18a_lab

	label define 	M4_A_1_lab	1 "Availability of medicines" 2 "Staff availability" 3 "Lack of trained personnel"	///
								4 "Lack of adequate infrastructure" 5 "Lack of equipment" 6 "Lack of leadership"	///
								7 "Lack of leadership" 8 "There are no limiting factors" 9 "Other (specify)"		///
								10 "Lack of laboratory"
	label values 	M4_A_1 M4_A_1_lab

	label define 	M4_A_6_a_lab	1 "National level government agencies" 2 "Provincial-level government agencies"	///
									3 "District/local government agencies" 4 "Inspectors" 							///
									5 "Director/Head of the health unit" 											///
									6 "Health Unit / Hospital Management Committee" 7 "Clinical Director"			///
									8 "Doctors" 9 "Health facility staff" 10 "Community/NGOs" 						///
									11 "Faith-based organizations (OBF)" 12 "Politicians" 13 "Donors"				///
									14 "Private companies" 99 "Other (specify)" 100 "Administrator"
	label values 	M4_A_6_a M4_A_7_a M4_A_10_a M4_A_6_a_lab

	label define 	M4_B_42_lab	1 "Report was not ready" 2 "Report not approved"										///
								3 "Report not approved by the Ministry of Health" 4 "Bank reconciliation was not done"	///
								5  "Other (specify)" 6 "Was not asked"
	label values 	M4_B_42 M4_B_42_lab

	label define 	M4_B_44_lab	1 "Responsible for the Health Unit" 2 "Tesoureiro" 3 "President" 						///
								4 "Sector accountant" 5 "Other (specify)" 6 "Administrator"
	label values 	M4_B_44 M4_B_44_lab

	label define 	M1_D_4_lab 1 "Units" 2 "Individual"
	label values 	M1_D_4* M1_D_4_lab

	label define 	M1_E_1_lab	1 "Seen at least one (E unexpired)" 2 "Seen at least one (MAS expired)"	///
								3 "Available MAS not seen (not expired)" 4 "Not available on the day"	///
								5 "Never available"
	label values 	M1_E_1* M1_E_1_lab

	label define 	M1_E_2_lab 1 "As indicated" 2 "Another"
	label values 	M1_E_2* M1_E_3* M1_E_2_lab
	
	/**************************
		Save translated dataset 
	***************************/

	*Save translated Guinea Bissau all merge dataset variables 
	save "$EL_dtRaw/Guinea Bissau 2018/Translated/Module 1 2 and 4_FINAL_tran.dta", replace   

/***************************
	Adult surveys 
*****************************/

	*Open adult surveys dataset 
	use	"$EL_dtRaw/Guinea Bissau 2018/Adult patients.dta", clear  

	/**********************************
		Translate all variable labels 
	************************************/
	 
	*Create loop to translate all variables 
	foreach v of varlist _all  {
		local varlabel `"`: var label `v''"' 	// Store all variable labels in a local
		
		cap	gtrans	`varlabel'					// gtrans command translates all the variable labels stored in the local
			
			return list 						// return the translated word into Englosh 
			local new_label "`r(text)'"
			label var `v' "`new_label'"			// Label variabel with translated English word 
	}
	
	/**********************************
		Translate all value labels 
	************************************/
	
	label define 	pacienteAdulto__id_lab 1 "Adult Patient 1" 2 "Adult Patient 2"
	label values 	pacienteAdulto__id pacienteAdulto__id_lab

	label define 	yesno 	1 "Yes" 2 "No"
	label values	M3_B_1_1 M3_B_1_11 M3_B_1_12 M3_B_1_14 M3_B_1_15 M3_B_1_19 M3_B_1_20	///
					M3_B_1_21 M3_B_1_22 M3_B_1_23 M3_B_1_24 M3_B_1_25 M3_B_1_26 M3_B_1_27 	///
					M3_B_1_28 M3_B_1_29 M3_B_1_35a yesno

	label define 	M3_B_1_8_lab 1 "New" 2 "Repeated" 3 "Do not know"
	label values 	M3_B_1_8 M3_B_1_8_lab


	label define 	M3_B_1_9_lab 1 "Youth (18-25)" 2 "Medium (26-45)" 3 "Senior (46+)"
	label values 	M3_B_1_9 M3_B_1_9_lab

	label define 	gender 	1 "Male" 2 "Female"
	label values 	M3_B_1_10 gender 


	label define 	M3_B_1_16b_lab 1 "Hours" 2 "Days" 3 "Semanas" 4 "Months" 5 "Years"
	label values 	M3_B_1_16b M3_B_1_17b M3_B_1_16b_lab


	label define 	M3_B_1_18_lab 1 "Yes" 2 "No" 3 "Do not know"
	label values 	M3_B_1_18 M3_B_1_18_lab

	label define 	M3_B_1_29a_lab 1 "FEVER" 2 "COUGH" 3 "DIARRHEA" 4 "OTHERS"
	label values 	M3_B_1_29a M3_B_1_29a_lab
		
	/**************************
		Save translated dataset 
	***************************/

	*Save translated adult surveys dataset variables 
	save "$EL_dtRaw/Guinea Bissau 2018/Translated/Adult patients_tran.dta", replace   
		

/***************************
	Adult exit surveys 
*****************************/

	*Open adult surveys dataset 
	use	"$EL_dtRaw/Guinea Bissau 2018/Adult exit surveys.dta", clear  

	/**********************************
		Translate all variable labels 
	************************************/
	 
	*Create loop to translate all variables 
	foreach v of varlist _all  {
		local varlabel `"`: var label `v''"' 	// Store all variable labels in a local
		
		cap	gtrans	`varlabel'					// gtrans command translates all the variable labels stored in the local
			
			return list 						// return the translated word into Englosh 
			local new_label "`r(text)'"
			label var `v' "`new_label'"			// Label variabel with translated English word 
	}
	
	/**********************************
		Translate all value labels 
	************************************/
	
	label define 	saidaAdulto__id_lab 1 "Adult Patient 1" 2 "Adult Patient 2"
	label values 	saidaAdulto__id saidaAdulto__id_lab

	label define 	M5_A_1_lab  1 "Malaria" 2 "Upper respiratory tract infections (Cough)"	///
								3 "Diarrhea" 4 "Fever" 5 "Weakness" 6 "Injury" 7 "Vomit"	///
								8 "Dermatological" 9 "Pain (tell me where)" 10 "Other complaint (please specify)"	///
								11 "Family planning" 12 "Prenatal care" 13 "Prenatal care" ///
								14 "Voluntary HIV testing and counseling" 					///
								15 "Get medicine" 16 "Another non-healing visit (specify)"
	label values 	M5_A_1 M5_A_1_lab

	label define 	M5_A_4_lab	0 "None (Never went to school)" 1 "Basic education not complete (1st to 5th)"		///
								2 "Complete Basic Education (6th year)" 3 "Non Completed Secondary (7 ° to 10 °)"	///
								4 "Complete Secondary (11 °)" 5 "CertificateTechnical Professional/Medium"			///
								6 "Complete University Level" 7 "Diploma of University Post-Graduation"				///
								8 "Coranica School Only" 9 "Other (specify)"
	label values 	M5_A_4 M5_A_4_lab

	label define 	gender 	1 "Male" 2 "Female"
	label values	M5_A_5 gender 

	label define 	M5_A_6_lab 1 "Not married" 2 "Married/de facto marriage" 3 "Widower" 4 "Divorced/Separated"
	label values 	M5_A_6 M5_A_6_lab


	label define 	M5_A_7_lab	0 "None (Never went to school)" 1 "Basic education not complete (1st to 5th)"		///
								2 "Complete Basic Education (6th year)" 3 "Non Completed Secondary (7 ° to 10 °)"	///
								4 "Complete Secondary (11 °)" 5 "CertificateTechnical Professional/Medium"			///
								6 "Complete University Level" 7 "Diploma of University Post-Graduation"				///
								8 "Coranica School Only" 9 "Other (specify)"
	label values 	M5_A_7 M5_A_7_lab

	label define 	yesno 	1 "Yes" 2 "No"
	label values 	M5_A_8a M5_A_8b M5_A_8c M5_A_8d M5_A_8e M5_A_8f M5_A_8g M5_A_8h M5_A_9 M5_A_10 M5_A_11 M5_A_12	///
					M5_A_13 M5_A_14 M5_A_15 M5_A_17 M5_A_24 M5_A_27 M5_A_29 M5_A_33 M5_A_35 M5_A_63a yesno

	label define 	M5_A_19_lab	1 "Less than 1km" 2 "1km - 5km" 3 "6 -10 Km" 4 "Above 10Km"
	label values 	M5_A_19 M5_A_19_lab


	label define 	M5_A_21_lab	1 "On foot" 2 "Bicycle" 3 "Animal" 4 "Private car" 5 "Bus or taxi"	///
								6 "Private motorcycle" 7 "Bike taxi" 8 "Other (specify)"
	label values 	M5_A_21 M5_A_21_lab


	label define 	M5_A_34_lab 1 "Public" 2 "Private" 3 "Community"
	label values 	M5_A_34 M5_A_34_lab


	label define 	M5_A_36_lab 1 "Lacking" 2 "Couldn't buy/pay" 3 "Other (specify)"
	label values 	M5_A_36 M5_A_36_lab

	label define 	M5_A_37_lab 1 "Very good" 2 "Boa" 3 "Normal" 4 "Ruim" 5 "Muito Ruim"
	label values 	M5_A_37 M5_A_37_lab

	label define 	M5_A_38a_lab	1 "I can do it easily" 2 "I can do it but with help" 3 "I can't do it at all"	///
									99 "I do not know"
	label values 	M5_A_38a M5_A_38b M5_A_38c M5_A_38d M5_A_38a_lab

	label define 	M5_A_39_lab	1 "Location close to home" 2 "Low cost" 3 "Trust in providers/High quality"			///
								4 "Service Opportunity/Readiness" 5 "Availability of medicines"						///
								6 "Availability of women as health professionals" 7 "Recommendation or reference"	///
								8 "The unit is the only option available" 9 "Other (specify)"
	label values 	M5_A_39 M5_A_40 M5_A_39_lab

	label define	M5_A_41_lab 1 "I fully agree" 2 "I agree" 3 "I disagree" 4 "Strongly disagree" 5 "Does not apply to me"
	label values 	M5_A_41 M5_A_42 M5_A_43 M5_A_44 M5_A_45 M5_A_46 M5_A_47 M5_A_48 M5_A_49 M5_A_50 	///
					M5_A_51 M5_A_52 M5_A_53 M5_A_54 M5_A_55 M5_A_56 M5_A_57 M5_A_58 M5_A_59 M5_A_60		///
					M5_A_61 M5_A_62 M5_A_41_lab

	label define	M5_A_64_lab	1 "Earth/Clay Bricks" 2 "Stone" 3 "Ceramic brick" 4 "Cement/Concrete" 5 "Wood/Bamboo"			///
								6 "Zinc" 7 "Cardboard" 8 "Tile/Slate" 9 "Floor" 10 "Clay/Straw" 11 "Thatch (grass or straw)"	///
								12 "Roof tile" 13 "Asbestos" 14 "Other (specify)"
	label values 	M5_A_64 M5_A_65 M5_A_66 M5_A_64_lab
		
	/**************************
		Save translated dataset 
	***************************/

	*Save translated adult exit surveys dataset variables 
	save "$EL_dtRaw/Guinea Bissau 2018/Translated/Adult exit surveys_tran.dta", replace   

/***************************
	Child surveys 
*****************************/

	*Open adult surveys dataset 
	use	"$EL_dtRaw/Guinea Bissau 2018/Child patients.dta", clear  

	/**********************************
		Translate all variable labels 
	************************************/
	 
	*Create loop to translate all variables 
	foreach v of varlist _all  {
		local varlabel `"`: var label `v''"' 	// Store all variable labels in a local
		
		cap	gtrans	`varlabel'					// gtrans command translates all the variable labels stored in the local
			
			return list 						// return the translated word into Englosh 
			local new_label "`r(text)'"
			label var `v' "`new_label'"			// Label variabel with translated English word 
	}
	
	/**********************************
		Translate all value labels 
	************************************/
	
	label define 	pacienteCrianca__id_lab 1 "Child Patient 1" 2 "Child Patient 2"
	label values 	pacienteCrianca__id pacienteCrianca__id_lab

	label define 	yesno 	1 "Yes" 2 "No"
	label values	M3_B_2_1 M3_B_2_11 M3_B_2_12 M3_B_2_14 M3_B_2_15 M3_B_2_19 M3_B_2_20 	///
					M3_B_2_21 M3_B_2_22 M3_B_2_23 M3_B_2_25 M3_B_2_26 M3_B_2_27 M3_B_2_28	///
					M3_B_2_29 M3_B_2_30 M3_B_2_31 M3_B_2_39a yesno

	label define 	M3_B_2_8_lab 1 "New" 2 "Repeated" 3 "Do not know"
	label values 	M3_B_2_8 M3_B_2_8_lab

	label define 	M3_B_2_9_lab 0 "Baby (less than 1 year)" 1 "1 year" 2 "2 years"	///
							  3 "3 years" 4 "4 years" 5 "5 years" 
	label values 	M3_B_2_9 M3_B_2_9_lab

	label define 	gender 	1 "Male" 2 "Female"
	label values 	M3_B_2_10 gender 

	label define 	M3_B_2_16b_lab 1 "Hours" 2 "Days" 3 "Semanas" 4 "Months" 5 "Years"
	label values 	M3_B_2_16b M3_B_2_17b M3_B_2_16b_lab

	label define 	M3_B_2_18_lab 1 "Yes" 2 "No" 3 "Do not know"
	label values 	M3_B_2_18 M3_B_2_18_lab


	label define 	M3_B_2_24_lab 	1 "Exclusive breastfeeding" 2 "Breastfeeding and complementary feeding"	///
									3 "There is no breastfeeding"
	label values 	M3_B_2_24 M3_B_2_24_lab

	label define 	M3_B_2_32_lab 1 "Yes" 2 "No" 3 "Not applicable"
	label values 	M3_B_2_32 M3_B_2_33 M3_B_2_32_lab

	label define 	M3_B_1_33a_lab 1 "FEVER" 2 "COUGH" 3 "DIARRHEA" 4 "OTHERS"
	label values 	M3_B_1_33a  M3_B_1_33a_lab
		
	/**************************
		Save translated dataset 
	***************************/

	*Save translated adult exit surveys dataset variables 
	save "$EL_dtRaw/Guinea Bissau 2018/Translated/Child patients_tran.dta", replace   
			
/***************************
	Child exit surveys 
*****************************/

	*Open adult surveys dataset 
	use	"$EL_dtRaw/Guinea Bissau 2018/Child exit surveys.dta", clear  

	/**********************************
		Translate all variable labels 
	************************************/
	 
	*Create loop to translate all variables 
	foreach v of varlist _all  {
		local varlabel `"`: var label `v''"' 	// Store all variable labels in a local
		
		cap	gtrans	`varlabel'					// gtrans command translates all the variable labels stored in the local
			
			return list 						// return the translated word into Englosh 
			local new_label "`r(text)'"
			label var `v' "`new_label'"			// Label variabel with translated English word 
	}
	
	/**********************************
		Translate all value labels 
	************************************/
	
	label define 	saidaCrianca__id_lab 1 "Adult with child 1" 2 "Adult with child 2"
	label values 	saidaCrianca__id saidaCrianca__id_lab

	label define 	M5_B_1_lab 	1 "1st time of consultation - Malaria" 													///
								2 "1st time of consultation - Upper Respiratory Tract Infections (related to cough)"	///
								3 "1st time of consultation - Measles" 4 "1st consultation time - Diarrhea" 			///
								5 " 1a vez da consulta - Outro" 6 "Visita de acompanhamento- Malaria" 					///
								7 "Follow-up visit- Upper Respiratory Tract Infections (cough related)"					///
								8 "Follow-up visit - Measles" 9 "Follow-up visit- Diarrhea" 							///
								10 "Follow-up visit - Other" 11 "Growth monitoring" 12 "Vaccination" 13 "Other (specify)"			
	label values 	M5_B_1 M5_B_1_lab

	label define 	yesno 	1 "Yes" 2 "No"
	label values	M5_B_3 M5_B_12 M5_B_20 M5_B_21 M5_B_27 M5_B_28 M5_B_29 M5_B_30-M5_B_40	///
					M5_B_42-M5_B_112 M5_B_118-M5_B_126__6 M5_B_127 M5_B_129 yesno	
					
	label define 	gender 	1 "Male" 2 "Female"
	label values 	M5_B_4 M5_B_9 gender 

	label define 	M5_B_6_lab	1 "Mother" 2 "Dad" 3 "Caregiver (including another family member)" 	///
								4 "Caregiver (including another family member)" 5 "Other (specify)"	
	label values 	M5_B_6 M5_B_6_lab

	label define 	M5_B_8_lab	0 "None (Never went to school)" 1 "Basic education not complete (1st to 5th)"		///
								2 "Complete Basic Education (6th year)" 3 "Non Completed Secondary (7 ° to 10 °)"	///
								4 "Complete Secondary (11 °)" 5 "CertificateTechnical Professional/Medium"			///
								6 "Complete University Level" 7 "Diploma of University Post-Graduation"				///
								8 "Coranica School Only" 9 "Other (specify)"
	label values 	M5_B_8 M5_B_11 M5_B_8_lab

	label define 	M5_B_10_lab 1 "Not married" 2 "Married/de facto marriage" 3 "Widower" 4 "Divorced/Separated"
	label values 	M5_B_10 M5_B_10_lab

	label define	M5_B_14a_lab	1 "Earth/Clay Bricks" 2 "Stone" 3 "Ceramic brick" 4 "Cement/Concrete" 5 "Wood/Bamboo"			///
									6 "Zinc" 7 "Cardboard" 8 "Tile/Slate" 9 "Floor" 10 "Clay/Straw" 11 "Thatch (grass or straw)"	///
									12 "Roof tile" 13 "Asbestos" 14 "Other (specify)"
	label values 	M5_B_14a M5_B_14b M5_B_14c M5_B_14a_lab

	label define 	M5_B_22_lab 1 "Still sick" 2 "Return with results" 3 "More medicine"
	label values 	M5_B_22 M5_B_22_lab

	label define 	M5_B_41_lab 1 "FEVER" 2 "COUGH" 3 "DIARRHEA" 4 "OTHERS"
	label values 	M5_B_41 M5_B_41_lab

	label define 	M5_B_113_lab	1 "Less than 1km" 2 "1km - 5km" 3 "6 -10 Km" 4 "Above 10Km"
	label values 	M5_B_113 M5_B_113_lab

	label define 	M5_B_115_lab	1 "On foot" 2 "Bicycle" 3 "Animal" 4 "Private car" 5 "Bus or taxi"	///
									6 "Private motorcycle" 7 "Bike taxi" 8 "Other (specify)"
	label values 	M5_B_115 M5_B_115_lab

	label define 	M5_B_128_lab 1 "Public" 2 "Private" 3 "Community"
	label values 	M5_B_128 M5_B_128_lab

	label define 	M5_B_130_lab 1 "Lacking" 2 "I couldn't buy" 3 "Other (specify)"
	label values 	M5_B_130 M5_B_130_lab

	label define 	M5_B_131_lab	1 "Location close to home" 2 "Low cost" 3 "Trust in providers/High quality"			///
									4 "Service Opportunity/Readiness" 5 "Availability of medicines"						///
									6 "Availability of women as health professionals" 7 "Recommendation or reference"	///
									8 "The unit is the only option available" 9 "Other (specify)"
	label values 	M5_B_131 M5_B_132 M5_B_131_lab

	label define	M5_B_133_lab 1 "I fully agree" 2 "I agree" 3 "I disagree" 4 "Strongly disagree" 5 "Does not apply to me"
	label values 	M5_B_133-M5_B_154 M5_B_133_lab	
		
	/**************************
		Save translated dataset 
	***************************/

	*Save translated adult exit surveys dataset variables 
	save "$EL_dtRaw/Guinea Bissau 2018/Translated/Child exit surveys_tran.dta", replace   
			
/***************************
	Medical Vignettes
*****************************/

	*Open adult surveys dataset 
	use	"$EL_dtRaw/Guinea Bissau 2018/responseVignettes0.dta", clear  

	/**********************************
		Translate all variable labels 
	************************************/
	 
	*Create loop to translate all variables 
	foreach v of varlist _all  {
		local varlabel `"`: var label `v''"' 	// Store all variable labels in a local
		
		cap	gtrans	`varlabel'					// gtrans command translates all the variable labels stored in the local
			
			return list 						// return the translated word into Englosh 
			local new_label "`r(text)'"
			label var `v' "`new_label'"			// Label variabel with translated English word 
	}
	
	/**********************************
		Translate all value labels 
	************************************/
	
	label define  	M2_B_12_lab 1 "In consultation (face-to-face care)" 2 "Reviewing or writing on the board"	///
								3 "Filling out visit form or fee sheet" 4 "Waiting for the patient to undress"	///
								5 "Scheduling tests or appointments" 6 "Write a recipe" 						///
								7 "Obtaining materials or equipment for consultation" 							///
								8 "In consultation with another doctor or member of staff" 						///
								9 "Interpreting lab work or radiographs" 10 "Consulting medical information"	///
								11 "Performing lab work" 12 "Filling out forms" 								///
								13 "On the phone to/from, patient or family" 14 "Confirming schedules"			///
								15 "Looking for missing or pending lab information, radiographs or maps"		///
								16 "Consult authorized references" 99 "Other (specify)"
	label values 	M2_B_12 M2_B_12_lab
		
	label define	M2_B_11_lab	1 "Illness/childbirth" 2 "Training/seminar" 3 "On official mission"				///
								4 "Authorized absence" 5 "It's not your shift" 6 "In field work"				///
								7 "Unauthorized absence" 8 "Went to get a salary" 9 "On strike" 99 "Other (specify)"
	label values 	M2_B_11 M2_A_18 M2_B_11_lab
	
	label define 	gender 	1 "Male" 2 "Female"
	label values 	M2_B_8  M2_A_10 gender 

	label define 	M2_B_6_lab	1 "Specialist Doctor" 2 "Higher Education Nurse" 3 "Middle Level Nurse"			///
								4 "Assistant Level Nurse" 5 "Elementary Level Nurse" 							///
								6 "Higher Education Technician" 7 "Technical Middle Level" 						///
								8 "Technical Assistant Level" 9 "Elementary Level Technician" 					///
								10 "Traditional Pateira" 11 "Community Health Agent" 12 "Voluntário" 99 "Other (specify)"
	label values 	M2_B_6 M2_B_6_lab
	
	label define 	M2_B_5_lab	0 "None (Never went to school)" 1 "Basic education not complete (1st to 5th)"		///
								2 "Complete Basic Education (6th year)" 3 "Non Completed Secondary (7 ° to 10 °)"	///
								4 "Complete Secondary (11 °)" 5 "CertificateTechnical Professional/Medium"			///
								6 "Complete University Level" 7 "Diploma of University Post-Graduation"				///
								8 "Coranica School Only" 9 "Other (specify)"
	label values 	M2_B_5 M2_A_8 M3_A_6 M2_B_5_lab

	label define 	M2_B_4_lab	1 "Director" 2 "Clinical Director" 3 "Public Health Physician" 						///
								4 "Specialist Doctor" 5 "General practitioner"	 6 "Stomatologist (dentist)"		///
								7 "Pharmaceutical" 8 "Generalist Nurse" 9 "Midwife (with diploma)" 					///
								10 "Laboratory technician" 11 "Stomatology Technician" 12 "Pharmacy Technician"		///
								13 "Ophthalmology Technician" 14 "Radiology technician" 15 "Nursing assistant"		///
								16 "Midwife Assistant" 17 "Laboratory assistant" 18 "Pharmacy Assistant" 			///
								19 "Radiology Assistant" 20 "Community Health Agent" 21 "Traditional midwife" 99 "Other (specify)"
	label values 	M2_B_4 M2_A_7 M3_A_7 M2_B_4_lab
	
	label define 	M2_B_3_lab 	1 "Director" 2 "Deputy Director" 3 "Head of service/Head of department"		///
								4 "Deputy Head of Service/Head of Department" 5 "Supervisor"				///
								6 "Agent" 7 "Head Nurse" 8 "Deputy Chief Nurse" 9 "Without post"			///
								99 "Other (specify)"
	label values 	M2_B_3 M2_A_6 M3_A_5 M2_B_3_lab

	label define 	M2_A_14_lab	1 "Permanent and retirement benefits" 2 "Contrato de curto prazo (menos de 6 meses)"	///
								2 "Fixed-term contract (6 months and more)" 3 "Casual (without contract)" 				///
								4 "Voluntary" 9 "Other (specify)"
	label values 	M2_A_14 M2_A_14_lab

	label define 	M2_A_13_lab	1 "Central Government" 2 "Health Unit" 3 "Non-Governmental Organization (NGO)" 			///
								4 "Military" 5 "Religious Organization" 6 "Autonomous" 7 "Local community" 9 "Other (specify)"
	label values 	M2_A_13 M2_A_13_lab
	
	label define 	M2_A_9_lab	1 "General practitioner" 2 "Specialist Doctor" 3 "Higher Education Nurse" 				///
								4 "Middle Level Nurse" 5 "Assistant Level Nurse" 6 "Elementary Level Nurse"				///
								7 "Higher Education Technician" 8 "Technical Middle Level" 9 "Técnico Nível Auxiliar"	///
								10 "Elementary Level Technician" 11 "Traditional Midwife" 								///
								12 "Agente de Saude Comunitario" 13 "Voluntary" 99 "Other (specify)"
	label values 	M2_A_9 M3_A_8 M2_A_9_lab
	
	label define	M3_L_17_lab	1 "Strongly disagree" 2 "I disagree" 3 "Neither disagree nor agree" 4 "I disagree" 	///
								5 "Strongly agree" 6 "Not applicable"
	label values 	M3_L_1-M3_L_17  M3_L_17_lab	

	label define 	M3_K_4_lab 1 "Daily or more" 2 "Weekly" 3 "Monthly" 4 "Every 4 months" 5 "Yearly" 6 "Never"
	label values 	M3_K_1-M3_K_4 M3_K_4_lab

	label define 	yesno 	1 "Yes" 2 "No"
	label values	M2_B_13 M2_B_10 M2_A_20 M2_A_19 M2_A_17 M2_A_16 M2_A_12 M2_A_11 case8_ref_notes case8_action_notes	///
					case8_23 case8_exam_notes case7_ref_notes case7_tratam_notes case7_test_notes case7_exam_notes 		///
					case7_historia_notes case6_ref_notes case6_edu_notes case6_tratam_notes case6_diag_notes 			///
					case6_test_notes case6_exam_notes case6_historia_notes case5_ref_notes case5_edu_notes 				///
					case5_tratam_notes case5_test_notes case5_exam_notes case5_historia_notes case4_ref_notes 			///
					case4_edu_notes case4_tratam_notes case4_test_notes case4_exam_notes case4_historia_notes 			///
					case3_ref_notes case3_edu_notes case3_tratam_notes case3_test_notes case3_exam_notes 				///
					case3_historia_notes case2_ref_notes case2_edu_notes case2_trat_notes case2_test_notes 				///
					case2_exam_notes case2_hist_notes case1_ref_notes case1_edu_notes case1_tratam_notes 				///
					case1_test_notes case1_exam_notes case1_historia_notes yesno
	
	label define  	yesno2 	1 "Yes" 2 "No" 3 "in a different situation"
	label values	case8_30c case8_30b case8_30a case8_2-case8_7 case8_8-case8_22 case8_24 case7_55-case7_57 			///
					case7_42-case7_54 case7_34-case7_38 case7_21-case7_33 case7_2-case7_20 case6_64-case6_91 			///
					case6_55-case6_63 case6_54a-case6_54 case6_44-case6_53 case6_28-case6_43 case6_2-case6_27 			///
					case5_76-case5_84 case5_64-case5_75 case5_49-case5_56 case5_23-case5_48 case5_2-case5_22a 			///
					case4_53-case4_57 case4_46-case4_52 case4_33-case4_40 case4_25-case4_32 case4_2-case4_24 			///
					case3_48-case3_48 case3_46-case3_47 case3_37-case3_41 case3_25-case3_36 case3_2-case3_24			///
					case2_60-case2_68 case2_51-case2_59 case2_44-case2_47 case2_24-case2_43 case2_2-case2_17			///      		
					case2_2-case2_17  case1_68-case1_78	case1_60-case1_67 case1_49-case1_51	case1_27-case1_48			///
					case1_2-case1_26 M3_A_10a-M3_A_11 M3_A_9a yesno2

	label define 	M3_A_9b_lab 0 "No job training" 1 "Assistente de parto qualificado" 2 "Adolescent health"			///
								3 "Infection control" 4 "Integrated Care for Childhood Illnesses" 						///
								5 "Newborn resuscitation" 6 "HIV counseling and rapid testing" 9 "Other (specify)"
	label values 	M3_A_9b M3_A_9b_lab
	
	label define 	M3_A_9_lab	1 "Day" 2 "Night"
	label values 	M3_A_9 M3_A_9_lab
	
	label define	M3_A_4obs_lab	1 "Yes, originally selected at random" 2 "No (ie replacement)"
	label values 	M3_A_4obs M3_A_4obs_lab

	/**************************
		Save translated dataset 
	***************************/

	*Save translated adult exit surveys dataset variables 
	save "$EL_dtRaw/Guinea Bissau 2018/Translated/responseVignettes0_tran.dta", replace   
		
		
****************************** End of do-file ***********************************
