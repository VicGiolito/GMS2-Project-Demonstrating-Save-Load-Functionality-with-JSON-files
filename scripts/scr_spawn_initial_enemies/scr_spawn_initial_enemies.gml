
	
//This script does NOT iterate the global.cur_floor_ind

function scr_spawn_initial_enemies(dungeon_enum_int, floor_num_int){
	
	#region Place enemy chars:
	
	var failsafe_val = 0, failsafe_max = 10000, enemy_count = 0, max_enemies = 6, ran_enemy_class;

	do {
		var grid_x = irandom_range(0,global.grid_w-1);
		var grid_y = irandom_range(0,global.grid_h-1);
		
		//Make sure terrain is not a wall:
		if global.master_level_ar[dungeon_enum_int][floor_num_int][GRID_TERRAIN][# grid_x,grid_y] < terrain_type.wall_dungeon {
			
			//Make sure there's not already a character here:
			if scr_return_struct_id(grid_x,grid_y,struct_type.character,floor_num_int,dungeon_enum_int) == false {
			
				ran_enemy_class = choose(char_class.goblin_cretin,char_class.goblin_brute);
				enemy_count++;
				
				new Character(ran_enemy_class,char_team.enemy,grid_x,grid_y,floor_num_int,dungeon_enum_int);
			}
		}
	
		failsafe_val++;
	
	} until(enemy_count >= max_enemies || failsafe_val >= failsafe_max);

	#endregion

}