

function scr_remove_from_master_struct_ar(struct_id,dungeon_index,floor_index, called_from_str){
	
	show_debug_message($"Entering scr_remove_from_master_struct_ar: it was called from: {called_from_str}")
	
	if is_array(global.master_struct_ar[dungeon_index]) {
		
		if floor_index < array_length(global.master_struct_ar[dungeon_index]) &&
		is_array(global.master_struct_ar[dungeon_index][floor_index]) {
		
			//Define appropriate team array:
			var team_ar_macro = scr_return_struct_team_macro(struct_id);
		
			if is_array(global.master_struct_ar[dungeon_index][floor_index][team_ar_macro]) {
		
				//Iterate through corresponding array:
				var struct_id_in_ar, ar_len = array_length(global.master_struct_ar[dungeon_index][floor_index][team_ar_macro]);
				for(var i = 0; i < ar_len; i++) {
				
					struct_id_in_ar = global.master_struct_ar[dungeon_index][floor_index][team_ar_macro][i];
				
					if(struct_id_in_ar == struct_id) {
						array_delete(global.master_struct_ar[dungeon_index][floor_index][team_ar_macro],i,1);
						return true;
					}
				}
			}
			else {
				show_debug_message("scr_remove_from_master_struct_ar: No array exists at master_struct_ar location: dungeon_index: "+
				string(dungeon_index)+", floor_index: "+string(floor_index)+", team_array macro: "+string(team_ar_macro) );
		
				show_error("scr_remove_from_master_struct_ar: No array exists at master_struct_ar location: dungeon_index: "+
				string(dungeon_index)+", floor_index: "+string(floor_index)+", team_array macro: "+string(team_ar_macro), true);
				
				return false;	
			}
		}
		else {
			show_debug_message("scr_remove_from_master_struct_ar: No array exists at master_struct_ar location: dungeon_index: "+
			string(dungeon_index)+", floor_index: "+string(floor_index) );
			
			show_error("scr_remove_from_master_struct_ar: No array exists at master_struct_ar location: dungeon_index: "+
			string(dungeon_index)+", floor_index: "+string(floor_index), true);
			
			return false;
		}
	}
	else {
		show_debug_message("scr_remove_from_master_struct_ar: No array exists at master_struct_ar location: dungeon_index: "+
		string(dungeon_index) );
		
		show_error("scr_remove_from_master_struct_ar: No array exists at master_struct_ar location: dungeon_index: "+
		string(dungeon_index), true);
		
		return false;
	}
	
	show_debug_message("scr_remove_from_master_struct_ar: we iterated through the corresponding array and did not finding the matching struct to remove. Returning false.");
	
	show_error("scr_remove_from_master_struct_ar: No array exists at master_struct_ar location: dungeon_index: "+
	string(dungeon_index), true)
	
	return false;
}