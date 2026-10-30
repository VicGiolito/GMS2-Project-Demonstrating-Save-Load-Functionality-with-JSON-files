
/* 

Returns true if successful

returns false if the struct_id_to_remove could not be found, or if there was no array at the specified
coordinates.

*/

function scr_remove_struct_from_inst_grid(struct_id_to_remove,grid_x,grid_y,floor_ind_to_remove_from,dungeon_int, called_from_str = "Called from string not defined"){
	
	d($"Entering scr_remove_struct_from_inst_grid: it was called from: {called_from_str}, for struct_id_to_remove: {struct_id_to_remove}, at grid_x: {grid_x}, {grid_y}.");
	
	var inst_grid = global.master_level_ar[dungeon_int][floor_ind_to_remove_from][GRID_INST];
	
	var ar_to_check = inst_grid[# grid_x,grid_y];
	
	if is_array(ar_to_check) {
	
		var ar_len = array_length(ar_to_check), struct_id;
	
		for(var i = 0; i < ar_len; i++) {
			
			struct_id = ar_to_check[i];
			
			if struct_id == struct_id_to_remove {
				array_delete(ar_to_check,i,1);
				
				//If, after deleting this index, the array is empty, then delete it:
				if array_length(ar_to_check) == 0 {
					ar_to_check = 0;	
				}
				
				inst_grid[# grid_x, grid_y] = ar_to_check; //ar_to_check has been modified, we need to update the 
				
				
				return true;
			}
		}
	}
	
	var struct_name_str = scr_return_struct_name(struct_id_to_remove);
	
	show_debug_message($"scr_remove_struct_from_inst_grid: return true condition never executed for struct with name of {struct_name_str}, this script was called from: {called_from_str}");
	
	return false;
}