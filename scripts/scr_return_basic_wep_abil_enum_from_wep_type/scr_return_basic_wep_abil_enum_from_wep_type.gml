

function scr_return_basic_wep_abil_enum_from_wep_type(wep_type_enum){
	
	var abil_enum = undefined;
	
	if wep_type_enum == wep_type.mace {
		abil_enum = ability.mace_smash;	
	}
	else if wep_type_enum == wep_type.hammer {
		abil_enum = ability.hammer_smash;	
	}
	else if wep_type_enum == wep_type.dagger {
		abil_enum = ability.dagger_stab;	
	}
	else if wep_type_enum == wep_type.sword {
		abil_enum = ability.sword_slash;
		abil_enum = ability.sword_thrust;
	}
	else if wep_type_enum == wep_type.dagger {
		abil_enum = ability.dagger_stab;	
	}
	else if wep_type_enum == wep_type.spear {
		abil_enum = ability.spear_thrust;	
	}
	else if wep_type_enum == wep_type.staff {	
		abil_enum = ability.staff_thrust;
	}
	else if wep_type_enum == wep_type.polearm {
		abil_enum = ability.polearm_thrust;	
	}
	else if wep_type_enum == wep_type.flail {
		abil_enum = ability.flail_swing;	
	}
	else if wep_type_enum == wep_type.axe {
		abil_enum = ability.axe_slash;	
	}
	else if wep_type_enum == wep_type.firearm {
		abil_enum = ability.firearm_fire;	
		abil_enum = ability.firearm_reload;
	}
	else if wep_type_enum == wep_type.crossbow {
		abil_enum = ability.crossbow_fire;	
		abil_enum = ability.crossbow_reload;
	}
	else if wep_type_enum == wep_type.bow {
		abil_enum = ability.bow_fire;	
		abil_enum = ability.bow_take_aim;
	}
	
}