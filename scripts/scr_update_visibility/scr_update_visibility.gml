/* 

--Should always be called after every call of scr_update_los.

-- Turns STRUCT visibility on or off if they're standing on a VISIBILE cell (excluding PCs and PC_BUILDINGS 
(these are always visible) );

--Logic works a bit differently with buildings (traps specifically):
we only reveal them if they belong to a pc or if they've been revealed already

--Should only be called ONCE whenever appropriate, after an instance moves, after we change floors, etc.;
this script already iterates through all applicable enemies/neutral npcs/items on the current dungeon and floor,
and checks whether or not they are on a visible cell; the actual visible/fow/unexplored state of the LOS grid is 
defined in scr_update_los

*/

function scr_update_visibility(dungeon_index, floor_index, called_from_str){
	
	show_debug_message("Entering scr_update_visibility now, this script was called from: "+called_from_str);
	
	//Reset our ds_map_revealed_items_on_grid:
	if ds_exists(global.ds_map_revealed_items_on_grid, ds_type_map) {
		ds_map_destroy(global.ds_map_revealed_items_on_grid);
		global.ds_map_revealed_items_on_grid = -1;
	}
	
	global.ds_map_revealed_items_on_grid = ds_map_create();
	ds_map_clear(global.ds_map_revealed_items_on_grid);
	
	if dungeon_index < array_length(global.master_struct_ar) && is_array(global.master_struct_ar[dungeon_index]) {
		
		if floor_index < array_length(global.master_struct_ar[dungeon_index]) && is_array(global.master_struct_ar[dungeon_index][floor_index]) {
			
			//Start with AR_ENEMY go to AR_ITEMS
			for(var team_i = AR_ENEMY; team_i <= AR_ITEMS; team_i++) {
				
				if team_i == AR_BUILDING_PC continue; //PC buildings are always visible if we're on the same floor.
				
				if is_array(global.master_struct_ar[dungeon_index][floor_index][team_i]) {
					
					for(var struct_i = 0; struct_i < array_length(global.master_struct_ar[dungeon_index][floor_index][team_i]); struct_i++) {
				
						var struct_id = global.master_struct_ar[dungeon_index][floor_index][team_i][struct_i];
						
						if is_struct(struct_id) {
				
							//Special logic for trap buildings:
							if team_i == AR_BUILDING_NEUTRAL || team_i == AR_BUILDING_ENEMY {
							
								var building_type_enum = struct_id.building_ar[building_stats.type];
						
								//Trap specific logic: Only reveal traps if they've already been revealed or if they're part of the pc_team:
								if building_type_enum >= building_type.trap_pit && building_type_enum <= building_type.trap_piranha_pit {
								
									//Only reveal any trap if its on a visible cell:
									if global.master_level_ar[dungeon_index][floor_index][GRID_LOS][# struct_id.building_grid_x, struct_id.building_grid_y ] == LOS_VISIBLE {
								
										//If it's on a visible cell, check to see if it's part of the pc team OR if it's been revealed already:
										if struct_id.revealed_trap_boolean == true || struct_id.building_ar[building_stats.team_enum] == char_team.pc {
											struct_id.visible_boolean = true;	
										}
									}
								}
								
								//If it's any other type of building and it's on a visible cell, mark it visible:
								else if global.master_level_ar[dungeon_index][floor_index][GRID_LOS][# struct_id.building_grid_x, struct_id.building_grid_y ] == LOS_VISIBLE {
									struct_id.visible_boolean = true;	
								}
							}
							
							//We only flag items visible if their 'is_in_inv' flag is set to false (this means they exist on the world map),
							//and then we store them in our ds_map
							else if team_i == AR_ITEMS {
								if struct_id.is_in_inv == false {
									if struct_id.item_grid_x >= 0 && struct_id.item_grid_y >= 0 {
										if global.master_level_ar[dungeon_index][floor_index][GRID_LOS][# struct_id.item_grid_x, struct_id.item_grid_y ] == LOS_VISIBLE {
											
											var map_key = struct_id.item_grid_x + struct_id.item_grid_y * global.grid_w;
											
											//Check to see if there's an array at this key position; if there is, add; if there is not, add and create
												//There is no key/value pair in this map:
											if ds_map_find_value(global.ds_map_revealed_items_on_grid, map_key) == undefined {
												ds_map_add(global.ds_map_revealed_items_on_grid, map_key, array_create(1, struct_id) );	
											}
											else {
												array_push(global.ds_map_revealed_items_on_grid[? map_key], struct_id);	
											}
										}
									}
								}
							}
						
							//If it's ANY other team (enemy or neutral char struct):
							else {
								//If it's on a VISIBLE cell, we flag it visible, it's that fucking simple:
								if global.master_level_ar[dungeon_index][floor_index][GRID_LOS][# struct_id.char_grid_x, struct_id.char_grid_y ] == LOS_VISIBLE {
									struct_id.visible_boolean = true;	
								}
							}
						}
					}
				}
			}
		}
	}
}
