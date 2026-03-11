

function scr_add_all_structs_from_dungeon_to_team_arrays(dungeon_index){
	
	var global_team_ar, struct_id;
	
	//Iterate through dungeon indices:
	for(var dungeon_i = 0; dungeon_i < array_length(global.master_struct_ar); dungeon_i++) {
		//Iterate through floor indices:
		for(var floor_i = 0; floor_i < array_length(global.master_struct_ar[dungeon_i]); floor_i++) {
			//Iterate through team indices:
			for(var team_i = 0; team_i < array_length(global.master_struct_ar[dungeon_i][floor_i]); team_i++) {
				//Iterate through positions in team_ar:
				for(var struct_i = 0; struct_i < array_length(global.master_struct_ar[dungeon_i][floor_i][team_i]); struct_i++) {
					struct_id = global.master_struct_ar[dungeon_i][floor_i][team_i][struct_i];
					global_team_ar = scr_return_struct_global_team_ar(struct_id);
					array_push(global_team_ar,struct_id);
				}
			}
		}
	}
}