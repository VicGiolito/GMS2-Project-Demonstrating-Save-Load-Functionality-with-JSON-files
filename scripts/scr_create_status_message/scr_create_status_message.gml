//if use_sprite_instead_boolean == true, specified_txt_str must == the sprite_resource NOT in string format,
//and txt_c should generally == c_white, unless you want to blend the colors of the sprite with the txt_c color

function scr_create_status_message(room_origin_x,room_origin_y,specified_txt_str,txt_color,txt_scrolling_boolean = true,
draw_on_gui_layer_boolean = false,use_sprite_instead_boolean = false,fade_spd_val = 0.5,scroll_spd_val = 0.001)
{
	var txt_offset_x = string_width(specified_txt_str) / 2;
	
	with(instance_create_layer(room_origin_x-txt_offset_x,room_origin_y,"layer_debug",o_display_msg) )
	{
		scroll_spd = scroll_spd_val;
		fade_spd = fade_spd_val;
		draw_sprite_instead = use_sprite_instead_boolean;
		if draw_sprite_instead == false txt_str = string(specified_txt_str);
		else if draw_sprite_instead == true txt_str = specified_txt_str;
		txt_c = txt_color;
		scrolling_boolean = txt_scrolling_boolean;
		
		if draw_on_gui_layer_boolean draw_on_gui_layer = true;
	}
}