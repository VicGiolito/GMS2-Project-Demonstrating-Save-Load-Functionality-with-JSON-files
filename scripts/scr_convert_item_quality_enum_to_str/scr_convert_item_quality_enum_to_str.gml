

function scr_convert_item_quality_enum_to_str(item_quality_enum_){
	
	var return_str = "undefined";
	
	if item_quality_enum_ == item_quality.crude return_str = "CRUDE";
	else if item_quality_enum_ == item_quality.poor return_str = "POOR";
	else if item_quality_enum_ == item_quality.average return_str = "AVERAGE";
	else if item_quality_enum_ == item_quality.good return_str = "GOOD";
	else if item_quality_enum_ == item_quality.excellent return_str = "EXCELLENT";
	
	return return_str;
}