/***************************************************************************************************

OBJECTIVE:  Personnel prep!
			
***************************************************************************************************/

clear all
macro drop _all
set more off
cap log close

* FOLDER PATHS

	* Dropbox Global *
	if c(username) == "WB553288" { 
			gl Dropbox = "C:/Users/WB553288/Dropbox"
			gl OneDrive "C:/Users/WB553288"
			gl health_data "$OneDrive/WBG/Andres Yi Chang - SDI_Health_Data_Repository"
			global user WB553288
			}
		else if c(username) == "[YOUR USERNAME]" { 
			gl Dropbox = "[YOUR DROPBOX PATH]"
			gl OneDrive "[YOUR ONEDRIVE PATH]"
			}

	* EDUCATION COUNTRY AND YEAR *
	local cys KEN_2018 NGA_2013 UGA_2013 TGO_2013 TZN_2014 MOZ_2014 NER_2015 MDG_2016 TZN_2016 SLA_2018 
	foreach cy of local cys {
		local c = substr("`cy'",1,3)
		local y = substr("`cy'",5,4)
		if "`c'" == "KEN" local country "Kenya"
		if "`c'" == "MDG" local country "Madagascar"
		if "`c'" == "MAR" local country "Morocco"
		if "`c'" == "MOZ" local country "Mozambique"
		if "`c'" == "NER" local country "Niger"
		if "`c'" == "NGA" local country "Nigeria"
		if "`c'" == "SEN" local country "Senegal"
		if "`c'" == "TZN" local country "Tanzania"
		if "`c'" == "TGO" local country "Togo"
		if "`c'" == "UGA" local country "Uganda"
		if "`c'" == "SLA" local country "SierraLeone"
		
		gl `cy' "${health_data}/`country'/`y'/01_Data/Harmonized/SDI_`country'-`y'_Module2_Harmonized.dta"
	}
	cd "C:\Users\\$user\\WBG\Andres Yi Chang - SDI\Analytical Report\Clean\Health\Full Datasets"

	// Last fixes
	use "${MDG_2016}", clear
	destring year_started, replace
	save "${MDG_2016}", replace

** COMBINE DATASETS
	use "${KEN_2018}", clear
	gen cy = "KEN_2018", after(year)
	append using "${NGA_2013}"
	replace cy = "NGA_2013" if cy == ""
	append using "${UGA_2013}"
	replace cy = "UGA_2013" if cy == ""
	append using "${TGO_2013}"       
	replace cy = "TGO_2013" if cy == ""
	append using "${MOZ_2014}"       
	replace cy = "MOZ_2014" if cy == ""
	append using "${NER_2015}"       
	replace cy = "NER_2015" if cy == ""
	append using "${MDG_2016}"       
	replace cy = "MDG_2016" if cy == ""
	append using "${TZN_2016}"       
	replace cy = "TZN_2016" if cy == ""
	append using "${SLA_2018}"       
	replace cy = "SLA_2018" if cy == ""

** CREATING TRUE ABSENCE VARIABLES **
	// Absentee variable
		gen absent = (provider_present2 == 0)
		replace absent = . if provider_present2 == .
		replace absent_reason2 = . if absent == 0 // Some places listed as present but have a reason for absence. Assume they are absent. 

	// rename old absenteeism variable
		ren absent x_absent
		
	// make a new absent variable that reflects the accurate denominator - you shouldn't be calculated in the denominator if you are not supposed to be working in any capacity
		gen absent = (provider_present2 == 0)
		replace absent = . if provider_present2 == .
		replace absent = . if absent_reason2 == 5 // "on-call" means you shouldn't be in the facility - remove from denominator
		replace absent = . if absent_reason2 == 12 // "not his/her shift" means you shouldn't be in the facility - remove from denominator
		
		
	// make a variable for authorized vs unauthorized absence
		gen auth_absent = (absent_reason2 < 5 | absent_reason2 == 6 | absent_reason2 == 10 | absent_reason2 == 11)
		replace auth_absent = . if absent_reason2 == . | absent_reason2 == 99 | absent_reason2 == 5 | absent_reason2 == 8 | absent_reason2 == 9 | absent_reason2 == 12
		replace auth_absent = . if absent == .

		gen unauth_absent = (absent_reason2 == 7)
		replace unauth_absent = . if absent_reason2 == . | absent_reason2 == 99 | absent_reason2 == 5 | absent_reason2 == 8 | absent_reason2 == 9 | absent_reason2 == 12
		replace unauth_absent = . if absent == .

		gen absent_unauth = 0
		replace absent_unauth = 1 if absent_reason2 == 7 // Count as present if they have an authorized reason
		replace absent_unauth = . if absent == .
		
	// clean up reasons for absenteeism
		gen absent_reason_clean = absent_reason2
		replace absent_reason_clean = 2 if absent_reason2 == 11 | absent_reason2 == 6 // "Internal organization" counts as a "meeting"; "internship" counts as training 
		replace absent_reason_clean = 99 if absent_reason2 == 8 | absent_reason2 == 9 // Grouping collecting salary and on strike into "other"	
		replace absent_reason_clean = . if absent_reason2 == 5 | absent_reason2 == 12 // doesn't count as absent if you're not on shift or you're on call (not supposed to be working)
		
	// make variables to be able to make stacked bar
		gen abz1 = (absent_reason_clean == 1) // sick/maternity
		gen abz2 = (absent_reason_clean == 2) // training/mtg
		gen abz3 = (absent_reason_clean == 3) // official mission
		gen abz4 = (absent_reason_clean == 10) // fieldwork
		gen abz5 = (absent_reason_clean == 4) // authorized
		gen abz6 = (absent_reason_clean == 99) // other
		gen abz7 = (absent_reason_clean == 7) // unauth
		forvalues n = 1/7 {
			replace abz`n' = . if absent_reason_clean == . 
		}
		
	gen total = 1 if absent != .	
	
** Age categories **
	replace provider_age1 = . if provider_age1 == 99
	replace provider_age1 = . if provider_age1 < 15
	gen age_cat = 1 if provider_age1 < 30
	replace age_cat = 2 if provider_age1 >= 30 & provider_age1 < 40
	replace age_cat = 3 if provider_age1 >= 40 & provider_age1 < 50
	replace age_cat = 4 if provider_age1 >= 50 & provider_age1 != .	
	label define age_catz 1 "20 - 30 y/o" 2 "30 - 40 y/o" 3 "40 - 50 y/o" 4 "50+ y/o"
	label values age_cat age_catz

	* gen doctor = (provider_cadre1 == 1) 
	* gen co = (provider_cadre1 == 2) 
	* gen nurse = (provider_cadre1 == 3)	
	* gen other = (provider_cadre1 == 4)
		
drop _merge
save "Module2_Prepped.dta", replace
