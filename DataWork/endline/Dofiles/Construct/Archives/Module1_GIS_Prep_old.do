/***************************************************************************************************

OBJECTIVE:  Generate GIS files for each country for Brian to include GIS variables.
			
***************************************************************************************************/

clear all
macro drop _all
set more off
cap log close

* FOLDER PATHS

	* Dropbox Global
	if c(username) == "andresyichang"{
			gl Dropbox "C:/Users/andresyichang/Dropbox"
			gl OneDrive "C:/Users/andresyichang/OneDrive"
			}
		else if c(username) == "wb486079" { 
			gl Dropbox = "C:/Users/wb486079/Dropbox"
			gl OneDrive "C:/Users/wb486079"
			gl health_data "$OneDrive/OneDrive - WBG/SDI_Health_Data_Repository"
			}
		else if c(username) == "WB553288" { 
			gl Dropbox = "C:/Users/WB553288/Dropbox"
			gl OneDrive "C:/Users/WB553288"
			gl health_data "$OneDrive/WBG/Andres Yi Chang - SDI_Health_Data_Repository"
			gl user "WB553288"

			}
		else if c(username) == "[YOUR USERNAME]" { 
			gl Dropbox = "[YOUR DROPBOX PATH]"
			gl OneDrive "[YOUR ONEDRIVE PATH]"
			}

	* General
	gl data "$OneDrive/SDI_Education_Data_Repository"
	foreach topic in health education {
		gl `topic'_do "$OneDrive/WBG/Andres Yi Chang - SDI/Analytical Report/Do/`topic'"
		gl `topic'_tables "$OneDrive/WBG/Andres Yi Chang - SDI/Analytical Report/Tables/`topic'"
		gl `topic'_figures "$OneDrive/WBG/Andres Yi Chang - SDI/Analytical Report/Figures/`topic'"
		gl `topic'_clean "$OneDrive/WBG/Andres Yi Chang - SDI/Analytical Report/Clean/`topic'"
		}
		
	* Health Folders
	* gl health_data "$OneDrive/WBG/Andres Yi Chang - SDI_Health_Data_Repository"
	* gl health_dofiles "$OneDrive/WBG/SDI_Education_Do"
	* gl health_do "$health_dofiles/WBG/3_Analysis/Do"
	* gl health_out "$health_dofiles/WBG/3_Analysis/Out"
	* gl health_intermediate "$health_out/WBG/intermediate"
	* gl health_clean "$health_dofiles/OneDrive - WBG/3_Analysis/Clean"
	
	* EDUCATION COUNTRY AND YEAR
	local cys KEN_2012 KEN_2018 NGA_2013 UGA_2013 TGO_2013 TZN_2014 MOZ_2014 NER_2015 MAR_2016 MDG_2016 TZN_2016 SLA_2018 
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
		
		gl `cy' "${health_data}/`country'/`y'/01_Data/Harmonized/SDI_`country'-`y'_Module1_Harmonized.dta"
	}

cd "$health_clean/GIS_for_Brian"


******************************************** KEN_2018 ************************************************
use "${KEN_2018}", clear
gen cy = "KEN_2018", after(year)
lab var cy "Country + Year Code"
egen map_id = concat(cy facility_id), punct("_")

*Format GPS Coordinates
gen gps_lat = gpslat_all 
gen gps_lon = gpslong_all


// Removing a few nonsensical points 
replace gps_lat = . if gps_lat > 6
replace gps_lon = . if gps_lat > 6
replace gps_lon = . if gps_lon < 33
replace gps_lat = . if gps_lon < 33
lab var gps_lat "Latitude"
lab var gps_lon "Longitude"

drop gpslong_all gpslat_all
order gps_*, after(public)

// Last fixes
destring enum1_visit1_code, replace force ignore("Enumerator 1 of team ")

save "../Full Datasets/HEALTH_KEN_2018.dta", replace

keep country cy facility_id map_id gps_lat gps_lon rural public admin1 admin1_name
save "HEALTH_KEN_2018_GIS.dta", replace

* decode county, gen(county_name)
* dta2kml using EDU_KEN_2012.kml, replace latitude(gps_lat) longitude(gps_lon) descriptions(county_name) 


******************************************** KEN_2012 ************************************************
use "${KEN_2012}", clear
gen cy = "KEN_2012", after(year)
lab var cy "Country + Year Code"
* keep country cy facility_id gpslong_all gpslat_all rural public admin1 admin2 admin3 admin1_name admin2_name admin3_name
egen map_id = concat(cy facility_id), punct("_")

*Format GPS Coordinates
gen gps_lat_temp = gpslat_all
replace gps_lat_temp = subinstr(gps_lat_temp, "'", "-", .)
split gps_lat_temp, gen(latz) parse(".", " ", "-") destring
gen gps_lat = latz2 + latz3/100 + latz4/10000 + latz5/1000000
replace gps_lat = gps_lat*-1 if latz1 == "S"
drop latz* gps_lat_temp

