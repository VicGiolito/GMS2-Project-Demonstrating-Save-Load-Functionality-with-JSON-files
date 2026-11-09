
function scr_parse_str_for_main_txt_ar(str_to_parse){
	
	//For the purpose of the string_width function, we need to set the proper font set before calling that function:
	draw_set_font(default_main_txt_fnt);
	
	var temp_str_ar = [];
	var str_char_len = string_length(str_to_parse);
	
	var cur_char_ind = 1, line_start_ind = 1;
	var cur_txt = "", cur_str_w = 0, char_at_ind = "";
	
	while (cur_char_ind <= str_char_len) {
		
		char_at_ind = string_char_at(str_to_parse, cur_char_ind);
		cur_str_w += string_width(char_at_ind);
		
		if (cur_str_w > global.main_txt_max_str_w) {
			
			if (char_at_ind == " ") {
				//Overflowing char is a space: end the line here and drop the space:
				array_push(temp_str_ar, cur_txt);
				cur_char_ind++;
			}
			else {
				//Retreat to previous space, but never past the start of this line:
				var space_ind = cur_char_ind - 1;
				while (space_ind >= line_start_ind && string_char_at(str_to_parse, space_ind) != " ") {
					space_ind--;
				}
				
				if (space_ind >= line_start_ind) {
					//Found a space: line is everything before it, resume after it:
					array_push(temp_str_ar, string_copy(str_to_parse, line_start_ind, space_ind - line_start_ind));
					cur_char_ind = space_ind + 1;
				}
				else {
					//No space (word wider than the box): hard break before this char.
					//If cur_txt is empty, one char alone is too wide, so force it in to guarantee progress:
					if (cur_txt == "") {
						cur_txt = char_at_ind;
						cur_char_ind++;
					}
					array_push(temp_str_ar, cur_txt);
				}
			}
			
			//Reset for the next line:
			cur_txt = "";
			cur_str_w = 0;
			line_start_ind = cur_char_ind;
		}
		else {
			cur_txt += char_at_ind;
			cur_char_ind++;
		}
	}
	
	//Push whatever is left over:
	if (cur_txt != "") array_push(temp_str_ar, cur_txt);
	
	//Reset:
	draw_set_font(global.default_fnt);
	
	return temp_str_ar;
}