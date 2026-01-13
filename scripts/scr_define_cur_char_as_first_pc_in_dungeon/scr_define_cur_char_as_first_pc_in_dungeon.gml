/* This script is mostly a debug placeholder for now:


*/
function scr_define_cur_char_as_first_pc_in_dungeon(dungeon_index){
	
	for(var floor_i = 0; floor_i < array_length(global.master_struct_ar[dungeon_index]); floor_i++) {
		if is_array(global.master_struct_ar[dungeon_index][floor_i]) {
			if is_array(global.master_struct_ar[dungeon_index][floor_i][AR_PC]) && array_length(global.master_struct_ar[dungeon_index][floor_i][AR_PC]) > 0 {
				if is_struct(global.master_struct_ar[dungeon_index][floor_i][AR_PC][0]) {
					
					global.cur_char = global.master_struct_ar[dungeon_index][floor_i][AR_PC][0];
					
					show_debug_message($"scr_define_cur_char_as_first_pc_in_dungeon: defining g.cur_char as the first pc char we found while iterate down from the first floor to the last of dungeon_index: {dungeon_index}, we found the pc_char with name of: {global.cur_char.char_stats_ar[char_stats.name]}.");
					
					return true;
				}
			}
		}
	}
	
	show_debug_message("scr_define_cur_char_as_first_pc_in_dungeon: ERROR: We FAILED to find a pc Character instance within any of the floors of dungeon_index: "+string(dungeon_index) );
	
	return false;
}