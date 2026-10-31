
function scr_setup_backpack_slots(char_id, called_from_str = "undefined"){
	
	d($"Entering scr_setup_backpack_slots, it was called from: {called_from_str}");
	
	//Reset o_backpack_slot instances:
	if instance_exists(o_backpack_slot) instance_destroy(o_backpack_slot);
	
	var slot_h = sprite_get_height(spr_inv_frame), slot_w = sprite_get_width(spr_inv_frame);
	
	//First row of backpack slots:
	var backpack_slot_x = head_slot_x-(slot_w*2);
	var backpack_slot_y = head_slot_y+slot_h*4;
	
	var xx = 0, yy = 0;
	var ind = o_controller.items_in_backpack_min_range;
	
	repeat(6) { //Our columns
		
		repeat(4) { //Our rows
			
			with(instance_create_layer(backpack_slot_x+(slot_w*xx),backpack_slot_y+(slot_h*yy),"layer_inv", o_backpack_slot)) {
				
				inv_slot_type = inv_slot.backpack;
				
				slot_ind = ind;
				ind++;
				
				contents_id = -1;
				
				if slot_ind < array_length(char_id.inv_ar) {
					contents_id = char_id.inv_ar[slot_ind];
				}
			}
			
			xx++;
		}
		
		//Increment yy, reset xx:
		yy++;
		xx = 0;
	}
}