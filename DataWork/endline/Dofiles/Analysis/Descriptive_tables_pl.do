* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Descriptive Stats									   *
*				Unique ID											   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create figures and graphs on caseload 

       ** IDS VAR: country year unique_id 
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	Mar 19th 2021
 */
 
		clear all
 
		//Sections
		global sectionA		0 // Table of providers by gender and age  
		global sectionB		0 // Table of providers by gender and age at hospitals  
		global sectionC		0 // Table of providers by gender and age at health centers 
		global sectionD		0 // Table of providers by gender and age at health posts 
		global sectionE		0 // Table by provider occupation - Female providers 		
		global sectionF		0 // Table by provider occupation - Male providers		
		global sectionG		0 // Table of providers by occupation
		global sectionH		1 // Table of provider characteristics 
		
/*************************************
		Provider level dataset 
**************************************/

	*Open final provider level dataset 
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
	Table of provider gender
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
	Table of provider gender at Hospitals
	****************************************/
	if $sectionB {	
		
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
	Table of provider gender at Health Center
	*******************************************/
	if $sectionC {	
		
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
	Table of provider gender at Health Post
	*******************************************/
	if $sectionD {	
		
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
	Table of provider occupation - Female providers
	************************************************/
	if $sectionE {	
 	
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
	Table of provider occupation - Male providers
	************************************************/
	if $sectionF {	
 	
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
	
	/**************************************
	Table of provider occupation by country
	***************************************/
	if $sectionG {	
	
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
 
	/****************************************
	Table of provider characteristics   
	*****************************************/	
	if $sectionH {	
		
		*Create a facility count variable 
		egen fac_count = count(facility_id), by(cy)
		
		*This creates the numbers for each row 
		forvalues num = 1/28 {
			
			estpost	tab cy provider_male1 						// This creates the number stats for col 1 & 2
			matrix 	list e(b)
			matrix 	stat1 = e(b)  
			local 	D`num'r = stat1[1,`num'] 
			di		`D`num'r'
			
			matrix	list e(rowpct)						// This stores the percentages in a local
			matrix 	stat2 = e(rowpct)  
			local 	P`num'r = string(stat2[1,`num'],"%9.0f")  
			di		`P`num'r'
		}
		
		forvalues num = 1/56 {	
			estpost	tab cy facility_level 				// This creates the number stats for col 3,4 & 6
			matrix 	list e(b)
			matrix 	stat1 = e(b)  
			local 	H`num'r = stat1[1,`num'] 
			di		`H`num'r'
			
			matrix	list e(rowpct)						// This stores the percentages in a local 
			matrix 	stat2 = e(rowpct)  
			local 	A`num'r = string(stat2[1,`num'],"%9.0f")  
			di		`A`num'r'
		}
		
		forvalues num = 1/14 {	
			estpost	tab cy  							// This creates the number stats for 7
			matrix 	list e(b)
			matrix 	stat1 = e(b)  
			local 	N`num'r = stat1[1,`num'] 
			di		`N`num'r'
		}
		
		preserve
			*Remove duplicate facility ids - only need 1 facility id 
			bysort 	cy facility_id: gen facility_id_dup 	= cond(_N==1,0,_n) 		
			
			drop if	facility_id_dup > 1 		// drops if facility id is duplicated 
			drop 	facility_id_dup
		
			forvalues num = 1/14 {	
				estpost	tab  cy  							// This creates the number stats for 8
				matrix 	list e(b)
				matrix 	stat1 = e(b)  
				local 	F`num'r = stat1[1,`num'] 
				di		`F`num'r'
				}
		restore 
				
		*Create and build out latex table 
		file open 	descTable using "$EL_out/Final/Tex files/table_prov_fac.tex", write replace
		file write 	descTable ///
		"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
		"\begin{tabular}{l*{7}{c}}" _n ///
		"\hline\hline" _n ///
		"&\multicolumn{2}{c}{Gender} &\multicolumn{3}{c}{Facility Level}    \\\cmidrule(lr){2-3}\cmidrule(lr){4-6}" _n ///
		"&\multicolumn{1}{c}{Female}&\multicolumn{1}{c}{Male}&\multicolumn{1}{c}{Hospital}&\multicolumn{1}{c}{Health Center}&\multicolumn{1}{c}{Health Post}&\multicolumn{1}{c}{Total Providers}&\\" _n ///
		"\hline" _n ///
		"Guinea Bissau&  	{`D1r'(`P1r'\%)}&	 {`D15r'(`P15r'\%)}&	{`H1r'(`A1r'\%)}&		{`H15r'(`A15r'\%)}&		{`H29r'(`A29r'\%)}&		{`N1r'}\\" _n ///
		"Kenya 2012&  		{`D2r'(`P2r'\%)}&  	 {`D16r'(`P16r'\%)}&  	{`H2r'(`A2r'\%)}&		{`H16r'(`A16r'\%)}&		{`H30r'(`A30r'\%)}&		{`N2r'}\\" _n ///
		"Kenya 2018&	    {`D3r'(`P3r'\%)}&  	 {`D17r'(`P17r'\%)}&  	{`H3r'(`A3r'\%)}&		{`H17r'(`A17r'\%)}&		{`H31r'(`A31r'\%)}&		{`N3r'}\\" _n ///
		"Madagascar&	    {`D4r'(`P4r'\%)}&  	 {`D18r'(`P18r'\%)}&  	{`H4r'(`A4r'\%)}&		{`H18r'(`A18r'\%)}&		{`H32r'(`A32r'\%)}&		{`N4r'}\\" _n ///
		"Mozambique&	    {`D5r'(`P5r'\%)}&  	 {`D19r'(`P19r'\%)}&  	{`H5r'(`A5r'\%)}&		{`H19r'(`A19r'\%)}&		{`H33r'(`A33r'\%)}&		{`N5r'}\\" _n ///
		"Malawi&	      	{`D6r'(`P6r'\%)}&  	 {`D20r'(`P20r'\%)}&  	{`H6r'(`A6r'\%)}&		{`H20r'(`A20r'\%)}&		{`H34r'(`A34r'\%)}&		{`N6r'}\\" _n ///
		"Niger&	      		{`D7r'(`P7r'\%)}&  	 {`D21r'(`P21r'\%)}&  	{`H7r'(`A7r'\%)}&		{`H21r'(`A21r'\%)}&		{`H35r'(`A35r'\%)}&		{`N7r'}\\" _n ///
		"Nigeria&	      	{`D8r'(`P8r'\%)}&	 {`D22r'(`P22r'\%)}&  	{`H8r'(`A8r'\%)}&		{`H22r'(`A22r'\%)}&		{`H36r'(`A36r'\%)}&		{`N8r'}\\" _n ///
		"Sierra Leone&	    {`D9r'(`P9r'\%)}&	 {`D23r'(`P23r'\%)}&  	{`H9r'(`A9r'\%)}&		{`H23r'(`A23r'\%)}&		{`H37r'(`A37r'\%)}&		{`N9r'}\\" _n ///
		"Togo&	      		{`D10r'(`P10r'\%)}&  {`D24r'(`P24r'\%)}&  	{`H10r'(`A10r'\%)}&		{`H24r'(`A24r'\%)}&		{`H38r'(`A38r'\%)}&		{`N10r'}\\" _n ///
		"Tanzania 2014&	    {`D11r'(`P11r'\%)}&  {`D25r'(`P25r'\%)}&  	{`H11r'(`A11r'\%)}&		{`H25r'(`A25r'\%)}&		{`H39r'(`A39r'\%)}&		{`N11r'}\\" _n ///
		"Tanzania 2016&	    {`D12r'(`P12r'\%)}&  {`D26r'(`P26r'\%)}&  	{`H12r'(`A12r'\%)}&		{`H26r'(`A26r'\%)}&		{`H40r'(`A40r'\%)}&		{`N12r'}\\" _n ///
		"Uganda&	      	{`D13r'(`P13r'\%)}&  {`D27r'(`P27r'\%)}&  	{`H13r'(`A13r'\%)}&		{`H27r'(`A27r'\%)}&		{`H41r'(`A41r'\%)}&		{`N13r'}\\" _n ///
		"\hline" _n ///
		"Total&	      		{`D14r'}& 				{`D28r'}&  			{`H14r'}&				{`H28r'}&				{`H42r'}&			{`N14r'}\\" _n ///
		"\hline\hline" _n ///
		"\multicolumn{7}{l}{\footnotesize Notes: Gender is reported among the providers in the sample of 87,153 providers. Some providers did not report their gender}\\" _n ///
		"\multicolumn{7}{l}{\footnotesize status. Some providers did not report their gender status. The facility level were selected from the listing of health facilities} \\" _n ///
		"\multicolumn{7}{l}{\footnotesize provided by the Ministry of Health in each country. Facilties were randomly selected in each country when feasibile. The total}\\" _n ///
		"\multicolumn{7}{l}{\footnotesize number of providers includes all providers in the sample regardless if they reported their gender or not. }\\" _n ///
		"\end{tabular}"
		file close 	descTable	 	
		}			

		
********************************** End of do-file ************************************
