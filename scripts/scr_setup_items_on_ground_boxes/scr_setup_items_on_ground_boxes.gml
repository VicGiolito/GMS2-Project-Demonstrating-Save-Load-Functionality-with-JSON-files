
function scr_setup_items_on_ground_boxes(){
	
	d("Entering scr_setup_items_on_ground_boxes NOW!");
	
	if is_array(items_on_ground_ar) == false {
		d("We called scr_setup_items_on_ground_boxes, but items_on_ground_ar was not an array; returning false.");
		return false;
	}
	
	var slot_h = sprite_get_height(spr_inv_frame), slot_w = sprite_get_width(spr_inv_frame);
	var half_slot_h = slot_h / 2, half_slot_w = slot_w / 2;
	
	//up to 27 on one 'page':
	var rows = 9, columns = 3, xx = 0, yy = 0, ind = 0;
	
	repeat(columns) {
		
		repeat(rows) { //Our rows
			
			with(instance_create_layer(items_on_ground_box_x+half_slot_w+items_on_ground_inner_frame_offset+(slot_w*xx), 
			items_on_ground_box_y+half_slot_h+items_on_ground_inner_frame_offset+(slot_h*yy),"layer_inv",o_items_on_ground_box)) {
				
				inv_slot_type = inv_slot.item_on_ground;
				
				slot_ind = ind;
				ind++;
				
				contents_id = -1;
				
				if slot_ind < array_length(o_controller.items_on_ground_ar) {
					contents_id = o_controller.items_on_ground_ar[slot_ind];
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