
function scr_destroy_master_level_ar_grids(){
	
	if is_array(global.master_level_ar) {
	
		for(var w = 0; w < array_length(global.master_level_ar); w++) {
	
			for(var f = 0; f < array_length(global.master_level_ar[w]); f++) {
	
				for(var g = 0; g < array_length(global.master_level_ar[f]); g++) {
			
					if ds_exists(global.master_level_ar[w][f][g],ds_type_grid) {
						ds_grid_destroy(global.master_level_ar[w][f][g]);	
					}
				}
			}
		}
	}
}