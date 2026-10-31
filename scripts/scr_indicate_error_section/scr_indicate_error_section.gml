
//Creates a fading red rectangle at the specific location on the GUI, to indicate to the player that something
//needs addressing, and their action is invalid


function scr_indicate_error_section(spawn_x1, spawn_y1, rectangle_w, rectangle_h, color, outline_bool_){
	
	with(instance_create_layer(spawn_x1,spawn_y1, "layer_debug", o_indicate_box)) {
		
		rect_w = rectangle_w;
		rect_h = rectangle_h;
		
		outline_bool = outline_bool_;
		
		alpha_val = 1; 
		
		fade_duration = 3; //3 seconds
		
		c = color;
	}
}