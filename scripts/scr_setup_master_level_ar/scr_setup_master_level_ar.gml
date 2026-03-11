
/* Needs to be called every time BEFORE we create a new dungeon.

Initializes the g.master_level_ar at the specified world for the specified amount of levels with our necessary ds_grids:

Is NOT necessary when starting a game using scr_load_file(); scr_load_level_grids() handles that.

*/

function scr_setup_master_level_ar(dungeon_type_enum,total_floors_in_level,base_terrain,called_from_str) {
	
	show_debug_message($"Entering scr_setup_master_level_ar: it was called from: {called_from_str} - dungeon_type_enum == {dungeon_type_enum}, "+
	$"total_floors_in_level == {total_floors_in_level}, base_terrain == {base_terrain}");
	
	//Setup and define grids for master_level_ar:
	for(var i = 0; i < total_floors_in_level; i++) {
		
		global.master_level_ar[dungeon_type_enum][i] = [];
		
		global.master_level_ar[dungeon_type_enum][i][GRID_TERRAIN] = ds_grid_create(global.grid_w,global.grid_h);
		
		ds_grid_clear(global.master_level_ar[dungeon_type_enum][i][GRID_TERRAIN],base_terrain);
		
		global.master_level_ar[dungeon_type_enum][i][GRID_INST] = ds_grid_create(global.grid_w,global.grid_h);
		ds_grid_clear(global.master_level_ar[dungeon_type_enum][i][GRID_INST],INST_FREE_CELL);
		
		global.master_level_ar[dungeon_type_enum][i][GRID_LOS] = ds_grid_create(global.grid_w,global.grid_h);
		ds_grid_clear(global.master_level_ar[dungeon_type_enum][i][GRID_LOS],LOS_SHROUD);
	}
}