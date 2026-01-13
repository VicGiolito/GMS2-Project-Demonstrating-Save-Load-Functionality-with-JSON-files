
/* De-references and therefore destroys structs within the world_index, floor_index
location.

As pc characters can only live in one dungeon at a time, whenever we move to a new dungeon, it
just makes sense to use this on the previous dungeon

--Edit 11-5: Needs to be adjusted to delete and json_stringify() structs, rather than wiping clean the
array indices. We still need to keep a record of structs in other dungeons after we leave them, after all.

*/

function scr_unload_level_structs(world_index, floor_index) {
    
    if (global.master_struct_ar[world_index][floor_index] == undefined) {
        return false;  // Already unloaded
    }
    
    // Clear the inst_grid
    if (is_array(global.master_level_ar[world_index][floor_index])) {
        ds_grid_clear(global.master_level_ar[world_index][floor_index][GRID_INST], INST_FREE_CELL);
    }
	
	if(!is_undefined(global.master_struct_ar[world_index][floor_index]))
	{
		for(var i = 0; i < array_length(global.master_struct_ar[world_index][floor_index]); i++) {
			
			if is_array(global.master_struct_ar[world_index][floor_index][i]) {
				for(var yy = 0; yy < array_length(global.master_struct_ar[world_index][floor_index][i]); yy++) {
					
					var struct_id = global.master_struct_ar[world_index][floor_index][i][yy];
					
					if (is_struct(struct_id)) {
					
						var struct_str = json_stringify(struct_id);
					
						global.master_struct_ar[world_index][floor_index][i][yy] = struct_str; //Save its json string here instead. Removing the original reference of the struct here will delete the instance of it with the GM garbage collector.
					}
				}
			}
		}
	}
    
    show_debug_message("Unloaded structs for world " + string(world_index) + ", floor " + string(floor_index));

	return true;
}