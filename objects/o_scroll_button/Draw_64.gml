/// @description draw sprite in draw gui event

if sprite_index != -1 {
	draw_self();
	
	if collision_point(display_mouse_get_x(),display_mouse_get_y(),o_inv_slot,false,false) == id {
		image_index = 1;
	}
	else { 
		image_index = 0;	
	}
}





