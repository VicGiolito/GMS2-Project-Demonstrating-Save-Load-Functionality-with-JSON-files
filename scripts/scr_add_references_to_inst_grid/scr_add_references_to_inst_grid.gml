
/* Currently only used to reference the struct ids of structs within a specific dungeon and floor of the
g.master_struct_ar

This script goes through the master_struct_ar at the parameters specified, then adds the REFERENCES to those
structs to the corresponding inst_grid in the g.master_level_ar with scr_add_struct_to_inst_grid.

//Important to note: This also CLEARS the corresponding instance grid first:

returns an error if the corresponding inst grid could not be found.

*/

function scr_add_references_to_inst_grid(dungeon_ind,floor_ind, called_from_str){
	
	show_debug_message("Entering scr_add_references_to_inst_grid now, dungeon_ind: "+string(dungeon_ind)+
	", floor_ind: "+string(floor_ind)+", this was called from: "+string(called_from_str) );
	
	if(!is_array(global.master_struct_ar[dungeon_ind]) ) {
		if (!is_array(global.master_struct_ar[dungeon_ind][floor_ind]) ) {
			if ds_exists(global.master_struct_ar[dungeon_ind][floor_ind][GRID_INST],ds_type_grid) == false {
				show_error("scr_add_references_to_inst_grid: the instance grid at dungeon_ind: "+string(dungeon_ind)+", floor_ind: "+string(floor_ind)+" does not exist.", true);	
			}
		}
	}
	
	if (is_array(global.master_struct_ar[dungeon_ind])) {
		if is_array(global.master_struct_ar[dungeon_ind][floor_ind]) {
			var team_ar, struct_id, grid_x, grid_y;
			for(var i = 0; i < array_length(global.master_struct_ar[dungeon_ind][floor_ind]); i++ ) //Iterating through team_arrays AR_PC,AR_ENEMY, etc.
			{
				team_ar = global.master_struct_ar[dungeon_ind][floor_ind][i];
				
				if is_array(team_ar) {
				
					for(var yy = 0; yy < array_length(team_ar); yy++) {
					
						struct_id = team_ar[yy];
					
						if struct_id.struct_enum == struct_type.character {
							grid_x = struct_id.char_grid_x;
							grid_y = struct_id.char_grid_y;	
						} else if struct_id.struct_enum == struct_type.building {
							grid_x = struct_id.building_grid_x;	
							grid_y = struct_id.building_grid_y;
						} 
						else if struct_id.struct_enum == struct_type.loot_drop {
							grid_x = struct_id.building_grid_x;	
							grid_y = struct_id.building_grid_y;
						} 
						//It's not necessary to add items here (or any other structs thus far),
						//as items are always represented on the map as a loot_drop struct, which is considered a building
						else continue;
						
						scr_add_struct_to_inst_grid(struct_id,grid_x,grid_y,floor_ind,dungeon_ind);
					}
				}
			}
		} 
		else show_error("scr_add_references_to_inst_grid: array did not exist at the level of g.master_struct_ar[dungeon_ind][floor_ind]", true);
	}
	else show_error("scr_add_references_to_inst_grid: array did not exist at the level of g.master_struct_ar[dungeon_ind]", true);	
	
	
	return true;
}