
/*
should be run from scope of o_con.


*/

function scr_setup_npc_backpack_slots(char_id, called_from_str = "undefined"){
	
	d($"Entering scr_setup_npc_backpack_slots, it was called from: {called_from_str}");
	
	//Reset o_backpack_slot instances:
	if instance_exists(o_npc_backpack_slot) instance_destroy(o_npc_backpack_slot);
	if instance_exists(o_npc_trader_scroll_button) instance_destroy(o_npc_trader_scroll_button);
	if instance_exists(o_cycle_npc_stats_button) instance_destroy(o_cycle_npc_stats_button);
	
	//Define position vars for backpack slots:
	var slot_h = sprite_get_height(spr_inv_frame), slot_w = sprite_get_width(spr_inv_frame);
	var backpack_slot_x = npc_backpack_slot_x;
	var backpack_slot_y = head_slot_y+slot_h*4;
	
	//Create scroll buttons:
		//Left arrow:
	with(instance_create_layer(backpack_slot_x,backpack_slot_y-slot_h*1,"layer_inv",o_npc_trader_scroll_button)) {
		scroll_left = true;
		sprite_index = spr_scroll_left;
	}
		//Right arrow:
	with(instance_create_layer(backpack_slot_x+slot_w*2,backpack_slot_y-slot_h*1,"layer_inv",o_npc_trader_scroll_button)) {
		scroll_left = false;
		sprite_index = spr_scroll_right;
	}
		//Scroll stats:
	instance_create_layer(backpack_slot_x+slot_w,backpack_slot_y-slot_h*1, "layer_inv", o_cycle_npc_stats_button);
	
	var xx = 0, yy = 0;
	var ind = o_controller.items_in_npc_backpack_min_range;
	
	repeat(6) { //Our columns
		
		repeat(4) { //Our rows
			
			with(instance_create_layer(backpack_slot_x+(slot_w*xx),backpack_slot_y+(slot_h*yy),"layer_inv", o_npc_backpack_slot)) {
				
				inv_slot_type = inv_slot.npc_backpack;
				
				slot_ind = ind;
				ind++;
				
				contents_id = -1;
				
				if slot_ind < array_length(char_id.inv_ar) {
					
					//It's possible for indices in the inv_ar to be replaced by non-struct values (such as 0 or -1) when
					//there's nothing in that slot as items get lifted and moved around, so we need to make sure there's
					//actually an item in this position:
					if is_struct(char_id.inv_ar[slot_ind]) && char_id.inv_ar[slot_ind].struct_enum == struct_type.item {
					
						contents_id = char_id.inv_ar[slot_ind];
					}
				}
			}
			
			xx++;
		}
		
		//Increment yy, reset xx:
		yy++;
		xx = 0;
	}
	
}