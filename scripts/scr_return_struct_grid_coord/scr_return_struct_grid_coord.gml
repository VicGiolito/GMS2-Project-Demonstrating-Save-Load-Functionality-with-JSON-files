/*
	Returns false if the struct is an item, which don't have grid coordinates, unless they're currently a loot_drop BUILDING



*/

function scr_return_struct_grid_coord(struct_id, grid_coord_ar){
	
	if struct_id.struct_enum == struct_type.item {
		return false; //Items don't have a grid_x and y coordinate (unless they are currently existing as a loot_drop building).	
	}
	
	else if struct_id.struct_enum == struct_type.character {
		array_push(grid_coord_ar,struct_id.char_grid_x,struct_id.char_grid_y);
		return grid_coord_ar;
	}
	else if struct_id.struct_enum == struct_type.building || struct_id.struct_enum == struct_type.loot_drop {
		array_push(grid_coord_ar,struct_id.building_grid_x,struct_id.building_grid_y);	
		return grid_coord_ar;
	}
	
	show_error("scr_return_struct_grid_coord: could not find corresponding grid_x and y variables for struct id; perhaps it's struct_enum was not defined? struct_id == "+string(struct_id), true);
}