/// @description o_con Draw gui event

var win_w = window_get_width(), win_h = window_get_height();

#region Main game state - Draw debug information:

if global.cur_game_state == game_state.main {
	
	var title_y_buff = 16;

	scr_center_font_align();

	draw_text(win_w / 2, title_y_buff,string(level_type_str_ar[global.cur_dungeon_ind])+", FLOOR: "+string(global.cur_floor_ind) );

	scr_reset_font_align();

	var debug_str = "UNDEFINED";
	if debug_place_struct == 1 debug_str = "CHAR";
	else if debug_place_struct == 2 debug_str = "ITEM";
	else if debug_place_struct == 3 debug_str = "BUILDING";

	draw_text_color(win_w-256,24,"PLACING: "+string(debug_str),c_white,c_white,c_white,c_white,1);
}

#endregion

#region Start Menu or debug_new_game_choose_maze_type:

else if global.cur_game_state == game_state.start_menu || global.cur_game_state == game_state.debug_new_game_choose_maze_type {
	
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

#region Game_state == main - Draw our g.cur_char portrait and other party members with stats on top left of screen:

if global.cur_game_state == game_state.main {
	
	//Draw current char, if applicable:
	if global.cur_char != -1 && is_struct(global.cur_char) && global.cur_char.struct_enum == struct_type.character && global.cur_char.char_stats_ar[char_stats.char_team_enum] == char_team.pc {
	
		var portrait_scale = 4;
	
		var char_spr_w = sprite_get_width(global.cur_char.char_sprite)*portrait_scale;
		var char_spr_h = sprite_get_height(global.cur_char.char_sprite)*portrait_scale;
	
		var portrait_offset_x = 16, portrait_offset_y = 16;
	
		var spr_origin_x = char_spr_w / 2+portrait_offset_x, spr_origin_y = char_spr_h / 2+portrait_offset_y;
	
		var mouse_win_x = device_mouse_x_to_gui(0), mouse_win_y = device_mouse_y_to_gui(0);
	
		var mouse_within_portrait = false, spr_frame = 0;
	
		if mouse_win_x <= char_spr_w+portrait_offset_x && mouse_win_y <= char_spr_h+portrait_offset_y {
			mouse_within_portrait = true;
			spr_frame = 1;
		}

		draw_sprite_ext(global.cur_char.char_sprite,spr_frame,spr_origin_x,spr_origin_y,4,4,0,c_white,1);
	
		//Draw stat information beneath it - hp, stam, mana, morale:
		var stat_i = char_stats.hp_cur, stat_cur, stat_max;
		var stat_bar_w = char_spr_w, stat_bar_h = 16;
		var stat_bar_origin_x = portrait_offset_x, stat_bar_origin_y = char_spr_h+portrait_offset_y;
		var stat_bar_frame_offset = stat_bar_h / 2, stat_cur_val, stat_max_val;
	
		repeat(4) {
		
			stat_cur = stat_i;
			stat_max = stat_i+1;
		
			stat_cur_val = global.cur_char.char_stats_ar[stat_cur];
			stat_max_val = global.cur_char.char_stats_ar[stat_max];
		
			//Draw stat bar:
			var stat_c;
			if stat_i == char_stats.hp_cur stat_c = c_red;
			else if stat_i == char_stats.stam_cur stat_c = c_yellow;
			else if stat_i == char_stats.mana_cur stat_c = c_blue;
			else stat_c = c_white;
			draw_rectangle_color(stat_bar_origin_x,stat_bar_origin_y,stat_bar_origin_x+(stat_cur_val / stat_max_val)*stat_bar_w,stat_bar_origin_y+stat_bar_h,stat_c,stat_c,stat_c,stat_c,false);
		
			//Draw stat bar frame:
			draw_rectangle_color(stat_bar_origin_x,stat_bar_origin_y,stat_bar_origin_x+stat_bar_w,stat_bar_origin_y+stat_bar_h,c_gray,c_gray,c_gray,c_gray,true);
		
			stat_i += 2; //Iterate by 2 to jump to the next "stat_cur" stat
		
			//Iterate our stat_bar_origin_y
			stat_bar_origin_y += stat_bar_h+stat_bar_frame_offset;
		}
	}
	
	//Now draw the rest of our party:
	if is_array(global.pc_team_ar) && array_length(global.pc_team_ar) > 0 {
		
		var ar_len = array_length(global.pc_team_ar), portrait_scale = 2;
		var char_struct;
		var char_spr_w = sprite_get_width(asset_get_index("spr_pc_ogre"))*portrait_scale;
		var char_spr_h = sprite_get_height(asset_get_index("spr_pc_ogre"))*portrait_scale;
		var portrait_origin_x = char_spr_w*3;
		var portrait_origin_y = char_spr_h;
		var portrait_offset_x = char_spr_w+16, portrait_offset_y = 16;
		//Mouse gui vars:
		var mouse_win_x = device_mouse_x_to_gui(0), mouse_win_y = device_mouse_y_to_gui(0);
		
		//Iterate through team array:
		for(var i = 0; i < ar_len; i++) {
			
			//Define struct:
			char_struct = global.pc_team_ar[i];
			
			//Don't re-draw the g.cur_char:
			if char_struct == global.cur_char continue;
			
			//Detect mouse hover:
			var char_spr_frame = 0;
	
			if mouse_win_x >= portrait_origin_x-(char_spr_w / 2) && mouse_win_x <= portrait_origin_x+portrait_offset_x-(char_spr_w / 2) && mouse_win_y <= portrait_origin_y+(char_spr_h / 2) {
				char_spr_frame = 1;
				if mouse_check_button_released(mb_left) {
					
					//Only allow change if char is in the same dungeon (they always should be):
					if char_struct.cur_dungeon_ind == global.cur_dungeon_ind {
						
						//Change g.cur_char
						global.cur_char = char_struct;
					
						//If applicable, change floor:
						if global.cur_char.cur_floor_level != global.cur_floor_ind {
							//Define g.cur_floor_ind:
							global.cur_floor_ind = global.cur_char.cur_floor_level;
							//Assign terrain_grid and then update tilemap:
							global.terrain_grid = global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN];
							scr_define_tilemap_from_grid(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_TERRAIN],global.terrain_tile_id,"o_con draw gui event: Clicked on a character portrait within the pc_team_ar.");
				
							//Update los and define fow tilemap:
							scr_reset_fow(global.cur_floor_ind,global.cur_dungeon_ind);
							scr_update_los(global.cur_dungeon_ind, global.cur_floor_ind,"o_con draw gui event: Clicked on a character portrait within the pc_team_ar.");
							//scr_update_visibility(global.cur_floor_ind, "o_con create event: updating building visibility after changing the floor.");
							scr_define_tilemap_from_grid(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_LOS], global.fow_tile_id,"o_con draw gui event: Clicked on a character portrait within the pc_team_ar.");
						}
					}
				}
			} 
			
			//Draw sprite:
			draw_sprite_ext(char_struct.char_sprite,char_spr_frame,portrait_origin_x,portrait_origin_y,portrait_scale, portrait_scale,0,c_white,1);
			
			//Draw stat information beneath it - hp, stam, mana, morale:
			var stat_i = char_stats.hp_cur, stat_cur, stat_max;
			var stat_bar_w = char_spr_w; 
			var stat_bar_h = 8;
			var stat_bar_origin_x = portrait_origin_x-(stat_bar_w / 2);
			var stat_bar_origin_y = portrait_origin_y+(char_spr_h / 2)+stat_bar_h / 2;
			var stat_bar_offset_x = portrait_offset_x;
			var stat_bar_offset_y = stat_bar_h / 2, stat_cur_val, stat_max_val;
			
			repeat(4) {
		
				stat_cur = stat_i;
				stat_max = stat_i+1;
		
				stat_cur_val = char_struct.char_stats_ar[stat_cur];
				stat_max_val = char_struct.char_stats_ar[stat_max];
		
				//Draw stat bar:
				var stat_c;
				if stat_i == char_stats.hp_cur stat_c = c_red;
				else if stat_i == char_stats.stam_cur stat_c = c_yellow;
				else if stat_i == char_stats.mana_cur stat_c = c_blue;
				else stat_c = c_white;
				draw_rectangle_color(stat_bar_origin_x,stat_bar_origin_y,stat_bar_origin_x+(stat_cur_val / stat_max_val)*stat_bar_w,stat_bar_origin_y+stat_bar_h,stat_c,stat_c,stat_c,stat_c,false);
		
				//Draw stat bar frame:
				draw_rectangle_color(stat_bar_origin_x,stat_bar_origin_y,stat_bar_origin_x+stat_bar_w,stat_bar_origin_y+stat_bar_h,c_gray,c_gray,c_gray,c_gray,true);
		
				stat_i += 2; //Iterate by 2 to jump to the next "stat_cur" stat
		
				//Iterate our stat_bar_origin_y:
				stat_bar_origin_y += stat_bar_h+stat_bar_offset_y;
			}
			
			//Increment our main positional x vars with each iteration that is NOT of a matching g.cur_char:
			portrait_origin_x += portrait_offset_x;
			stat_bar_origin_x += stat_bar_offset_x;
		}
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







