
/* Very simple, could conceivable even use this for an ability like chain lightning or something:

designed to be used with structs

struct_type_ must == one of the struct_type enums: char, building, item, etc.

char_team_ can == any of the char_team enums: pc, enemy, neutral

*/

function scr_define_adjacent_structs_ar(origin_char, struct_type_, struct_team_ = char_team.pc){
	
	if is_struct(origin_char) == false {
		return false;	
	}
	
	var adjacent_char_ar = [];
	
	array_push(adjacent_char_ar, origin_char);
	
	var cur_struct, grid_x, grid_y, found_struct_id;
	
	for(var i = 0; i < array_length(adjacent_char_ar); i++) {
		
		cur_struct = adjacent_char_ar[i];
		
		//Define grid_x and y based upon our struct_type_
		if struct_type_ == struct_type.character {
			grid_x = cur_struct.char_grid_x;
			grid_y = cur_struct.char_grid_y;
		}
		else if struct_type_ == struct_type.building {
			grid_x = cur_struct.building_grid_x;
			grid_y = cur_struct.building_grid_y;	
		}
		else if struct_type_ == struct_type.item {
			grid_x = cur_struct.item_grid_x;
			grid_y = cur_struct.item_grid_y;	
		}
		
		for(var yy = grid_y-1; yy <= grid_y+1; yy++) {
				
			for(var xx = grid_x-1; xx <= grid_x+1; xx++) {
				
				//We can skip this iteration if we're checking the origin coordinates of the cur_struct; in such cases, 
				//that struct has already been added to the array:
				if xx == grid_x && yy == grid_y continue;
				
				//Make sure we're within grid bounds:
				if xx >= 0 && xx < global.grid_w && yy >= 0 && yy < global.grid_h {
					
					found_struct_id = scr_return_struct_id(xx, yy, struct_type_, global.cur_floor_ind, global.cur_dungeon_ind);
					
					//If we found a struct here and it matches our struct type enum...
					if is_struct(found_struct_id) && found_struct_id.struct_enum == struct_type_ {
						
						//Only characters and buildings have 'teams':
						if struct_type_ == struct_type.character && found_struct_id.char_stats_ar[char_stats.char_team_enum] != struct_team_ {
							continue; //Skip the rest of this iteration, this is not a valid add.	
						}
						
						if struct_type_ == struct_type.building && found_struct_id.building_ar[building_stats.team_enum] != struct_team_ {
							continue; //Skip the rest of this iteration, this is not a valid add.		
						}
						
						//If this struct hasn't already been added to our array...
						if scr_return_val_in_ar(adjacent_char_ar, found_struct_id) == -1 {
							//... Add it now:
							array_push(adjacent_char_ar, found_struct_id);
						}
					}
				}	
			}
		}
	}
	
	
	return adjacent_char_ar;
}