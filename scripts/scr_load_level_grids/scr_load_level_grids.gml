
/* This script ALSO creates the necessary array structure in our g.master_level_ar for [floor_index] and [grid_index], if they don't
yet exist; the [dungeon_index] level of the g.master_level_ar is already initialized in the create event.

*/

function scr_load_level_grids(filename_str,world_index,floor_index,called_from_str){
	
	show_debug_message("Entering scr_load_level_grids: world_index = "+string(world_index)+", floor_index = "+string(floor_index)+", called from: "+string(called_from_str) );
	
	// Check if save file exists
    if (!directory_exists(filename_str+"/")) {
        show_debug_message("scr_load_level_grids: Directory with path: "+string(filename_str+"/")+" does not exist!");
		show_message("scr_load_level_grids: Directory with path: "+string(filename_str+"/")+" does not exist!");
        return false;
    }
	
	//file directory is:filename/world/level/grid_data
	var grid_dir_path_str = filename_str+"/"+string(world_index)+"/"+string(floor_index)+"/";
	
	if directory_exists(grid_dir_path_str) {
		
		var grid_struct_filename = filename_str+"/"+string(world_index)+"/"+string(floor_index)+"/grid_data";
		
		if file_exists(grid_struct_filename) {
		
			var file = file_text_open_read(grid_struct_filename);
			if file == -1 {
				show_error("scr_load_level_grids: file_text_open_read(filename) for grid_struct_filename returned -1. filename = "+string(grid_struct_filename),true);
			}
			
			var json_string = "";
			while (!file_text_eof(file)) {
			    json_string += file_text_read_string(file);
			    file_text_readln(file);
			}
			if file_text_close(file) == false {
				show_error("scr_load_level_grids: file_text_close(filename) return falsed, could not close file for file: "+string(file),true);	
				return false;
			}
			
			var grid_struct = json_parse(json_string);
		
			//Make sure the structure of g.master_level_ar can accomodate these grids:
			if !is_array(global.master_level_ar[world_index]) {
				global.master_level_ar[world_index] = [];	
			}
			// Check if the array is large enough to hold floor_index
			if array_length(global.master_level_ar[world_index]) <= floor_index {
			    // Resize array to accommodate this floor_index
			    array_resize(global.master_level_ar[world_index], floor_index + 1);
			}
			if !is_array(global.master_level_ar[world_index][floor_index]) {
				global.master_level_ar[world_index][floor_index] = [];
			}
            
		    // Create and read terrain grid
		    var terrain_grid = ds_grid_create(1, 1);
		    ds_grid_read(terrain_grid, grid_struct.terrain_grid);
		    global.master_level_ar[world_index][floor_index][GRID_TERRAIN] = terrain_grid;
				
			// Create and read los grid
		    var los_grid = ds_grid_create(1, 1);
		    ds_grid_read(los_grid, grid_struct.los_grid);
		    global.master_level_ar[world_index][floor_index][GRID_LOS] = los_grid;
        
			//Create blank inst grid - it will be filled with struct references after scr_load_level_structs() is run:
			var inst_grid = ds_grid_create(ds_grid_width(terrain_grid),ds_grid_height(terrain_grid) );
			ds_grid_clear(inst_grid,INST_FREE_CELL);
			global.master_level_ar[world_index][floor_index][GRID_INST] = inst_grid;
		}
		else {
			show_debug_message("scr_load_level_grids: no grid_data file existed at file path: "+string(grid_struct_filename) );
			return false;	
		}
	}
	else {
		show_debug_message("scr_load_level_grids: no directory existed at file path: "+string(grid_dir_path_str) );
		return false;
	}
	
	show_debug_message("scr_load_level_grids: loaded grids for world " + string(world_index) + ", floor " + string(floor_index)+".");
    
	return true;
}