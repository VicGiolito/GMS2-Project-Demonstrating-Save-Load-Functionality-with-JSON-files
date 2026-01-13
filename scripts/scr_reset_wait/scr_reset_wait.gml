
//Currently not in use

function scr_reset_wait(wait_int){
	
	global.wait = false;
	
	with(o_controller) {
		alarm[1] = wait_int;
	}
}