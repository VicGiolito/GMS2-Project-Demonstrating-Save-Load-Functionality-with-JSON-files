
/*
Defines our vars used for drawing the tooltip


should be run from scope of o con
*/

function scr_calc_tooltip_layout(tooltip_str){
	
	// set BEFORE calculating, since measurements depend on the font
	draw_set_font(tooltip_fnt); 
	
	var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    // Window mouse position, scaled into GUI space
    var _mx = window_mouse_get_x() * (gui_w / window_get_width());
    var _my = window_mouse_get_y() * (gui_h / window_get_height());

    // Largest box allowed: hard cap, but never wider/taller than the screen
    var _max_w = min(tooltip_max_box_w, gui_w - tooltip_screen_margin * 2);
    var _max_h = gui_h - tooltip_screen_margin * 2;

    // Text wraps at the box width minus padding on both sides
    var _wrap_w = _max_w - tooltip_padding * 2;

    // Box shrinks to fit short text, capped at the max
    tooltip_w = min(string_width_ext(tooltip_str, tooltip_line_h, _wrap_w) + tooltip_padding * 2, _max_w);
    tooltip_h = min(string_height_ext(tooltip_str, tooltip_line_h, _wrap_w) + tooltip_padding * 2, _max_h);

    // Preferred position: below and to the right of the cursor
    var _x = _mx + tooltip_cursor_offset;
    var _y = _my + tooltip_cursor_offset;

    // Flip to the other side of the cursor if it would overflow
    if (_x + tooltip_w > gui_w - tooltip_screen_margin) _x = _mx - tooltip_cursor_offset - tooltip_w;
    if (_y + tooltip_h > gui_h - tooltip_screen_margin) _y = _my - tooltip_cursor_offset - tooltip_h;

    // Final clamp guarantees the box is fully on screen
    tooltip_origin_x = clamp(_x, tooltip_screen_margin, gui_w - tooltip_screen_margin - tooltip_w);
    tooltip_origin_y = clamp(_y, tooltip_screen_margin, gui_h - tooltip_screen_margin - tooltip_h);

    tooltip_txt_origin_x = tooltip_origin_x + tooltip_padding;
    tooltip_txt_origin_y = tooltip_origin_y + tooltip_padding;
	
	//Reset font:
	draw_set_font(global.default_fnt);
}