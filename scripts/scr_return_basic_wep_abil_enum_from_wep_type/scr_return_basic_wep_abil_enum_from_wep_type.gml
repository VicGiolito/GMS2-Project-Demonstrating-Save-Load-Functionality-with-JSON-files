

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
	
	I'm working here
}