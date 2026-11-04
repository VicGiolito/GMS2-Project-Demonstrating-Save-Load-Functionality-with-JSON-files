
/*


*/

function scr_build_action_buttons(pc_struct_id){
	
	//Reset:
	o_controller.action_button_ar = -1;
	o_controller.action_button_ar = [];
	
	#region Add our 'basic' attack depending upon the first valid weapon we find equipped, if any:
		
		var wep_type_enum = undefined;
		
		//Check rh first:
		if is_struct(pc_struct_id.equip_slot_ar[inv_slot.rh]) && pc_struct_id.equip_slot_ar[inv_slot.rh].struct_enum == struct_type.item {
			if pc_struct_id.equip_slot_ar[inv_slot.rh].item_weapon_type_enum >= wep_type.mace && pc_struct_id.equip_slot_ar[inv_slot.rh].item_weapon_type_enum >= wep_type.firearm {
				if  pc_struct_id.equip_slot_ar[inv_slot.rh].item_weapon_type_enum != wep_type.shield {
					wep_type_enum = pc_struct_id.equip_slot_ar[inv_slot.rh].item_weapon_type_enum;
				}
			}
		}
		//check lh:
		else if is_struct(pc_struct_id.equip_slot_ar[inv_slot.lh]) && pc_struct_id.equip_slot_ar[inv_slot.lh].struct_enum == struct_type.item {
			if pc_struct_id.equip_slot_ar[inv_slot.lh].item_weapon_type_enum >= wep_type.mace && pc_struct_id.equip_slot_ar[inv_slot.lh].item_weapon_type_enum >= wep_type.firearm {
				if  pc_struct_id.equip_slot_ar[inv_slot.lh].item_weapon_type_enum != wep_type.shield {
					wep_type_enum = pc_struct_id.equip_slot_ar[inv_slot.lh].item_weapon_type_enum;
				}
			}
		}
		
		if !is_undefined(wep_type_enum) {
			
			var abil_enum = scr_return_basic_wep_abil_enum_from_wep_type(wep_type_enum);
			
			array_push(o_controller.action_button_ar, abil_enum);
		}
		
	#endregion
	
	#region Check to see if we're adjacent to a valid NPC we can trade with:
	
	var char_struct;
	
	for(var yy = pc_struct_id.char_grid_y-1; yy <= pc_struct_id.char_grid_y+1; yy++) {
		for(var xx = pc_struct_id.char_grid_x-1; xx <= pc_struct_id.char_grid_x+1; xx++) {
			
			char_struct = scr_return_struct_id(xx, yy, struct_type.character, global.cur_floor_ind, global.cur_dungeon_ind);
			
			if is_struct(char_struct) && char_struct.char_stats_ar[char_stats.char_team_enum] == char_team.neutral {
				if is_array(char_struct.inv_ar) && array_length(char_struct.inv_ar)	> 0 {
					array_push(o_controller.action_button_ar, ability.trade_with_npc);	
				}
			}
		}
	}
	
	#endregion
	
	//Iterate through our action_button_ar, instantiating action_button instances as we go:
	var ar_len = array_length(o_controller.action_button_ar), abil_enum_, button_h = sprite_get_height(spr_action_button);
	
	for(var i = 0; i < ar_len; i++){ 
		
		abil_enum_ = o_controller.action_button_ar[i];
		
		with(instance_create_layer(action_button_origin_x, action_button_origin_y+(button_h*i), "layer_action_buttons", o_action_button)) {
			
			ab_title = "undefined";
			
			ab_tooltip = "undefined";
			
			ab_abil_enum = abil_enum_;
			
			abil_struct_id = global.abil_ar[ab_abil_enum];
		}
	}
}