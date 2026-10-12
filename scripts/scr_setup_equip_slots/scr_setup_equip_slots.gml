
function scr_setup_equip_slots(char_id){
	
	var slot_h = sprite_get_height(spr_inv_frame), slot_w = sprite_get_width(spr_inv_frame);
	
	//Create head slot:
	with(instance_create_layer(head_slot_x,head_slot_y,"layer_inv",o_inv_slot)) {
		inv_slot_type = inv_slot.head;
		slot_ind = inv_slot_type;
		
		contents_id = char_id.equip_slot_ar[slot_ind];
	}
	
	//Create accessory slot:
	with(instance_create_layer(head_slot_x+slot_w,head_slot_y,"layer_inv",o_inv_slot)) {
		inv_slot_type = inv_slot.accessory;
		slot_ind = inv_slot_type;
		
		contents_id = char_id.equip_slot_ar[slot_ind];
	}
	
	//Body slot:
	with(instance_create_layer(head_slot_x,head_slot_y+slot_h,"layer_inv",o_inv_slot)) {
		inv_slot_type = inv_slot.body;
		slot_ind = inv_slot_type;
		
		contents_id = char_id.equip_slot_ar[slot_ind];
	}
	
	//RH slot:
	with(instance_create_layer(head_slot_x-slot_w,head_slot_y+slot_h,"layer_inv",o_inv_slot)) {
		inv_slot_type = inv_slot.rh;
		slot_ind = inv_slot_type;
		
		contents_id = char_id.equip_slot_ar[slot_ind];
	}
	
	//RH slot:
	with(instance_create_layer(head_slot_x+slot_w,head_slot_y+slot_h,"layer_inv",o_inv_slot)) {
		inv_slot_type = inv_slot.rh;
		slot_ind = inv_slot_type;
		
		contents_id = char_id.equip_slot_ar[slot_ind];
	}
	
	//Left arrow (placeholder):
	with(instance_create_layer(head_slot_x-slot_w,head_slot_y+slot_h*2,"layer_inv",o_scroll_button)) {
		scroll_dir_ = scroll_dir.left;
		sprite_index = spr_scroll_left;
	}
	
	//Right arrow (placeholder):
	with(instance_create_layer(head_slot_x+slot_w,head_slot_y+slot_h*2,"layer_inv",o_scroll_button)) {
		scroll_dir_ = scroll_dir.right;
		sprite_index = spr_scroll_right;
	}
}