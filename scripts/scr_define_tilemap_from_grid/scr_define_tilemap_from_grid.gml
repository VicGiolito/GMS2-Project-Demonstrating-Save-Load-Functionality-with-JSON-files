

function scr_define_tilemap_from_grid(grid_id,tile_id, called_from_str){
	
	show_debug_message("Entering scr_define_tilemap_from_grid, it was called from: "+called_from_str);
	
	var grid_w = ds_grid_width(grid_id), grid_h = ds_grid_height(grid_id);
	var cell_val;
	
	for(var xx = 0; xx < grid_w; xx++) {
		for(var yy = 0; yy < grid_h; yy++) {
			cell_val = grid_id[# xx,yy];
			
			if !tilemap_set(tile_id,cell_val,xx,yy) {
				show_debug_message("scr_define_tilemap_from_grid: could not set our tilemap at gridX: "+
				string(xx)+", gridY: "+string(yy)+", cell_val was == "+string(cell_val) );	
			}
		}
	}

}