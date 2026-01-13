/* 

--Should always be called after every call of scr_update_los.

--Should ALSO be called by an enemy after every time they move into a new cell.

--If this is being called by an enemy, then check_building_visibility_boolean should == FALSE;
currently is only being used for pcs; not applicable for enemies.

-- Turns BUILDING visibility on or off if they're standing on a VISIBILE cell,
same with traps if they also have the revealed_trap_boolean == true OR the trap 
belongs to the pc team.

--Currently only used for buildings

*/

function scr_update_visibility(floor_int, dungeon_int, called_from_str = "undefined", check_building_visibility_boolean = true){
	
	show_debug_message("Entering scr_update_visibility now, this script was called from: "+called_from_str);
	
	/*
	
	var enemy_team_ar_len = array_length(o_controller.enemy_team_ar), enemy_struct_id;
	
	if enemy_team_ar_len > 0 {
		for(var i = 0; i < enemy_team_ar_len; i++) {
			
			enemy_struct_id = o_controller.enemy_team_ar[i];
			
			if is_struct(enemy_struct_id) {
				
				//We only adjust enemy visibility for enemies on the specified floor:
				if enemy_struct_id.cur_floor_level == floor_int {
					
					if global.master_level_ar[floor_int][GRID_LOS][# enemy_struct_id.char_grid_x, enemy_struct_id.char_grid_y] == LOS_VISIBLE {
						enemy_struct_id.visible_boolean = true;	
					}
					else {
						enemy_struct_id.visible_boolean = false;	
					}
				}
			}
		}
	}
	*/
	
	//Enemies do not need to check for buildings or loot drops, or anything like that:
	if check_building_visibility_boolean {
		
		var building_ar, ar_count = 0, repeat_count = 3, building_ar_len, building_struct_id;
		
		repeat(repeat_count) {
			//Define building_ar:
			if ar_count == 0 building_ar = global.master_struct_ar[dungeon_int][floor_int][AR_BUILDING_PC]; // o_controller.pc_building_team_ar;
			else if ar_count == 1 building_ar = global.master_struct_ar[dungeon_int][floor_int][AR_BUILDING_ENEMY]; //o_controller.enemy_building_team_ar;
			else if ar_count == 2 building_ar = global.master_struct_ar[dungeon_int][floor_int][AR_BUILDING_NEUTRAL]; //o_controller.neutral_building_team_ar;
			
			building_ar_len = array_length(building_ar);
			
			if building_ar_len > 0 {
				for(var i = 0; i < building_ar_len; i++) {
					
					building_struct_id = building_ar[i];
					
					if is_struct(building_struct_id) {
						
						//We only adjust building visibility for buildings on the specified floor:
						if building_struct_id.cur_floor_level == floor_int {
						
							var building_type_enum = building_struct_id.building_ar[building_stats.type];
						
							//Only reveal traps if they've already been revealed or if they're part of the pc_team:
							if building_type_enum >= building_type.trap_pit && building_type_enum <= building_type.trap_piranha_pit {
							
								//Only reveal any trap if its on a visible cell:
								if global.master_level_ar[dungeon_int][floor_int][GRID_LOS][# building_struct_id.building_grid_x, building_struct_id.building_grid_y ] == LOS_VISIBLE {
								
									//If it's on a visible cell, check to see if it's part of the pc team OR if it's been revealed already:
									if building_struct_id.revealed_trap_boolean == true || building_struct_id.building_ar[building_stats.team_enum] == char_team.pc {
										building_struct_id.visible_boolean = true;	
									}
									else building_struct_id.visible_boolean = false;
								}
								//If it's not a visible cell, make it invisible_boolean
								else building_struct_id.visible_boolean = false;	
							}
							//If it's any other building, just check to see if it's on a visible cell:
							else {
							
								if global.master_level_ar[dungeon_int][floor_int][GRID_LOS][# building_struct_id.building_grid_x, building_struct_id.building_grid_y ] == LOS_VISIBLE {
									building_struct_id.visible_boolean = true;	
								
								}
								else {
									building_struct_id.visible_boolean = false;	
								}	
							}
						}
					}
				}
			}
			ar_count++;
		} //End of repeat loop

	} //End of if check_building_visibility_boolean == true
}