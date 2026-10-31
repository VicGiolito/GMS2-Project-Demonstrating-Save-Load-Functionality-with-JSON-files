/// @description o_backpack_slot draw gui event

var spr_frame = 0;
	
if collision_point(window_mouse_get_x(), window_mouse_get_y(), self, false, false) == id {
	spr_frame = 1;
}
	
//If applicable, draw the item's sprite:
if contents_id != -1 && is_struct(contents_id) {
		
	var spr_id = asset_get_index(contents_id.item_spr_str);
		
	draw_sprite(spr_id,spr_frame,x,y);
}
//Just draw the generic inventory frame (its assigned sprite):
else { 
	draw_sprite(sprite_index, spr_frame, x, y);
}









