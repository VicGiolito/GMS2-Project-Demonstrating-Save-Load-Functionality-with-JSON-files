
/*


*/

function scr_build_action_buttons(pc_struct_id){
	
	//Reset:
	o_controller.action_button_ar = -1;
	o_controller.action_button_ar = [];
	
	if instance_exists(o_action_button) instance_destroy(o_action_button);
	
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
	
	#region Go through our char's ability_ar and add any abilities that are unique to them:
	
	if is_array(pc_struct_id.ability_ar) && array_length(pc_struct_id.ability_ar) > 0 {
		
		for(var i = 0; i < array_length(pc_struct_id.ability_ar); i++) {
			array_push(o_controller.action_button_ar, pc_struct_id.ability_ar[i]);	
		}
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
	var ar_len = array_length(o_controller.action_button_ar), abil_enum_;
	var button_h = sprite_get_height(spr_action_button);
	
	for(var i = 0; i < ar_len; i++){ 
		
		abil_enum_ = o_controller.action_button_ar[i];
		
		with(instance_create_layer(action_button_origin_x, action_button_origin_y+(button_h*i), "layer_action_buttons", o_action_button)) {
			
			ab_title = "undefined";
			
			tooltip_str = "undefined";
			
			ab_abil_enum = abil_enum_;
			
			abil_struct_id = global.abil_ar[ab_abil_enum];
			
			//Some of our structs use stats from a char struct to define their own stats; therefore we have a few methods we call
			//to further define their stats based upon the char_struct_id provided:
			if is_struct(abil_struct_id) && abil_struct_id.struct_enum == struct_type.ability {
			
				if is_struct(global.cur_char) && global.cur_char.struct_enum == struct_type.character {
				
					ab_title = abil_struct_id.abil_name_str;
				
					//Defines the char_* variables for the entire struct! So you need to make sure to reset them afterwards:
					abil_struct_id.define_abil_char_stats(global.cur_char);
				
					tooltip_str = abil_struct_id.abil_tooltip_str;
				
					//Reset them:
					abil_struct_id.reset_abil_char_stats();
				}
			}
		}
	}
}