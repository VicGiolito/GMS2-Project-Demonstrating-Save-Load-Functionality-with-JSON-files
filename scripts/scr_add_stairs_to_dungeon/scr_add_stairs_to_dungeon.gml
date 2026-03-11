
/* Iterates through floors within the specified dungeon_index, add up/down stairs

	--Must be called AFTER our g.master_struct_ar is setup as well, as the constructor
	event for Buildings adds the Building struct ids to the appropriate array in the
	g.master_struct_ar.

*/

function scr_add_stairs_to_dungeon(dungeon_index,called_from_str){
	
	show_debug_message($"Entering scr_add_stairs_to_dungeon for dungeon_index {dungeon_index}: called_from: {called_from_str}");
	
	//Check to see if the terrain_grid grid exists on the first floor of this dungeon:
	if ds_exists(global.master_level_ar[dungeon_index][0][GRID_TERRAIN],ds_type_grid) {
		
		var dungeon_length = array_length(global.master_level_ar[dungeon_index]);
		var ran_grid_x, ran_grid_y;
	
		randomize();
		
		//We subtract -1 b.c we don't want to be accessing beyond the boundaries of our dungeon array
		for(var f = 0; f < dungeon_length-1; f++) { 
			
			var terrain_grid = global.master_level_ar[dungeon_index][f][GRID_TERRAIN];
			var next_terrain_grid = global.master_level_ar[dungeon_index][f+1][GRID_TERRAIN];
			
			if !ds_exists(terrain_grid,ds_type_grid) {
				show_error($"scr_add_stairs_to_dungeon: the terrain_grid: {terrain_grid} was not a grid; we were tring to access a grid in the g.master_level_ar that wasn't properly setup yet.",true);
			}
			if !ds_exists(next_terrain_grid,ds_type_grid) {
				show_error($"scr_add_stairs_to_dungeon: the next_terrain_grid: {next_terrain_grid} was not a grid; we were tring to access a grid in the g.master_level_ar that wasn't properly setup yet.",true);
			}
			
			
			var grid_w = ds_grid_width(terrain_grid), grid_h = ds_grid_height(terrain_grid);
			var stairs_created = false, failsafe_val = 0;
			var failsafe_max = grid_w*grid_h+1;
		
			do {
				ran_grid_x = irandom_range(0,grid_w-1);
				ran_grid_y = irandom_range(0,grid_h-1);
				
				if terrain_grid[# ran_grid_x,ran_grid_y] < terrain_type.wall_dungeon && 
				next_terrain_grid[# ran_grid_x,ran_grid_y] < terrain_type.wall_dungeon {
					//Create up/down stairs:
					new Building(building_type.stair_up,ran_grid_x,ran_grid_y,char_team.neutral,f+1,true,dungeon_index); //We're placing the up stair on the level beneath b.c we don't need a up stair on the first floor
					if f < dungeon_length-2 new Building(building_type.stair_down,ran_grid_x,ran_grid_y,char_team.neutral,f,true,dungeon_index); //if f < dungeon_length-2 : we don't want to be placing a down stair on the last floor of the dungeon
					stairs_created = true;
					break;
				}
				
				failsafe_val++;
			}
			until(stairs_created == true || failsafe_val >= failsafe_max);
		}
	}
	else {
		show_debug_message("Entering scr_add_stairs_to_dungeon: There was no ds_grid for the location g.master_level_ar["+
		string(dungeon_index)+"][0][GRID_TERRAIN]");
	}
	
	return true;
}