/// @description o_display_msg - DRAW GUI

if draw_on_gui_layer == true
{
	draw_set_alpha(alpha_fade_val);
	if !draw_sprite_instead {
		draw_text_color(x,y-y_fade,txt_str,txt_c,txt_c,txt_c,txt_c,alpha_fade_val);
	} else if draw_sprite_instead {
		draw_sprite_ext(txt_str,-1,x,y-y_fade,1,1,0,txt_c,alpha_fade_val);	
	}
	draw_set_alpha(1);

	alpha_fade_val -= scroll_spd;
	if scrolling_boolean y_fade += fade_spd;

	if alpha_fade_val <= 0 instance_destroy();
}

/* Some values to consider:
--Creates an interesting effect when status_box_max_duration == intended_game_spd*6-8, medium length.
status_box_max_duration == intended_game_spd*24, very long effect, still looks interesting.
status_box_max_duration == intended_game_spd*1 - just a blink