gen gps_lon_temp = gpslong_all
replace gps_lon_temp = subinstr(gps_lon_temp, "'", "-", .)
split gps_lon_temp, gen(lonz) parse(".", " ", "-") destring
gen gps_lon = lonz2 + lonz3/100 + lonz4/10000 + lonz5/1000000
replace gps_lon = gps_lon*-1 if lonz1 == "W"
drop lonz* gps_lon_temp

// Removing a few nonsensical points (way too far west, unclear where they should be)
replace gps_lon = . if gps_lon < 33
replace gps_lat = . if gps_lon == .

lab var gps_lat "Latitude"
lab var gps_lon "Longitude"

drop gpslong_all gpslat_all
order gps_*, after(public)

// Last fixes
destring enum2_visit2_code transport_central_tpt, replace force

save "../Full Datasets/HEALTH_KEN_2012.dta", replace

keep country cy facility_id map_id gps_lat gps_lon rural public admin1 admin2 admin3 admin1_name admin2_name admin3_name
save "HEALTH_KEN_2012_GIS.dta", replace

* decode county, gen(county_name)
* dta2kml using EDU_KEN_2012.kml, replace latitude(gps_lat) longitude(gps_lon) descriptions(county_name) 

******************************************** NGA_2013 ************************************************
use "${NGA_2013}", clear
gen cy = "NGA_2013", after(year)
lab var cy "Country + Year Code"
* keep country cy facility_id gpslat_all gpslong_all rural public admin1 admin1_name admin2 admin3
egen map_id = concat(cy facility_id), punct("_")

// There are no decimals places, I'm going to try to put some in
gen first = substr(gpslat_all, 1, 2)
destring first, replace force
gen dd = (first == 10 | first == 11 | first == 12)
gen gps_lat = real(substr(gpslat_all,1,2) + "." + substr(gpslat_all,3,.)) if dd == 1
replace gps_lat = real(substr(gpslat_all,1,1) + "." + substr(gpslat_all,2,.)) if dd == 0
drop first dd 
gen first = substr(gpslong_all, 1, 2)
destring first, replace force
gen dd = (first == 10 | first == 11 | first == 12)
gen gps_lon = real(substr(gpslong_all,1,2) + "." + substr(gpslong_all,3,.)) if dd == 1
replace gps_lon = real(substr(gpslong_all,1,1) + "." + substr(gpslong_all,2,.)) if dd == 0
lab var gps_lat "Latitude"
lab var gps_lon "Longitude"

drop first dd gpslong gpslat
order gps_*, after(public)

save "../Full Datasets/HEALTH_NGA_2013.dta", replace

keep country cy facility_id map_id gps_lat gps_lon rural public admin1 admin1_name admin2 admin3
save "HEALTH_NGA_2013_GIS.dta", replace


* decode m1s1q5, gen(geopol_name)
* dta2kml using EDU_NGA_2013.kml, replace latitude(gps_lat) longitude(gps_lon) descriptions(geopol_name) 


******************************************** UGA_2013 ************************************************

use "${UGA_2013}", clear
gen cy = "UGA_2013", after(year)
lab var cy "Country + Year Code"
* keep country cy facility_id gpslat_all gpslong_all rural public admin1 admin1_name admin3 admin3_name // No admin2, not clear why
egen map_id = concat(cy facility_id), punct("_")

*lat should be between -1 to +4
*long should be between 29 to 35
replace gpslat_all = subinstr(gpslat_all,".","",.)
replace gpslong_all = subinstr(gpslong_all,".","",.)

gen switch_ind2 = (real(substr(gpslat_all,1,3))>real(substr(gpslong_all,1,3)))

clonevar gpslat_correct = gpslat_all 
clonevar gpslon_correct = gpslong_all 
replace gpslat_correct = gpslong_all if switch_ind2==1
replace gpslon_correct = gpslat_all if switch_ind2==1

gen extra_zeros = (real(substr(gpslon_correct,1,3))<29)
replace gpslon_correct = subinstr(gpslon_correct,"00","",1) if extra_zeros==1

gen lat_deg = real(substr(gpslat_correct,1,2))
gen lat_min = real(substr(gpslat_correct,3,2))
gen lat_sec = real(substr(gpslat_correct,5,4))/100

gen lon_deg = real(substr(gpslon_correct,1,3))
gen lon_min = real(substr(gpslon_correct,4,2))
gen lon_sec = real(substr(gpslon_correct,6,4))/100

gen gps_lat1 = lat_deg + lat_min/60 + lat_sec/3600
gen gps_lon1 = lon_deg + lon_min/60 + lon_sec/3600

