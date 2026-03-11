
//Destroys structs whether they've been instantiated or not

//Preserves array structure.

//Technically not even necessary, considering GMS automatically garbage-collects and removes from memory any
//structs that are no longer referenced in the code, but still it's good practice, and just to be on the safe side.

function scr_destroy_all_structs(){
	
	if is_array(global.master_struct_ar) {
	
		for(var i = 0; i < array_length(global.master_struct_ar); i++) { //Iterating through worlds
		
			for(var yy = 0; yy < array_length(global.master_struct_ar[i]); yy++) { //Iterating through floors
				
				for(var g = 0; g < array_length(global.master_struct_ar[i][yy]); g++) { //Iterating through array indices within each floor: AR_PC, AR_ENEMY, etc...
					
					for(var s = 0; s < array_length(global.master_struct_ar[i][yy][g]); s++) { //Iterating through array that is within one of the array indices like AR_PC, etc.
						
						if is_struct(global.master_struct_ar[i][yy][g][s]) {
							
							delete global.master_struct_ar[i][yy][g][s];	
						}	
					}
				}
			}
		}
	}
}