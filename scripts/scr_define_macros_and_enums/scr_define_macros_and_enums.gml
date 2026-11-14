
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
		save_game,
		loading_from_file,
		load_game_list,
		access_inv,
		view_stats,
		view_bio,
		
		select_trader
		
	}
	
	//Struct enum - used with scr_return_struct_id, also used to help identify/distinguish structs from eachother:
	enum struct_type {
		character,
		item,
		building,
		ability,
		loot_drop, //not a struct type in use
		any //If this struct_type is used for a argument with scr_return_struct_id, and ANY struct is found in that inst_grid location, then that grid returns FALSE 
		
	}
	
	//Enum for prompt box types - defines what type of prompt box is created to the GUI - edit
	enum prompt_box_type {
		create_new_game,
		total_prompt_box_types
	}
	
	//Used with scr_parse_str()
	enum parse_str_type {
		debug_new_map,
		new_save_file_name
	}
	
	//This will need to be a index within the g.master_arrays, such as the overworld, minotaur maze, etc.;
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
	
	//Enums for o_inv_slots - used for logic and such:
	enum inv_slot {
		head, //should remain as first equipment slot
		body,
		rh, //if an inventory item has this, it can be equipped in either hand; all weapons and shields will have this
		lh,
		accessory,
		feet, 
		hands, //should stay as last equipment slot
		backpack,
		item_on_ground,
		npc_backpack,
		total_inv_slots
	}
	
	//Enum for item quality - determines stats for each item:
	enum item_quality {
		cursed,
		crude,
		poor, 
		average,
		good, 
		excellent,
		total_item_quality
	}
	
	enum scroll_dir {
		left,
		right,
		up,
		down
	}
	
	//Inst grid macros:
	#macro INST_FREE_CELL 0

	//macros to be used with global.master_level_ar:
	#macro GRID_TERRAIN 0
	#macro GRID_INST 1
	#macro GRID_LOS 2
	#macro GRID_TOTAL_GRIDS 3
	
	//macros to be used with global.master_struct_ar - stores structs within each level; and levels themselves are stored within dungeons.
	#macro AR_PC 0
	#macro AR_ENEMY 1
	#macro AR_NEUTRAL 2
	#macro AR_BUILDING_PC 3
	#macro AR_BUILDING_ENEMY 4 
	#macro AR_BUILDING_NEUTRAL 5 //This is where up/down stairs and portals and etc. are stored
	#macro AR_ITEMS 6
	#macro AR_TOTAL_ARS 7
	
	//Macros used with the g.los_grid AND the tile_fow tilemap  - should align with spr_fow_tiles_32:
	#macro LOS_VISIBLE 0
	#macro LOS_SHROUD 1
	#macro LOS_FOW 2
	
	//Macros for pathing algorithms:
	#macro UNVISITED_CELL 0
	#macro VISITED_CELL 1
	
	#macro UNVISITED_STEP_VAL 999999999 //Needs to simply be a very large number that our pathing alogirithm is NOT going to want to choose.
	
	#macro TERRAIN_VAL_PLAINS 2
	#macro TERRAIN_VAL_GRASS 2
	#macro TERRAIN_VAL_DUNGEON 1
	#macro TERRAIN_VAL_CAVE 2
	#macro TERRAIN_VAL_ROAD 1
	#macro TERRAIN_VAL_SWAMP 8
	#macro TERRAIN_VAL_MOUNTAIN 6
	#macro TERRAIN_VAL_HILLS 3
	#macro TERRAIN_VAL_FOREST 4
	
	#macro GRID_ENCODE 1000000  // must be larger than your max grid width; removes the need for creating structs to store separate grid_x and grid_y vars. Stores coordinates as a single number instead, represented by: encoded_val = checking_cell_x + checking_cell_y * GRID_ENCODE. We unpack this number into x and y coordinates by using: pather_x = encoded_val mod GRID_ENCODE; and pather_y = encoded_val div GRID_ENCODE. So essentially, we just use math to store coordinates as a single number, rather than storing them in something with multiple data points, such as an array or a struct.
	
	
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
	
	//Enum for weapon skills - wep_skills_ar; is used for determining buffs/skills etc.;
	//IMPORTANT NOTE: also used for ALL other items, including armor, and misc accessories:
	enum wep_type {
		none, //unequippable items
		misc, //items that equip to the 'misc' slot.
		
		mace, //should remain grouped and ordered as is
		sword,
		axe,
		dagger,
		flail,
		polearm,
		hammer,
		staff,
		spear, //should remain grouped and ordered as is
		shield, //should remain grouped and ordered as is
		
		bow, //Start of ranged type weps; //should remain grouped and ordered as is
		crossbow,
		firearm, //End of ranged type weps; //should remain grouped and ordered as is
		
		torch, //the basic attack adds fire damage; when equipped also adds vision in dark dungeons
		
		cloth, //should remain grouped and ordered as is
		leather,
		chain_mail,
		plate, //should remain grouped and ordered as is
		
		missile,
		consumable,
		inert, //Things that have low value but can't be equipped?
		treasure, //Things that have high value but can't be equipped?
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
		
		base_res_crushing,
		cur_res_crushing,
		base_res_slashing,
		cur_res_slashing,
		base_res_piercing,
		cur_res_piercing,
		
		base_res_fire,
		cur_res_fire,
		base_res_ice,
		cur_res_ice,
		base_res_shock,
		cur_res_shock,
		base_res_light,
		cur_res_light,
		base_res_dark,
		cur_res_dark,
		base_res_poison,
		cur_res_poison,
		base_res_arcane,
		cur_res_arcane,
		
		base_vision_radius,
		cur_vision_radius,
		char_team_enum,
		char_class_enum,
		cur_carrying_capacity,
		max_carrying_capacity,
		total_stats
	}
	
	#endregion
	
	#region Enum for character actions - every one of these can show up as a button in the char_action_bar_ar:
	
	//Edit: should these be combined with the 'ability' enum?
	
	enum char_action {
		
		basic_attack,
	
	}
	
	#endregion
	
	#region Enum for abilities - used with ability_ar, scr_build_action_buttons, and more; these include spells as well as combat abilities; some are passive, and some need to be activated; not all are combat related.
	
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
		dagger_stab,
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
		spear_spear_wall, //Every enemy moving into a cell adjacent must pass a hit check, or be forced back.
		torch_swing, //+toHit;-dmg; chance to set on fire
		torch_thrust, //-toHit; +dmg; chance to set on fire.
		
		rest,
		shield_shield_wall, //End of weapon type abilities; gains +5 melee and +5 ranged def for each pc that uses this in the same rank used with another pc in the same rank
		
		//Start of spell or racial or class abilities that are ACTIVATABLE in combat or in the main screen:
		
		heal_1,
		heal_2,
		heal_3,
		heal_group_1,
		heal_group_2,
		heal_group_3,
		bless_1,
		bless_2,
		bless_3,
		stone_skin_1,
		stone_skin_2,
		stone_skin_3,
		regenerate_1,
		regenerate_2,
		regenerate_3,
		
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
		craggy_skin_1, //increases physical resist, wep break chance, attacker injure chance
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
		
		//ogre and/or troll or golem abilities:
		headbutt, //small chance to stun self
		bite,
		throttle, //stuns both
		claw_swipe,
		charge,
		eye_gouge,
		
		//ogre:
		blood_letting, //injures self in order to increase his rage, has a chance of giving himself the 'bleeding' debuff.
		
		//troll
		feast, 
		terrorizing_howl,
		
		//golem abilities:
		golem_pulverize, //deals aoe damage all around the golem, damaging even pcs and neutrals
		golem_swing, //3 cell aoe anywhere him.
		
		//Start of misc abilities:
		trade_with_npc,
		
		total_ablities
	}
	
	#endregion
	
	//Ability_type enum - used in conjunction with our Ability structs, and elsewhere
	enum ability_type {
		activate, //R
		passive, //passive, but not all chars have it
		universal //passive, but all chars have it
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
		
		//Neutral classes from here on:
		npc_trader_generic,
		
		total_char_classes
	}
	
	//Enum for char_team - NOTE: ALSO USED FOR BUILDINGS!
	enum char_team {
		pc,
		enemy,
		neutral,
		total_char_teams
	}
	
	//Enum for all items in the game:
	enum item_enum {
		
		none,
		
		wep_axe_two_hand_woodcut,
		wep_axe_one_hand,
		wep_sword_two_hand_ancient,
		wep_sword_one_hand,
		wep_mace_one_hand,
		wep_hammer_one_hand,
		wep_dagger_one_hand,
		wep_spear_one_hand,
		wep_staff_two_hand,
		wep_staff_two_hand_acheron,
		wep_shield_buckler_leather,
		wep_shield_medium_leather,
		wep_bow_short,
		wep_crossbow,
		wep_polearm_halberd,
		wep_polearm_pike,
		wep_torch,
		
		armor_body_leather_vest,
		armor_body_furs,
		armor_body_robes,
		armor_body_rags,
		armor_body_chainmail,
		armor_head_feather_hat,
		armor_head_padded_cap,
		armor_head_chainmail_coif,
		armor_feet_leather,
		armor_feet_iron,
		armor_hands_leather,
		armor_hands_leather_wraps,
		armor_hands_iron_gauntlets,
		
		misc_gold_necklace,
		
		item_rock,
		item_boulder_average,
		item_boulder_small,
		item_boulder_giant,
		
		armor_head_pillory, //experimental item, 'punishment' item that thief starts with
		
		total_items
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
		//the up/down stairs, do NOT have their visible boolean reset to FALSE in scr_reset_visibility; once set to true, they always remain visible in the current floor.
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

/*A note on 'heuristic tie-breaking'; ex: var dist_to_dest = scr_return_chebyshev_dist(checking_cell_x, checking_cell_y, dest_x, dest_y) * 1.001;
When two nodes have the same f(n) value, A* has no preference between them and may explore both. In open areas this happens a lot — many cells will have identical f values, so A* fans out and explores a bunch of nodes that are all equally scored.
Tie-breaking gives A* a slight preference so it picks one path and commits rather than exploring many equivalent options. The idea is to favor nodes with a higher g(n), because a higher g means you've traveled further from the start, which means you're closer to the goal. 
Between two nodes with the same f, the one that's closer to the goal is more likely to be on the final path.
The simplest way to implement it is to multiply your heuristic by a tiny factor just above 1: