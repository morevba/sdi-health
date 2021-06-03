* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Descriptive Stats									   *
*				Unique ID											   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create figures and graphs on the vignettes 

       ** IDS VAR: country year unique_id 
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	May 24th 2021
	   
 *************************************************************************/
 
		//Sections
		global sectionA		1 // table - descriptive stats of providers 
		
/*****************************
		Vignettes   
******************************/	
	
	*Open vignettes dataset 
	use "$VG_dtFin/Vignettes_construct.dta", clear   
	
/**********************************************************
				Facility & Provider Characteristics 
***********************************************************/		
  	
	*Restrict to key variables needed for table 
	keep	rural public facility_level facility_id				///
			provider_cadre1 provider_mededuc1 provider_male1 cy ///
			skip_* *_history_* *_exam_* *_test_* diag* treat*	///
			tb_antibio diar_antibio

/******************************************************************************
			Table of descriptive stats of providers 
******************************************************************************/
if $sectionA {	
 	
	*Code country year variable 
	encode cy, gen(cy_code)
 
	*Create facility level binaries 
	gen 	hospital  = (facility_level ==1)
	gen 	health_ce = (facility_level ==2)
	gen 	health_po = (facility_level ==3)
	
	*Create provider cadre binaries 
	gen 	doctor	= 	(provider_cadre1 ==1)
	replace doctor  = . if missing(provider_cadre1) 
	gen 	nurse 	= 	(provider_cadre1 ==3)
	replace nurse  	= . if missing(provider_cadre1)
	gen 	other 	= 	(provider_cadre1 ==4)
	replace other 	 = . if missing(provider_cadre1)
	
	*Create medical education binaries 
	gen 	advanced	= 	(provider_mededuc1 ==4)
	replace advanced  	= . if missing(provider_mededuc1) 
	gen 	diploma 	= 	(provider_mededuc1 ==3)
	replace diploma  	= . if missing(provider_mededuc1)
	gen 	certificate = 	(provider_mededuc1 ==2)
	replace certificate = . if missing(provider_mededuc1)
	
	*This creates the numbers for each row - Number of health providers for each row  
	forvalues num = 1/13 {
		
		count if  cy_code == `num'	// This creates the number stats for row 1
		local 	A`num'r = string(`r(N)',"%9.0f") 
		di		`A`num'r'
		
	}
	
	forvalues num = 1/13 {
		sum 	rural  if	cy_code == `num', d	// This creates the number stats for row 2
		local 	C`num'r = string(`r(mean)',"%9.2f") 
		di		`C`num'r'
	
		sum 	public if	cy_code == `num', d	// This creates the number stats for row 3
		local 	D`num'r = string(`r(mean)',"%9.2f") 
		di		`D`num'r'
	}
	
	forvalues num = 1/13 {
		
		sum 	hospital if cy_code == `num'	// This creates the number stats for row 4
		local 	E`num'r = string(`r(mean)',"%9.2f") 
		di		`E`num'r'
		
		sum 	health_ce if cy_code == `num'	// This creates the number stats for row 5
		local 	F`num'r = string(`r(mean)',"%9.2f")  
		di		`F`num'r'
		
		sum 	health_po if cy_code == `num'	// This creates the number stats for row 6
		local 	G`num'r = string(`r(mean)',"%9.2f") 
		di		`G`num'r'
	}
	
	forvalues num = 1/13 {
		
		sum 	doctor	if cy_code == `num'		// This creates the number stats for row 7
		local 	I`num'r = string(`r(mean)',"%9.2f") 
		di		`I`num'r'
		
		sum 	nurse	if cy_code == `num'		// This creates the number stats for row 8
		local 	K`num'r = string(`r(mean)',"%9.2f") 
		di		`K`num'r'
		
		sum 	other	if cy_code == `num'		// This creates the number stats for row 9
		local 	L`num'r = string(`r(mean)',"%9.2f") 
		di		`L`num'r'
	}

	forvalues num = 1/13 {
		
	cap	sum 	advanced if cy_code == `num'		// This creates the number stats for row 10
	cap	local 	M`num'r = string(`r(mean)',"%9.2f")
		di		`M`num'r'
		
	cap	sum 	diploma if cy_code == `num'		// This creates the number stats for row 11
	cap	local 	N`num'r = string(`r(mean)',"%9.2f")
		di		`N`num'r'
		
	cap	sum 	certificate if cy_code == `num'	// This creates the number stats for row 12
	cap	local 	O`num'r = string(`r(mean)',"%9.2f") 
		di		`O`num'r'
	}
	
	*Create and build out latex table 
	file open 	descTable using "$VG_out/tables/prov_summ_1.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{7}{c}}" _n ///
	"\hline\hline" _n ///
	"&\multicolumn{1}{c}{Guinea Bissau}&\multicolumn{1}{c}{Kenya 2012}&\multicolumn{1}{c}{Kenya 2018}&\multicolumn{1}{c}{Madagascar}&\multicolumn{1}{c}{Mozambique}&\multicolumn{1}{c}{Malawi}&\\" _n ///
	"\hline" _n ///
	"Total&						{`A1r'}&	{`A2r'}&  {`A3r'}&	{`A4r'}&	{`A5r'}&	{`A6r'}\\" _n ///
	"  &  {""}\\" _n ///
	"Rural&						{`C1r'}&	{`C2r'}&  {`C3r'}&  {`C4r'}&	{`C5r'}&	{`C6r'}\\" _n ///
	"Public&  					{`D1r'}&	{`D2r'}&  {`D3r'}&  {`D4r'}&	{`D5r'}&	{`D6r'}\\" _n ///
	" &   {""}\\" _n ///
	"Hospital&  				{`E1r'}&	{`E2r'}&  {`E3r'}&  {`E4r'}&	{`E5r'}&	{`E6r'}\\" _n ///
	"Health center&  			{`F1r'}&	{`F2r'}&  {`F3r'}&	{`F4r'}&	{`F5r'}&	{`F6r'}\\" _n ///
	"Health post&  				{`G1r'}&	{`G2r'}&  {`G3r'}&  {`G4r'}&	{`G5r'}&	{`G6r'}\\" _n ///
	" &   {""}\\" _n ///
	"Doctor&  					{`I1r'}&	{`I2r'}&  {`I3r'}&  {`I4r'}&	{`I5r'}&	{`I6r'}\\" _n ///
	"Nurse&  					{`K1r'}&	{`K2r'}&  {`K3r'}&  {`K4r'}&	{`K5r'}&	{`K6r'}\\" _n ///
	"Other profession& 	 		{`L1r'}&	{`L2r'}&  {`L3r'}&  {`L4r'}&	{`L5r'}&	{`L6r'}\\" _n ///
	"&   {""}\\" _n ///
	"Advanced med.&  			{`M1r'}&	{`M2r'}&  {`M3r'}&  {`M4r'}&	{`M5r'}&	{`M6r'}\\" _n ///
	"Diploma&  					{`N1r'}&	{`N2r'}&  {`N3r'}&  {`N4r'}&	{`N5r'}&	{`N6r'}\\" _n ///
	"Certificate&  				{`O1r'}&	{`O2r'}&  {`O3r'}&  {`O4r'}&	{`O5r'}&	{`O6r'}\\" _n ///
	"\hline" _n ///
	"\end{tabular}"
	file close 	descTable		
	
	*Create and build out latex table 
	file open 	descTable using "$VG_out/tables/prov_summ_2.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{8}{c}}" _n ///
	"\hline\hline" _n ///
	"&\multicolumn{1}{c}{Niger}&\multicolumn{1}{c}{Nigeria}&\multicolumn{1}{c}{Sierra Leone}&\multicolumn{1}{c}{Togo}&\multicolumn{1}{c}{Tanzania 2014}&\multicolumn{1}{c}{Tanzania 2016}&\multicolumn{1}{c}{Uganda}&\\" _n ///
	"\hline" _n ///
	"Total&							{`A7r'}&	{`A8r'}&	{`A9r'}&	{`A10r'}&	{`A11r'}&	{`A12r'}&	{`A13r'}\\" _n ///
	"  &  {""}\\" _n ///
	"Rural&							{`C7r'}&	{`C8r'}&	{`C9r'}&	{`C10r'}&	{`C11r'}&	{`C12r'}&	{`C13r'}\\" _n ///
	"Public&  						{`D7r'}&	{`D8r'}&	{`D9r'}&	{`D10r'}&	{`D11r'}&	{`D12r'}&	{`D13r'}\\" _n ///
	" &   {""}\\" _n ///
	"Hospital&  					{`E7r'}&	{`E8r'}&	{`E9r'}&	{`E10r'}&	{`E11r'}&	{`E12r'}&	{`E13r'}\\" _n ///
	"Health center&  				{`F7r'}&	{`F8r'}&	{`F9r'}&	{`F10r'}&	{`F11r'}&	{`F12r'}&	{`F13r'}\\" _n ///
	"Health post&  					{`G7r'}&	{`G8r'}&	{`G9r'}&	{`G10r'}&	{`G11r'}&	{`G12r'}&	{`G13r'}\\" _n ///
	" &   {""}\\" _n ///
	"Doctor&  						{`I7r'}&	{`I8r'}&	{`I9r'}&	{`I10r'}&	{`I11r'}&	{`I12r'}&	{`I13r'}\\" _n ///
	"Nurse&  						{`K7r'}&	{`K8r'}&	{`K9r'}&	{`K10r'}&	{`K11r'}&	{`K12r'}&	{`K13r'}\\" _n ///
	"Other profession& 	 			{`L7r'}&	{`L8r'}&	{`L9r'}&	{`L10r'}&	{`L11r'}&	{`L12r'}&	{`L13r'}\\" _n ///
	"&   {""}\\" _n ///
	"Advanced med.&  				{`M7r'}&	{`M8r'}&	{`M9r'}&	{`M10r'}&	{`M11r'}&	{`M12r'}&	{`M13r'}\\" _n ///
	"Diploma&  						{`N7r'}&	{`N8r'}&	{`N9r'}&	{`N10r'}&	{`N11r'}&	{`N12r'}&	{`N13r'}\\" _n ///
	"Certificate&  					{`O7r'}&	{`O8r'}&	{`O9r'}&	{`O10r'}&	{`O11r'}&	{`O12r'}&	{`O13r'}\\" _n ///
	"\hline" _n ///
	"\end{tabular}"
	file close 	descTable		
	
	
	}			

	

***************************************** End of do-file *********************************************
