* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Clean Povery Rate Dataset	   			               *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create a ready merge dataset of the poverty rates

       ** IDS VAR: country admin1_name          
       ** NOTES:
       ** WRITTEN BY:	Michael Orevba
       ** Last date modified: Feb 25th 2021
 */

/******************************************************************
Imports Povery Rates Dataset from the Poverty Team
*******************************************************************/

	*Import poverty rates excel sheet 
	import excel "$EL_dtInt/Poverty rates/Selected SSA - SDI.xlsx", sheet("Sheet1") firstrow clear

	*Import and clean codebook with poverty lables 
		preserve
			import excel using "$EL/Documentation/Codebooks/Poverty rate/Poverty_rate_codebook.xlsx", firstrow sheet("General") clear
			tab vallab
			if `r(N)'==0 local haslab = ""
			if `r(N)'>0 local haslab = "vallab"
		restore
 
	*Apply codebook exel with updated variable names and labels 
	applyCodebook using "$EL/Documentation/Codebooks/Poverty rate/Poverty_rate_codebook.xlsx", varlab rename `haslab' sheet("General")

	*Clean up admin 1 level variables 
	split	sample, p("-", "–", "  ")
	
	*Create admin 1 level variable 
	replace	sample2 = "Mzimba"				if sample == "105/107 Mzimba"
	replace	sample2 = "Lilongwe"			if sample == "206/210 Lilongwe"
	replace	sample2 = "Zomba"				if sample == "303/314 Zomba"
	replace	sample2 = "Blantyre"			if sample == "305/315 Blantyre"
	replace	sample2 = "Bombali/Karene"		if sample == "21–Bombali/32–Karene"
	replace	sample2 = "Falaba/Koinadugu"	if sample == "22–Falaba/23–Koinadugu"
	rename	sample2 admin1_name 
	
	*Remove the empty space before state names 
	replace admin1_name = strtrim(admin1_name)
	
	*Create country variable 
	gen 	country = "KENYA"			if country_code  == "KEN"
	replace country = "MADAGASCAR"		if country_code  == "MDG"
	replace country = "MOZAMBIQUE" 		if country_code  == "MOZ"
	replace country = "NIGER" 			if country_code  == "NER"
	replace country = "NIGERIA" 		if country_code  == "NGA"
	replace country = "SIERRALEONE"		if country_code  == "SLE"
	replace country = "TANZANIA" 		if country_code  == "TZA"
	replace country = "TOGO" 			if country_code  == "TGO"
	replace country = "UGANDA" 			if country_code  == "UGA" 
	replace country = "GUINEABISSAU"	if country_code  == "GNB" 
	replace country = "MALAWI"	 		if country_code  == "MWI" 
	
	*Drop unwanted variables 
	drop region survname welfaretype level sample sample1 sample3 
	
	*Order variables 
	order country country_code survey_year lineupyear admin1_name
 	
	*Rename state level variables to match harmonization dataset 
	replace	admin1_name	= "Gabu"			if admin1_name == "Gabou"
	replace	admin1_name	= "Bolama_Bijagos"	if admin1_name == "Bolama/Bijag"
	replace	admin1_name	= "SAB"				if admin1_name == "Bissau"
	replace	admin1_name	= "Tharaka-Nithi"	if admin1_name == "Tharaka Nithi"
	replace	admin1_name	= "Murang’a"		if admin1_name == "Muranga"
	replace	admin1_name	= "Nairobi City"	if admin1_name == "Nairobi" 
	replace	admin1_name	= "Antsiranana"		if admin1_name == "DIANA" 
	replace	admin1_name	= "Antananarivo"	if admin1_name == "Analamanga" 
	replace	admin1_name	= "Fianarantsoa"	if admin1_name == "Matsiatra Ambony" 
	replace	admin1_name	= "Mahajanga"		if admin1_name == "Boeny" 
	replace	admin1_name	= "Toamasina"		if admin1_name == "Atsinanana" 
	replace	admin1_name	= "Toliary"			if admin1_name == "Atsimo Andrefana" 
	replace	admin1_name	= "Blanytyre"		if admin1_name == "Blantyre" 
	replace	admin1_name	= "Tillabery"		if admin1_name == "Tillab�ri"
	replace	admin1_name	= "Niamey"			if admin1_name == "Communaut� urbaine de Niamey"
	replace	admin1_name	= "Bombali"			if admin1_name == "Bombali/Karene" 
	replace	admin1_name	= "Koinadugu"		if admin1_name == "Falaba/Koinadugu" 
	replace	admin1_name	= "Western"			if admin1_name == "Western Area" 
	replace	admin1_name	= "Golfe/Lome"		if admin1_name == "Grand Lom�"  
	replace	admin1_name	= "Dar es Salaam"	if admin1_name == "Dar Es Salaam" 
	
	*Create a duplicate of the Central region poverty rate in Uganda 
	expand 	2 if admin1_name == "Central", gen(dupindicator)
	replace	admin1_name	= "Kampala"	if admin1_name == "Central" & dupindicator == 1
	drop	dupindicator
 
	*Create a duplicate of the Mzimba distruct poverty rate in Malawi 
	expand 	2 if admin1_name == "Mzimba", gen(dupindicator)
	replace	admin1_name	= "Mzimba North"	if admin1_name == "Mzimba" & dupindicator == 0
	replace	admin1_name	= "Mzimba South"	if admin1_name == "Mzimba" & dupindicator == 1
	drop	dupindicator
	
	*Drop unwanted variables 
	drop country_code  // no longer needed 
	 
	*Save poverty rates dataset
	rename	admin1_name admin1_name_temp
	isid	country	admin1_name_temp
	sort	country	admin1_name_temp
	save "$EL_dtInt/Poverty rates/poverty_rates.dta", replace 

***************** End of do-file ******************************
