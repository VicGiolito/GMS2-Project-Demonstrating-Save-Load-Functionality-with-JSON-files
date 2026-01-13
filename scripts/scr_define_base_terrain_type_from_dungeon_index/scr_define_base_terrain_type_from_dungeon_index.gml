
/*
	Should be called before scr_generate_maze() after we change to a new dungeon


*/

function scr_define_base_terrain_type_from_dungeon_index(dungeon_type_enum){
	
	//Define global.base_terrain_type:
	if dungeon_type_enum == dungeon_type.minotaur_maze {
		global.base_terrain_type = terrain_type.dungeon;
	}
	else if dungeon_type_enum == dungeon_type.overworld {
		global.base_terrain_type = terrain_type.fields;	
	}
	else global.base_terrain_type = terrain_type.dungeon; //default
}