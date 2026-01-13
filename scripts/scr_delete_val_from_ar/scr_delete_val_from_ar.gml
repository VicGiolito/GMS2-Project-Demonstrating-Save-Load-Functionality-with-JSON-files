
/* 
	Only deletes ONE matching value of the val_to_remove from the ar_id.
*/

function scr_delete_val_from_ar(ar_id, val_to_remove, called_from_str){
	
	var ar_len = array_length(ar_id);
	for(var i = 0; i < ar_len; i++) {
		if(ar_id[i] == val_to_remove) {
			array_delete(ar_id,i,1);
			show_debug_message($"scr_delete_val_from_ar: successfully deleted val_to_remove from ar_id, this script was called from: {called_from_str}");
			return true;
		}
	}
	
	show_debug_message($"scr_delete_val_from_ar: there was no matching val_to_remove from ar_id, returning false. This script was called from {called_from_str}")
	
	return false;
}