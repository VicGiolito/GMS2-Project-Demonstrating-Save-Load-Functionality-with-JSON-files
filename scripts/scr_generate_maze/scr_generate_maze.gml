
/*
	Some defaults I've been using thus far: 3 (floors),29w,29h

	scr_setup_master_level_ar should be run before the first time this script is executed.
	
	global.cur_floor_ind should == 0 before the first time this script is executed.
	
	global vars grid_w,grid_h, and g.cur_maze_type should all be defined before the first time
this script is executed.
	
	--the g.visited_grid should be correctly sized before this script is executed.
	
	scr_define_base_terrain_type should be run before this is executed
	
	--Important note: this script does NOT iterate the global.cur_floor_ind !
*/

function scr_generate_maze(dungeon_type_index){
	
	show_debug_message($"Entering scr_generate_maze: dungeon_type_index == {dungeon_type_index}, global.floors_loaded_count == {global.floors_loaded_count}" );
	
	//Redefine and clear our visitedGrid: used for algorithms:
	ds_grid_clear(global.visited_grid,UNVISITED_CELL);
	
	//Some pathing vars for our algorithms:
	maze_pather_x = -1;
	maze_pather_y = -1;
	coord_stack_ar = [];
	dir_ar = [
		[-2,0], //W 0
		[0,-2], //N 1
		[2,0], //E 2
		[0,2] //S 3
	];
	
	#region Recursive Backtracker algorithm - currently used for 'minotaur maze':
	
	if dungeon_type_index == dungeon_type.minotaur_maze {
			
		//Fill corresponding grid with walls:
		ds_grid_clear(global.master_level_ar[dungeon_type_index][global.cur_floor_ind][GRID_TERRAIN],terrain_type.wall_dungeon);
			
		//Define terrain grid:
		global.terrain_grid = global.master_level_ar[dungeon_type_index][global.cur_floor_ind][GRID_TERRAIN];
			
		//Reset coord_stack and visited grid:
		coord_stack_ar = -1;
		coord_stack_ar = [];
		ds_grid_clear(global.visited_grid,UNVISITED_CELL);
		
		//Add first value:
		var ran_grid_x = irandom_range(0,global.grid_w-1);
		var ran_grid_y = irandom_range(0,global.grid_h-1);
		array_push(coord_stack_ar,[ran_grid_x,ran_grid_y]);
		
		var failsafe_val = 0, failsafe_max = 100000;
		do {
			//"pop" our coor_stack_ar: Our current coordinates will always == the bottom of the "stack":
			maze_pather_x = coord_stack_ar[array_length(coord_stack_ar)-1][0];
			maze_pather_y = coord_stack_ar[array_length(coord_stack_ar)-1][1];
			array_delete(coord_stack_ar,array_length(coord_stack_ar)-1,1);
			
			//Define both grids:
			global.terrain_grid[# maze_pather_x,maze_pather_y] = global.base_terrain_type;
			global.visited_grid[# maze_pather_x,maze_pather_y] = VISITED_CELL;
		
			//Choose one among our 4 cardinal directions; if no valid directions, we'll backtrack by deleting the
			//last position in our coord_stack_ar:
			var ran_dir_ar = dir_ar, check_dir_x,check_dir_y;
			var neighbors_list = ds_list_create();
			ds_list_clear(neighbors_list);
		
			for(var i = 0; i < array_length(dir_ar); i++) {
				
				//Assign check coords:
				check_dir_x = ran_dir_ar[i][0];
				check_dir_y = ran_dir_ar[i][1];
				
				//Check within bounds:
				if maze_pather_x+check_dir_x >= 0 && maze_pather_x+check_dir_x < global.grid_w && 
				maze_pather_y+check_dir_y >= 0 && maze_pather_y+check_dir_y < global.grid_h {
				
					if global.visited_grid[# maze_pather_x+check_dir_x,maze_pather_y+check_dir_y] == UNVISITED_CELL {
						ds_list_add(neighbors_list,[maze_pather_x+check_dir_x,maze_pather_y+check_dir_y]);	
					}
				}
			}
		
			if(ds_list_size(neighbors_list) > 0) {
				//Add our current coordinates back to the stack, as this was a cell along a path that
				//can continue, so we'll be backtracking through here again:
				array_push(coord_stack_ar,[maze_pather_x,maze_pather_y]);
			
				//Choose random unvisited neighbor:
				var ran_neighbor_ind = irandom_range(0,ds_list_size(neighbors_list)-1);
			
				var next_x = neighbors_list[| ran_neighbor_ind][0];
				var next_y = neighbors_list[| ran_neighbor_ind][1];
			
				// Carve path to neighbor
				global.terrain_grid[# next_x, next_y] = global.base_terrain_type; // carve destination
				global.visited_grid[# next_x, next_y] = VISITED_CELL;
        
				// Carve the wall between current and neighbor
				var wall_x = maze_pather_x + (next_x - maze_pather_x) / 2;
				var wall_y = maze_pather_y + (next_y - maze_pather_y) / 2;
				global.terrain_grid[# wall_x, wall_y] = global.base_terrain_type;
				global.visited_grid[# wall_x, wall_y] = VISITED_CELL;
        
				// Push neighbor onto stack
				array_push(coord_stack_ar,[next_x,next_y]);
			}
		
			ds_list_clear(neighbors_list); //Reset
			
			failsafe_val++;
		} until(array_length(coord_stack_ar) == 0 || failsafe_val >= failsafe_max);
		
		if(failsafe_val >= failsafe_max) {
			show_debug_message("scr_generate_maze: recursive_backtracker: failsafe_val >= failsafe_max: something went wrong.");
		}
	} //Closed bracket for recursive backtracker type
	
	#endregion
		
	#region Basic debug forest level - currently used for 'overworld':
		
	else if dungeon_type_index == dungeon_type.overworld {
			
		//Fill corresponding grid with grass/fields:
		ds_grid_clear(global.master_level_ar[dungeon_type_index][global.cur_floor_ind][GRID_TERRAIN], global.base_terrain_type);
			
		//Randomly apply forests to the top half of the map:
		var forest_count = 0, total_forests = floor((global.grid_h*global.grid_w)*.25);
			
		var failsafe_val = 0, failsafe_max = 100000, ran_x, ran_y;
		do {
			ran_x = irandom_range(0,global.grid_w-1);
			ran_y = irandom_range(0,global.grid_h div 2);
				
			if global.master_level_ar[dungeon_type_index][global.cur_floor_ind][GRID_TERRAIN][# ran_x,ran_y] == terrain_type.fields {
				global.master_level_ar[dungeon_type_index][global.cur_floor_ind][GRID_TERRAIN][# ran_x,ran_y] = terrain_type.forest;
				forest_count++;
			}
				
			failsafe_val++;
		}
		until(forest_count >= total_forests || failsafe_val >= failsafe_max);
			
		//Randomly apply walls to the lower half of the map:
		var wall_count = 0, total_walls = floor((global.grid_h*global.grid_w)*.1);
			
		var failsafe_val = 0, failsafe_max = 100000, ran_x, ran_y;
		do {
			ran_x = irandom_range(0,global.grid_w-1);
			ran_y = irandom_range(global.grid_h div 2,global.grid_h-1);
				
			if global.master_level_ar[dungeon_type_index][global.cur_floor_ind][GRID_TERRAIN][# ran_x,ran_y] == terrain_type.fields {
				global.master_level_ar[dungeon_type_index][global.cur_floor_ind][GRID_TERRAIN][# ran_x,ran_y] = terrain_type.wall_dungeon;
				wall_count++;
			}
				
			failsafe_val++;
		}
		until(wall_count >= total_walls || failsafe_val >= failsafe_max);
			
	}
		
	#endregion
	
	#region Placeholder: very basic up/down stair creation: 
	
	/* Eventually this will be replaced with more sophisticated algorithm that uses A* to find the longest path
	in the rooom, then creates the next down_stair at that end point; for now, it's just this: 
	
		Only do any of this if array_length(master_level_ar) > 1
	
		If cur_floor_ind != the last floor, find a random, non-wall location on the current floor,
		which ALSO has a non-wall location in the floor beneath it. If found, create our up/down stair.
		
		Only give it 100 attempts to do so, so this will fail now and then. When it does, simply pick a spot,
		transform the g.terrain_grid on that cell and the cell below it to our default value, then create our
		up/down stair.
	*/
	
	//If this is the very first floor:
	/*
	if array_length(global.master_level_ar) > 1 {
		//If this is not our last floor on this level:
		if global.cur_floor_ind != array_length(global.master_level_ar[dungeon_type_index])-1 {
			var stair_grid_x, stair_grid_y, stair_failsafe_val = 0, max_stair_failsafe = 100;
			
			do {
				stair_grid_x = irandom_range(0,global.grid_w-1);
				stair_grid_y = irandom_range(0,global.grid_h-1);
				
				if global.master_level_ar[dungeon_type_index][global.cur_floor_ind][GRID_TERRAIN][# stair_grid_x,stair_grid_y] < terrain_type.wall_dungeon {
					if global.master_level_ar[dungeon_type_index][global.cur_floor_ind+1][GRID_TERRAIN][# stair_grid_x,stair_grid_y] < terrain_type.wall_dungeon {
							
					}
				}
				
				stair_failsafe_val++;
			} 
			until(stair_failsafe_val >= max_stair_failsafe);
		}
	}
	*/
	
	#endregion
	
	//Reset/clear:
	coord_stack_ar = -1;
	dir_ar = -1;
}