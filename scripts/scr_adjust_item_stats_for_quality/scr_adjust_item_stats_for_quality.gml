
/* Assumes that the starting value of the item quality is average:



*/

function scr_adjust_item_stats_for_quality(item_struct_id, called_from_str){
	
	d("Entering scr_adjust_item_stats_for_quality, it was called from: {called_from_str}");
	
	var item_quality_enum_ = item_struct_id.item_quality_enum;
	var item_class_ = item_struct_id.item_class;
	
	#region Define stat modifiers based upon quality:
	
	//For now, all items receive a gradation +/- 1 for each level of quality away from average, but only if there was an actual stat there to begin with 
	//(the stat != 0); we also don't let their values modify below 0, unless it's a cursed item:
	var crude_mod = -2, poor_mod = -1, good_mod = 1, excellent_mod = 2, cursed_mod = -10;
	var cursed_gold_val_mod = -.5, crude_gold_val_mod = -.25, poor_gold_val_mod = -.1, good_gold_val_mod = .35, excellent_gold_val_mod = .65;
	
	var stat_mod = 0;
	
	//Define stat mod, adjust gold_value:
	if item_quality_enum_ == item_quality.cursed { stat_mod = cursed_mod; item_struct_id.gold_value += item_struct_id.gold_value*cursed_gold_val_mod; item_struct_id.gold_value = ceil(item_struct_id.gold_value); }
	else if item_quality_enum_ == item_quality.crude { stat_mod = crude_mod; item_struct_id.gold_value += item_struct_id.gold_value*crude_gold_val_mod; item_struct_id.gold_value = ceil(item_struct_id.gold_value); }
	else if item_quality_enum_ == item_quality.poor { stat_mod = poor_mod; item_struct_id.gold_value += item_struct_id.gold_value*poor_gold_val_mod; item_struct_id.gold_value = ceil(item_struct_id.gold_value);}
	else if item_quality_enum_ == item_quality.good { stat_mod = good_mod; item_struct_id.gold_value += item_struct_id.gold_value*good_gold_val_mod; item_struct_id.gold_value = ceil(item_struct_id.gold_value); }
	else if item_quality_enum_ == item_quality.excellent { stat_mod = excellent_mod; item_struct_id.gold_value += item_struct_id.gold_value*excellent_gold_val_mod; item_struct_id.gold_value = ceil(item_struct_id.gold_value); }
	
	//min dmg:
	if item_struct_id.min_dmg != 0 {
		//Cap at 0:
		if item_struct_id.min_dmg + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.min_dmg = 0; } 
		//Alter as normal:
		else {
			item_struct_id.min_dmg += stat_mod;
		}
	}
	
	//max dmg:
	if item_struct_id.max_dmg != 0 {
		//Cap at 0:
		if item_struct_id.max_dmg + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.max_dmg = 0; } 
		//Alter as normal:
		else {
			item_struct_id.max_dmg += stat_mod;
		}
	}
	
	//to_hit mod:
	if item_struct_id.to_hit_mod != 0 {
		//Cap at 0:
		if item_struct_id.to_hit_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.to_hit_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.to_hit_mod += stat_mod;
		}
	}
	
	//protect val:
	if item_struct_id.base_protect_val != 0 {
		//Cap at 0:
		if item_struct_id.base_protect_val + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.base_protect_val = 0; } 
		//Alter as normal:
		else {
			item_struct_id.base_protect_val += stat_mod;
		}
	}
	
	//Evasion mod:
	if item_struct_id.evasion_mod != 0 {
		//Cap at 0:
		if item_struct_id.evasion_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.evasion_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.evasion_mod += stat_mod;
		}
	}
	
	//Resitances:
	if item_struct_id.res_arcane_mod != 0 {
		//Cap at 0:
		if item_struct_id.res_arcane_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.res_arcane_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.res_arcane_mod += stat_mod;
		}
	}
	if item_struct_id.res_fire_mod != 0 {
		//Cap at 0:
		if item_struct_id.res_fire_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.res_fire_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.res_fire_mod += stat_mod;
		}
	}
	if item_struct_id.res_ice_mod != 0 {
		//Cap at 0:
		if item_struct_id.res_ice_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.res_ice_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.res_ice_mod += stat_mod;
		}
	}
	if item_struct_id.res_poison_mod != 0 {
		//Cap at 0:
		if item_struct_id.res_poison_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.res_poison_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.res_poison_mod += stat_mod;
		}
	}
	if item_struct_id.res_shock_mod != 0 {
		//Cap at 0:
		if item_struct_id.res_shock_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.res_shock_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.res_shock_mod += stat_mod;
		}
	}
	if item_struct_id.res_light_mod != 0 {
		//Cap at 0:
		if item_struct_id.res_light_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.res_light_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.res_light_mod += stat_mod;
		}
	}
	if item_struct_id.res_dark_mod != 0 {
		//Cap at 0:
		if item_struct_id.res_dark_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.res_dark_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.res_dark_mod += stat_mod;
		}
	}
	
	if item_struct_id.res_crushing_mod != 0 {
		//Cap at 0:
		if item_struct_id.res_crushing_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.res_crushing_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.res_crushing_mod += stat_mod;
		}	
	}
	if item_struct_id.res_slashing_mod != 0 {
		//Cap at 0:
		if item_struct_id.res_slashing_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.res_slashing_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.res_slashing_mod += stat_mod;
		}
	}
	if item_struct_id.res_piercing_mod != 0 {
		//Cap at 0:
		if item_struct_id.res_piercing_mod + stat_mod < 0 && item_quality_enum_ != item_quality.cursed { item_struct_id.res_piercing_mod = 0; } 
		//Alter as normal:
		else {
			item_struct_id.res_piercing_mod += stat_mod;
		}
	}
	
	#endregion
	
	#region Define item description based upon it's quality:
	
	if item_class_ == item_enum.wep_axe_two_hand_woodcut {
		if item_quality_enum_ == item_quality.crude {
			item_struct_id.description = "This basic version of a big woodcutter's axe is battered and blunted.";	
		}
		else {
			item_struct_id.description = "The basic version of a big woodcutter's axe.";	
		}
	}	
	else if item_class_ == item_enum.wep_axe_one_hand {
		if item_quality_enum_ == item_quality.crude {
			item_struct_id.description = "This basic version of a woodcutter's hatchet is battered and blunted.";	
		}
		else {
			item_struct_id.description = "The basic version of a woodcutter's hatchet.";	
		}
	}
	else if item_class_ == item_enum.wep_sword_one_hand {
		if item_quality_enum_ == item_quality.crude {
			item_struct_id.description = "Rusty iron short sword.";	
		}
		else {
			item_struct_id.description = "Iron short sword.";	
		}
	}
	else if item_class_ == item_enum.wep_sword_two_hand_ancient {
		if item_quality_enum_ == item_quality.crude {
			item_struct_id.description = "This may have been a noble great sword a century ago; now it's barely passable as a weapon.";	
		}
		else {
			item_struct_id.description = "This may have been a noble great sword a century ago.";	
		}
	}
	else if item_class_ == item_enum.wep_polearm_pike {
		if item_quality_enum_ == item_quality.crude {
			item_struct_id.description = "Just a huge length of hard wood with a rusty iron spear head.";	
		}
		else {
			item_struct_id.description = "Just a huge length of hard wood with a iron spear head.";	
		}
	}
	else if item_class_ == item_enum.wep_polearm_halberd {
		if item_quality_enum_ == item_quality.crude {
			item_struct_id.description = "A powerful and versatile weapon that can serve as both an axe, a spear, and a hammer. Nonetheless, this particular weapon has seen better days.";	
		}
		else {
			item_struct_id.description = "A powerful and versatile weapon that can serve as both an axe, a spear, and a hammer.";	
		}
	}
	
	else if item_class_ == item_enum.wep_mace_one_hand {
		if item_quality_enum_ == item_quality.crude {
			item_struct_id.description = "This is just a stick with an iron head; looks like it could break at any moment..";	
		}
		else if item_quality_enum_ == item_quality.average {
			item_struct_id.description = "Your basic soldier's mace.";	
		}
		else if item_quality_enum_ >= item_quality.good {
			item_struct_id.description = "Likely forged by a castle smithy, this sturdy mace with a flanged iron head could deal some decent blunt damage.";
		}
	}
	else if item_class_ == item_enum.wep_dagger_one_hand {
		if item_quality_enum_ == item_quality.crude {
			item_struct_id.description = "This might have been a kitchen knife in a previous life; better than nothing, at any rate.";	
		}
		else if item_quality_enum_ == item_quality.average {
			item_struct_id.description = "Your basic soldier's dagger.";	
		}
	}
	else if item_class_ == item_enum.wep_spear_one_hand {
		if item_quality_enum_ == item_quality.crude {
			item_struct_id.description = "This is just a sturdy stick with a sharpened point.";
		}
		else if item_quality_enum_ == item_quality.average {
			item_struct_id.description = "Your basic soldier's spear.";	
		}
	}
		
	#endregion
	
}