
/* Should only be used in conjunction with the global.inst_grid:

instance_of_struct: must be the instanceof(struct_id) of the struct

returns the struct_id of the struct with the matching struct_enum (struct_type_enum), if successful

if unsuccessful, returns false

*/

function scr_return_struct_id(grid_x,grid_y,struct_type_enum,floor_int,dungeon_int){
	
	var struct_ar = global.master_level_ar[dungeon_int][floor_int][GRID_INST][# grid_x,grid_y];
	
	//If there's no array here at all, then there's no struct ids here, return false:
	if is_array(struct_ar) == false return false;
	
	var struct_id;
	
	for(var i = 0; i < array_length(struct_ar); i++) {
		
		struct_id = struct_ar[i];
		
		if struct_type_enum == struct_type.any {
			return struct_id;	
		}
		
		else if struct_id.struct_enum == struct_type_enum {
			return struct_id;
		}
	}
	
	return false;
}