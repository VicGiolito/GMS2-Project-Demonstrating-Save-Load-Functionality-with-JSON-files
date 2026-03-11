/// @description o_controller - STEP EVENT

//Maintain fullscreen mode in case it is lost at any point 
//(sometimes we lose window focus at start and then we lose full screen mode):
if window_get_fullscreen() == false {
	window_set_fullscreen(true);	
}

#region Basic debug commands:

if keyboard_check_released(vk_f1) game_end();
if keyboard_check_released(vk_f2) game_restart();

if global.cur_game_state == game_state.main {
	if keyboard_check_released(ord("0")) {
		//switch var:
		if global.debug_disable_los {
			global.debug_disable_los = false;
		}
		else {
			global.debug_disable_los = true;
		
			tilemap_clear(global.fow_tile_id,LOS_VISIBLE);
		}
	}
}

#endregion

#region Logic for game_state == save_game:

if global.cur_game_state == game_state.save_game {
	//If called here from scr_start_game, global.cur_dungeon_ind should == starting_dungeon, cur_floor_ind should == 0, global.prev_game_state = game_state.main
	scr_save_file(global.cur_save_filename_str,global.cur_dungeon_ind,global.cur_floor_ind,save_game_called_from_str);
	
	global.cur_game_state = global.prev_game_state;
}

#endregion

#region Logic for create new game game state

else if global.cur_game_state == game_state.create_new_game {
	
	//Add input to player_input_str
	if !keyboard_check_released(vk_enter) && !keyboard_check_released(vk_backspace) {
		if keyboard_check_released(vk_anykey) && !keyboard_check_released(vk_shift) && !keyboard_check_released(vk_control) 
		&& !keyboard_check_released(vk_alt) { //We need to include checks for control keys so this code doesn't trigger twice when the user releases the shift key, for instance.
			
			//Check for and filter out extraneous control characters, such as lshift hold + backspace press, tabs, escape key, etc.:
			var _code = ord(keyboard_lastchar);
    
		    //Filter out control characters (0-31 and 127)
		    if (_code >= 32 && _code != 127) {
				if scr_check_forbidden_filename_char(keyboard_lastchar) == false {
					player_input_str += string_upper(keyboard_lastchar);
				}
			}
		}
	}
	
	if keyboard_check_released(vk_backspace) {
		player_input_str = string_delete(player_input_str, string_length(player_input_str), 1);
	}
	
	if keyboard_check_released(vk_enter) {
		
		if string_length(player_input_str) > 0 && player_input_str != " " {
		
			//Parse our string again in case any forbidden characters got through:
			player_input_str = scr_parse_str(parse_str_type.new_save_file_name,player_input_str);
			
			var start_game = true;
			
			if scr_check_save_filename(player_input_str) == true {
				
				if show_question($"The save file: {player_input_str} already exists, are you sure you want over-write it?") {
					scr_delete_save_file(player_input_str);
				}
				else {
					start_game = false;
					player_input_str = "";
					global.cur_game_state = game_state.start_menu;	
				}
			}
			
			if start_game {
				
				global.cur_save_filename_str = player_input_str;
			
				//Define whatever vars we want here to more quickly load the game:
				global.floors_loaded_count = 0;
				global.cur_floor_ind = 0;
				global.grid_w = 25; //29
				global.grid_h = 25; //29
				global.max_floors_on_level = 15; //This var should vary depending upon the dungeon, as some dungeons are longer and more grueling than others.
				global.cur_dungeon_ind = dungeon_type.overworld;
				ds_grid_resize(global.visited_grid,global.grid_w,global.grid_h);
			
				scr_define_base_terrain_type_from_dungeon_index(global.cur_dungeon_ind);
				scr_setup_master_level_ar(global.cur_dungeon_ind,global.max_floors_on_level,global.base_terrain_type,"o_con step event: game_state == create new game, valid save filename was entered.");
		
				//Send to loading screen:
				global.cur_game_state = game_state.loading_mazes_screen;
			} else {
				show_message_async("A save game with this file name already exists, try again.");
				player_input_str = "";
			}
		} else {
			show_debug_message("o_con step event: create new game game state: player_input_str must be > 0 and cannot == an empty space.");	
		}
	}
}

#endregion

#region Loading Mazes Game Screen:

