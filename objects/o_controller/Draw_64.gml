/// @description o_con Draw gui event

var win_w = window_get_width(), win_h = window_get_height();

var gui_display_w = display_get_gui_width(), gui_display_h = display_get_gui_height();

//Mouse gui vars:
var mouse_win_x = device_mouse_x_to_gui(0), mouse_win_y = device_mouse_y_to_gui(0);

#region Attempt to reset window full screen:

if window_has_focus() == true { //We use this because the window_get_width() and height functions only return 0 when the game doesn't have focus, so it's not useful to run this code when the game doesn't have focus

	global.reset_full_screen_count--;

	if global.reset_full_screen_count <= 0 {

		var debug_fs = false, debug_win_w = false, debug_win_h = false;
	
		if window_get_fullscreen() == false debug_fs = true;
		if win_w != global.win_w debug_win_w = true;
		if win_h != global.win_h debug_win_h = true;
	
		if debug_fs || debug_win_w || debug_win_h {
			window_set_fullscreen(true);
			d("o_con Draw GUI event: window dimensions were altered somehow (bug), automatic timer has RESET WINDOW TO FULL SCREEN. This was triggered by:");
			if debug_fs d("window_get_fullscreen == false");
			if debug_win_w d($"win_w: {win_w} did not == {global.win_w}");
			if debug_win_h d($"win_h: {win_h} did not == {global.win_h}");
			d($"win_w: {window_get_width()} win_h: {window_get_height()} gui_w: {display_get_gui_width()} gui_h: {display_get_gui_height()} display_w: {display_get_width()} display_h: {display_get_height()}");
			d($"os_type: {os_type} focus: {window_has_focus()}");
		}
	
		global.reset_full_screen_count = global.reset_full_screen_val; //reset
	
	}
}

#endregion

#region Main game state - Draw debug information:

 //Indicates game has already been loaded for the first time
if draw_inv_for_load_once == false {

	var title_y_buff = 16;

	scr_center_font_align();
	
	draw_text(display_get_gui_width() / 2, title_y_buff, $"\"{global.cur_save_filename_str}\" - {level_type_str_ar[global.cur_dungeon_ind]}, FLOOR: {global.cur_floor_ind}, FOOD: {global.resource_food}, GOLD: {global.resource_gold}" );
	d("DRAWING GLOBAL RESOURCES!");
	scr_reset_font_align();
	
	/* //Defunct:
	var debug_str = "UNDEFINED";
	if debug_place_struct == 1 debug_str = "CHAR";
	else if debug_place_struct == 2 debug_str = "ITEM";
	else if debug_place_struct == 3 debug_str = "BUILDING";

	draw_text_color(gui_display_w-256,24,"PLACING: "+string(debug_str),c_white,c_white,c_white,c_white,1);
	*/
}

#endregion

#region Start Menu or debug_new_game_choose_maze_type:

if global.cur_game_state == game_state.start_menu || global.cur_game_state == game_state.debug_new_game_choose_maze_type {
	
	//Blacken the screen:
	draw_rectangle_color(0,0,win_w,win_h,c_black,c_black,c_black,c_black,false);
	
	var ar_to_use;
	if global.cur_game_state == game_state.start_menu ar_to_use = start_menu_str_ar;
	else ar_to_use = level_type_str_ar;
	
	scr_center_font_align();
	
	var txt_y_offset = 32, c = c_white;
	for(var i = 0; i < array_length(ar_to_use); i++) {
	
		draw_text_color(win_w / 2, (win_h / 2)-128+(txt_y_offset*i),string(ar_to_use[i]),c,c,c,c,1 );
	}
	
	scr_reset_font_align();
	
	//Draw cursor:
	var cursor_offset_x;
	if global.cur_game_state == game_state.start_menu cursor_offset_x = 96;
	else cursor_offset_x = 128;
	draw_sprite(spr_start_menu_cursor,-1,win_w / 2-cursor_offset_x,(win_h / 2)-128+(txt_y_offset*cursor_pos) );
}

#endregion

#region debug_new_game_choose_w_and_h_and_floors:

else if global.cur_game_state == game_state.debug_new_game_choose_w_and_h_and_floors {
	
	//Blacken the screen:
	draw_rectangle_color(0,0,win_w,win_h,c_black,c_black,c_black,c_black,false);
	
	scr_center_font_align();
	
	var c = c_white;
	
	//Draw instructions:
	draw_text_color(win_w / 2, (win_h / 2)-128,"Enter map w, h, and num_floors in format:w,h,floors.",c,c,c,c,1 );
	
	//Draw user input and text_cursor_sprite:
	draw_text_color(win_w / 2, (win_h / 2)-96,player_input_str,c,c,c,c,1 );
	
	scr_reset_font_align();
	
	//Draw our blinking txt cursor beneath:
		//We can reuse these vars for our purposes b.c we're not in the actual game yet:
	if cur_char_frame_timer < global.intended_game_spd {
		cur_char_frame = 0;	
	} 
	else cur_char_frame = 1;
		
	if cur_char_frame_timer > global.intended_game_spd*2 cur_char_frame_timer = 0;
		
	draw_sprite(spr_txt_cursor,cur_char_frame,(win_w / 2)+string_width(player_input_str) / 2,
	(win_h / 2)-96+4+(sprite_get_height(asset_get_index("spr_txt_cursor"))));
		
	cur_char_frame_timer++;	
}

#endregion

#region Loading Mazes or Loading chars screen:

else if global.cur_game_state == game_state.loading_mazes_screen || global.cur_game_state == game_state.loading_loot_screen || 
global.cur_game_state == game_state.loading_chars_screen {
	
	//Blacken the screen:
	draw_rectangle_color(0,0,win_w,win_h,c_black,c_black,c_black,c_black,false);
	
	scr_center_font_align();
	
	var c = c_white;
	var txt_str;
	if global.cur_game_state == game_state.loading_mazes_screen txt_str = "...CREATING WORLDS AND LABYRINTHS...";
	else if global.cur_game_state == game_state.loading_chars_screen txt_str = "...SPAWNING ENEMIES...";
	else if global.cur_game_state == game_state.loading_loot_screen txt_str = "...SPAWNING TREASURE...";
	
	draw_text_color(win_w / 2, (win_h / 2)-128,txt_str,c,c,c,c,1 );
	
	//Define positional vars:
	var bar_y = (win_h / 2)-128+16+(sprite_get_height(asset_get_index("spr_progress_bar_frame")));
	var bar_x = (win_w / 2);
	
	// Calculate the color based on progress (0-100)
	var progress_color = merge_color(c_red, c_lime, global.level_progress_percent / 100);

	// Calculate width based on progress
	var bar_width = (global.level_progress_percent / 100) * 512;

	// Draw the progress bar
	draw_set_color(progress_color);
	var rect_x1 = bar_x-sprite_get_width(asset_get_index("spr_progress_bar_frame")) / 2;
	var rect_y1 = bar_y-sprite_get_height(asset_get_index("spr_progress_bar_frame")) / 2;
	//var rect_x2 = bar_x+sprite_get_width(asset_get_index("spr_progress_bar_frame")) / 2;
	var rect_y2 = bar_y+sprite_get_height(asset_get_index("spr_progress_bar_frame")) / 2;
	
	//Draw progress bar fill, which changes color from red to green:
	draw_rectangle(rect_x1, rect_y1, rect_x1 + bar_width, rect_y2, false);
	
	//Draw progress bar frame:
	draw_sprite(spr_progress_bar_frame,0,bar_x,bar_y );
	
	draw_set_color(c_white); //Reset
	scr_reset_font_align();
}

#endregion

#region Create New Game:

