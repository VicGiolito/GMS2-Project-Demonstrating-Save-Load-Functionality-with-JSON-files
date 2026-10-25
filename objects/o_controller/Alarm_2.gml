/// @description setup inv slot boxes:

/*We run this 1 frame after switching gui_state == inv, because we have local vars in draw_gui
event: head_slot_x and head_slot_y, that define the positioning vars for the o_inv_slots:

*/

scr_setup_equip_slots(global.cur_char);

scr_setup_backpack_slots(global.cur_char);







