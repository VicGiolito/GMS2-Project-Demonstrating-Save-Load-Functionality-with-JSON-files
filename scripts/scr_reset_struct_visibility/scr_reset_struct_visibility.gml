/* 

	Iterates through the all of the team arrays (ar_enemy, ar_neutral, ar_building_pc, ar_building_enemy, 
	and ar_building_neutral, ar_items) within the corresponding master_struct_ar location
	and sets the visible_boolean attribute in each of those structs to == false

*/

function scr_reset_struct_visibility(dungeon_index, floor_index, called_from_str){
	
	show_debug_message($"Entering scr_reset_building_and_loot_drop_visibility: it was called from: {called_from_str}");
	
	var struct_id;
	if dungeon_index < array_length(global.master_struct_ar) && is_array(global.master_struct_ar[dungeon_index]) {
		
		if floor_index < array_length(global.master_struct_ar[dungeon_index]) && is_array(global.master_struct_ar[dungeon_index][floor_index]) {
			
			//Start with AR_ENEMY go to AR_ITEMS
			for(var team_i = AR_ENEMY; team_i <= AR_ITEMS; team_i++) {
				
				if team_i == AR_BUILDING_PC continue; //We never reset visibility of pc_owned buildings; they are always visible if they're on the current floor.
				
				if is_array(global.master_struct_ar[dungeon_index][floor_index][team_i]) {
					for(var struct_i = 0; struct_i < array_length(global.master_struct_ar[dungeon_index][floor_index][team_i]); struct_i++) {
						struct_id = global.master_struct_ar[dungeon_index][floor_index][team_i][struct_i];
						struct_id.visible_boolean = false;
					}
				}
			}
		}
	}
	
}