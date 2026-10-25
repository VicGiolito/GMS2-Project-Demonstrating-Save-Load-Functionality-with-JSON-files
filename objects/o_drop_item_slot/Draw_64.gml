/// @description Insert description here
// You can write your code in this editor

if sprite_index != -1 {
	draw_self();
	
	if collision_point(display_mouse_get_x(),display_mouse_get_y(),o_drop_item_slot,false,false) == id {
		image_index = 1;
	}
	else { 
		image_index = 0;	
	}
}







