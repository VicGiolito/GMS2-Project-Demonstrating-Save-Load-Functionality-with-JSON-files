
//Returns true if the specified filename is found in our GMS2 working_directory; returns false if it is not found.

function scr_check_save_filename(filename_str){
	
	// Check if save file exists
    if (directory_exists(filename_str)) {
        
		show_debug_message("scr_check_save_filename: Directory with name: "+string(filename_str+"/")+" was found in our working directory.");
		
        return true;
    }
	else {
		return false;	
	}
}