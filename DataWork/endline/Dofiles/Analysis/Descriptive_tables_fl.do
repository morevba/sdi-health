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
       ** Last date modified: 	Mar 19th 2021
 */
 
		//Sections
		global sectionA		0 // Table of facility level by country 
		global sectionB		0 // Table of facility type by counrty  


/*************************************
		Facility level dataset 
**************************************/

	*Open final facility level dataset 
	use "$EL_dtFin/Final_fl.dta", clear    
	
	/***************************
	Table by facility level
	****************************/
	if $sectionA {	
	
	*This creates the numbers for each row - Number of health facilities per country 
	forvalues num = 1/56 {
	estpost	tab cy facility_level			// This creates the number stats for each row
	matrix 	list e(b)
	matrix 	stat1 = e(b)  
	local 	N`num'r = stat1[1,`num'] 	// This stores those numbers in a local
	di	`	N`num'r'
	
	matrix	list e(rowpct)
	matrix 	stat2 = e(rowpct)  
	local 	P`num'r = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
	di		`P`num'r'
	}
	* 	

		
	* Creates table needed for Latex output below:
	file open 	descTable using "$EL_out/Final/Tex files/Des_table_fl.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{6}{c}}" _n ///
	"\hline\hline" _n ///
	"               &\multicolumn{1}{c}{Hospitals}&\multicolumn{1}{c}{Health Centers}&\multicolumn{1}{c}{Health Posts}&\multicolumn{1}{c}{All Health Facilities}&\\" _n ///
	"               &       N&                     N&       N&                                       N\\" _n ///
	"               &     (\%)&                 (\%)&    (\%)&                                     (\%)\\" _n ///
	"\hline" _n ///
	"Guinea Bissau 2018&  		{`N1r'}&  		{`N15r'}&          {`N29r'}&             {`N43r'}\\" _n ///
	"&    						{(`P1r')}&  	{(`P15r')}&        {(`P29r')}&         	 {(`P43r')}\\" _n ///
	"Kenya 2012&  				{`N2r'}&  		{`N16r'}&          {`N30r'}&             {`N44r'}\\" _n ///
	"&    						{(`P2r')}&  	{(`P16r')}&        {(`P30r')}&         	 {(`P44r')}\\" _n ///
	"Kenya 2018&	      		{`N3r'}&  		{`N17r'}&          {`N31r'}&             {`N45r'}\\" _n ///
	"&      					{(`P3r')}&  	{(`P17r')}&        {(`P31r')}&         	 {(`P45r')}\\" _n ///
	"Madagascar 2016&	      	{`N4r'}&  		{`N18r'}&          {`N32r'}&             {`N46r'}\\" _n ///
	"&      					{(`P4r')}&  	{(`P18r')}&        {(`P32r')}&         	 {(`P46r')}\\" _n ///
	"Malawi 2019&	      		{`N5r'}&  		{`N19r'}&          {`N33r'}&             {`N47r'}\\" _n ///
	"&      					{(`P5r')}&  	{(`P19r')}&        {(`P33r')}&        	 {(`P47r')}\\" _n ///
	"Mozambique 2014&	      	{`N6r'}&  		{`N20r'}&          {`N34r'}&             {`N48r'}\\" _n ///
	"&      					{(`P6r')}&  	{(`P20r')}&        {(`P34r')}&         	 {(`P48r')}\\" _n ///
	"Nigeria 2013&	      		{`N7r'}&  		{`N21r'}&          {`N35r'}&             {`N49r'}\\" _n ///
	"&      					{(`P7r')}&  	{(`P21r')}&        {(`P35r')}&         	 {(`P49r')}\\" _n ///
	"Niger 2015&	      		{`N8r'}&  		{`N22r'}&          {`N36r'}&             {`N50r'}\\" _n ///
	"&      					{(`P8r')}&  	{(`P22r')}&        {(`P36r')}&         	 {(`P50r')}\\" _n ///
	"Sierra Leone 2018&	      	{`N9r'}&  		{`N23r'}&          {`N37r'}&             {`N51r'}\\" _n ///
	"&      					{(`P9r')}&  	{(`P23r')}&        {(`P37r')}&         	 {(`P51r')}\\" _n ///
	"Tanzania 2014&	      		{`N10r'}&  		{`N24r'}&          {`N38r'}&             {`N52r'}\\" _n ///
	"&      					{(`P10r')}&  	{(`P24r')}&        {(`P38r')}&           {(`P52r')}\\" _n ///
	"Tanzania 2016&	      		{`N11r'}&  		{`N25r'}&          {`N39r'}&              {`N53r'}\\" _n ///
	"&      					{(`P11r')}&  	{(`P25r')}&        {(`P39r')}&         	 {(`P53r')}\\" _n ///
	"Togo 2014&	      			{`N12r'}&  		{`N26r'}&          {`N40r'}&              {`N54r'}\\" _n ///
	"&      					{(`P12r')}&  	{(`P26r')}&        {(`P40r')}&         	 {(`P54r')}\\" _n ///
	"Uganda 2013&	      		{`N13r'}&  		{`N27r'}&          {`N41r'}&              {`N55r'}\\" _n ///
	"&      					{(`P13r')}&  	{(`P27r')}&        {(`P41r')}&          {(`P55r')}\\" _n ///
	"\hline" _n ///
	"\(N\)          		&	{`N14r'}	&  {`N28r'} 	&    {`N42r'} &            {`N56r'}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{6}{l}{\footnotesize Numbers in parenthesis are row percentages}\\" _n ///
	"\end{tabular}"
	file close 	descTable

	}	

	/***************************
	Table by facility type
	****************************/
	if $sectionB {	
	
	*This creates the numbers for each row - Number of health facilities per country 
	forvalues num = 1/91 {
	estpost	tab cy fac_type			// This creates the number stats for reach row 
	matrix 	list e(b)
	matrix 	stat1 = e(b)  
	local 	N`num'r = stat1[1,`num'] 	// This stores those numbers in a local
	di	`	N`num'r'
	
	matrix	list e(rowpct)
	matrix 	stat2 = e(rowpct)  
	local 	P`num'r = string(stat2[1,`num'],"%9.1f")  // This stores the percentages in a local 
	di		`P`num'r'
	}
	* 
	
		
	file open 	descTable using "$EL_out/Final/Des_table_fl_2.tex", write replace
	file write 	descTable ///
	"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n ///
	"\begin{tabular}{l*{7}{c}}" _n ///
	"\hline\hline" _n ///
	"         &\multicolumn{1}{c}{Rural Hospitals}&\multicolumn{1}{c}{Rural Clinics}&\multicolumn{1}{c}{Rural Health Posts}&\multicolumn{1}{c}{Urban Hospitals}&\multicolumn{1}{c}{Urban Clinics}&\multicolumn{1}{c}{Urban Health Posts}&\multicolumn{1}{c}{All Health Facilities}\\" _n ///
	"         &       				N&     		N&      			N&       	N&			N&       	N&       N\\" _n ///
	"         &    					(\%)&   	(\%)&   			(\%)&    	(\%)&		(\%)&    	(\%)&    (\%)\\" _n ///
	"\hline" _n ///
	"Kenya 2012&  				{`N1r'}&  		{`N14r'}&          {`N27r'}&     		{`N40r'}&		{`N53r'}&		{`N66r'}&       {`N79r'}\\" _n ///
	"&    						{(`P1r')}&  	{(`P14r')}&        {(`P27r')}&   		{(`P40r')}&     {(`P53r')}&   	{(`P66r')}&	    {(`P79r')}\\" _n ///
	"Kenya 2018&	      		{`N2r'}&  		{`N15r'}&          {`N28r'}&     		{`N41r'}&       {`N54r'}& 		{`N67r'}&		{`N80r'}\\" _n ///
	"&      					{(`P2r')}&  	{(`P15r')}&        {(`P28r')}&   		{(`P41r')}&     {(`P54r')}&    	{(`P67r')}&		{(`P80r')}\\" _n ///
	"Madgascar 2016&	      	{`N3r'}&  		{`N16r'}&          {`N29r'}&    		{`N42r'}&       {`N55r'}&  		{`N68r'}&		{`N81r'}\\" _n ///
	"&      					{(`P3r')}&  	{(`P16r')}&        {(`P29r')}&   		{(`P42r')}&     {(`P55r')}&    	{(`P68r')}&		{(`P81r')}\\" _n ///
	"Malawi 2019&	      		{`N4r'}&  		{`N17r'}&          {`N30r'}&    		{`N43r'}&       {`N56r'}&  		{`N69r'}&		{`N82r'}\\" _n ///
	"&      					{(`P4r')}&  	{(`P17r')}&        {(`P30r')}&   		{(`P43r')}&     {(`P56r')}&    	{(`P69r')}&		{(`P82r')}\\" _n ///
	"Mozambique 2014&	      	{`N5r'}&  		{`N18r'}&          {`N31r'}&    		{`N44r'}&       {`N57r'}&  		{`N70r'}&		{`N83r'}\\" _n ///
	"&      					{(`P5r')}&  	{(`P8r')}&         {(`P31r')}&   		{(`P44r')}&     {(`P57r')}&    	{(`P70r')}&		{(`P83r')}\\" _n ///
	"Nigeria 2013&	      		{`N6r'}&  		{`N19r'}&          {`N32r'}&    		{`N45r'}&       {`N58r'}&  		{`N71r'}&		{`N84r'}\\" _n ///
	"&      					{(`P6r')}&  	{(`P19r')}&        {(`P32r')}&   		{(`P45r')}&     {(`P58r')}&    	{(`P71r')}&		{(`P84r')}\\" _n ///
	"Niger 2015&	      		{`N7r'}&  		{`N20r'}&  		   {`N33r'}&    		{`N46r'}&       {`N59r'}&  		{`N72r'}&		{`N85r'}\\" _n ///
	"&      					{(`P7r')}&  	{(`P20r')}&        {(`P33r')}&   		{(`P46r')}&     {(`P59r')}&    	{(`P72r')}&		{(`P85r')}\\" _n ///
	"Sierra Leone 2018&	      	{`N8r'}&  		{`N21r'}&          {`N34r'}&    		{`N47r'}&       {`N60r'}&  		{`N73r'}&		{`N86r'}\\" _n ///
	"&      					{(`P8r')}&  	{(`P21r')}&        {(`P34r')}&   		{(`P47r')}&     {(`P60r')}&    	{(`P73r')}&		{(`P86r')}\\" _n ///
	"Tanzania 2014&	      		{`N9r'}&  		{`N22r'}&          {`N35r'}&    		{`N48r'}&       {`N61r'}&  		{`N74r'}&		{`N87r'}\\" _n ///
	"&      					{(`P9r')}&  	{(`P22r')}&        {(`P35r')}&   		{(`P48r')}&     {(`P61r')}&    	{(`P74r')}&		{(`P87r')}\\" _n ///
	"Tanzania 2016&	      		{`N10r'}&  		{`N23r'}&          {`N36r'}&   			{`N49r'}&       {`N62r'}&  		{`N75r'}&		{`N88r'}\\" _n ///
	"&      					{(`P10r')}&  	{(`P23r')}&        {(`P36r')}&  	    {(`P49r')}&     {(`P62r')}&   	{(`P75r')}&		{(`P88r')}\\" _n ///
	"Togo 2014&	      			{`N11r'}&  		{`N24r'}&          {`N37r'}&   			{`N50r'}&       {`N63r'}&  		{`N76r'}&		{`N89r'}\\" _n ///
	"&      					{(`P12r')}&  	{(`P24r')}&        {(`P37r')}&  	    {(`P50r')}&    	{(`P63r')}&   	{(`P76r')}&		{(`P89r')}\\" _n ///
	"Uganada 2013&	      		{`N12r'}&  		{`N25r'}&          {`N38r'}&   			{`N51r'}&      	{`N64r'}&  		{`N77r'}&		{`N90r'}\\" _n ///
	"&      					{(`P12r')}&  	{(`P25r')}&        {(`P38r')}&  		{(`P51r')}&    	{(`P64r')}&    	{(`P77r')}&		{(`P90r')}\\" _n ///
	"\hline" _n ///
	"\(N\)    &   				{`N13r'}&    	{`N26r'}&    		{`N39r'}&      		 {`N52r'}&        {`N65r'}&    {`N78r'}&         {`N91r'}\\" _n ///
	"\hline\hline" _n ///
	"\multicolumn{6}{l}{\footnotesize Numbers in parenthesis are row percentages}\\" _n ///
	"\multicolumn{6}{l}{\footnotesize This table does not include Guinea Bissau (2018) and Cameroon (2019)}\\" _n ///
	"\end{tabular}"
	file close 	descTable		

	}	
	

************************* End of do-file *******************************************
