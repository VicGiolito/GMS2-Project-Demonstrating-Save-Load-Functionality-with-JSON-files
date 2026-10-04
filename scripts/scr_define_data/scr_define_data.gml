

function scr_define_data(){
	
	start_menu_str_ar = ["NEW DEBUG GAME","NEW QUICK GAME","LOAD 'T' GAME", "LOAD GAME LIST", "OPTIONS","QUIT"];
	
	enum start_menu_options {
		new_debug_game,
		new_quick_game,
		load_game,
		load_game_list,
		options,
		quit
	}
	
	enum maze_type_options {
		recursive_backtracker,
		debug_forest_world
	}	
}