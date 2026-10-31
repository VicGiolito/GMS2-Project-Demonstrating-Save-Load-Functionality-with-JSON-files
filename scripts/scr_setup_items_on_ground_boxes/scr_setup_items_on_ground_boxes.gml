
function scr_setup_items_on_ground_boxes(){
	
	d("Entering scr_setup_items_on_ground_boxes...");
	
	if is_array(o_controller.items_on_ground_ar) == false {
		d("We called scr_setup_items_on_ground_boxes, but items_on_ground_ar was not an array; returning false.");
		return false;
	}
	
	var ar_len = array_length(o_controller.items_on_ground_ar);
	
	if ar_len == 0 {
		d("We called scr_setup_items_on_ground_boxes, but items_on_ground_ar length was == 0; returning false.");
		return false;	
	}
	
	//Reset slot and button instances:
	if instance_exists(o_items_on_ground_box) instance_destroy(o_items_on_ground_box);
	if instance_exists(o_items_on_ground_scroll_button) instance_destroy(o_items_on_ground_scroll_button);
	
	//Create our scroll buttons:
	if ar_len > global.max_items_on_ground_in_box {
		//Scroll left button:
		with(instance_create_layer(o_controller.items_on_ground_scroll_button_x, o_controller.items_on_ground_box_y, "layer_inv", o_items_on_ground_scroll_button)) {
			scroll_left = true;
			sprite_index = spr_on_ground_scroll_left;
		}
		
		var scroll_button_h = sprite_get_height(spr_on_ground_scroll_left);
		
		//Scroll right button:
		with(instance_create_layer(o_controller.items_on_ground_scroll_button_x, o_controller.items_on_ground_box_y+scroll_button_h, "layer_inv", o_items_on_ground_scroll_button)) {
			scroll_left = false;
			sprite_index = spr_on_ground_scroll_right;
		}
	}
	
	var slot_h = sprite_get_height(spr_inv_frame), slot_w = sprite_get_width(spr_inv_frame);
	var half_slot_h = slot_h / 2, half_slot_w = slot_w / 2;
	
	//up to 27 on one 'page':
	var rows = 9, columns = 3, xx = 0, yy = 0;
	var ind = o_controller.items_on_ground_min_range;
	
	repeat(columns) {
		
		repeat(rows) { //Our rows
			
			with(instance_create_layer(o_controller.items_on_ground_box_x+half_slot_w+o_controller.items_on_ground_inner_frame_offset+(slot_w*xx), 
			o_controller.items_on_ground_box_y+half_slot_h+o_controller.items_on_ground_inner_frame_offset+(slot_h*yy),
			"layer_inv", o_items_on_ground_box)) {
				
				inv_slot_type = inv_slot.item_on_ground;
				
				slot_ind = ind;
				ind++;
				
				contents_id = -1;
				
				if slot_ind < array_length(o_controller.items_on_ground_ar) {
					
					//It's possible for indices in the items_on_ground_ar to be replaced by non-struct values (such as 0 or -1) when
					//there's nothing in that slot as items get lifted and moved around, so we need to make sure there's
					//actually an item in this position:
					if is_struct(o_controller.items_on_ground_ar[slot_ind]) && o_controller.items_on_ground_ar[slot_ind].struct_enum == struct_type.item {
					
						contents_id = o_controller.items_on_ground_ar[slot_ind];
					}
				}
			}
			
			xx++;
		}
		
		//Increment yy, reset xx:
		yy++;
		xx = 0;
	}
	
	return true;
}