gen gps_lat2 = real(substr(gpslat_correct,1,2) + "." + substr(gpslat_correct,3,.))
gen gps_lon2 = real(substr(gpslon_correct,1,3) + "." + substr(gpslon_correct,4,.))

replace gps_lat1 = . if gps_lat1<-1 | gps_lat1>4
replace gps_lat2 = . if gps_lat2<-1 | gps_lat2>4

replace gps_lon1 = . if gps_lon1<29 | gps_lon1>35 
replace gps_lon2 = . if gps_lon2<29 | gps_lon2>35 

rename gps_lat1 gps_lat
rename gps_lon1 gps_lon

* dta2kml using HEALTH_UGA_2013_test1.kml, replace latitude(gps_lat1) longitude(gps_lon1) descriptions(admin1_name) 
* dta2kml using HEALTH_UGA_2013_test2.kml, replace latitude(gps_lat2) longitude(gps_lon2) descriptions(admin1_name) 

*Format GPS Coordinates
* gen gps_lat = q10na + (q10nb/60) + ((q10nc/1000)*60)/3600 // format is N xx°xx.xxx 
* gen gps_lon = q10ea + (q10eb/60) + ((q10ec/1000)*60)/3600 // format is E xx°xx.xxx 
* lab var gps_lat "Latitude"
* lab var gps_lon "Longitude"

order gps_*, after(public)

save "../Full Datasets/HEALTH_UGA_2013.dta", replace

keep country cy facility_id map_id gps_lat* gps_lon* rural public admin1 admin1_name admin3 admin3_name // No admin2, not clear why
save "HEALTH_UGA_2013_GIS.dta", replace

* dta2kml using EDU_UGA_2013.kml, replace latitude(gps_lat) longitude(gps_lon) descriptions(districu) 

******************************************** TGO_2013 ************************************************

use "${TGO_2013}", clear
gen cy = "TGO_2013", after(year)
lab var cy "Country + Year Code"
rename gpslong_o gpslong_m
rename gpslat_s gpslong_o
* keep country cy facility_id gpslat_o gpslat_m gpslong_o gpslong_m rural public admin1 admin1_name admin2 admin2_name
egen map_id = concat(cy facility_id), punct("_")

gen gps_lat = gpslat_o + (gpslat_m/60) // format is decimal degrees
gen gps_lon = gpslong_o + (gpslong_m/60) // format is decimal degrees

drop gpslat_o gpslat_m gpslong_o gpslong_m
order gps_*, after(public)

save "../Full Datasets/HEALTH_TGO_2013.dta", replace

keep country cy facility_id map_id gps_lat gps_lon rural public admin1 admin1_name admin2 admin2_name
save "HEALTH_TGO_2013_GIS.dta", replace


******************************************** TZN_2014 ************************************************
use "${TZN_2014}", clear
gen cy = "TZN_2014", after(year)
lab var cy "Country + Year Code"
* keep country cy facility_id gpslat_o gpslat_m gpslat_s gpslong_o gpslong_m gpslong_s rural public admin1 admin1_name admin2
egen map_id = concat(cy facility_id), punct("_")

