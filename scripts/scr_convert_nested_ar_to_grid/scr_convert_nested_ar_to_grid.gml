

function scr_convert_nested_ar_to_grid(nested_ar){
	
    if (!is_array(nested_ar) || array_length(nested_ar) == 0) {
        show_error("scr_convert_nested_ar_to_grid: invalid array provided. nested_ar = "+string(nested_ar)+", it is either was not an array or it's length == 0", true);
    }
    
    var grid_h = array_length(nested_ar);
    var grid_w = array_length(nested_ar[0]);
    
    var grid = ds_grid_create(grid_w, grid_h);
    
    for(var yy = 0; yy < grid_h; yy++) {
        
		for(var xx = 0; xx < grid_w; xx++) {
            
			grid[# xx, yy] = nested_ar[yy][xx];
			
        }
    }
    
    return grid;
}