
/* Returns an array id of all applicable items on the corresponding grid cell of the char_struct_id;

global.cur_dungeon_ind and global.cur_floor_ind must be properly defined.

*/

function scr_build_items_on_ground_ar(char_struct_id){
	
	var ar_to_return = [];
	
	if is_struct(char_struct_id) && char_struct_id.struct_enum == struct_type.character {
		
		var grid_x = char_struct_id.char_grid_x, grid_y = char_struct_id.char_grid_y;
		
		var inst_grid = global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_INST];
		
		var inst_ar_at_cell = inst_grid[# grid_x, grid_y];
		
		//d($"scr_build_items_on_ground_ar: inst_ar_at_cell = {inst_ar_at_cell}");
		
		if is_array(inst_ar_at_cell) && array_length(inst_ar_at_cell) > 0 {
			
			var ar_len = array_length(inst_ar_at_cell), struct_id;
			
			for(var yy = 0; yy < ar_len; yy++) {
				
				struct_id = inst_ar_at_cell[yy];
				
				//d($"scr_build_items_on_ground_ar: for inst_ar_at_cell index: {yy}, struct_id = {struct_id}");
				
				if is_struct(struct_id) && struct_id.struct_enum == struct_type.item {
					array_push(ar_to_return, struct_id);	
				}
			}
		}
	}
	
	return ar_to_return;
}