
function scr_add_to_ar_if_no_duplicate_exists(ar_to_add_to, ar_val_to_add){
	
	show_debug_message($"Entering scr_add_to_ar_if_no_duplicate_exists: ar_to_add_to == {ar_to_add_to}, ar_val_to_add == {ar_val_to_add}");
	
	var ar_len = array_length(ar_to_add_to), ar_val;
	
	for(var i = 0; i < ar_len; i++) {
		ar_val = ar_to_add_to[i];
		
		if ar_val_to_add == ar_val {
			show_debug_message($"Entering scr_add_to_ar_if_no_duplicate_exists: we found a duplicate of the ar_to_add_to: {ar_to_add_to} in the ar_to_add_to: {ar_to_add_to}, did not add to array and returning FALSE.");
			
			return false;	
		}
	}
	
	array_push(ar_to_add_to,ar_val_to_add);
	
	show_debug_message($"Entering scr_add_to_ar_if_no_duplicate_exists: No duplicate found, so we PUSHED ar_val_to_add == {ar_val_to_add} to the end of the ar_to_add_to == {ar_to_add_to}; returning TRUE.");

	return true;
}