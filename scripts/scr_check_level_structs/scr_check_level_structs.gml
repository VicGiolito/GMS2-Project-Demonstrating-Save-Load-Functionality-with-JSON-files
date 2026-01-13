/* returns true if array structure in g.mater_struct_ar DOES exist

returns false otherwise


*/

function scr_check_level_structs(dungeon_ind,floor_ind){

	if dungeon_ind < array_length(global.master_struct_ar) && is_array(global.master_struct_ar[dungeon_ind]) {
		
		if floor_ind < array_length(global.master_struct_ar[dungeon_ind]) && is_array(global.master_struct_ar[dungeon_ind][floor_ind]) {
			
			if array_length(global.master_struct_ar[dungeon_ind][floor_ind]) > 0 {
			
				show_debug_message("scr_check_level_structs: corresponding arrays exists in g.master_struct_ar at dungeon_ind: "+
				string(dungeon_ind)+", floor_ind: "+string(floor_ind)+". Returning true." );
			
				return true;
			}
		}
	} else {
		show_debug_message($"scr_check_level_structs: an array did not exist at the dungeon_ind: {dungeon_ind} of our g.master_struct_ar, which means it was not initialized properly.");
	}
	
	show_debug_message("scr_check_level_structs: corresponding arrays did NOT exist in g.master_struct_ar at dungeon_ind: "+
	string(dungeon_ind)+", floor_ind: "+string(floor_ind)+". Returning false." );
	
	return false;

}