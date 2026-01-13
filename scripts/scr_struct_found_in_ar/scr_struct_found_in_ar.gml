
/* instance_of_struct: the instanceof(struct_id); this will be a STRING

ar_to_check: presumably one of our team arrays:

//Note: only works if the ar_struct has been INSTANTIATED! Remember this if you're using it to check
instances of structs on different worlds or levels, where they may not have been instantiated yet

*/

function scr_struct_found_in_ar(instance_of_struct,ar_to_check){
	
	var ar_len = array_length(ar_to_check);
	var ar_struct;
	
	for(var i = 0; i < ar_len; i++) {
		ar_struct = ar_to_check[i];
		
		if is_struct(ar_struct) {
			if instanceof(ar_struct) == instance_of_struct {
				return true;	
			}
		}
	}
	
	return false;
}