* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Clean Malawi - Module 1 dataset	  		 			   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Clean module 1 version of dataset

       ** IDS VAR:       fac_id interview__id      
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: March 25th 2021
 */

*****************************************************************************
* Preliminaries - Module 1 - Facility Infrastructure and Supplies
*****************************************************************************

	*Open module 1 malawi  
	use	"$EL_dtDeID/Module1_Malawi_2019_deid.dta", clear  	
 
	rename 		Fcode fac_id
	tostring	fac_id, replace
	sort 		fac_id
	
	*Equipment
	rename HH101A12 thermometer_b
	rename HH101A13 stethoscope_b
	rename HH101A16 sphgmeter_b
	rename HH101A1 adult_scale 
	rename HH101A25 child_scale 
	rename HH101A9 infant_scale
	
	*Medicine
	rename U106_01 irona_a
	rename U106_02 folic_a
	rename U106_03 ironfolic_a
	rename U103_20 paracetamol_tab
	rename U111_08 paracetamol_syrup
	rename U116_01 act 
	rename U102_05 amox_tab
	rename U111_17 amox_syrup
	rename U102_06 ceftriaxone_a 
	rename U106_24 ceftriaxone2_a
	rename U125_16 diazepam1a_a
	rename U126_04 diazepam1b_a
	rename U126_05 diazepam3_a
	rename U106_14 misoprostol_a
	rename M116__310 oxytocin_a 
	rename U106_27 oxytocin2_a
	rename U120_04 rifampicin_a
	rename U120_05 isoniazid_a
	rename U120_07 pyrazinam_a
	rename U120_06 ethambutol_a
	rename U120_08 ethambutol2_a
	rename U120_09 ethambutol3_a
	rename U126_01 amitriptyline_a
	rename U103_04 ace_a
	rename U103_06 beta_a
	rename U102_07 ciproflox_a
	rename U103_14 glibenclam_a
	rename U103_19 omeprazole_a
	rename U103_21 salbutamol_a
	rename U103_22 simvastatin_a
 	
	*Workload
	rename B106 num_outpatient
	rename E101 daysperwk


