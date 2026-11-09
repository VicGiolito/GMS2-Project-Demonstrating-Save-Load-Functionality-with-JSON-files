/// @description o_main_txt_box_scroll_button

if sprite_index != -1 {

	var hovered = false;
	
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	if collision_point(mx, my,self,false,false) == id {
		image_index = 1;
		hovered = true;
		if is_up_scroll {
			d("HOVERING OVER THE FUCKNIG UP ARROW SCROLL!")	
		}
		else {
			d("HOVERING OVER THE DOWN ARROW SCROLL!");
		}
	}
	else { 
		image_index = 0;	
	}
	
	if is_array(global.main_txt_ar) && array_length(global.main_txt_ar) {
		
		if hovered && mouse_check_button_released(mb_left) {
			d("UP NOR DOWN BUTTON SELECETD!")
			if is_up_scroll	{
				d("UP BUTTON SELECTED!");
				if global.main_txt_ar_min_range - 1 >= 0 {
					global.main_txt_ar_min_range -= 1;	
					d("UP LOGIC EXECUTED!");
				}
			}
			else {
				d("DOWN BUTTON SELECTED!");
				if global.main_txt_ar_min_range+global.main_txt_max_lines+1 < array_length(global.main_txt_ar) {
					global.main_txt_ar_min_range++;	
					d("DOWN BUTTON LOGIC EXECUTED@!");
				}
			}
		}
	}
	
	draw_self();
}









