
//Considers 0 or -1 values as an 'empty' array position - keep that in mind;

//returns true if successful false otherwise.

function scr_add_val_to_ar(ar_id,val_to_add){
	
	var ar_len = array_length(ar_id);
	for(var i = 0; i < ar_len; i++) {
		if(ar_id[i] == 0 || ar_id[i] == -1) {
			ar_id[i] = val_to_add;
			return true;
		}
	}
	
	return false;
}