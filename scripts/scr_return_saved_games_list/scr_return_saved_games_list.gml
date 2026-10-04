

function scr_return_saved_games_list(){
	
	d("Entering scr_return_saved_games_list now...");
	
	var temp_saved_games_ar = [];
	
	var filename_str = file_find_first("*",fa_directory);
	
	while filename_str != "" {
		
		if (filename_str != "." && filename_str != ".." && directory_exists(filename_str)) {
			
			//Add our first game str to the array:
			array_push(temp_saved_games_ar, filename_str);
		}
		
		filename_str = file_find_next();
	}
	
	//Always use this function whenever using file_find_first and file_find_next:
	file_find_close();
	
	return temp_saved_games_ar;
}