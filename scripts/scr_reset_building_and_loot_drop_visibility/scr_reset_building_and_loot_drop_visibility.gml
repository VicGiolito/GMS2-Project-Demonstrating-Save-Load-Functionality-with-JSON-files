/* 

	Iterates through the building_team arrays within the corresponding master_struct_ar
	locations to set visible_boolean = false

*/

function scr_reset_building_and_loot_drop_visibility(dungeon_index,floor_index, called_from_str){
	
	show_debug_message($"Entering scr_reset_building_and_loot_drop_visibility: it was called from: {called_from_str}");
	
	var struct_id;
	if dungeon_index < array_length(global.master_struct_ar) && is_array(global.master_struct_ar[dungeon_index]) {
		if floor_index < array_length(global.master_struct_ar[dungeon_index]) && is_array(global.master_struct_ar[dungeon_index][floor_index]) {
			if array_length(global.master_struct_ar[dungeon_index][floor_index]) >= AR_BUILDING_NEUTRAL {
				for(var team_i = AR_BUILDING_PC; team_i <= AR_BUILDING_NEUTRAL; team_i++) {
					if is_array(global.master_struct_ar[dungeon_index][floor_index][team_i]) {
						for(var struct_i = 0; struct_i < array_length(global.master_struct_ar[dungeon_index][floor_index][team_i]); struct_i++) {
							struct_id = global.master_struct_ar[dungeon_index][floor_index][team_i][struct_i];
							struct_id.visible_boolean = false;
						}
					}
				}
			}
			else {
				show_error($"scr_reset_building_and_loot_drop_visibility: the team array length within g.master_struct_ar[{dungeon_index}][{floor_index}] wasn't even long enough to accomodate the team_macro array position: AR_BUILDING_NEUTRAL, the g.master_struct_ar wasn't setup properly",true)	
			}
		}
	}
	
}