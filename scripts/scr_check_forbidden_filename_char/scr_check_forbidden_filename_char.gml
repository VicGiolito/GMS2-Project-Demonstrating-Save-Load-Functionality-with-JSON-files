
//char must be a string of a single character;

//Returns true if the forbidden char is found; false otherwise.

function scr_check_forbidden_filename_char(char){
	
	for(var i = 0; i < array_length(global.forbidden_save_file_name_chars); i++) {
		if global.forbidden_save_file_name_chars[i] == char {
			return true;	
		}
	}
	
	return false;
}