else if global.cur_game_state == game_state.loading_mazes_screen {
	
	if global.floors_loaded_count < global.max_floors_on_level {
		
		scr_generate_maze(global.cur_dungeon_ind);
		
		//Important! Iterate:
		global.cur_floor_ind++;
		
		global.floors_loaded_count++;
		
		global.level_progress_percent = (global.floors_loaded_count / global.max_floors_on_level) * 100;
	}
	
	//Reset g.floors_loaded_count and iterate cur_dungeon_ind to next dungeon:
	if global.floors_loaded_count >= global.max_floors_on_level {
		
		global.cur_dungeon_ind++;	
		
		//Reset vars for mazes to continue generating mazes:
		if global.cur_dungeon_ind <= dungeon_type.minotaur_maze {
			global.floors_loaded_count = 0; //Reset
			global.cur_floor_ind = 0; //Reset
		
			scr_define_base_terrain_type_from_dungeon_index(global.cur_dungeon_ind);
			scr_setup_master_level_ar(global.cur_dungeon_ind,global.max_floors_on_level,global.base_terrain_type,$"o_con stepe event: game_state == loading_mazes_screen, global.cur_dungeon_ind == {global.cur_dungeon_ind}, global.max_floors_on_level == {global.max_floors_on_level}, global.base_terrain_type == {global.base_terrain_type }");
		}
	
		//Mazes have finished generating, and we've started a new quick game or a new debug game:
		else {
			global.floors_loaded_count = 0; //Reset
			global.cur_floor_ind = 0; //Reset
			global.cur_dungeon_ind = dungeon_type.overworld; //Reset
		
			scr_setup_master_struct_ar();
			
			for(var dungeon_i = 0; dungeon_i <= dungeon_type.minotaur_maze; dungeon_i++) {
			
				scr_add_stairs_to_dungeon(dungeon_i, "o_con step event: game_state == loading_mazes_screen: floors_loaded_count >= max_floors_on_level and we finished generating our maze with scr_generate_maze");
			}
			
			//Set max_floros_on_level == floor length of the dungeon we'll be iterating over next:
			global.max_floors_on_level = array_length(global.master_level_ar[global.cur_dungeon_ind]);
			global.cur_game_state = game_state.loading_loot_screen;
		}
	}
}

#endregion

#region Loading loot game screen - we're brought here from loading_mazes_screen:

else if global.cur_game_state == game_state.loading_loot_screen {
	
	if global.floors_loaded_count < global.max_floors_on_level {
		
		scr_generate_loot(global.cur_dungeon_ind, global.floors_loaded_count);
		
		//Iterate floors loaded count:
		global.floors_loaded_count++;
		
		global.level_progress_percent = (global.floors_loaded_count / global.max_floors_on_level) * 100;
	}
	
	//Reset g.floors_loaded_count and iterate cur_dungeon_ind to next dungeon:
	if global.floors_loaded_count >= global.max_floors_on_level {
		
		global.cur_dungeon_ind++;	
		
		//Reset vars for mazes to continue generating loot on a different dungeon:
		if global.cur_dungeon_ind <= dungeon_type.minotaur_maze {
			
			global.floors_loaded_count = 0; //Reset
			global.max_floors_on_level = array_length(global.master_level_ar[global.cur_dungeon_ind]);
		}
	
		//Mazes have finished generating loot, add stairs then move to loading chars:
		else {
			global.floors_loaded_count = 0; //Reset
			global.cur_floor_ind = 0; //Reset
			global.cur_dungeon_ind = dungeon_type.overworld; //Reset
			
			//We'll start loading characters next:
			global.cur_game_state = game_state.loading_chars_screen;
		}
	}
	
}

#endregion

#region Loading Chars Game Screen: we're brought here from loading_loot_screen:

else if global.cur_game_state == game_state.loading_chars_screen {
	
	if global.floors_loaded_count < global.max_floors_on_level {
		
		scr_spawn_initial_enemies(global.cur_dungeon_ind,global.floors_loaded_count);
		
		global.floors_loaded_count++;
		
		global.level_progress_percent = (global.floors_loaded_count / global.max_floors_on_level) * 100;
	}
	//Reset g.floors_loaded_count and iterate cur_dungeon_ind to next dungeon:
	if global.floors_loaded_count >= global.max_floors_on_level {
		
		//Iterate:
		global.cur_dungeon_ind++;
		
		if global.cur_dungeon_ind <= dungeon_type.minotaur_maze {
			global.floors_loaded_count = 0; //Reset
			global.cur_floor_ind = 0; //Reset	
		}
	
		else {
			//Reset:
			global.cur_floor_ind = 0;
		
			global.cur_dungeon_ind = dungeon_type.overworld;
		
			//Randomly place our pcs in levels scattered throughout the first dungeon - 
			for(var dungeon_i = 0; dungeon_i <= dungeon_type.overworld; dungeon_i++) {
				scr_debug_spawn_initial_pcs(dungeon_i);
			}
			
			//Randomly place portals in the up/down portals first level of each world - 
			//they're debug buildings which allow pcs to move to/from different worlds
			scr_debug_spawn_initial_portals(dungeon_type.minotaur_maze, true);
		
			//Debug placeholder - Assign cur_char as first pc player in the first floor we find of the first world:
			// [dungeon_ind][floor_ind][team_ind][1d array within team_ind containg structs]
			scr_define_cur_char_as_first_pc_in_dungeon(global.cur_dungeon_ind);
			
			global.cur_floor_ind = global.cur_char.cur_floor_level;
		
			//Define g.*_grid global grid variables, setup terrain and LOS tilemaps, update LOS, center cam, change game_state:
			scr_start_game(global.cur_dungeon_ind,global.cur_floor_ind);
		}
	}
}

