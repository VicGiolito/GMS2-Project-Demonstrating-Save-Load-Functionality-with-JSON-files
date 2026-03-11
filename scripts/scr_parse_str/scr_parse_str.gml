


function scr_parse_str(parse_type_enum,str_to_parse){

	//First str == w; second == h; 3rd == floor_count, all separated by commas:
	if parse_type_enum == parse_str_type.debug_new_map {
	
		var total_str_len = string_length(str_to_parse);
	
		var char_at_i, store_type_int = 0, map_w_str = "", map_h_str = "", total_floors_int = "";
	
		for(var char_i = 1; char_i <= total_str_len; char_i++) { //char_i must start at 1 because string_char_at() uses 1 as the first index
		
			char_at_i = string_char_at(str_to_parse, char_i);
			
			if char_at_i == "," { store_type_int++; continue; }
			
			if store_type_int == 0 {
				map_w_str += char_at_i;	
			} else if store_type_int == 1 {
				map_h_str += char_at_i;	
			}
			else total_floors_int += char_at_i;
		}
		
		//Convert to ints:
		global.grid_w = int64(map_w_str);
		global.grid_h = int64(map_h_str);
		global.max_floors_on_level = int64(total_floors_int);
		
		show_debug_message("scr_parse_str: parse_type_enum = "+string(parse_type_enum)+", grid_w = "+
		string(global.grid_w)+", grid_h = "+string(global.grid_h)+", max_floors_on_level = "+string(global.max_floors_on_level) );
		
		return true;
	}
	
	//Simply returns a copy of the str_to_parse without any of the forbidden filename characters.
	else if parse_type_enum == parse_str_type.new_save_file_name {
		
		var total_str_len = string_length(str_to_parse);
	
		var char_at_i, new_str = "";
	
		for(var char_i = 1; char_i <= total_str_len; char_i++) { //char_i must start at 1 because string_char_at() uses 1 as the first index
		
			char_at_i = string_char_at(str_to_parse, char_i);
			
			if scr_check_forbidden_filename_char(char_at_i) == false { 
				new_str += char_at_i; 
			}
		}
		
		return new_str;
	}
}