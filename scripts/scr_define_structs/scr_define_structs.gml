


function scr_define_structs(){
	
	#region Our character struct:
	
	Character = function(char_class_enum,char_team_enum,grid_spawn_x,grid_spawn_y,cur_floor_lvl_int,cur_dungeon_enum,visibility_boolean = true) constructor
	{
		struct_enum = struct_type.character; ///Used with scr_return_struct_id and other things
		
		cur_dungeon_ind = cur_dungeon_enum;
		
		//Controls visibility in o_con draw event:
		cur_floor_level = cur_floor_lvl_int;
		visible_boolean = visibility_boolean; //Not actually used to control character visibility; rather, the revealed_enemy_ar is.
		
		//Arrays:
		char_stats_ar = array_create(char_stats.total_stats,false);
		wep_skills_ar = array_create(wep_type.total_wep_types,0);
		ability_ar = array_create(ability.total_ablities,-1);
		idle_conv_ar = []; 
		victory_conv_ar = [];
		inv_ar = -1; //Is used as an array
		equip_slot_ar = -1;
		
		//Define for pcs only:
		if char_team_enum == char_team.pc {
			inv_ar = []; //The 'backpack' for the character.
			array_push(inv_ar,-1); //The inv_ar should always have at least 1 additional slot beyond the number of items it is creating.
			equip_slot_ar = array_create(equip_slot.total_equip_slots,-1); //Misc, head, body, hands, feet, lh, rh
		}
		
		//Default/base stats and vars:
		char_stats_ar[char_stats.base_vision_radius] = global.default_los_radius; //Default
		char_sprite = -1;
		char_portrait_spr = -1;
		cur_wep_skill = -1;
		cur_wep_type = wep_type.none; //Is defined in scr_update_combat_stats_with_item 
		shield_equipped = false;
		
		cur_action_points = 2;
		cur_move_points = 1;
		char_pronoun_str = "he";
		
		char_stats_ar[char_stats.char_class_enum] = char_class_enum;
		
		#region Character stats:
		
		switch(char_class_enum) {
			
			case char_class.kurgun:
				char_stats_ar[char_stats.name] = "Kurgun, the barbarian";
				//Stats:
				char_stats_ar[char_stats.base_str] = 22;
				char_stats_ar[char_stats.base_agil] = 4;
				char_stats_ar[char_stats.base_int] = 2;
				char_stats_ar[char_stats.base_wis] = 7;
				char_stats_ar[char_stats.base_con] = 25;
				char_stats_ar[char_stats.base_per] = 2;
				char_stats_ar[char_stats.base_charisma] = 1;
				char_stats_ar[char_stats.base_will] = 16;
				char_stats_ar[char_stats.base_vision_radius] = global.default_los_radius;
				//Wep skills:
				wep_skills_ar[wep_type.two_handed] = 4;
				wep_skills_ar[wep_type.mace] = 4;
				wep_skills_ar[wep_type.hammer] = 4;
				//Idle conversation elements:
				array_push(idle_conv_ar, "\"I am strong! I am worthy!\" Kurgun bellows. \"My mother's death will NOT be in vain!\"");
				array_push(idle_conv_ar,"Kurgun says: \"Pah! Wizards. If only I could rid the world of the whole lot of them.\"");
				array_push(idle_conv_ar,"Kurgun says: \"Show me a worthy ogre foe and I shall make him pay!\"");
	            array_push(idle_conv_ar,"Kurgun says: \"What use is a wizard's magic against the strength of my fist?\"");
	            array_push(idle_conv_ar,"Kurgun says: \"'Mordra,' the wizard's name? Never met him. But if he be as strong as you say, then I'll consider it an honor to slay him.\"");
	            array_push(idle_conv_ar,"Kurgun says: \"You want this wizard 'Mordra' dead, and I tell you I will do it. But let me be clear: I am here for the coin which was promised, and for the worthy foe, who lurks ahead.\"");
	            array_push(idle_conv_ar,"Kurgun roars: \"Enough of this skulking about! Point me in the direction of a real warrior!\"");
	            array_push(idle_conv_ar,"\"Ogres?\" Kurgun says. \"I despise their race, and so hate no one more than myself.\"");
	            array_push(idle_conv_ar,"Kurgun asks: \"Is it not enough that I bear the shame of ogre blood flowing through my veins? Let me use my father's strength then, for redemption--for revenge!\"");
	            array_push(idle_conv_ar,"Kurgun says: \"My mother's gentle hand was the only kindness I've ever known. If only she had not been taken from me so soon, I may never have turned to war.\""); 
	            array_push(idle_conv_ar,"Kurgun says: \"My own father fed my mother as sacrifice to the great water wurm Slazu, the god of the northern tribes.\" Kurgun grins savagely. \"When I became a man, I repaid him for his cruelty.\"");
	            array_push(idle_conv_ar,"Kurgun cracks his knuckles, and grins a sinister smile.");
	            array_push(idle_conv_ar,"Kurgun cracks his knuckles, and grins a sinister smile.");
				//Combat victory conv:
				array_push(victory_conv_ar, "Kurgun roars in triumph. \"I AM A MONSTER MORE TERRIBLE THAN YOU!\"");
	            array_push(victory_conv_ar,"Kurgun asks, \"Did you really think that the forces of good were all wizard welps and weak men?\"");
	            array_push(victory_conv_ar,"\"Mordra!\" Kurgun cries. \"Can you see me now?\"");
	            array_push(victory_conv_ar,"\"I am more monster than man!\" Kurgun screams. \"Do you think that I am afraid of you?\"");
	            array_push(victory_conv_ar,"\"WEAKLING!\" Kurgun cries. \"Show me a worthy foe!\""); 
				array_push(victory_conv_ar,"Kurgun asks, \"Did you really think that every monster in the world would only follow Mordra?\"");
				
				char_sprite = spr_pc_ogre;
				char_portrait_spr = spr_pc_ogre;
				
			break;
			
			case char_class.acheron:
				char_stats_ar[char_stats.name] = "Acheron, the magician"
				//Stats:
				char_stats_ar[char_stats.base_str] = 4;
				char_stats_ar[char_stats.base_agil] = 6;
				char_stats_ar[char_stats.base_int] = 25;
				char_stats_ar[char_stats.base_wis] = 18;
				char_stats_ar[char_stats.base_con] = 4;
				char_stats_ar[char_stats.base_per] = 9;
				char_stats_ar[char_stats.base_charisma] = 18;
				char_stats_ar[char_stats.base_will] = 25;
				char_stats_ar[char_stats.base_vision_radius] = 5;
				//Wep skills:
				wep_skills_ar[wep_type.staff] = 4;
				//Idle cov:
				array_push(idle_conv_ar,"Acheron mumbles arcane formulas and figures beneath his beard.");
	            array_push(idle_conv_ar,"Acheron mumbles arcane formulas and figures beneath his beard.");
				array_push(idle_conv_ar,"\"Oh, I just remembered the name of an old spell!...\" Acheron's shaggy brows finally fall. \"...Never mind, I've lost it.\"");
	            array_push(idle_conv_ar,"Acheron says: \"Mordra and I were both students of the Gray Spire, you know, though that was more than five centuries ago. I still remember how the leaves of the Golden Wood were just begin to fall during our graduation ceremony...\"");
	            array_push(idle_conv_ar,"Acheron says: \"Mordra and I were fast friends during our time in the Gray Spire, yet five hundred years can change a man. Now he is far beyond redemption.\"");
	            array_push(idle_conv_ar,"Acheron says: \"Cherish this moment, even if it may be ugly. Everything falls apart, in the end. That is the natural way of the world.\"");
	            array_push(idle_conv_ar,"Acheron is calculating how many gallons of sea water are left in the world while pondering the acrimonious relationship between cats and dogs.");
	            array_push(idle_conv_ar,"Acheron is trying to remember the name of his first dog, who died more than five hundred years ago. He was a good boy.");
	            array_push(idle_conv_ar,"Acheron is calculating the air speed velocity of an unladen swallow.");
	            array_push(idle_conv_ar,"Acheron is dividing by five, multiplying by the square root, carrying the three...");
	            array_push(idle_conv_ar,"Acheron is calculating to the fortieth digit of Pi...");
	            array_push(idle_conv_ar,"Acheron is remembering the moment when he met his first wife in the golden wood. He can recall her smile so clearly... And her eyes...");
	            array_push(idle_conv_ar,"Acheron says: \"For centuries I've held fast the Gray Spire against the forces of evil. I shall not see it finally fall to this upstart 'Mordra the Menace'!\"");
	            array_push(idle_conv_ar,"Acheron says: \"Mordra and I were school boy chums, once; though between you and me, I always thought he was a bit dim.\"");
	            array_push(idle_conv_ar,"Acheron says: \"I always was the better duelist with spells, when Mordra and I were still students of the Gray Spire. I wonder who is the better duelist now?\"");
	            array_push(idle_conv_ar,"Acheron says: \"My magic power has extended my years beyond their mortal span, yet for all of us the magic must fade away, some day. If only Mordra could have accepted this great truth as I have. Alas, he has turned instead to the unholy rites of blood sacrifice to extend his life span. Now he shall fall forever in darkness...\"");

				char_sprite = spr_pc_wizard;
				char_portrait_spr = spr_pc_wizard;
			break;
			
			case char_class.roderick:
				char_stats_ar[char_stats.name] = "Roderick, the ranger";
				//Stats:
				char_stats_ar[char_stats.base_str] = 13;
				char_stats_ar[char_stats.base_agil] = 16;
				char_stats_ar[char_stats.base_int] = 12;
				char_stats_ar[char_stats.base_wis] = 15;
				char_stats_ar[char_stats.base_con] = 12;
				char_stats_ar[char_stats.base_per] = 16;
				char_stats_ar[char_stats.base_charisma] = 12;
				char_stats_ar[char_stats.base_will] = 9;
				char_stats_ar[char_stats.base_vision_radius] = 9;
				//Wep skills:
				wep_skills_ar[wep_type.bow] = 4;
				wep_skills_ar[wep_type.crossbow] = 4;
				wep_skills_ar[wep_type.sword] = 4;
				wep_skills_ar[wep_type.firearm] = 2;
				//Idle cov:
				array_push(idle_conv_ar,"Roderick says: \"I've traveled the length and breadth of the Wilds to be here now. Let us not tarry!\"");
	            array_push(idle_conv_ar,"Roderick says: \"My wanderings have taught me to always expect the unexpected!\"");
	            array_push(idle_conv_ar,"Roderick says: \"My wanderings have taught me to always expect the unexpected!\"");
	            array_push(idle_conv_ar,"Roderick says: \"My village was burned to ash by Mordra and his minions when I was but a boy. It is because of him that I have wandered far and am forever restless.\"");
	            array_push(idle_conv_ar,"Roderick says: \"I thought I knew the name of every beast that flies, flees and slithers in this world; yet in this place, I am pleased to say that I am ignorant.\"");
	            array_push(idle_conv_ar,"Roderick nocks an arrow in his bow. \"Keep a watchful eye about you!\"");
	            array_push(idle_conv_ar,"Roderick says: \"My boots shall never tire beneath an open sky; it is the cold dungeons of the earth that make them drag.\"");
	            array_push(idle_conv_ar,"Roderick says: \"Too long has Mordra been the scourge of the civilized world. By my bow or my steel he shall meet his end.\"");
	            array_push(idle_conv_ar,"Roderick says: \"I never knew my parents as a child. I only ever knew their tombstones, which were cold and dark beneath the limbs of a willow bright and weeping. I have Mordra to thank for that.\"");
	            array_push(idle_conv_ar,"Roderick says: \"I am among the few mortals in this world to have walked the land of the Fae--and lived to tell the tale.\"");
	            array_push(idle_conv_ar,"Roderick says: \"I shall never forget the wonders that I saw in the land of the Fae... And only when I am dead can I ever hope to return there.\"");
	            array_push(idle_conv_ar,"\"Stay sharp!\" Roderick tightens his scabbard. \"Enemies abound!\"");
				
				char_sprite = spr_pc_ranger;
				char_portrait_spr = spr_pc_ranger;
			break;
			
			case char_class.thade:
				char_stats_ar[char_stats.name] = "Thade, the criminal";
				//Stats:
				char_stats_ar[char_stats.base_str] = 12;
				char_stats_ar[char_stats.base_agil] = 14;
				char_stats_ar[char_stats.base_int] = 4;
				char_stats_ar[char_stats.base_wis] = 4;
				char_stats_ar[char_stats.base_con] = 10;
				char_stats_ar[char_stats.base_per] = 15;
				char_stats_ar[char_stats.base_charisma] = 4;
				char_stats_ar[char_stats.base_will] = 4;
				char_stats_ar[char_stats.base_vision_radius] = global.default_los_radius;
				//Wep skills:
				wep_skills_ar[wep_type.dagger] = 2;
				//Idle conv ar:
				array_push(idle_conv_ar,"Thade says: \"I'm innocent, I swear! I've never even been near the governor's house!\"");
	            array_push(idle_conv_ar,"Thade says: \"Don't look at me like that, I haven't done anything!\"");
	            array_push(idle_conv_ar,"Thade checks his pockets and shifts restlessly.");
	            array_push(idle_conv_ar,"Thade scratches his arms and his beard nervously.");
	            array_push(idle_conv_ar,"Thade smiles, or perhaps he sneers; a previous bout of the pox plague has scarred his features into a permanent leering mask.");
	            array_push(idle_conv_ar,"Thade says: \"Look, I never even met the man before he sent the constable for me!\"");
	            array_push(idle_conv_ar,"Thade says: \"It was a kangaroo court that sent me to the stocks. You think I give a damn about my fellow man after that?\"");
	            array_push(idle_conv_ar,"Thade says: \"'Mordra,' eh? Never met the guy, but he sure has a sick sense of humor, by the looks of it.\"");
	            array_push(idle_conv_ar,"Thade says: \"Is this place worse than the stocks? Not sure yet. At least here I don't have that fucking pillory 'round my neck.\"");
	            array_push(idle_conv_ar,"Thade says: \"I'm telling you, someone planted that gold necklace in my room, I had never even seen it before!\"");
	            array_push(idle_conv_ar,"Thade says: \"So this 'Mordra' is the wizard trying to take over the world, huh? Maybe a new change in management is in order; the king and his men ain't ever done a thing for me and mine, anyhow.\"");
	            //array_push(idle_conv_ar,"Thade says: \"Twelve days and twelve nights in the stocks, then this weird bright light just before I was to hang. Next thing, I'm  a thousand leagues away. , and next thing I know I end up here with some strange folk. Life sure is strange.\"");
	            //array_push(idle_conv_ar,"Thade says: \"I ain't no hero; I have no fucking clue why this Mordra fellow brought me here.\"");
				array_push(idle_conv_ar,"Thade says: \"I ain't no hero--so don't get your hopes up.");
				array_push(idle_conv_ar,"Thade says: \"I can take care of myself just fine. That's all I ever done.");
				
	            array_push(idle_conv_ar,"Thade winces against the weight of the uprooted pillory around his neck. \"Get this fucking thing off me!\"");
        
				char_sprite = spr_pc_thief;
				char_portrait_spr = spr_pc_thief;
			break;
			case char_class.ulric:
				char_stats_ar[char_stats.name] = "Ulric, the priest";
				//Stats:
				char_stats_ar[char_stats.base_str] = 11;
				char_stats_ar[char_stats.base_agil] = 10;
				char_stats_ar[char_stats.base_int] = 12;
				char_stats_ar[char_stats.base_wis] = 18;
				char_stats_ar[char_stats.base_con] = 13;
				char_stats_ar[char_stats.base_per] = 8;
				char_stats_ar[char_stats.base_charisma] = 12;
				char_stats_ar[char_stats.base_will] = 9;
				char_stats_ar[char_stats.base_vision_radius] = global.default_los_radius;
				//Wep skills:
				wep_skills_ar[wep_type.mace] = 3;
				wep_skills_ar[wep_type.shield] = 2;
				
				array_push(idle_conv_ar,"Ulric shouts: \"This sinner Mordred shall be baptized by holy fire!\"");
				array_push(idle_conv_ar,"Ulric mutters a prayer for strength.");
				
				char_sprite = spr_pc_priest;
				char_portrait_spr = spr_pc_priest;
			break;
			case char_class.diana:
				char_stats_ar[char_stats.name] = "Diana, the huntress";
				//Stats:
				char_stats_ar[char_stats.base_str] = 10;
				char_stats_ar[char_stats.base_agil] = 18;
				char_stats_ar[char_stats.base_int] = 14;
				char_stats_ar[char_stats.base_wis] = 20;
				char_stats_ar[char_stats.base_con] = 8;
				char_stats_ar[char_stats.base_per] = 18;
				char_stats_ar[char_stats.base_charisma] = 12;
				char_stats_ar[char_stats.base_will] = 8;
				char_stats_ar[char_stats.base_vision_radius] = 11;
				//Wep skills:
				wep_skills_ar[wep_type.bow] = 6;
				wep_skills_ar[wep_type.crossbow] = 2;
				
				array_push(idle_conv_ar,"I have nothing to say.");
				
				char_sprite = spr_pc_archer;
				char_portrait_spr = spr_pc_archer;
				
				char_pronoun_str = "she";
		
			break;
			case char_class.crag: //Alternative names (can't use Tiny, Dota copyright): slag, slab, crag (like this), pebbles.
				char_stats_ar[char_stats.name] = "Crag, the golem";
				//Stats:
				char_stats_ar[char_stats.base_str] = 30;
				char_stats_ar[char_stats.base_agil] = 1;
				char_stats_ar[char_stats.base_int] = 1;
				char_stats_ar[char_stats.base_wis] = 1;
				char_stats_ar[char_stats.base_con] = 32;
				char_stats_ar[char_stats.base_per] = 1;
				char_stats_ar[char_stats.base_charisma] = 1;
				char_stats_ar[char_stats.base_will] = 32;
				char_stats_ar[char_stats.base_vision_radius] = 5;
				//Wep skills:
				
				array_push(idle_conv_ar,"Dust explodes and pebbles tumble; Crag smiles his inscrutable smile.");
	            array_push(idle_conv_ar,"Crag furrows his craggy brow.");
	            array_push(idle_conv_ar,"Crag scratches his head.");
	            array_push(idle_conv_ar,"Crag sighs with the sound of a bellowing furnace.");
	            array_push(idle_conv_ar,"Crag grumbles like a land slide.");
	            array_push(idle_conv_ar,"Crag says: \"Hmph!\"");
	            array_push(idle_conv_ar,"Crag scratches an elbow with a shower of flinty sparks.");
	            array_push(idle_conv_ar,"Crag plucks an earth worm from his head. Stares at it. Smiles.");
				
				char_sprite = spr_pc_crag;
				char_portrait_spr = spr_pc_crag;
		
			break;
			case char_class.zool:
				char_stats_ar[char_stats.name] = "Zool, the necromancer";
				//Stats:
				char_stats_ar[char_stats.base_str] = 6;
				char_stats_ar[char_stats.base_agil] = 8;
				char_stats_ar[char_stats.base_int] = 20;
				char_stats_ar[char_stats.base_wis] = 16;
				char_stats_ar[char_stats.base_con] = 7;
				char_stats_ar[char_stats.base_per] = 11;
				char_stats_ar[char_stats.base_charisma] = 12;
				char_stats_ar[char_stats.base_will] = 12;
				char_stats_ar[char_stats.base_vision_radius] = global.default_los_radius;
				//Wep skills:
				wep_skills_ar[wep_type.dagger] = 2;
				wep_skills_ar[wep_type.staff] = 3;
				
				array_push(idle_conv_ar,"I have nothing to say.");
				
				char_sprite = spr_pc_necromancer;
				char_portrait_spr = spr_pc_necromancer;
		
			break;
			case char_class.neleera:
				char_stats_ar[char_stats.name] = "Neleera, the relic hunter";
				//Stats:
				char_stats_ar[char_stats.base_str] = 8;
				char_stats_ar[char_stats.base_agil] = 18;
				char_stats_ar[char_stats.base_int] = 14;
				char_stats_ar[char_stats.base_wis] = 12;
				char_stats_ar[char_stats.base_con] = 8;
				char_stats_ar[char_stats.base_per] = 16;
				char_stats_ar[char_stats.base_charisma] = 16;
				char_stats_ar[char_stats.base_will] = 5;
				char_stats_ar[char_stats.base_vision_radius] = global.default_los_radius;
				
				//Wep skills:
				wep_skills_ar[wep_type.dagger] = 2;
				wep_skills_ar[wep_type.sword] = 2;
				wep_skills_ar[wep_type.bow] = 4;
				wep_skills_ar[wep_type.crossbow] = 2;
				wep_skills_ar[wep_type.firearm] = 2;

				array_push(idle_conv_ar,"I have nothing to say.");
				
				char_sprite = spr_char_treasure_hunter;
				char_portrait_spr = spr_char_treasure_hunter;
		
			break;
			case char_class.goblin_cretin:
				char_stats_ar[char_stats.name] = "goblin cretin";
				//Stats:
				char_stats_ar[char_stats.base_str] = 8;
				char_stats_ar[char_stats.base_agil] = 14;
				char_stats_ar[char_stats.base_int] = 5;
				char_stats_ar[char_stats.base_wis] = 4;
				char_stats_ar[char_stats.base_con] = 8;
				char_stats_ar[char_stats.base_per] = 17;
				char_stats_ar[char_stats.base_charisma] = 1;
				char_stats_ar[char_stats.base_will] = 2;
				char_stats_ar[char_stats.base_vision_radius] = global.default_los_radius;
				//Wep skills:
				wep_skills_ar[wep_type.bow] = 2;
				wep_skills_ar[wep_type.crossbow] = 2;
				wep_skills_ar[wep_type.sword] = 2;
				wep_skills_ar[wep_type.spear] = 2;
				wep_skills_ar[wep_type.shield] = 2;
				wep_skills_ar[wep_type.axe] = 2;
				
				array_push(idle_conv_ar,"Goblin Cretin says: \"I'm a loathsome little git!'\"");
				
				char_sprite = spr_goblin;
				char_portrait_spr = spr_goblin;
				
				enemy_position_weight = 10;
		
			break;
			case char_class.goblin_brute:
				char_stats_ar[char_stats.name] = "goblin brute";
				//Stats:
				char_stats_ar[char_stats.base_str] = 20;
				char_stats_ar[char_stats.base_agil] = 10;
				char_stats_ar[char_stats.base_int] = 4;
				char_stats_ar[char_stats.base_wis] = 5;
				char_stats_ar[char_stats.base_con] = 18;
				char_stats_ar[char_stats.base_per] = 10;
				char_stats_ar[char_stats.base_charisma] = 1;
				char_stats_ar[char_stats.base_will] = 4;
				char_stats_ar[char_stats.base_vision_radius] = global.default_los_radius;
				//Wep skills:
				wep_skills_ar[wep_type.two_handed] = 5;
				wep_skills_ar[wep_type.mace] = 2;
				wep_skills_ar[wep_type.hammer] = 2;
				wep_skills_ar[wep_type.shield] = 2;
				
				array_push(idle_conv_ar,"Goblin Cretin says: \"I'm an even bigger loathsome git!'\"");
				
				char_sprite = spr_orc;
				char_portrait_spr = spr_orc;
				
				enemy_position_weight = 0;
		
			break;
		}
		
		//Define 'cur' stats from base stats:
		char_stats_ar[char_stats.cur_con] = char_stats_ar[char_stats.base_con];
		char_stats_ar[char_stats.cur_int] = char_stats_ar[char_stats.base_int];
		char_stats_ar[char_stats.cur_str] = char_stats_ar[char_stats.base_str];
		char_stats_ar[char_stats.cur_agil] = char_stats_ar[char_stats.base_agil];
		char_stats_ar[char_stats.cur_charisma] = char_stats_ar[char_stats.base_charisma];
		char_stats_ar[char_stats.cur_per] = char_stats_ar[char_stats.base_per];
		char_stats_ar[char_stats.cur_will] = char_stats_ar[char_stats.base_will];
		char_stats_ar[char_stats.cur_wis] = char_stats_ar[char_stats.base_wis];
		char_stats_ar[char_stats.cur_vision_radius] = char_stats_ar[char_stats.base_vision_radius];
		
		//Define other stat values from stats:
		char_stats_ar[char_stats.hp_cur] = char_stats_ar[char_stats.cur_con]; //Base Hp Max == 100% of con
		char_stats_ar[char_stats.hp_max] = char_stats_ar[char_stats.hp_cur];
		char_stats_ar[char_stats.stam_cur] = round(char_stats_ar[char_stats.cur_con]*.5); //Base Stam Max == 100% of con
		char_stats_ar[char_stats.stam_max] = char_stats_ar[char_stats.stam_cur];
		char_stats_ar[char_stats.mana_cur] = char_stats_ar[char_stats.cur_int]; //Base Mana Max == 100% of int
		char_stats_ar[char_stats.mana_max] = char_stats_ar[char_stats.mana_cur];
		char_stats_ar[char_stats.morale_cur] = char_stats_ar[char_stats.cur_will]; //Base Morale Max == 100% of will
		char_stats_ar[char_stats.morale_max] = char_stats_ar[char_stats.morale_cur];
		char_stats_ar[char_stats.max_carrying_capacity] = char_stats_ar[char_stats.cur_str]*12;
		char_stats_ar[char_stats.cur_carrying_capacity] = 0; //Is defined in scr_define_char_class_starting_equipment()
	
		//Define combat stats:
		base_melee_min_dmg = round(char_stats_ar[char_stats.cur_str]*.5);
		base_melee_max_dmg = round(char_stats_ar[char_stats.cur_str]*1.5);
		base_ranged_min_dmg = round(char_stats_ar[char_stats.cur_per]*.5);
		base_ranged_max_dmg = round(char_stats_ar[char_stats.cur_per]*1.5);
		base_ranged_tohit_mod = char_stats_ar[char_stats.cur_per]*4;
		base_melee_tohit_mod = char_stats_ar[char_stats.cur_agil]*4;
		base_armor_pen = 0;
		base_magic_pen = 0;
		base_physical_resist = 0;
		base_magical_resist = 0;
		base_block_chance = round(char_stats_ar[char_stats.cur_str]*.5);
		base_melee_evasion = round(char_stats_ar[char_stats.cur_agil]*.5);
		base_ranged_evasion = round(char_stats_ar[char_stats.cur_agil]*.5);
		
		max_action_points = cur_action_points;
		max_move_points = cur_move_points;
		
		//Adjust baseToHitMod for classes with very low agil, and other class-specific stats:
		if(char_class_enum == char_class.kurgun) {
			base_melee_tohit_mod = (char_stats_ar[char_stats.cur_agil]*4)+43;
			base_magical_resist = -0.25;
		} else if(char_class_enum == char_class.crag) {
			base_melee_tohit_mod = (char_stats_ar[char_stats.cur_agil]*4)+73;
		}
		
		//Define our 'total' stats:
		total_armor_pen = base_armor_pen; //This value subtracts from the target's 'physical_resist' value; the target's physical resist cannot go below zero in this way.
        total_magic_pen = base_magic_pen; //This value subtracts from the target's 'magical_resist' value; the target's magic resist cannot go below zero in this way.
        total_physical_resist = base_physical_resist;
        total_magical_resist = base_magical_resist;
        total_melee_evasion = base_melee_evasion;
		total_ranged_evasion = base_ranged_evasion;
        total_block_chance = base_block_chance;
        total_melee_min_dmg = base_melee_min_dmg;
        total_melee_max_dmg = base_melee_max_dmg;
        total_ranged_min_dmg = base_ranged_min_dmg;
        total_ranged_max_dmg = base_ranged_max_dmg;
        total_melee_tohit = base_melee_tohit_mod;
		total_ranged_tohit = base_ranged_tohit_mod;
		
		//Define armor variables:
		armor_cur_head = 0;
		armor_max_head = armor_cur_head;
		armor_cur_body = 0;
		armor_max_body = armor_cur_body;
		armor_cur_hands = 0;
		armor_max_hands = armor_cur_hands;
		armor_cur_feet = 0;
		armor_max_feet = armor_cur_feet;
		
		idle_conv_count = 0;
		idle_conv_max = irandom_range(1,20);
		
		#endregion
		
		//Combat related vars:
		action_queue = -1; //Used in combat; should represent a ability enum value.
		target_of_ability = -1; //Will be a struct instance of o_char
		
		char_grid_x = grid_spawn_x;
		char_grid_y = grid_spawn_y;
		
		//Make sure we snap our coordinates to the nearest grid cell when this is created:
		var pos_ar = [];
		pos_ar = scr_convert_grid_to_room_coordinates(pos_ar,char_grid_x,char_grid_y);
		
		char_room_x =  pos_ar[0];
		char_room_y =  pos_ar[1];
		pos_ar = -1;
		
		//Add to appropriate inst_grid cell:
		scr_add_struct_to_inst_grid(self,char_grid_x,char_grid_y,cur_floor_lvl_int,cur_dungeon_enum);
		
		sprite_image_index = 0; //Default
		
		char_stats_ar[char_stats.char_team_enum] = char_team_enum;
		
		//Add to appropriate array:
		if char_team_enum == char_team.pc { 
			array_push(global.master_struct_ar[cur_dungeon_enum][cur_floor_lvl_int][AR_PC],self);
			array_push(global.pc_team_ar,self); //These *_team arrays are NOT used for drawing sprites, checking LOS, etc.; they're only used for easy reference-type purposes.
		}
		
		else if char_team_enum == char_team.enemy { 
			array_push(global.master_struct_ar[cur_dungeon_enum][cur_floor_lvl_int][AR_ENEMY],self); 
			array_push(global.enemy_team_ar,self);
		}
		
		else {
			array_push(global.master_struct_ar[cur_dungeon_enum][cur_floor_lvl_int][AR_NEUTRAL],self);
			array_push(global.neutral_team_ar,self);	
		}
		
		//show_debug_message("Character struct constructor: Character struct with id: "+string(self)+", gridX: "+
		//string(char_grid_x)+", gridY: "+string(char_grid_y) );
		
		show_revealed_spr_boolean = false; //This will indicate whether or not we draw the exclamation point over newly revealed enemies
		
		show_debug_message("Constructor event for Character struct: Character struct instanitated with character name: "+string(self.char_stats_ar[char_stats.name]) );
		
		return self;
	}
	
	#endregion
	
	#region Our item struct:
	
	Item = function(item_class_enum, floor_int,cur_dungeon_enum) constructor
	{
		cur_floor_level = floor_int;
		
		cur_dungeon_ind = cur_dungeon_enum;
		
		struct_enum = struct_type.item; ///Used with scr_return_struct_id and other things
		
		//Default vars:
		item_class = item_class_enum;
		item_weapon_type_enum = wep_type.none; //Used for determining the corresponding wep_skill buffs that the char will benefit from when this item is equipped.
		item_equip_type_enum = item_equip_type.none; //Used for logic within scr_equip_unequip_item
		item_name = "Not Defined By Constructor Event";
		dura_cur = 0;
		
		item_sprite = spr_item_placeholder;
		
		description = "";
		armor_pen = 0;
		magic_pen = 0;
		is_equipped = false; //I don't foresee a scenario where this will necessary.
		is_ranged_weapon = false; //I don't foresee a scenario where this will necessary
		is_weapon = false;
		value = 0;
		melee_evasion_mod = 0;
		ranged_evasion_mod = 0;
		block_mod = 0;
		physical_resist = 0;
		magical_resist = 0;
		stam_debuff = 0;
		melee_min_dmg = 0;
		melee_max_dmg = 0;
		ranged_min_dmg = 0;
		ranged_max_dmg = 0;
		melee_to_hit_mod = 0;
		ranged_to_hit_mod = 0;
		is_armor = false;
		is_cursed = false;
		weight_val = 0; //In pounds
		contains_meat = false;
		satiation_val = 0; //Consider that most pcs consume 1 food unit at the end of each turn.
		causes_food_poisoning = false; //If true, the char will need to pass a constitution test or get sick.
		item_range = 0; //0: melee; 1: polearm; 2: ranged.
		
		//Start defining stats for each weapon:
		switch(item_class) {
			
			case item_enum.wep_axe_two_hand_rusty:
				item_name = "Rusty Woodcutter's Axe";
				dura_cur = 25;
				melee_min_dmg = 2;
				melee_max_dmg = 6;
				armor_pen = 125;
				item_equip_type_enum = item_equip_type.two_hand;
				is_weapon = true;
				melee_to_hit_mod = 5;
				block_mod = 7;
				stam_debuff = 1;
				item_weapon_type_enum = wep_type.two_handed;
				description = "This basic version of a big woodcutter's axe is battered and blunted.";
				value = 10;
				weight_val = 25;
			break;
			
			case item_enum.wep_axe_one_hand_rusty:
				item_name = "Rusty Hatchet";
				dura_cur = 20;
				melee_min_dmg = 1;
				melee_max_dmg = 3;
				armor_pen = 125;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = true;
				melee_to_hit_mod = 5;
				block_mod = 3;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.axe;
				description = "This basic version of a woodcutter's hatchet is battered and blunted.";
				value = 5;
				weight_val = 8;
			break;
			
			case item_enum.wep_sword_one_hand_rusty:
				item_name = "Rusty Short Sword";
				dura_cur = 20;
				melee_min_dmg = 2;
				melee_max_dmg = 4;
				armor_pen = 85;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = true;
				melee_to_hit_mod = 4;
				block_mod = 5;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.sword;
				description = "Rusty iron short sword.";
				value = 10;
				weight_val = 12;
			break;
			
			case item_enum.wep_sword_two_hand_rusty:
				item_name = "Rusty Two Handed Great Sword";
				dura_cur = 25;
				melee_min_dmg = 3;
				melee_max_dmg = 8;
				armor_pen = 75;
				item_equip_type_enum = item_equip_type.two_hand;
				is_weapon = true;
				melee_to_hit_mod = 10;
				block_mod = 7;
				stam_debuff = 1;
				item_weapon_type_enum = wep_type.two_handed;
				description = "This may have been a noble great sword a century ago; now it's barely passable as a weapon.";
				value = 10;
				weight_val = 25;
			break;
			
			case item_enum.wep_polearm_pike_rusty:
				item_name = "Rusty Pike";
				dura_cur = 35;
				melee_min_dmg = 3;
				melee_max_dmg = 6;
				armor_pen = 75;
				item_equip_type_enum = item_equip_type.two_hand;
				is_weapon = true;
				melee_to_hit_mod = 10;
				block_mod = 7;
				stam_debuff = 1;
				item_weapon_type_enum = wep_type.polearm;
				description = "Just a huge length of hard wood with a rusty iron spear head.";
				value = 10;
				weight_val = 25;
				item_range = 1;
			break;
			
			case item_enum.wep_polearm_halberd_rusty:
				item_name = "Rusty Halberd";
				dura_cur = 35;
				melee_min_dmg = 4;
				melee_max_dmg = 8;
				armor_pen = 110;
				item_equip_type_enum = item_equip_type.two_hand;
				is_weapon = true;
				melee_to_hit_mod = 5;
				block_mod = 7;
				stam_debuff = 1;
				item_weapon_type_enum = wep_type.polearm;
				description = "A powerful and versatile weapon that can serve as both an axe, a spear, and a hammer. Nonetheless, this particular weapon has seen better days.";
				value = 10;
				weight_val = 25;
				item_range = 1;
			break;
			
			case item_enum.wep_mace_one_hand_rusty:
				item_name = "Rusty Mace";
				dura_cur = 20;
				melee_min_dmg = 1;
				melee_max_dmg = 3;
				armor_pen = 150;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = true;
				melee_to_hit_mod = 2;
				block_mod = 3;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.mace;
				description = "This is just a stick with an iron head; looks like it could break at any moment.";
				value = 5;
				weight_val = 15;
			break;
			
			case item_enum.wep_mace_one_hand_average:
				item_name = "Iron Mace";
				dura_cur = 20;
				melee_min_dmg = 2;
				melee_max_dmg = 5;
				armor_pen = 150;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = true;
				melee_to_hit_mod = 5;
				block_mod = 6;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.mace;
				description = "Likely forged by a castle smithy, this sturdy mace with a flanged iron head could deal some decent blunt damage.";
				value = 5;
				weight_val = 18;
			break;
			
			case item_enum.wep_hammer_one_hand_rusty:
				item_name = "Rusty Hammer";
				dura_cur = 10;
				melee_min_dmg = 1;
				melee_max_dmg = 2;
				armor_pen = 200;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = true;
				melee_to_hit_mod = 1;
				block_mod = 1;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.hammer;
				description = "This fragile looking hammer looks like it could have been made for a carpenter. Still, it could puncture armor a bit.";
				value = 3;
				weight_val = 13;
			break;
			
			case item_enum.wep_dagger_one_hand_rusty:
				item_name = "Rusty Knife";
				dura_cur = 10;
				melee_min_dmg = 1;
				melee_max_dmg = 2;
				armor_pen = 75;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = true;
				melee_to_hit_mod = 1;
				block_mod = 1;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.dagger;
				description = "This might have been a kitchen knife in a previous life; better than nothing, at any rate.";
				value = 2;
				weight_val = 2;
			break;
			
			case item_enum.wep_spear_one_hand_rusty:
				item_name = "Pointed Stick";
				dura_cur = 20;
				melee_min_dmg = 2;
				melee_max_dmg = 4;
				armor_pen = 85;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = true;
				melee_to_hit_mod = 5;
				block_mod = 1;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.spear;
				description = "This is just a sturdy stick with a sharpened point.";
				value = 5;
				weight_val = 8;
			break;
			
			case item_enum.wep_torch_crude:
				item_name = "Crude Torch";
				dura_cur = 20;
				melee_min_dmg = 0; //Be sure to keep this 0 as it's the only wep in the game that can be 'dual wielded'
				melee_max_dmg = 0;
				armor_pen = 0;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = true;
				melee_to_hit_mod = 0;
				block_mod = 0;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.torch; //Is unique
				description = "An invaluable tool for any spelunking adventurer. Its fragile flames can reveal treasures from your wildest dreams--or monsters from your darkest nightmares.";
				value = 15;
				weight_val = 2;
			break;
			
			case item_enum.misc_gold_necklance:
				item_name = "Crude Golden Necklace";
				dura_cur = 1;
				melee_min_dmg = 0;
				melee_max_dmg = 0;
				armor_pen = 0;
				item_equip_type_enum = item_equip_type.misc;
				is_weapon = true;
				melee_to_hit_mod = 0;
				block_mod = 0;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.none;
				description = "A kind-hearted merchant might accept this shiny bauble for a coin or two.";
				value = 50;
				weight_val = 1;
			break;
			
			case item_enum.item_tools_and_supplies:
				item_name = "Bundle of Tools and Supplies";
				dura_cur = 1;
				melee_min_dmg = 0;
				melee_max_dmg = 0;
				armor_pen = 0;
				item_equip_type_enum = item_equip_type.none;
				is_weapon = true;
				melee_to_hit_mod = 0;
				block_mod = 0;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.none;
				description = "Assorted tools and supplies; everything an adventurer might need to survive in the Wilds or the darkest dungeons.";
				value = 75;
				weight_val = 25;
			break;
			
			case item_enum.food_ration_iron:
				item_name = "Iron Rations";
				dura_cur = 30;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "Expertly sealed and salted meats and bread which will last a long time. Very satiating.";
				value = 75;
				weight_val = 3;
				is_food = true;
				contains_meat = true;
				satiation_val = 15;
			break;
			
			case item_enum.food_ration:
				item_name = "Rations";
				dura_cur = 20;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "Carefully packed meats and bread which will last a while. Moderately satiating.";
				value = 50;
				weight_val = 2;
				is_food = true;
				contains_meat = true;
				satiation_val = 10;
			break;
			
			case item_enum.food_ration_meager:
				item_name = "Rations";
				dura_cur = 10;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "Some unsalted slices of mysterious meat and crackers. This won't last long.";
				value = 50;
				weight_val = 2;
				is_food = true;
				contains_meat = true;
				satiation_val = 5;
			break;
			
			case item_enum.food_mutton_raw:
				item_name = "Raw Mutton";
				dura_cur = 8;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "Only a barbarian or some kind of animal would appreciate eating raw meat.";
				value = 10;
				weight_val = 1;
				is_food = true;
				contains_meat = true;
				satiation_val = 3;
				causes_food_poisoning = true;
			break;
			
			case item_enum.food_mutton_cooked:
				item_name = "Cooked Mutton";
				dura_cur = 15;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "Cooked hunk of animal meat, somewhat satiating.";
				value = 30;
				weight_val = 1;
				is_food = true;
				contains_meat = true;
				satiation_val = 6;
			break;
			
			case item_enum.food_carrots_raw:
				item_name = "Raw Carrots";
				dura_cur = 30;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "Raw carrots, not very satiating.";
				value = 10;
				weight_val = 1;
				is_food = true;
				contains_meat = false;
				satiation_val = 3;
			break;
			
			case item_enum.food_carrots_cooked:
				item_name = "Cooked Carrots";
				dura_cur = 10;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "Cooked carrots, more satiating but won't last very long.";
				value = 30;
				weight_val = 1;
				is_food = true;
				contains_meat = false;
				satiation_val = 6;
			break;
			
			case item_enum.food_bread:
				item_name = "Roll Of Bread";
				dura_cur = 10;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "A roll of bread, not cooked to last.";
				value = 15;
				weight_val = 1;
				is_food = true;
				contains_meat = false;
				satiation_val = 4;
			break;
			
			case item_enum.item_rock:
				item_name = "A Rock";
				dura_cur = 25;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "A flinty piece of stone.";
				value = 1;
				weight_val = 4;
				is_rock = true;
			break;
			
			case item_enum.item_boulder_giant:
				item_name = "A Giant Boulder";
				dura_cur = 75;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "It would take an immensely strong person to lug this giant boulder around.";
				value = 1;
				weight_val = 350;
				is_rock = true;
			break;
			
			case item_enum.item_boulder_average:
				item_name = "An Average Boulder";
				dura_cur = 75;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "It would take a strong person to lug this boulder around.";
				value = 1;
				weight_val = 200;
				is_rock = true;
			break;
			
			case item_enum.item_boulder_small:
				item_name = "A Small Boulder";
				dura_cur = 75;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "Who could find a use for this small boulder?";
				value = 1;
				weight_val = 125;
				is_rock = true;
			break;
			
			case item_enum.food_corpse_humanoid_raw:
				item_name = "Raw Humanoid Corpse";
				dura_cur = 8;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "The unfortunate corpse of some humanoid creature.";
				value = 5;
				weight_val = 150;
				is_food = true;
				contains_meat = true;
				satiation_val = 3;
				causes_food_poisoning = true;
			break;
			
			case item_enum.food_corpse_humanoid_cooked:
				item_name = "Cooked Humanoid Corpse";
				dura_cur = 15;
				item_equip_type_enum = item_equip_type.none;
				item_weapon_type_enum = wep_type.none;
				description = "The cooked corpse of some unfortunate humanoid creature.";
				value = 15;
				weight_val = 125;
				is_food = true;
				contains_meat = true;
				satiation_val = 6;
			break;
			
			case item_enum.wep_staff_two_hand_rusty:
				item_name = "Battered Staff";
				dura_cur = 20;
				melee_min_dmg = 2;
				melee_max_dmg = 4;
				armor_pen = 60;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = true;
				melee_to_hit_mod = 4;
				block_mod = 6;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.staff;
				description = "This giant staff looks like it may serve better as a walking stick.";
				value = 8;
				weight_val = 12;
			break;
			
			case item_enum.wep_staff_two_hand_acheron: //Unique weapon, only acheron can wield it.
				item_name = "Acheron's Griffin Core Staff";
				dura_cur = 75;
				melee_min_dmg = 5;
				melee_max_dmg = 10;
				armor_pen = 115;
				magic_pen = 25;
				item_equip_type_enum = item_equip_type.two_hand;
				is_weapon = true;
				melee_to_hit_mod = 35;
				block_mod = 10;
				stam_debuff = 0;
				item_weapon_type_enum = wep_type.staff;
				description = "This gnarled iron-wood staff with a griffin feather core has served for centuries as Acheron's steadfast companion through countless wars and adventures.";
				value = 500;
				weight_val = 15;
			break;
			
			case item_enum.wep_shield_buckler_leather:
				item_name = "Small Leather Buckler";
				dura_cur = 30;
				melee_min_dmg = 0;
				melee_max_dmg = 0;
				armor_pen = 0;
				magic_pen = 0;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = false;
				melee_to_hit_mod = 0;
				block_mod = 10;
				stam_debuff = 0;
				melee_evasion_mod = 5;
				ranged_evasion_mod = 5;
				item_weapon_type_enum = wep_type.shield;
				is_armor = false;
				description = "This leather buckler doesn't offer much protection.";
				value = 15;
				weight_val = 15;
			break;
			
			case item_enum.wep_shield_medium_leather:
				item_name = "Medium Leather Shield";
				dura_cur = 50;
				melee_min_dmg = 0;
				melee_max_dmg = 0;
				armor_pen = 0;
				magic_pen = 0;
				item_equip_type_enum = item_equip_type.one_hand;
				is_weapon = false;
				melee_to_hit_mod = 0;
				block_mod = 15;
				stam_debuff = 1;
				melee_evasion_mod = 15;
				ranged_evasion_mod = 15;
				item_weapon_type_enum = wep_type.shield;
				is_armor = false;
				description = "This leather shield has seen better days.";
				value = 50;
				weight_val = 30;
			break;
			
			case item_enum.wep_bow_short_crude:
				item_name = "Crude Wooden Short Bow";
				dura_cur = 10;
				ranged_min_dmg = 2;
				ranged_max_dmg = 4;
				armor_pen = 80;
				magic_pen = 0;
				item_range = 2;
				item_equip_type_enum = item_equip_type.two_hand;
				is_weapon = true;
				ranged_to_hit_mod = 2;
				block_mod = 3;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.bow;
				is_armor = false;
				description = "Crudely made long ago, it still serves its purpose.";
				value = 15;
				weight_val = 7;
			break;
			
			case item_enum.wep_bow_short_average:
				item_name = "Wooden Short Bow";
				dura_cur = 15;
				ranged_min_dmg = 4;
				ranged_max_dmg = 6;
				armor_pen = 85;
				magic_pen = 0;
				item_range = 2;
				item_equip_type_enum = item_equip_type.two_hand;
				is_weapon = true;
				ranged_to_hit_mod = 4;
				block_mod = 4;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.bow;
				is_armor = false;
				description = "Competently constructed wooden short bow.";
				value = 20;
				weight_val = 8;
			break;
			
			case item_enum.wep_crossbow_crude:
				item_name = "Crude Crossbow";
				dura_cur = 15;
				ranged_min_dmg = 4;
				ranged_max_dmg = 6;
				armor_pen = 125;
				magic_pen = 0;
				item_range = 2;
				item_equip_type_enum = item_equip_type.two_hand;
				is_weapon = true;
				ranged_to_hit_mod = 5;
				block_mod = 6;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.crossbow;
				is_armor = false;
				description = "This crude crossbow has seen better days.";
				value = 20;
				weight_val = 13;
			break;
			
			case item_enum.wep_crossbow_average:
				item_name = "Iron Crossbow";
				dura_cur = 25;
				ranged_min_dmg = 6;
				ranged_max_dmg = 8;
				armor_pen = 125;
				magic_pen = 0;
				item_range = 2;
				item_equip_type_enum = item_equip_type.two_hand;
				is_weapon = true;
				ranged_to_hit_mod = 8;
				block_mod = 7;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.crossbow;
				is_armor = false;
				description = "This iron crossbow looks relatively new and in good condition.";
				value = 45;
				weight_val = 15;
			break;
			
			case item_enum.armor_body_leather_vest:
				item_name = "Crude Leather Vest";
				dura_cur = 4;
				item_equip_type_enum = item_equip_type.body;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 2;
				ranged_evasion_mod = 0;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "A simple traveler's vest of cured leather.";
				physical_resist = 2;
				magical_resist = 0;
				value = 35;
				weight_val = 2;
			break;
			
			case item_enum.armor_head_feather_hat:
				item_name = "Hunter's Feathered Hat";
				dura_cur = 2;
				item_equip_type_enum = item_equip_type.head;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 1;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "A green hunter's hat adorned with the bright yellow feather of a falcon.";
				value = 5;
				weight_val = 1;
			break;
			
			case item_enum.armor_head_padded_cap:
				item_name = "Padded Cap";
				dura_cur = 4;
				item_equip_type_enum = item_equip_type.head;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "A simple leather cap stuffed with wool and cloth for added protection.";
				physical_resist = 1;
				magical_resist = 0;
				value = 45;
				weight_val = 2;
			break;
			
			case item_enum.armor_head_chainmail_coif_crude:
				item_name = "Rusty Chainmail Coif";
				dura_cur = 8;
				item_equip_type_enum = item_equip_type.head;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "Rusty chainmail links over a padded cap serve as crude protection for the skull.";
				physical_resist = 3;
				magical_resist = 0;
				value = 150;
				weight_val = 5;
			break;
			
			case item_enum.armor_feet_leather_crude:
				item_name = "Battered Leather Boots";
				dura_cur = 2;
				item_equip_type_enum = item_equip_type.feet;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 1;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "Old leather boots that have seen too many leagues pass beneath them.";
				physical_resist = 1;
				magical_resist = 0;
				value = 25;
				weight_val = 1;
			break;
			
			case item_enum.armor_feet_iron_crude:
				item_name = "Battered Iron Boots";
				dura_cur = 5;
				item_equip_type_enum = item_equip_type.feet;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "Old iron boots that have seen too many leagues pass beneath them.";
				physical_resist = 2;
				magical_resist = 0;
				value = 115;
				weight_val = 5;
			break;
			
			case item_enum.armor_hands_leather_crude:
				item_name = "Crude Leather Gloves";
				dura_cur = 3;
				item_equip_type_enum = item_equip_type.hands;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 1;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "Falling apart, but they will serve.";
				value = 35;
				weight_val = 2;
			break;
			
			case item_enum.armor_hands_leather_wraps:
				item_name = "Crude Leather Wraps";
				dura_cur = 2;
				item_equip_type_enum = item_equip_type.hands;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "Just stripes of cured animal hide to be tied around the wrists and forearms.";
				value = 15;
				weight_val = 2;
			break;
			
			case item_enum.armor_hands_iron_gauntlets_crude:
				item_name = "Rusty Iron Gauntlets";
				dura_cur = 8;
				item_equip_type_enum = item_equip_type.hands;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 1;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "Poorly made, could use a good scouring.";
				physical_resist = 2;
				magical_resist = 0;
				value = 205;
				weight_val = 5;
			break;
			
			case item_enum.armor_body_furs_crude:
				item_name = "Tattered Furs";
				dura_cur = 8;
				item_equip_type_enum = item_equip_type.body;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "A molting collection of furs from animals too disintegrated to discern.";
				physical_resist = 2;
				magical_resist = 0;
				value = 75;
				weight_val = 8;
			break;
			
			case item_enum.armor_body_robes_crude:
				item_name = "Tattered Magician's Robe";
				dura_cur = 2;
				item_equip_type_enum = item_equip_type.body;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 1;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "These old gray robes are patched and fraying at the edges.";
				physical_resist = 0;
				magical_resist = 3;
				value = 55;
				weight_val = 2;
			break;
			
			case item_enum.armor_body_rags_crude:
				item_name = "Tattered Roughspun Rags";
				dura_cur = 1;
				item_equip_type_enum = item_equip_type.body;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "These rags are filthy and barely even preserve the wearer's modesty.";
				physical_resist = 0;
				magical_resist = 0;
				value = 3;
				weight_val = 1;
			break;
			
			case item_enum.armor_body_chainmail_crude:
				item_name = "Rusty Iron Chainmail";
				dura_cur = 20;
				item_equip_type_enum = item_equip_type.body;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "Poorly made, could use a good scouring.";
				physical_resist = 8;
				magical_resist = 0;
				value = 550;
				weight_val = 45;
			break;
			
			case item_enum.armor_head_pillory:
				item_name = "Uprooted Pillory";
				dura_cur = 20;
				item_equip_type_enum = item_equip_type.head;
				is_weapon = false;
				block_mod = 0;
				stam_debuff = 0;
				melee_evasion_mod = 0;
				item_weapon_type_enum = wep_type.none;
				is_armor = true;
				description = "A wooden frame with three holes through which the neck and hands of some unfortunate criminal are fastened. Commonly used to publicy shame convicted thieves and cut-throats while subjecting them to the jeers and abuse of the masses.";
				physical_resist = 0;
				magical_resist = 0;
				value = 5;
				weight_val = 75;
			break;
			
			default:
				show_debug_message("With item struct: "+string(self)+", our switch case did not capture the item_class enum : "+string(item_class)+"; something went wrong.");
			break;
		}
		
		//Default values:
		dura_max = dura_cur;
		
		//Add to appropriate arrays:
		array_push(global.master_struct_ar[cur_dungeon_enum][floor_int][AR_ITEMS],self);
		array_push(global.master_item_ar,self);
		
		show_debug_message("Constructor event for Item struct: Item struct instanitated with item_name: "+string(self.item_name) );
	}
	
	#endregion
	
	#region Building (interactive object)
	
	Building = function(enum_building_type,spawn_grid_x,spawn_grid_y,building_team_enum,level_int,visibility_boolean,cur_dungeon_enum) constructor {
		
		struct_enum = struct_type.building; ///Used with scr_return_struct_id and other things	
		
		//Set defaults vars:
		cur_floor_level = level_int;
		cur_dungeon_ind = cur_dungeon_enum;
		visible_boolean = visibility_boolean;
		building_type_enum = enum_building_type;
		
		building_sprite = spr_building_default;
		sprite_image_index = 0;
		
		revealed_trap_boolean = false;
		
		building_ar = array_create(building_stats.total_building_stats);
		
		//Default stats:
		building_ar[building_stats.name] = "Not Defined By Constructor Event.";
		building_ar[building_stats.type] = enum_building_type;
		building_ar[building_stats.team_enum] = building_team_enum;
		
		building_grid_x = spawn_grid_x;
		building_grid_y = spawn_grid_y;
		
		//Make sure we snap our coordinates to the nearest grid cell when this is created:
		var pos_ar = [];
		pos_ar = scr_convert_grid_to_room_coordinates(pos_ar,building_grid_x,building_grid_y);
		
		building_room_x = pos_ar[0];
		building_room_y = pos_ar[1];
		pos_ar = -1;
		
		scr_add_struct_to_inst_grid(self,building_grid_x,building_grid_y,cur_floor_level,cur_dungeon_ind);
		
		switch(enum_building_type) {
			
			case building_type.chest:
				building_sprite = spr_building_default;
				building_ar[building_stats.name] = "Chest";
			break;
			case building_type.stake_wall:
				building_sprite = spr_building_palisade;
				building_ar[building_stats.name] = "Stake Wall";
			break;
			case building_type.stair_down:
				building_sprite = spr_down_stair_32;
				building_ar[building_stats.name] = "Stair Leading Down";
			break;
			case building_type.stair_up:
				building_sprite = spr_up_stair_32;
				building_ar[building_stats.name] = "Stair Leading Up";
			break;
			case building_type.portal_world_down:
				building_sprite = spr_building_world_portal_down;
				building_ar[building_stats.name] = "World Portal Leading Down";
			break;
			case building_type.portal_world_up:
				building_sprite = spr_building_world_portal_up;
				building_ar[building_stats.name] = "World Portal Leading Up";
			break;
			case building_type.portal_random_up:
				building_sprite = spr_building_random_portal_up;
				building_ar[building_stats.name] = "Random Portal Leading Up";
			break;
			case building_type.portal_random_down:
				building_sprite = spr_building_random_portal_down;
				building_ar[building_stats.name] = "Random Portal Leading Down";
			break;
			
			default:
				show_debug_message("New Building constructor: enum_building_type: "+string(enum_building_type)+" was not captured by our switch-case.");
			break;
		}
		
		//Add to g.master_struct_ar:
		if building_team_enum == char_team.pc {
			array_push(global.master_struct_ar[cur_dungeon_enum][level_int][AR_BUILDING_PC],self);
			array_push(global.pc_building_team_ar,self);
		}
		else if building_team_enum == char_team.enemy {
			array_push(global.master_struct_ar[cur_dungeon_enum][level_int][AR_BUILDING_ENEMY],self);	
			array_push(global.enemy_building_team_ar,self);
		}
		else {
			array_push(global.master_struct_ar[cur_dungeon_enum][level_int][AR_BUILDING_NEUTRAL],self);
			array_push(global.neutral_building_team_ar,self);
		}
		
		show_debug_message("Constructor event for Building struct: Building struct instanitated with building name: "+string(self.building_ar[building_stats.name]) );
	}
	
	#endregion
	
	#region Loot drop (container for items in the world)
	
	LootDrop = function(spawn_grid_x,spawn_grid_y,level_int,cur_dungeon_enum,visibility_boolean) constructor {
		
		struct_enum = struct_type.loot_drop; ///Used with scr_return_struct_id and other things	
		
		//Set defaults vars:
		cur_floor_level = level_int;
		cur_dungeon_ind = cur_dungeon_enum;
		visible_boolean = visibility_boolean;
		
		building_sprite = spr_building_default;
		sprite_image_index = 0;
		
		revealed_trap_boolean = false;
		
		building_ar = array_create(building_stats.total_building_stats);
		
		//Default stats:
		loot_ar = [];
		
		building_grid_x = spawn_grid_x;
		building_grid_y = spawn_grid_y;
		
		//Make sure we snap our coordinates to the nearest grid cell when this is created:
		var pos_ar = [];
		pos_ar = scr_convert_grid_to_room_coordinates(pos_ar,building_grid_x,building_grid_y);
		
		building_room_x = pos_ar[0];
		building_room_y = pos_ar[1];
		pos_ar = -1;
		
		scr_add_struct_to_inst_grid(self,building_grid_x,building_grid_y,cur_floor_level,cur_dungeon_ind);
		
		//Add to g.master_struct_ar:
		array_push(global.master_struct_ar[cur_dungeon_enum][level_int][AR_BUILDING_NEUTRAL],self);
		array_push(global.loot_drop_ar,self);
		
		show_debug_message($"Constructor event for LootDrop struct: loot_drop struct instanitated, it contained the following items: {loot_ar}" );
	}
	
	#endregion
}