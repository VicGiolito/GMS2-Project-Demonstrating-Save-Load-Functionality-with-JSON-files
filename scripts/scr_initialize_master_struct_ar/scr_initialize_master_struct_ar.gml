

function scr_initialize_master_struct_ar(called_from_str){
	
	show_debug_message($"Entering scr_initialize_master_struct_ar: it was called from: {called_from_str}");
	
	scr_destroy_all_structs();
	
	global.master_struct_ar = -1;
	global.master_struct_ar = [];
	
	var world_ar_len = array_length(global.master_level_ar);
	var level_len;
	
	for(var d = 0; d < world_ar_len; d++) {
		
		level_len = array_length(global.master_level_ar[d]);
		
		global.master_struct_ar[d] = array_create(level_len);
		
		for(var l = 0; l < array_length(global.master_struct_ar[d]); l++) {
			
			global.master_struct_ar[d][l] = array_create(AR_TOTAL_ARS);
			
			for(var t = 0; t < array_length(global.master_struct_ar[d][l]); t++) {
				
				global.master_struct_ar[d][l][t] = []; 	
			}
		}
	}	
}