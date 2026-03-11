
/* Is this being used anywhere? Doesn't actually delete values from arrays, just converts those
values to -1



*/

function scr_remove_val_from_ar(ar_id, val_to_remove){

	var ar_len = array_length(ar_id);
	for(var i = 0; i < ar_len; i++) {
		if(ar_id[i] == val_to_remove) {
			ar_id[i] = -1;
			return true;
		}
	}
	
	return false;

}