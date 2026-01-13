
/* We simply change any tile that has been set to == VISIBLE to now == FOW
*/

function scr_reset_fow(floor_int,dungeon_int){
	
	var grid_w = ds_grid_width(global.master_level_ar[dungeon_int][floor_int][GRID_LOS]);
	var grid_h = ds_grid_height(global.master_level_ar[dungeon_int][floor_int][GRID_LOS]);
	
	for(var xx = 0; xx < grid_w; xx++)
	{
		for(var yy = 0; yy < grid_h; yy++)
		{
			//Set grid and tilemap:
			if(global.master_level_ar[dungeon_int][floor_int][GRID_LOS][# xx,yy] == LOS_VISIBLE) { 
				
				global.master_level_ar[dungeon_int][floor_int][GRID_LOS][# xx,yy] = LOS_FOW; 
				
				tilemap_set(global.fow_tile_id,LOS_FOW,xx,yy);
			}
		}
	}
}