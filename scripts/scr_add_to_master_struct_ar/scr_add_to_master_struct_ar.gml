

function scr_add_to_master_struct_ar(struct_id,dungeon_index,floor_index, called_from_str){
	
	show_debug_message($"Entering scr_add_to_master_struct_ar: this script was called from {called_from_str}");
	
	if(is_array(global.master_struct_ar[dungeon_index]) && floor_index < array_length(global.master_struct_ar[dungeon_index]) && 
	is_array(global.master_struct_ar[dungeon_index][floor_index]) ) {
		
		var team_ar_macro, struct_name;
		
		//Define appropriate team array:
		if struct_id.struct_enum == struct_type.item {
			team_ar_macro = AR_ITEMS;
			struct_name = struct_id.item_name;
		}
		else if struct_id.struct_enum == struct_type.building {
			if struct_id.char_stats_ar[char_stats.char_team_enum] == char_team.pc {
				team_ar_macro = AR_BUILDING_PC;	
			} else if struct_id.char_stats_ar[char_stats.char_team_enum] == char_team.enemy {
				team_ar_macro = AR_BUILDING_ENEMY;	
			}
			else {
				team_ar_macro = AR_BUILDING_NEUTRAL;	
			}
			struct_name = struct_id.building_ar[building_stats.name];
		}
		else if struct_id.struct_enum == struct_type.character {
			if struct_id.char_stats_ar[char_stats.char_team_enum] == char_team.pc {
				team_ar_macro = AR_PC;	
			} else if struct_id.char_stats_ar[char_stats.char_team_enum] == char_team.enemy {
				team_ar_macro = AR_ENEMY;	
			}
			else {
				team_ar_macro = AR_NEUTRAL;	
			}
			struct_name = struct_id.char_stats_ar[char_stats.name];
		}
		
		if is_array(global.master_struct_ar[dungeon_index][floor_index][team_ar_macro]) {
			
			show_debug_message("scr_add_to_master_struct_ar: struct_id with char_name: "+string(struct_name)+" SUCCESSFULLY added to the g.master_struct_ar at: dungeon_index: "+
			string(dungeon_index)+", floor_index: "+string(floor_index)+", team_array macro: "+string(team_ar_macro) );
			
			array_push(global.master_struct_ar[dungeon_index][floor_index][team_ar_macro],struct_id);
			
			return true;
		}
		else {
			show_debug_message("scr_add_to_master_struct_ar: No array exists at master_struct_ar location: dungeon_index: "+
			string(dungeon_index)+", floor_index: "+string(floor_index)+", team_array macro: "+string(team_ar_macro)+" - creating array now and adding struct_id to it with name of: "+string(struct_name) );
			
			global.master_struct_ar[dungeon_index][floor_index][team_ar_macro] = [];
			
			array_push(global.master_struct_ar[dungeon_index][floor_index][team_ar_macro],struct_id);
		
			return true;	
		}
	}
	else {
		show_debug_message("scr_add_to_master_struct_ar: No array exists at master_struct_ar location: dungeon_index: "+
		string(dungeon_index)+", floor_index: "+string(floor_index) );
		
		show_error("scr_add_to_master_struct_ar: No array exists at master_struct_ar location: dungeon_index: "+
		string(dungeon_index)+", floor_index: "+string(floor_index),true );
		
		return false;
	}
	
	show_debug_message("scr_add_to_master_struct_ar: we iterated through the corresponding array and did not finding the matching struct to remove for struct with name: "+string(struct_name)+". Returning false.");
	
	show_error("scr_add_to_master_struct_ar: we iterated through the corresponding array and did not finding the matching struct to remove for struct with name: "+string(struct_name)+". Returning false.", true);
	
	return false;
}