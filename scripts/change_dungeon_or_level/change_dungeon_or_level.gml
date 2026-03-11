

function change_dungeon_or_level(new_world, new_floor,called_from_str) {
    
	show_debug_message("Entering change_dungeon_or_level: new_world: "+string(new_world)+
	", new_floor = "+string(new_floor)+", called_from: "+string(called_from_str) );
	
	// Unload old level (optional - saves memory)
		//scr_unload_level_structs(global.cur_dungeon_ind, global.cur_floor_ind);
    
    // Load new level structs
    scr_load_level_structs(new_world, new_floor,"change_dungeon_or_level");
    
    global.cur_dungeon_ind = new_world;
    global.cur_floor_ind = new_floor;
}