
//instance_of_struct: must be the instanceof(struct_id) of the struct

/* returns the struct_id of the struct with the matching struct_enum (struct_type_enum), if successful

if unsuccessful, returns false
*/

function scr_return_struct_id(grid_x,grid_y,struct_type_enum,floor_int,dungeon_int){
	
	var struct_ar = global.master_level_ar[dungeon_int][floor_int][GRID_INST][# grid_x,grid_y];
	
	var ar_len = array_length(struct_ar), struct_id;
	
	for(var i = 0; i < ar_len; i++) {
		
		struct_id = struct_ar[i]; //struct id Not in use
		
		if struct_type_enum == struct_type.any {
			return struct_id;	
		}
		
		if struct_id.struct_enum == struct_type_enum {
			return global.master_level_ar[dungeon_int][floor_int][GRID_INST][# grid_x,grid_y][i]; //aka: struct_id
		}
	}
	
	return false;
}