else if global.cur_game_state == game_state.create_new_game {
	
	//Draw spr_prompt_box using vars created in scr_create_prompt_box:
	var c = c_gray, frame_c = c_silver, frame_offset = 8;
	//Draw base prompt box:
	draw_rectangle_color(prompt_box_origin_x-(prompt_box_w / 2),prompt_box_origin_y-(prompt_box_h / 2),
	prompt_box_origin_x+(prompt_box_w / 2),prompt_box_origin_y+(prompt_box_h / 2),c,c,c,c,false);
	//Draw inner frame:
	draw_rectangle_color(prompt_box_origin_x-(prompt_box_w / 2)+frame_offset,prompt_box_origin_y-(prompt_box_h / 2)+frame_offset,
	prompt_box_origin_x+(prompt_box_w / 2)-frame_offset,prompt_box_origin_y+(prompt_box_h / 2)-frame_offset,frame_c,frame_c,frame_c,frame_c,true);
	
	//Draw prompt text:
	scr_center_font_align();
	var text_c = c_silver, str_h = string_height("ABCDEFGHIJKLMNOPQRSTUVWXYZ")+frame_offset+8;
	draw_text_color(prompt_box_origin_x,prompt_box_origin_y-(prompt_box_h / 2)+str_h,"Create New Game - Enter Save File Name",text_c,text_c,text_c,text_c,1);
	scr_reset_font_align();
	
	//Draw input box:
	var c = c_white;
	draw_rectangle_color(prompt_box_origin_x-(max_filename_box_w / 2),prompt_box_origin_y-(max_filename_box_h / 2),
	prompt_box_origin_x+(max_filename_box_w / 2),prompt_box_origin_y+(max_filename_box_h / 2),c,c,c,c,false);
	//Draw black frame box:
	var c = c_black;
	draw_rectangle_color(prompt_box_origin_x-(max_filename_box_w / 2),prompt_box_origin_y-(max_filename_box_h / 2),
	prompt_box_origin_x+(max_filename_box_w / 2),prompt_box_origin_y+(max_filename_box_h / 2),c,c,c,c,true);
	
	//Define cursor_origin_x:
	cursor_origin_x = prompt_box_origin_x-(max_filename_box_w / 2);
	cursor_origin_y = prompt_box_origin_y+sprite_get_height(asset_get_index("spr_txt_cursor"))+8;
	
	//Draw player_input_str:
	draw_text_color(cursor_origin_x, cursor_origin_y-string_height("W"),player_input_str,c,c,c,c,1 );
	
	//Draw our blinking txt cursor beneath:
		//We can reuse these vars for our purposes b.c we're not in the actual game yet:
	if cur_char_frame_timer < global.intended_game_spd {
		cur_char_frame = 0;	
	} 
	else cur_char_frame = 1;
		
	if cur_char_frame_timer > global.intended_game_spd*2 cur_char_frame_timer = 0;
		
	draw_sprite(spr_txt_cursor_2,cur_char_frame,cursor_origin_x+string_width(player_input_str),cursor_origin_y);
		
	cur_char_frame_timer++;	
}

#endregion

#region Load Saved Games List screen:

else if global.cur_game_state == game_state.load_game_list {
	
	//Draw our light gray foreground box:
	var fg_c = c_ltgrey;
	draw_rectangle_color(load_list_fg_origin_x, load_list_fg_origin_y, load_list_fg_origin_x+load_list_fg_w,  load_list_fg_origin_y+load_list_fg_h, fg_c, fg_c, fg_c, fg_c, false);
	
	//Draw our g.saved_games_list array, if applicable:
	if is_array(global.saved_games_list) && array_length(global.saved_games_list) > 0 {
		
		var txt_c, frame_c;
		
		scr_center_font_align();
		
		//Draw our 'LOAD SAVED GAME' screen title:
		draw_set_font(fnt_std_16);
		draw_text_color(display_get_gui_width() / 2, load_list_fg_origin_y-96,"LOAD SAVED GAME:\nLMB click to choose file\nEscape button to return to main menu",c_white,c_white,c_white,c_white,1);
		draw_set_font(global.default_fnt);
		
		for(var i = 0; i < array_length(global.saved_games_list); i++) {
			
			txt_c = c_black;
			frame_c = c_white;
			
			if i == load_game_index { txt_c = c_lime; frame_c = c_lime; }
			
			//Draw a thin white box framing every index position:
			draw_rectangle_color(load_list_fg_origin_x, load_list_fg_origin_y+(i*load_list_slot_h), 
			load_list_fg_origin_x+load_list_fg_w, load_list_fg_origin_y+((i*load_list_slot_h)+load_list_slot_h), frame_c,frame_c,frame_c,frame_c,true);
			
			//Draw text centered in the middle of the list:
			draw_text_color(load_list_fg_origin_x+(load_list_fg_w / 2),load_list_fg_origin_y+(load_list_slot_h / 2)+(load_list_slot_h*i),global.saved_games_list[i],txt_c,txt_c,txt_c,txt_c,1);
		}
		
		scr_reset_font_align();
	}
	
}

#endregion

#region Game_state == main - Draw our g.cur_char portrait and other party members with stats on top left of screen:

