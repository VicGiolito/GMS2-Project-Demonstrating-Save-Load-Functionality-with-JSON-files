
/* This is just an adapatation of the Bressenham's Line Equation.

Summary: We use a for-loop to move our origin_x and origin_y values along the length of our line 
until they reach the destination coordinates. 

--Works with GRID coordinates.

--Can be adapted for many different uses.

--When applicable, changes FOW or SHROUD cells to VISIBLE
*/

function scr_plot_los_line(origin_x,origin_y,destination_x,destination_y,floor_int,dungeon_int)
{
	// Differential - x and y length between our 2 points, can be a either negative or positive val:
    var dist_x = destination_x-origin_x;
    var dist_y = destination_y-origin_y;
     
    // Increments - the direction that both our x and y axis are moving when our code is following along the line:
    var sign_x = sign(dist_x);
    var sign_y = sign(dist_y);
     
    // Segment Length - the positive value of the x and y distances between our 2 points:
    dist_x = abs(dist_x);
    dist_y = abs(dist_y);
	
	// Max distance - the greater of the 2 values:
    var max_dist = max(dist_x,dist_y);
    
	// Remainder - The starting value for our remainder, which is half of the max_dist:
    var remainder = max_dist / 2;
	
	//Vars unique for the use of this algorithm:
	var blocking_wall_count = 0, blocking_terrain_count = 0; //For tracking forests and walls, respectively.
	
	// The horizontal length of this line is longer than the vertical length of this line,
	//we'll follow along that axis and adjust our origin_y as we move along:
    if (dist_x > dist_y) 
	{
        // We will repeat the following code for every unit of the max_dist that is the longer axis of our line,
		//in this case the x axis, which will be incremented more often than the y-axis because it is longer than the y-axis:
		for(var i = 0; i <= max_dist; i++) 
		{
            #region Insert code here for w.e the purpose of this script is:
			
			if global.master_level_ar[dungeon_int][floor_int][GRID_TERRAIN][# origin_x,origin_y] == terrain_type.forest blocking_terrain_count++;
			if global.master_level_ar[dungeon_int][floor_int][GRID_TERRAIN][# origin_x,origin_y] >= terrain_type.wall_dungeon blocking_wall_count++;
				
			/*The behavior is for forests: it allows us to see beyond the first
			forest tile until we encounter another.
			The behavior for walls: if we encounter even one wall, then the next
			cell will remain FOW or shroud
			*/
			if blocking_terrain_count > 1 {
				//Transform to VISIBLE cell
				tilemap_set(global.fow_tile_id,LOS_VISIBLE,origin_x,origin_y);
				//Set grid:
				global.master_level_ar[dungeon_int][floor_int][GRID_LOS][# origin_x,origin_y] = LOS_VISIBLE;
				return;
			}  
				
			if blocking_wall_count >= 1 {
				//Transform to VISIBLE cell
				tilemap_set(global.fow_tile_id,LOS_VISIBLE,origin_x,origin_y);
				//Set grid:
				global.master_level_ar[dungeon_int][floor_int][GRID_LOS][# origin_x,origin_y] = LOS_VISIBLE;
				return;	
			}
				
			//Transform to VISIBLE cell
			tilemap_set(global.fow_tile_id,LOS_VISIBLE,origin_x,origin_y);
			//Set grid:
			global.master_level_ar[dungeon_int][floor_int][GRID_LOS][# origin_x,origin_y] = LOS_VISIBLE;
			
			#endregion
			
			//Our origin_x value is incremented by along the length of our line in either a positive or negative direction:
            origin_x += sign_x; 
            
			// Our remainder is increased by the total length of the y-axis of our line:
			remainder += dist_y;
			
			//If our remainder is now >= the total length of the x-axis of our line...
            if (remainder >= dist_x) 
			{
                // ... Then increment our origin_y by the y-axis direction of our line...
				origin_y += sign_y;
				
				// ... And reduce our remainder by the total length of the x-axis of our line:
                remainder -= dist_x; //This basically resets our remainder to == 0 again.
            }
        }
    }
    
	// The vertical length of this line is longer than the horizontal length of this line,
	// we'll follow along that axis and adjust our origin_x as we move along:
	else 
	{
        // We will repeat the following code for every pixel of the max_dist that is the longer axis of our line,
		//in this case the y axis:
		for(var i = 0; i <= max_dist; i++) 
		{
			#region Insert code here for w.e the purpose of this script is:
			
			if global.master_level_ar[dungeon_int][floor_int][GRID_TERRAIN][# origin_x,origin_y] == terrain_type.forest blocking_terrain_count++;
			if global.master_level_ar[dungeon_int][floor_int][GRID_TERRAIN][# origin_x,origin_y] >= terrain_type.wall_dungeon blocking_wall_count++;
				
			/*The behavior is for forests: it allows us to see beyond the first
			forest tile until we encounter another.
			The behavior for walls: if we encounter even one wall, then the next
			cell will remain FOW or shroud
			*/
			if blocking_terrain_count > 1 {
				//Transform to VISIBLE cell
				tilemap_set(global.fow_tile_id,LOS_VISIBLE,origin_x,origin_y);
				//Set grid:
				global.master_level_ar[dungeon_int][floor_int][GRID_LOS][# origin_x,origin_y] = LOS_VISIBLE;
				return;
			}  
				
			if blocking_wall_count >= 1 {
				//Transform to VISIBLE cell
				tilemap_set(global.fow_tile_id,LOS_VISIBLE,origin_x,origin_y);
				//Set grid:
				global.master_level_ar[dungeon_int][floor_int][GRID_LOS][# origin_x,origin_y] = LOS_VISIBLE;
				return;	
			}
				
			//Transform to VISIBLE cell
			tilemap_set(global.fow_tile_id,LOS_VISIBLE,origin_x,origin_y);
			//Set grid:
			global.master_level_ar[dungeon_int][floor_int][GRID_LOS][# origin_x,origin_y] = LOS_VISIBLE;
			
			#endregion
			
            origin_y += sign_y;
			
            remainder += dist_x;
			
            if (remainder >= dist_y)
			{
                origin_x += sign_x;
				
                remainder -= dist_y;
            }
        }
    }
}