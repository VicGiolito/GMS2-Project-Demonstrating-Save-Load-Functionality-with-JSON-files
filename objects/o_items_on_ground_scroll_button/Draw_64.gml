/// @description draw sprite in draw gui event

if sprite_index != -1 {
	
	draw_self();
	
	var hovered = false;
	
	if collision_point(window_mouse_get_x(),window_mouse_get_y(),self,false,false) == id {
		image_index = 1;
		hovered = true;
	}
	else { 
		image_index = 0;	
	}
	
	//Adjust our min-max ranges on lmb_click:
	if hovered && mouse_check_button_released(mb_left) && global.wait {
		
		scr_reset_wait(1);
		
		var iterate_dir = 1; //scroll right
		
		//This is a left scroll button so scroll left:
		if scroll_left {
			iterate_dir = -1;
		}
		
		//Iterate ranges:
		o_controller.items_on_ground_min_range += global.max_items_on_ground_in_box*iterate_dir;
		o_controller.items_on_ground_max_range += global.max_items_on_ground_in_box*iterate_dir;
		
		//Cap:
			//We tried to iterate backwards (left) past the 0 zero index - bring it back (right):
		if o_controller.items_on_ground_min_range < 0 {
			o_controller.items_on_ground_min_range += global.max_items_on_ground_in_box;
			o_controller.items_on_ground_max_range += global.max_items_on_ground_in_box;
		}
		
			//We tried to iterate forward (right) past the length of the array - bring ti back (left):
		if o_controller.items_on_ground_min_range >= array_length(o_controller.items_on_ground_ar) {
			o_controller.items_on_ground_min_range -= global.max_items_on_ground_in_box;
			o_controller.items_on_ground_max_range -= global.max_items_on_ground_in_box;
		}
		
		//Rebuild o_items_on_ground slot instances:
		scr_setup_items_on_ground_boxes();
	}
	
}





