

function scr_defunct_return_maze_type_from_dungeon_ind(dungeon_ind){
	
	var maze_type_enum;
	
	switch(dungeon_ind) {
		
		case dungeon_type.overworld:
			maze_type_enum = maze_type.basic_forest_world;
		break;
		case dungeon_type.minotaur_maze:
			maze_type_enum = maze_type.recursive_backtracker;
		break;
		
		default:
			show_error("scr_return_maze_type_from_dungeon_ind: dungeon_ind: "+string(dungeon_ind)+" was not captured by our switch-case.", true);
		break;
	}
	
	return maze_type_enum;
}