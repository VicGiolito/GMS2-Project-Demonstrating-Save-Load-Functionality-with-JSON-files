
/*
	the global vars cur_maze_type, max_floors_on_level, map_w, and map_h all must be defined first for 
this to work correctly

	This defines g.*_grid global grid variables, setup terrain and LOS tilemaps, update LOS, center cam, change game_state:
	
	Important!: g.cur_dungeon_ind and g.cur_floor_ind must be properly defined for this script to work as intended.
*/

function scr_start_game(initial_dungeon_ind,initial_floor_ind){
	
	//Assign terrain_grid, inst_grid, and los_grid to first floor using our g.cur_dungeon and g.cur_floor_ind:
	global.terrain_grid = global.master_level_ar[initial_dungeon_ind][initial_floor_ind][GRID_TERRAIN];
	global.inst_grid = global.master_level_ar[initial_dungeon_ind][initial_floor_ind][GRID_INST];
	global.los_grid = global.master_level_ar[initial_dungeon_ind][initial_floor_ind][GRID_LOS];

	//Clear/define our terrain tilemap:
	tilemap_clear(global.terrain_tile_id,terrain_type.unexplored); 
	scr_define_tilemap_from_grid(global.terrain_grid,global.terrain_tile_id,"scr_start_new_game: defining the terrain tilemap for the first time.");
	
	#region Clear/define our los tilemap - note: this has to be done after we spawn our pcs:

	tilemap_clear(global.fow_tile_id,LOS_SHROUD);
	scr_reset_fow(initial_floor_ind,initial_dungeon_ind);
	scr_reset_building_and_loot_drop_visibility(initial_dungeon_ind,initial_floor_ind,"scr_start_game");
	scr_update_los(initial_dungeon_ind, initial_floor_ind, "scr_start_new_game: updating los for the first time.");
	//scr_update_visibility();
	scr_define_tilemap_from_grid(global.los_grid, global.fow_tile_id,"scr_start_new_game: defining fow tile map for the first time.");

	#endregion
	
	#region Center our cam in the middle of the grid:
	
	var mid_map_x = global.grid_offset_x+(global.grid_w*global.cell_size) / 2;
	var mid_map_y = global.grid_offset_y+(global.grid_h*global.cell_size) / 2;

	scr_center_cam(false,-1,mid_map_x-camera_get_view_width(global.map_cam) / 2,
	mid_map_y-camera_get_view_height(global.map_cam) / 2,global.map_cam,"o_con Create event: end of create event: center cam in middle of map.");
	
	#endregion
	
	//Game is ready to begin:
	global.prev_game_state = game_state.main; //This will take us to the main_game after game_state.save_game is finished executing.
	global.cur_game_state = game_state.save_game;
	save_game_called_from_str = "scr_start_game: generated maze, starting new game, saving for the first time.";
}