

function scr_generate_loot(dungeon_index,floor_index){
	
	#region Place enemy chars:
	
	var failsafe_val = 0, failsafe_max = 10000, loot_count = 0, max_loot = irandom_range(4,8);

	do {
		var grid_x = irandom_range(0,global.grid_w-1);
		var grid_y = irandom_range(0,global.grid_h-1);
		
		//Make sure terrain is not a wall:
		if global.master_level_ar[dungeon_index][floor_index][GRID_TERRAIN][# grid_x,grid_y] < terrain_type.wall_dungeon {
			
			//Make sure there's not already another struct here:
			if scr_return_struct_id(grid_x,grid_y,struct_type.any,floor_index,dungeon_index) == false {
			
				loot_count++;
				
				new LootDrop(grid_x,grid_y,floor_index,dungeon_index,true);
			}
		}
	
		failsafe_val++;
	
	} until(loot_count >= max_loot || failsafe_val >= failsafe_max);

	#endregion
}