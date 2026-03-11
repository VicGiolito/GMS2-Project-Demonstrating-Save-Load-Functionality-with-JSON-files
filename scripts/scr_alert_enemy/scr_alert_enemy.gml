/* This simply switches on the g.tactical_pause and centers our camera on the
last applicable enemy_inst_id within the revealed_enemies_ar; we do this whenever a enemy is newly revealed.
*/

function scr_alert_enemy(specific_enemy_inst_id = undefined){
	if is_undefined(specific_enemy_inst_id) {
		var revealed_enemies_ar_len = array_length(o_controller.revealed_enemies_ar), revealed_enemy_id;
		for(var enemy_pos = 0; enemy_pos < revealed_enemies_ar_len; enemy_pos++){
			revealed_enemy_id = o_controller.revealed_enemies_ar[enemy_pos];
			if revealed_enemy_id.show_revealed_spr_boolean {
				//global.tactical_pause = true;
				//global.tactical_pause_explanation = "- ENEMY "+string(revealed_enemy_id)+" REVEALED!";
				//scr_center_on_inst(revealed_enemy_id,global.map_cam,"scr_alert_enemy: centering on newly revealed enemy: "+string(revealed_enemy_id) );	
			}
		}
	}
	else if !is_undefined(specific_enemy_inst_id) {
		if instance_exists(specific_enemy_inst_id) == false {
			show_debug_message("scr_alert_enemy: specific_enemy_inst_id: "+string(specific_enemy_inst_id)+" was not undefined, but that instance no longer exists. Something went wrong returning false.");
			return false;
		}
		if specific_enemy_inst_id.show_revealed_spr_boolean == true {
			//global.tactical_pause = true;
			//global.tactical_pause_explanation = "- ENEMY "+string(specific_enemy_inst_id)+" REVEALED!";
			//scr_center_on_inst(specific_enemy_inst_id,global.map_cam,"scr_alert_enemy: centering on newly revealed enemy: "+string(specific_enemy_inst_id) );		
		}
	}
}