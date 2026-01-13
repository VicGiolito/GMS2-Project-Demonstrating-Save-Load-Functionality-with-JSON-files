/* Iterates through the specified array and returns a count of all elements that match either == -1 or 0

*/

function scr_return_empty_elements(ar_to_count){
	var ar_len = array_length(ar_to_count), empty_slot_count = 0;
	
	for(var i = 0; i < ar_len; i++) {
		if ar_to_count[i] == -1 || ar_to_count[i] == 0 {
			empty_slot_count++;	
		}
	}
	
	return empty_slot_count;
}