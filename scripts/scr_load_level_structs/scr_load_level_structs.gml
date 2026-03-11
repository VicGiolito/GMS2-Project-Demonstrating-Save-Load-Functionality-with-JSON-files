


function scr_load_level_structs(filename_str,world_index, floor_index, called_from_str){
	
	show_debug_message("Entering scr_load_level_structs: world_index = "+string(world_index)+", floor_index = "+string(floor_index)+", called from: "+string(called_from_str) );
	
	 // Check if save file exists
    if (!directory_exists(filename_str)) {
        show_debug_message("scr_load_level_structs: Directory with path: "+string(filename_str+"/")+" does not exist!");
		show_message("scr_load_level_structs: Directory with path: "+string(filename_str+"/")+" does not exist!");
        return false;
    }
	
	for(var i = 0; i < AR_TOTAL_ARS; i++) {
		
		var struct_dir_path_str = filename_str+"/"+string(world_index)+"/"+string(floor_index)+"/"+string(i)+"/";
		
		if directory_exists(struct_dir_path_str) {
			
			var level_struct_filename = filename_str+"/"+string(world_index)+"/"+string(floor_index)+"/"+string(i)+"/struct_data";
			
			if file_exists(level_struct_filename) {
				
				var file = file_text_open_read(level_struct_filename);
				if file == -1 {
					show_error("scr_load_level_structs: file_text_open_read(filename) for level_struct_filename returned -1. filename = "+string(level_struct_filename),true);
				}
			
				var json_string = "";
			    while (!file_text_eof(file)) {
			        json_string += file_text_read_string(file);
			        file_text_readln(file);
			    }
			    if file_text_close(file) == false {
					show_error("scr_load_level_structs: file_text_close(filename) return falsed, could not close file for file: "+string(file),true);	
					return false;
				}
			
				// From claude ai: Parse the outer array (gets you an array of JSON strings)
			    var json_struct_string_array = json_parse(json_string);
    
			    //Create a temp array to hold the actual character structs
			    var character_struct_array = [];
    
			    //Iterate and parse each character JSON string
			    for (var c_i = 0; c_i < array_length(json_struct_string_array); c_i++) {
			        var char_json_str = json_struct_string_array[c_i];
        
			        // Parse the individual character struct - this instantiates the struct
			        var struct = json_parse(char_json_str);
        
			        // Add to our array
			        array_push(character_struct_array, struct);
					
					if struct.struct_enum == struct_type.character {
						show_debug_message($"Loaded Character struct: {struct.char_stats_ar[char_stats.name]}");
					} else if struct.struct_enum == struct_type.building {
						show_debug_message($"Loaded Building struct with building_type_enum: {struct.building_ar[building_stats.type]}");
					} else if struct.struct_enum == struct_type.item {
						show_debug_message($"Loaded Item struct with item_name: {struct.item_name}");	
					}
					else if struct.struct_enum == struct_type.loot_drop {
						show_debug_message($"Loaded loot_drop struct with loot_ar: {struct.loot_ar}");	
					}
					
					//Add this struct to our corresponding global team array:
					var struct_global_team_ar = scr_return_struct_global_team_ar(struct);
					array_push(struct_global_team_ar,struct);
			    }
			
				//Now add temp array to corresponding g.master_struct_ar, make sure structure
				//of g.master_struct_ar exists first:
				if !is_array(global.master_struct_ar) {
					global.master_struct_ar = [];	
				}
				// Check if the array is large enough to hold world_index
				if array_length(global.master_struct_ar) <= world_index {
				    // Resize array to accommodate this floor_index
				    array_resize(global.master_struct_ar, world_index + 1);
				}
				if !is_array(global.master_struct_ar[world_index]) {
					global.master_struct_ar[world_index] = [];	
				}
				// Check if the array is large enough to hold floor_index
				if array_length(global.master_struct_ar[world_index]) <= floor_index {
				    // Resize array to accommodate this floor_index
				    array_resize(global.master_struct_ar[world_index], floor_index + 1);
				}
				if !is_array(global.master_struct_ar[world_index][floor_index]) {
					global.master_struct_ar[world_index][floor_index] = [];
				}
			
				global.master_struct_ar[world_index][floor_index][i] = character_struct_array;
			}
			else {
				show_debug_message("scr_load_level_structs: no struct_data file existed at file path: "+string(level_struct_filename)+" likely because no structs of that type exist on this level. We'll just create an empty array at this location instead." );
				global.master_struct_ar[world_index][floor_index][i] = [];
				continue;	
			}
		}
		else {
			show_debug_message("scr_load_level_structs: no directory existed at file path: "+string(struct_dir_path_str)+" likely because no structs of that type exist on this level. We'll just create an empty array at this location instead." );
			global.master_struct_ar[world_index][floor_index][i] = [];
			continue;	
		}
	}
	
	show_debug_message("Instantiated structs for world " + string(world_index) + ", floor " + string(floor_index)+". They have been added to the appropriate location in the g.master_struct_ar.");
    
    // Now populate the inst_grid with references; this is necessary because structs instantiated
	//with json_parse() do NOT call their constructor event:
	scr_add_references_to_inst_grid(world_index, floor_index, "scr_load_level_structs, just finished instantiating structs and adding to g.master_struct_ar.");
}