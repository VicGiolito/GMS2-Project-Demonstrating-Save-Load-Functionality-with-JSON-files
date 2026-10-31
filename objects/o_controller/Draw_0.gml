/// @description o_controller - DRAW EVENT



//Debug: draw our pathing vars as they move through the recursive tracker:

//draw_sprite(spr_debug_pather,0,maze_pather_x*global.cell_size+global.grid_offset_x+global.half_c,
//maze_pather_y*global.cell_size+global.grid_offset_y+global.half_c);

#region Game state == main: Draw our different struct sprites, and cur_frame spr:

//Remember: those structs with their draw_sprite() function executed lowest in this event
//will be drawn over those structs that are higher in this event

if global.cur_game_state == game_state.main || global.cur_game_state == game_state.pc_plotting_path || 
global.cur_game_state == game_state.access_inv {
	
	#region Go through our building team arrays and display buildings AND loot drops that are on the current floor:
	
	//BUILDING SPRITES: We want our building sprites to be drawn underneath everything else our char sprites and above our item sprites, 
	//which is why we're drawing them here:
	
	if is_array(global.master_struct_ar) {

		var building_struct, team_i = 0, team_ar;

		repeat(3) {
			if team_i == 0 team_ar = global.master_struct_ar[global.cur_dungeon_ind][global.cur_floor_ind][AR_BUILDING_PC];
			else if team_i == 1 team_ar = global.master_struct_ar[global.cur_dungeon_ind][global.cur_floor_ind][AR_BUILDING_ENEMY];
			else team_ar = global.master_struct_ar[global.cur_dungeon_ind][global.cur_floor_ind][AR_BUILDING_NEUTRAL];
			
			if is_array(team_ar) {
			
				var ar_len = array_length(team_ar), building_spr;
	
				for(var i = 0; i < ar_len; i++){
					building_struct = team_ar[i];
					if is_struct(building_struct) {
						if building_struct.building_spr_str != -1 && building_struct.cur_floor_level == global.cur_floor_ind {
							if building_struct.visible_boolean == true {
								building_spr = asset_get_index(building_struct.building_spr_str);
								//Draw building sprite
								draw_sprite(building_spr,0,building_struct.building_room_x,building_struct.building_room_y);
							}
						}
					}
				}
			}
	
			team_i++;
		}
	}

	#endregion
	
	#region Items - we want our items drawn below chars but above buildings - that's why they're drawn here:
	
	//Note: items are drawn at half scale
	
	if ds_exists(global.ds_map_revealed_items_on_grid, ds_type_map) && ds_map_size(global.ds_map_revealed_items_on_grid) > 0 {
		
		//Define first key:
		var key = ds_map_find_first(global.ds_map_revealed_items_on_grid), ar_at_coord, ar_len, item_struct_id;
		
		while (!is_undefined(key)) {
			
			ar_at_coord = global.ds_map_revealed_items_on_grid[? key];
			
			if is_array(ar_at_coord) {
				ar_len = array_length(ar_at_coord);
				item_struct_id = ar_at_coord[0];
				if ar_len > 0 {
					//If this array has a length of 1, draw the corresponding item struct sprite:
					if ar_len == 1 {
						draw_sprite_ext(asset_get_index(item_struct_id.item_spr_str), 0, item_struct_id.item_room_x, item_struct_id.item_room_y, .5, .5, 0, c_white, 1);
					}
					//Just draw our generic 'multiple items' sprite:
					else {
						draw_sprite_ext(spr_item_loot, 0, item_struct_id.item_room_x, item_struct_id.item_room_y, .5, .5, 0, c_white, 1);	
					}
				}	
			}
			
			//Define next key:
			key = ds_map_find_next(global.ds_map_revealed_items_on_grid, key);
		}
	}
	
	#endregion
	
	#region CHARACTERS - We draw these last as they be drawn on top of everything else - Go through our pc_team_ar, neutral_team_ar, 
	//and enemy_team_ar, and draw characters ONLY on this floor and dungeon:

	if is_array(global.master_struct_ar) {
		
		var debug_txt_offset = 32, char_spr;
		
		for(var team_i = AR_PC; team_i <= AR_NEUTRAL; team_i++) {
			
			if is_array(global.master_struct_ar[global.cur_dungeon_ind][global.cur_floor_ind][team_i]) {
				
				var char_ar = global.master_struct_ar[global.cur_dungeon_ind][global.cur_floor_ind][team_i];
				
				var ar_len = array_length(char_ar), char_struct;
				
				for(var char_i = 0; char_i < ar_len; char_i++) {
					
					char_struct = char_ar[char_i];	
					
					if is_struct(char_struct) {
						if char_struct.char_spr_str != -1 && char_struct.cur_floor_level == global.cur_floor_ind {
							if char_struct.visible_boolean == true || team_i == AR_PC {
								
								char_spr = asset_get_index(char_struct.char_spr_str)
								
								//Draw char
								draw_sprite(char_spr, 0, char_struct.char_room_x,char_struct.char_room_y);
								//Draw debug:
								draw_set_font(fnt_std_10);
								scr_center_font_align();
								draw_text_color(char_struct.char_room_x,char_struct.char_room_y-debug_txt_offset,string(char_struct.char_grid_x)+
								","+string(char_struct.char_grid_y),c_black,c_black,c_black,c_black,1);
								scr_reset_font_align();
								draw_set_font(global.default_fnt);
							}
						}
					}
				}
			}
		}
	}
	
	#endregion
	
	#region Draw cur_char blinking green frame:

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