//Using if instead of else-if opens up possibilities of this drawn in the background if other different, separate game states are used:
if global.cur_game_state == game_state.main || global.cur_game_state == game_state.access_inv || global.cur_game_state == game_state.view_stats || 
global.cur_game_state == game_state.view_bio || global.cur_game_state == game_state.select_trader {
	
	//Draw current char, if applicable:
	if global.cur_char != -1 && is_struct(global.cur_char) && global.cur_char.struct_enum == struct_type.character && global.cur_char.char_stats_ar[char_stats.char_team_enum] == char_team.pc {
	
		var cur_char_spr = asset_get_index(global.cur_char.char_spr_str);
		var char_spr_w = sprite_get_width(cur_char_spr)*global.portrait_scale;
		var char_spr_h = sprite_get_height(cur_char_spr)*global.portrait_scale;
		var half_char_spr_w = char_spr_w / 2, half_char_spr_h = char_spr_h / 2;
	
		var portrait_offset_x = 16, portrait_offset_y = 16;
	
		var spr_origin_x = half_char_spr_w+portrait_offset_x, spr_origin_y = half_char_spr_h+portrait_offset_y;
		
		cur_char_spr_origin_x = spr_origin_x; //used for drawing inventory bg and boxes and etc.:
		cur_char_spr_origin_y = spr_origin_y;
		
		var mouse_win_x = device_mouse_x_to_gui(0), mouse_win_y = device_mouse_y_to_gui(0);
	
		var mouse_within_portrait = false, spr_frame = 0;
	
		if mouse_win_x <= char_spr_w+portrait_offset_x && mouse_win_y <= char_spr_h+portrait_offset_y {
			mouse_within_portrait = true;
			spr_frame = 1;
		}
		
		//Draw cur_char portrait sprite:
		draw_sprite_ext(cur_char_spr,spr_frame,spr_origin_x,spr_origin_y,global.portrait_scale,global.portrait_scale,0,c_white,1);
		
		scr_center_font_align();
		var stat_c = c_black, icon_w = sprite_get_width(spr_generic_icon), icon_h = sprite_get_height(spr_generic_icon);
		//Draw move point value bottom left:
		var mp_x = spr_origin_x-half_char_spr_w, mp_y = spr_origin_y+half_char_spr_h-icon_h;
		draw_sprite_ext(spr_generic_icon, 0, mp_x+icon_w, mp_y, 2, 2, 0, c_white, 1);
		draw_text_color(mp_x+icon_w, mp_y, global.cur_char.cur_move_points, stat_c, stat_c, stat_c, stat_c,1);
		
		//Draw action point value bottom right:
		var mp_x = spr_origin_x+half_char_spr_w;
		draw_sprite_ext(spr_generic_icon, 1, mp_x-icon_w, mp_y, 2, 2, 0, c_white, 1);
		draw_text_color(mp_x-icon_w, mp_y, global.cur_char.cur_action_points,stat_c, stat_c, stat_c, stat_c,1);
		
		scr_reset_font_align();
	
		//Draw stat information beneath it - hp, mana, morale:
		var stat_i = char_stats.hp_cur, stat_cur, stat_max;
		var stat_bar_w = char_spr_w;
		var stat_bar_h = cur_char_stat_bar_h;
		var stat_bar_origin_x = portrait_offset_x, stat_bar_origin_y = char_spr_h+portrait_offset_y;
		var stat_bar_frame_offset = stat_bar_h / 2, stat_cur_val, stat_max_val;
		
		var stat_bar_num = 1;
		
		repeat(4) {
		
			stat_cur = stat_i;
			stat_max = stat_i+1;
		
			stat_cur_val = global.cur_char.char_stats_ar[stat_cur];
			stat_max_val = global.cur_char.char_stats_ar[stat_max];
		
			//Draw stat bar:
			var stat_c, stat_text = "";
			if stat_i == char_stats.hp_cur { stat_c = c_red; stat_text = "HP"; }
			else if stat_i == char_stats.morale_cur { stat_c = c_white; stat_text = "MORALE"; }
			else if stat_i == char_stats.mana_cur { stat_c = c_blue; stat_text = "MANA"; }
			else if stat_i == char_stats.stam_cur { stat_c = c_yellow; stat_text = "STAMINA"; }
			else stat_c = c_white;
			draw_rectangle_color(stat_bar_origin_x,stat_bar_origin_y,stat_bar_origin_x+(stat_cur_val / stat_max_val)*stat_bar_w,stat_bar_origin_y+stat_bar_h,stat_c,stat_c,stat_c,stat_c,false);
		
			//Draw stat bar frame:
			draw_rectangle_color(stat_bar_origin_x,stat_bar_origin_y,stat_bar_origin_x+stat_bar_w,stat_bar_origin_y+stat_bar_h,c_gray,c_gray,c_gray,c_gray,true);
			
			//Draw the actual text:
			scr_center_font_align();
			draw_text_color(stat_bar_origin_x+stat_bar_w/2,stat_bar_origin_y+stat_bar_h/2,$"{stat_text}: {stat_cur_val}/{stat_max_val}",c_black,c_black,c_black,c_black,1);
			scr_reset_font_align();
			
			stat_i += 2; //Iterate by 2 to jump to the next "stat_cur" stat
		
			//Iterate our stat_bar_origin_y
			stat_bar_origin_y += stat_bar_h+stat_bar_frame_offset;
			
			//Define our action_button_origin_x and y; this works because we run the draw_gui event before calling scr_build_action_buttons at the end of this
			//event with draw_inv_for_load_once, when game first starts
			if stat_bar_num == 4 {
				action_button_origin_x = stat_bar_origin_x+(sprite_get_width(spr_action_button) / 2);
				action_button_origin_y = stat_bar_origin_y+stat_bar_h+stat_bar_frame_offset+(sprite_get_height(spr_action_button) / 2);
			}
			
			stat_bar_num++;
		}
	}
	
	//Now draw the rest of our party:
	if is_array(global.pc_team_ar) && array_length(global.pc_team_ar) > 0 {
		
		var portrait_scale = global.pc_party_portrait_scale;
		var char_struct;
		var char_spr_w = sprite_get_width(asset_get_index("spr_pc_ogre"))*portrait_scale;
		var char_spr_h = sprite_get_height(asset_get_index("spr_pc_ogre"))*portrait_scale;
		var portrait_origin_x = char_spr_w*3;
		var portrait_origin_y = char_spr_h;
		var portrait_offset_x = char_spr_w+16, portrait_offset_y = 16;
		
		//Define which array we're using:
		var ar_to_use = global.pc_team_ar;
		
		if global.cur_game_state == game_state.access_inv && is_array(adjacent_pcs_for_inv_ar) && array_length(adjacent_pcs_for_inv_ar) > 0 {
			ar_to_use = adjacent_pcs_for_inv_ar;
		}
		
		var ar_len = array_length(ar_to_use);
		
		//Iterate through team array:
		for(var i = 0; i < ar_len; i++) {
			
			//Define struct:
			char_struct = ar_to_use[i];
			
			//Don't re-draw the g.cur_char:
			if char_struct == global.cur_char continue;
			
			//Detect mouse hover:
			var char_spr_frame = 0;
			
			/*If our mouse is within the general x and y border of where the current pc party is being displayed;
			Note: The reason this code works as intended, and always selects the character in the party that you want it to, 
			is BECAUSE PORTRAIT_ORIGIN_X CHANGES WITH EACH ITERATION THROUGH OUR ARRAY, AND THEREFORE ONLY EVER COVERS THE 
			AREA ON THE GUI DISPLAY THAT IS DRAWING THE SECTION THAT OUR MOUSE IS CURRENTLY HOVERING OVER. SO WHEN WE CLICK,
			THE CHAR_STRUCT VAR (SET ABOVE) IS ALREADY DEFINED AS THAT CHARACTER.
			*/
			if mouse_win_x >= portrait_origin_x-(char_spr_w / 2) && mouse_win_x <= portrait_origin_x+portrait_offset_x-(char_spr_w / 2) && mouse_win_y <= portrait_origin_y+(char_spr_h / 2) {
				
				char_spr_frame = 1;
				
				#region Change control of the cur_char, either when within main game state or access inv:
				
				if mouse_check_button_released(mb_left) {
					
					//Only allow change if char is in the same dungeon (they always should be):
					if char_struct.cur_dungeon_ind == global.cur_dungeon_ind {
						
						//We've clicked on a char in our party rather than the specified trader, reset game state (game state was previously main):
						if global.cur_game_state = game_state.select_trader {
							global.cur_game_state = game_state.main;	
						}
						
						//If we were trading with an npc trader -- we're not now!
						global.trading_with_npc_struct_id = -1; 
						if instance_exists(o_npc_backpack_slot) instance_destroy(o_npc_backpack_slot);
						
						//Change g.cur_char
						global.cur_char = char_struct;
						
						//If we're in access_inv screen, it's possible the items on ground and inv_ar items have been moved around
						//and/or manipulated, resulting in empty indices in those arrays; TIDY them up to remove this:
						if global.cur_game_state == game_state.access_inv {
							global.cur_char.inv_ar = scr_tidy_ar(global.cur_char.inv_ar);
							global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_INST][# global.cur_char.char_grid_x, global.cur_char.char_grid_y] = scr_tidy_ar(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_INST][# global.cur_char.char_grid_x, global.cur_char.char_grid_y]);	
						}
						
						//If applicable, change floor:
						if global.cur_char.cur_floor_level != global.cur_floor_ind {
							//Define g.cur_floor_ind:
							global.cur_floor_ind = global.cur_char.cur_floor_level;
							
							//Assign terrain_grid and then update terrain tilemap:
							global.terrain_grid = global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN];
							scr_define_tilemap_from_grid(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN],global.terrain_tile_id,"o_con draw gui event: Clicked on a character portrait within the pc_team_ar.");
				
							//Update los and define fow tilemap:
							scr_reset_struct_visibility(global.cur_dungeon_ind,global.cur_floor_ind,"o_con draw gui event: Clicked on a character portrait within the pc_team_ar..");
							scr_reset_fow(global.cur_floor_ind,global.cur_dungeon_ind);
							scr_update_los(global.cur_dungeon_ind, global.cur_floor_ind,"o_con draw gui event: Clicked on a character portrait within the pc_team_ar..");
							scr_update_visibility(global.cur_dungeon_ind, global.cur_floor_ind, "o_con draw gui event: Clicked on a character portrait within the pc_team_ar..");
							scr_define_tilemap_from_grid(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_LOS], global.fow_tile_id,"o_con draw gui event: Clicked on a character portrait within the pc_team_ar..");
						}
						
						//If applicable, reset inv_slot instances:
						if global.cur_game_state == game_state.access_inv {
							scr_setup_equip_slots(global.cur_char);
							scr_setup_backpack_slots(global.cur_char);
						}
						
						//Always change items_on_ground_ar and any applicable items on ground boxes - no two chars can exist on the same cell:
						items_on_ground_ar = -1;
						items_on_ground_ar = scr_build_items_on_ground_ar(global.cur_char);
							
						//Whether or not the items_on_ground_ar was built or not, if we're in the inventory screen, we still want 
						//this char to be able to drop items on the ground if they need to, so we'll create those boxes now;
						if global.cur_game_state == game_state.access_inv {
							scr_setup_items_on_ground_boxes();
						}
						//... However if were in the main game state now, we only want to build the items on ground boxes if
						//its applicable:
						else if global.cur_game_state == game_state.main && is_array(items_on_ground_ar) && array_length(items_on_ground_ar) {
							scr_setup_items_on_ground_boxes();	
						}
						
						//If none of those conditions apply, simply destroy the o items on ground boxes:
						else {
							if instance_exists(o_items_on_ground_box) instance_destroy(o_items_on_ground_box);
							if instance_exists(o_items_on_ground_scroll_button) instance_destroy(o_items_on_ground_scroll_button);
						}
						
						//If this is the main game state and we've just changed the g.cur_char, we need to define their action buttons:
						scr_build_action_buttons(global.cur_char);
					} //End of if this char's cur_dungeon_ind == global.cur_dungeon_ind
				} //End of lmb click
				
				#endregion
			} 
			
			//Draw sprite:
			var char_spr = asset_get_index(char_struct.char_spr_str);
			draw_sprite_ext(char_spr,char_spr_frame,portrait_origin_x,portrait_origin_y,portrait_scale, portrait_scale,0,c_white,1);
			
			//Draw stat information beneath it - hp, mana, morale:
			var stat_i = 0, stat_cur, stat_max;
			var stat_bar_w = char_spr_w; 
			var stat_bar_h = 8;
			var stat_bar_origin_x = portrait_origin_x-(stat_bar_w / 2);
			var stat_bar_origin_y = portrait_origin_y+(char_spr_h / 2)+stat_bar_h / 2;
			var stat_bar_offset_x = portrait_offset_x;
			var stat_bar_offset_y = stat_bar_h / 2, stat_cur_val, stat_max_val;
			var total_stat_bars = 4;
			
			repeat(total_stat_bars) {
		
				stat_cur = stat_i;
				stat_max = stat_i+1;
		
				stat_max_val = char_struct.char_stats_ar[stat_max];
		
				//Draw stat bar:
				var stat_c;
				//hp:
				if stat_i == 0 { stat_c = c_red; stat_cur_val = char_struct.char_stats_ar[char_stats.hp_cur]; stat_max_val = char_struct.char_stats_ar[char_stats.hp_max]; }
				//Mana:
				else if stat_i == 1 { stat_c = c_blue; stat_cur_val = char_struct.char_stats_ar[char_stats.mana_cur]; stat_max_val = char_struct.char_stats_ar[char_stats.mana_max]; }
				//Morale:
				else if stat_i == 2 { stat_c = c_white; stat_cur_val = char_struct.char_stats_ar[char_stats.morale_cur]; stat_max_val = char_struct.char_stats_ar[char_stats.morale_max]; }
				//Morale:
				else if stat_i == 3 { stat_c = c_yellow; stat_cur_val = char_struct.char_stats_ar[char_stats.stam_cur]; stat_max_val = char_struct.char_stats_ar[char_stats.stam_max]; }
				
				//Draw stat bar:
				draw_rectangle_color(stat_bar_origin_x,stat_bar_origin_y,stat_bar_origin_x+(stat_cur_val / stat_max_val)*stat_bar_w,stat_bar_origin_y+stat_bar_h,stat_c,stat_c,stat_c,stat_c,false);
		
				//Draw stat bar frame:
				draw_rectangle_color(stat_bar_origin_x,stat_bar_origin_y,stat_bar_origin_x+stat_bar_w,stat_bar_origin_y+stat_bar_h,c_gray,c_gray,c_gray,c_gray,true);
				
				//Draw the actual text:
				draw_set_font(fnt_std_8); //draw smaller text
				scr_center_font_align();
				draw_text_color(stat_bar_origin_x+stat_bar_w/2,stat_bar_origin_y+stat_bar_h/2,$"{stat_cur_val}/{stat_max_val}",c_black,c_black,c_black,c_black,1)
				scr_reset_font_align();
				draw_set_font(global.default_fnt);
				
				//Iterate our stat_bar_origin_y:
				stat_bar_origin_y += stat_bar_h+stat_bar_offset_y;
				
				//Increment:
				stat_i++;
			}
			
			//Increment our main positional x vars with each iteration that is NOT of a matching g.cur_char:
			portrait_origin_x += portrait_offset_x;
			stat_bar_origin_x += stat_bar_offset_x;
		}
	}
	
} //End of game_state == main