#endregion

#region Various start menu game states:

#region Logic for interacting with start_menu and debug_new_game_choose_maze_type

else if global.cur_game_state == game_state.start_menu || global.cur_game_state == game_state.debug_new_game_choose_maze_type {
	
	if keyboard_check_released(vk_escape) global.cur_game_state = game_state.start_menu;
	
	if keyboard_check_released(vk_up) || keyboard_check_released(vk_down) {
		
		if keyboard_check_released(vk_up) cursor_pos -= 1;
		else cursor_pos += 1;
		
		//Cap:
		var str_ar_len;
		if global.cur_game_state == game_state.start_menu str_ar_len = array_length(start_menu_str_ar);
		else str_ar_len = array_length(level_type_str_ar);
		if cursor_pos < 0 cursor_pos = str_ar_len-1;
		if cursor_pos >= str_ar_len cursor_pos = 0;
	}
	
	if keyboard_check_released(vk_enter) {
		
		#region Start Menu
		
		if global.cur_game_state == game_state.start_menu {
			
			#region New debug game: choose maze_type, w,h,and floors:
			
			if cursor_pos == start_menu_options.new_debug_game {
				global.cur_game_state = game_state.debug_new_game_choose_maze_type;
			} 
			
			#endregion
			
			#region New Quick Game
			
			else if cursor_pos == start_menu_options.new_quick_game {
				
				scr_create_prompt_box(prompt_box_type.create_new_game);
				
				global.cur_game_state = game_state.create_new_game;
			}
			
			#endregion
			
			#region LOAD GAME:
			
			else if cursor_pos == start_menu_options.load_game {
				
				//Switch to our 'load_filename_from_list' game state:
				
				//Load game data from external file - this also defines g.cur_dungeon_ind:
				if scr_load_file(global.cur_save_filename_str,"start_menu_options.load_game") {
					
					//g.master_level_ar and g.master_struct_ar have been loaded for the entire corresponding dungeon
					
					//Define our first g.cur_char as just the first pc char we find in the dungeon:
					scr_define_cur_char_as_first_pc_in_dungeon(global.cur_dungeon_ind);
					
					//Define our g.cur_floor_ind as w.e floor our g.cur_char is on:
					global.cur_floor_ind = global.cur_char.cur_floor_level;
					
					//Define grid dimensions:
					global.grid_w = ds_grid_width(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN]); //Hardly matters which one you choose, maps should always be == w and h
					global.grid_h = ds_grid_height(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN]);
				
					//Defunct vars only used for maze generation:	
						//scr_define_base_terrain_type_from_dungeon_index(global.cur_dungeon_ind);
						//global.max_floors_on_level = array_length(global.master_level_ar[global.cur_dungeon_ind]);
					
					//Start game:
					scr_start_game(global.cur_dungeon_ind,global.cur_floor_ind);	
				}
				//return to main menu:
				else {
					global.cur_game_state = game_state.start_menu;
				}
			}
			
			#endregion
			
			#region options screen:
			
			if cursor_pos == start_menu_options.options {
				global.cur_game_state = game_state.options_menu;
			}
			
			#endregion
			
			#region End game:
			
			if cursor_pos == start_menu_options.quit {
				game_end();
			}
			
			#endregion
		}
		
		#endregion
		
		#region Choose maze type:
		
		else if global.cur_game_state == game_state.debug_new_game_choose_maze_type {
			if cursor_pos == maze_type_options.recursive_backtracker {
				global.cur_dungeon_ind = dungeon_type.minotaur_maze;
				global.cur_game_state = game_state.debug_new_game_choose_w_and_h_and_floors;
				player_input_str = ""; //Reset
			} 
			else if cursor_pos == maze_type_options.debug_forest_world {
				global.cur_dungeon_ind = dungeon_type.overworld;
				global.cur_game_state = game_state.debug_new_game_choose_w_and_h_and_floors;
				player_input_str = ""; //Reset
			}	
		}
		
		#endregion
	}
}

#endregion

#region Logic for interacting with debug_new_game_choose_w_and_h_and_floors

else if global.cur_game_state == game_state.debug_new_game_choose_w_and_h_and_floors {
	
	//Edit 11-28-25: I don't use this option anymore, so it's probably not stable:
	if !keyboard_check_released(vk_enter) {
		if keyboard_check_released(vk_anykey) {
			player_input_str += keyboard_lastchar;	
		}
	}
	else {
		//This defines max_floors, map_w, map_h; g.cur_maze_type was defined by our previous game_state debug_new_game_choose_maze_type
		scr_parse_str(parse_str_type.debug_new_map,player_input_str);
		
		//Important!:
		global.floors_loaded_count = 0;
		global.cur_floor_ind = 0;
		ds_grid_resize(global.visited_grid,global.grid_w,global.grid_h);
		scr_define_base_terrain_type_from_dungeon_index(global.cur_dungeon_ind);
		scr_setup_master_level_ar(global.cur_dungeon_ind,global.max_floors_on_level,global.base_terrain_type,"game_state == debug_new_game_choose_w_and_h_and_floors");
		
		//Code to initiate new game:
		global.cur_game_state = game_state.loading_mazes_screen;
	}
} 

