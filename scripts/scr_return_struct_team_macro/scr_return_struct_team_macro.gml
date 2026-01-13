

function scr_return_struct_team_macro(struct_id){
	
	var team_macro;
	
	if struct_id.struct_enum == struct_type.character {
		if struct_id.char_stats_ar[char_stats.char_team_enum] == char_team.pc team_macro = AR_PC;
		else if struct_id.char_stats_ar[char_stats.char_team_enum] == char_team.enemy team_macro = AR_ENEMY;
		else team_macro = AR_NEUTRAL;
	}
	else if struct_id.struct_enum == struct_type.item { team_macro = AR_ITEMS; }
	else if struct_id.struct_enum == struct_type.loot_drop { team_macro = AR_BUILDING_NEUTRAL; }
	else if struct_id.struct_enum == struct_type.building {
		if struct_id.building_ar[building_stats.team_enum] == char_team.pc team_macro = AR_BUILDING_PC;
		else if struct_id.building_ar[building_stats.team_enum] == char_team.enemy team_macro = AR_BUILDING_ENEMY;
		else if struct_id.building_ar[building_stats.team_enum] == char_team.neutral team_macro = AR_BUILDING_NEUTRAL;
	}
	
	return team_macro;
}