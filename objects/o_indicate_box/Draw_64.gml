/// @description o_indicate_box - draw gui event
	
	// Reduce alpha evenly: 1 / 3 per second
	alpha_val -= (delta_time / 1000000) / fade_duration;

	// Draw the red rectangle with the fading alpha
	draw_set_alpha(max(alpha_val, 0));
	
	draw_rectangle_color(x, y, x + rect_w, y + rect_h, c, c, c, c, outline_bool); 

	// Reset alpha:
	draw_set_alpha(1);

	// Destroy once fully faded
	if (alpha_val <= 0) instance_destroy();
	
















