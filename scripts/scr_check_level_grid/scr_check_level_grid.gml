
//Returns true if the array and grid structure DOES exist in the g.mater_level_ar;

//returns false otherwise

function scr_check_level_grid(dungeon_ind,floor_ind){
	
	if dungeon_ind < array_length(global.master_level_ar) && is_array(global.master_level_ar[dungeon_ind]) { 
		
		if floor_ind < array_length(global.master_level_ar[dungeon_ind]) && is_array(global.master_level_ar[dungeon_ind][floor_ind]){
			
			if array_length(global.master_level_ar[dungeon_ind][floor_ind]) > 0 && ds_exists(global.master_level_ar[dungeon_ind][floor_ind][GRID_TERRAIN],ds_type_grid) {
				
				show_debug_message("scr_check_level_grid: corresponding arrays and grid exists in g.master_level_ar at dungeon_ind: "+
				string(dungeon_ind)+", floor_ind: "+string(floor_ind)+". Returning true." );
				
				return true;	
			}
		}
	} else {
		show_debug_message($"scr_check_level_grid: an array did not exist at the dungeon_ind: {dungeon_ind} of our g.master_level_ar, which means it was not initialized properly.");
	}
	
	show_debug_message("scr_check_level_grid: corresponding arrays and/or grid did NOT exist in g.master_level_ar at dungeon_ind: "+
	string(dungeon_ind)+", floor_ind: "+string(floor_ind)+". Returning false." );
				
	return false;
}