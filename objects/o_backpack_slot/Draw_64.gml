/// @description o_backpack_slot draw gui event

var spr_frame = 0;
	
if collision_point(window_mouse_get_x(), window_mouse_get_y(), self, false, false) == id {
	spr_frame = 1;
}
	
//If applicable, draw the item's sprite:
if contents_id != -1 && is_struct(contents_id) {
		
	var spr_id = asset_get_index(contents_id.item_spr_str);
		
	draw_sprite(spr_id,spr_frame,x,y);
	
	//If we're currently trading with a npc, also draw the gold value of the item in the upper left,
	//in yellow or orange:
	if is_struct(global.trading_with_npc_struct_id) && global.trading_with_npc_struct_id.struct_enum == struct_type.character {
		var offset = 8, gold_c = c_orange;
		var txt_x = x-(sprite_get_width(spr_id)/2)+offset;
		var txt_y = y-(sprite_get_height(spr_id)/2)+offset;
		
		draw_text_color(txt_x, txt_y, string(contents_id.gold_value),gold_c,gold_c,gold_c,gold_c,1);
	}
}
//Just draw the generic inventory frame (its assigned sprite):
else { 
	draw_sprite(sprite_index, spr_frame, x, y);
}









