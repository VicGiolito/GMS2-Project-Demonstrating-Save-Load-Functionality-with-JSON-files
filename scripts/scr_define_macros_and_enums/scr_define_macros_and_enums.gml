
function scr_define_macros_and_enums(){
	
	//Game state enum
	enum game_state {
		start_menu,
		create_new_game,
		debug_new_game_choose_maze_type,
		debug_new_game_choose_w_and_h_and_floors,
		load_game_menu,
		options_menu,
		main,
		pc_plotting_path,
		inst_moving,
		loading_mazes_screen,
		loading_chars_screen,
		loading_loot_screen,
		save_game
	}
	
	//Struct enum - used with scr_return_struct_id, also used to help identify/distinguish structs from eachother:
	enum struct_type {
		character,
		item,
		building,
		loot_drop,
		any //If this struct_type is used for a argument with scr_return_struct_id, and ANY struct is found in that inst_grid location, then that grid returns FALSE 
	}
	
	//Enum for prompt box types - defines what type of prompt box is created to the GUI
	enum prompt_box_type {
		create_new_game,
		total_prompt_box_types
	}
	
	//Used with scr_parse_str()
	enum parse_str_type {
		debug_new_map,
		new_save_file_name
	}
	
	//This will need to be a literal place in the game, such as the overworld, minotaur maze, etc.;
	//it NOT simply a type of level.
	enum dungeon_type {
		overworld, //debug forest world
		minotaur_maze, //recursive backtracker
		restless_graveyard,
		infested_mines,
		crypt_of_kings,
		emerald_tower, //The "vegetation" dungeon, with sentient vines, etc.
		medusa_lair,
		hall_of_mirrors,
		goblin_warrens,
		ogre_caves,
		orc_stronghold,
		wizards_castle,
		haunted_manor,
		gilded_treasure_vaults, //living armor, heavy trapped, 
		infernal_pit, //demonic theme
		bandits_den,
		assassins_guild,
		thieves_guild,
		deserted_camp,
		east_haven, //settlement
		obrechia, //settlement
		askor, //settlement
		black_forest, //forest dungeons
		cursed_fen, //swamp dungeons
		dread_peaks, //mountain dungeon; //24
		
		total_dungeon_types
	}
	
	//Inst grid macros:
	#macro INST_FREE_CELL 0
	
	//visited grid macros:
	#macro UNVISITED_CELL 0
	#macro VISITED_CELL 1
	
	//macros to be used with global.master_level_ar:
	#macro GRID_TERRAIN 0
	#macro GRID_INST 1
	#macro GRID_LOS 2
	#macro GRID_TOTAL_GRIDS 3
	
	//macros to be used with global.master_char_ar - stores structs within each level
	#macro AR_PC 0
	#macro AR_ENEMY 1
	#macro AR_NEUTRAL 2
	#macro AR_BUILDING_PC 3
	#macro AR_BUILDING_ENEMY 4 
	#macro AR_BUILDING_NEUTRAL 5 //This is where loot drop structs are stored
	#macro AR_ITEMS 6
	#macro AR_TOTAL_ARS 7
	
	//Macros used with the g.los_grid AND the tile_fow tilemap  - should align with spr_fow_tiles_32:
	#macro LOS_VISIBLE 0
	#macro LOS_SHROUD 1
	#macro LOS_FOW 2
	
	//Defunct - over-complicates, and makes it harder to iterate scr_generate_maze:
	/*
	enum maze_type {
		recursive_backtracker, //Currently used for "minotaur maze"
		basic_forest_world, //Currently used for "overworld"
		total_maze_types
	}
	*/
	
	//Terrain cell enum - must match spr_terrain_*:
	enum terrain_type {
		unexplored,
		fields,
		swamp,
		mountain,
		forest,
		lake,
		cave,
		dungeon,
		
		wall_dungeon, //should always be our first wall_* type, and there should never be other traversable terrain types beyond this one
		wall_cave,
		total_terrain_type
	}
	
	//Terrain features enum - must match spr_terrain_features_*
	enum terrain_feature {
		tree,
		statue,
		rock,
		chest_closed,
		chest_opened,
		spiderwebs,
		total_terrain_features
	}
	
	//Enum for weapon skills - wep_skills_ar:
	enum wep_type {
		none, //unequippable items
		misc, //items that equip to the 'misc' slot.
		two_handed,
		mace,
		sword,
		axe,
		dagger,
		flail,
		polearm,
		hammer,
		staff,
		spear,
		shield,
		bow, //Start of ranged type weps
		crossbow,
		firearm, //End of ranged type weps
		torch,
		total_wep_types
	}
	
	#region Enum for our char_stats_ar:
	
	enum char_stats {
	
		name,
		base_str,
		cur_str,
		base_agil,
		cur_agil,
		base_wis,
		cur_wis,
		base_int,
		cur_int,
		base_con,
		cur_con,
		base_per,
		cur_per, //perception
		base_charisma, 
		cur_charisma,
		base_will,
		cur_will,
		hp_cur,
		hp_max,
		stam_cur,
		stam_max,
		mana_cur,
		mana_max,
		morale_cur,
		morale_max,
		base_vision_radius,
		cur_vision_radius,
		char_team_enum,
		char_class_enum,
		cur_carrying_capacity,
		max_carrying_capacity,
		total_stats
	}
	
	#endregion
	
	#region Enum for abilities - these include spells as well; some are passive, and some need to be activated:
	
	enum ability { //**CAREFUL WHEN RE-ORDERING THESE: THEIR ORDER MATTERS IN SCR_BUILD_ACTION_BUTTONS; THEIR ORDER MUST ALIGN WITH THE BUTTON_ACTION ENUM
		
		sword_slash, //+toHit,-dmg
		sword_thrust, //-toHit,+dmg
		sword_half_sword, //-toHit,-dmg,+armor_pierce
		axe_slash,
		axe_break_shield, //B.c the player can't see what the enemies have equipped (yet), just have the pc auto perform this if the enemy has a shield
		hammer_smash,
		hammer_armor_break, //-toHit, +armor piercing
		two_handed_slash, //+toHit,-dmg
		two_handed_thrust, //-toHit,+dmg
		two_handed_swing, //-toHit, can hit up to 3 in same rank
		two_handed_cleave, //-toHit, can hit up to 2 in different rank +-1 of each other
		flail_swing,
		flail_target_head, //-toHit, always hits head
		dagger_thrust,
		dagger_armor_pierce, //-toHit, -dmg, bypasses armor altogether
		staff_thrust, //-toHit,+dmg
		staff_swing, //+toHit,-dmg
		bow_fire,
		bow_take_aim,
		crossbow_fire,
		crossbow_reload,
		firearm_fire,
		firearm_reload,
		polearm_thrust,
		polearm_shove,
		mace_smash,
		mace_stun,
		spear_thrust,
		spear_spear_wall, //Every enemy targeting the same rank or beyond with a melee attack must first pass a free hit test.
		torch_swing, //+toHit;-dmg; chance to set on fire
		torch_thrust, //-toHit; +dmg; chance to set on fire.
		
		rest,
		shield_shield_wall, //End of weapon type abilities; gains +5 melee and +5 ranged def for each pc that uses this in the same rank used with another pc in the same rank
		
		//Start of spell or racial or class abilities that are ACTIVATABLE in combat or in the main screen:
		
		arcane_bolt,
		fireball,
		chain_lightning,
		sparks,
		frogify,
		sheepify,
		water_elem_1,
		water_elem_2,
		water_elem_3,
		will_o_wisp,
		magic_lantern,
		charm_1,
		charm_2,
		charm_3,
		paralyze_1,
		paralyze_2,
		paralyze_3, //End of spell or racial or class abilities that need to be ACTIVATED
		
		//Start of PASSIVE abilities:
		detect_trap_1,
		detect_trap_2,
		detect_trap_3,
		disarm_trap_1,
		disarm_trap_2,
		disarm_trap_3,
		craggy_skin_1, //increases physical resist, wep break chance
		craggy_skin_2,
		craggy_skin_3,
		shimmering_stones_1, //increases magic resist
		shimmering_stones_2,
		shimmering_stones_3,
		gathering_bulk_1, //tiny: increases base armor points and max hp
		gathering_bulk_2,
		gathering_bulk_3,
		thick_hide_1, //kurgun and troll: increases physical resist and base hp
		thick_hide_2,
		thick_hide_3,
		troll_blood_1, //troll: increases hp regen and limb regen chance
		troll_blood_2,
		troll_blood_3, //End of PASSIVE ABILITIES
		
		total_ablities
	}
	
	#endregion
	
	//Enum for equip slots - used for chars equip_slot_ar:
	enum equip_slot {
		none, //these are all items that can't be equipped; they are stored in the backpack only.
		misc,
		head,
		body,
		hands,
		feet,
		rh,
		lh,
		total_equip_slots
	}
	
	//Enum for pc char classes:
	enum char_class {
		roderick, //ranger
		kurgun, //half-ogre barbarian
		acheron, //protagonist and ancient wizard
		thade, //criminal and thief
		ulric, //priest
		crag, //stone golem
		neleera, //female treasure hunter/thief
		zool, //necromancer
		frizela, //witch/sorceress
		tom, //hobo
		ashra, //animist
		bill, //outlaw
		guy, //white knight; Ser Guy of Reeves
		johns, //gray knight; Ser Johns of Kennel Hold
		theobold, //black knight; Ser Theobold the Bastard
		danrys, //Smith?
		fiske, //Bandit?
		deserter, //self-explanatory
		bolger, //Hobbit thief
		diana, //Elven huntress
		troll, //self-explanatory
		artificer, //gnome that creates golems
		alchemist, //gnome that creates potions
		rogue_wizard, //half-wizard half-warrior
		brood_mother, //late game creation: spider queen that gestates goblin children on her back
		lich, //??
		goblin_cretin, //Enemy classes from here on:
		goblin_brute,
		total_char_classes
	}
	
	//Enum for char_team:
	enum char_team {
		pc,
		enemy,
		neutral,
		total_char_teams
	}
	
	//Enum for all items in the game:
	enum item_enum {
		none,
		
		wep_axe_two_hand_rusty,
		wep_axe_one_hand_rusty,
		wep_sword_two_hand_rusty,
		wep_sword_one_hand_rusty,
		wep_mace_one_hand_rusty,
		wep_mace_one_hand_average,
		wep_hammer_one_hand_rusty,
		wep_dagger_one_hand_rusty,
		wep_spear_one_hand_rusty,
		wep_staff_two_hand_rusty,
		wep_staff_two_hand_acheron,
		wep_shield_buckler_leather,
		wep_shield_medium_leather,
		wep_bow_short_crude,
		wep_bow_short_average,
		wep_crossbow_crude,
		wep_crossbow_average,
		wep_polearm_halberd_rusty,
		wep_polearm_pike_rusty,
		wep_torch_crude,
		
		armor_body_leather_vest,
		armor_body_furs_crude,
		armor_body_robes_crude,
		armor_body_rags_crude,
		armor_body_chainmail_crude,
		armor_head_pillory,
		armor_head_feather_hat,
		armor_head_padded_cap,
		armor_head_chainmail_coif_crude,
		armor_feet_leather_crude,
		armor_feet_iron_crude,
		armor_hands_leather_crude,
		armor_hands_leather_wraps,
		armor_hands_iron_gauntlets_crude,
		
		item_tools_and_supplies,
		item_rock,
		item_boulder_average,
		item_boulder_small,
		item_boulder_giant,
		
		food_ration_meager,
		food_ration,
		food_ration_iron,
		food_mutton_raw,
		food_mutton_cooked,
		food_corpse_humanoid_raw,
		food_corpse_humanoid_cooked,
		food_bread,
		food_carrots_raw,
		food_carrots_cooked,
		
		misc_gold_necklance,
		
		total_items
	}
	
	//Enum for item types - used with equip logic when determining if an can be equipped:
	enum item_equip_type {
		none, //these are all items that can't be equipped; they are stored in the backpack only.
		misc,
		head,
		body,
		hands,
		feet,
		two_hand,
		one_hand,
		total_item_equip_types
	}
	
	//BUILDING stats enum - used with building_ar array associated with the building struct:
	enum building_stats {
		name,
		sprite,
		type,
		has_inv_boolean,
		inv_space_int,
		has_concealment_boolean, //Functions the same as character concealment ability
		passable_boolean, //Blocks MOVEMENT when == false
		blocks_vision_boolean,
		team_enum,
		provides_vision_boolean,
		blocks_missiles_boolean, //Blocks RANGED fire when == false;
		cur_hp,
		max_hp,
		pathing_val,
		total_building_stats
	}
	
	//Enum for building struct types:
	enum building_type
	{
		door_closed, //Considered empty cells for the purposes of the pathing algorithms; do not have a "weight_pathing_val" associated with them.
		door_open,
		stair_up,
		stair_down,
		chest,
		
		portal_world_down, //5
		portal_world_up, //6
		portal_random_down, //7
		portal_random_up, //8
		
		trap_pit, //First trap enum - keep in this position - important for scr_return_trap_id
		trap_floor_spikes,
		trap_poison_darts,
		trap_rock_fall,
		trap_explosion,
		trap_ceiling_saw,
		trap_blinding_powder,
		trap_summon_hostiles,
		trap_piranha_pit, //Last trap enum - keep in this position - important for scr_return_trap_id
		
		pillar_stone, //Considered "obstacles" which have pathing values higher than empty terrain cells; these do have a "weight_pathing_val" associated with them.
		
		settlement,
		keep,
		castle,
		wall_wooden,
		wall_stone,
		wall_iron,
		watchtower_wooden,
		watchtower_stone,
		watchtower_iron,
		stake_wall, //Passable, but damages enemy units moving into it
		pit,
		gold_mine,
		lumbermill,
		stone_quarry,
		pig_iron_quarry,
		mana_fountain,
		healing_fountain,
		peasant_hovels,
		gnome_burrows,
		goblin_caves,
		windmill,
		shrine_of_hope, //Improves allied units' morale
		shrine_of_terror, //Damages enemy units' morale	
		
		generic_debug_building,
		
		total_building_types
	}
	
}