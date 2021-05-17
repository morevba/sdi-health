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
       ** Last date modified: 	Jan 20th 2021
 */
 
		//Sections
		global sectionA		0 // Table of providers occupation 
		global sectionB		1 // Table of providers by occupation  


/*************************************
		Provider level dataset 
**************************************/

	*Open final facility level dataset 
	use "$EL_dtFin/Final_pl.dta", clear    
	
	*Create a new variables that combines country and year 
	gen			year_str		= string(year)
	egen 		country_year	= concat(country year_str), punct(_)
	label var 	country_year "Country name and year"
	
	*Drop unwanted variables 
	drop year_str

	/***************************
	Table by provider gender
	****************************/
	if $sectionA {	
	
	*This creates the numbers for columns 1 - Number of health providers per country 
	forvalues num = 1/13 {
	estpost	tab country_year 			// This creates the number stats for column 1
	matrix 	list e(b)
	matrix 	stat1 = e(b)  
	local 	N`num'c1 = stat1[1,`num'] 	// This stores those numbers in a local
	di	`	N`num'c1'
	
	matrix	list e(pct)
	matrix 	stat2 = e(pct)  
	local 	P`num'c1 = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
	di		`P`num'c1'
	}
	*
	
	*This creates the numbers for columns 2 - Number of male providers per country 
	forvalues num = 1/13 {
	estpost	tab country_year if provider_male1 == 0		// This creates the number stats for column 2
	matrix 	list e(b)
	matrix 	stat1 = e(b)  
	local 	N`num'c2 = stat1[1,`num'] 					// This stores those numbers in a local
	di	`	N`num'c2'
	
	matrix	list e(pct)
	matrix 	stat2 = e(pct)  
	local 	P`num'c2 = string(stat2[1,`num'],"%9.1f")  	// This stores the percentages in a local 
	di		`P`num'c2'
	}
	*

	*This creates the numbers for columns 3 - Number of female providers per country 
	forvalues num = 1/13 {
	estpost	tab country_year if provider_male1 == 1		// This creates the number stats for column 3
	matrix 	list e(b)
	matrix 	stat1 = e(b)  
	local 	N`num'c3 = stat1[1,`num'] 					// This stores those numbers in a local
	di	`	N`num'c3'
	
	matrix	list e(pct)
	matrix 	stat2 = e(pct)  
	local 	P`num'c3 = string(stat2[1,`num'],"%9.1f")  	// This stores the percentages in a local 
	di		`P`num'c3'
	}
	*
	
	*This creates the numbers for columns 4 - Average age per country 
	forvalues num = 1/13 {
	 estpost tabstat provider_age1, by(country_year)	// This creates the number stats for column 4
	matrix 	list e(mean)
	matrix 	stat1 = e(mean)  
	local 	N`num'c4 = string(stat1[1,`num'],"%9.1f")  		// This stores those numbers in a local
	di	`	N`num'c4'
	}
	*
 
	
