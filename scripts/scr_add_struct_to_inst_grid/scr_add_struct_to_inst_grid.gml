

function scr_add_struct_to_inst_grid(struct_id_to_add,grid_x,grid_y,floor_ind_to_add_to,dungeon_int){
	
	var ar_at_grid = global.master_level_ar[dungeon_int][floor_ind_to_add_to][GRID_INST][# grid_x,grid_y];
	
	var adding_struct_type = struct_id_to_add.struct_enum;
	
	var struct_name = scr_return_struct_name(struct_id_to_add);
	
	show_debug_message($"Entering scr_add_struct_to_inst_grid now for struct with name of: {struct_name}, its adding_struct_type (struct_enum) == "+string(adding_struct_type)+", grid_x = "+string(grid_x)+
	", grid_y == "+string(grid_y) );
	
	if is_array(ar_at_grid) {
		var ar_len = array_length(ar_at_grid), struct_id, invalid_add = false;
		for(var i = 0; i < ar_len; i++) {
			struct_id = ar_at_grid[i];
			if adding_struct_type == struct_id.struct_enum {
				invalid_add = true;
				show_debug_message($"scr_add_struct_to_inst_grid: there was already another struct at this location with the struct_enum of: {struct_id.struct_enum}; it is the same type as our adding_struct_type struct_enum: {adding_struct_type}; failed to add and returned false.");
				return false;
			}
		}
		//We're good to add:
		if !invalid_add {
			array_push(global.master_level_ar[dungeon_int][floor_ind_to_add_to][GRID_INST][# grid_x,grid_y],struct_id_to_add);
			show_debug_message($"scr_add_struct_to_inst_grid: there was already at least one other struct here, but it had a different struct_enum; successfully added the struct with the name of: {struct_name}.");
			return true;
		}
	}
	
	//There's nothing here, we can simply add:
	else {
		global.master_level_ar[dungeon_int][floor_ind_to_add_to][GRID_INST][# grid_x,grid_y] = [];
		array_push(global.master_level_ar[dungeon_int][floor_ind_to_add_to][GRID_INST][# grid_x,grid_y],struct_id_to_add);
		show_debug_message($"scr_add_struct_to_inst_grid: there was nothing here; successfully added the struct with the name of: {struct_name}.");
		return true;
	}
	
	show_debug_message($"scr_add_struct_to_inst_grid: we made it through our use cases and nothing was added to this grid cell; the struct with the name of: {struct_name} and struct_enum of: {adding_struct_type} failed to add." );
	return false;
}