
//Should be called before scr_setup_backpack_slots.

function scr_setup_equip_slots(char_id){
	
	//Reset inv instances:
	if instance_exists(o_inv_slot) instance_destroy(o_inv_slot);
	if instance_exists(o_drop_item_slot) instance_destroy(o_drop_item_slot);
	if instance_exists(o_scroll_button) instance_destroy(o_scroll_button);
	
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
	
	//LH slot:
	with(instance_create_layer(head_slot_x+slot_w,head_slot_y+slot_h,"layer_inv",o_inv_slot)) {
		inv_slot_type = inv_slot.lh;
		slot_ind = inv_slot_type;
		
		contents_id = char_id.equip_slot_ar[slot_ind];
	}
	
	//Hands
	with(instance_create_layer(head_slot_x-slot_w,head_slot_y+slot_h*2,"layer_inv",o_inv_slot)) {
		inv_slot_type = inv_slot.hands;
		slot_ind = inv_slot_type;
		
		contents_id = char_id.equip_slot_ar[slot_ind];
	}
	
	//Feet
	with(instance_create_layer(head_slot_x,head_slot_y+slot_h*2,"layer_inv",o_inv_slot)) {
		inv_slot_type = inv_slot.feet;
		slot_ind = inv_slot_type;
		
		contents_id = char_id.equip_slot_ar[slot_ind];
	}
	
	//Drop item on to ground slot:
	with(instance_create_layer(head_slot_x,head_slot_y+slot_h*3,"layer_inv",o_drop_item_slot)) {
		
	}
	
	//Left arrow:
	with(instance_create_layer(head_slot_x-slot_w,head_slot_y+slot_h*3,"layer_inv",o_scroll_button)) {
		scroll_left = true;
		sprite_index = spr_scroll_left;
	}
	
	//Right arrow:
	with(instance_create_layer(head_slot_x+slot_w,head_slot_y+slot_h*3,"layer_inv",o_scroll_button)) {
		scroll_left = false;
		sprite_index = spr_scroll_right;
	}
}