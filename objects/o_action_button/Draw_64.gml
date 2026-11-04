/// @description o_action_button - draw gui event

if sprite_index != -1 {
	
	var spr_frame = 0;
	
	if collision_point(window_mouse_get_x(), window_mouse_get_y(), self, false, false) == id {
		spr_frame = 1;
	}
	
	image_index = spr_frame;
	
	draw_self();
	
	draw_set_font(fnt_std_18);
	scr_center_font_align();
	
	var ab_c = c_white;
	
	draw_text_color(x,y,string(ab_title),ab_c,ab_c,ab_c,ab_c,1);
	
	scr_reset_font_align();
	draw_set_font(global.default_fnt);
}










