

function scr_return_saved_games_list(){
	
	var temp_saved_games_ar = [];
	
	var first_saved_game_str = file_find_first("*",fa_directory);
	
	if first_saved_game_str != "" {
		
		if directory_exists(first_saved_game_str) {
			
			//Add our first game str to the array:
			array_push(temp_saved_games_ar, first_saved_game_str);
			
			var next_saved_game_str = "";
			
			do {
				 next_saved_game_str = file_find_next();
				 
				 if next_saved_game_str != "" {
					array_push(temp_saved_games_ar, next_saved_game_str);
				 }
				 else {
					break;	 
				 }
			}
			until(next_saved_game_str == "");
			
		}
	}
	
	//Always use this function whenever using file_find_first and file_find_next:
	file_find_close();
	
	if array_length(temp_saved_games_ar) <= 0 return false;
	
	else return temp_saved_games_ar;
}