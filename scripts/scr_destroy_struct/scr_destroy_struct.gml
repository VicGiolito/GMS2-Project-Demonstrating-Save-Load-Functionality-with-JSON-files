
/* --Remove struct from corresponding location in global.master_struct_ar;

--Corresponding inst_grid in g.master_level_ar

--Corresponding global team array (g.pc_team_ar,enemy_team_ar, etc.)

*/

function scr_destroy_struct(struct_id){
	
	var struct_world_ind = struct_id.cur_dungeon_ind;
	var struct_floor_ind = struct_id.cur_floor_level;
	
	var struct_name = scr_return_struct_name(struct_id);
	
	show_debug_message($"Entering scr_destroy_struct for struct with name of: {struct_name}");
	
	var struct_grid_ar = [];
	
	struct_grid_ar = scr_return_struct_grid_coord(struct_id,struct_grid_ar);
	
	var struct_grid_x = struct_grid_ar[0], struct_grid_y = struct_grid_ar[1];
	struct_grid_ar = -1;
	
	scr_remove_from_master_struct_ar(struct_id,struct_world_ind,struct_floor_ind,"scr_destroy_struct for struct with name: "+string(struct_name) );
	
	scr_remove_struct_from_inst_grid(struct_id,struct_grid_x,struct_grid_y,struct_floor_ind,struct_world_ind,"scr_destroy_struct for struct with name of: "+string(struct_name));
	
	scr_remove_struct_from_global_team_ar(struct_id);
	
	if struct_id.struct_enum == struct_type.character {
		scr_delete_val_from_ar(o_controller.revealed_enemies_ar,struct_id,"scr_destroy_struct for struct with name of: "+string(struct_name) );
	}
	
	delete struct_id;
}