#endregion

#endregion

#region Debug scr_add_struct_to_inst_grid:

/*

var debug_key_pressed = false;
if keyboard_check_released(ord("1")) { debug_place_struct = 1; debug_key_pressed = true; }
if keyboard_check_released(ord("2")) { debug_place_struct = 2; debug_key_pressed = true; }
if keyboard_check_released(ord("3")) { debug_place_struct = 3; debug_key_pressed = true; }

if debug_key_pressed {
	
	var mouse_room_x = mouse_x, mouse_room_y = mouse_y;
	
	if scr_check_within_grid_bounds(global.terrain_grid,mouse_room_x,mouse_room_y) {
		var pos_ar = [];
		pos_ar = scr_convert_room_to_grid_coords(pos_ar,mouse_room_x,mouse_room_y);
		var mouse_grid_x = pos_ar[0], mouse_grid_y = pos_ar[1];
		pos_ar = -1;
		
		if debug_place_struct >= 1 && debug_place_struct <= 3 {
			
			if debug_place_struct == 1 scr_add_struct_to_inst_grid(new Character(char_class.acheron,char_team.pc,mouse_grid_x,mouse_grid_y),mouse_grid_x,mouse_grid_y,global.cur_floor_ind);
			
			else if debug_place_struct == 2 scr_add_struct_to_inst_grid(new Item(item_enum.armor_body_chainmail_crude),mouse_grid_x,mouse_grid_y,global.cur_floor_ind);
			
			else if debug_place_struct == 3 scr_add_struct_to_inst_grid(new Building("fucking building"),mouse_grid_x,mouse_grid_y,global.cur_floor_ind);
		}
	}
}
*/

#endregion

#region Game state == main:

