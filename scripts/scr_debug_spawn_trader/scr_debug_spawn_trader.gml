


//Dungeon at global.master_level_ar[dungeon_enum_int] must already be created, obviously

function scr_debug_spawn_trader(dungeon_enum_int){
	
	#region Place pc chars:
	
	var failsafe_val = 0, failsafe_max = 1000, npc_count = 0, max_neutrals = 50;
	
	//Choose random first floor:
	var floor_num_int = 0; //Always spawn our first pc on the first floor so I can debug easily
	
	do {
		var grid_x = irandom_range(0,global.grid_w-1);
		var grid_y = irandom_range(0,global.grid_h-1);
		
		//Make sure terrain is not a wall:
		if global.master_level_ar[dungeon_enum_int][floor_num_int][GRID_TERRAIN][# grid_x,grid_y] < terrain_type.wall_dungeon {
			
			//Make sure there's not already a character here:
			if scr_return_struct_id(grid_x,grid_y,struct_type.character,floor_num_int,dungeon_enum_int) == false {
		
				npc_count++;
				
				var npc_struct_id = new Character(char_class.npc_trader_generic,char_team.neutral,grid_x,grid_y,floor_num_int,dungeon_enum_int, true);
				
				//Add some random items in the inv_ar: we definitely need to script this process:
				
				var neutral_grid_x = npc_struct_id.char_grid_x, neutral_grid_y = npc_struct_id.char_grid_y;
				
				//Debug: add many items to backpack to test the scroll feature:
					
				repeat(global.max_backpack_slots_per_page+6) {
					//Add ran items:
					var item_struct_in_inv = new Item(irandom_range(item_enum.wep_axe_two_hand_rusty, item_enum.misc_gold_necklace), floor_num_int, dungeon_enum_int, neutral_grid_x, neutral_grid_y, true);
					
					//Add light weight items:
						//var item_struct_in_inv = new Item(item_enum.misc_gold_necklace, floor_num_int, dungeon_enum_int, neutral_grid_x, neutral_grid_y, true);
						
					array_push(npc_struct_id.inv_ar, item_struct_in_inv);
					npc_struct_id.char_stats_ar[char_stats.cur_carrying_capacity] += item_struct_in_inv.weight_val;
				}
			}
		}
	
		failsafe_val++;
	
	} 
	until(npc_count >= max_neutrals || failsafe_val >= failsafe_max);

	#endregion
	
}