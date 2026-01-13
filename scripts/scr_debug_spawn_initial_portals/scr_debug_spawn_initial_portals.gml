
//max_worlds_int == the last dungeon/world index we will iterate to

function scr_debug_spawn_initial_portals(max_world_int,world_portals_boolean){
	
	#region Place world portals:
	
	if world_portals_boolean {
	
		var failsafe_val = 0, failsafe_max = 1000, portals_placed = false;
	
		//Choose random first floor:
		var dungeon_enum_int = 0; //We start in first world
		var place_down_portal = true;
	
		do {
			var grid_x = irandom_range(0,global.grid_w-1);
			var grid_y = irandom_range(0,global.grid_h-1);
		
			//Make sure terrain is not a wall:
			if global.master_level_ar[dungeon_enum_int][0][GRID_TERRAIN][# grid_x,grid_y] < terrain_type.wall_dungeon {
			
				//Make sure there's not already a character here:
				if scr_return_struct_id(grid_x,grid_y,struct_type.character,0,dungeon_enum_int) == false {
				
					//It's our first_world, just create the down portal and move on
					if dungeon_enum_int == 0 {
						new Building(building_type.portal_world_down,grid_x,grid_y,char_team.neutral,0,true,dungeon_enum_int);
						dungeon_enum_int++; //Iterate to next world
					}
					//If it's our last world, just create the up portal and exit
					else if dungeon_enum_int == max_world_int {
						new Building(building_type.portal_world_up,grid_x,grid_y,char_team.neutral,0,true,dungeon_enum_int);
						portals_placed = true;
						return true;
					}
				
					//... It has to be a world that is not the first or the last world... 
				
					//Create down portal
					else if place_down_portal {
						new Building(building_type.portal_world_down,grid_x,grid_y,char_team.neutral,0,true,dungeon_enum_int);
						place_down_portal = false;
					}
					//Create up portal:
					else if !place_down_portal {
						new Building(building_type.portal_world_up,grid_x,grid_y,char_team.neutral,0,true,dungeon_enum_int);
						place_down_portal = true;
						dungeon_enum_int++; //Iterate to next world
					}
				}
			}
		
			if dungeon_enum_int > max_world_int {
				portals_placed = true;
				break;
			}
		
			failsafe_val++;
	
		} until(portals_placed || failsafe_val >= failsafe_max);
	
		show_error("scr_debug_spawn_initial_portals: we made it through our do-until loop and return true condition never executed, something went wrong.", true);
	}
	
	#endregion
}