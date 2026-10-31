

function scr_equip_or_unequip_item(char_struct_id, item_struct_id, equip_boolean){
	
	#region Equip item:
	
	if equip_boolean {
		
		//Equipping weapon or shield:
		if item_struct_id.item_equip_type_enum == inv_slot.rh || item_struct_id.item_equip_type_enum == inv_slot.lh {
				
		}
		
		//Equipping head armor:
		else if item_struct_id.item_equip_type_enum == inv_slot.head {
				
		}
		
		//Equipping body armor:
		else if item_struct_id.item_equip_type_enum == inv_slot.body {
				
		}
		
		//Equipping hands armor:
		else if item_struct_id.item_equip_type_enum == inv_slot.hands {
				
		}
		
		//Equipping feet armor:
		else if item_struct_id.item_equip_type_enum == inv_slot.feet {
				
		}
		
		//Equipping misc armor:
		else if item_struct_id.item_equip_type_enum == inv_slot.accessory {
				
		}
	}
	
	#endregion
	
	#region Unequip item:
	
	else if !equip_boolean {
	
		//Unequipping weapon or shield:
		if item_struct_id.item_equip_type_enum == inv_slot.rh || item_struct_id.item_equip_type_enum == inv_slot.lh {
			
		}
		
		//Unequipping head armor:
		else if item_struct_id.item_equip_type_enum == inv_slot.head {
				
		}
		
		//Unequipping body armor:
		else if item_struct_id.item_equip_type_enum == inv_slot.body {
				
		}
		
		//Unequipping hands armor:
		else if item_struct_id.item_equip_type_enum == inv_slot.hands {
				
		}
		
		//Unequipping feet armor:
		else if item_struct_id.item_equip_type_enum == inv_slot.feet {
				
		}
		
		//Unequipping misc armor:
		else if item_struct_id.item_equip_type_enum == inv_slot.accessory {
				
		}
	}
	
	#endregion
}