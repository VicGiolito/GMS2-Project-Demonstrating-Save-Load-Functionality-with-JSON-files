/// @description draw sprite in draw gui event

if sprite_index != -1 {
	
	draw_self();
	
	if collision_point(window_mouse_get_x(),window_mouse_get_y(),self,false,false) == id {
		image_index = 1;
	}
	else { 
		image_index = 0;	
	}
}





