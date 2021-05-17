* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Descriptive Stats									   *
*				Unique ID											   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create figures and graphs 

       ** IDS VAR: country year unique_id 
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	April 14th 2021
 */
 
		//Sections
		global sectionA		0 // Table of providers by gender and age  
		global sectionA_1	0 // Table of providers by gender and age at hospitals  
		global sectionA_2	0 // Table of providers by gender and age at health centers 
		global sectionA_3	0 // Table of providers by gender and age at health posts 
		global sectionA_4	0 // Table by provider occupation - Female providers 		
		global sectionA_5	0 // Table by provider occupation - Male providers		
		global sectionB		0 // Table of providers by occupation
		global sectionC		0 // Histogram of providers age  
	    global sectionD		0 // Boxplot of providers age 
	    global sectionE		0 // Bar graph of staffing of clinics by region 
		global sectionF		0 // Bar graph of staffing of clinics by facility type  
		global sectionG		0 // Bar graph of clinics by region
		global sectionH		0 // Bar graph of staff gender by facility type 

/*************************************
		Provider level dataset 
**************************************/

	*Open final facility level dataset 
	use "$EL_dtFin/Final_pl.dta", clear    
	
	*Rename countries to removed capitalized letters   	
	replace country = "Kenya"			if country == "KENYA"
	replace country = "Madagascar"		if country == "MADAGASCAR"
	replace country = "Mozambique" 		if country == "MOZAMBIQUE"
	replace country = "Niger" 			if country == "NIGER"
	replace country = "Nigeria" 		if country == "NIGERIA"
	replace country = "Sierra Leone"	if country == "SIERRALEONE"
	replace country = "Tanzania" 		if country == "TANZANIA"
	replace country = "Togo" 			if country == "TOGO"
	replace country = "Uganda" 			if country == "UGANDA" 
	replace country = "Guinea Bissau"	if country == "GUINEABISSAU" 
	replace country = "Malawi"	 		if country == "MALAWI" 
	
	*Create rural/urban indicator 
	gen			rural = 1 if fac_type == 1 | fac_type == 2 | fac_type == 3
	replace 	rural = 0 if fac_type == 4 | fac_type == 5 | fac_type == 6
	lab define  rur_lab 1 "Rural" 0 "Urban"
	label val 	rural rur_lab 

	/***************************
	Table by provider gender
	****************************/
	if $sectionA {	
	
	*This creates the numbers for each row - Number of health providers for each row  
	forvalues num = 1/42 {
		estpost	tab cy provider_male1		// This creates the number stats for reach row 

		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di	`	N`num'r'

		matrix	list e(rowpct)
		matrix 	stat2 = e(rowpct)  
		local 	P`num'r = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
		di		`P`num'r'
	}
	*
 	 
	*This creates the numbers for columns 4 - Average age per country 
	forvalues num = 1/13 {
		estpost tabstat provider_age1, by(cy)  stat(mean min max) 	// This creates the number stats for column 4
			
			matrix 	list e(mean)
			matrix 	stat1 = e(mean)  
			local 	N`num'c4 = string(stat1[1,`num'],"%9.1f")  		// This stores those numbers in a local
			di	`	N`num'c4'
			
			matrix 	list e(min)
			matrix 	stat1 = e(min)  
			local 	m`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	m`num'c4'
			
			matrix 	list e(max)
			matrix 	stat1 = e(max)  
			local 	M`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	M`num'c4'
	}
	* 
	
	* Creates table needed for Latex output below:
	file open 	descTable using "$EL_out/Final/Tex files/Des_table_pl.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{6}{c}}" _n ///
	"\hline\hline" _n ///
	"         &\multicolumn{1}{c}{Female Providers}&\multicolumn{1}{c}{Male Providers}&\multicolumn{1}{c}{All Health Providers}&\multicolumn{1}{c}{Average Age}&\\" _n ///
	"               &       N&                     N&       N&                                       N\\" _n ///
	"               &     (\%)&                 (\%)&    (\%)&                                     (min-max)\\" _n ///
	"\hline" _n ///
	"Guinea Bissau 2018&  		{`N1r'}&  		{`N15r'}&           {`N29r'}&              {`N1c4'}\\" _n ///
	"&    						{(`P1r')}&  	{(`P15r')}&        	{(`P29r')}&            {(`m1c4'-`M1c4')}\\" _n ///
	"Kenya 2012&  				{`N2r'}&  		{`N16r'}&           {`N30r'}&              {`N2c4'}\\" _n ///
	"&    						{(`P2r')}&  	{(`P16r')}&        	{(`P30r')}&            {(`m2c4'-`M2c4')}\\" _n ///
	"Kenya 2018&	      		{`N3r'}&  		{`N17r'}&           {`N31r'}&              {`N3c4'}\\" _n ///
	"&      					{(`P3r')}&  	{(`P17r')}&        	{(`P31r')}&            {(`m3c4'-`M3c4')}\\" _n ///
	"Madagascar 2016&	      	{`N4r'}&  		{`N18r'}&           {`N32r'}&              {`N4c4'}\\" _n ///
	"&      					{(`P4r')}&  	{(`P18r')}&        	{(`P32r')}&            {(`m4c4'-`M4c4')}\\" _n ///
	"Mozambique 2014&	      	{`N5r'}&  		{`N19r'}&           {`N33r'}&              {`N5c4'}\\" _n ///
	"&      					{(`P5r')}&  	{(`P19r')}&        	{(`P33r')}&            {(`m5c4'-`M5c4')}\\" _n ///
	"Malawi 2019&	      		{`N6r'}&  		{`N20r'}&           {`N34r'}&              {`N6c4'}\\" _n ///
	"&      					{(`P6r')}&  	{(`P20r')}&        	{(`P34r')}&            {(`m6c4'-`M6c4')}\\" _n ///
	"Niger 2015&	      		{`N7r'}&  		{`N21r'}&           {`N35r'}&              {`N7c4'}\\" _n ///
	"&      					{(`P7r')}&  	{(`P21r')}&        	{(`P35r')}&            {(`m7c4'-`M7c4')}\\" _n ///
	"Nigeria 2013&	      		{`N8r'}&  		{`N22r'}&           {`N36r'}&              {`N8c4'}\\" _n ///
	"&      					{(`P8r')}&  	{(`P22r')}&        	{(`P36r')}&            {(`m8c4'-`M8c4')}\\" _n ///
	"Sierra Leone 2018&	      	{`N9r'}&  		{`N23r'}&           {`N37r'}&              {`N9c4'}\\" _n ///
	"&      					{(`P9r')}&  	{(`P23r')}&        	{(`P37r')}&            {(`m9c4'-`M9c4')}\\" _n ///
	"Togo 2014&	      			{`N10r'}&  		{`N24r'}&           {`N38r'}&              {`N10c4'}\\" _n ///
	"&      					{(`P10r')}&  	{(`P24r')}&       	{(`P38r')}&            {(`m10c4'-`M10c4')}\\" _n ///
	"Tanzania 2014&	      		{`N11r'}&  		{`N25r'}&           {`N39r'}&              {`N11c4'}\\" _n ///
	"&      					{(`P11r')}&  	{(`P25r')}&        	{(`P39r')}&            {(`m11c4'-`M11c4')}\\" _n ///
	"Tanzania 2016&	      		{`N12r'}&  		{`N26r'}&           {`N40r'}&              {`N12c4'}\\" _n ///
	"&      					{(`P12r')}&  	{(`P26r')}&       	{(`P40r')}&            {(`m12c4'-`M12c4')}\\" _n ///
	"Uganda 2013&	      		{`N13r'}&  		{`N27r'}&           {`N41r'}&              {`N13c4'}\\" _n ///
	"&      					{(`P13r')}&  	{(`P27r')}&       	{(`P41r')}&            {(`m13c4'-`M13c4')}\\" _n ///
	"\hline" _n ///
	"\(N\)          		&	{`N14r'}		&  {`N28r'} &    {`N42r'} &            {}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{6}{l}{\footnotesize Numbers in parenthesis are row percentages}\\" _n ///
	"\end{tabular}"
	file close 	descTable
}  

	/***************************************
	Table by provider gender at Hospitals
	****************************************/
	if $sectionA_1 {	
		
	*This creates the numbers for each row - Number of health providers for each row  
	forvalues num = 1/42 {
		estpost	tab cy provider_male1 if  facility_level == 1	// This creates the number stats for reach row 

		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di	`	N`num'r'

		matrix	list e(rowpct)
		matrix 	stat2 = e(rowpct)  
		local 	P`num'r = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
		di		`P`num'r'
	}
	*
 	 
	*This creates the numbers for columns 4 - Average age per country 
	forvalues num = 1/13 {
		estpost tabstat provider_age1 if	 facility_level == 1, by(cy) stat(mean min max) // This creates the number stats for column 4
			
			matrix 	list e(mean)
			matrix 	stat1 = e(mean)  
			local 	N`num'c4 = string(stat1[1,`num'],"%9.1f")  		// This stores those numbers in a local
			di	`	N`num'c4'
			
			matrix 	list e(min)
			matrix 	stat1 = e(min)  
			local 	m`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	m`num'c4'
			
			matrix 	list e(max)
			matrix 	stat1 = e(max)  
			local 	M`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	M`num'c4'
	}
	* 
	
	* Creates table needed for Latex output below:
	file open 	descTable using "$EL_out/Final/Tex files/Des_table_pl_hospital.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{6}{c}}" _n ///
	"\hline\hline" _n ///
	"         &\multicolumn{1}{c}{Female Providers}&\multicolumn{1}{c}{Male Providers}&\multicolumn{1}{c}{All Health Providers}&\multicolumn{1}{c}{Average Age}&\\" _n ///
	"               &       N&                     N&       N&                                       N\\" _n ///
	"               &     (\%)&                 (\%)&    (\%)&                                     (min-max)\\" _n ///
	"\hline" _n ///
	"Guinea Bissau 2018&  		{`N1r'}&  		{`N15r'}&           {`N29r'}&              {`N1c4'}\\" _n ///
	"&    						{(`P1r')}&  	{(`P15r')}&        	{(`P29r')}&            {(`m1c4'-`M1c4')}\\" _n ///
	"Kenya 2012&  				{`N2r'}&  		{`N16r'}&           {`N30r'}&              {`N2c4'}\\" _n ///
	"&    						{(`P2r')}&  	{(`P16r')}&        	{(`P30r')}&            {(`m2c4'-`M2c4')}\\" _n ///
	"Kenya 2018&	      		{`N3r'}&  		{`N17r'}&           {`N31r'}&              {`N3c4'}\\" _n ///
	"&      					{(`P3r')}&  	{(`P17r')}&        	{(`P31r')}&            {(`m3c4'-`M3c4')}\\" _n ///
	"Madagascar 2016&	      	{`N4r'}&  		{`N18r'}&           {`N32r'}&              {`N4c4'}\\" _n ///
	"&      					{(`P4r')}&  	{(`P18r')}&        	{(`P32r')}&            {(`m4c4'-`M4c4')}\\" _n ///
	"Mozambique 2014&	      	{`N5r'}&  		{`N19r'}&           {`N33r'}&              {`N5c4'}\\" _n ///
	"&      					{(`P5r')}&  	{(`P19r')}&        	{(`P33r')}&            {(`m5c4'-`M5c4')}\\" _n ///
	"Malawi 2019&	      		{`N6r'}&  		{`N20r'}&           {`N34r'}&              {`N6c4'}\\" _n ///
	"&      					{(`P6r')}&  	{(`P20r')}&        	{(`P34r')}&            {(`m6c4'-`M6c4')}\\" _n ///
	"Niger 2015&	      		{`N7r'}&  		{`N21r'}&           {`N35r'}&              {`N7c4'}\\" _n ///
	"&      					{(`P7r')}&  	{(`P21r')}&        	{(`P35r')}&            {(`m7c4'-`M7c4')}\\" _n ///
	"Nigeria 2013&	      		{`N8r'}&  		{`N22r'}&           {`N36r'}&              {`N8c4'}\\" _n ///
	"&      					{(`P8r')}&  	{(`P22r')}&        	{(`P36r')}&            {(`m8c4'-`M8c4')}\\" _n ///
	"Sierra Leone 2018&	      	{`N9r'}&  		{`N23r'}&           {`N37r'}&              {`N9c4'}\\" _n ///
	"&      					{(`P9r')}&  	{(`P23r')}&        	{(`P37r')}&            {(`m9c4'-`M9c4')}\\" _n ///
	"Togo 2014&	      			{`N10r'}&  		{`N24r'}&           {`N38r'}&              {`N10c4'}\\" _n ///
	"&      					{(`P10r')}&  	{(`P24r')}&       	{(`P38r')}&            {(`m10c4'-`M10c4')}\\" _n ///
	"Tanzania 2014&	      		{`N11r'}&  		{`N25r'}&           {`N39r'}&              {`N11c4'}\\" _n ///
	"&      					{(`P11r')}&  	{(`P25r')}&        	{(`P39r')}&            {(`m11c4'-`M11c4')}\\" _n ///
	"Tanzania 2016&	      		{`N12r'}&  		{`N26r'}&           {`N40r'}&              {`N12c4'}\\" _n ///
	"&      					{(`P12r')}&  	{(`P26r')}&       	{(`P40r')}&            {(`m12c4'-`M12c4')}\\" _n ///
	"Uganda 2013&	      		{`N13r'}&  		{`N27r'}&           {`N41r'}&              {`N13c4'}\\" _n ///
	"&      					{(`P13r')}&  	{(`P27r')}&       	{(`P41r')}&            {(`m13c4'-`M13c4')}\\" _n ///
	"\hline" _n ///
	"\(N\)          		&	{`N14r'}		&  {`N28r'} &    {`N42r'} &            {}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{6}{l}{\footnotesize Numbers in parenthesis are row percentages}\\" _n ///
	"\end{tabular}"
	file close 	descTable
	}

	/******************************************
	Table by provider gender at Health Center
	*******************************************/
	if $sectionA_2 {	
		
	*This creates the numbers for each row - Number of health providers for each row  
	forvalues num = 1/42 {
		estpost	tab cy provider_male1 if  facility_level == 2	// This creates the number stats for reach row 

		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di	`	N`num'r'

		matrix	list e(rowpct)
		matrix 	stat2 = e(rowpct)  
		local 	P`num'r = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
		di		`P`num'r'
		
		
	}
	*
 	 
	*This creates the numbers for columns 4 - Average age per country 
	forvalues num = 1/13 {
		estpost tabstat provider_age1 if	 facility_level == 2, by(cy) stat(mean min max) // This creates the number stats for column 4
			
			matrix 	list e(mean)
			matrix 	stat1 = e(mean)  
			local 	N`num'c4 = string(stat1[1,`num'],"%9.1f")  		// This stores those numbers in a local
			di	`	N`num'c4'
			
			matrix 	list e(min)
			matrix 	stat1 = e(min)  
			local 	m`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	m`num'c4'
			
			matrix 	list e(max)
			matrix 	stat1 = e(max)  
			local 	M`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	M`num'c4'
	}
	* 
	
	* Creates table needed for Latex output below:
	file open 	descTable using "$EL_out/Final/Tex files/Des_table_pl_healthcenter.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{6}{c}}" _n ///
	"\hline\hline" _n ///
	"         &\multicolumn{1}{c}{Female Providers}&\multicolumn{1}{c}{Male Providers}&\multicolumn{1}{c}{All Health Providers}&\multicolumn{1}{c}{Average Age}&\\" _n ///
	"               &       N&                     N&       N&                                       N\\" _n ///
	"               &     (\%)&                 (\%)&    (\%)&                                     (min-max)\\" _n ///
	"\hline" _n ///
	"Guinea Bissau 2018&  		{`N1r'}&  		{`N15r'}&           {`N29r'}&             {`N1c4'}\\" _n ///
	"&    						{(`P1r')}&  	{(`P15r')}&        	{(`P29r')}&           {(`m1c4'-`M1c4')}\\" _n ///
	"Kenya 2012&  				{`N2r'}&  		{`N16r'}&           {`N30r'}&             {`N2c4'}\\" _n ///
	"&    						{(`P2r')}&  	{(`P16r')}&        	{(`P30r')}&           {(`m2c4'-`M2c4')}\\" _n ///
	"Kenya 2018&	      		{`N3r'}&  		{`N17r'}&           {`N31r'}&             {`N3c4'}\\" _n ///
	"&      					{(`P3r')}&  	{(`P17r')}&        	{(`P31r')}&           {(`m3c4'-`M3c4')}\\" _n ///
	"Madagascar 2016&	      	{`N4r'}&  		{`N18r'}&           {`N32r'}&             {`N4c4'}\\" _n ///
	"&      					{(`P4r')}&  	{(`P18r')}&        	{(`P32r')}&           {(`m4c4'-`M4c4')}\\" _n ///
	"Mozambique 2014&	      	{`N5r'}&  		{`N19r'}&           {`N33r'}&             {`N5c4'}\\" _n ///
	"&      					{(`P5r')}&  	{(`P19r')}&        	{(`P33r')}&           {(`m5c4'-`M5c4')}\\" _n ///
	"Malawi 2019&	      		{`N6r'}&  		{`N20r'}&           {`N34r'}&             {`N6c4'}\\" _n ///
	"&      					{(`P6r')}&  	{(`P20r')}&        	{(`P34r')}&           {(`m6c4'-`M6c4')}\\" _n ///
	"Niger 2015&	      		{`N7r'}&  		{`N21r'}&           {`N35r'}&             {`N7c4'}\\" _n ///
	"&      					{(`P7r')}&  	{(`P21r')}&        	{(`P35r')}&           {(`m7c4'-`M7c4')}\\" _n ///
	"Nigeria 2013&	      		{`N8r'}&  		{`N22r'}&           {`N36r'}&             {`N8c4'}\\" _n ///
	"&      					{(`P8r')}&  	{(`P22r')}&        	{(`P36r')}&           {(`m8c4'-`M8c4')}\\" _n ///
	"Sierra Leone 2018&	      	{`N9r'}&  		{`N23r'}&           {`N37r'}&             {`N9c4'}\\" _n ///
	"&      					{(`P9r')}&  	{(`P23r')}&        	{(`P37r')}&           {(`m9c4'-`M9c4')}\\" _n ///
	"Togo 2014&	      			{`N10r'}&  		{`N24r'}&           {`N38r'}&             {`N10c4'}\\" _n ///
	"&      					{(`P10r')}&  	{(`P24r')}&       	{(`P38r')}&           {(`m10c4'-`M10c4')}\\" _n ///
	"Tanzania 2014&	      		{`N11r'}&  		{`N25r'}&           {`N39r'}&             {`N11c4'}\\" _n ///
	"&      					{(`P11r')}&  	{(`P25r')}&        	{(`P39r')}&           {(`m11c4'-`M11c4')}\\" _n ///
	"Tanzania 2016&	      		{`N12r'}&  		{`N26r'}&           {`N40r'}&             {`N12c4'}\\" _n ///
	"&      					{(`P12r')}&  	{(`P26r')}&       	{(`P40r')}&           {(`m12c4'-`M12c4')}\\" _n ///
	"Uganda 2013&	      		{`N13r'}&  		{`N27r'}&           {`N41r'}&             {`N13c4'}\\" _n ///
	"&      					{(`P13r')}&  	{(`P27r')}&       	{(`P41r')}&           {(`m13c4'-`M13c4')}\\" _n ///
	"\hline" _n ///
	"\(N\)          		&	{`N14r'}		&  {`N28r'} &    {`N42r'} &            {}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{6}{l}{\footnotesize Numbers in parenthesis are row percentages}\\" _n ///
	"\end{tabular}"
	file close 	descTable
	}
 	
	/******************************************
	Table by provider gender at Health Post
	*******************************************/
	if $sectionA_3 {	
		
	*This creates the numbers for each row - Number of health providers for each row  
	forvalues num = 1/42 {
		estpost	tab cy provider_male1 if  facility_level == 3	// This creates the number stats for reach row 

		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di	`	N`num'r'

		matrix	list e(rowpct)
		matrix 	stat2 = e(rowpct)  
		local 	P`num'r = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
		di		`P`num'r'
	}
	*
 	 
	*This creates the numbers for columns 4 - Average age per country 
	forvalues num = 1/13 {
		estpost tabstat provider_age1 if	facility_level == 3, by(cy)	stat(mean min max)  // This creates the number stats for column 4
			
			matrix 	list e(mean)
			matrix 	stat1 = e(mean)  
			local 	N`num'c4 = string(stat1[1,`num'],"%9.1f")  		// This stores those numbers in a local
			di	`	N`num'c4'
			
			matrix 	list e(min)
			matrix 	stat1 = e(min)  
			local 	m`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	m`num'c4'
			
			matrix 	list e(max)
			matrix 	stat1 = e(max)  
			local 	M`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	M`num'c4'
	}
	* 
	
	* Creates table needed for Latex output below:
	file open 	descTable using "$EL_out/Final/Tex files/Des_table_pl_healthpost.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{6}{c}}" _n ///
	"\hline\hline" _n ///
	"         &\multicolumn{1}{c}{Female Providers}&\multicolumn{1}{c}{Male Providers}&\multicolumn{1}{c}{All Health Providers}&\multicolumn{1}{c}{Average Age}&\\" _n ///
	"               &       N&                     N&       N&                                       N\\" _n ///
	"               &     (\%)&                 (\%)&    (\%)&                                     (min-max)\\" _n ///
	"\hline" _n ///
	"Guinea Bissau 2018&  		{0}&  			{0}& 	    	    {0}&	              	{0}\\" _n ///
	"&    						{(0)}&  		{(0)}&  	      	{(0)}&     	 	    	{(0)}\\" _n ///
	"Kenya 2012&  				{`N1r'}&  		{`N14r'}&           {`N27r'}&             {`N1c4'}\\" _n ///
	"&    						{(`P1r')}&  	{(`P14r')}&        	{(`P27r')}&           {(`m1c4'-`M1c4')}\\" _n ///
	"Kenya 2018&	      		{`N2r'}&  		{`N15r'}&           {`N28r'}&             {`N2c4'}\\" _n ///
	"&      					{(`P2r')}&  	{(`P15r')}&        	{(`P28r')}&           {(`m2c4'-`M2c4')}\\" _n ///
	"Madagascar 2016&	      	{`N3r'}&  		{`N16r'}&           {`N29r'}&             {`N3c4'}\\" _n ///
	"&      					{(`P3r')}&  	{(`P16r')}&        	{(`P29r')}&           {(`m3c4'-`M3c4')}\\" _n ///
	"Mozambique 2014&	      	{`N4r'}&  		{`N17r'}&           {`N30r'}&             {`N4c4'}\\" _n ///
	"&      					{(`P4r')}&  	{(`P17r')}&        	{(`P30r')}&           {(`m4c4'-`M4c4')}\\" _n ///
	"Malawi 2019&	      		{`N5r'}&  		{`N18r'}&           {`N31r'}&             {`N5c4'}\\" _n ///
	"&      					{(`P5r')}&  	{(`P18r')}&        	{(`P31r')}&           {(`m5c4'-`M5c4')}\\" _n ///
	"Niger 2015&	      		{`N6r'}&  		{`N19r'}&           {`N32r'}&             {`N6c4'}\\" _n ///
	"&      					{(`P6r')}&  	{(`P19r')}&        	{(`P32r')}&           {(`m6c4'-`M6c4')}\\" _n ///
	"Nigeria 2013&	      		{`N7r'}&  		{`N20r'}&           {`N33r'}&             {`N7c4'}\\" _n ///
	"&      					{(`P7r')}&  	{(`P20r')}&        	{(`P33r')}&           {(`m7c4'-`M7c4')}\\" _n ///
	"Sierra Leone 2018&	      	{`N8r'}&  		{`N21r'}&           {`N34r'}&             {`N8c4'}\\" _n ///
	"&      					{(`P8r')}&  	{(`P21r')}&        	{(`P34r')}&           {(`m8c4'-`M8c4')}\\" _n ///
	"Togo 2014&	      			{`N9r'}&  		{`N22r'}&           {`N35r'}&             {`N9c4'}\\" _n ///
	"&      					{(`P9r')}&  	{(`P22r')}&       	{(`P35r')}&           {(`m9c4'-`M9c4')}\\" _n ///
	"Tanzania 2014&	      		{`N10r'}&  		{`N23r'}&           {`N36r'}&             {`N10c4'}\\" _n ///
	"&      					{(`P10r')}&  	{(`P23r')}&        	{(`P36r')}&           {(`m10c4'-`M10c4')}\\" _n ///
	"Tanzania 2016&	      		{`N11r'}&  		{`N24r'}&           {`N37r'}&             {`N11c4'}\\" _n ///
	"&      					{(`P11r')}&  	{(`P24r')}&       	{(`P37r')}&           {(`m11c4'-`M11c4')}\\" _n ///
	"Uganda 2013&	      		{`N12r'}&  		{`N25r'}&           {`N38r'}&             {`N12c4'}\\" _n ///
	"&      					{(`P12r')}&  	{(`P25r')}&       	{(`P38r')}&           {(`m12c4'-`M12c4')}\\" _n ///
	"\hline" _n ///
	"\(N\)          		&	{`N13r'}		&  {`N26r'} &    {`N39r'} &            {}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{6}{l}{\footnotesize Numbers in parenthesis are row percentages}\\" _n ///
	"\end{tabular}"
	file close 	descTable
	}
	
	/************************************************
	Table by provider occupation - Female providers
	************************************************/
	if $sectionA_4 {	
 	
	*This creates the numbers for each row - Number of heatlh occupation for each row  
	forvalues num = 1/56 {
		estpost	tab cy provider_cadre1  if provider_male1 == 0	// This creates the number stats for reach row 

		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di	`	N`num'r'

		matrix	list e(rowpct)
		matrix 	stat2 = e(rowpct)  
		local 	P`num'r = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
		di		`P`num'r'
	}
	*
 	 
	*This creates the numbers for columns 4 - Average age per country 
	forvalues num = 1/13 {
		estpost tabstat provider_age1	if provider_male1 == 0, by(cy)	stat(mean min max)  // This creates the number stats for column 4
			
			matrix 	list e(mean)
			matrix 	stat1 = e(mean)  
			local 	N`num'c4 = string(stat1[1,`num'],"%9.1f")  		// This stores those numbers in a local
			di	`	N`num'c4'
			
			matrix 	list e(min)
			matrix 	stat1 = e(min)  
			local 	m`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	m`num'c4'
			
			matrix 	list e(max)
			matrix 	stat1 = e(max)  
			local 	M`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	M`num'c4'
	}
	* 
	
	* Creates table needed for Latex output below:
	file open 	descTable using "$EL_out/Final/Tex files/Des_table_pl_occ_female.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{6}{c}}" _n ///
	"\hline\hline" _n ///
	"         &\multicolumn{1}{c}{Doctors}&\multicolumn{1}{c}{Nurses}&\multicolumn{1}{c}{Other}&\multicolumn{1}{c}{All Female Providers}&\multicolumn{1}{c}{Average Age}&\\" _n ///
	"               &       N&                     N&       N&              	 N&                         N\\" _n ///
	"               &     (\%)&                 (\%)&    (\%)&					(\%)&                   (min-max)\\" _n ///
	"\hline" _n ///
	"Guinea Bissau 2018&  		{`N1r'}&  		{`N15r'}&           {`N29r'}&      	{`N43r'}&         {`N1c4'}\\" _n ///
	"&    						{(`P1r')}&  	{(`P15r')}&        	{(`P29r')}&     {(`P43r')}&       {(`m1c4'-`M1c4')}\\" _n ///
	"Kenya 2012&  				{`N2r'}&  		{`N16r'}&           {`N30r'}&       {`N44r'}&         {`N2c4'}\\" _n ///
	"&    						{(`P2r')}&  	{(`P16r')}&        	{(`P30r')}&     {(`P44r')}&       {(`m2c4'-`M2c4')}\\" _n ///
	"Kenya 2018&	      		{`N3r'}&  		{`N17r'}&           {`N31r'}&       {`N45r'}&         {`N3c4'}\\" _n ///
	"&      					{(`P3r')}&  	{(`P17r')}&        	{(`P31r')}&     {(`P45r')}&       {(`m3c4'-`M3c4')}\\" _n ///
	"Madagascar 2016&	      	{`N4r'}&  		{`N18r'}&           {`N32r'}&       {`N46r'}&         {`N4c4'}\\" _n ///
	"&      					{(`P4r')}&  	{(`P18r')}&        	{(`P32r')}&     {(`P46r')}&       {(`m4c4'-`M4c4')}\\" _n ///
	"Mozambique 2014&	      	{`N5r'}&  		{`N19r'}&           {`N33r'}&       {`N47r'}&         {`N5c4'}\\" _n ///
	"&      					{(`P5r')}&  	{(`P19r')}&        	{(`P33r')}&     {(`P47r')}&       {(`m5c4'-`M5c4')}\\" _n ///
	"Malawi 2019&	      		{`N6r'}&  		{`N20r'}&           {`N34r'}&       {`N48r'}&         {`N6c4'}\\" _n ///
	"&      					{(`P6r')}&  	{(`P20r')}&        	{(`P34r')}&     {(`P48r')}&       {(`m6c4'-`M6c4')}\\" _n ///
	"Niger 2015&	      		{`N7r'}&  		{`N21r'}&           {`N35r'}&       {`N49r'}&         {`N7c4'}\\" _n ///
	"&      					{(`P7r')}&  	{(`P21r')}&        	{(`P35r')}&     {(`P49r')}&       {(`m7c4'-`M7c4')}\\" _n ///
	"Nigeria 2013&	      		{`N8r'}&  		{`N22r'}&           {`N36r'}&       {`N50r'}&         {`N8c4'}\\" _n ///
	"&      					{(`P8r')}&  	{(`P22r')}&        	{(`P36r')}&     {(`P50r')}&       {(`m8c4'-`M8c4')}\\" _n ///
	"Sierra Leone 2018&	      	{`N9r'}&  		{`N23r'}&           {`N37r'}&       {`N51r'}&         {`N9c4'}\\" _n ///
	"&      					{(`P9r')}&  	{(`P23r')}&        	{(`P37r')}&     {(`P51r')}&       {(`m9c4'-`M9c4')}\\" _n ///
	"Togo 2014&	      			{`N10r'}&  		{`N24r'}&           {`N38r'}&       {`N52r'}&         {`N10c4'}\\" _n ///
	"&      					{(`P10r')}&  	{(`P24r')}&       	{(`P38r')}&     {(`P52r')}&       {(`m10c4'-`M10c4')}\\" _n ///
	"Tanzania 2014&	      		{`N11r'}&  		{`N25r'}&           {`N39r'}&       {`N53r'}&         {`N11c4'}\\" _n ///
	"&      					{(`P11r')}&  	{(`P25r')}&        	{(`P39r')}&     {(`P53r')}&       {(`m11c4'-`M11c4')}\\" _n ///
	"Tanzania 2016&	      		{`N12r'}&  		{`N26r'}&           {`N40r'}&       {`N54r'}&         {`N12c4'}\\" _n ///
	"&      					{(`P12r')}&  	{(`P26r')}&       	{(`P40r')}&     {(`P54r')}&       {(`m12c4'-`M12c4')}\\" _n ///
	"Uganda 2013&	      		{`N13r'}&  		{`N27r'}&           {`N41r'}&       {`N55r'}&         {`N13c4'}\\" _n ///
	"&      					{(`P13r')}&  	{(`P27r')}&       	{(`P41r')}&     {(`P55r')}&       {(`m13c4'-`M13c4')}\\" _n ///
	"\hline" _n ///
	"\(N\)          		&	{`N14r'}		&  {`N28r'} &    {`N42r'} &         {`N56r'}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{6}{l}{\footnotesize Numbers in parenthesis are row percentages}\\" _n ///
	"\end{tabular}"
	file close 	descTable
	}
	
	/************************************************
	Table by provider occupation - Male providers
	************************************************/
	if $sectionA_5 {	
 	
	*This creates the numbers for each row - Number of heatlh occupation for each row  
	forvalues num = 1/56 {
		estpost	tab cy provider_cadre1  if provider_male1 == 1	// This creates the number stats for reach row 

		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di	`	N`num'r'

		matrix	list e(rowpct)
		matrix 	stat2 = e(rowpct)  
		local 	P`num'r = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
		di		`P`num'r'
	}
	*
 	 
	*This creates the numbers for columns 4 - Average age per country 
	forvalues num = 1/13 {
		estpost tabstat provider_age1	if provider_male1 == 1, by(cy)	stat(mean min max)  // This creates the number stats for column 4
			
			matrix 	list e(mean)
			matrix 	stat1 = e(mean)  
			local 	N`num'c4 = string(stat1[1,`num'],"%9.1f")  		// This stores those numbers in a local
			di	`	N`num'c4'
			
			matrix 	list e(min)
			matrix 	stat1 = e(min)  
			local 	m`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	m`num'c4'
			
			matrix 	list e(max)
			matrix 	stat1 = e(max)  
			local 	M`num'c4 = string(stat1[1,`num'],"%9.0f")  		// This stores those numbers in a local
			di	`	M`num'c4'
	}
	* 
	
	* Creates table needed for Latex output below:
	file open 	descTable using "$EL_out/Final/Tex files/Des_table_pl_occ_male.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{6}{c}}" _n ///
	"\hline\hline" _n ///
	"         &\multicolumn{1}{c}{Doctors}&\multicolumn{1}{c}{Nurses}&\multicolumn{1}{c}{Other}&\multicolumn{1}{c}{All Male Providers}&\multicolumn{1}{c}{Average Age}&\\" _n ///
	"               &       N&                     N&       N&              	 N&                         N\\" _n ///
	"               &     (\%)&                 (\%)&    (\%)&					(\%)&                   (min-max)\\" _n ///
	"\hline" _n ///
	"Guinea Bissau 2018&  		{`N1r'}&  		{`N15r'}&           {`N29r'}&      	{`N43r'}&         {`N1c4'}\\" _n ///
	"&    						{(`P1r')}&  	{(`P15r')}&        	{(`P29r')}&     {(`P43r')}&       {(`m1c4'-`M1c4')}\\" _n ///
	"Kenya 2012&  				{`N2r'}&  		{`N16r'}&           {`N30r'}&       {`N44r'}&         {`N2c4'}\\" _n ///
	"&    						{(`P2r')}&  	{(`P16r')}&        	{(`P30r')}&     {(`P44r')}&       {(`m2c4'-`M2c4')}\\" _n ///
	"Kenya 2018&	      		{`N3r'}&  		{`N17r'}&           {`N31r'}&       {`N45r'}&         {`N3c4'}\\" _n ///
	"&      					{(`P3r')}&  	{(`P17r')}&        	{(`P31r')}&     {(`P45r')}&       {(`m3c4'-`M3c4')}\\" _n ///
	"Madagascar 2016&	      	{`N4r'}&  		{`N18r'}&           {`N32r'}&       {`N46r'}&         {`N4c4'}\\" _n ///
	"&      					{(`P4r')}&  	{(`P18r')}&        	{(`P32r')}&     {(`P46r')}&       {(`m4c4'-`M4c4')}\\" _n ///
	"Mozambique 2014&	      	{`N5r'}&  		{`N19r'}&           {`N33r'}&       {`N47r'}&         {`N5c4'}\\" _n ///
	"&      					{(`P5r')}&  	{(`P19r')}&        	{(`P33r')}&     {(`P47r')}&       {(`m5c4'-`M5c4')}\\" _n ///
	"Malawi 2019&	      		{`N6r'}&  		{`N20r'}&           {`N34r'}&       {`N48r'}&         {`N6c4'}\\" _n ///
	"&      					{(`P6r')}&  	{(`P20r')}&        	{(`P34r')}&     {(`P48r')}&       {(`m6c4'-`M6c4')}\\" _n ///
	"Niger 2015&	      		{`N7r'}&  		{`N21r'}&           {`N35r'}&       {`N49r'}&         {`N7c4'}\\" _n ///
	"&      					{(`P7r')}&  	{(`P21r')}&        	{(`P35r')}&     {(`P49r')}&       {(`m7c4'-`M7c4')}\\" _n ///
	"Nigeria 2013&	      		{`N8r'}&  		{`N22r'}&           {`N36r'}&       {`N50r'}&         {`N8c4'}\\" _n ///
	"&      					{(`P8r')}&  	{(`P22r')}&        	{(`P36r')}&     {(`P50r')}&       {(`m8c4'-`M8c4')}\\" _n ///
	"Sierra Leone 2018&	      	{`N9r'}&  		{`N23r'}&           {`N37r'}&       {`N51r'}&         {`N9c4'}\\" _n ///
	"&      					{(`P9r')}&  	{(`P23r')}&        	{(`P37r')}&     {(`P51r')}&       {(`m9c4'-`M9c4')}\\" _n ///
	"Togo 2014&	      			{`N10r'}&  		{`N24r'}&           {`N38r'}&       {`N52r'}&         {`N10c4'}\\" _n ///
	"&      					{(`P10r')}&  	{(`P24r')}&       	{(`P38r')}&     {(`P52r')}&       {(`m10c4'-`M10c4')}\\" _n ///
	"Tanzania 2014&	      		{`N11r'}&  		{`N25r'}&           {`N39r'}&       {`N53r'}&         {`N11c4'}\\" _n ///
	"&      					{(`P11r')}&  	{(`P25r')}&        	{(`P39r')}&     {(`P53r')}&       {(`m11c4'-`M11c4')}\\" _n ///
	"Tanzania 2016&	      		{`N12r'}&  		{`N26r'}&           {`N40r'}&       {`N54r'}&         {`N12c4'}\\" _n ///
	"&      					{(`P12r')}&  	{(`P26r')}&       	{(`P40r')}&     {(`P54r')}&       {(`m12c4'-`M12c4')}\\" _n ///
	"Uganda 2013&	      		{`N13r'}&  		{`N27r'}&           {`N41r'}&       {`N55r'}&         {`N13c4'}\\" _n ///
	"&      					{(`P13r')}&  	{(`P27r')}&       	{(`P41r')}&     {(`P55r')}&       {(`m13c4'-`M13c4')}\\" _n ///
	"\hline" _n ///
	"\(N\)          		&	{`N14r'}		&  {`N28r'} &    {`N42r'} &         {`N56r'}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{6}{l}{\footnotesize Numbers in parenthesis are row percentages}\\" _n ///
	"\end{tabular}"
	file close 	descTable
	} 	
	
	/***************************
	Table by provider occupation
	****************************/
	if $sectionB {	
	
	*This creates the numbers for each row - Number of health providers for each row  
	forvalues num = 1/56 {
		estpost	tab cy provider_cadre1		// This creates the number stats for reach row 

		matrix 	list e(b)
		matrix 	stat1 = e(b)  
		local 	N`num'r = stat1[1,`num'] 
		di	`	N`num'r'

		matrix	list e(rowpct)
		matrix 	stat2 = e(rowpct)  
		local 	P`num'r = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
		di		`P`num'r'
	}
	*	
	
	*Create and build out latex table 
	file open 	descTable using "$EL_out/Final/Tex files/Des_table_pl_2.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{6}{c}}" _n ///
	"\hline\hline" _n ///
	"         &\multicolumn{1}{c}{Doctors}&\multicolumn{1}{c}{Nurses}&\multicolumn{1}{c}{Other}&\multicolumn{1}{c}{All Health Providers}&\\" _n ///
	"         &       				N&     		N&      	      	N&           N\\" _n ///
	"         &    					(\%)&   	(\%)&   	    	(\%)&       (\%)\\" _n ///
	"\hline" _n ///
	"Guinea Bissau 2018&  		{`N1r'}&  		{`N15r'}&           {`N29r'}&             {`N43r'}\\" _n ///
	"&    						{(`P1r')}&  	{(`P15r')}&        	{(`P29r')}&           {(`P43r')}\\" _n ///
	"Kenya 2012&  				{`N2r'}&  		{`N16r'}&           {`N30r'}&             {`N44r'}\\" _n ///
	"&    						{(`P2r')}&  	{(`P16r')}&        	{(`P30r')}&           {(`P44r')}\\" _n ///
	"Kenya 2018&	      		{`N3r'}&  		{`N17r'}&           {`N31r'}&             {`N45r'}\\" _n ///
	"&      					{(`P3r')}&  	{(`P17r')}&        	{(`P31r')}&           {(`P45r')}\\" _n ///
	"Madagascar 2016&	      	{`N4r'}&  		{`N18r'}&           {`N32r'}&             {`N46r'}\\" _n ///
	"&      					{(`P4r')}&  	{(`P18r')}&        	{(`P32r')}&           {(`P46r')}\\" _n ///
	"Mozambique 2014&	      	{`N5r'}&  		{`N19r'}&           {`N33r'}&             {`N47r'}\\" _n ///
	"&      					{(`P5r')}&  	{(`P19r')}&        	{(`P33r')}&           {(`P47r')}\\" _n ///
	"Malawi 2019&	      		{`N6r'}&  		{`N20r'}&           {`N34r'}&             {`N48r'}\\" _n ///
	"&      					{(`P6r')}&  	{(`P20r')}&        	{(`P34r')}&           {(`P48r')}\\" _n ///
	"Niger 2015&	      		{`N7r'}&  		{`N21r'}&           {`N35r'}&             {`N49r'}\\" _n ///
	"&      					{(`P7r')}&  	{(`P21r')}&        	{(`P35r')}&           {(`P49r')}\\" _n ///
	"Nigeria 2013&	      		{`N8r'}&  		{`N22r'}&           {`N36r'}&             {`N50r'}\\" _n ///
	"&      					{(`P8r')}&  	{(`P22r')}&        	{(`P36r')}&           {(`P50r')}\\" _n ///
	"Sierra Leone 2018&	      	{`N9r'}&  		{`N23r'}&           {`N37r'}&             {`N51r'}\\" _n ///
	"&      					{(`P9r')}&  	{(`P23r')}&        	{(`P37r')}&           {(`P51r')}\\" _n ///
	"Togo 2014&	      			{`N10r'}&  		{`N24r'}&           {`N38r'}&             {`N52r'}\\" _n ///
	"&      					{(`P10r')}&  	{(`P24r')}&       	{(`P38r')}&           {(`P52r')}\\" _n ///
	"Tanzania 2014&	      		{`N11r'}&  		{`N25r'}&           {`N39r'}&             {`N53r'}\\" _n ///
	"&      					{(`P11r')}&  	{(`P25r')}&        	{(`P39r')}&           {(`P53r')}\\" _n ///
	"Tanzania 2016&	      		{`N12r'}&  		{`N26r'}&           {`N40r'}&             {`N54r'}\\" _n ///
	"&      					{(`P12r')}&  	{(`P26r')}&       	{(`P40r')}&           {(`P54r')}\\" _n ///
	"Uganda 2013&	      		{`N13r'}&  		{`N27r'}&           {`N41r'}&             {`N55r'}\\" _n ///
	"&      					{(`P13r')}&  	{(`P27r')}&       	{(`P41r')}&           {(`P55r')}\\" _n ///
	"\hline" _n ///
	"\(N\)    &   				{`N14r'}&    	{`N28r'}&        	{`N42r'}&        {`N56r'}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{6}{l}{\footnotesize Numbers in parenthesis are row percentages}\\" _n ///
	"\end{tabular}"
	file close 	descTable		
	}		
	
	/***************************
	Histogram of provider age
	****************************/
	if $sectionC {	
	
	tw histogram	provider_age1 if provider_cadre1 == 1, 								///
					title("Doctors in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%")							///
					ytit("Share of Doctors") xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_doc.gph", replace 		
	
	tw histogram	provider_age1 if provider_cadre1 == 3, 								///
					title("Nurses in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%")							///
					ytit("Share of Nurses")	xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_nur.gph", replace 
	
	graph combine 								///
			"$EL_out/Final/Hist/age_doc.gph" 	///
			"$EL_out/Final/Hist/age_nur.gph" 	///
			, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/Hist_age_all.png", replace as(png)
	
	
	*Create histograms for each country 
	foreach cry in	KEN_2012 KEN_2018 MDG_2016 MOZ_2014	///
					NGA_2013 TGO_2013 TZN_2014 TZN_2016	///
					UGA_2013 {
				
	tw histogram	provider_age1 if provider_cadre1 == 1 & cy == "`cry'", 				///
					title("Doctors in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%")							///
					ytit("Share of Doctors") xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_doc_`cry'.gph", replace 
	
	tw histogram	provider_age1 if provider_cadre1 == 3 & cy == "`cry'", 				///
					title("Nurses in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%")							///
					ytit("Share of Nurses")	xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_nur_`cry'.gph", replace 
		}
		
	*Create histograms for each country 
	foreach cry2 in MWI_2019 NER_2015 SLA_2018	 {
		
	tw histogram	provider_age1 if provider_cadre1 == 1 & cy == "`cry2'", 			///
					title("Doctors in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%" .25 "25%")			///
					ytit("Share of Doctors") xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_doc_`cry2'.gph", replace 
	
	tw histogram	provider_age1 if provider_cadre1 == 3 & cy == "`cry2'", 			///
					title("Nurses in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%" .25 "25%")			///
					ytit("Share of Nurses")	xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_nur_`cry2'.gph", replace 
		}	
		
	tw histogram	provider_age1 if provider_cadre1 == 1 & cy == "GNB_2018", 				///
					title("Doctors in Health Facilties: Age", color(black) size(med))		///
					frac lc(black) fc(gs14) gap(10) xoverhang 								///
					ylab(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%" .6 "60%")		///
					ytit("Share of Doctors") xtit(" ")										///
					bgcolor(white) graphregion(color(white))  								///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_doc_GNB_2018.gph", replace 
	
	tw histogram	provider_age1 if provider_cadre1 == 3 & cy == "GNB_2018", 			///
					title("Nurses in Health Facilties: Age", color(black) size(med))	///
					frac lc(black) fc(gs14) gap(10) xoverhang 							///
					ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%" .25 "25%")			///
					ytit("Share of Nurses")	xtit(" ")									///
					bgcolor(white) graphregion(color(white))  							///
					legend(region(lwidth(none)))
	graph save "$EL_out/Final/Hist/age_nur_GNB_2018.gph", replace 			

	*Combine the two graphs for each country 
	{ // create bracket to close commands below 	
		
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_GNB_2018.gph" 	///
			"$EL_out/Final/Hist/age_nur_GNB_2018.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Guinea Bissau 2018", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_GNB_2018.gph", replace 
	graph export "$EL_out/Final/Hist_age_4.png", replace as(png)
			
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_MWI_2019.gph" 	///
			"$EL_out/Final/Hist/age_nur_MWI_2019.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Malawi 2019", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_MWI_2019.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_NER_2015.gph" 	///
			"$EL_out/Final/Hist/age_nur_NER_2015.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Niger 2015", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_NER_2015.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_SLA_2018.gph" 	///
			"$EL_out/Final/Hist/age_nur_SLA_2018.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Sierra Leone 2018", size(small) color(black))		
	graph save "$EL_out/Final/Hist/age_SLA_2018.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_UGA_2013.gph" 	///
			"$EL_out/Final/Hist/age_nur_UGA_2013.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Uganda 2013", size(small) color(black))			
	graph save "$EL_out/Final/Hist/age_UGA_2013.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_TZN_2016.gph" 	///
			"$EL_out/Final/Hist/age_nur_TZN_2016.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Tanzania 2016", size(small) color(black))		
	graph save "$EL_out/Final/Hist/age_TZN_2016.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_TZN_2014.gph" 	///
			"$EL_out/Final/Hist/age_nur_TZN_2014.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Tanzania 2014", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_TZN_2014.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_TGO_2013.gph" 	///
			"$EL_out/Final/Hist/age_nur_TGO_2013.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Togo 2013", size(small) color(black))		
	graph save "$EL_out/Final/Hist/age_TGO_2013.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_NGA_2013.gph" 	///
			"$EL_out/Final/Hist/age_nur_NGA_2013.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Nigeria 2013", size(small) color(black))			
	graph save "$EL_out/Final/Hist/age_NGA_2013.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_KEN_2012.gph" 	///
			"$EL_out/Final/Hist/age_nur_KEN_2012.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Kenya 2012", size(small) color(black))	
	graph save "$EL_out/Final/Hist/age_KEN_2012.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_KEN_2018.gph" 	///
			"$EL_out/Final/Hist/age_nur_KEN_2018.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Kenya 2018", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_KEN_2018.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_MDG_2016.gph" 	///
			"$EL_out/Final/Hist/age_nur_MDG_2016.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Madagascar 2016", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_MDG_2016.gph", replace 
	
	graph combine 										///
			"$EL_out/Final/Hist/age_doc_MOZ_2014.gph" 	///
			"$EL_out/Final/Hist/age_nur_MOZ_2014.gph" 	///
			, altshrink  graphregion(color(white)) 		///
			title("Mozambique 2014", size(small) color(black))
	graph save "$EL_out/Final/Hist/age_MOZ_2014.gph", replace 
	
	graph combine 									///
			"$EL_out/Final/Hist/age_MWI_2019.gph"	///
			"$EL_out/Final/Hist/age_NER_2015.gph"	///
			"$EL_out/Final/Hist/age_SLA_2018.gph"	///
			"$EL_out/Final/Hist/age_UGA_2013.gph"	///
			,altshrink graphregion(color(white)) 
	graph export "$EL_out/Final/Hist_age_1.png", replace as(png)
	
	graph combine 									///
			"$EL_out/Final/Hist/age_TZN_2016.gph"	///
			"$EL_out/Final/Hist/age_TZN_2014.gph"	///
			"$EL_out/Final/Hist/age_TGO_2013.gph"	///
			"$EL_out/Final/Hist/age_NGA_2013.gph"	///
			,altshrink graphregion(color(white)) 
	graph export "$EL_out/Final/Hist_age_2.png", replace as(png)
	
	graph combine 									///
			"$EL_out/Final/Hist/age_KEN_2012.gph"	///
			"$EL_out/Final/Hist/age_KEN_2018.gph"	///
			"$EL_out/Final/Hist/age_MDG_2016.gph"	///
			"$EL_out/Final/Hist/age_MOZ_2014.gph"	///
			,altshrink graphregion(color(white)) 
	graph export "$EL_out/Final/Hist_age_3.png", replace as(png)
	}	


}

	/***************************
	Boxplot of provider age
	****************************/
	if $sectionD {	
	
	*Boxplot of provider age by each country 
	graph	hbox provider_age1, over(country) noout									///
			ylab(,angle(0) nogrid) showyvars 										///
			ytit("Age") title("Age of Health Providers", color(black) size(med))	///	
			bgcolor(white) graphregion(color(white))  								///
			legend(region(lwidth(none))) 											///
			note(" ") asy legend(off)
	graph export "$EL_out/Final/Boxplot_age.pdf", replace as(pdf)
	
	*Boxplot of provider age in rural clinics by each country 
	graph	hbox provider_age1 if rural == 1, over(country) noout					///
			ylab(,angle(0) nogrid) showyvars 										///
			ytit("Age") title("Rural Health Providers", color(black) size(med))		///	
			bgcolor(white) graphregion(color(white))  								///
			legend(region(lwidth(none))) 											///
			note(" ") asy legend(off)
	graph save "$EL_out/Final/Boxplot_agereg1.gph", replace 	
	
	*Boxplot of provider age in urban clinics by each country 
	graph	hbox provider_age1 if rural == 0, over(country) noout					///
			ylab(,angle(0) nogrid) showyvars 										///
			ytit("Age") title("Urban Health Providers", color(black) size(med))		///	
			bgcolor(white) graphregion(color(white))  								///
			legend(region(lwidth(none))) 											///
			note(" ") asy legend(off)
	graph save "$EL_out/Final/Boxplot_agereg2.gph", replace
 	
	*Combine both graphs to they are side by side
	graph combine 									///
			"$EL_out/Final/Boxplot_agereg1.gph" 	///
			"$EL_out/Final/Boxplot_agereg2.gph" 	///
			, altshrink  graphregion(color(white)) 
	graph export "$EL_out/Final/Boxplot_age_cb.pdf", replace as(pdf)
	}		
 	
	/**********************************
	Bar graph of clinic staff by region
	***********************************/
	if $sectionE {	
 
	preserve 
		*Create country binary variables 
		foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016	///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
			
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
				
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
				 
			*Create horizontal bar graph of provider occupation by country  
			betterbarci	c_*																										///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) barcolor(edkblue eltblue ebblue)					///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%")  graphregion(color(white)) format(%9.1f)
			graph export "$EL_out/Final/Staff_all.png", replace as(png)
	restore  
  
	preserve 
			*Restrict to only rural health facilities 
			keep if rural == 1
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
			
			*Create variable labels for each country 		
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
		 
		   *Create horizontal bar graph of provider occupation by country and rural clinics 
			betterbarci	c_*																										///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) title("Rural") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Staff_rural.gph", replace 
	restore 
	
	preserve 
			*Restrict to only urban health facilities 
			keep if rural == 0
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of provider occupation by country and urban clinics 
			betterbarci	c_* 																									///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) title("Urban") barcolor(edkblue eltblue ebblue) 	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Staff_urban.gph", replace 
	restore 		 
  
	*Combine both graphs to use the same legend 
	grc1leg ///
		"$EL_out/Final/Bar/Staff_rural.gph" ///
		"$EL_out/Final/Bar/Staff_urban.gph" ///
		,r(1) pos(12) imargin(0 0 0 0) 	///
		graphregion(color(white)) 
	graph export "$EL_out/Final/Staff_reg.png", replace as(png)
	}	 

	/*****************************************
	Bar graph of clinic staff by facility type 
	*******************************************/
	if $sectionF {	
  
	preserve 
			*Restrict to only hospitals  
			keep if facility_level == 1
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
			
			*Create variable labels for each country 		
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
		 
		   *Create horizontal bar graph of provider occupation by country and rural clinics 
			betterbarci	c_*																											///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) title("Hospitals") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))		///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Staff_hos.gph", replace 
	restore 
	
	preserve 
			*Restrict to only health centers  
			keep if facility_level == 2
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of provider occupation by country and urban clinics 
			betterbarci	c_* 																											///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) title("Health Centers") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 			///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Staff_hc.gph", replace 
	restore
	
	preserve 
			*Restrict to only health posts   
			keep if facility_level == 3
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_cadre1)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of provider occupation by country and urban clinics 
			betterbarci	c_* 																											///
						,over(provider_cadre1) barlab pct xoverhang scale(0.7) title("Health Posts") barcolor(edkblue eltblue ebblue) 	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 			///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Staff_hp.gph", replace 
	restore 		 
  
	*Combine both graphs to use the same legend 
	grc1leg ///
		"$EL_out/Final/Bar/Staff_hos.gph" ///
		"$EL_out/Final/Bar/Staff_hc.gph" ///
		"$EL_out/Final/Bar/Staff_hp.gph" ///
		,r(1) pos(12) imargin(0 0 0 0) 	///
		graphregion(color(white)) 
 	graph export "$EL_out/Final/Staff_fl.png", replace as(png)
	}	 	
	
	/***************************
	Bar graph of clinics
	****************************/
	if $sectionG {	
 
	preserve 
		*Create country binary variables 
		foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016	///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				distinct facility_id	if cy == "`cry'"
				return list 
				local N_`cry' `r(ndistinct)'
			} 
			
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(facility_level)	
				
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
				 
			*Create horizontal bar graph of facility level by country  
			betterbarci	c_*																										///
						,over(facility_level) barlab pct xoverhang scale(0.7) barcolor(edkblue eltblue ebblue)					///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%")  graphregion(color(white)) format(%9.1f)
			graph export "$EL_out/Final/Clinic_all.png", replace as(png)
	restore  
  
	preserve 
			*Restrict to only rural health facilities 
			keep if rural == 1
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				distinct facility_id	if cy == "`cry'"
				return list 
				local N_`cry' `r(ndistinct)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(facility_level)	
			
			*Create variable labels for each country 		
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
		 
		   *Create horizontal bar graph of facility level and rural clinics 
			betterbarci	c_*																										///
						,over(facility_level) barlab pct xoverhang scale(0.7) title("Rural") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Clinic_rural.gph", replace 
	restore 
	
	preserve 
			*Restrict to only urban health facilities 
			keep if rural == 0
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				distinct facility_id	if cy == "`cry'"
				return list 
				local N_`cry' `r(ndistinct)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(facility_level)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of facility level and urban clinics 
			betterbarci	c_* 																									///
						,over(facility_level) barlab pct xoverhang scale(0.7) title("Urban") barcolor(edkblue eltblue ebblue) 	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 	///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Clinic_urban.gph", replace 
	restore 		 
  
	*Combine both graphs to use the same legend 
	grc1leg ///
		"$EL_out/Final/Bar/Clinic_rural.gph" ///
		"$EL_out/Final/Bar/Clinic_urban.gph" ///
		,r(1) pos(12) imargin(0 0 0 0) 	///
		graphregion(color(white)) 
 	graph export "$EL_out/Final/Clinic_reg.png", replace as(png)
	}	

	/*****************************************
	Bar graph of staff gender by facility type 
	*******************************************/
	if $sectionH {	
   
	preserve 
			*Restrict to only hospitals  
			keep if facility_level == 1
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_male1)	
			
			*Create variable labels for each country 		
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
		 
		   *Create horizontal bar graph of provider occupation by country and rural clinics 
			betterbarci	c_*																											///
						,over(provider_male1) barlab pct xoverhang scale(0.7) title("Hospitals") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small))		///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Gender_hos.gph", replace 
	restore 
 
	preserve 
			*Restrict to only health centers  
			keep if facility_level == 2
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_male1)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of provider occupation by country and urban clinics 
			betterbarci	c_* 																											///
						,over(provider_male1) barlab pct xoverhang scale(0.7) title("Health Centers") barcolor(edkblue eltblue ebblue)	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 			///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Gender_hc.gph", replace 
	restore
	
	preserve 
			*Restrict to only health posts   
			keep if facility_level == 3
			
			*Create country binary variables 
			foreach cry in	GNB_2018 KEN_2012 KEN_2018 MDG_2016 MOZ_2014 MWI_2019	///
					NER_2015 NGA_2013 SLA_2018 TGO_2013 TZN_2014 TZN_2016			///
					UGA_2013 {
				gen		c_`cry' = 1 	if cy == "`cry'"
				count					if cy == "`cry'"
				local N_`cry' `r(N)'
			} 
		 
			*Collapse each country by facility to obtain percent levels 
			collapse (percent) c_*, by(provider_male1)	
			
			*Create variable labels for each country 	
			label var c_GNB_2018 "Guinea Bissau N=`N_GNB_2018'"
			label var c_KEN_2012 "Kenya '12 N=`N_KEN_2012'"
			label var c_KEN_2018 "Kenya '14 N=`N_KEN_2018'"
			label var c_MDG_2016 "Madagascar N=`N_MDG_2016'"
			label var c_MOZ_2014 "Mozambique N=`N_MOZ_2014'"
			label var c_MWI_2019 "Malawi N=`N_MWI_2019'"
			label var c_NER_2015 "Niger N=`N_NER_2015'"
			label var c_NGA_2013 "Nigeria N=`N_NGA_2013'"
			label var c_SLA_2018 "Sierra Leone N=`N_SLA_2018'"
			label var c_TGO_2013 "Togo N=`N_TGO_2013'"
			label var c_TZN_2014 "Tanzania '14 N=`N_TZN_2014'"
			label var c_TZN_2016 "Tanzania '16 N=`N_TZN_2016'"
			label var c_UGA_2013 "Uganda N=`N_UGA_2013'" 
	
			*Create horizontal bar graph of provider occupation by country and urban clinics 
			betterbarci	c_* 																											///
						,over(provider_male1) barlab pct xoverhang scale(0.7) title("Health Posts") barcolor(edkblue eltblue ebblue) 	///
						 legend(on region(lc(none)) region(lc(none)) r(1) ring(1) size(small) symxsize(small) symysize(small)) 			///
						 ysize(6) xlab(0 "0%" 50 "50%" 100 "100%") graphregion(color(white)) format(%9.1f)
			graph save "$EL_out/Final/Bar/Gender_hp.gph", replace 
	restore 		 
 
	*Combine both graphs to use the same legend 
	grc1leg ///
		"$EL_out/Final/Bar/Gender_hos.gph" ///
		"$EL_out/Final/Bar/Gender_hc.gph" ///
		"$EL_out/Final/Bar/Gender_hp.gph" ///
		,r(1) pos(12) imargin(0 0 0 0) 	///
		graphregion(color(white)) 
 	graph export "$EL_out/Final/Gender_fl.png", replace as(png)
	}	 	
	
	
	
********************************** End of do-file ************************************
