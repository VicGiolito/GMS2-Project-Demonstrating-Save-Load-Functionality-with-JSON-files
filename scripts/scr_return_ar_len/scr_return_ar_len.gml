/* Used for arrays that have a set length and consider their 'length' to be the number
of valid instances within them, with -1 indicating an empty index.

*/

function scr_return_ar_len(ar_to_check){
	var ar_len = array_length(ar_to_check), ar_count = 0;
	for(var i = 0; i < ar_len; i++) {
		if ar_to_check[i] != -1 {
			ar_count++;	
		}
	}
	
	return ar_count;
}