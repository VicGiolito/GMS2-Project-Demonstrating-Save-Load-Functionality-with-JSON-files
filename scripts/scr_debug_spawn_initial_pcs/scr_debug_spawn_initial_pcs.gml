
//Dungeon at global.master_level_ar[dungeon_enum_int] must already be created, obviously

function scr_debug_spawn_initial_pcs(dungeon_enum_int){
	
	#region Place pc chars:
	
	var failsafe_val = 0, failsafe_max = 1000, pc_count = 0, max_pcs = char_class.zool, pc_class = char_class.roderick;
	
	//Choose random first floor:
	var floor_num_int = 0; //Always spawn our first pc on the first floor so I can debug portals
	
	do {
		var grid_x = irandom_range(0,global.grid_w-1);
		var grid_y = irandom_range(0,global.grid_h-1);
		
		//Make sure terrain is not a wall:
		if global.master_level_ar[dungeon_enum_int][floor_num_int][GRID_TERRAIN][# grid_x,grid_y] < terrain_type.wall_dungeon {
			
			//Make sure there's not already a character here:
			if scr_return_struct_id(grid_x,grid_y,struct_type.character,floor_num_int,dungeon_enum_int) == false {
		
				pc_count++;
				
				new Character(pc_class,char_team.pc,grid_x,grid_y,floor_num_int,dungeon_enum_int);
				
				pc_class++;
				
				//Choose new random floor:
				floor_num_int = irandom_range(0,array_length(global.master_level_ar[dungeon_enum_int])-1);
			}
		}
	
		failsafe_val++;
	
	} until(pc_count >= max_pcs || failsafe_val >= failsafe_max);

	#endregion
	
}