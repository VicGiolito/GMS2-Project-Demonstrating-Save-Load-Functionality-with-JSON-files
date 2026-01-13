
/* Does NOT reset the g.master_item_ar!


*/

function scr_reset_global_team_arrays(){
	
	global.pc_team_ar = -1
	global.enemy_team_ar = -1;
	global.neutral_team_ar = -1;
	global.pc_building_team_ar = -1;
	global.enemy_building_team_ar = -1;
	global.neutral_building_team_ar = -1;
	global.loot_drop_ar = -1;
	
	global.pc_team_ar = [];
	global.enemy_team_ar = [];
	global.neutral_team_ar = [];
	global.pc_building_team_ar = [];
	global.enemy_building_team_ar = [];
	global.neutral_building_team_ar = [];
	global.loot_drop_ar = [];
}