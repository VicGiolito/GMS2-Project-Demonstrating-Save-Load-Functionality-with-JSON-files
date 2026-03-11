
/*




This script also defines our g.cur_dungeon_ind
*/

function scr_load_file(filename_str, called_from_str){
	
	show_debug_message("Entering scr_load_file: it was called from: "+string(called_from_str) );
	
    // Check if save file exists
    if (directory_exists(filename_str+"/") == false) {
        show_debug_message("scr_load_file: Directory with file_path: "+string(filename_str+"/")+" does not exist!");
		show_message("scr_load_file: Directory with file_path: "+string(filename_str+"/")+" does not exist!");
        return false;
    }
	
	// Read the metadata JSON string:
	var metadata_filename = filename_str+"/meta_data";
	
	if file_exists(metadata_filename) {
	    var file = file_text_open_read(metadata_filename);
	
		if file == -1 {
			show_error("scr_load_file: file_text_open_read(filename) for meta data returned -1. filename = "+string(metadata_filename),true);
		}
	
	    var json_string = "";
	    while (!file_text_eof(file)) {
	        json_string += file_text_read_string(file);
	        file_text_readln(file);
	    }
	    file_text_close(file);
    
	    // Parse JSON string back to struct
	    var meta_data_struct = json_parse(json_string);
    
		//Technically unnecessary, but good practice:
		scr_destroy_all_structs();
	
		// Initialize master_struct_ar with correct structure [world][floor][team]
	    global.master_struct_ar = -1;
		global.master_struct_ar = [];
	
		//Define g.cur_level_ind and g.cur_dungeon_ind from meta data:
		global.cur_dungeon_ind = meta_data_struct.cur_dungeon_ind_;
		//global.loaded_game_floor_ind = meta_data_struct.cur_floor_ind_; //Not currently in use
		var max_floors = meta_data_struct.max_floors_in_dungeon;
		
		//Just load the entire dungeon for now - eventually we'll have enemies that move between floors (such as the boss monster)
		//and those enemies that have already been aggroed by the player. We don't want them to lose agrro or AI just b.c the player
		//saved and then loaded their game.
		
		for(var floor_i = 0; floor_i < max_floors; floor_i++) {
			// Load ONLY this level's grids:
			scr_load_level_grids(filename_str,global.cur_dungeon_ind, floor_i,"scr_load_file")
	
			// Load ONLY this level's structs:
		    scr_load_level_structs(filename_str, global.cur_dungeon_ind, floor_i,"scr_load_file");
		}
		
		return true;
	}
	else {
		show_debug_message("scr_load_file: Meta data file with filename: "+string(metadata_filename)+" does not exist!");
		show_message("scr_load_file: Meta data file with filename: "+string(metadata_filename)+" does not exist!");
        return false;
	}
}