* Many GPS coordinates missing
*Format GPS Coordinates
foreach var in gpslat_o gpslat_m gpslat_s gpslong_o gpslong_m gpslong_s {
	replace `var' = . if inlist(`var',-99,-88,99,999,0)
	replace `var' = . if gpslong_o < 10 // Some facilities have a GPS longitude less than 10 which puts them in the Atlantic
	}
	
gen gps_lat = gpslat_o + (gpslat_m/60) + (((gpslat_s/1000)*60)/3600)
replace gps_lat = gps_lat*-1 
gen gps_lon = gpslong_o + (gpslong_m/60) + (((gpslat_s/1000)*60)/3600)
lab var gps_lat "Latitude"
lab var gps_lon "Longitude"

drop gpslat_o gpslat_m gpslat_s gpslong_o gpslong_m gpslong_s
order gps_*, after(public)
tostring admin5, replace
destring facility_cntryid, replace ignore("D") force

save "../Full Datasets/HEALTH_TZN_2014.dta", replace

keep country cy facility_id map_id gps_lat gps_lon rural public admin1 admin1_name admin2
save "HEALTH_TZN_2014_GIS.dta", replace


* dta2kml using EDU_TZN_2014.kml, replace latitude(gps_lat) longitude(gps_lon) descriptions(m1q2an) 


******************************************** MOZ_2014 ************************************************

use "${MOZ_2014}", clear
gen cy = "MOZ_2014", after(year)
lab var cy "Country + Year Code"
* keep country cy facility_id rural public admin1 admin2
isid facility_id
egen map_id = concat(cy facility_id), punct("_")

*Format GPS Coordinates
*Manually transformed using "http://www.zonums.com/online/coords/cotrans.php?module=14"
*UTM Zones 36 and 37 done separately
*Format was ID, X, Y with UTM Zone 36/37 Southern Hemisphere using Datum WGS84
preserve
	foreach UTM_zone in 36 37 {
		insheet using "./extra materials/moz_zone`UTM_zone'.csv", clear comma names
		ren latitude gps_lat
		ren longitude gps_lon
		drop gpslat gpslon
		tostring facility_id, replace
		tempfile moz_`UTM_zone'
		save `moz_`UTM_zone'', replace
		}
	use `moz_36', clear
	append using `moz_37'
	lab var gps_lat "Latitude"
	lab var gps_lon "Longitude"
	tempfile lat_lon
	save `lat_lon'
restore
merge 1:1 facility_id using `lat_lon', nogen

order gps_*, after(public)

save "../Full Datasets/HEALTH_MOZ_2014.dta", replace

keep country cy facility_id map_id gps_lat gps_lon rural public admin1 admin2
save "HEALTH_MOZ_2014_GIS.dta", replace

* decode m1q3, gen(provincia_name)
* dta2kml using EDU_MOZ_2014.kml, replace latitude(gps_lat) longitude(gps_lon) descriptions(provincia_name) 



******************************************** NER_2015 ************************************************
use "${NER_2015}", clear
gen cy = "NER_2015", after(year)
lab var cy "Country + Year Code"
* keep country cy facility_id rural public admin1 admin1_name admin2 gps_both
egen map_id = concat(cy facility_id), punct("_")

*Format GPS Coordinates
* GPS coordinates are stored in one variable... Hoping this is the correct way to split them
gen gps_lat = substr(gps_both, 1, 8)
gen gps_lon = substr(gps_both, 9, 7)
destring gps_lat gps_lon, replace
replace gps_lat = gps_lat / 100000
replace gps_lon = gps_lon / 100000
lab var gps_lat "Latitude"
lab var gps_lon "Longitude"

order gps_*, after(public)
drop gps_both

save "../Full Datasets/HEALTH_NER_2015.dta", replace

keep country cy facility_id map_id gps_lat gps_lon rural public admin1 admin1_name admin2
save "HEALTH_NER_2015_GIS.dta", replace


* decode m1q3, gen(provincia_name)
* dta2kml using EDU_NER_2015.kml, replace latitude(gps_lat) longitude(gps_lon) descriptions(provincia_name) 



******************************************** MDG_2016 ************************************************
* GPS POINTS MISSING FOR MADAGASCAR 

use "${MDG_2016}", clear
gen cy = "MDG_2016", after(year)
lab var cy "Country + Year Code"
* keep country cy facility_id rural public admin1 admin1_name admin2 admin2_name admin3 admin3_name

*Format GPS Coordinates
* gen gps_lat = -real(substr(id10a,1,2) + "." + substr(id10a,3,.)) 
* gen gps_lon = real(substr(id10b,1,2) + "." + substr(id10b,3,.)) 
gen gps_lat = .
gen gps_lon = .
lab var gps_lat "Latitude"
lab var gps_lon "Longitude"

order gps_*, after(public)

save "../Full Datasets/HEALTH_MDG_2016.dta", replace

* dta2kml using EDU_MDG_2016.kml, replace latitude(gps_lat) longitude(gps_lon) descriptions(id1_nom) 

*/

******************************************** TZN_2016 ************************************************

use "${TZN_2016}", clear
gen cy = "TZN_2016", after(year)
lab var cy "Country + Year Code"
* keep country cy facility_id rural public admin1 admin1_name admin2 gps*
egen map_id = concat(cy facility_id), punct("_")

*Format GPS Coordinates
foreach var of varlist gps*{
	replace `var' = . if `var' == -8
	replace `var' = . if gpslat_o > 10 // Some random bad readings
	replace `var' = . if gpslong_o == 0 | gpslong_o == 1 // Some random bad readings
}

gen gps_lat = gpslat_o + gpslat_m/60 + (((gpslat_s/1000)*60)/3600)
replace gps_lat = gps_lat*-1
gen gps_lon = gpslong_o + gpslong_m/60 + (((gpslong_s/1000)*60)/3600)

* gen period = "."
* egen gps_lat = concat(gpslat_o period gpslat_m gpslat_s)
* egen gps_lon = concat(gpslong_o period gpslong_m gpslong_s)
* destring gps_lat gps_lon, replace force
* replace gps_lat = gps_lat*-1

lab var gps_lat "Latitude"
lab var gps_lon "Longitude"

drop gpslong* gpslat*
order gps_*, after(public)
tostring admin5, replace
destring facility_cntryid, replace ignore("D") force

save "../Full Datasets/HEALTH_TZN_2016.dta", replace

keep country cy facility_id map_id gps_lat gps_lon rural public admin1 admin1_name admin2 
save "HEALTH_TZN_2016_GIS.dta", replace

