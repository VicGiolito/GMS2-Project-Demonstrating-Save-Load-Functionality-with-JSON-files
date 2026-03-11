

function scr_convert_grid_to_nested_ar(grid_to_convert){

	if !ds_exists(grid_to_convert,ds_type_grid) {
		show_error("scr_convert_grid_to_nested_ar: grid_to_convert: "+string(grid_to_convert)+", was not a grid.",true);
	}
	
	var grid_w = ds_grid_width(grid_to_convert), grid_h = ds_grid_height(grid_to_convert);
	
	var nested_ar = array_create(grid_h);
	
	//Then fill it the grid values:
	for(var yy = 0; yy < grid_h; yy++) {
		nested_ar[yy] = array_create(grid_w); //Pre-allocate row
		for(var xx = 0; xx < grid_w; xx++) { //Then iterate through it, adding values:
			nested_ar[yy][xx] = grid_to_convert[# xx,yy];	
		}
	}
	
	return nested_ar;
}