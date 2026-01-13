/*
return_up_portal_boolean: if true, returns up portals only; if false, returns down portals only

Checks the building arrays within our g.master_struct_ar at the corresponding location

Only returns the FIRST found up or down portal within the team arrays; so would return a up portal in the AR_BUILDING_PC[0] position first.
*/

function scr_return_portal_on_floor(return_up_portal_boolean,dungeon_index,floor_index ){
	
	show_debug_message($"Entering scr_return_portal_on_floor: return_up_portal_boolean == {return_up_portal_boolean}, dungeon_index == {dungeon_index}, floor_index == {floor_index}");
	
	if is_array(global.master_struct_ar) {
		if dungeon_index < array_length(global.master_struct_ar) && is_array(global.master_struct_ar[dungeon_index]) {
			if floor_index < array_length(global.master_struct_ar[dungeon_index]) && is_array(global.master_struct_ar[dungeon_index][floor_index]) {
				
				var building_team_ar, building_struct_id;
				
				for(var team_i = AR_BUILDING_PC; team_i <= AR_BUILDING_NEUTRAL; team_i++) {
					
					building_team_ar = global.master_struct_ar[dungeon_index][floor_index][team_i];
					
					if is_array(building_team_ar) && array_length(building_team_ar) > 0 {
						
						var building_ar_len = array_length(building_team_ar);
						
						for(var building_i = 0; building_i < building_ar_len; building_i++) {
							
							building_struct_id = building_team_ar[building_i];
							
							if is_struct(building_struct_id) {
								if return_up_portal_boolean && building_struct_id.building_ar[building_stats.type] == building_type.portal_world_up {
									show_debug_message($"scr_return_portal_on_floor: successfully found matching portal type and it has building_grid_x: {building_struct_id.building_grid_x}, building_grid_y: {building_struct_id.building_grid_y}. Returning building struct id.");
								
									return building_struct_id;
								}
								else if !return_up_portal_boolean && building_struct_id.building_ar[building_stats.type] == building_type.portal_world_down {
									show_debug_message($"scr_return_portal_on_floor: successfully found matching portal type and it has building_grid_x: {building_struct_id.building_grid_x}, building_grid_y: {building_struct_id.building_grid_y}. Returning building struct id.");
									
									return building_struct_id;	
								}
							}
						}
					}
				}
			}
		}
	}
	
	show_debug_message($"scr_return_portal_on_floor: could not find matching portal in any building team arrays in dungeon_index: {dungeon_index}, floor_index: {floor_index} ");

	return false;
}