* Creates table needed for Latex output below:
file open 	descTable using "$EL_out/Final/Des_table_pl.tex", write replace
file write 	descTable ///
"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
"\begin{tabular}{l*{6}{c}}" _n ///
"\hline\hline" _n ///
"               &\multicolumn{1}{c}{All Health Providers}&\multicolumn{1}{c}{Female Providers}&\multicolumn{1}{c}{Male Providers}&\multicolumn{1}{c}{Average Age}&\multicolumn{1}{}&\\" _n ///
"               &       N&                     N&       N&                                       N\\" _n ///
"               &     (\%)&                 (\%)&    (\%)&                                     {}\\" _n ///
"\hline" _n ///
"Kenya 2012&  				{`N1c1'}&  		{`N1c2'}&          {`N1c3'}&              {`N1c4'}\\" _n ///
"&    						{(`P1c1')}&  	{(`P1c2')}&        {(`P1c3')}&          	{}\\" _n ///
"Kenya 2018&	      		{`N2c1'}&  		{`N2c2'}&          {`N2c3'}&             {`N2c4'}\\" _n ///
"&      					{(`P2c1')}&  	{(`P2c2')}&        {(`P3c3')}&          	{}\\" _n ///
"Madgascar 2016&	      	{`N3c1'}&  		{`N3c2'}&          {`N3c3'}&             {`N3c4'}\\" _n ///
"&      					{(`P3c1')}&  	{(`P3c2')}&        {(`P3c3')}&          	{}\\" _n ///
"Malawi 2019&	      		{`N4c1'}&  		{`N4c2'}&          {`N4c3'}&             {`N4c4'}\\" _n ///
"&      					{(`P4c1')}&  	{(`P4c2')}&        {(`P4c3')}&          	{}\\" _n ///
"Mozambique 2014&	      	{`N5c1'}&  		{`N5c2'}&          {`N5c3'}&             {`N5c4'}\\" _n ///
"&      					{(`P5c1')}&  	{(`P5c2')}&        {(`P5c3')}&          	{}\\" _n ///
"Nigeria 2013&	      		{`N6c1'}&  		{`N6c2'}&          {`N6c3'}&             {`N6c4'}\\" _n ///
"&      					{(`P6c1')}&  	{(`P6c2')}&        {(`P6c3')}&          	{}\\" _n ///
"Niger 2015&	      		{`N7c1'}&  		{`N7c2'}&          {`N7c3'}&             {`N7c4'}\\" _n ///
"&      					{(`P7c1')}&  	{(`P7c2')}&        {(`P7c3')}&          	{}\\" _n ///
"Sierra Leone 2018&	      	{`N8c1'}&  		{`N8c2'}&          {`N8c3'}&             {`N8c4'}\\" _n ///
"&      					{(`P8c1')}&  	{(`P8c2')}&        {(`P8c3')}&          	{}\\" _n ///
"Tanzania 2014&	      		{`N9c1'}&  		{`N9c2'}&          {`N9c3'}&             {`N9c4'}\\" _n ///
"&      					{(`P9c1')}&  	{(`P9c2')}&        {(`P9c3')}&          	{}\\" _n ///
"Tanzania 2016&	      		{`N10c1'}&  	{`N10c2'}&         {`N10c3'}&           {`N10c4'}\\" _n ///
"&      					{(`P10c1')}&  	{(`P10c2')}&       {(`P10c3')}&          	{}\\" _n ///
"Togo 2014&	      			{`N11c1'}&  	{`N11c2'}&         {`N11c3'}&            {`N11c4'}\\" _n ///
"&      					{(`P11c1')}&  	{(`P11c2')}&       {(`P11c3')}&          	{}\\" _n ///
"Uganada 2013&	      		{`N12c1'}&  	{`N12c2'}&         {`N12c3'}&            {`N12c4'}\\" _n ///
"&      					{(`P12c1')}&  	{(`P12c2')}&       {(`P12c3')}&          	{}\\" _n ///
"\hline" _n ///
"\(N\)          		&	{`N13c1'}		&  {`N13c2'} &    {`N13c3'} &            {}\\" _n ///
"\hline\hline" _n ///
"\multicolumn{7}{l}{\footnotesize Numbers in parenthesis are column percentages}\\" _n ///
"\multicolumn{7}{l}{\footnotesize This table does not include Guinea Bissau (2018) and Cameroon (2019)}\\" _n ///
"\end{tabular}"
file close 	descTable

	}
	
	
	/***************************
	Table by provider occupation
	****************************/
	if $sectionB {	
	
	*This creates the numbers for columns 1 - Number of health facilities per country 
	forvalues num = 1/13 {
	estpost	tab country_year 			// This creates the number stats for column 1
	matrix 	list e(b)
	matrix 	stat1 = e(b)  
	local 	N`num'c1 = stat1[1,`num'] 	// This stores those numbers in a local
	di	`	N`num'c1'
	
	matrix	list e(pct)
	matrix 	stat2 = e(pct)  
	local 	P`num'c1 = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
	di		`P`num'c1'
	}
	*
	
	*This creates the numbers for columns 2 - Number of doctors per country 
	forvalues num = 1/13 {
	estpost	tab country_year if provider_cadre1 == 1		// This creates the number stats for column 2
	matrix 	list e(b)
	matrix 	stat1 = e(b)  
	local 	N`num'c2 = stat1[1,`num'] 					// This stores those numbers in a local
	di	`	N`num'c2'
	
	matrix	list e(pct)
	matrix 	stat2 = e(pct)  
	local 	P`num'c2 = string(stat2[1,`num'],"%9.1f")  	// This stores the percentages in a local 
	di		`P`num'c2'
	}
	*

	*This creates the numbers for columns 3 - Number of clinical officers per country 
	forvalues num = 1/13 {
	estpost	tab country_year if provider_cadre1 == 2		// This creates the number stats for column 3
	matrix 	list e(b)
	matrix 	stat1 = e(b)  
	local 	N`num'c3 = stat1[1,`num'] 					// This stores those numbers in a local
	di	`	N`num'c3'
	
	matrix	list e(pct)
	matrix 	stat2 = e(pct)  
	local 	P`num'c3 = string(stat2[1,`num'],"%9.1f")  	// This stores the percentages in a local 
	di		`P`num'c3'
	}
	*
	
	*This creates the numbers for columns 4 - Number of nurses per country 
	forvalues num = 1/13 {
	estpost	tab country_year if provider_cadre1 == 3		// This creates the number stats for column 4
	matrix 	list e(b)
	matrix 	stat1 = e(b)  
	local 	N`num'c4 = stat1[1,`num'] 					// This stores those numbers in a local
	di	`	N`num'c4'
	
	matrix	list e(pct)
	matrix 	stat2 = e(pct)  
	local 	P`num'c4 = string(stat2[1,`num'],"%9.1f")  	// This stores the percentages in a local 
	di		`P`num'c4'
	}
	*	
	
	*This creates the numbers for columns 5 - Number of other per country 
	forvalues num = 1/13 {
	estpost	tab country_year if provider_cadre1 == 4		// This creates the number stats for column 5
	matrix 	list e(b)
	matrix 	stat1 = e(b)  
	local 	N`num'c5 = stat1[1,`num'] 					// This stores those numbers in a local
	di	`	N`num'c5'
	
	matrix	list e(pct)
	matrix 	stat2 = e(pct)  
	local 	P`num'c5 = string(stat2[1,`num'],"%9.1f")  	// This stores the percentages in a local 
	di		`P`num'c5'
	}
	*		
	
	
