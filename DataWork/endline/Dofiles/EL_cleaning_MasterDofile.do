   * ******************************************************************** *
   * ******************************************************************** *
   *                                                                      *
   *               ENDLINE CLEANING MASTER DO_FILE                        *
   *               This master dofile calls all dofiles related           *
   *               to cleaning in the endline round.                      *
   *                                                                      *
   * ******************************************************************** *
   * ******************************************************************** *

   ** IDS VAR:          	country year facility_id
   ** NOTES:
   ** WRITTEN BY:       	Michael Orevba
   ** Last date modified:  	Feb 25th 2021

   
  
   * ***************************************************** *
   *
   *   cleaning dofile 1
   *
   *   The purpose of this dofiles is:
   *      - Translates the Guinea Bissau modules to English
   *      - Get datasets ready for de-identification
   *
   * ***************************************************** *

    * qui do "$EL_doCln/Translate_data.do" 
	
	*Note: the do-file above takes a very long time to return due to all the 
	*translation so I am commenting it out for now since the datasets are already
	*translated
   
   * ***************************************************** *
   *
   *   cleaning dofile 2
   *
   *   The purpose of this dofiles is:
   *      - De-identifies the raw dataset 
   *      - Removes all identifiable information 
   *
   * ***************************************************** *

     qui do "$EL_doCln/De_identify.do" 
	
	* ***************************************************** *
   *
   *   cleaning dofile 3
   *
   *   The purpose of this dofiles is:
   *      - Clean Module 1 of the Guinea Bissau datset
   *      - Harmonizes all the variables 
   *
   * ***************************************************** *

     qui do "$EL_doCln/Guinea Bissau/GuineaBissau_2018_Module1.do" 
	 
	 * ***************************************************** *
   *
   *   cleaning dofile 4
   *
   *   The purpose of this dofiles is:
   *      - Clean Module 2 of the Guinea Bissau datset
   *      - Harmonizes all the variables
   *
   * ***************************************************** *

    qui do "$EL_doCln/Guinea Bissau/GuineaBissau_2018_Module2.do" 
	 
	 * ***************************************************** *
   *
   *   cleaning dofile 5
   *
   *   The purpose of this dofiles is:
   *      - Clean Module 3 of the Guinea Bissau datset 
   *      - Harmonizes all the variables 
   *
   * ***************************************************** *

     qui do "$EL_doCln/Guinea Bissau/GuineaBissau_2018_Module3.do" 
	 
	* ***************************************************** *
   *
   *   cleaning dofile 6
   *
   *   The purpose of this dofiles is:
   *      - Clean Module 1 of the Malawi datset 
   *      - Harmonizes all the variables 
   *
   * ***************************************************** *

     qui do "$EL_doCln/Malawi/Malawi_2019_Module1.do" 
	 
	 * ***************************************************** *
   *
   *   cleaning dofile 7
   *
   *   The purpose of this dofiles is:
   *      - Clean Module 2 of the Malawi datset 
   *      - Harmonizes all the variables
   *
   * ***************************************************** *

    qui do "$EL_doCln/Malawi/Malawi_2019_Module2.do" 
	 
	 * ***************************************************** *
   *
   *   cleaning dofile 8
   *
   *   The purpose of this dofiles is:
   *      - Clean Module 3 of the Malawi datset 
   *      - Harmonizes all the variables 
   *
   * ***************************************************** *

     qui do "$EL_doCln/Malawi/Malawi_2019_Module3.do"  
	 
	 * ***************************************************** *
   *
   *   cleaning dofile 9
   *
   *   The purpose of this dofiles is:
   *      - Cleans the poverty rates dataset 
   *      - Creates merge ready poverty rates dataset
   *
   * ***************************************************** *

     qui do "$EL_doCln/Clean_pov.do" 	
	 
************************** End of do-file ******************************************
