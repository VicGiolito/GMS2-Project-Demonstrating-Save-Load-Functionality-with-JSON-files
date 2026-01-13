/// @description Detroy DS:

//Go through our master array, deleting grids:

scr_destroy_master_level_ar_grids();

global.master_level_ar = -1;

scr_destroy_all_structs();

global.master_struct_ar = -1;

if ds_exists(global.terrain_grid,ds_type_grid) {
	ds_grid_destroy(global.terrain_grid);
	global.terrain_grid = -1;
}

if ds_exists(global.inst_grid,ds_type_grid) {
	ds_grid_destroy(global.inst_grid);
	global.inst_grid = -1;
}

if ds_exists(global.visited_grid,ds_type_grid) {
	ds_grid_destroy(global.visited_grid);
	global.visited_grid = -1;
}

if ds_exists(global.los_grid,ds_type_grid) {
	ds_grid_destroy(global.los_grid);
	global.los_grid = -1;
}
if ds_exists(global.steps_grid,ds_type_grid) {
	ds_grid_destroy(global.steps_grid);
	global.steps_grid = -1;
}

if ds_exists(global.frontier_queue,ds_type_priority) {
	ds_priority_destroy(global.frontier_queue);
	global.frontier_queue = -1;
}










