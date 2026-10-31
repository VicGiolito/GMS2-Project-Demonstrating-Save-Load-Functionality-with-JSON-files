/// @description o_items_on_ground_scroll_button - draw sprite:

if sprite_index != -1 {
	
	draw_self();
	
	var hovered = false;
	
	if collision_point(window_mouse_get_x(),window_mouse_get_y(),self,false,false) == id {
		image_index = 1;
		hovered = true;
	}
	else { 
		image_index = 0;	
	}
	
}





