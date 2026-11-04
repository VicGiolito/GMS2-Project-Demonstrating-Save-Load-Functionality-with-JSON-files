

function scr_define_data(){
	
	start_menu_str_ar = ["NEW DEBUG GAME","NEW QUICK GAME", "LOAD GAME", "OPTIONS","QUIT"];
	
	enum start_menu_options {
		new_debug_game,
		new_quick_game,
		load_game_list,
		options,
		quit
	}
	
	enum maze_type_options {
		recursive_backtracker,
		debug_forest_world
	}	
	
	//Define global.abil_ar and instantiate 1 of each struct for future reference by characters:
	global.abil_ar = array_create(ability.total_ablities);
	
	for(var i = 0; i < array_length(global.abil_ar); i++) {
		global.abil_ar[i] = new Ability(i);	
	}
}