#endregion

#region Draw inventory screen - Draws above main game state:

if global.cur_game_state == game_state.access_inv || global.cur_game_state == game_state.view_stats || global.cur_game_state == game_state.view_bio {
		
	//Draw  background:
	var slot_h = sprite_get_height(spr_inv_frame), slot_w = sprite_get_width(spr_inv_frame);
	var bg_offset_y = 16, bg_offset_x = 16, inner_frame_offset = 8;
	var bg_c = c_gray;
	var bg_max_w = cur_char_spr_origin_x+slot_w*8;
	var bg_y = cur_char_spr_origin_y+(cur_char_stat_bar_h*8)+bg_offset_y+(cur_char_stat_bar_h/2);
	var bg_max_h = bg_y+(slot_h*7);
	
	draw_set_alpha(global.inv_screen_alpha);
	
	//Draw bg:
	draw_rectangle_color(bg_offset_x, bg_y, bg_max_w, bg_y+bg_max_h, bg_c, bg_c ,bg_c, bg_c, false);
	//Draw white inner frame:
	draw_rectangle_color(bg_offset_x+inner_frame_offset, bg_y+inner_frame_offset, bg_max_w-inner_frame_offset, bg_y+bg_max_h-inner_frame_offset, c_white, c_white ,c_white, c_white, true);
	
	draw_set_alpha(1);
	
	#region Draw relevant stat text for the cur_char:
	
	if global.cur_char != -1 && is_struct(global.cur_char) {
		
		draw_set_font(global.char_stats_fnt);
		
		var txt_origin_x = bg_offset_x*2, txt_origin_y = bg_y+bg_offset_y, txt_c = c_white;
		var line_h = string_height("ABCDEFGHIJKLMNOPQRSTUVWXYZ"), i= 0;
		var char = global.cur_char;
		
		if cur_stat_page_int == 0 {
		
			//Name, HP, Mana, Stamina, Morale:
			draw_text_color(txt_origin_x, txt_origin_y,$"{char.char_stats_ar[char_stats.name]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Hit Points: {char.char_stats_ar[char_stats.hp_cur]}/{char.char_stats_ar[char_stats.hp_max]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Mana: {char.char_stats_ar[char_stats.mana_cur]}/{char.char_stats_ar[char_stats.mana_max]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Stamina: {char.char_stats_ar[char_stats.stam_cur]}/{char.char_stats_ar[char_stats.stam_max]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Morale: {char.char_stats_ar[char_stats.morale_cur]}/{char.char_stats_ar[char_stats.morale_max]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
			//Combat related stats: 
		
			//Armor values:
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Head Armor: {char.armor_cur_head} / {char.armor_max_head}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Body Armor: {char.armor_cur_body} / {char.armor_max_body}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Hands Armor: {char.armor_cur_hands} / {char.armor_max_hands}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Feet Armor: {char.armor_cur_feet} / {char.armor_max_feet}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
		
			//melee and ranged to_hit, melee and ranged dmg, 
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Melee Hit: {char.base_melee_tohit_mod}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Melee Dmg: {char.base_melee_min_dmg} - {char.base_melee_max_dmg}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Ranged Hit: {char.base_ranged_tohit_mod}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Ranged Dmg: {char.base_ranged_min_dmg} - {char.base_ranged_max_dmg}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			//Dodge, Crit Chance:
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Dodge: {char.base_evasion}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Crit Chance: {char.cur_crit_chance}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
		
			//Carrying Capacity and Max:
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"C.C./Max: {char.char_stats_ar[char_stats.cur_carrying_capacity]}/{char.char_stats_ar[char_stats.max_carrying_capacity]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
		}
		
		else if cur_stat_page_int == 1 {
			
			//Other stats: strength, wisdom, etc.
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Stats:",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Strength: {char.char_stats_ar[char_stats.cur_str]}/{char.char_stats_ar[char_stats.base_str]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Agility: {char.char_stats_ar[char_stats.cur_agil]}/{char.char_stats_ar[char_stats.base_agil]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Constitution: {char.char_stats_ar[char_stats.cur_con]}/{char.char_stats_ar[char_stats.base_con]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Willpower: {char.char_stats_ar[char_stats.cur_will]}/{char.char_stats_ar[char_stats.base_will]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Intelligence: {char.char_stats_ar[char_stats.cur_int]}/{char.char_stats_ar[char_stats.base_int]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Wisdom: {char.char_stats_ar[char_stats.cur_wis]}/{char.char_stats_ar[char_stats.base_wis]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Perception: {char.char_stats_ar[char_stats.cur_per]}/{char.char_stats_ar[char_stats.base_per]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Charisma: {char.char_stats_ar[char_stats.cur_charisma]}/{char.char_stats_ar[char_stats.base_charisma]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Resistances:",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Crushing: {char.char_stats_ar[char_stats.cur_res_crushing]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Slashing: {char.char_stats_ar[char_stats.cur_res_slashing]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Piercing: {char.char_stats_ar[char_stats.cur_res_piercing]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Arcane: {char.char_stats_ar[char_stats.cur_res_arcane]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Poison: {char.char_stats_ar[char_stats.cur_res_poison]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Ice: {char.char_stats_ar[char_stats.cur_res_ice]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Fire: {char.char_stats_ar[char_stats.cur_res_fire]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Shock: {char.char_stats_ar[char_stats.cur_res_shock]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Light: {char.char_stats_ar[char_stats.cur_res_light]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Dark: {char.char_stats_ar[char_stats.cur_res_dark]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
		}
		
		draw_set_font(global.default_fnt);
		
	}
	
	#endregion
	
	//Draw the 'page' our backpack display (g.cur_char.inv_ar) is currently on:
	var pg_num_x = head_slot_x-(slot_w*2)-(slot_w / 2);
	var pg_num_y = head_slot_y+slot_h*3;
	
	var pg_count = (items_in_backpack_min_range div global.max_backpack_slots_per_page) + 1;
	
	draw_text_color(pg_num_x, pg_num_y,$"Page {pg_count}",c_white, c_white, c_white,c_white, 1);
	
	//Define vars - these are used in scr_setup_backpack_slots and scr_setup_equip_slots:
	if define_positional_vars_once {
		define_positional_vars_once = false;
		
		head_slot_x = bg_max_w-bg_offset_x-(slot_w*2) //bg_offset_x+(bg_max_w / 2);
		head_slot_y = bg_y+inner_frame_offset+slot_h/2;
	
		items_on_ground_inner_frame_offset = inner_frame_offset;
	
		//This is the ORIGIN X AND Y for the BACKGROUND of the items on ground box... It is NOT the origin of the o_items_on_ground_boxes
		//themselves; THAT is defined in scr_setup_items_on_ground_boxes
		items_on_ground_box_y = bg_y+bg_max_h+(cur_char_stat_bar_h*3);
		items_on_ground_box_x = bg_offset_x;
	
		//These are used to draw the BACKGROUND of the items on ground box
		items_on_ground_box_w = (inner_frame_offset*2)+slot_w*9;
		items_on_ground_box_h = (inner_frame_offset*2)+slot_h*3;
	
		//Instance position vars for our o_items_on_ground_scroll_button:
		items_on_ground_scroll_button_x = items_on_ground_box_x+items_on_ground_box_w;
		items_on_ground_scroll_button_y = items_on_ground_box_y;
	
		//Define instance positional vars for when we're drawing our NPC trader screen:
		npc_trader_bg_origin_x = gui_display_w-bg_offset_x-bg_max_w;
		npc_trader_bg_origin_y = bg_y;
		npc_trader_bg_w = bg_max_w;
		npc_trader_bg_h = bg_max_h;
		//We'll just use one of the pc char sprite portraits as a reference:
		var scaled_portrait_spr_w = sprite_get_width(spr_pc_ogre)*global.portrait_scale;
		var scaled_potrait_spr_h = sprite_get_height(spr_pc_ogre)*global.portrait_scale;
		
		var portrait_offset = 16;
		npc_portrait_origin_x = gui_display_w-portrait_offset-(scaled_portrait_spr_w/2);
		npc_portrait_origin_y = (scaled_potrait_spr_h/2)+portrait_offset;
		
		npc_backpack_slot_x = npc_trader_bg_origin_x+npc_trader_bg_w-(bg_offset_x+(slot_w*4));
		npc_backpack_slot_y = bg_y+inner_frame_offset+slot_h/2;;
	}
	
	//If applicable, draw our NPC (or, later, enemy) portrait sprite and NPC (or, later, enemy) inventory background:
	if is_struct(global.trading_with_npc_struct_id) && global.trading_with_npc_struct_id.struct_enum == struct_type.character {
		
		//Draw npc trader portrait:
		draw_sprite_ext(asset_get_index(global.trading_with_npc_struct_id.char_spr_str), 0, npc_portrait_origin_x, npc_portrait_origin_y, global.portrait_scale, global.portrait_scale, 0, c_white, 1);
		
		var trader_bg_c = c_gray, inner_frame_offset = 8, inner_frame_c = c_white;
		
		draw_set_alpha(global.inv_screen_alpha);
		
		//Draw BG:
		draw_rectangle_color(npc_trader_bg_origin_x,npc_trader_bg_origin_y,
		npc_trader_bg_origin_x+npc_trader_bg_w, npc_trader_bg_origin_y+npc_trader_bg_h,
		trader_bg_c,trader_bg_c,trader_bg_c,trader_bg_c,false);
		
		//Draw inner frame:
		draw_rectangle_color(npc_trader_bg_origin_x+inner_frame_offset,npc_trader_bg_origin_y+inner_frame_offset,
		npc_trader_bg_origin_x+npc_trader_bg_w-inner_frame_offset, npc_trader_bg_origin_y+npc_trader_bg_h-inner_frame_offset,
		inner_frame_c,inner_frame_c,inner_frame_c,inner_frame_c, true);
		
		draw_set_alpha(1);
		
		#region Draw relevant stats for our NPC or enemy along the left hand side:
		
		draw_set_font(global.char_stats_fnt);
		
		var bg_offset_x = 16, bg_offset_y = 16;
		var txt_origin_x = npc_trader_bg_origin_x+bg_offset_x*2;
		var txt_origin_y = npc_trader_bg_origin_y+bg_offset_y, txt_c = c_white;
		var line_h = string_height("ABCDEFGHIJKLMNOPQRSTUVWXYZ"), i= 0;
		var char = global.trading_with_npc_struct_id;
		
		if cur_npc_or_enemy_stat_page_int == 0 {
		
			//Name, HP, Mana, Stamina, Morale:
			draw_text_color(txt_origin_x, txt_origin_y,$"{char.char_stats_ar[char_stats.name]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Hit Points: {char.char_stats_ar[char_stats.hp_cur]}/{char.char_stats_ar[char_stats.hp_max]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Mana: {char.char_stats_ar[char_stats.mana_cur]}/{char.char_stats_ar[char_stats.mana_max]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Stamina: {char.char_stats_ar[char_stats.stam_cur]}/{char.char_stats_ar[char_stats.stam_max]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Morale: {char.char_stats_ar[char_stats.morale_cur]}/{char.char_stats_ar[char_stats.morale_max]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
			//Combat related stats: 
		
			//Armor values:
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Head Armor: {char.armor_cur_head} / {char.armor_max_head}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Body Armor: {char.armor_cur_body} / {char.armor_max_body}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Hands Armor: {char.armor_cur_hands} / {char.armor_max_hands}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Feet Armor: {char.armor_cur_feet} / {char.armor_max_feet}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
		
			//melee and ranged to_hit, melee and ranged dmg, 
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Melee Hit: {char.base_melee_tohit_mod}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Melee Dmg: {char.base_melee_min_dmg} - {char.base_melee_max_dmg}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Ranged Hit: {char.base_ranged_tohit_mod}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Ranged Dmg: {char.base_ranged_min_dmg} - {char.base_ranged_max_dmg}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			//Dodge, Crit Chance:
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Dodge: {char.base_evasion}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Crit Chance: {char.cur_crit_chance}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
		
			//Carrying Capacity and Max:
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"C.C./Max: {char.char_stats_ar[char_stats.cur_carrying_capacity]}/{char.char_stats_ar[char_stats.max_carrying_capacity]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
		}
		
		else if cur_stat_page_int == 1 {
			
			//Other stats: strength, wisdom, etc.
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Stats:",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Strength: {char.char_stats_ar[char_stats.cur_str]}/{char.char_stats_ar[char_stats.base_str]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Agility: {char.char_stats_ar[char_stats.cur_agil]}/{char.char_stats_ar[char_stats.base_agil]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Constitution: {char.char_stats_ar[char_stats.cur_con]}/{char.char_stats_ar[char_stats.base_con]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Willpower: {char.char_stats_ar[char_stats.cur_will]}/{char.char_stats_ar[char_stats.base_will]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Intelligence: {char.char_stats_ar[char_stats.cur_int]}/{char.char_stats_ar[char_stats.base_int]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Wisdom: {char.char_stats_ar[char_stats.cur_wis]}/{char.char_stats_ar[char_stats.base_wis]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Perception: {char.char_stats_ar[char_stats.cur_per]}/{char.char_stats_ar[char_stats.base_per]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Charisma: {char.char_stats_ar[char_stats.cur_charisma]}/{char.char_stats_ar[char_stats.base_charisma]}",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Resistances:",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			i++; //Space
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Crushing: {char.char_stats_ar[char_stats.cur_res_crushing]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Slashing: {char.char_stats_ar[char_stats.cur_res_slashing]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Piercing: {char.char_stats_ar[char_stats.cur_res_piercing]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Arcane: {char.char_stats_ar[char_stats.cur_res_arcane]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Poison: {char.char_stats_ar[char_stats.cur_res_poison]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Ice: {char.char_stats_ar[char_stats.cur_res_ice]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Fire: {char.char_stats_ar[char_stats.cur_res_fire]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Shock: {char.char_stats_ar[char_stats.cur_res_shock]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Light: {char.char_stats_ar[char_stats.cur_res_light]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
			draw_text_color(txt_origin_x, txt_origin_y+(line_h*i),$"Dark: {char.char_stats_ar[char_stats.cur_res_dark]}%",txt_c,txt_c,txt_c,txt_c,1);
			i++;
		}
		
		draw_set_font(global.default_fnt);
		
		#endregion
	}
	
	#region Logic for display info boxes in middle of screen:
		
	var hovered_inst = collision_point(mouse_win_x, mouse_win_y, [o_inv_slot, o_backpack_slot, o_items_on_ground_box], false, true);
		
	if hovered_inst != noone || global.mouse_struct_item != -1 {
		
		//Define our lower_box_item - any item in the mouse will always take precedence over an item we may be hovering over:
		var lower_box_item_struct_id = undefined;
		
		//If the inv_slot we are hovering over 
		if hovered_inst != noone && is_struct(hovered_inst.contents_id) && hovered_inst.contents_id.struct_enum == struct_type.item && global.mouse_struct_item == -1 {
			lower_box_item_struct_id = hovered_inst.contents_id;
		}
	
		if is_struct(global.mouse_struct_item) && global.mouse_struct_item.struct_enum == struct_type.item {
			lower_box_item_struct_id = global.mouse_struct_item;
		}
		
		//Draw our lower_box_item, and possibly our comparison item afterwards:
		
		if !is_undefined(lower_box_item_struct_id) {
			
			#region Drawing lower box item:
			
			var inv_slot_w = sprite_get_width(spr_inv_frame), inv_slot_h = sprite_get_height(spr_inv_frame);
			var bg_c = c_gray, lower_box_w = inv_slot_w*5, lower_box_h = inv_slot_h*7, inner_frame_offset = 8;
			var inner_frame_c = c_white;
		
			var lower_box_origin_x = items_on_ground_box_x+items_on_ground_box_w+(inv_slot_w);
			var lower_box_origin_y = items_on_ground_box_y-(inv_slot_h*4);
			
			//Draw with inv_bg transparency:
			draw_set_alpha(global.inv_screen_alpha);
			
			//Change bg color if item is cursed:
			var cursed_bool = false;
			if lower_box_item_struct_id.item_quality_enum == item_quality.cursed cursed_bool = true;
			if cursed_bool bg_c = c_purple;
			
			//Draw bg:
			draw_rectangle_color(lower_box_origin_x, lower_box_origin_y, lower_box_origin_x+lower_box_w, 
			lower_box_origin_y+lower_box_h, bg_c, bg_c, bg_c, bg_c, false);
			
			//Draw white inner frame:
			draw_rectangle_color(lower_box_origin_x+inner_frame_offset, lower_box_origin_y+inner_frame_offset, 
			lower_box_origin_x+lower_box_w-inner_frame_offset, 
			lower_box_origin_y+lower_box_h-inner_frame_offset, 
			inner_frame_c, inner_frame_c, inner_frame_c, inner_frame_c, true);
			
			//Reset alpha:
			draw_set_alpha(1);
			
			//Draw our relevant stats, depending upon the item:
			
			/* Relevant stats:
			
			Always relevant, regardless of item_type:
			Name; Quality: (crude, poor, average, good, excellent); Weight; Gold Value; item_type string
			
			rh or lh weapon (not shield):
			 min/max dmg; toHitMod; 
			 
			rh or lh weapon (shield) || or body, feet, or hands:
			Armor Val; Evasion Val;
			
			Misc inv slot (accesory):
				various stat mods, can figure out later:
			*/
			
			//Always draw our item's sprite in the upper right corner of the box, so we know what we're looking at immediately:
			draw_sprite(asset_get_index(lower_box_item_struct_id.item_spr_str), 0, lower_box_origin_x+lower_box_w-(inner_frame_offset+(inv_slot_w/2)),
			lower_box_origin_y+inner_frame_offset+(inv_slot_h/2) );
			
			//Start drawing stats:
			var line_h = string_height("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
			var lb_stat_origin_x = lower_box_origin_x+inner_frame_offset;
			var lb_stat_origin_y = lower_box_origin_y+inner_frame_offset;
			var i = 0;
			
			//Set text color and font:
			draw_set_color(c_white);
			draw_set_font(fnt_std_14);
			
			//Denote the type of item box we are looking at:
			draw_text(lb_stat_origin_x, lb_stat_origin_y, $"VIEWING ITEM:");
			i++;
			if cursed_bool {
				//Draw cursed text:	
				draw_text_color(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), $"CURSED!",c_red,c_red,c_red,c_red,1);
				i++;
			}
			//Name:
			draw_text(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), $"{lower_box_item_struct_id.item_name}");
			i++;
			//Quality:
			draw_text(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), $"QUALITY: {scr_convert_item_quality_enum_to_str(lower_box_item_struct_id.item_quality_enum)}");
			i++;
			//Item type:
			draw_text(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), $"CLASS: {scr_convert_item_type_to_str(lower_box_item_struct_id.item_weapon_type_enum)}");
			i++;
			//Weight:
			draw_text(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), $"WEIGHT: {lower_box_item_struct_id.weight_val}");
			i++;
			//Value:
			draw_text(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), $"VALUE: {lower_box_item_struct_id.gold_value}");
			i++;
			
			//Now we draw different stats depending upon the item type:
				//Armors:
			if lower_box_item_struct_id.item_weapon_type_enum >= wep_type.cloth && lower_box_item_struct_id.item_weapon_type_enum <= wep_type.plate {
				//Protective value:
				draw_text(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), $"ARMOR: {lower_box_item_struct_id.base_protect_val}");
				i++;
				//Evasion:
				draw_text(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), $"EVASION: {lower_box_item_struct_id.evasion_mod}");
				i++;
			}
				//Weapons:
			else if lower_box_item_struct_id.item_weapon_type_enum >= wep_type.mace && lower_box_item_struct_id.item_weapon_type_enum <= wep_type.firearm {
				//Min-max damage:
				draw_text(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), $"MIN-MAX DMG: {lower_box_item_struct_id.min_dmg}-{lower_box_item_struct_id.max_dmg}");
				i++;
				//ToHit Mod:
				draw_text(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), $"ACCURACY MODIFIER: {lower_box_item_struct_id.to_hit_mod}");
				i++;
			}
				//Misc: various stat mods:
			else if lower_box_item_struct_id.item_weapon_type_enum >= wep_type.misc {
					
			}
			
			//Always end with the description of the item:
			var item_desc_str = lower_box_item_struct_id.description;
			var max_str_w = lower_box_w-(inner_frame_offset*4); //We multiply by 4 b.c with draw_text_ext(), if there is no white-space inside of a particularly long word, it will still run over the max-width
			
			draw_text_ext(lb_stat_origin_x, lb_stat_origin_y+(i*line_h), item_desc_str, line_h, max_str_w);
			
			#endregion
			
			//Determine if we had a applicable item equipped that is necessary to compare this item to:
			var lb_item_inv_slot_type = lower_box_item_struct_id.item_equip_type_enum;
		
			var comparison_equipped_item = -1;
			
			//Logic for rh and lh items will be different; other equip slots are straight-forward, we'll cover this first -
			if lb_item_inv_slot_type == inv_slot.head || lb_item_inv_slot_type == inv_slot.body || lb_item_inv_slot_type == inv_slot.accessory ||
			lb_item_inv_slot_type == inv_slot.feet || lb_item_inv_slot_type == inv_slot.hands {
				comparison_equipped_item = global.cur_char.equip_slot_ar[lb_item_inv_slot_type];
			}
			
			//Logic for rh and lh equipped items:
			else if lb_item_inv_slot_type == inv_slot.rh || lb_item_inv_slot_type == inv_slot.lh {
				
				//We can simply check the right hand to see if there is a equipped weapon there, as two_hand items occupy both hands:
				if lower_box_item_struct_id.is_two_hand == true {
					comparison_equipped_item = global.cur_char.equip_slot_ar[inv_slot.rh];	
				}
				
				//If it's not a 2h weapon, check to see if it's a shield...
				else if lower_box_item_struct_id.item_weapon_type_enum == wep_type.shield {
					
					//If either hand has a shield, use that for comparison:
					if is_struct(global.cur_char.equip_slot_ar[inv_slot.rh]) && global.cur_char.equip_slot_ar[inv_slot.rh].item_weapon_type_enum == wep_type.shield {
						comparison_equipped_item = global.cur_char.equip_slot_ar[inv_slot.rh];
					}
					else if is_struct(global.cur_char.equip_slot_ar[inv_slot.lh]) && global.cur_char.equip_slot_ar[inv_slot.lh].item_weapon_type_enum == wep_type.shield {
						comparison_equipped_item = global.cur_char.equip_slot_ar[inv_slot.lh];
					}
				}
				
				//If it's not a shield, then simply check to see if either hand contains a non-shield item and if it does, 
				//we'll use that, since chars can't dual wield, we'll always find the correct one:
				else {
					if is_struct(global.cur_char.equip_slot_ar[inv_slot.rh]) && global.cur_char.equip_slot_ar[inv_slot.rh].item_weapon_type_enum != wep_type.shield {
						comparison_equipped_item = global.cur_char.equip_slot_ar[inv_slot.rh];	
					}
					else if is_struct(global.cur_char.equip_slot_ar[inv_slot.lh]) && global.cur_char.equip_slot_ar[inv_slot.lh].item_weapon_type_enum != wep_type.shield {
						comparison_equipped_item = global.cur_char.equip_slot_ar[inv_slot.lh];	
					}
				}
			}	
			
			#region Drawing upper box equipped item:
			
			//Alright, we've defined our comparison_equipped_item as an item struct, it's time to draw it,
			//in (almost) the exact same way we drew our lower box item:
			if is_struct(comparison_equipped_item) && comparison_equipped_item.struct_enum == struct_type.item {
				
				var bg_c = c_gray;
				var inner_frame_c = c_white;
				
				//Change bg color if item is cursed:
				var cursed_bool = false;
				if comparison_equipped_item.item_quality_enum == item_quality.cursed cursed_bool = true;
				if cursed_bool bg_c = c_purple;
		
				var upper_box_origin_x = items_on_ground_box_x+items_on_ground_box_w+(inv_slot_w);
				var upper_box_origin_y = lower_box_origin_y-lower_box_h;
			
				//Draw with inv_bg transparency:
				draw_set_alpha(global.inv_screen_alpha);
			
				//Draw bg:
				draw_rectangle_color(upper_box_origin_x, upper_box_origin_y, upper_box_origin_x+lower_box_w, 
				upper_box_origin_y+lower_box_h, bg_c, bg_c, bg_c, bg_c, false);
			
				//Draw white inner frame:
				draw_rectangle_color(upper_box_origin_x+inner_frame_offset, upper_box_origin_y+inner_frame_offset, 
				upper_box_origin_x+lower_box_w-inner_frame_offset, 
				upper_box_origin_y+lower_box_h-inner_frame_offset, 
				inner_frame_c, inner_frame_c, inner_frame_c, inner_frame_c, true);
			
				//Reset alpha:
				draw_set_alpha(1);
			
				//Draw our relevant stats, depending upon the item:
			
				//Always draw our item's sprite in the upper right corner of the box, so we know what we're looking at immediately:
				draw_sprite(asset_get_index(comparison_equipped_item.item_spr_str), 0, upper_box_origin_x+lower_box_w-(inner_frame_offset+(inv_slot_w/2)),
				upper_box_origin_y+inner_frame_offset+(inv_slot_h/2) );
			
				//Start drawing stats:
				var upper_stat_origin_x = upper_box_origin_x+inner_frame_offset;
				var upper_stat_origin_y = upper_box_origin_y+inner_frame_offset;
				var i = 0;
			
				//Set text color and font:
				draw_set_color(c_white);
				draw_set_font(fnt_std_14);
			
				//Denote the type of item box we are looking at:
				draw_text(upper_stat_origin_x, upper_stat_origin_y, $"EQUIPPED ITEM:");
				i++;
				if cursed_bool {
					//Draw cursed text:	
					draw_text_color(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), $"CURSED!",c_red,c_red,c_red,c_red,1);
					i++;
				}
				//Name:
				draw_text(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), $"{comparison_equipped_item.item_name}");
				i++;
				//Quality:
				draw_text(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), $"QUALITY: {scr_convert_item_quality_enum_to_str(comparison_equipped_item.item_quality_enum)}");
				i++;
				//Item type:
				draw_text(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), $"CLASS: {scr_convert_item_type_to_str(comparison_equipped_item.item_weapon_type_enum)}");
				i++;
				//Weight:
				draw_text(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), $"WEIGHT: {comparison_equipped_item.weight_val}");
				i++;
				//Value:
				draw_text(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), $"VALUE: {comparison_equipped_item.gold_value}");
				i++;
			
				//Now we draw different stats depending upon the item type:
					//Armors:
				if comparison_equipped_item.item_weapon_type_enum >= wep_type.cloth && comparison_equipped_item.item_weapon_type_enum <= wep_type.plate {
					//Protective value:
					draw_text(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), $"ARMOR: {comparison_equipped_item.base_protect_val}");
					i++;
					//Evasion:
					draw_text(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), $"EVASION: {comparison_equipped_item.evasion_mod}");
					i++;
				}
					//Weapons:
				else if comparison_equipped_item.item_weapon_type_enum >= wep_type.mace && comparison_equipped_item.item_weapon_type_enum <= wep_type.firearm {
					//Min-max damage:
					draw_text(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), $"MIN-MAX DMG: {comparison_equipped_item.min_dmg}-{comparison_equipped_item.max_dmg}");
					i++;
					//ToHit Mod:
					draw_text(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), $"ACCURACY MODIFIER: {comparison_equipped_item.to_hit_mod}");
					i++;
				}
					//Misc: various stat mods:
				else if comparison_equipped_item.item_weapon_type_enum >= wep_type.misc {
					
				}
			
				//Always end with the description of the item:
				var item_desc_str = comparison_equipped_item.description;
				var max_str_w = lower_box_w-(inner_frame_offset*4); //We multiply by 4 b.c with draw_text_ext(), if there is no white-space inside of a particularly long word, it will still run over the max-width
			
				draw_text_ext(upper_stat_origin_x, upper_stat_origin_y+(i*line_h), item_desc_str, line_h, max_str_w);
			}
			
			#endregion
			
			//Reset color and font:
			draw_set_color(c_black);
			draw_set_font(global.default_fnt);
		}
	}
		
	#endregion
	
}

#endregion

#region Draw our items on ground box frame:

if global.cur_game_state == game_state.main || global.cur_game_state == game_state.access_inv || global.cur_game_state == game_state.view_stats || 
global.cur_game_state == game_state.view_bio {
	
	var draw_bg = false;
	
	if global.cur_game_state == game_state.access_inv draw_bg = true;
	
	if global.cur_game_state == game_state.main && is_array(items_on_ground_ar) && array_length(items_on_ground_ar) > 0 {
		draw_bg = true;	
	}
	
	if draw_bg {
		
		var bg_c = c_gray, inner_frame = c_white, inner_frame_offset = 8;
		draw_set_alpha(global.inv_screen_alpha);
		
		var items_on_ground_pg_count = (items_on_ground_min_range div global.max_items_on_ground_in_box) + 1;
		
		//Draw rectangular background over box title text:
		var title = $"ITEMS AT LOCATION, PAGE {items_on_ground_pg_count}:";
		var title_str_w = string_width(title), title_str_h = string_height(title), title_border = 4;
		var title_offset = 16;
		
		//Draw background behind our title text:
		/*
		draw_rectangle_color(items_on_ground_box_x, items_on_ground_box_y-(title_str_h+title_border), 
		items_on_ground_box_x+(title_str_w+title_border), items_on_ground_box_y, 
		bg_c, bg_c ,bg_c, bg_c, false);
		*/
		
		//Draw text - ITEMS AT LOCATION:
		draw_text_color(items_on_ground_box_x+title_offset,items_on_ground_box_y-(title_str_h/2)-title_offset,title,c_white,c_white,c_white,c_white,1);
		
		//Draw bg:
		draw_rectangle_color(items_on_ground_box_x, items_on_ground_box_y, items_on_ground_box_x+items_on_ground_box_w, 
		items_on_ground_box_y+items_on_ground_box_h, bg_c, bg_c ,bg_c, bg_c, false);
		
		//Draw white inner frame
		draw_rectangle_color(items_on_ground_box_x+inner_frame_offset, items_on_ground_box_y+inner_frame_offset, 
		items_on_ground_box_x+items_on_ground_box_w-inner_frame_offset, 
		items_on_ground_box_y+items_on_ground_box_h-inner_frame_offset, inner_frame, inner_frame ,inner_frame, inner_frame, true);
		draw_set_alpha(1);
	}
	
}

#endregion

#region Draw 'SAVING GAME' over everything else:

if global.cur_game_state == game_state.save_game {
	
	draw_rectangle_color(0,0,win_w,win_h,c_black,c_black,c_black,c_black,false);
	
	draw_set_font(fnt_std_24);
	scr_center_font_align();
	draw_text_color(win_w / 2, win_h / 2,"... SAVING GAME ...",c_white,c_white,c_white,c_white,1);
	scr_reset_font_align();
	draw_set_font(global.default_fnt)
}

#endregion

//Draw fps:
var c = c_lime;
draw_text_color(win_w-128,8,"FPS: "+string(fps_real),c,c,c,c,1);

#region Setup items on ground boxes for first time, if applicable:

if global.cur_game_state == game_state.access_inv && draw_inv_for_load_once {
	draw_inv_for_load_once = false;
	global.cur_game_state = game_state.main;
	items_on_ground_ar = -1;
	if is_struct(global.cur_char) {
		
		//Setup items on ground for the first time:
		items_on_ground_ar = -1;
		items_on_ground_ar = scr_build_items_on_ground_ar(global.cur_char);
		if is_array(items_on_ground_ar) && array_length(items_on_ground_ar) > 0 {
			scr_setup_items_on_ground_boxes();
		}
		
		//Setup action buttons for the first time:
		scr_build_action_buttons(global.cur_char);
	}
}

#endregion

//Draw our global.mouse_item_struct:

if global.mouse_struct_item != -1 && is_struct(global.mouse_struct_item) && global.mouse_struct_item.struct_enum == struct_type.item {
	
	draw_sprite(asset_get_index(global.mouse_struct_item.item_spr_str), 0, mouse_win_x, mouse_win_y);
}

#region If game_state == select_trader - Draw instructions above mouse for player:

if global.cur_game_state == game_state.select_trader {
	
	scr_center_font_align();
	
	var instruction_txt = "SELECT ADJACENT\nFRIENDLY NPC";
	
	var str_h = string_height(instruction_txt);
	
	draw_text_color(mouse_win_x, mouse_win_y-str_h, instruction_txt,c_white,c_white,c_white,c_white,1);
	
	scr_reset_font_align();
	
}

#endregion

#region - Tooltip interactions: increase hover count, display tooltip if applicable:

//Note: I want this code here because I want our tooltips drawn over everything else:

if global.cur_game_state == game_state.main || global.cur_game_state == game_state.access_inv || global.cur_game_state == game_state.view_bio ||
global.cur_game_state == game_state.view_stats {
	
	var button_inst = collision_point(mouse_win_x, mouse_win_y, [o_action_button], false, true);
	
	if button_inst != noone {
		
		global.tooltip_hover_count += delta_time;
		
		if (global.tooltip_hover_count > global.tooltip_hover_max) {
			
			//Define tool tip positional and dimension vars:
			if calc_tooltip_vars_once {
				scr_calc_tooltip_layout(button_inst.tooltip_str);
				calc_tooltip_vars_once = false; //reset
			}
			
			//Actually draw our tooltip:
			draw_set_font(tooltip_fnt); 
			
			var tooltip_c = c_gray, tooltip_frame_c = c_white;
			//Draw gray bg:
		    draw_rectangle_color(tooltip_origin_x, tooltip_origin_y,
		                   tooltip_origin_x + tooltip_w, tooltip_origin_y + tooltip_h, 
						   tooltip_c, tooltip_c, tooltip_c, tooltip_c, false);
			//Draw white frame:
			draw_rectangle_color(tooltip_origin_x, tooltip_origin_y,
		                   tooltip_origin_x + tooltip_w, tooltip_origin_y + tooltip_h, 
						   tooltip_frame_c, tooltip_frame_c, tooltip_frame_c, tooltip_frame_c, true);
			
			draw_text_ext(tooltip_txt_origin_x, tooltip_txt_origin_y, button_inst.tooltip_str, tooltip_line_h, tooltip_w - tooltip_padding * 2 );
			
		    // your draw_text_ext() call using tooltip_text_origin_x/y
		    // wrap width to use: tooltip_w - tooltip_pad * 2
			draw_set_font(global.default_fnt);
		}
	}
	
	//We are not hovering over any applicable button or stat instance...
	else {
		//Reset:
		global.tooltip_hover_count = 0;
		calc_tooltip_vars_once = true;
	}
}

#endregion


