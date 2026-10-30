
/* Currently spawns totally random items in totally random locations

The code with the struct constructor itself assigns the struct id to the appropriate grid cell coordinate,
as well as the global.master_item_ar.

*/

function scr_generate_loot(dungeon_index,floor_index){
	
	#region Place items:
	
	var failsafe_val = 0, failsafe_max = 10000, loot_count = 0, max_loot = irandom_range(16, 24);

	do {
		var grid_x = irandom_range(0,global.grid_w-1);
		var grid_y = irandom_range(0,global.grid_h-1);
		
		//Make sure terrain is not a wall:
		if global.master_level_ar[dungeon_index][floor_index][GRID_TERRAIN][# grid_x,grid_y] < terrain_type.wall_dungeon {
			
			//Make sure we're not placing items on top of buildings for now:
			var struct_type_ar = [];
			struct_type_ar = scr_return_struct_type_at_cell(grid_x, grid_y, floor_index, dungeon_index);
			
			var valid_add = true;
			
			//Iterate through, look for struct type enums of the builing struct type:
			if array_length(struct_type_ar) > 0 {
				for(var ii = 0; ii < array_length(struct_type_ar); ii++) {
					if struct_type_ar[ii] == struct_type.building {
						valid_add = false;
						break;
					}
				}
			}
			
			struct_type_ar = -1; //Good practice, though unnecessary
			
			if valid_add {
				
				var ran_stack_quantity = choose(1,5,27,35,27*4);
				
				repeat(ran_stack_quantity) {
					var ran_item_enum = irandom_range(item_enum.wep_axe_two_hand_rusty, item_enum.misc_gold_necklace);
					new Item(ran_item_enum, floor_index, dungeon_index, grid_x, grid_y, false);
				}
				
				loot_count++;
			}
		}
	
		failsafe_val++;
	
	} until(loot_count >= max_loot || failsafe_val >= failsafe_max);

	#endregion
}