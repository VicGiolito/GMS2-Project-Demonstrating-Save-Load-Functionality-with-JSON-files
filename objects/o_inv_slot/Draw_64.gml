/// @description draw sprite on gui layer:

if sprite_index != -1 {
	draw_self();
	
	if collision_point(display_mouse_get_x(),display_mouse_get_y(),o_inv_slot,false,false) == id {
		image_index = 1;
	}
	else { 
		image_index = 0;	
	}
	
	//If applicable, draw the item's sprite:
	if contents_id != -1 && is_struct(contents_id) {
		
		var spr_id = asset_get_index(contents_id.item_spr_str);
		
		draw_sprite(spr_id,0,x,y);
	}
}







