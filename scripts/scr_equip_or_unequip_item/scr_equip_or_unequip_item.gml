

function scr_equip_or_unequip_item(char_struct_id, item_struct_id, equip_boolean, called_from_str = "undefined"){
	
	var addition_multiplier = 1;
	
	if equip_boolean == false addition_multiplier = -1;
	
	//Weapon or shield:
	if item_struct_id.item_equip_type_enum == inv_slot.rh || item_struct_id.item_equip_type_enum == inv_slot.lh {
		
		char_struct_id.base_melee_min_dmg += item_struct_id.melee_min_dmg*addition_multiplier;
		char_struct_id.base_melee_max_dmg += item_struct_id.melee_max_dmg*addition_multiplier;
		
		char_struct_id.base_ranged_min_dmg += item_struct_id.ranged_min_dmg*addition_multiplier;
		char_struct_id.base_ranged_max_dmg += item_struct_id.ranged_max_dmg*addition_multiplier;
		
		char_struct_id.base_melee_tohit_mod += item_struct_id.melee_to_hit_mod*addition_multiplier;
		
		char_struct_id.base_ranged_tohit_mod += item_struct_id.ranged_to_hit_mod*addition_multiplier;
		
		//Shields are (usually) the only equippable weapon that provide armor or evasion bonuses; their protective values apply to the entire body:
		if item_struct_id.item_weapon_type_enum == wep_type.shield {
			
			char_struct_id.base_evasion += item_struct_id.evasion_mod*addition_multiplier;
			
			char_struct_id.armor_cur_head += item_struct_id.base_protect_val*addition_multiplier;
			char_struct_id.armor_max_head += item_struct_id.base_protect_val*addition_multiplier;
			
			char_struct_id.armor_cur_body += item_struct_id.base_protect_val*addition_multiplier;
			char_struct_id.armor_max_body += item_struct_id.base_protect_val*addition_multiplier;
			
			char_struct_id.armor_cur_hands += item_struct_id.base_protect_val*addition_multiplier;
			char_struct_id.armor_max_hands += item_struct_id.base_protect_val*addition_multiplier;
			
			char_struct_id.armor_cur_feet += item_struct_id.base_protect_val*addition_multiplier;
			char_struct_id.armor_max_feet += item_struct_id.base_protect_val*addition_multiplier;
		}
	}
		
	//Head armor:
	else if item_struct_id.item_equip_type_enum == inv_slot.head {
		char_struct_id.armor_cur_head += item_struct_id.base_protect_val*addition_multiplier;
		char_struct_id.armor_max_head += item_struct_id.base_protect_val*addition_multiplier;
		
		char_struct_id.base_evasion += item_struct_id.evasion_mod*addition_multiplier;
	}
		
	//Body armor:
	else if item_struct_id.item_equip_type_enum == inv_slot.body {
		char_struct_id.armor_cur_body += item_struct_id.base_protect_val*addition_multiplier;
		char_struct_id.armor_max_body += item_struct_id.base_protect_val*addition_multiplier;
		
		char_struct_id.base_evasion += item_struct_id.evasion_mod*addition_multiplier;
	}
		
	//Hands armor:
	else if item_struct_id.item_equip_type_enum == inv_slot.hands {
		char_struct_id.armor_cur_hands += item_struct_id.base_protect_val*addition_multiplier;
		char_struct_id.armor_max_hands += item_struct_id.base_protect_val*addition_multiplier;
		
		char_struct_id.base_evasion += item_struct_id.evasion_mod*addition_multiplier;
	}
		
	//Feet armor:
	else if item_struct_id.item_equip_type_enum == inv_slot.feet {
		char_struct_id.armor_cur_feet += item_struct_id.base_protect_val*addition_multiplier;
		char_struct_id.armor_max_feet += item_struct_id.base_protect_val*addition_multiplier;
		
		char_struct_id.base_evasion += item_struct_id.evasion_mod*addition_multiplier;
	}
		
	//Misc armor:
	else if item_struct_id.item_equip_type_enum == inv_slot.accessory {
			
	}
	
	d($"scr_equip_or_unequip_item: equip_boolean: {equip_boolean}, char_struct_id.name: {char_struct_id.char_stats_ar[char_stats.name]} has equipped or unequipped the: {item_struct_id.item_name}")
}