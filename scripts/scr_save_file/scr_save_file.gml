
/* 
	dungeon_ind: is used for meta_data.sav only: this determines what dungeon will be LOADED next, and how many 
	FLOORS will be loaded from that dungeon
	
	floor_ind: is used for meta_data only: this determines 

	Currently, this script saves EVERYTHING that is stored within our g.master_struct_ar and g.master_level_ar 
	into the external save file,
	AND it wipes the external file of all data that matches the structure of our g.master_struct_ar.

*/

function scr_save_file(save_game_name_str,dungeon_ind,floor_ind, called_from_str){
	
	show_debug_message("Entering scr_save_file: it was called from: "+string(called_from_str) );
	
	// Create base directory
	if !directory_exists(save_game_name_str) {
		directory_create(save_game_name_str);
	}
	
	#region Save metadata struct:
	
	var dungeon_floor_len = array_length(global.master_level_ar[dungeon_ind])
	
	var save_metadata_struct = {
		unique_save_name_str: string(save_game_name_str),
		version: "v0.3.0",
        timestamp: date_current_datetime(),
		cur_dungeon_ind_: dungeon_ind,
		cur_floor_ind_: floor_ind,
		max_floors_in_dungeon: dungeon_floor_len //This is used in scr_load_file() to load every floor in the CURRENT dungeon that we will LOAD into the next time the game is LOADED.
	}
	
	var filename_str = save_game_name_str + "/meta_data";
	var file = file_text_open_write(filename_str);

	// Throw error:
	if (file == -1) {
		show_error("file_text_open_write(filename) returned -1. filename = " + string(filename_str), true);	
	}

	file_text_write_string(file, json_stringify(save_metadata_struct)); // Convert array to JSON

	if (file_text_close(file) == false) {
		show_error("file_text_close(file) returned false. file == " + string(file), true);
	}
	
	#endregion
	
	#region First, we need to wipe the external file so that everything that is in currently memory match will match the external file exactly:
	
	//Iterate through dungeon:
	for (var w = 0; w < array_length(global.master_struct_ar); w++) {
		//Iterate through levels
		for(var f = 0; f < array_length(global.master_struct_ar[w]); f++) {
			//Iterate through team arrays:
			for(var t = 0; t < array_length(global.master_struct_ar[w][f]); t++) { 
				
				var file_path_str = game_save_id+save_game_name_str+"\\"+string(w)+"\\"+string(f)+"\\"+string(t)+"\\struct_data";
					
				if file_exists(file_path_str){
							
					if file_delete(file_path_str) {
						show_debug_message($"scr_save_file: Wiping data from external file: We SUCCESSFULLY deleted struct_data at world_index: {w}, floor_index: {f}, team_array: {t}.");	
					} else {
						show_debug_message($"scr_save_file: Wiping data from external file: We FAILED to delete struct_data at world_index: {w}, floor_index: {f}, team_array: {t}.");			
					}
				}
				else {
					show_debug_message($"scr_save_file: the following file_path_str doesn't exist: {file_path_str}, so we were unable to delete the associated struct_data file.");	
				}
			}
		}
	}
	
	#endregion
	
	#region Iterate through master_struct_ar:
	
	for (var w = 0; w < array_length(global.master_struct_ar); w++) { 
	    
		if !is_array(global.master_struct_ar[w]) continue; // Skip if not array
		
		// Iterate through levels
		for(var f = 0; f < array_length(global.master_struct_ar[w]); f++) { 
        
			if !is_array(global.master_struct_ar[w][f]) continue; // Skip if not array
			
			//Iterate through team arrays:
			for(var t = 0; t < array_length(global.master_struct_ar[w][f]); t++) { 
				
				var team_ar = global.master_struct_ar[w][f][t];
				
				//We need to check and see if a struct_data file exists at this location and if does, remove it; this should no longer ever be the case now that we're wiping data first, but just as a failsafe we'll still check:
				if !is_array(team_ar) {
					
					var file_path_str = working_directory+save_game_name_str+"/"+string(w)+"/"+string(f)+"/"+string(t)+"/struct_data";
					
					if file_exists(file_path_str){
							
						if file_delete(file_path_str) {
							show_debug_message($"scr_save_file: No array containing structs existed in the g.master_struct_ar at world_index: {w}, floor_index: {f}, team_array: {t}, but a struct_data file DID exist there from our previous save, so it has been SUCCESSFULLY deleted.");	
						} else {
							show_debug_message($"scr_save_file: No array containing structs existed in the g.master_struct_ar at world_index: {w}, floor_index: {f}, team_array: {t}, but a struct_data file DID exist there from our previous save, but we FAILED to delete it.");		
						}
					}
				}
				
				var team_json_ar = [];
				
				// Iterate through team_array -
				for(var i = 0; i < array_length(team_ar); i++) {
					var json_struct_str = json_stringify(global.master_struct_ar[w][f][t][i]);
					array_push(team_json_ar, json_struct_str);
				}
			
				// ONLY create directories and files if we have data
				if (array_length(team_json_ar) > 0) {
				
					// Create directory structure NOW (only when we have data)
					var floor_dir = save_game_name_str + "/" + string(w) + "/" + string(f) + "/" + string(t);
					directory_create(floor_dir);
				
					// Create file
					var filename_str = floor_dir + "/struct_data";
					var file = file_text_open_write(filename_str);

					// Throw error:
					if (file == -1) {
						show_error("file_text_open_write(filename) returned -1. filename = " + string(filename_str), true);	
					}

					file_text_write_string(file, json_stringify(team_json_ar)); // Convert array to JSON

					if (file_text_close(file) == false) {
						show_error("file_text_close(file) returned false. file == " + string(file), true);
					}
				
					show_debug_message("scr_save_file: saved struct data for floor " + string(w) + "-" + string(f) + " to " + string(filename_str));
				}
				
				//We need to DELETE the corresponding struct_data.sav from the external file, if it exists; this should no longer ever be the case now that we're wiping data first, but just as a failsafe we'll still check:
				else if array_length(team_json_ar) <= 0 {
					
					var file_path_str = working_directory+save_game_name_str+"/"+string(w)+"/"+string(f)+"/"+string(t)+"/struct_data";
					
					if file_exists(file_path_str){
							
						if file_delete(file_path_str) {
							show_debug_message($"scr_save_file: An array with a length of 0 containing no structs existed in the g.master_struct_ar at world_index: {w}, floor_index: {f}, team_array: {t}, but a struct_data file DID exist there from our previous save, so it has been SUCCESSFULLY deleted.");	
						} else {
							show_debug_message($"scr_save_file: An array with a length of 0 containing no structs existed in the g.master_struct_ar at world_index: {w}, floor_index: {f}, team_array: {t}, but a struct_data file DID exist there from our previous save, but we FAILED to delete it.");		
						}
					}
				}
			}
		}
	}
	
	#endregion
	
	#region Iterate through master_level_ar:
	
	for (var w = 0; w < array_length(global.master_level_ar); w++) { 
	    
		if !is_array(global.master_level_ar[w]) continue; // Skip if not array
		
		// Iterate through levels
		for(var f = 0; f < array_length(global.master_level_ar[w]); f++) { 
        
			if !is_array(global.master_level_ar[w][f]) continue; // Skip if not array
			
			if !ds_exists(global.master_level_ar[w][f][GRID_TERRAIN],ds_type_grid) continue; //Skip if there are no grids here
				
			// Collect all grid data for this floor into a struct:
			var level_data_struct = {
		        terrain_grid: ds_grid_write(global.master_level_ar[w][f][GRID_TERRAIN]),
		        //We don't bother to pass through the inst_grid here, as it will be recreated using our g.master_struct_ar instead.
				//We do this because if we were to use json_parse() on the struct ids within our inst_grid, we would end up with another set of instantiated structs,
				//in addition to the ones that are instantiated in the g.master_struct_ar
				los_grid: ds_grid_write(global.master_level_ar[w][f][GRID_LOS])    
			};

			// Create directory structure NOW (only when we have data)
			var floor_dir = save_game_name_str + "/" + string(w) + "/" + string(f);
			directory_create(floor_dir);
				
			// Create file
			var filename_str = floor_dir + "/grid_data";
			var file = file_text_open_write(filename_str);

			// Throw error:
			if (file == -1) {
				show_error("file_text_open_write(filename) returned -1. filename = " + string(filename_str), true);	
			}

			file_text_write_string(file, json_stringify(level_data_struct)); // Convert grid strings into JSON string

			if (file_text_close(file) == false) {
				show_error("file_text_close(file) returned false. file == " + string(file), true);
			}
				
			show_debug_message("scr_save_file: saved grid data for floor " + string(w) + "-" + string(f) + " to " + string(filename_str));
		}
	}
	
	#endregion
}