*****************************************************************************
* Adjust and Create Variables
*****************************************************************************

	gen has_facility = 1 if fac_id!="" | fac_id!="."
	lab var has_facility "Facility was included in infrastructure-supplies survey"

	*Create unique identifier
	tostring	fac_id, replace 
	lab var 	fac_id "Facility unique identifier, as string"	
	
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
	gen public = (Mowner_analysis == 1) 
	lab var public "Public"
	
	*Format date variable 
	split	B1001, p("-")
	rename	B10011		B1001_year
	rename  B10012		B1001_month
	split	B10013, p("T")
	rename  B100131		B1001_day 
	
	split	B100132, p(":")
	rename 	B1001321	B100132_hour
	rename  B1001322	B100132_minute
	drop 	B10013 B1001 B100132  B1001323

	gen		inpatients_fac =(B1001A==0)

	/********************
		Recode variables
	************************/
	
	*Recode power variable 
	recode D103 (0=2) (3=1) (2=5) (7=9) (96=9)
		
	*missing values
	ds *, has(type numeric)
	foreach v of varlist `r(varlist)' {
		recode `v' (-9=.b) (-99=.b) (-999=.b) (-99999=.b)
	}

	*yes-no questions
	findname, vallabeltext("Yes")
	quietly foreach v of varlist `r(varlist)' {
		recode `v' (2=0)
			}

	*observed-not observed questions
	findname, vallabeltext("Yes, observed")
	quietly foreach v of varlist `r(varlist)' {
		recode `v' (3=0) (2=1) (1=2)
			}

	findname, vallabeltext("Yes (observed)")
	quietly foreach v of varlist `r(varlist)' {
		recode `v' (3=0) (2=1) (1=2)
			}
 	
	*Drop unwamted variables 
	drop	C404* D108B* D108C* D108D* D108E*	///
			D108A* D108A__* B403A__* B403B*		///
			C417__* A402A* A402A_a* A402B*		///
			B407A* B407B* B407__* B408__* 		///
			AA400_c08* A4002AA__* A422a__* 		///
			A425__* B404__* C401 C402 C405 		///
			C408 C409B* C409__* C410__*			///
			HH101C* HH101E* HH101D* HH101B*		///
			C419__* D110 D111__* J103__* 		///
			M111__* X101__* W104__* V104_01__* 	///
			V105__*  A401__* A400 A4001			///
			A417__* C103__* C104__* A101 A400 	///
			A427 B100 newfacility A112_aa 		///
			Mowner Mowner_analysis A105 A105b 	///
			A113 A114 comment has__errors 		///
			interview__key interview__status 	///
			missing_C113 samplefacility 		///
			ssSys_IRnd sssys_irnd
 
	/***************************************
	Harmoninze modules with iecodebook
	***************************************/
 
	*Apply codebook exel with updated variable names and labels 
	applyCodebook using "$EL/Documentation/Codebooks/Malawi 2019/malawi-2019_module1_codebook.xlsx", varlab rename `haslab' sheet("General")
	
	*Modify infrastructure-services variables
	applyCodebook using "$EL/Documentation/Codebooks/Malawi 2019/malawi-2019_module1_codebook.xlsx", varlab rename vallab sheet("Infrastructure")

	*Modify drugs-supplies-tests-vaccines variables
	applyCodebook using "$EL/Documentation/Codebooks/Malawi 2019/malawi-2019_module1_codebook.xlsx", varlab rename vallab sheet("Drugs-Vaccines") 
 	
	*Drop unwanted variables 
	drop	A106 A10* A40* A41* A42* A43* 	///
			B40* C10* C11* D10* F10* F11* 	///
			C40* C41* H101__*  H10* 	///
			HH101A* HH101__* I101B* J102__* ///
			J104__* I101__* J102a J103a 	///
			K102__* L102__* M112__* M116__* ///
			N108_* N111_* O102__* O107__*	///
			T102_* T105_* T106_* T111_* 	///
			T114_* T118_* T120_* T121_* 	///
			T122_* T109_* T113_* RR121__* 	///
			RR115__* RR114__* Q108__* 		///
			Q103__* N109__* M113__* K103__* ///
			X102__*  X103__* X107__* X10* 	///
			A122 B10* E102 G10* J101 K10* 	///
			L10* M10* M11* N11* O10* P10* 	///
			Q10*  N10* N120_* R10* RR11* 	///
			S10* T10* M1* T12* U10* U11* 	///
			U12*  W10* V10* X11* RR10* O11* ///
			RR1* T11* A109__Altitude
			
	*Record variables 
	recode 	has_rutf (2/3 =1) (4/5 =0)
	recode 	waste_guidelines (3=0)
	recode 	methasone_a gentamycin2_a penicillin2_a		///
			ampicillin2_a polio_vac bcg_vac 			///
			pneumococ_vac measles_vac amoxicillin4_a	///
			(0=5)
			
	recode	fridge_power (6=5) (7=6)
	recode  hivtest_a urinetest_e (2/3=1) (4/5=0)
	recode 	bloodgluc_a haemoglobin_a has_malaria_test	///
			(2=1) (3=0)
	recode	microscope_a glucometer_a has_glucstrips	///
			eyescope_a bloodchemistry_a haemoglobin_c	///
			blood_type_a (1=2) (2/3=1) (4=0)
			
	recode 	ace_a beta_a furosemide_a glibenclam_a 		///
			omeprazole_a amitriptyline_a (0 99=5)
			
	labdtch ace_a beta_a furosemide_a glibenclam_a 		///
			omeprazole_a paracetamol_tab salbutamol_a 	///
			simvastatin_a amitriptyline_a
			
	lab val ace_a beta_a furosemide_a glibenclam_a 		///
			omeprazole_a paracetamol_tab salbutamol_a 	///
			simvastatin_a amitriptyline_a druglab	
			
	recode	has_mcondoms has_fcondoms has_fcondoms_c 	///
			has_ns has_rl has_4dextrose has_facemask 	///
			(2/3=1) (4/5=0)
	
	recode ruralurban (0=2) 
	
	*Fix admin variable to match other country datasets 
	decode	admin1, gen(admin1_name)
	labdtch admin1
	decode	admin2, gen(admin2_name)
	labdtch admin2
	
	*Save harmonized dataset
	isid 	facility_id
	sort 	facility_id
	order	country year facility_id
	save "$EL_dtInt/Module 1/Malawi_2019_mod_1.dta", replace 

********************** End of do-file *********************************************
