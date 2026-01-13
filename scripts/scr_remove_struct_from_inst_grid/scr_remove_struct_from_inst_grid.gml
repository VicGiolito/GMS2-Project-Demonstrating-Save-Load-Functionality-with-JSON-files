
/* Returns true if successful

returns false if the struct_id_to_remove could not be found, or if there was no array at the specified
coordinates.

*/

function scr_remove_struct_from_inst_grid(struct_id_to_remove,grid_x,grid_y,floor_ind_to_remove_from,dungeon_int, called_from_str = "Called from string not defined"){
	
	var ar_to_check = global.master_level_ar[dungeon_int][floor_ind_to_remove_from][GRID_INST][# grid_x,grid_y];
	
	if is_array(ar_to_check) {
	
		var ar_len = array_length(ar_to_check), struct_id;
	
		for(var i = 0; i < ar_len; i++) {
			
			struct_id = ar_to_check[i];
			
			if struct_id == struct_id_to_remove {
				array_delete(global.master_level_ar[dungeon_int][floor_ind_to_remove_from][GRID_INST][# grid_x,grid_y],i,1);
				return true;
			}
		}
	}
	
	var struct_name_str = scr_return_struct_name(struct_id_to_remove);
	
	show_debug_message($"scr_remove_struct_from_inst_grid: return true condition never executed for struct with name of {struct_name_str}, this script was called from: {called_from_str}");
	
	return false;
}