else if global.cur_game_state == game_state.main  {
	
	#region Debug placeholder: save game:
	
	if keyboard_check(vk_lcontrol) && keyboard_check_released(ord("S")) {
		
		scr_save_file(global.cur_save_filename_str,global.cur_dungeon_ind,global.cur_floor_ind,"o_con step event: ctrl+'S' key, user manually saving game.");
		
	}
	
	#endregion
	
	#region Basic map camera movement - move around with arrow keys, zoom in or out with mouse wheel:
	
	#region Move cam with keyboard:
	
	var cam_dir_x = 0, cam_dir_y = 0, cam_key_pressed = false;

	if(keyboard_check(vk_left)) { cam_dir_x = global.cam_move_spd*-1; cam_key_pressed = true; }
	if(keyboard_check(vk_right)) { cam_dir_x = global.cam_move_spd; cam_key_pressed = true; }
	if(keyboard_check(vk_up)) { cam_dir_y = global.cam_move_spd*-1; cam_key_pressed = true; }
	if(keyboard_check(vk_down)) { cam_dir_y = global.cam_move_spd; cam_key_pressed = true; }

	if(cam_key_pressed) {
		scr_move_cam(global.map_cam,cam_dir_x,cam_dir_y)	
	}
	
	#endregion
	
	#region grab and drag camera
	
	//ai claude version:
	
	//Gather and set vars:
	if mouse_check_button_pressed(mb_middle) {
	    // Reset instance vars - store the window mouse position as anchor:
	    cam_grab_origin_x = window_mouse_get_x();
	    cam_grab_origin_y = window_mouse_get_y();
	}

	// "drag" camera position while holding down the mouse button:
	if mouse_check_button(mb_middle) {
	    //Get current mouse coordinates within the window:
		var win_mouse_x = window_mouse_get_x();
	    var win_mouse_y = window_mouse_get_y();
    
	    // Calculate the difference in window coordinates - both variables are in window_coordinates so this is possible:
	    var mouse_diff_x = cam_grab_origin_x - win_mouse_x;
	    var mouse_diff_y = cam_grab_origin_y - win_mouse_y;
    
	    // Convert window coordinate difference to room coordinate difference:
	    var room_diff_x = mouse_diff_x * (camera_get_view_width(global.map_cam) / window_get_width());
	    var room_diff_y = mouse_diff_y * (camera_get_view_height(global.map_cam) / window_get_height());
    
	    // Get current camera position and add the scaled difference:
	    var current_cam_x = camera_get_view_x(global.map_cam);
	    var current_cam_y = camera_get_view_y(global.map_cam);
    
	    // Move camera:
	    camera_set_view_pos(global.map_cam, current_cam_x + room_diff_x, current_cam_y + room_diff_y);
    
	    // Update anchor point to current mouse position for smooth dragging:
	    cam_grab_origin_x = win_mouse_x;
	    cam_grab_origin_y = win_mouse_y;
	}
	
	#endregion
	
	#region Zoom in or out on mouse coordinates:
	
	//Zoom out:
	var zoom_key = false;
	if mouse_wheel_down()
	{
		global.cur_zoom_val += global.zoom_val;
		zoom_key = true;
	}

	//Zoom In:
	if mouse_wheel_up()
	{
		global.cur_zoom_val -= global.zoom_val;
		zoom_key = true;
	}

	if zoom_key
	{
		//Cap our cur_zoom_val so we're never zooming in too close or zooming out too far:
		if global.cur_zoom_val < .25 global.cur_zoom_val = .25; //Cap zoom in
		if global.cur_zoom_val > 4 global.cur_zoom_val = 4;
	
		var zoom_on_cur_char = false;
	
		if zoom_on_cur_char
		{
			scr_zoom_on_inst_or_coord(zoom_on_cur_char, global.cur_char,global.map_cam,global.cur_zoom_val,-1,-1);	
		}
		else if !zoom_on_cur_char
		{
			//Just use the current approx halfway point of our cam w and cam h as our coordinate:
			var half_cam_w = camera_get_view_x(global.map_cam)+(camera_get_view_width(global.map_cam) div 2);
			var half_cam_h = camera_get_view_y(global.map_cam)+(camera_get_view_height(global.map_cam) div 2);
			
			scr_zoom_on_inst_or_coord(zoom_on_cur_char,-1,global.map_cam,global.cur_zoom_val,half_cam_w,half_cam_h);
		}
	}
	
	#endregion
	
	#endregion
	
	#region Iterate through levels with keyboard:
	
	//Iterate tilemap and grids up/down through levels, regardless of whether or not they've been explored yet:
	if keyboard_lastchar == "+" || keyboard_lastchar == "-" {
		
		//Unassign g.cur_char:
		global.cur_char = -1;
		
		var iterate_dir = undefined;;
		
		if keyboard_lastchar == "+" {
				iterate_dir = 1;
				show_debug_message("(+) UP KEY DETECTED! - Browsing through levels");
		} 
		else if keyboard_lastchar == "-" {
			iterate_dir = -1;	
			show_debug_message("(-) DOWN KEY DETECTED! - Browsing through levels");
		}
		
		//Increment:
		global.cur_floor_ind += iterate_dir;
		
		//Cap:
		var ar_len = array_length(global.master_level_ar[global.cur_dungeon_ind]);
		if global.cur_floor_ind < 0 global.cur_floor_ind = ar_len-1;
		else if global.cur_floor_ind >= ar_len global.cur_floor_ind = 0;
		
		keyboard_lastchar = ""; //Reset
		
		//Assign terrain_grid and then update tilemap:
		global.terrain_grid = global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN];
		scr_define_tilemap_from_grid(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN],global.terrain_tile_id,"Using debug keys to change level floor.");
				
		//Update los and define fow tilemap:
		scr_reset_building_and_loot_drop_visibility(global.cur_dungeon_ind,global.cur_floor_ind,"o_con step event: + or - keypress used to iterate up/down through levels, even if they're unexplored.");
		scr_reset_fow(global.cur_floor_ind,global.cur_dungeon_ind);
		scr_update_los(global.cur_dungeon_ind, global.cur_floor_ind,"using debug to change the cur floor.");
		//scr_update_visibility(global.cur_floor_ind, "o_con create event: updating building visibility after changing the floor.");
		scr_define_tilemap_from_grid(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_LOS], global.fow_tile_id,"Using debug keys to change level floor.");
						
	}
	
	//Move g.cur_char up/down a level or up/down into different dungeon:
	if global.cur_char != -1 && !is_undefined(global.cur_char) {
		if is_struct(global.cur_char) {
			if keyboard_lastchar == "<" || keyboard_lastchar == ">" {
		
				var iterate_dir = undefined;;
		
				if keyboard_lastchar == "<" {
					 iterate_dir = -1;
					 show_debug_message("UP KEY DETECTED!");
				} 
				else if keyboard_lastchar == ">" {
					iterate_dir = 1;	
					show_debug_message("DOWN KEY DETECTED!");
				}
		
				keyboard_lastchar = ""; //Reset
		
				var building_struct = scr_return_struct_id(global.cur_char.char_grid_x,global.cur_char.char_grid_y,struct_type.building,global.cur_floor_ind,global.cur_dungeon_ind);
				
				if building_struct != 0 && is_struct(building_struct) {
					
					show_debug_message($"o_con step event: < or > keypress: pc is standing on building_struct with building_type_enum: {building_struct.building_ar[building_stats.type]}");
					
					var valid_key_press = false;
					var portal_used = false;
					
					//Placeholder logic for stairs or portals (portals currently don't change floors, just dungeons):
						//Down stairs
					if building_struct.building_ar[building_stats.type] == building_type.stair_down && 
					iterate_dir == 1 {	
						valid_key_press = true;
					}
						//Down portal:
					else if building_struct.building_ar[building_stats.type] == building_type.portal_world_down && 
					iterate_dir == 1 {	
						valid_key_press = true;
						portal_used = true;
					}
						//Up stair
					else if building_struct.building_ar[building_stats.type] == building_type.stair_up && 
					iterate_dir == -1 {
						valid_key_press = true;
					}
						//Up portal:
					else if building_struct.building_ar[building_stats.type] == building_type.portal_world_up && 
					iterate_dir == -1 {
						valid_key_press = true;
						portal_used = true;
					}
					
					if valid_key_press {
						
						//Remove from previous instance grid and struct_ar, add to new one:
							//Remove from previous inst grid:
						scr_remove_struct_from_inst_grid(global.cur_char,global.cur_char.char_grid_x,global.cur_char.char_grid_y,
						global.cur_floor_ind,global.cur_dungeon_ind,"o_con step event: manually moving character between floors or worlds with < or > keys.");
							
							//remove from previous struct_ar:
						scr_remove_from_master_struct_ar(global.cur_char,global.cur_dungeon_ind,global.cur_floor_ind,"o_con step event: manually moving character between floors or worlds with < or > keys.");
							
						//Adjust our cur_char's cur_floor_level and g.cur_floor_ind:
						if !portal_used {
							global.cur_char.cur_floor_level += iterate_dir;
							global.cur_floor_ind += iterate_dir;
						} else if portal_used {
							global.prev_dungeon_ind = global.cur_dungeon_ind;
							global.cur_dungeon_ind += iterate_dir;	
						}
							
						//Determine if the level grids and structs need to be loaded from our g.cur_save_filename_str:
						if portal_used {
							
							if scr_check_level_grid(global.cur_dungeon_ind,global.cur_floor_ind) == false || scr_check_level_structs(global.cur_dungeon_ind,global.cur_floor_ind) == false {
								
								//We need to reset our team arrays to avoid multiple copies of the same struct being added to the 
								//the same arrays when we move back and forth between worlds; also, in the actual game, pcs will only ever
								//exist in one dungeon at the same time, so it doesn't make any sense in that regard.
								scr_reset_global_team_arrays(); //Does NOT reset the g.master_item_ar!
								
								var next_dungeon_max_floors = scr_return_external_file_structure_floor_len(global.cur_save_filename_str,global.cur_dungeon_ind,"o_con step event: pc manually moved into a world_portal with < or > keypress.");
								
								for(var floor_i = 0; floor_i < next_dungeon_max_floors; floor_i++) {
									// Load ONLY this level's grids:
									scr_load_level_grids(global.cur_save_filename_str,global.cur_dungeon_ind, floor_i,"o_con step event: pc manually moved into a world_portal with < or > keypress.")
	
									// Load ONLY this level's structs:
								    scr_load_level_structs(global.cur_save_filename_str, global.cur_dungeon_ind, floor_i,"o_con step event: pc manually moved into a world_portal with < or > keypress.");
								}
							}
						
							//Change g.cur_char x and y coordinates to match portal's corresponding x and y:
							var find_up_portal = false;
							if iterate_dir == 1 find_up_portal = true;
							
							var up_portal_struct_id = scr_return_portal_on_floor(find_up_portal,global.cur_dungeon_ind,global.cur_floor_ind);
							
							if up_portal_struct_id != false && is_struct(up_portal_struct_id) {
								global.cur_char.char_grid_x = up_portal_struct_id.building_grid_x;
								global.cur_char.char_grid_y = up_portal_struct_id.building_grid_y;
								global.cur_char.char_room_x = global.cur_char.char_grid_x*global.cell_size+global.grid_offset_x+global.half_c;
								global.cur_char.char_room_y = global.cur_char.char_grid_y*global.cell_size+global.grid_offset_y+global.half_c;
							} 
						}
						
						//Add to different instance grid (potentially new location in g.master_level_ar)
						//And add to different g.master_struct_ar (potentially new location in g.master_struct_ar):
						
							//Add to new instance grid:
						scr_add_struct_to_inst_grid(global.cur_char,global.cur_char.char_grid_x,global.cur_char.char_grid_y,
						global.cur_floor_ind,global.cur_dungeon_ind);
							
							//Add to new struct ar:
						scr_add_to_master_struct_ar(global.cur_char,global.cur_dungeon_ind,global.cur_floor_ind,"o_con step event: just used </> to manually move a char up/down a level or world.");
						
						//Assign terrain_grid and then update tilemap:
						global.terrain_grid = global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN];
						scr_define_tilemap_from_grid(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN],global.terrain_tile_id,"Using debug keys to change level floor.");
				
						//Update los and define fow tilemap:
						scr_reset_building_and_loot_drop_visibility(global.cur_dungeon_ind,global.cur_floor_ind,"o_con step event: < or > keypress used to iterate up/down through levels by using a up or down stair or dungeon portal.");
						scr_reset_fow(global.cur_floor_ind,global.cur_dungeon_ind);
						scr_update_los(global.cur_dungeon_ind, global.cur_floor_ind,"using debug to change the cur floor.");
						//scr_update_visibility(global.cur_floor_ind, "o_con create event: updating building visibility after changing the floor.");
						scr_define_tilemap_from_grid(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_LOS], global.fow_tile_id,"Using debug keys to change level floor.");
						
						//Now we need to off-load the entire previous dungeon:
						if portal_used {
							//ALWAYS SAVE first before off-loading a dungeon:
							scr_save_file(global.cur_save_filename_str,global.cur_dungeon_ind,global.cur_floor_ind,"o_con step event: player has manually moved pc through a world_portal into another dungeon, getting ready to off-load previous dungeon by wiping external file of current g.master_struct_ar data, then saving everything from current g.master_struct_ar into external file.");
							//Delete that entire dungeon from both the g.master_struct_ar and g.master_level_ar:
							global.master_struct_ar[global.prev_dungeon_ind] = 0;
							global.master_level_ar[global.prev_dungeon_ind] = 0;
						}
					}
				}
			}
		}
	}
	
	#endregion
	
	#region Debug: move character with keyboard:
	
	if global.cur_char != -1 && is_struct(global.cur_char) {
				
		var n = keyboard_check_released(vk_numpad8);
		var ne = keyboard_check_released(vk_numpad9);
		var e = keyboard_check_released(vk_numpad6);
		var se = keyboard_check_released(vk_numpad3);
		var s = keyboard_check_released(vk_numpad2);
		var sw = keyboard_check_released(vk_numpad1);
		var w = keyboard_check_released(vk_numpad4);
		var nw = keyboard_check_released(vk_numpad7);
				
		var dir_x = 0, dir_y = 0;
				
		if n dir_y = -1;
		else if ne { dir_x = 1; dir_y = -1;}
		else if e { dir_x = 1; }
		else if se { dir_x = 1; dir_y = 1;}
		else if s { dir_y = 1;}
		else if sw { dir_x = -1; dir_y = 1;}
		else if w { dir_x = -1; }
		else if nw { dir_x = -1; dir_y = -1;}
				
		if(ne || n || e || se || s || sw || w || nw) {
			//show_debug_message("KEYBOARD MOVEMENT KEY DETECTED!")
			if global.terrain_grid[# global.cur_char.char_grid_x+dir_x,global.cur_char.char_grid_y+dir_y] < terrain_type.wall_dungeon {
				//show_debug_message("TERRAIN AT DEST COORDINATES < TERRAIN_WALL!")
						
				//If there's a matching struct at that location, forbid movement:
				var valid_move = false, swap_pos_boolean = false;
						
				var char_struct_at_dest = scr_return_struct_id(global.cur_char.char_grid_x+dir_x,
				global.cur_char.char_grid_y+dir_y,struct_type.character,global.cur_floor_ind,global.cur_dungeon_ind);
						
				if char_struct_at_dest == false { valid_move = true; }
						
				else if is_struct(char_struct_at_dest) {
					//We're attempting to move into another pc:
					if char_struct_at_dest.char_stats_ar[char_stats.char_team_enum] == char_team.pc {
						swap_pos_boolean = true;
						valid_move = true;
					}
					//Just destroy that other Character struct and remove it from g.master_struct_ar,
					//corresponding instance_grid and its corresponding global team array:
					else if char_struct_at_dest.char_stats_ar[char_stats.char_team_enum] != char_team.pc {
						var enemy_char_name = scr_return_struct_name(char_struct_at_dest);
						scr_create_status_message(global.cur_char.char_room_x,global.cur_char.char_room_y,$"{enemy_char_name} has been destroyed!",c_red,true);
						scr_destroy_struct(char_struct_at_dest);
						if !is_struct(char_struct_at_dest) {
							show_debug_message($"o_con step event: pc char just finished moving into a non-pc team character strut and removed that struct from the game.");	
						}
					}
				}
						
				if valid_move {
							
					if !swap_pos_boolean {
						//show_debug_message("Moving and NOT swapping positions!");
								
						//Remove from prev inst grid location
						scr_remove_struct_from_inst_grid(global.cur_char,global.cur_char.char_grid_x,
						global.cur_char.char_grid_y,global.cur_floor_ind,global.cur_dungeon_ind);
						
						//Update char grid and room coordinates:
						global.cur_char.char_grid_x += dir_x;
						global.cur_char.char_grid_y += dir_y;
						global.cur_char.char_room_x += global.cell_size*dir_x;
						global.cur_char.char_room_y += global.cell_size*dir_y;
						
						//Add to new inst_grid location:
						scr_add_struct_to_inst_grid(global.cur_char,global.cur_char.char_grid_x,
						global.cur_char.char_grid_y,global.cur_floor_ind,global.cur_dungeon_ind);
					}
					//Swap position instead:
					else {
						//show_debug_message("Moving AND swapping positions!");
								
						//Remove both pcs from their respective grid positions:
						scr_remove_struct_from_inst_grid(global.cur_char,global.cur_char.char_grid_x,
						global.cur_char.char_grid_y,global.cur_floor_ind,global.cur_dungeon_ind);
						scr_remove_struct_from_inst_grid(char_struct_at_dest,char_struct_at_dest.char_grid_x,
						char_struct_at_dest.char_grid_y,global.cur_floor_ind,global.cur_dungeon_ind);
								
						//Update char_grid_* and char_room_*:
						var origin_grid_x = global.cur_char.char_grid_x;
						var origin_grid_y = global.cur_char.char_grid_y;
						var origin_room_x = global.cur_char.char_room_x;
						var origin_room_y = global.cur_char.char_room_y;
								
							//g.cur_char:
						global.cur_char.char_grid_x += dir_x;
						global.cur_char.char_grid_y += dir_y;
						global.cur_char.char_room_x += global.cell_size*dir_x;
						global.cur_char.char_room_y += global.cell_size*dir_y;
							//swapped inst:
						char_struct_at_dest.char_grid_x = origin_grid_x;
						char_struct_at_dest.char_grid_y = origin_grid_y;
						char_struct_at_dest.char_room_x = origin_room_x;
						char_struct_at_dest.char_room_y = origin_room_y;
								
						//Add both to new positions in inst grid:
							//g.cur_char
						scr_add_struct_to_inst_grid(global.cur_char,global.cur_char.char_grid_x,
						global.cur_char.char_grid_y,global.cur_floor_ind,global.cur_dungeon_ind);
							//swapped inst:
						scr_add_struct_to_inst_grid(char_struct_at_dest,char_struct_at_dest.char_grid_x,
						char_struct_at_dest.char_grid_y,global.cur_floor_ind,global.cur_dungeon_ind);
					}
							
					//Update los and enemy visibility:
					if !global.debug_disable_los {
						scr_reset_building_and_loot_drop_visibility(global.cur_dungeon_ind,global.cur_floor_ind,"o_con step event: manually moving g.cur_char around the same floor with the numpad or arrow keys.");
						scr_reset_fow(global.cur_floor_ind,global.cur_dungeon_ind);
						scr_update_los(global.cur_dungeon_ind, global.cur_floor_ind, "pc_struct has just moved.");
						//scr_update_visibility("pc_struct has just moved.");
						scr_define_tilemap_from_grid(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_LOS], global.fow_tile_id,"A pc char just moved with the debug keyboard keys.");
					}
				}
			}
		}	
	}
	
	#endregion
	
	#region Change g.cur_char on lmb click, unassign with rmb click:
	
	if mouse_check_button_released(mb_left) {
		
		if scr_check_within_grid_bounds(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN],mouse_x,mouse_y) {
			var pos_ar = [];
			pos_ar = scr_convert_room_to_grid_coords(pos_ar,mouse_x,mouse_y);
			var grid_x = pos_ar[0], grid_y = pos_ar[1];
			pos_ar = -1;
			
			var struct_id = scr_return_struct_id(grid_x,grid_y,struct_type.character,global.cur_floor_ind,global.cur_dungeon_ind);
			
			if struct_id != false {
				if is_struct(struct_id) {
					if struct_id.char_stats_ar[char_stats.char_team_enum] == char_team.pc {
						global.cur_char = struct_id;
						
						/*
						global.cur_game_state = game_state.pc_plotting_path;
						
						//Define start and end coordinates:
						path_start_grid_x = global.cur_char.char_grid_x;
						path_start_grid_y = global.cur_char.char_grid_y;
						path_dest_grid_x = -1;
						path_dest_grid_y = -1;
						mouse_prev_grid_x = -2;
						mouse_prev_grid_y = -2;
						*/
					}
				}
			}
		}
	}
	
	//Unassign g.cur_char:
	if mouse_check_button_released(mb_right) {
		global.cur_char = -1;
	}
	
	#endregion
}

#endregion

#region Logic for pc_plotting_path:

else if global.cur_game_state == game_state.pc_plotting_path {

	var mouse_room_x = mouse_x, mouse_room_y = mouse_y;
	
	if scr_check_within_grid_bounds(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN],mouse_room_x,mouse_room_y) {
		
		//Convert to grid coords:
		var pos_ar = [];
		pos_ar = scr_convert_room_to_grid_coords(pos_ar,mouse_room_x,mouse_room_y);
		
		var mouse_grid_x = pos_ar[0], mouse_grid_y = pos_ar[1];
		pos_ar = -1;
		
		//If we've moved into a new cell...
		if mouse_grid_x != path_dest_grid_x && mouse_grid_y != path_dest_grid_y {
			
			scr_plot_a_star_path_to_dest()
			
		}
	}
}

#endregion





