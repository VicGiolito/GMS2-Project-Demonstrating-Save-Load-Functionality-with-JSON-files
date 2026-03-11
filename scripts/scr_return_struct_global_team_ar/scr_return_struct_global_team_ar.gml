


function scr_return_struct_global_team_ar(struct_id){
	
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
	
	return global_team_ar;
}