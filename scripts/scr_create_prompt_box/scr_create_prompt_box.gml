

function scr_create_prompt_box(prompt_box_type_enum){
	
	var win_w = window_get_width(), win_h = window_get_height();
	
	if prompt_box_type_enum == prompt_box_type.create_new_game {
		prompt_box_w = win_w / 2;
		prompt_box_h = 512;
		prompt_box_origin_x = win_w / 2;
		prompt_box_origin_y = win_h / 2;
		
		
	}
	else {
		show_error($"scr_create_prompt_box: prompt_box_type_enum {prompt_box_type_enum} not captured by our if-else cases.",true);		
	}
	
	
}