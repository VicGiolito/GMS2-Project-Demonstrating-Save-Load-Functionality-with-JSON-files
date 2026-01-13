


function scr_return_external_file_structure_floor_len(filename_str,dungeon_index,called_from_str){
	
	show_debug_message($"Entering scr_return_external_file_structure_floor_len: dungeon_index = {dungeon_index}, called from: {called_from_str}");
	
	 // Check if save file exists
    if (!directory_exists(filename_str)) {
        show_debug_message("scr_return_external_file_structure_floor_len: Main save file directory with path: "+string(filename_str)+" does not exist!");
		show_message("scr_return_external_file_structure_floor_len: Main save file directory with path: "+string(filename_str)+" does not exist!");
        return false;
    }
	
	//Check to see if dungeon exists:
	var dungeon_file_path = filename_str+"\\"+string(dungeon_index)+"\\";
	if (!directory_exists(dungeon_file_path)) {
        show_debug_message("scr_return_external_file_structure_floor_len: Dungeon directory with path: "+string(dungeon_file_path)+" does not exist!");
		show_message("scr_return_external_file_structure_floor_len: Dungeon directory with path: "+string(dungeon_file_path)+" does not exist!");
        return false;
    }
	
	//Iterate through directories:
	var failsafe_val = 0, failsafe_max = 10000, max_floors_reached = false;
	var floor_index = 0, file_path_str = "";
	do {
		file_path_str = filename_str+"\\"+string(dungeon_index)+"\\"+string(floor_index)+"\\";
		
		if (!directory_exists(file_path_str)) {
			max_floors_reached = true;
			
			if floor_index > 0 {
				show_debug_message($"scr_return_external_file_structure_floor_len: there was no corresponding level directory in our external file structure at floor_index {floor_index}, max floors for dungeon_index: {dungeon_index} should == {floor_index-1}");	
			
				return floor_index-1;
			} else {
				show_debug_message($"scr_return_external_file_structure_floor_len: there was no corresponding level directory in our external file structure at floor_index 0 for dungeon_index: {dungeon_index}, something went wrong, perhaps there are no levels in the external file for that dungeon_index?");	
			
				return false;
			}
		}
		
		failsafe_val++;
		floor_index++;
	}
	until(failsafe_val >= failsafe_max || max_floors_reached);
	
	show_debug_message("scr_return_external_file_structure_floor_len: we moved through our do-until loop and did not executed any of the return conditions, something went wrong.");
	
	return false;
}