

function scr_return_struct_name(struct_id){
	
	var struct_name_str;
	
	if struct_id.struct_enum == struct_type.character {
		struct_name_str = struct_id.char_stats_ar[char_stats.name];
	}
	else if struct_id.struct_enum == struct_type.item { struct_name_str = struct_id.item_name; }
	else if struct_id.struct_enum == struct_type.building {
		struct_name_str = struct_id.building_ar[building_stats.name]
	}
	else if struct_id.struct_enum == struct_type.loot_drop struct_name_str = "LOOT DROP";
	
	return struct_name_str;
}