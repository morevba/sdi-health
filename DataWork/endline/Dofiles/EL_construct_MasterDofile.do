   * ******************************************************************** *
   * ******************************************************************** *
   *                                                                      *
   *               ENDLINE CONSTRUCT MASTER DO_FILE                       *
   *               This master dofile calls all dofiles related           *
   *               to construct in the endline round.                     *
   *                                                                      *
   * ******************************************************************** *
   * ******************************************************************** *

   ** IDS VAR:          country year facility_id provider_id 
   ** NOTES:
   ** WRITTEN BY:       	Michael Orevba
   ** Last date modified:  	22 Jan 2021


   
   * ***************************************************** *
   *                                                       *
   * ***************************************************** *
   *
   *   construct dofile 1
   *
   *   The purpose of this dofiles is:
   *	  - Harmonizes module 1 variables across all countries 
   *      - Appends all the module 1 dataset for each country 
   *      - Creates a final module 1 dataset containg all countries   
   *
   * ***************************************************** *

		qui do "$EL_doCon/Module1_Prep.do" 
   
   * ***************************************************** *
   *                                                       *
   * ***************************************************** *
   *
   *   construct dofile 2
   *
   *   The purpose of this dofiles is:
   *	  - Harmonizes module 2 variables across all countries 
   *      - Appends all the module 2 dataset for each country 
   *      - Creates a final module 2 dataset containg all countries 
   *
   * ***************************************************** *

		qui do "$EL_doCon/Module2_Prep.do" 
   
   * ***************************************************** *
   *                                                       *
   * ***************************************************** *
   *
   *   construct dofile 3
   *
   *   The purpose of this dofiles is:
   *	  - Harmonizes module 3 variables across all countries 
   *      - Appends all the module 3 dataset for each country 
   *      - Creates a final module 3 dataset containg all countries 
   *
   * ***************************************************** *

		qui do "$EL_doCon/Module3_Prep.do" 
		
   * ***************************************************** *
   *                                                       *
   * ***************************************************** *
   *
   *   construct dofile 4
   *
   *   The purpose of this dofiles is:
   *      - Merges all the module datasets together 
   *      - Creates a dataset containing all modules
   *	  - Create and harmonizes more variables 
   *	  - Creates the final harmonized dataset 
   * ***************************************************** *

		qui do "$EL_doCon/Module123_Combine.do" 
		
   * ***************************************************** *
   *                                                       *
   * ***************************************************** *
   *
   *   construct dofile 5
   *
   *   The purpose of this dofiles is:
   *      - Cleans up the GPS coordinates variables  
   *      - Merge cleaned GSP coordinate variables with 
   *		harmonized dataset 
   * ***************************************************** *

		qui do "$EL_doCon/GPS_prep.do" 		
		
   * ***************************************************** *
   *                                                       *
   * ***************************************************** *
   *
   *   construct dofile 6
   *
   *   The purpose of this dofiles is:
   *      - Create facility level datasets for each country
   *      - Keeps key variables related to facility level 
   *
   * ***************************************************** *

     qui  do "$EL_doCon/Create_skinny_fl_data.do" 

   * ***************************************************** *
   *                                                       *
   * ***************************************************** *
   *
   *   construct dofile 7
   *
   *   The purpose of this dofiles is:
   *      - Create provider level datasets for each country
   *      - Keeps key variables related to provider level 
   *
   * ***************************************************** *

     qui  do "$EL_doCon/Create_skinny_pl_data.do" 		
   
   * ***************************************************** *
   *                                                       *
   * ***************************************************** *
   *
   *   construct dofile 8
   *
   *   The purpose of this dofiles is:
   *      - Appends all facility level datasets
   *      - Creates a facility level dataset that contains all countries  
   *
   * ***************************************************** *

		qui do "$EL_doCon/Append_skinny_fl_data.do" 
		
   * ***************************************************** *
   *                                                       *
   * ***************************************************** *
   *
   *   construct dofile 9
   *
   *   The purpose of this dofiles is:
   *      - Appends all provider level datasets
   *      - Creates a provider level dataset that contains all countries  
   *
   * ***************************************************** *

		qui do "$EL_doCon/Append_skinny_pl_data.do" 		

   * ***************************************************** *
   *
   *   construct dofile 9
   *
   *   The purpose of this dofiles is:
   *      - Merge additional datasets to the appended skinny fl dataset
   *      - Creates a final facility level dataset 
   *
   * ***************************************************** *

       qui do "$EL_doCon/Merge_variables_fl_data.do" 

   * ***************************************************** *
   *
   *   construct dofile 10
   *
   *   The purpose of this dofiles is:
   *      - Merge additional datasets to the appended skinny pl dataset
   *      - Creates a final provider level dataset 
   *
   * ***************************************************** *

       qui do "$EL_doCon/Merge_variables_pl_data.do" 	   
  
**************************** End do-file ********************************************