file open 	descTable using "$EL_out/Final/Des_table_pl_2.tex", write replace
file write 	descTable ///
"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
"\begin{tabular}{l*{6}{c}}" _n ///
"\hline\hline" _n ///
"         &\multicolumn{1}{c}{All Health Providers}&\multicolumn{1}{c}{Doctors}&\multicolumn{1}{c}{Clinical Officers}&\multicolumn{1}{c}{Nurses}&\multicolumn{1}{c}{Other}&\\" _n ///
"         &       				N&     		N&      			N&       	N&           N\\" _n ///
"         &    					(\%)&   	(\%)&   			(\%)&    	(\%)&       (\%)\\" _n ///
"\hline" _n ///
"Kenya 2012&  				{`N1c1'}&  		{`N1c2'}&          {`N1c3'}&     	{`N1c4'}&		{`N1c5'}\\" _n ///
"&    						{(`P1c1')}&  	{(`P1c2')}&        {(`P1c3')}&   	{(`P1c4')}&     {(`P1c5')}\\" _n ///
"Kenya 2018&	      		{`N2c1'}&  		{`N2c2'}&          {0}&     		{`N2c4'}&       {`N2c5'}\\" _n ///
"&      					{(`P2c1')}&  	{(`P2c2')}&        {(0)}&   		{(`P2c4')}&     {(`P2c5')}\\" _n ///
"Madgascar 2016&	      	{`N3c1'}&  		{`N3c2'}&          {0}&    			{`N3c4'}&       {`N3c5'}\\" _n ///
"&      					{(`P3c1')}&  	{(`P3c2')}&        {(0)}&   		{(`P3c4')}&     {(`P3c5')}\\" _n ///
"Malawi 2019&	      		{`N4c1'}&  		{0}& 		       {0}&    			{0}&      		{0}\\" _n ///
"&      					{(`P4c1')}&  	{(0)}&      	   {(0)}&   		{(0)}&     		{(0)}\\" _n ///
"Mozambique 2014&	      	{`N5c1'}&  		{`N4c2'}&          {0}&    			{`N4c4'}&       {`N4c5'}\\" _n ///
"&      					{(`P5c1')}&  	{(`P4c2')}&        {(0)}&   		{(`P4c4')}&     {(`P4c5')}\\" _n ///
"Nigeria 2013&	      		{`N6c1'}&  		{`N5c2'}&          {0}&    			{`N5c4'}&       {`N5c5'}\\" _n ///
"&      					{(`P6c1')}&  	{(`P5c2')}&        {(0)}&   		{(`P5c4')}&     {(`P5c5')}\\" _n ///
"Niger 2015&	      		{`N7c1'}&  		{`N6c2'}&  		   {0}&    			{`N6c4'}&       {`N6c5'}\\" _n ///
"&      					{(`P7c1')}&  	{(`P6c2')}&        {(0)}&   		{(`P6c4')}&     {(`P6c5')}\\" _n ///
"Sierra Leone 2018&	      	{`N8c1'}&  		{`N7c2'}&          {0}&    			{`N7c4'}&       {`N7c5'}\\" _n ///
"&      					{(`P8c1')}&  	{(`P7c2')}&        {(0)}&   		{(`P7c4')}&     {(`P7c5')}\\" _n ///
"Tanzania 2014&	      		{`N9c1'}&  		{`N8c2'}&          {`N2c3'}&    	{`N8c4'}&       {`N8c5'}\\" _n ///
"&      					{(`P9c1')}&  	{(`P8c2')}&        {(`P2c3')}&   	{(`P8c4')}&     {(`P8c5')}\\" _n ///
"Tanzania 2016&	      		{`N10c1'}&  	{`N9c2'}&          {0}&   			{`N9c4'}&       {`N9c5'}\\" _n ///
"&      					{(`P10c1')}&  	{(`P9c2')}&        {(0)}&  			{(`P9c4')}&     {(`P9c5')}\\" _n ///
"Togo 2014&	      			{`N11c1'}&  	{`N10c2'}&         {0}&   			{`N10c4'}&      {`N10c5'}\\" _n ///
"&      					{(`P11c1')}&  	{(`P10c2')}&       {(0)}&  			{(`P10c4')}&    {(`P10c5')}\\" _n ///
"Uganada 2013&	      		{`N12c1'}&  	{`N11c2'}&         {0}&   			{`N11c4'}&      {`N11c5'}\\" _n ///
"&      					{(`P12c1')}&  	{(`P11c2')}&       {(0)}&  			{(`P11c4')}&    {(`P11c5')}\\" _n ///
"\hline" _n ///
"\(N\)    &   				{`N13c1'}&    {`N12c2'}&    {`N3c3'}&       {`N12c4'}&        {`N12c5'}\\" _n ///
"\hline\hline" _n ///
"\multicolumn{6}{l}{\footnotesize Numbers in parenthesis are column percentages}\\" _n ///
"\multicolumn{6}{l}{\footnotesize This table does not include Guinea Bissau (2018) and Cameroon (2019)}\\" _n ///
"\end{tabular}"
file close 	descTable		

	}		
	
	
	
	
	
********************************** End of do-file ************************************
