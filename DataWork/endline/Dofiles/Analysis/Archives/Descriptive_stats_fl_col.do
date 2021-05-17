* ******************************************************************** *
* ******************************************************************** *
*                                                                      *
*              	Descriptive Stats									   *
*				Facility ID 										   *
*                                                                      *
* ******************************************************************** *
* ******************************************************************** *
/*
	  ** PURPOSE: Create figures and graphs on caseload 

       ** IDS VAR: country year facility_id 
       ** NOTES:
       ** WRITTEN BY:			Michael Orevba
       ** Last date modified: 	Jan 20th 2021
 */
 
		//Sections
		global sectionA		1 // Table of facility level by country 
		global sectionB		0 // Table of facility type by counrty  


/*************************************
		Facility level dataset 
**************************************/

	*Open final facility level dataset 
	use "$EL_dtFin/Final_fl.dta", clear    
 
	/***************************
	Table by facility level
	****************************/
*	if $sectionA {	
	
	*This creates the numbers for each row - Number of health providers for each row  
	forvalues num = 1/56 {
		estpost	tab cy facility_level		// This creates the number stats for reach row 

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
	
* Creates table needed for Latex output below:
file open 	descTable using "$EL_out/Final/Des_table_fl.tex", write replace
file write 	descTable ///
"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
"\begin{tabular}{l*{6}{c}}" _n ///
"\hline\hline" _n ///
"               &\multicolumn{1}{c}{Hopitals}&\multicolumn{1}{c}{Health Centers}&\multicolumn{1}{c}{Health Post}&\multicolumn{1}{c}{All Health Facilties}&\multicolumn{1}{}&\\" _n ///
"               &       N&                     N&       N&                                       N\\" _n ///
"               &     (\%)&                 (\%)&    (\%)&                                     (\%)\\" _n ///
"\hline" _n ///
"Guinea Bissau 2018&  		{`N1r'}&  		{`N15r'}&           {`N29r'}&             {`N43r'}\\" _n ///
"&    						{(`P1r')}&  	{(`P15r')}&        	{(`P29r')}&           {(`P43r')}\\" _n ///
"Kenya 2012&  				{`N2r'}&  		{`N16r'}&           {`N30r'}&             {`N44r'}\\" _n ///
"&    						{(`P2r')}&  	{(`P16r')}&        	{(`P30r')}&           {(`P44r')}\\" _n ///
"Kenya 2018&	      		{`N3r'}&  		{`N17r'}&           {`N31r'}&             {`N45r'}\\" _n ///
"&      					{(`P3r')}&  	{(`P17r')}&        	{(`P31r')}&           {(`P45r')}\\" _n ///
"Madgascar 2016&	      	{`N4r'}&  		{`N18r'}&           {`N32r'}&             {`N46r'}\\" _n ///
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
"Uganada 2013&	      		{`N13r'}&  		{`N27r'}&           {`N41r'}&             {`N55r'}\\" _n ///
"&      					{(`P13r')}&  	{(`P27r')}&       	{(`P41r')}&           {(`P55r')}\\" _n ///
"\hline" _n ///
"\(N\)    &   				{`N14r'}&    	{`N28r'}&        	{`N42r'}&        {`N56r'}\\" _n ///
"\hline\hline" _n ///
"\multicolumn{7}{l}{\footnotesize Numbers in parenthesis are row percentages}\\" _n ///
"\end{tabular}"
file close 	descTable

	}	 


************************* End of do-file *******************************************