* dta2kml using EDU_TZN_2016.kml, replace latitude(gps_lat) longitude(gps_lon) descriptions(m1q2an) 

*/


******************************************** SLA_2018 ************************************************
use "${SLA_2018}", clear
gen cy = "SLA_2018", after(year)
lab var cy "Country + Year Code"
* keep country cy facility_id rural public admin1 admin1_name admin2 admin2_name admin3_name admin4_name gpslat gpslong
egen map_id = concat(cy facility_id), punct("_")

*Format GPS Coordinates
rename gpslat gps_lat
rename gpslon gps_lon
destring gps_lat gps_lon, replace
replace gps_lat = . if gps_lon == 0
replace gps_lon = . if gps_lon == 0
lab var gps_lat "Latitude"
lab var gps_lon "Longitude"

order gps_*, after(public)

save "../Full Datasets/HEALTH_SLA_2018.dta", replace

keep country cy facility_id map_id gps_lat gps_lon rural public admin1 admin1_name admin2 admin2_name admin3_name admin4_name
save "HEALTH_SLA_2018_GIS.dta", replace

* decode m1q3, gen(provincia_name)
* dta2kml using EDU_NER_2015.kml, replace latitude(gps_lat) longitude(gps_lon) descriptions(provincia_name) 



*** BRING ALL GIS TOGETHER ***
use "HEALTH_KEN_2018_GIS.dta", clear
append using "HEALTH_NGA_2013_GIS.dta"
append using "HEALTH_TGO_2013_GIS.dta"
append using "HEALTH_TZN_2014_GIS.dta"
append using "HEALTH_MOZ_2014_GIS.dta"
append using "HEALTH_NER_2015_GIS.dta"
append using "HEALTH_SLA_2018_GIS.dta"

outsheet using "./extra materials/mapping_coords.csv", replace comma names 
outsheet using "./All_GIS_Countries_Combined.csv", replace comma names 


*** BRING THEM ALL TOGETHER ***
use "../Full Datasets/HEALTH_NGA_2013.dta", clear
append using "../Full Datasets/HEALTH_KEN_2018.dta"
append using "../Full Datasets/HEALTH_UGA_2013.dta"
append using "../Full Datasets/HEALTH_TGO_2013.dta"
append using "../Full Datasets/HEALTH_MOZ_2014.dta"
append using "../Full Datasets/HEALTH_NER_2015.dta"
append using "../Full Datasets/HEALTH_MDG_2016.dta"
append using "../Full Datasets/HEALTH_TZN_2016.dta"
append using "../Full Datasets/HEALTH_SLA_2018.dta"



