
function scr_convert_room_to_grid_coords(pos_ar,room_x,room_y){
	
	room_x -= global.grid_offset_x;
	room_y -= global.grid_offset_y;
	
	pos_ar[0] = room_x div global.cell_size;
	pos_ar[1] = room_y div global.cell_size;
	
	return pos_ar;
}