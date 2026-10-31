/// @description o_inv_slot draw sprite on gui layer:

var spr_frame = 0;
	
if collision_point(window_mouse_get_x(), window_mouse_get_y(), self, false, false) == id {
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
		
	draw_sprite(spr_id, spr_frame, x,y);
}
//Just draw the generic inventory frame (its assigned sprite):
else { 
	draw_sprite(sprite_index, spr_frame, x, y);
}
	
//Draw text in the inv frame (head, body, etc.) when there's nothing there:
if inv_slot_type != inv_slot.backpack && contents_id == -1 {
	scr_center_font_align();
	draw_text_color(x,y,equip_slot_str,c_white,c_white,c_white,c_white,.5);
	scr_reset_font_align();
}








