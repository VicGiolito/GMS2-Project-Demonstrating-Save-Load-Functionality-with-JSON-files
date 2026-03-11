/*

This script creates the g.master_struct_ar to match the structure of the g.master_level_ar, adding empty arrays for EVERY team array

Needs be run or defined with scr_load_file before we start referencing it and adding structs to it 

Also must be run AFTER scr_generate_maze has created EVERY world in order to copy the same array structure as g.master_level_ar

*/

function scr_setup_master_struct_ar(){
	
	for(var i = 0; i < array_length(global.master_level_ar); i++) { //Iterating through worlds ars
		
		global.master_struct_ar[i] = []; //floors ar
		
		for(var yy = 0; yy < array_length(global.master_level_ar[i]); yy++) { //Iterating through floors ars
			
			global.master_struct_ar[i][yy] = array_create(AR_TOTAL_ARS); //7 ar indices per floor
			
			//Create empty arrays within each AR array
			for(var s = 0; s < AR_TOTAL_ARS; s++) { //Iterating through the different AR_PC, etc. arrays
				
				global.master_struct_ar[i][yy][s] = [];
			}
		}
	}
}