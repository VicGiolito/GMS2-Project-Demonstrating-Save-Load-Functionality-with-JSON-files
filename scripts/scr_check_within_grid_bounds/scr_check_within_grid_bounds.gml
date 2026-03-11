

function scr_check_within_grid_bounds(grid_to_check,room_x,room_y){
	
	var grid_w = ds_grid_width(grid_to_check), grid_h = ds_grid_height(grid_to_check);
	
	if room_x >= global.grid_offset_x && room_x <= global.grid_offset_x+(grid_w * global.cell_size) && 
	room_y >= global.grid_offset_y && room_y <= global.grid_offset_y+(grid_h * global.cell_size) {
		return true;	
	}
	
	return false;
}