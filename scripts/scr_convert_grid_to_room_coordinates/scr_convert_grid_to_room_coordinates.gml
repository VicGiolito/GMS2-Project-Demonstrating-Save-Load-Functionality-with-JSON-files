//This also places the new room coordinates in the CENTER of the specified grid cell.

function scr_convert_grid_to_room_coordinates(pos_ar,grid_x,grid_y,center_coordinate_boolean = true)
{
	var room_x, room_y;
	
	if(center_coordinate_boolean) {
		room_x = ((grid_x)*global.cell_size)+global.half_c+global.grid_offset_x;
		room_y = ((grid_y)*global.cell_size)+global.half_c+global.grid_offset_y;
	} 
	//This would leave the room coordinates in the upper left corner of the grid cell - 
	//I don't ever see a use for this:
	else 
	{ 
		room_x = ((grid_x)*global.cell_size)+global.grid_offset_x;
		room_y = ((grid_y)*global.cell_size)+global.grid_offset_y;	
	}
	
	pos_ar[0] = room_x;
	pos_ar[1] = room_y;
	
	return pos_ar;
}