** ASSUMPTIONS FOR MODULE 1 **
	* Assumption! Reclassify semi-urban as urban
	replace rural = 2 if rural == 3

	* Assumption! Reclassify "Private, non-specific" as "Private, for-profit" for 46 facilities in Sierra Leone
	replace public = 5 if public == 7

	* Assumption! Reclassify "NGO or faith based non-profit" as "NGO, non-profit" for 9 facilities in Niger *
	replace public = 2 if public == 6 

	* Basic cleaning *
	rename num_med num_med2 // Uganda has this variable for some reason 
	drop if facility_level == 7 // One mistake in Kenya
	
	* Fix bed variable for TANZANIA	
	gen bedz = beds_inpatient
	replace beds_inpatient = beds_total if country == "TANZANIA"
	replace beds_total = bedz if country == "TANZANIA"
	drop bedz
	
	** EQUIPMENT AVAILABILITY **  
	// Fridge
		gen fridge_a = 0 if has_fridge == 0
		replace fridge_a = 1 if has_fridge == 1 | has_fridge == 2 | has_fridge == 3
		gen fridge_b = fridge_a
		replace fridge_b = 0 if has_fridge == 1
		// In some countries, vaccine_store1 determines if the has_fridge question is asked. 
		// Hence there a high number of places with missing fridge info. We assume they don't have fridges. 
		// In Nigeria, they asked about fridges anyhow and found that 18% of facilities not offering vaccines still had a fridge
			
	// Replace as simple binary rather than categorical
		foreach t in a b {
			foreach var of varlist thermometer_`t' stethoscope_`t' sphgmeter_`t' adultscale_`t' childscale_`t' infantscale_`t' autoclave_`t' steamer_`t' dryheat_`t' nonelectric_`t' fridge_`t' {
				codebook `var'
				replace `var' = 1 if `var' == 2
			}
		}

	// Scale
		gen scale_a = (adultscale_a == 1 | childscale_a == 1 | infantscale_a == 1)
		gen scale_b = (adultscale_b == 1 | childscale_b == 1 | infantscale_b == 1)
		gen sterile_a = (autoclave_a == 1 | steamer_a == 1 | dryheat_a == 1 | nonelectric_a == 1)
		gen sterile_b = (autoclave_b == 1 | steamer_b == 1 | dryheat_b == 1 | nonelectric_b == 1)
	
	// Equip avail total
		gen equip_avail1 = (thermometer_a == 1 & stethoscope_a == 1 & sphgmeter_a == 1 & scale_a == 1)
		gen equip_func1 = (thermometer_b == 1 & stethoscope_b == 1 & sphgmeter_b == 1 & scale_b == 1)

		gen equip_avail2 = (thermometer_a == 1 & stethoscope_a == 1 & sphgmeter_a == 1 & scale_a == 1 & sterile_a == 1)
		gen equip_func2 = (thermometer_b == 1 & stethoscope_b == 1 & sphgmeter_b == 1 & scale_b == 1 & sterile_b == 1)

		gen equip_avail3 = (thermometer_a == 1 & stethoscope_a == 1 & sphgmeter_a == 1 & scale_a == 1 & sterile_a == 1 & fridge_a == 1)
		gen equip_func3 = (thermometer_b == 1 & stethoscope_b == 1 & sphgmeter_b == 1 & scale_b == 1 & sterile_b == 1 & fridge_b == 1)
		
		gen equip_avail = equip_func1
		
		drop equip_avail1 equip_avail2 equip_avail3 
		
		foreach var of varlist equip_avail thermometer_a stethoscope_a sphgmeter_a scale_a sterile_a fridge_a equip_func* {
			replace `var' = `var'*100
		}

	
	** INFRASTRUCTURE AVAILABILITY **
	// Electricity variable - Counting everything other than "none"
		gen elec = (power_a != 1)
		replace elec = 0 if power_a == .
		tab power_a elec
	
	// Water variable - No credit for unprotected sources, cart with small tank, surface water or buy from vendors
		gen water = (water_a == 2 | water_a == 3 | water_a == 4 | water_a == 5 | water_a == 7 | water_a == 9 | water_a == 10 | water_a == 12) 
		tab water_a water
	
	// Sanitation variable 
		gen toilet = (toilet_opt_a == 4 | toilet_opt_a == 6 | toilet_opt_a == 7 | toilet_opt_a == 8 | toilet_opt_a == 9 | toilet_opt_a == 10)
		tab toilet_opt_a toilet
	
	// Infrastructure score:
		gen infra_avail = toilet == 1 & water == 1 & elec == 1
		
		egen totes = rowtotal(elec water toilet)
		gen two_of_three = (totes == 2)
		gen one_of_three = (totes == 1)
		gen none = (totes == 0)
		drop totes

		foreach var of varlist infra_avail elec water toilet two_of_three one_of_three none {
			replace `var' = `var'*100
		}
	
	** DRUG AVAILABILITY **

	// Mother drug availability
	// Per the Answers document: 
	// Oxytocin (injectable), misoprostol (cap/tab), sodium chloride (saline solution) (injectable solution), azithromycin (cap/tab or oral liquid), calcium gluconate (injectable), cefixime (cap/tab), magnesium sulfate (injectable), benzathine benzylpenicillin powder (for injection), ampicillin powder (for injection), betamethasone or dexamethasone (injectable), gentamicin (injectable) nifedipine (cap/tab), metronidazole (injectable), medroxyprogesterone acetate (Depo-Provera) (injectable), iron supplements (cap/tab) and folic acid supplements (cap/tab).
	// Iron and folic acid asked differently in a few countries
		gen ironandfol = (ironfolic_a == 1)
		replace ironandfol = 1 if irona_a == 1 & folic_a == 1
		replace ironandfol = . if ironfolic_a == . & irona_a == . & folic_a == . 

	// Paracetamol
		gen paracetamol = (paracetamol3_a == 1 | paracetamol1_a == 1 | paracetamol3_b == 1 | paracetamol3_c == 1)	
		replace paracetamol = . if paracetamol3_a == . & paracetamol1_a == . & paracetamol3_b == . & paracetamol3_c == .	

	// ACTs
		gen act = (act_a == 1 | dihydroartemisinine_a == 1) 
		replace act = . if act_a == . & dihydroartemisinine_a == .

	// Amoxicillin
		gen amox = (amoxicillin4_a == 1 | amoxicillin3_a == 1 | amoxicillin2_a == 1 | amoxicillin1_a == 1)
		replace amox = . if amoxicillin4_a == . & amoxicillin3_a == . & amoxicillin2_a == . & amoxicillin1_a == .
		
	// Ceftriaxone
		gen ceftriaxone = (ceftriaxone_a == 1 | ceftriaxone2_a == 1)
		replace ceftriaxone = . if ceftriaxone_a == . & ceftriaxone2_a == .
		
	// Diazepam	
		gen diazepam = (diazepam1a_a == 1 | diazepam1b_a == 1 | diazepam3_a == 1)
		replace diazepam = . if diazepam1a_a == . & diazepam1b_a == . & diazepam3_a == .
		
	// Cotrimoxazole 
		gen cotrimoxazole = (cotrimoxazole1_a == 1 | cotrimoxazole2_a == 1 | cotrimoxazole3_a == 1)
		replace cotrimoxazole = . if cotrimoxazole1_a == . & cotrimoxazole2_a == . & cotrimoxazole3_a == .
		
	// Uterotonics
		gen other_utero = (misoprostol_a == 1 | ergometrine_a == 1)
		replace other_utero = . if misoprostol_a == . & ergometrine_a == .
	
		gen utero = (oxytocin_a == 1 | other_utero == 1)
		replace utero = . if oxytocin_a == . & other_utero == .
	
	// TB drugs - giving the benefit of the doubt here and assuming the presence of one means combination therapy is likely available
	// They are very frequently available together. 
		gen tb_combo = (rifampicin_a == 1 | pyrazinam_a == 1 | ethambutol_a == 1 | isoniazid_a == 1)
		replace tb_combo = . if rifampicin_a == . & pyrazinam_a == . & ethambutol_a == . & isoniazid_a == .
	
	// Small fix for Kenya. Skip pattern means that mothers drugs were not asked about where they weren't provided. 
		foreach var of varlist oxytocin_a misoprostol_a nacl_a azithromycin_a calgluc_a cefixime_a magsulf_a benzathine_a ampicillin_a methasone_a gentamycin_a nifedipine2_a metronidazole_a depo_a {
			di in red "`var'"
			tab country if `var' == .
			replace `var' = 5 if `var' == . & country == "KENYA" // Skip patterns mean var is frequently missing in Kenya. Assume never available. 
		}


	// Create variable for 14 minimum essential
		foreach var of varlist amitriptyline_a amox atenolol_a captopril_a ceftriaxone ciproflox_a diazepam diclofenac_a glibenclam_a omeprazole_a paracetamol salbutamol_a simvastatin_a cotrimoxazole {
			replace `var' = 0 if `var' != 1 & `var' != .
			replace `var' = 99 if `var' == .
		}		
		egen count14 = anycount(amitriptyline_a amox atenolol_a captopril_a ceftriaxone ciproflox_a diazepam diclofenac_a glibenclam_a omeprazole_a paracetamol salbutamol_a simvastatin_a cotrimoxazole), val(1, 99)
		gen med_avail = count14/14
		replace med_avail = . if country == "KENYA" | country == "NIGERIA" | country == "UGANDA"
		
		* foreach var of varlist amitriptyline_a amox atenolol_a captopril_a ceftriaxone ciproflox_a diazepam diclofenac_a glibenclam_a omeprazole_a paracetamol salbutamol_a simvastatin_a cotrimoxazole {
			* replace `var' = 0 if `var' != 1 & `var' != .
		* }
		* collapse amitriptyline_a amox atenolol_a captopril_a ceftriaxone ciproflox_a diazepam diclofenac_a glibenclam_a omeprazole_a paracetamol salbutamol_a simvastatin_a cotrimoxazole, by(country)
		
	// Label variables
		label variable ironandfol "Medicines - Iron and folic acid availability (constructed variable)"
		label variable act "Medicines - ACT availability (constructed variable)"
		label variable amox "Medicines - Amoxicillin available (constructed variable)"
		label variable ceftriaxone "Medicines - Ceftriaxone available (constructed variable)"
		label variable diazepam "Medicines - Diazepam available (constructed variable)"
		label variable cotrimoxazole "Medicines - Cotrimoxazole available (constructed variable)"
		label variable other_utero "Medicines - Uterotonic available - not oxytocin (constructed variable)"
		label variable utero "Medicines - Oxytocin or other uterotonic available (constructed variable)"
		label variable tb_combo "Medicines - Any drugs for TB combo therapy available (constructed variable)"

		label variable count14 "Count of 14 SARA essential medicines available"
		label variable med_avail "Medical availability - of 14 SARA essential medicines available"
		
	// Create mother variable
		egen mother_drugs = anycount(oxytocin_a misoprostol_a nacl_a azithromycin_a calgluc_a cefixime_a magsulf_a benzathine_a ampicillin_a methasone_a gentamycin_a nifedipine2_a metronidazole_a depo_a ironandfol), val(1)
		gen mother_avail = mother_drugs/15
		replace mother_avail = mother_avail*15/14 if country == "NIGERIA" // cefixime_a missing for Nigeria
		replace mother_avail = mother_avail*15/14 if country == "KENYA" // depo_a missing for Kenya
		replace mother_avail = mother_avail*100

		
	// Child drug availability
	// For children: Amoxicillin (syrup/suspension), oral rehydration salts (ORS sachets), zinc (tablets), ceftriaxone (powder for injection), artemisinin combination therapy (ACT), artesunate (rectal or injectable), benzylpenicillin (powder for injection), vitamin A (capsules)
	// We take out of analysis of the child tracer medicines two medicines (Gentamicin and ampicillin powder) that are included in the mother and in the child tracer medicine list to avoid double counting.  		
	// Create child variable
		egen child_drugs = anycount(amoxicillin3_a ors_a zinctabs_a ceftriaxone2_a act_a artesunate_a benzylpenicillin_a vitamina_a), val(1)
		gen child_avail = child_drugs/7 
		replace child_avail = child_drugs/8 if country == "MOZAMBIQUE" | country == "UGANDA" // Countries with ceftriaxone2_a. Nigeria also has it but they are missing artesunate
		replace child_avail = child_drugs/4 if country == "KENYA"
		replace child_avail = child_avail*100

		foreach var of varlist amoxicillin3_a ors_a zinctabs_a ceftriaxone2_a act_a artesunate_a benzylpenicillin_a vitamina_a {
			di in red "`var'"
			tab country if `var' == . 
		}
		
	// Stock outs
		egen mother_stock_out = anycount(oxytocin_a misoprostol_a nacl_a azithromycin_a calgluc_a cefixime_a magsulf_a benzathine_a ampicillin_a methasone_a gentamycin_a nifedipine2_a metronidazole_a depo_a ironandfol), val(5)
		replace mother_stock_out = . if country == "KENYA"		
		egen child_stock_out = anycount(amoxicillin3_a ors_a zinctabs_a ceftriaxone2_a act_a artesunate_a benzylpenicillin_a vitamina_a), val(5)
		gen stock_out = mother_stock_out + child_stock_out
	
	// Create drug availability variable ** OUTDATED DEFINITION **			
		* gen drug_avail = (mother_drugs + child_drugs)/23	
		* replace drug_avail = . if mother_avail == . | child_avail == .
		* // Assessing Kenya only on child drug availability since mother's drugs are so missing
		* replace drug_avail = drug_avail*100


	// Minimum essential 
		gen min_med = (amox == 1 & ors_a == 1 & act_a == 1)
		replace min_med = 100 if min_med == 1
	

** Create normalized weights 
	drop weight // Leftover var in Kenya
	bysort country: egen avg_weight = mean(ipw)
	gen weight = ipw/avg_weight
	
	// Do not want to drop observations because of missing weight. Assume they are 1 if missing. 
	// This is a big assumption for Mozambique where we were not able to locate the weights. 
	// Also missing for about 5% of the Nigeria sample
	replace weight = 1 if weight == .	
	
*** GDP variable that captures ranking of countries (low to high) by GDP
	** GDP values were taken from: https://data.worldbank.org/indicator/NY.GDP.PCAP.PP.CD
	gen gdp = .
	replace gdp = 965 if country == "NIGER" 
	replace gdp = 1381 if country == "MOZAMBIQUE"
	replace gdp = 1431 if country == "TOGO"
	replace gdp = 1602 if country == "SIERRALEONE"
	replace gdp = 1757 if country == "UGANDA"
	replace gdp = 1759 if country == "MADAGASCAR"
	replace gdp = 2926 if country == "TANZANIA"
	replace gdp = 3468 if country == "KENYA"
	replace gdp = 5698 if country == "NIGERIA"

	// 2019 values
	* gen gdp = .
	* replace gdp = 1270 if country == "NIGER" 
	* replace gdp = 1334 if country == "MOZAMBIQUE"
	* replace gdp = 1662 if country == "TOGO"
	* replace gdp = 1790 if country == "SIERRALEONE"
	* replace gdp = 2271 if country == "UGANDA"
	* replace gdp = 1714 if country == "MADAGASCAR"
	* replace gdp = 2771 if country == "TANZANIA"
	* replace gdp = 4509 if country == "KENYA"
	* replace gdp = 5348 if country == "NIGERIA"

	gen gdp_rank = 1 if country == "NIGER"
	replace gdp_rank = 2 if country == "MOZAMBIQUE"
	replace gdp_rank = 3 if country == "TOGO"
	replace gdp_rank = 4 if country == "SIERRALEONE"
	replace gdp_rank = 5 if country == "UGANDA"
	replace gdp_rank = 6 if country == "MADAGASCAR"
	replace gdp_rank = 7 if country == "TANZANIA"
	replace gdp_rank = 8 if country == "KENYA"
	replace gdp_rank = 9 if country == "NIGERIA"

	label values gdp_rank country
	labmask gdp_rank, values(country)
	
	
save "../Full Datasets/Module1_Prepped.dta", replace

cd "C:\Users\\$user\\WBG\Andres Yi Chang - SDI\Analytical Report\Clean\Health\Full Datasets"