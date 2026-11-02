

function scr_convert_item_type_to_str(item_wep_type_){
	
	var return_str = "undefined";
	
	if item_wep_type_ == wep_type.sword return_str = "SWORD";
	else if item_wep_type_ == wep_type.axe return_str = "AXE";
	else if item_wep_type_ == wep_type.mace return_str = "MACE/CLUB";
	else if item_wep_type_ == wep_type.dagger return_str = "DAGGER/KNIFE";
	else if item_wep_type_ == wep_type.flail return_str = "FLAIL";
	else if item_wep_type_ == wep_type.polearm return_str = "POLEARM";
	else if item_wep_type_ == wep_type.hammer return_str = "HAMMER/PICK";
	else if item_wep_type_ == wep_type.staff return_str = "STAFF";
	else if item_wep_type_ == wep_type.spear return_str = "SPEAR";
	else if item_wep_type_ == wep_type.shield return_str = "SHIELD";
	else if item_wep_type_ == wep_type.bow return_str = "BOW";
	else if item_wep_type_ == wep_type.crossbow return_str = "CROSSBOW";
	else if item_wep_type_ == wep_type.consumable return_str = "CONSUMABLE";
	else if item_wep_type_ == wep_type.inert return_str = "INERT";
	else if item_wep_type_ == wep_type.cloth return_str = "CLOTH";
	else if item_wep_type_ == wep_type.chain_mail return_str = "CHAIN MAIL";
	else if item_wep_type_ == wep_type.plate return_str = "PLATE MAIL";
	else if item_wep_type_ == wep_type.leather return_str = "LEATHER/FUR";
	else if item_wep_type_ == wep_type.misc return_str = "ACCESSORY";
	else if item_wep_type_ == wep_type.treasure return_str = "TREASURE";
	else if item_wep_type_ == wep_type.torch return_str = "TORCH";
	else if item_wep_type_ == wep_type.firearm return_str = "FIREARM";
	
	return return_str;
}