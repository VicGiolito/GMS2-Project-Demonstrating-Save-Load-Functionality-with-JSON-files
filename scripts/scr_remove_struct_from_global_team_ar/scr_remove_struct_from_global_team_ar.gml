

function scr_remove_struct_from_global_team_ar(struct_id){
	
	var struct_name = scr_return_struct_name(struct_id);
	
	var global_team_ar;
	
	if struct_id.struct_enum == struct_type.character {
		if struct_id.char_stats_ar[char_stats.char_team_enum] == char_team.pc global_team_ar = global.pc_team_ar;
		else if struct_id.char_stats_ar[char_stats.char_team_enum] == char_team.enemy global_team_ar = global.enemy_team_ar;
		else global_team_ar = global.neutral_team_ar;
	}
	else if struct_id.struct_enum == struct_type.item { global_team_ar = global.master_item_ar; }
	else if struct_id.struct_enum == struct_type.loot_drop { global_team_ar = global.loot_drop_ar; }
	else if struct_id.struct_enum == struct_type.building {
		if struct_id.building_ar[building_stats.team_enum] == char_team.pc global_team_ar = global.pc_building_team_ar;
		else if struct_id.building_ar[building_stats.team_enum] == char_team.enemy global_team_ar = global.enemy_building_team_ar;
		else global_team_ar = global.neutral_building_team_ar;
	}
	
	var ar_len = array_length(global_team_ar), struct_id_in_ar;
	for(var i = 0; i < ar_len; i++) {
		struct_id_in_ar = global_team_ar[i];
		
		if struct_id_in_ar == struct_id {
			array_delete(global_team_ar,i,1);
			show_debug_message($"scr_remove_struct_from_global_team_ar: struct with name of: {struct_name} successfully removed from its corresponding global team array.");
			return true;
		}
	}
	
	show_error($"scr_remove_struct_from_global_team_ar: failed to remove struct with name of : {struct_name} from one of our corresponding global team arrays, it was not captured by our if-else cases, something went wrong.",true);
	
	return false;
}