/// @description o_controller - CREATE EVENT

game_set_speed(60, gamespeed_fps);

randomize();

//global.version_num = "v002"; //We could incoporate this into save filenames at some point to ensure we're always testing the correct version.

global.cur_game_state = game_state.start_menu;

global.default_fnt = fnt_std_12;

global.intended_game_spd = game_get_speed(gamespeed_fps);

draw_set_font(global.default_fnt);

global.wait = true;

save_game_called_from_str = "Not defined"; //debug

global.forbidden_save_file_name_chars = [ "\\","/",":","*","?","\"","<",">","|" ];

global.cur_char = -1;

global.grid_w = 0; //maximum possible grid size == 152x152 (assuming cell_size == 32, and including a buffer of 128px on both left and right sides)
global.grid_h = 0;

global.cell_size = 32;
global.half_c = global.cell_size / 2;

global.grid_offset_x = 128; 
global.grid_offset_y = 128;

//tile layer ids:
global.terrain_tile_id = layer_tilemap_get_id(layer_get_id("tile_terrain"));
global.fow_tile_id = layer_tilemap_get_id(layer_get_id("tile_fow"));

//For pathing algorithms/maze generation, like recursive backtracker
global.visited_grid = ds_grid_create(global.grid_w,global.grid_h); 
ds_grid_clear(global.visited_grid,UNVISITED_CELL);

global.save_file_ar = [];

//This always represents the terrain grid of our CURRENT floor:
global.terrain_grid = -1;
	
//This represents the instance grid of our CURRENT floor:
global.inst_grid = -1;

//This represents the los grid of our CURRENT floor:
global.los_grid = -1;

global.default_los_radius = 7;

global.cur_dungeon_ind = 0;
global.cur_floor_ind = 0;
global.max_floors_on_level = 0;
global.floors_loaded_count = 0;
global.prev_dungeon_ind = global.cur_dungeon_ind; //Used to keep track of previous dungeon when moving into a new dungeon and offloading the entire previous dungeon.

global.level_progress_percent = 0; //For our load screen

global.base_terrain_type = terrain_type.unexplored; //Is assigned deliberately in scr_generate_maze

global.master_level_ar = -1;

global.master_level_ar = []; //Has the following structure g.master_level_ar[cur_dungeon_ind][cur_floor_ind][GRID_X][# cell_x,cell_y];

for(var i = 0; i < dungeon_type.total_dungeon_types; i++) {
	global.master_level_ar[i] = [];
}

global.cur_save_filename_str = "T";

//Team/misc arrays:

//Is defined as a nested array in scr_setup_master_struct_ar() and in scr_load_file(); has the following structure:
//g.master_struct_ar[dungeon_ind][AR_INDEX for PC, enemy, neutral, pc_building,enemy_building,neutral_building][array containing every Character,Building,or Item struct in that dungeon]
global.master_struct_ar = -1; 

global.master_struct_json_str_ar = -1; //Becomes a nested array in scr_load_file(); saves the raw json strings of structs from our external file, waiting to be instantiated.

global.frontier_queue = -1; //Is used as a ds_priority queue

global.steps_grid = -1; //Used as a ds_grid with pathing algorithms

path_start_grid_x = -1;
path_start_grid_y = -1;
path_dest_grid_x = -1;
path_dest_grid_y = -1;

mouse_cur_grid_x = -1;
mouse_cur_grid_y = -1;
mouse_prev_grid_x = -1;
mouse_prev_grid_y = -1;

//These team arrays are NOT used for drawing sprites, updating LOS, etc.; they're only used for easy-reference type purposes.
global.pc_team_ar = [];
global.enemy_team_ar = [];
global.neutral_team_ar = [];

global.pc_building_team_ar = [];
global.enemy_building_team_ar = [];
global.neutral_building_team_ar = [];
global.loot_drop_ar = [];

global.master_item_ar = [];

revealed_enemies_ar = [];

cursor_pos = 0;

scr_define_data();

scr_define_structs();

#region Prompt box vars

prompt_box_w = 0;
prompt_box_h = 0;
prompt_box_origin_x = 0;
prompt_box_origin_y = 0;
prompt_box_original_spr_w = sprite_get_width(asset_get_index("spr_prompt_box"));
prompt_box_original_spr_h = sprite_get_height(asset_get_index("spr_prompt_box"));

max_filename_box_w = string_width("W")*32;
max_filename_box_h = string_height("W")+8;

cursor_origin_x = 0;
cursor_origin_y = 0;

#endregion

#region Camera and views:

global.cur_zoom_val = 1; //This is the zoom value that is used in our camera functions when zooming in or out.
global.zoom_val = 0.25; //This is the value that increments or decreases our cur_zoom_val

global.cam_move_spd = 16;

global.win_w = 1920;
global.win_h = 1200;

scr_setup_cam_views(true,true,global.win_w,global.win_h,0,0,0,0);

#endregion

level_type_str_ar = [ "DEBUG FOREST WORLD - OVERWORLD", "RECURSIVE BACKTRACKER - MINOTAUR MAZE" ];

//vars for cur_char frame:
cur_char_frame = 0;
cur_char_frame_timer = 0;

debug_place_struct = 0;

player_input_str = "";

global.debug_disable_los = false;

show_debug_message("Working Directory: " + working_directory); //Debug

show_debug_message("Game Save ID: " + game_save_id); //Debug

var debug_experiment_grid = ds_grid_create(1,1);

debug_ar = [];

array_push(debug_ar,debug_experiment_grid);

