
function scr_setup_backpack_slots(char_id){
	
	var slot_h = sprite_get_height(spr_inv_frame), slot_w = sprite_get_width(spr_inv_frame);
	
	//First row of backpack slots:
	var backpack_slot_x = head_slot_x-slot_w, backpack_slot_y = head_slot_y+slot_h*3;
	var xx = 0, yy = 0, ind = 0;
	repeat(7) {
		
		repeat(3) {
			
			with(instance_create_layer(backpack_slot_x+(slot_w*xx),backpack_slot_y+(slot_h*yy),"layer_inv",o_inv_slot)) {
				
				inv_slot_type = equip_slot.backpack;
				
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