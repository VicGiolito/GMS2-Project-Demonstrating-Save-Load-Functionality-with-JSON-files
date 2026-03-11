/// @description o_controller - DRAW EVENT


//Debug: draw our pathing vars as they move through the recursive tracker:

//draw_sprite(spr_debug_pather,0,maze_pather_x*global.cell_size+global.grid_offset_x+global.half_c,
//maze_pather_y*global.cell_size+global.grid_offset_y+global.half_c);

#region Game state == main: Draw our different struct sprites, and cur_frame spr:

//Remember: those structs with their draw_sprite() function executed lowest in this event
//will be drawn over those structs that are higher in this event

if global.cur_game_state == game_state.main || global.cur_game_state == game_state.pc_plotting_path {
	
	#region Go through our building team arrays and display buildings AND loot dorps that are on the current floor:

	if is_array(global.master_struct_ar) {

		var building_struct, team_i = 0, team_ar;

		repeat(3) {
			if team_i == 0 team_ar = global.master_struct_ar[global.cur_dungeon_ind][global.cur_floor_ind][AR_BUILDING_PC];
			else if team_i == 1 team_ar = global.master_struct_ar[global.cur_dungeon_ind][global.cur_floor_ind][AR_BUILDING_ENEMY];
			else team_ar = global.master_struct_ar[global.cur_dungeon_ind][global.cur_floor_ind][AR_BUILDING_NEUTRAL];
			
			if is_array(team_ar) {
			
				var ar_len = array_length(team_ar);
	
				for(var i = 0; i < ar_len; i++){
					building_struct = team_ar[i];
					if is_struct(building_struct) {
						if building_struct.building_sprite != -1 && building_struct.cur_floor_level == global.cur_floor_ind {
							if building_struct.visible_boolean == true {
								//Draw building sprite
								draw_sprite(building_struct.building_sprite,building_struct.sprite_image_index,
								building_struct.building_room_x,building_struct.building_room_y);
							}
						}
					}
				}
			}
	
			team_i++;
		}
	}

	#endregion
	
	#region Go through our pc_team_ar and draw characters on this floor and dungeon:

	if is_array(global.master_struct_ar) {

		var ar_len = array_length(global.master_struct_ar[global.cur_dungeon_ind][global.cur_floor_ind][AR_PC]), char_struct;
	
		for(var i = 0; i < ar_len; i++){
			
			char_struct = global.master_struct_ar[global.cur_dungeon_ind][global.cur_floor_ind][AR_PC][i];
			
			if is_struct(char_struct) {
				if char_struct.char_sprite != -1 && char_struct.cur_floor_level == global.cur_floor_ind {
					if char_struct.visible_boolean == true {
						//Draw char
						draw_sprite(char_struct.char_sprite,char_struct.sprite_image_index,
						char_struct.char_room_x,char_struct.char_room_y);
						//Draw debug:
						draw_set_font(fnt_std_10);
						scr_center_font_align();
						draw_text_color(char_struct.char_room_x,char_struct.char_room_y,string(char_struct.char_grid_x)+
						","+string(char_struct.char_grid_y),c_black,c_black,c_black,c_black,1);
						scr_reset_font_align();
						draw_set_font(global.default_fnt);
					}
				}
			}
		}
	}
	
	#endregion

	#region Go through our revealed_enemies_ar and display enemies that are on the current floor (this will also display revealed neutral chars):

	if is_array(revealed_enemies_ar) {

		var ar_len = array_length(revealed_enemies_ar), enemy_struct;
	
		for(var i = 0; i < ar_len; i++){
	
			enemy_struct = revealed_enemies_ar[i];
	
			if is_struct(enemy_struct) {
				if enemy_struct.char_sprite != -1 && enemy_struct.cur_floor_level == global.cur_floor_ind && 
				enemy_struct.visible_boolean == true {
					//Draw char
					draw_sprite(enemy_struct.char_sprite,enemy_struct.sprite_image_index,
					enemy_struct.char_room_x,enemy_struct.char_room_y);
					//Draw debug:
					draw_set_font(fnt_std_10);
					scr_center_font_align();
					draw_text_color(enemy_struct.char_room_x,enemy_struct.char_room_y,string(enemy_struct.char_grid_x)+
					","+string(enemy_struct.char_grid_y),c_black,c_black,c_black,c_black,1);
					scr_reset_font_align();
					draw_set_font(global.default_fnt);
				}
			}
		}
	}

	#endregion

	#region Draw cur_char frame:

	if is_struct(global.cur_char) {
	
		//show_debug_message("cur_char == char_struct!")
	
		if global.cur_char.visible_boolean == true && global.cur_char.cur_floor_level == global.cur_floor_ind {
		
			//show_debug_message("DRAWING CUR CHAR FRAME!");

			if cur_char_frame_timer < global.intended_game_spd {
				cur_char_frame = 0;	
			} else cur_char_frame = 1;
		
			if cur_char_frame_timer > global.intended_game_spd*2 cur_char_frame_timer = 0;
		
			draw_sprite(spr_cur_char_frame,cur_char_frame,global.cur_char.char_room_x,global.cur_char.char_room_y);
		
			cur_char_frame_timer++;	
		}
							
	}

	#endregion
	
	#region Debug - Draw indication of struct at cell:
	
	var debug_grid = false;
	
	if debug_grid {
	
		if(is_array(global.master_level_ar[global.cur_dungeon_ind]) && is_array(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind]) ) {
		
			if ds_exists(global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_INST],ds_type_grid) {
			
				var cell_val, grid_w = global.grid_w, grid_h = global.grid_h, c = c_white;
				
				draw_set_font(fnt_std_14);
			
				for(var xx = 0; xx < grid_w; xx++) {
					for(var yy = 0; yy < grid_h; yy++) {
						
						cell_val = global.master_level_ar[global.cur_dungeon_ind][global.cur_floor_ind][GRID_INST][# xx,yy];
					
						if is_struct(cell_val) {
							draw_text_color(global.grid_offset_x+(xx*global.cell_size),global.grid_offset_y+(yy*global.cell_size),
							string(cell_val),c,c,c,c,1);	
						}
					}
				}
				
				draw_set_font(global.default_fnt);
			}
		
		}
	}
	
	#endregion

}

#endregion


