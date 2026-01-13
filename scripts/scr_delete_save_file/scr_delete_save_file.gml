

function scr_delete_save_file(filename_str){
	
	if directory_exists(working_directory+filename_str) {
		directory_destroy(filename_str);	
	}
}