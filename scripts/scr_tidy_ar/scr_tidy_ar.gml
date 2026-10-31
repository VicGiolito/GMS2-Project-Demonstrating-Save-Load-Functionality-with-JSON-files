
/* Quite simply: we iterate through the ar_to_tidy, removing elements that are NOT structs 
(such as 'empty' element indices, like 0 and -1)

Returns the passed_through array ar_to_tidy

*/

function scr_tidy_ar(ar_to_tidy){
	
	var local_ar = [];
	
	var ar_element;
	
	for(var i = 0; i < array_length(ar_to_tidy); i++) {
		
		ar_element = ar_to_tidy[i];
		
		if is_struct(ar_element) {
			array_push(local_ar, ar_element);
		}
	}
	
	ar_to_tidy = local_ar;
	
	return ar_to_tidy;
}