/* 

--Should always be called after every call of scr_update_los.

-- Turns STRUCT visibility on or off if they're standing on a VISIBILE cell (excluding PCs and PC_BUILDINGS 
(these are always visible) );

--Logic works a bit differently with buildings (traps specifically):
we only reveal them if they belong to a pc or if they've been revealed already

*/

function scr_update_visibility(dungeon_index, floor_index, called_from_str){
	
	show_debug_message("Entering scr_update_visibility now, this script was called from: "+called_from_str);

	if dungeon_index < array_length(global.master_struct_ar) && is_array(global.master_struct_ar[dungeon_index]) {
		
		if floor_index < array_length(global.master_struct_ar[dungeon_index]) && is_array(global.master_struct_ar[dungeon_index][floor_index]) {
			
			//Start with AR_ENEMY go to AR_ITEMS
			for(var team_i = AR_ENEMY; team_i <= AR_ITEMS; team_i++) {
				
				if team_i == AR_BUILDING_PC continue; //PC buildings are always visible if we're on the same floor.
				
				if is_array(global.master_struct_ar[dungeon_index][floor_index][team_i]) {
					
					for(var struct_i = 0; struct_i < array_length(global.master_struct_ar[dungeon_index][floor_index][team_i]); struct_i++) {
				
						var struct_id = global.master_struct_ar[dungeon_index][floor_index][team_i][struct_i];
						
						if is_struct(struct_id) {
				
							//Special logic for trap buildings:
							if team_i == AR_BUILDING_NEUTRAL || team_i == AR_BUILDING_ENEMY {
							
								var building_type_enum = struct_id.building_ar[building_stats.type];
						
								//Trap specific logic: Only reveal traps if they've already been revealed or if they're part of the pc_team:
								if building_type_enum >= building_type.trap_pit && building_type_enum <= building_type.trap_piranha_pit {
								
									//Only reveal any trap if its on a visible cell:
									if global.master_level_ar[dungeon_index][floor_index][GRID_LOS][# struct_id.building_grid_x, struct_id.building_grid_y ] == LOS_VISIBLE {
								
										//If it's on a visible cell, check to see if it's part of the pc team OR if it's been revealed already:
										if struct_id.revealed_trap_boolean == true || struct_id.building_ar[building_stats.team_enum] == char_team.pc {
											struct_id.visible_boolean = true;	
										}
									}
								}
								
								//If it's any other type of building and it's on a visible cell, mark it visible:
								else if global.master_level_ar[dungeon_index][floor_index][GRID_LOS][# struct_id.building_grid_x, struct_id.building_grid_y ] == LOS_VISIBLE {
									struct_id.visible_boolean = true;	
								}
							}
						
							//If it's ANY other team (enemy or neutral char struct):
							else {
								//If it's on a VISIBLE cell, we flag it visible, it's that fucking simple:
								if global.master_level_ar[dungeon_index][floor_index][GRID_LOS][# struct_id.char_grid_x, struct_id.char_grid_y ] == LOS_VISIBLE {
									struct_id.visible_boolean = true;	
								}
							}
						}
					}
				}
			}
		}
	}
}
