
/*





*/

function scr_return_struct_type_at_cell(grid_x, grid_y, floor_int, dungeon_int){
	
	var temp_ar = []
	
	var struct_ar = global.master_level_ar[dungeon_int][floor_int][GRID_INST][# grid_x,grid_y];
	
	//If there's no array here at all, then there's no struct ids here, return the empty array:
	if is_array(struct_ar) == false return temp_ar;
	
	var struct_id, duplicate_found = false;
	
	for(var i = 0; i < array_length(struct_ar); i++) {
		
		struct_id = struct_ar[i];
		
		duplicate_found = false; //reset
		
		//Search our temp_ar for a duplicate of this value:
		if array_length(temp_ar) > 0 {
			for(var yy = 0; yy < array_length(temp_ar); yy++) {
				if temp_ar[yy] == struct_id.struct_type_enum {
					duplicate_found = true;
					break;
				}
			}
		}
		
		if duplicate_found {
			array_push(temp_ar, struct_id.struct_type_enum);	
		}
	}
	
	return temp_ar;
	
}