/// @description draw sprite on gui layer:

if sprite_index != -1 {
	draw_self();
	
	if collision_point(display_mouse_get_x(),display_mouse_get_y(),o_inv_slot,false,false) == id {
		image_index = 1;
		d("MOUSE HOVERING OVER O_INV_SLOT!");
	}
	else { 
		image_index = 0;	
	}
	
	//If applicable, draw the item's sprite:
	
}







