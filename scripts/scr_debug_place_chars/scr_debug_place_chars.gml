
/* Note: This script does NOT iterate the global.cur_floor_ind
	
	Also note: 
*/

function scr_debug_place_chars(floor_num_int,dungeon_enum_int) {
	
	#region Placeholder: place chars:
	
	var failsafe_val = 0, failsafe_max = 10000, char_count = 0, max_chars = 3, max_enemies = 8;
	var total_char_count = 0, total_chars = max_chars+max_enemies, char_team_var, ran_class;
	
	
	do {
		var grid_x = irandom_range(0,global.grid_w-1);
		var grid_y = irandom_range(0,global.grid_h-1);
		
		//Make sure terrain is not a wall:
		if global.master_level_ar[dungeon_enum_int][floor_num_int][GRID_TERRAIN][# grid_x,grid_y] < terrain_type.wall_dungeon {
			
			//Make sure there's not already a character here:
			if scr_return_struct_id(grid_x,grid_y,struct_type.character,floor_num_int,dungeon_enum_int) == false {
			
				if char_count < max_chars {
					char_team_var = char_team.pc;
					ran_class = irandom_range(0,char_class.zool);	
					char_count++;
					total_char_count++;
				} else {
					char_team_var = char_team.enemy;
					ran_class = choose(char_class.goblin_cretin,char_class.goblin_brute);
					total_char_count++;
				}
		
				new Character(ran_class,char_team_var,grid_x,grid_y,floor_num_int,dungeon_enum_int);
			}
		}
	
		failsafe_val++;
	
	} until(total_char_count >= total_chars || failsafe_val >= failsafe_max);

	#endregion
}