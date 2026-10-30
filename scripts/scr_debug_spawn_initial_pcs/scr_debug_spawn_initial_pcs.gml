
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
				
				new Character(pc_class,char_team.pc,grid_x,grid_y,floor_num_int,dungeon_enum_int, true);
				
				//Add corresponding starting equipment for the most recently created pc; we definitely need to script this process:
				var pc_struct_id = global.pc_team_ar[array_length(global.pc_team_ar)-1];
				
				var pc_grid_x = pc_struct_id.char_grid_x, pc_grid_y = pc_struct_id.char_grid_y;
				
				if pc_struct_id.char_stats_ar[char_stats.char_class_enum] == char_class.roderick {
					var item_struct = new Item(item_enum.armor_head_feather_hat, floor_num_int, dungeon_enum_int, pc_grid_x, pc_grid_y, true);
					item_struct.is_in_inv = true;
					pc_struct_id.equip_slot_ar[inv_slot.head] = item_struct;
					
					//Just as a debug feature, add a few items to this starting position, just to test our items_on_ground_ar:
					var ran_quant = choose(35,46);
					repeat(ran_quant) {
						new Item(irandom_range(item_enum.wep_axe_two_hand_rusty, item_enum.misc_gold_necklace), floor_num_int, dungeon_enum_int, pc_grid_x, pc_grid_y, false);	
					}
				}
				else if pc_struct_id.char_stats_ar[char_stats.char_class_enum] == char_class.kurgun {
					var item_struct = new Item(item_enum.armor_body_furs_crude, floor_num_int, dungeon_enum_int, pc_grid_x, pc_grid_y, true);
					item_struct.is_in_inv = true;
					pc_struct_id.equip_slot_ar[inv_slot.body] = item_struct;
				}
				else if pc_struct_id.char_stats_ar[char_stats.char_class_enum] == char_class.acheron {
					var item_struct = new Item(item_enum.armor_body_robes_crude, floor_num_int, dungeon_enum_int, pc_grid_x, pc_grid_y, true);
					item_struct.is_in_inv = true;
					pc_struct_id.equip_slot_ar[inv_slot.body] = item_struct;
				}
				else if pc_struct_id.char_stats_ar[char_stats.char_class_enum] == char_class.thade {
					var item_struct = new Item(item_enum.armor_body_rags_crude, floor_num_int, dungeon_enum_int, pc_grid_x, pc_grid_y, true); 
					item_struct.is_in_inv = true;
					pc_struct_id.equip_slot_ar[inv_slot.body] = item_struct;
				}
				else if pc_struct_id.char_stats_ar[char_stats.char_class_enum] == char_class.ulric {
					var item_struct = new Item(item_enum.armor_body_rags_crude, floor_num_int, dungeon_enum_int, pc_grid_x, pc_grid_y, true);
					item_struct.is_in_inv = true;
					pc_struct_id.equip_slot_ar[inv_slot.body] = item_struct;
				}
				else if pc_struct_id.char_stats_ar[char_stats.char_class_enum] == char_class.neleera {
					var item_struct = new Item(item_enum.armor_body_leather_vest, floor_num_int, dungeon_enum_int, pc_grid_x, pc_grid_y, true);
					item_struct.is_in_inv = true;
					pc_struct_id.equip_slot_ar[inv_slot.body] = item_struct;
				}
				else if pc_struct_id.char_stats_ar[char_stats.char_class_enum] == char_class.zool {
					var item_struct = new Item(item_enum.armor_body_robes_crude, floor_num_int, dungeon_enum_int, pc_grid_x, pc_grid_y, true);
					item_struct.is_in_inv = true;
					pc_struct_id.equip_slot_ar[inv_slot.body] = item_struct;
				}
				
				//Increment class:
				pc_class++;
				
				//Choose new random floor:
				floor_num_int = irandom_range(0,array_length(global.master_level_ar[dungeon_enum_int])-1);
			}
		}
	
		failsafe_val++;
	
	} until(pc_count >= max_pcs || failsafe_val >= failsafe_max);

	#endregion
	
}