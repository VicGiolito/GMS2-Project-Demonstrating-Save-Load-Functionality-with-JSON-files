/// @description o_inv_slot draw sprite on gui layer:

if sprite_index != -1 {
	
	var spr_frame = 0;
	
	if collision_point(display_mouse_get_x(),display_mouse_get_y(),o_inv_slot,false,false) == id {
		spr_frame = 1;
	}
	
	//Define the text for the corresponding equip slot:
	var equip_slot_str = "";
	if inv_slot_type == inv_slot.head equip_slot_str = "HEAD";
	else if inv_slot_type == inv_slot.body equip_slot_str = "BODY";
	else if inv_slot_type == inv_slot.lh equip_slot_str = "L.HAND";
	else if inv_slot_type == inv_slot.rh equip_slot_str = "R.HAND";
	else if inv_slot_type == inv_slot.hands equip_slot_str = "GLOVES";
	else if inv_slot_type == inv_slot.feet equip_slot_str = "FEET";
	else if inv_slot_type == inv_slot.accessory equip_slot_str = "MISC.";
	
	//If applicable, draw the item's sprite:
	if contents_id != -1 && is_struct(contents_id) {
		
		var spr_id = asset_get_index(contents_id.item_spr_str);
		
		draw_sprite(spr_id,spr_frame,x,y);
	}
	else { //Just draw the generic inventory frame:
		draw_sprite(spr_inv_frame, spr_frame, x, y);
	}
	
	//Draw text above the inv frame, if they happen to overlap:
	if inv_slot_type != inv_slot.backpack {
		scr_center_font_align();
		draw_text_color(x,y,equip_slot_str,c_white,c_white,c_white,c_white,.5);
		scr_reset_font_align();
	}
}







