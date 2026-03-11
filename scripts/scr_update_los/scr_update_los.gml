
/* 

--Returns either 0 (false) if no enemies were revealed by this LOS update, or it returns true if
the revealed_enemies_ar was added to, which will be filled with the ids of all enemies revealed by this update

--Important note!: The character's "cur_floor_level" variable must be accurate BEFORE this script is run!

--Important note: we also should really only use this for pcs within the g.master_struct_ar, or perhaps
pc_buildings within the g.master_struct_ar, otherwise the iteration count on this script could get huge,
and there's already a lot of iterating going on in this script.

*/

function scr_update_los(dungeon_int, floor_level_int,called_from_boolean = "undefined", debug_disable_enemy_reveal_boolean = false ){
		
		if !is_undefined(called_from_boolean) {
			show_debug_message("Entering scr_update_los now, script was called from: "+string(called_from_boolean) );
		}
		
		var ar_len = array_length(global.master_struct_ar[dungeon_int][floor_level_int][AR_PC]), pc_struct, pc_grid_x, pc_grid_y, vision_range;
		var grid_w = global.grid_w, grid_h = global.grid_h, char_struct, building_struct, loot_drop_struct;
		var new_enemy_discovered_boolean = false;
			
		for(var i = 0; i < ar_len; i++)
		{
			//Assign pc struct:
			pc_struct = global.master_struct_ar[dungeon_int][floor_level_int][AR_PC][i];
				
			//Assign vision range:				
			vision_range = pc_struct.char_stats_ar[char_stats.cur_vision_radius];
			
			//Define grid coordinates:
			pc_grid_x = pc_struct.char_grid_x;
			pc_grid_y = pc_struct.char_grid_y;
			
			//Plot los lines within the vision range around this instance:
			for(var xx = pc_grid_x-vision_range; xx <= pc_grid_x+vision_range; xx++)
			{
				for(var yy = pc_grid_y-vision_range; yy <= pc_grid_y+vision_range; yy++)
				{
					//Make sure we're within bounds:
					if xx >= 0 && xx < grid_w && yy >= 0 && yy < grid_h {
							
						//Only bother doing any of this if the cell we are checking hasn't already
						//been switched to VISIBLE by another pc:
						if global.master_level_ar[dungeon_int][floor_level_int][GRID_LOS][# xx,yy] != LOS_VISIBLE { 
							//Even if 'blinded', pcs should always be able to see the same cell they are on;
							//just mark it visible and continue to next iteration:
							if xx == pc_grid_x && yy == pc_grid_y {
								//Set tilemap:
								tilemap_set(global.fow_tile_id,LOS_VISIBLE,xx,yy);
								//Set grid:
								global.master_level_ar[dungeon_int][floor_level_int][GRID_LOS][# xx,yy] = LOS_VISIBLE;
								continue;
							}
							
							/*Otherwise, perform los_line check; scr_plot_line will transform cells to VISIBLE if
							applicable or, if more than 1 obstacle is encountered along its line, it will
							prematurely break, causing that cell to reamin as FOW or shroud */
							scr_plot_los_line(pc_grid_x,pc_grid_y,xx,yy, floor_level_int,dungeon_int);
						}
					}
				}
			} //End of iterating through vision range for this pc
		
		} //End of iterating through pc_team_ar
		
		#region Add newly revealed enemies to our revealed_enemies_ar:
		
		/* Unfortunately, it's necessary to iterate through all of our LOS_VISIBLE cells AGAIN, because of the 
		unavoidable way that lines are plotted with scr_plot_los_line, the cell that we are checking may not be
		turned to visible until we are checking a DIFFERENT cell; which makes revealing enemies this way inconsistent.
		*/
		
		//Only do any of this if our debug_disable_enemy_reveal_boolean == false
		if !debug_disable_enemy_reveal_boolean {
			for(var i = 0; i < ar_len; i++)
			{
				pc_struct = global.master_struct_ar[dungeon_int][floor_level_int][AR_PC][i];
				vision_range = pc_struct.char_stats_ar[char_stats.base_vision_radius];
			
				//Define grid coordinates:
				pc_grid_x = pc_struct.char_grid_x;
				pc_grid_y = pc_struct.char_grid_y;
			
				//Clear the tile_fow according to the vision range around this instance:
				for(var xx = pc_grid_x-vision_range; xx <= pc_grid_x+vision_range; xx++)
				{
					for(var yy = pc_grid_y-vision_range; yy <= pc_grid_y+vision_range; yy++)
					{
						//Make sure we're within bounds:
						if xx >= 0 && xx < grid_w && yy >= 0 && yy < grid_h {
							//If the cell we are checking right is VISIBLE, 
							//then also check to see if an enemy can be revealed there:
							if global.master_level_ar[dungeon_int][floor_level_int][GRID_LOS][# xx,yy] == LOS_VISIBLE {
								
								//Check for buildings to reveal:
								building_struct = scr_return_struct_id(xx,yy,struct_type.building,floor_level_int,dungeon_int);
								
								if building_struct != false {	
									if is_struct(building_struct) {
										building_struct.visible_boolean = true;
									}	
								}
								
								//Check for loot_drop structs to reveal:
								loot_drop_struct = scr_return_struct_id(xx,yy,struct_type.loot_drop,floor_level_int,dungeon_int);
								
								if loot_drop_struct != false {	
									if is_struct(loot_drop_struct) {
										loot_drop_struct.visible_boolean = true;
									}	
								}
								
								//Check for newly revealed enemies to be added to array.
								char_struct = scr_return_struct_id(xx,yy,struct_type.character,floor_level_int,dungeon_int);
								
								if char_struct != false {	
									if is_struct(char_struct) {
										//show_debug_message("scr_update_los: char_struct found at xx:"+string(xx)+", yy:"+string(yy)+" == "+string(char_struct));
										if char_struct.char_stats_ar[char_stats.char_team_enum] != char_team.pc {
											//Check our revealed_enemies_ar to see if they are already in there:
											var duplicate_found = false, revealed_enemies_ar_len = array_length(o_controller.revealed_enemies_ar), enemy_id;
											for(var e_pos = 0; e_pos < revealed_enemies_ar_len; e_pos++) {
												enemy_id = o_controller.revealed_enemies_ar[e_pos];
												if enemy_id == char_struct {
													duplicate_found = true;
													//show_debug_message("scr_update_los: this enemy char_struct was already found in our revealed_enemies_ar; not adding it again.");
													break;
												}
											}
											//If they were not already within the revealed_enemies_ar, then add them now:
											if !duplicate_found {
												array_push(o_controller.revealed_enemies_ar,char_struct);
												char_struct.show_revealed_spr_boolean = true;
												new_enemy_discovered_boolean = true;
												//show_debug_message("scr_update_los: this enemy char_struct was NOT found in our revealed_enemies_ar, adding it now.");
											}
											
										}
									}
								}
							}
						}
					}
				}
			}
		
			#endregion
		
			#region Remove enemies from the revealed_enemies_ar if they are no longer in a VISIBLE cell
		
			//Go through our revealed_enemies_ar, remove any enemies that are now no longer standing in a VISIBLE cell:
			if array_length(o_controller.revealed_enemies_ar) > 0 {
				var ar_len = array_length(o_controller.revealed_enemies_ar), enemy_ar_id, array_changed_boolean = false;
				for(var i = 0; i < ar_len; i++) {
					enemy_ar_id = o_controller.revealed_enemies_ar[i];
			
					if global.master_level_ar[dungeon_int][floor_level_int][GRID_LOS][# enemy_ar_id.char_grid_x,enemy_ar_id.char_grid_y] != LOS_VISIBLE {
						//show_debug_message("scr_update_los: removing enemies from the revealed_enemies_ar if they are no longer standing on a visible cell: at grid_x: "+
						//string(enemy_ar_id.char_grid_x)+", grid_y: "+string(enemy_ar_id.char_grid_y)+", the following enemy id will be from the array: "+string(enemy_ar_id) );
						
						o_controller.revealed_enemies_ar[i] = -1;
						array_changed_boolean = true;
					}
				}
				if array_changed_boolean {
					var temp_ar = [];
					for(var i = 0; i < ar_len; i++) {
						enemy_ar_id = o_controller.revealed_enemies_ar[i];
						if enemy_ar_id != -1 {
							if instance_exists(enemy_ar_id)	{
								array_push(temp_ar,enemy_ar_id);
							}
						}
					}
					//Clear, change:
					o_controller.revealed_enemies_ar = -1;
					o_controller.revealed_enemies_ar = [];
					array_copy(o_controller.revealed_enemies_ar,0,temp_ar,0,array_length(temp_ar) );
					temp_ar = -1;
				}
			}
	} //End of if !debug_disable_enemy_reveal_boolean
	
	#endregion
		
	return new_enemy_discovered_boolean;
}