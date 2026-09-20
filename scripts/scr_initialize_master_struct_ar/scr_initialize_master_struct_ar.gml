
/*

//9-20-26: not currently in use, at least not for the load game function.

Initializes our g.master_struct_ar for the first time;

deletes all structs first;

--g.master_level_ar must be correctly defined first.

*/

function scr_initialize_master_struct_ar(called_from_str){
	
	show_debug_message($"Entering scr_initialize_master_struct_ar: it was called from: {called_from_str}");
	
	scr_destroy_all_structs();
	
	global.master_struct_ar = -1;
	global.master_struct_ar = [];
	
	var world_ar_len = array_length(global.master_level_ar);
	var level_len;
	
	for(var yy = 0; yy < world_ar_len; yy++) {
		
		level_len = array_length(global.master_level_ar[yy]);
		
		global.master_struct_ar[yy] = array_create(level_len); //This not only creates the new dungeon array [yy], but create 
		
		for(var l = 0; l < array_length(global.master_struct_ar[yy]); l++) {
			
			global.master_struct_ar[yy][l] = array_create(AR_TOTAL_ARS);
			
			for(var t = 0; t < array_length(global.master_struct_ar[yy][l]); t++) { //We create an array for every different TYPE of struct on this level
				
				global.master_struct_ar[yy][l][t] = []; 	
			}
		}
	}	
}