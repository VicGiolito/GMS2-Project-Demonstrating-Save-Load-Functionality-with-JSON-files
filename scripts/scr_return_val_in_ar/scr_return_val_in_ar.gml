/*
Simply checks the specified array for the specified value (which could be anything);

we return that value if it's found;

otherwise we return -1.

So really, you should never use this script to check for values like -1

*/

function scr_return_val_in_ar(ar_to_check, val_to_return){
	
	if !is_array(ar_to_check) return -1;
	
	var ar_len = array_length(ar_to_check);
	
	for(var i = 0; i < ar_len; i++) {
		if ar_to_check[i] == val_to_return {
			return ar_to_check[i];	
		}
	}
	
	return -1;
}