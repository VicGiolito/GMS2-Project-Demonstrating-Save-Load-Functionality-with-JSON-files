/// @description o_scroll_button - draw sprite in draw gui event

if sprite_index != -1 {
	
	draw_self();
	
	var hovered = false;
	
	if collision_point(window_mouse_get_x(),window_mouse_get_y(),self,false,false) == id {
		image_index = 1;
		hovered = true;
		//d($"WE ARE HOVERING OVER AN INSTANCE OF O_SCROLL_BUTTON WITH ID: {id} AND SCROLL_LEFT VAR: {scroll_left}.");
	}
	else { 
		image_index = 0;	
	}
}





