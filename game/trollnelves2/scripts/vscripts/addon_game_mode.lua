-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc
require('events_protector')
require('LinkModifier')
require('internal/util')
require('trollnelves2')
require("libraries/buildinghelper")
require('settings')
require("PrecacheLoad")
require("map_system")
require("mod_system")
require('PseudoRandom')
function Precache( context )
	--[[
		This function is used to precache resources/units/items/abilities that will be needed
		for sure in your game and that will not be precached by hero selection.  When a hero
		is selected from the hero selection screen, the game will precache that hero's assets,
		any equipped cosmetics, and perform the data-driven precaching defined in that hero's
		precache{} block, as well as the precache{} block for any equipped abilities.
		
		See trollnelves2:PostLoadPrecache() in trollnelves2.lua for more information
	]]
	
	DebugPrint("[TROLLNELVES2] Performing pre-load precache")
	
	-- Particles can be precached individually or by folder
	-- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
	-- Models can also be precached by folder or individually
	-- PrecacheModel should generally used over PrecacheResource for individual models
	-- Sounds can precached here like anything else
	
	-- Entire items can be precached by name
	-- Abilities can also be precached in this way despite the name
	
	-- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
	-- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way

	
	PrecacheResource("particle","particles/buildinghelper/square_overlay.vpcf", context)
	PrecacheResource("particle","particles/buildinghelper/range_overlay.vpcf", context)
	PrecacheResource("particle","particles/buildinghelper/ghost_model.vpcf", context)
	PrecacheResource("particle","particles/buildinghelper/square_sprite.vpcf", context)
	PrecacheResource("particle","particles/ui_mouseactions/range_display.vpcf", context)
	
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
	PrecacheResource("particle","particles/econ/events/league_teleport_2014/teleport_end_league.vpcf",context)
	PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_sven.vsndevts",context)
	PrecacheResource("particle","particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf",context)
	PrecacheResource("particle","particles/generic_gameplay/generic_stunned.vpcf",context)
	
	PrecacheResource("particle","particles/units/heroes/hero_mirana/mirana_base_attack.vpcf",context)
	PrecacheResource("particle","particles/base_attacks/ranged_tower_good.vpcf",context)
	PrecacheResource("particle","particles/base_attacks/ranged_tower_bad.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_venomancer/venomancer_base_attack.vpcf",context)  
	PrecacheResource("particle","particles/units/heroes/hero_drow/drow_frost_arrow.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_vengeful/vengeful_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_templar_assassin/templar_assassin_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_luna/luna_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_medusa/medusa_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_enigma/enigma_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf",context)
	
	PrecacheResource("particle", "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_3.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient.vpcf", context)
	PrecacheResource("particle", "particles/my_new/courier_roshan_darkmoon.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_shagbark/courier_shagbark_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti7/ti7_hero_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_ice.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_fire.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_roshan_ti8/courier_roshan_ti8_flying.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf", context)
	-- PrecacheResource("particle", "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti8/ti8_hero_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_hermit_crab/hermit_crab_skady_ambient.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_mars/mars_arena_of_blood_heal.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf", context)
    PrecacheResource("particle", "particles/my_new/ambientfx_effigy_wm16_radiant_lvl3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient_lvl4.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/ember_spirit/ember_spirit_vanishing_flame/ember_spirit_vanishing_flame_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_purple/courier_greevil_purple_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_yellow/courier_greevil_yellow_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_2.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_swarm.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_bloom_ambient.vpcf", context)
    PrecacheResource("particle", "particles/dev/curlnoise_test.vpcf",  context)
    PrecacheResource("particle", "particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/sniper/sniper_charlie/sniper_shrapnel_charlie_ground.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_faceless_rex/cour_rex_ground_a.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/bane/slumbering_terror/bane_slumbering_terror_ambient_a.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_crystal_rift/courier_ambient_crystal_rift.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_oculopus/courier_oculopus_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_detail.vpcf", context)
	PrecacheResource("particle", "particles/econ/golden_ti7.vpcf", context)
    PrecacheResource("particle", "particles/econ/events/ti9/ti9_emblem_effect.vpcf", context)
    PrecacheResource("particle", "particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/undying/undying_scourge/undying_scourge_blade_elec.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_sprint_fire.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/diretide_2020/emblem/fall20_emblem_v2_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/diretide_2020/emblem/fall20_emblem_v1_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/diretide_2020/emblem/fall20_emblem_effect.vpcf", context)
	
	PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_arms/venomancer_hydra_switch_color_arms.vmdl", context)
    PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_shoulder/venomancer_hydra_switch_color_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_head/venomancer_hydra_switch_color_head.vmdl", context)
    PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_tail/venomancer_hydra_switch_color_tail.vmdl", context)        
    
	PrecacheResource("model", "models/items/drow/drow_ti9_immortal_weapon/drow_ti9_immortal_weapon.vmdl", context)
    PrecacheResource("model", "models/items/drow/mask_of_madness/mask_of_madness.vmdl", context)
    PrecacheResource("model", "models/items/drow/frostfeather_huntress_shoulder/frostfeather_huntress_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/drow/frostfeather_huntress_misc/frostfeather_huntress_misc.vmdl", context)
    PrecacheResource("model", "models/items/drow/ti6_immortal_cape/mesh/drow_ti6_immortal_cape.vmdl", context)       
    PrecacheResource("model", "models/items/drow/frostfeather_huntress_arms/frostfeather_huntress_arms.vmdl", context)
    PrecacheResource("model", "models/items/drow/frostfeather_huntress_legs/frostfeather_huntress_legs.vmdl", context) 
    PrecacheResource("particle", "particles/econ/items/drow/drow_ti6_gold/drow_ti6_ambient_gold.vpcf", context)
   
   --PrecacheResource("model", "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl", context)
   -- PrecacheResource("model", "models/items/windrunner/ti6_windranger_offhand/ti6_windranger_offhand.vmdl", context)
   -- PrecacheResource("model", "models/items/windrunner/ti6_windranger_head/ti6_windranger_head.vmdl", context)
   -- PrecacheResource("model", "models/items/windrunner/ti6_windranger_back/ti6_windranger_back.vmdl", context)
   -- PrecacheResource("model", "models/items/windrunner/ti6_windranger_shoulder/ti6_windranger_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/vengefulspirit/fallenprincess_head/fallenprincess_head.vmdl", context)
    PrecacheResource("model", "models/items/vengefulspirit/fallenprincess_legs/fallenprincess_legs.vmdl", context)
    PrecacheResource("model", "models/items/vengefulspirit/fallenprincess_weapon/fallenprincess_weapon.vmdl", context)
    PrecacheResource("model", "models/items/vengefulspirit/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder.vmdl", context)
	PrecacheResource("particle", "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder_crimson_ambient.vpcf", context)
    
	PrecacheResource("model", "models/items/shadow_fiend/arms_deso/arms_deso.vmdl", context)
    PrecacheResource("model", "models/heroes/shadow_fiend/head_arcana.vmdl", context)
    PrecacheResource("model", "models/items/nevermore/sf_souls_tyrant_shoulder/sf_souls_tyrant_shoulder.vmdl", context)
    
	PrecacheResource("model", "models/items/lanaya/raiment_of_the_violet_archives_shoulder/raiment_of_the_violet_archives_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/lanaya/raiment_of_the_violet_archives_armor/raiment_of_the_violet_archives_armor.vmdl", context)
    PrecacheResource("model", "models/items/lanaya/raiment_of_the_violet_archives_head_hood/raiment_of_the_violet_archives_head_hood.vmdl", context)
    PrecacheResource("model", "models/items/luna/luna_ti7_set_head/luna_ti7_set_head.vmdl", context)
    PrecacheResource("model", "models/items/luna/luna_ti7_set_mount/luna_ti7_set_mount.vmdl", context)
    PrecacheResource("model", "models/items/luna/luna_ti7_set_shoulder/luna_ti7_set_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/luna/luna_ti7_set_weapon/luna_ti7_set_weapon.vmdl", context)
    PrecacheResource("model", "models/items/luna/luna_ti7_set_offhand/luna_ti7_set_offhand.vmdl", context)
   
   PrecacheResource("model", "models/items/medusa/dotaplus_medusa_weapon/dotaplus_medusa_weapon.vmdl", context)
    PrecacheResource("model", "models/items/medusa/daughters_of_hydrophiinae/daughters_of_hydrophiinae.vmdl", context)
	PrecacheResource("model", "models/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_immortal_tail.vmdl", context)
    PrecacheResource("model", "models/items/medusa/dotaplas_medusa_head/dotaplas_medusa_head.vmdl", context)
    PrecacheResource("model", "models/items/medusa/dotaplus_medusa_arms/dotaplus_medusa_arms.vmdl", context)
	
	PrecacheResource("model", "models/items/enigma/tentacular_conqueror_armor/tentacular_conqueror_armor.vmdl", context)
    PrecacheResource("model", "models/items/enigma/tentacular_conqueror_arms/tentacular_conqueror_arms.vmdl", context)
    PrecacheResource("model", "models/items/enigma/tentacular_conqueror_head/tentacular_conqueror_head.vmdl", context) 
	
	PrecacheResource("particle", "particles/items_fx/blink_dagger_end.vpcf", context) 
	PrecacheResource("particle", "particles/items_fx/blink_dagger_start.vpcf", context) 
	PrecacheResource("particle", "particles/ui_mouseactions/ping_circle_static.vpcf", context) 
	
	PrecacheResource("model", "models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution_flying.vmdl", context) 
	PrecacheResource("model", "models/items/courier/little_sapplingnew_bloom_style/little_sapplingnew_bloom_style_flying.vmdl", context)
    PrecacheResource("model", "models/courier/baby_winter_wyvern/baby_winter_wyvern_flying.vmdl", context)
	
	PrecacheResource("model", "models/heroes/alchemist/alchemist.vmdl", context) 
	PrecacheResource("model", "models/items/world/towers/ti10_radiant_tower/ti10_radiant_tower.vmdl", context)
	
	PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_cape.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_quiver.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_head.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_weapon.vmdl", context)
	PrecacheResource("particle", "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_bow_ambient.vpcf", context) 
	
	PrecacheResource("particle", "particles/msg_fx/msg_damage.vpcf", context)
	PrecacheResource("particle_folder", "particles/msg_fx", context)
	
	PrecacheResource("model", "models/items/viper/king_viper_head/king_viper_head.vmdl", context)
    PrecacheResource("model", "models/items/viper/king_viper_back/king_viper_back.vmdl", context)
    PrecacheResource("model", "models/items/viper/king_viper_tail/viper_king_viper_tail.vmdl", context)
	PrecacheResource("particle", "particles/units/heroes/hero_viper/viper_base_attack.vpcf", context)
	
	PrecacheResource("model", "models/items/nevermore/ferrum_chiroptera_head/ferrum_chiroptera_head.vmdl", context)
    PrecacheResource("model", "models/items/nevermore/ferrum_chiroptera_shoulder/ferrum_chiroptera_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/nevermore/ferrum_chiroptera_arms/ferrum_chiroptera_arms.vmdl", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nevermore/shadow_fiend_ambient_eyes.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_head_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_shoulder_ambient.vpcf", context)
	PrecacheResource("model", "models/items/courier/serpent_warbler/serpent_warbler_flying.vmdl", context)
	PrecacheResource("model", "models/items/courier/ig_dragon/ig_dragon_flying.vmdl", context)
	
	PrecacheResource("model", "models/items/wards/frozen_formation/frozen_formation.vmdl", context)
	PrecacheResource("model", "models/items/wards/sylph_ward/sylph_ward.vmdl", context)
	PrecacheResource("model", "models/items/wards/watcher_below_ward/watcher_below_ward.vmdl", context)
	PrecacheResource("model", "models/items/wards/megagreevil_ward/megagreevil_ward.vmdl", context)
	
	PrecacheResource("particle", "particles/units/heroes/hero_sniper/sniper_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", context)
	
	PrecacheResource("model", "models/items/sniper/witch_hunter_set_weapon/witch_hunter_set_weapon.vmdl", context)
    PrecacheResource("model", "models/items/sniper/witch_hunter_set_shoulder/witch_hunter_set_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/sniper/witch_hunter_set_arms/witch_hunter_set_arms.vmdl", context)
    PrecacheResource("model", "models/items/sniper/witch_hunter_set_head/witch_hunter_set_head.vmdl", context)
    PrecacheResource("model", "models/items/sniper/witch_hunter_set_back/witch_hunter_set_back.vmdl", context)
	--pets
	PrecacheResource("particle", "particles/econ/courier/courier_butch/courier_butch_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_huntling_gold/courier_huntling_gold_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_krobeling_gold/courier_krobeling_gold_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_venoling_gold/courier_venoling_ambient_gold.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_beetlejaw_gold/courier_beetlejaw_gold_ambient.vpcf", context)

	PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_casterribbons_arcana1.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf", context)
	PrecacheResource("model", "models/courier/baby_rosh/babyroshan_ti10_dire.vmdl", context)
    PrecacheResource("model", "models/courier/baby_rosh/babyroshan_elemental.vmdl", context)
	PrecacheResource("model", "models/items/courier/duskie/duskie.vmdl", context)
	
	PrecacheResource("model", "models/items/courier/dc_demon/dc_demon_flying.vmdl", context)
	PrecacheResource("model", "models/items/courier/little_sapplingnew_bloom_style/little_sapplingnew_bloom_style.vmdl", context) -- spring winner
	
	PrecacheResource("particle", "particles/econ/events/fall_major_2016/radiant_fountain_regen_fm06_lvl3.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/fall_major_2016/force_staff_fm06.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/fall_major_2016/force_staff_fm06_glow_trail.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/items/omniknight/omniknight_fall20_immortal/omniknight_fall20_immortal_degen_aura_debuff.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti10/aghanim_aura_ti10/agh_aura_ti10.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/events/summer_2021/summer_2021_emblem_effect.vpcf", context)
    PrecacheResource("particle", "particles/econ/events/spring_2021/fountain_regen_spring_2021_lvl3.vpcf", context)
    PrecacheResource("particle", "particles/econ/events/spring_2021/agh_aura_spring_2021_lvl2.vpcf", context) 
	
    PrecacheResource("model", "models/items/drow/drow_arcana/drow_arcana_back.vmdl", context) 
    PrecacheResource("model", "models/items/drow/drow_arcana/drow_arcana_weapon.vmdl", context) 
	PrecacheResource("model", "models/items/drow/drow_arcana/drow_arcana_legs.vmdl", context) 
    PrecacheResource("model", "models/items/drow/drow_arcana/drow_arcana_quiver.vmdl", context)         
    PrecacheResource("model", "models/items/drow/drow_arcana/drow_arcana_head.vmdl", context) 
    PrecacheResource("model", "models/items/drow/drow_arcana/drow_arcana_shoulder.vmdl", context)  
    
	PrecacheResource("particle", "particles/units/heroes/hero_void_spirit/planeshift/void_spirit_planeshift_untargetable.vpcf", context) 
	PrecacheResource("particle", "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf", context)


	PrecacheResource("particle", "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf", context) -- 48 event direc

    PrecacheResource("particle", "particles/econ/events/fall_2021/fountain_regen_fall_2021_lvl3.vpcf", context)  -- winter TOP2 49
    PrecacheResource("particle", "particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_dire_lvl3.vpcf", context) -- winter TOP3 50
    
    PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", context) -- ивент 51

    PrecacheResource("particle", "particles/units/heroes/hero_oracle/oracle_fatesedict_arc_pnt.vpcf", context) -- TOP2 52
    PrecacheResource("particle", "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf", context)  -- TOP 1 53 
    PrecacheResource("particle", "particles/units/heroes/hero_oracle/oracle_fatesedict_arc_thin.vpcf", context) -- TOP3 54

    PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf", context) -- TOP1 55
    PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_pulse.vpcf", context) -- TOP2 56
    PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_beam.vpcf", context) -- TOP3  57

    PrecacheResource("particle", "particles/econ/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf", context) -- ТОП шар 58

    -- ивент гуд
    PrecacheResource("particle", "particles/econ/items/omniknight/omni_ti8_head/omniknight_repel_buff_ti8.vpcf", context) -- синяя фигня с кругом  59
    PrecacheResource("particle", "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames.vpcf", context) -- грин с кругом  60
    PrecacheResource("particle", "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6.vpcf", context) -- фил с кругом  61
    PrecacheResource("particle", "particles/econ/treasures/aghanim_2021_treasure/aghanim_2021_treasure_ambient.vpcf", context) -- син кольцо 62
    PrecacheResource("particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf", context) -- ивент 63
    PrecacheResource("particle", "particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield.vpcf", context) -- сфера медузы грин 64
    PrecacheResource("particle", "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal.vpcf", context) -- кольцо огня от омника 65

    -- ивент
    PrecacheResource("particle", "particles/units/heroes/hero_rubick/rubick_doom_ring.vpcf", context) -- биг метка 66
    PrecacheResource("particle", "particles/units/heroes/hero_rubick/rubick_doom_sigil_c.vpcf", context) -- метка мини 67
    PrecacheResource("particle", "particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_pushrocks.vpcf", context) -- камни 68
    PrecacheResource("particle", "particles/econ/items/bane/slumbering_terror/bane_slumber_nightmare.vpcf", context) -- son 69
    PrecacheResource("particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", context) -- аура дума кольцо ОГОнь 70
    PrecacheResource("particle", "particles/econ/courier/courier_hermit_crab/hermit_crab_skady_ambient.vpcf", context) -- хрень топ10 71
    PrecacheResource("particle", "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient.vpcf", context)  -- хрень донат7 72 
	PrecacheResource("particle", "particles/econ/items/grimstroke/gs_fall20_immortal/gs_fall20_immortal_soul_debuff.vpcf", context)
	
	PrecacheResource("model", "models/items/ancient_apparition/extremely_cold_shackles_tail/extremely_cold_shackles_tail.vmdl", context)
	PrecacheResource("model", "models/items/ancient_apparition/extremely_cold_shackles_shoulder/extremely_cold_shackles_shoulder.vmdl", context)
	PrecacheResource("model", "models/items/ancient_apparition/extremely_cold_shackles_head/extremely_cold_shackles_head.vmdl", context)
	PrecacheResource("model", "models/items/ancient_apparition/extremely_cold_shackles_arms/extremely_cold_shackles_arms.vmdl", context)
	PrecacheResource("model", "models/items/courier/green_jade_dragon/green_jade_dragon_flying.vmdl", context)
	PrecacheResource("model", "models/items/wards/chinese_ward/chinese_ward.vmdl", context)
	
	PrecacheResource("model", "models/items/clinkz/degraded_soul_hunter_weapon/degraded_soul_hunter_weapon.vmdl", context)
	PrecacheResource("model", "models/items/clinkz/degraded_soul_hunter_shoulder/degraded_soul_hunter_shoulder.vmdl", context)
	PrecacheResource("model", "models/items/clinkz/degraded_soul_hunter_head/degraded_soul_hunter_head.vmdl", context)
	PrecacheResource("model", "models/items/clinkz/degraded_soul_hunter_gloves/degraded_soul_hunter_gloves.vmdl", context)
	PrecacheResource("model", "models/items/clinkz/degraded_soul_hunter_back/degraded_soul_hunter_back.vmdl", context)

	PrecacheResource("model", "models/items/hoodwink/hood_2021_blossom_weapon/hood_2021_blossom_weapon.vmdl", context)
    PrecacheResource("model", "models/items/hoodwink/hood_2021_blossom_armor/hood_2021_blossom_armor.vmdl", context) 
    PrecacheResource("model", "models/items/hoodwink/hood_2021_blossom_tail/hood_2021_blossom_tail.vmdl", context) 
    PrecacheResource("model", "models/items/hoodwink/hood_2021_blossom_back/hood_2021_blossom_back.vmdl", context) 

	PrecacheResource("model", "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/sirius_curse/sirius_curse.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/ambry_true_form/ambry_true_form.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/hunter_kings_trueform/hunter_kings_trueform.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/alpha_trueform9/alpha_trueform9.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/_ascension_of_the_hallowed_beast_form/_ascension_of_the_hallowed_beast_form.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/frostivus2018_lycan_savage_beast_form/frostivus2018_lycan_savage_beast_form.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/2018_lycan_shapeshift/2018_lycan_shapeshift.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/mutant_exorcist_form/mutant_exorcist_form.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/_werewolf_samurai_wolf_form_v1/_werewolf_samurai_wolf_form_v1.vmdl", context)
PrecacheResource("model", "models/items/lycan/ultimate/watchdog_lycan_true_form/watchdog_lycan_true_form.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/true_form/dark_wood_true_form/dark_wood_true_form.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/true_form/elemental_curse_set_elemental_curse_true_form/elemental_curse_set_elemental_curse_true_form.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/true_form/form_of_the_atniw/form_of_the_atniw.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/true_form/frostivus2018_lone_druid_inuit_trueform/frostivus2018_lone_druid_inuit_trueform.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/true_form/iron_claw_true_form/iron_claw_true_form.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/true_form/ld_enslaved_wanderer_ability_2/ld_enslaved_wanderer_ability_2.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/true_form/rabid_black_bear/rabid_black_bear.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/true_form/tarzan_and_kingkong_trueform/tarzan_and_kingkong_trueform.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/true_form/wizened_bear/wizened_bear.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/true_form/wolf_hunter_true_form/wolf_hunter_true_form.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_melee/crystal_radiant_melee.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_crystal.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega_crystal.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_mega.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_ranged/crystal_radiant_ranged.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_crystal.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_mega_crystal.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged_mega.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_bad_ranged/creep_bad_ranged_crystal.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_bad_ranged/creep_bad_ranged_mega_crystal.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_crystal.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega_crystal.vmdl", context)
PrecacheResource("model", "models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_golden.vmdl", context)
PrecacheResource("model", "models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_crimson.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_melee.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_melee_mega.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_ranged.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_2021_dire/creep_2021_dire_ranged_mega.vmdl", context)
PrecacheResource("model", "models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_flagbearer_melee.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_flagbearer_melee_mega.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_ranged.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_ranged_mega.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_flagbearer_melee.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_flagbearer_melee_mega.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_ranged.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_ranged_mega.vmdl", context)


PrecacheResource("model", "models/creeps/pine_cone/pine_cone.vmdl", context);
PrecacheResource("model", "models/heroes/furion/treant.vmdl", context);
PrecacheResource("model", "models/items/furion/treant_flower_1.vmdl", context);
PrecacheResource("model", "models/items/furion/treant_stump.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/abyssal_prophet_abyssal_prophet_treant/abyssal_prophet_abyssal_prophet_treant.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/allfather_of_nature_treant/allfather_of_nature_treant.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/defender_of_the_jungle_lakad_coconut/defender_of_the_jungle_lakad_coconut.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/eternalseasons_treant/eternalseasons_treant.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/father_treant/father_treant.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/fungal_lord_shroomthing/fungal_lord_shroomthing.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/furion_treant_nelum_red/furion_treant_nelum_red.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/hallowed_horde/hallowed_horde.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/np_cute_cactus_treant/np_cute_cactus_treant.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/np_desert_traveller_treant/np_desert_traveller_treant.vmdl", context);
PrecacheResource("model", "models/creeps/mega_greevil/mega_greevil.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/primeval_treant/primeval_treant.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/ravenous_woodfang/ravenous_woodfang.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/shroomling_treant/shroomling_treant.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/supreme_gardener_treants/supreme_gardener_treants.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/the_ancient_guardian_the_ancient_treants/the_ancient_guardian_the_ancient_treants.vmdl", context);
PrecacheResource("model", "models/items/furion/treant/treant_cis/treant_cis.vmdl", context);
PrecacheResource("model", "models/heroes/invoker/forge_spirit.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/arsenal_magus_forged_spirit/arsenal_magus_forged_spirit.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/cadenza_spirit/cadenza_spirit.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/covenant_of_the_depths_deep_forged/covenant_of_the_depths_deep_forged.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/dark_sorcerer_forge_spirit/dark_sorcerer_forge_spirit.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit_dpc.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/frostivus2018_invoker_keeper_of_magic_spirit/frostivus2018_invoker_keeper_of_magic_spirit.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/grievous_ingots/grievous_ingots.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/iceforged_spirit/iceforged_spirit.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/infernus/infernus.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/nightlord_crypt_sentinel/nightlord_crypt_sentinel.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/sempiternal_revelations_forged_spirits/sempiternal_revelations_forged_spirits.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/steampowered_magic_forge_spirit/steampowered_magic_forge_spirit.vmdl", context);
PrecacheResource("model", "models/items/invoker/forge_spirit/ti8_invoker_prism_forge_spirit/ti8_invoker_prism_forge_spirit.vmdl", context);
PrecacheResource("model", "models/items/wraith_king/frostivus_wraith_king/frostivus_wraith_king_skeleton.vmdl", context);
PrecacheResource("model", "models/courier/baby_winter_wyvern/baby_winter_wyvern_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/serpent_warbler/serpent_warbler_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/ig_dragon/ig_dragon_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/dc_demon/dc_demon_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/green_jade_dragon/green_jade_dragon_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/deathbringer/deathbringer_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/echo_wisp/echo_wisp_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/blazing_hatchling_the_fortune_bringer_courier/blazing_hatchling_the_fortune_bringer_courier.vmdl", context);
PrecacheResource("model", "models/courier/venoling/venoling_flying.vmdl", context);
PrecacheResource("model", "models/courier/trapjaw/trapjaw_flying.vmdl", context);


PrecacheResource("model", "models/courier/smeevil_mammoth/smeevil_mammoth_flying.vmdl", context)
PrecacheResource("model", "models/courier/smeevil/smeevil_flying.vmdl", context)
PrecacheResource("model", "models/courier/seekling/seekling.vmdl", context)
PrecacheResource("model", "models/courier/minipudge/minipudge.vmdl", context)
PrecacheResource("model", "models/courier/mega_greevil_courier/mega_greevil_courier_flying.vmdl", context)
PrecacheResource("model", "models/courier/frog/frog_flying.vmdl", context)
PrecacheResource("model", "models/courier/drodo/drodo_flying.vmdl", context)
PrecacheResource("model", "models/courier/doom_demihero_courier/doom_demihero_courier.vmdl", context)
PrecacheResource("model", "models/courier/baby_rosh/babyroshan_winter18_flying.vmdl", context)
PrecacheResource("model", "models/courier/baby_rosh/babyroshan_ti9_flying.vmdl", context)
PrecacheResource("model", "models/courier/baby_rosh/babyroshan_ti10_flying.vmdl", context)
PrecacheResource("model", "models/courier/baby_rosh/babyroshan_ti10_dire_flying.vmdl", context)
PrecacheResource("model", "models/courier/baby_winter_wyvern/baby_winter_wyvern_flying.vmdl", context)
PrecacheResource("model", "models/courier/baby_winter_wyvern/baby_winter_wyvern_flying.vmdl", context)
PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_arms/venomancer_hydra_switch_color_arms.vmdl", context)
PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_shoulder/venomancer_hydra_switch_color_shoulder.vmdl", context)
PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_head/venomancer_hydra_switch_color_head.vmdl", context)
PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_tail/venomancer_hydra_switch_color_tail.vmdl", context)
PrecacheResource("model", "models/items/viper/king_viper_head/king_viper_head.vmdl", context)
PrecacheResource("model", "models/items/viper/king_viper_back/king_viper_back.vmdl", context)
PrecacheResource("model", "models/items/viper/king_viper_tail/viper_king_viper_tail.vmdl", context)
PrecacheResource("model", "models/items/drow/drow_ti9_immortal_weapon/drow_ti9_immortal_weapon.vmdl", context)
PrecacheResource("model", "models/items/drow/mask_of_madness/mask_of_madness.vmdl", context)
PrecacheResource("model", "models/items/drow/frostfeather_huntress_shoulder/frostfeather_huntress_shoulder.vmdl", context)
PrecacheResource("model", "models/items/drow/frostfeather_huntress_misc/frostfeather_huntress_misc.vmdl", context)
PrecacheResource("model", "models/items/drow/ti6_immortal_cape/mesh/drow_ti6_immortal_cape.vmdl", context)
PrecacheResource("model", "models/items/drow/frostfeather_huntress_arms/frostfeather_huntress_arms.vmdl", context)
PrecacheResource("model", "models/items/drow/frostfeather_huntress_legs/frostfeather_huntress_legs.vmdl", context)
PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_cape.vmdl", context)
PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_quiver.vmdl", context)
PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_shoulder.vmdl", context)
PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_head.vmdl", context)
PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_weapon.vmdl", context)
PrecacheResource("model", "models/items/ancient_apparition/ancient_apparition_frozen_evil_head/ancient_apparition_frozen_evil_head.vmdl", context)
PrecacheResource("model", "models/items/ancient_apparition/ancient_apparition_frozen_evil_arms/ancient_apparition_frozen_evil_arms.vmdl", context)
PrecacheResource("model", "models/items/ancient_apparition/ancient_apparition_frozen_evil_shoulder/ancient_apparition_frozen_evil_shoulder.vmdl", context)
PrecacheResource("model", "models/items/ancient_apparition/ancient_apparition_frozen_evil_tail/ancient_apparition_frozen_evil_tail.vmdl", context)
PrecacheResource("model", "models/items/vengefulspirit/fallenprincess_head/fallenprincess_head.vmdl", context)
PrecacheResource("model", "models/items/vengefulspirit/fallenprincess_legs/fallenprincess_legs.vmdl", context)
PrecacheResource("model", "models/items/vengefulspirit/fallenprincess_weapon/fallenprincess_weapon.vmdl", context)
PrecacheResource("model", "models/items/vengefulspirit/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder.vmdl", context)
PrecacheResource("model", "models/items/shadow_fiend/arms_deso/arms_deso.vmdl", context)
PrecacheResource("model", "models/heroes/shadow_fiend/head_arcana.vmdl", context)
PrecacheResource("model", "models/items/nevermore/sf_souls_tyrant_shoulder/sf_souls_tyrant_shoulder.vmdl", context)
PrecacheResource("model", "models/items/nevermore/ferrum_chiroptera_head/ferrum_chiroptera_head.vmdl", context)
PrecacheResource("model", "models/items/nevermore/ferrum_chiroptera_shoulder/ferrum_chiroptera_shoulder.vmdl", context)
PrecacheResource("model", "models/items/nevermore/ferrum_chiroptera_arms/ferrum_chiroptera_arms.vmdl", context)
PrecacheResource("model", "models/items/lanaya/raiment_of_the_violet_archives_shoulder/raiment_of_the_violet_archives_shoulder.vmdl", context)
PrecacheResource("model", "models/items/lanaya/raiment_of_the_violet_archives_armor/raiment_of_the_violet_archives_armor.vmdl", context)
PrecacheResource("model", "models/items/lanaya/raiment_of_the_violet_archives_head_hood/raiment_of_the_violet_archives_head_hood.vmdl", context)
PrecacheResource("model", "models/items/luna/luna_ti7_set_head/luna_ti7_set_head.vmdl", context)
PrecacheResource("model", "models/items/luna/luna_ti7_set_mount/luna_ti7_set_mount.vmdl", context)
PrecacheResource("model", "models/items/luna/luna_ti7_set_shoulder/luna_ti7_set_shoulder.vmdl", context)
PrecacheResource("model", "models/items/luna/luna_ti7_set_weapon/luna_ti7_set_weapon.vmdl", context)
PrecacheResource("model", "models/items/luna/luna_ti7_set_offhand/luna_ti7_set_offhand.vmdl", context)
PrecacheResource("model", "models/items/medusa/dotaplus_medusa_weapon/dotaplus_medusa_weapon.vmdl", context)
PrecacheResource("model", "models/items/medusa/daughters_of_hydrophiinae/daughters_of_hydrophiinae.vmdl", context)
PrecacheResource("model", "models/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_immortal_tail.vmdl", context)
PrecacheResource("model", "models/items/medusa/dotaplas_medusa_head/dotaplas_medusa_head.vmdl", context)
PrecacheResource("model", "models/items/medusa/dotaplus_medusa_arms/dotaplus_medusa_arms.vmdl", context)
PrecacheResource("model", "models/items/enigma/tentacular_conqueror_armor/tentacular_conqueror_armor.vmdl", context)
PrecacheResource("model", "models/items/enigma/tentacular_conqueror_arms/tentacular_conqueror_arms.vmdl", context)
PrecacheResource("model", "models/items/enigma/tentacular_conqueror_head/tentacular_conqueror_head.vmdl", context)
PrecacheResource("model", "models/items/sniper/witch_hunter_set_weapon/witch_hunter_set_weapon.vmdl", context)


PrecacheResource("model", "models/items/sniper/witch_hunter_set_weapon/witch_hunter_set_weapon.vmdl", context);
PrecacheResource("model", "models/items/wards/frozen_formation/frozen_formation.vmdl", context);
PrecacheResource("model", "models/items/wards/sylph_ward/sylph_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/watcher_below_ward/watcher_below_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/megagreevil_ward/megagreevil_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/dire_ward_eye/dire_ward_eye.vmdl", context);
PrecacheResource("model", "models/items/wards/chinese_ward/chinese_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/stonebound_ward/stonebound_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/monty_ward/monty_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/gazing_idol_ward/gazing_idol_ward.vmdl", context);
PrecacheResource("model", "models/items/courier/throe/throe_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/shagbark/shagbark_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/courier_mvp_redkita/courier_mvp_redkita_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/defense4_dire/defense4_dire_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/mlg_wraith_courier/mlg_wraith_courier.vmdl", context);
PrecacheResource("model", "models/items/courier/mei_nei_rabbit/mei_nei_rabbit_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/mango_the_courier/mango_the_courier_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/blazing_hatchling_the_fortune_bringer_courier/blazing_hatchling_the_fortune_bringer_courier_flying.vmdl", context);
PrecacheResource("model", "models/items/courier/bookwyrm/bookwyrm_flying.vmdl", context);
PrecacheResource("model", "models/items/drow/wandering_ranger_head/wandering_ranger_head.vmdl", context);
PrecacheResource("model", "models/items/drow/wandering_ranger_back/wandering_ranger_back.vmdl", context);
PrecacheResource("model", "models/items/drow/wandering_ranger_arms/wandering_ranger_arms.vmdl", context);
PrecacheResource("model", "models/items/drow/wandering_ranger_weapon/wandering_ranger_weapon.vmdl", context);
PrecacheResource("model", "models/items/drow/wandering_ranger_shoulder/wandering_ranger_shoulder.vmdl", context);
PrecacheResource("model", "models/items/drow/wandering_ranger_misc/wandering_ranger_misc.vmdl", context);
PrecacheResource("model", "models/items/drow/wandering_ranger_legs/wandering_ranger_legs.vmdl", context);
PrecacheResource("model", "models/items/windrunner/ti6_windranger_back/ti6_windranger_back.vmdl", context);
PrecacheResource("model", "models/items/windrunner/ti6_windranger_head/ti6_windranger_head.vmdl", context);
PrecacheResource("model", "models/items/windrunner/ti6_windranger_offhand/ti6_windranger_offhand.vmdl", context);
PrecacheResource("model", "models/items/windrunner/ti6_windranger_shoulder/ti6_windranger_shoulder.vmdl", context);
PrecacheResource("model", "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl", context);
PrecacheResource("model", "models/items/hoodwink/hood_2021_blossom_weapon/hood_2021_blossom_weapon.vmdl", context);
PrecacheResource("model", "models/items/hoodwink/hood_2021_blossom_armor/hood_2021_blossom_armor.vmdl", context);
PrecacheResource("model", "models/items/hoodwink/hood_2021_blossom_tail/hood_2021_blossom_tail.vmdl", context);
PrecacheResource("model", "models/items/hoodwink/hood_2021_blossom_back/hood_2021_blossom_back.vmdl", context);
PrecacheResource("model", "models/items/clinkz/degraded_soul_hunter_weapon/degraded_soul_hunter_weapon.vmdl", context);
PrecacheResource("model", "models/items/clinkz/degraded_soul_hunter_shoulder/degraded_soul_hunter_shoulder.vmdl", context);
PrecacheResource("model", "models/items/clinkz/degraded_soul_hunter_head/degraded_soul_hunter_head.vmdl", context);
PrecacheResource("model", "models/items/clinkz/degraded_soul_hunter_gloves/degraded_soul_hunter_gloves.vmdl", context);
PrecacheResource("model", "models/items/clinkz/degraded_soul_hunter_back/degraded_soul_hunter_back.vmdl", context);
PrecacheResource("model", "models/flag_2.vmdl", context);
PrecacheResource("model", "models/items/wards/arcticwatchtower/arcticwatchtower.vmdl", context);
PrecacheResource("model", "models/items/wards/atlas_burden_ward/atlas_burden_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/augurys_guardian/augurys_guardian.vmdl", context);
PrecacheResource("model", "models/items/wards/chicken_hut_ward/chicken_hut_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/bane_ward/bane_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/echo_bat_ward/echo_bat_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/enchantedvision_ward/enchantedvision_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/esl_one_jagged_vision/esl_one_jagged_vision.vmdl", context);
PrecacheResource("model", "models/items/wards/esl_wardchest_radling_ward/esl_wardchest_radling_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/esl_wardchest_franglerfish/esl_wardchest_franglerfish.vmdl", context);
PrecacheResource("model", "models/items/wards/esl_wardchest_jungleworm/esl_wardchest_jungleworm.vmdl", context);
PrecacheResource("model", "models/items/wards/esl_wardchest_toadstool/esl_wardchest_toadstool.vmdl", context);
PrecacheResource("model", "models/items/wards/eye_of_avernus_ward/eye_of_avernus_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/ti8_snail_ward/ti8_snail_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/frostivus_2023_ward/frostivus_2023_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/jakiro_pyrexae_ward/jakiro_pyrexae_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/hand_2021_ward/hand_2021_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/knightstatue_ward/knightstatue_ward.vmdl", context);
PrecacheResource("model", "models/items/wards/lich_black_pool_watcher/lich_black_pool_watcher.vmdl", context);
PrecacheResource("model", "models/items/wards/revtel_jester_obs/revtel_jester_obs.vmdl", context);
PrecacheResource("model", "models/items/wards/the_monkey_sentinel/the_monkey_sentinel.vmdl", context);
PrecacheResource("model", "models/items/wards/warding_guise/warding_guise.vmdl", context);


PrecacheResource("model", "models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_flagbearer_melee.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_flagbearer_melee_mega.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_ranged.vmdl", context)
PrecacheResource("model", "models/creeps/lane_creeps/creep_2021_radiant/creep_2021_radiant_ranged_mega.vmdl", context)

PrecacheResource("model", "models/courier/baby_rosh/babyroshan_ti10_dire.vmdl", context)
PrecacheResource("model", "models/courier/baby_rosh/babyroshan_elemental.vmdl", context)
PrecacheResource("model", "models/courier/baby_rosh/babyroshan.vmdl", context)
PrecacheResource("model", "models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl", context)
PrecacheResource("model", "models/courier/doom_demihero_courier/doom_demihero_courier.vmdl", context)
PrecacheResource("model", "models/courier/huntling/huntling.vmdl", context)
PrecacheResource("model", "models/items/courier/krobeling_gold/krobeling_gold.vmdl", context)
PrecacheResource("model", "models/courier/venoling/venoling.vmdl", context)
PrecacheResource("model", "models/courier/beetlejaws/mesh/beetlejaws.vmdl", context)
PrecacheResource("model", "models/items/courier/courier_ti9/courier_ti9_lvl7/courier_ti9_lvl7.vmdl", context)
PrecacheResource("model", "models/items/courier/duskie/duskie.vmdl", context)
PrecacheResource("model", "models/items/courier/little_sapplingnew_bloom_style/little_sapplingnew_bloom_style.vmdl", context)
PrecacheResource("model", "models/items/courier/chocobo/chocobo.vmdl", context)
PrecacheResource("model", "models/items/courier/faceless_rex/faceless_rex.vmdl", context)
PrecacheResource("model", "models/items/courier/courier_ti10_radiant/courier_ti10_radiant_lvl4/courier_ti10_radiant_lvl4.vmdl", context)
PrecacheResource("model", "models/items/courier/starladder_grillhound/starladder_grillhound.vmdl", context)
PrecacheResource("model", "models/items/courier/virtus_werebear_t2/virtus_werebear_t2.vmdl", context)
PrecacheResource("model", "models/items/courier/virtus_werebear_t3/virtus_werebear_t3.vmdl", context)
PrecacheResource("model", "models/items/courier/raiq/raiq.vmdl", context)
PrecacheResource("model", "models/items/courier/green_jade_dragon/green_jade_dragon.vmdl", context)
PrecacheResource("model", "models/items/courier/bajie_pig/bajie_pig.vmdl", context)
PrecacheResource("model", "models/items/courier/baekho/baekho.vmdl", context)
PrecacheResource("model", "models/items/courier/scuttling_scotty_penguin/scuttling_scotty_penguin.vmdl", context)
PrecacheResource("model", "models/items/courier/captain_bamboo/captain_bamboo.vmdl", context)
PrecacheResource("model", "models/items/courier/livery_llama_courier/livery_llama_courier.vmdl", context)
PrecacheResource("model", "models/courier/seekling/seekling.vmdl", context)
PrecacheResource("model", "models/items/courier/lilnova/lilnova.vmdl", context)
PrecacheResource("model", "models/items/courier/supernova_rave_courier/supernova_rave_courier.vmdl", context)
PrecacheResource("model", "models/items/courier/mei_nei_rabbit/mei_nei_rabbit.vmdl", context)
PrecacheResource("model", "models/props_gameplay/pig.vmdl", context)
PrecacheResource("model", "models/items/courier/snaggletooth_red_panda/snaggletooth_red_panda.vmdl", context)
PrecacheResource("model", "models/items/courier/el_gato_beyond_the_summit/el_gato_beyond_the_summit.vmdl", context)
PrecacheResource("model", "models/items/courier/hermid/hermid.vmdl", context)
PrecacheResource("model", "models/items/courier/nilbog/nilbog.vmdl", context)
PrecacheResource("model", "models/items/courier/royal_griffin_cub/royal_griffin_cub.vmdl", context)
PrecacheResource("model", "models/items/courier/blotto_and_stick/blotto.vmdl", context)
PrecacheResource("model", "models/courier/skippy_parrot/skippy_parrot.vmdl", context)
PrecacheResource("model", "models/courier/drodo/drodo.vmdl", context)
PrecacheResource("model", "models/courier/otter_dragon/otter_dragon.vmdl", context)
PrecacheResource("model", "models/items/courier/pangolier_squire/pangolier_squire.vmdl", context)
PrecacheResource("model", "models/courier/navi_courier/navi_courier.vmdl", context)

PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_radiant_lv1.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_dire_lv1.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_radiant_lv2.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_dire_lv2.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_radiant_lv3.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_dire_lv3.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_radiant_lv4.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_dire_lv4.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_radiant_lv5.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_dire_lv5.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_radiant_lv6.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_dire_lv6.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_radiant_lv7.vmdl", context)
PrecacheResource("model", "models/items/courier/hand_courier/hand_courier_dire_lv7.vmdl", context)
PrecacheResource("model", "models/items/courier/boooofus_courier/boooofus_courier.vmdl", context)
PrecacheResource("model", "models/courier/aghanim_courier/aghanim_courier.vmdl", context)
PrecacheResource("model", "models/items/courier/vigilante_fox_green/vigilante_fox_green.vmdl", context)
PrecacheResource("model", "models/items/courier/vigilante_fox_red/vigilante_fox_red.vmdl", context)
PrecacheResource("model", "models/courier/winter2022/taffy_donkey_courier.vmdl", context)
PrecacheResource("model", "models/courier/winter2022/cotton_donkey_courier.vmdl", context)
PrecacheResource("model", "models/items/courier/gnomepig/gnomepig.vmdl", context)
PrecacheResource("model", "models/items/courier/hamster_courier/hamster_courier_lv1.vmdl", context)
PrecacheResource("model", "models/items/courier/hamster_courier/hamster_courier_lv2.vmdl", context)
PrecacheResource("model", "models/items/courier/hamster_courier/hamster_courier_lv3.vmdl", context)
PrecacheResource("model", "models/items/courier/hamster_courier/hamster_courier_lv4.vmdl", context)
PrecacheResource("model", "models/items/courier/hamster_courier/hamster_courier_lv5.vmdl", context)
PrecacheResource("model", "models/items/courier/hamster_courier/hamster_courier_lv6.vmdl", context)
PrecacheResource("model", "models/items/courier/hamster_courier/hamster_courier_lv7.vmdl", context)
PrecacheResource("model", "models/items/courier/deathbringer/deathbringer.vmdl", context)
PrecacheResource("model", "models/items/courier/grim_wolf_radiant/grim_wolf_radiant.vmdl", context)
PrecacheResource("model", "models/items/courier/coco_the_courageous/coco_the_courageous.vmdl", context)
PrecacheResource("model", "models/items/courier/courier_janjou/courier_janjou.vmdl", context)
PrecacheResource("model", "models/items/courier/dplus_zao_jun_the_stove_god/dplus_zao_jun_the_stove_god.vmdl", context)
PrecacheResource("model", "models/items/courier/dokkaebi_nexon_courier/dokkaebi_nexon_courier.vmdl", context)
PrecacheResource("model", "models/items/courier/gama_sennin/gama_sennin.vmdl", context)
PrecacheResource("model", "models/items/courier/itsy/itsy.vmdl", context)
PrecacheResource("model", "models/items/courier/shroomy/shroomy.vmdl", context)

PrecacheResource("model", "models/items/courier/jumo/jumo.vmdl", context)
PrecacheResource("model", "models/items/courier/jumo_dire/jumo_dire.vmdl", context)
PrecacheResource("model", "models/items/courier/guardians_of_justice_enix/guardians_of_justice_enix.vmdl", context)
PrecacheResource("model", "models/items/courier/guardians_of_justice_phoe/guardians_of_justice_phoe.vmdl", context)
PrecacheResource("model", "models/items/courier/jin_yin_white_fox/jin_yin_white_fox.vmdl", context)
PrecacheResource("model", "models/items/courier/jin_yin_black_fox/jin_yin_black_fox.vmdl", context)



--	PrecacheResource("model", "models/heroes/death_prophet/death_prophet.vmdl", context)
--	PrecacheResource("model", "models/items/death_prophet/drowned_siren_head/drowned_siren_head.vmdl", context)
  --  PrecacheResource("model", "models/items/death_prophet/drowned_siren_drowned_siren_skirt/drowned_siren_drowned_siren_skirt.vmdl", context)
  --  PrecacheResource("model", "models/items/death_prophet/drowned_siren_armor/drowned_siren_armor.vmdl", context)
   -- PrecacheResource("model", "models/items/death_prophet/exorcism/drowned_siren_drowned_siren_crowned_fish/drowned_siren_drowned_siren_crowned_fish.vmdl", context)
  --  PrecacheResource("model", "models/items/death_prophet/drowned_siren_misc/drowned_siren_misc.vmdl", context)
	
--	PrecacheResource("model", "models/heroes/life_stealer/life_stealer.vmdl", context)
	--PrecacheResource("model", "models/items/lifestealer/bloody_ripper_belt/bloody_ripper_belt.vmdl", context)
  --  PrecacheResource("model", "models/items/lifestealer/promo_bloody_ripper_back/promo_bloody_ripper_back.vmdl", context)
   -- PrecacheResource("model", "models/items/lifestealer/bloody_ripper_arms/bloody_ripper_arms.vmdl", context)       
   -- PrecacheResource("model", "models/items/lifestealer/bloody_ripper_head/bloody_ripper_head.vmdl", context)  
	
 --  PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_weapon.vmdl", context)
  --  PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_arms.vmdl", context)
  --  PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_shoulder.vmdl", context)
  --  PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_armor.vmdl", context)
   -- PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_back.vmdl", context)
    --PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_head.vmdl", context)	
	
	--PrecacheResource("model", "models/heroes/pudge/pudge.vmdl", context)
	--PrecacheResource("model", "models/items/pudge/blackdeath_offhand/blackdeath_offhand.vmdl", context)
   -- PrecacheResource("model", "models/items/pudge/blackdeath_belt/blackdeath_belt.vmdl", context)
    --PrecacheResource("model", "models/items/pudge/blackdeath_head/blackdeath_head.vmdl", context)
    --PrecacheResource("model", "models/items/pudge/blackdeath_back/blackdeath_back.vmdl", context)
   -- PrecacheResource("model", "models/items/pudge/blackdeath_weapon/blackdeath_weapon.vmdl", context)
   -- PrecacheResource("model", "models/items/pudge/blackdeath_shoulder/blackdeath_shoulder.vmdl", context)
	--PrecacheResource("model", "models/items/pudge/blackdeath_arms/blackdeath_arms.vmdl", context)
	
	--PrecacheResource("model", "models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl", context)
	-- End Halloween
	
	PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts",context)
    PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts",context)

	-- PrecacheResource("soundfile", "soundevents/game_sounds_birzha.vsndevts", context) 
	PrecacheResource("soundfile", "soundevents/game_sounds_birzha_new.vsndevts", context) 

	PrecacheResource("model", "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_crystal.vmdl", context) 		
	
	
	PrecacheLoad:PrecacheLoad (context)
	
	GameRules.pc = context
	trollnelves2().pc = context
	
end

-- Create the game mode when we activate
function Activate()
	GameRules.MapSpeed = tonumber(string.match(GetMapName(),"%d+")) or 1
	GameRules.lumberPrice = STARTING_LUMBER_PRICE
	GameRules.maxFood = STARTING_MAX_FOOD
	GameRules.maxWisp = STARTING_MAX_WISP
	GameRules.maxMine = STARTING_MAX_MINE
	GameRules.maxWispMine = STARTING_MAX_WISP_MINE
	GameRules.playerTeamChoices = {}
	GameRules.dcedChoosers = {}
	-- --[[
	if string.match(GetMapName(),"1x1fort") then 
		GameRules.trollTps = {Vector(0,-1280,256)} -- -640
	else
		GameRules.trollTps = {Vector(-320,-320,256),Vector(0,-320,256),Vector(320,-320,256),Vector(-320,-640,256),Vector(0,-640,256),Vector(320,-640,256),Vector(-320,0,256),Vector(0,0,256),Vector(320,0,256),}
	end

	if GameRules.disconnectedHeroSelects == nil then
		GameRules.disconnectedHeroSelects = {}
	end
	--]]
	--GameRules.trollTps = {Vector(-320,-320,256),Vector(0,-320,256),Vector(320,-320,256),Vector(-320,-640,256),Vector(0,-640,256),Vector(320,-640,256),Vector(-320,0,256),Vector(0,0,256),Vector(320,0,256),}
	GameRules.angel_spawn_points = Entities:FindAllByName("angel_spawn_point")
	GameRules.shops = Entities:FindAllByClassname("trigger_shop")
	GameRules.base = Entities:FindAllByName("trigger_base")
	GameRules.baseBlock = Entities:FindAllByName("trigger_antibild")
	GameRules.startTime = nil
	GameRules.colorCounter = 1
	GameRules.gold = {}
	GameRules.lumber = {}
	GameRules.goldGained = {}
	GameRules.lumberGained = {}
	GameRules.goldGiven = {}
	GameRules.lumberGiven = {}
	GameRules.scores = {}
	GameRules.rep = {}
	GameRules.GetRep = {}
	GameRules.GetGem = {}
	GameRules.isTesting = false
	GameRules.server = "https://tve3.us/test/" -- "https://localhost:5001/test/"  -- 
	GameRules.BonusGem = {}
	--GameRules.xp = {}
	GameRules.types = {}
	GameRules.trollID = nil
	GameRules.trollHero = nil
	GameRules.trollID2 = nil
	GameRules.trollHero2 = nil
	GameRules.Bonus = {}
	GameRules.BonusPercent = 0
	GameRules.BonusTrollIDs = {}
	GameRules.PartDefaults = {}
	GameRules.PetsDefaults = {}
	GameRules.SkinDefaults = {}
	GameRules.Score = {}
	GameRules.PlayersBase = {}
	GameRules.PlayersBaseSendFlag = {}
	GameRules.PlayersFPS = {}
	GameRules.test = false
	GameRules.test2 = false
	GameRules.PlayersCount = 0
	GameRules.KickList = {}
	GameRules.MultiMapSpeed = 1
	GameRules.Mute = {}
	GameRules.countFlag = {}
	GameRules.tent = {}
	GameRules.Block = {}

	if GameRules.MapSpeed == 4 then
		GameRules.WOLF_START_SPAWN_TIME = 180 -- When the players will be able to choose wolf instead of auto chosen to angels. In seconds.
	elseif GameRules.MapSpeed == 2 then
		GameRules.WOLF_START_SPAWN_TIME = 240 -- When the players will be able to choose wolf instead of auto chosen to angels. In seconds.
	else
		GameRules.WOLF_START_SPAWN_TIME = 300 -- When the players will be able to choose wolf instead of auto chosen to angels. In seconds.
	end
	

	GameRules.PoolTable = {}
    GameRules.PoolTable[0] = {} -- валюта
    GameRules.PoolTable[1] = {} -- эффекты и петы
    GameRules.PoolTable[2] = {} -- шанс тролля
    GameRules.PoolTable[3] = {} -- бонус рейт
    GameRules.PoolTable[4] = {} -- сундуки
    GameRules.PoolTable[5] = {} -- инфа перса
	GameRules.PoolTable[6] = {} -- ежедневки 
	GameRules.PoolTable[7] = {} -- опыт батл пасса 
	GameRules.PoolTable[8] = {} -- статистика за эльфа 
	GameRules.PoolTable[9] = {} -- статистика за тролля
	GameRules.PoolTable[10] = {} -- батлпасс
	GameRules.PoolTable[11] = {} -- реп
	GameRules.PoolTable[12] = {} -- перк
    GameRules.PoolTable[0][0] = {}
    GameRules.PoolTable[1][0] = {}
    GameRules.PoolTable[2][0] = {}
    GameRules.PoolTable[3][0] = {}
    GameRules.PoolTable[4][0] = {}
    GameRules.PoolTable[4][0][0] = {}
    GameRules.PoolTable[5][0] = {}
	GameRules.PoolTable[6][0] = {}
	GameRules.PoolTable[7][0] = {}
	GameRules.PoolTable[7][0][0] = {}
	GameRules.PoolTable[8][0] = {} 
	GameRules.PoolTable[9][0] = {} 
	GameRules.PoolTable[10][0] = {} 
	GameRules.PoolTable[10][0][0] = {} 
	GameRules.PoolTable[11][0] = {} -- реп
	GameRules.PoolTable[12][0] = {} -- перк
	GameRules.PoolTable[12][0][0] = {} -- перк
	
	GameRules.SkinTower = {}
	GameRules.SkinTower[0] = {}
	GameRules.SkinTower[1] = {} 
	GameRules.SkinTower[2] = {} 
	GameRules.SkinTower[3] = {} 
	GameRules.SkinTower[4] = {} 
	GameRules.SkinTower[5] = {} 
	GameRules.SkinTower[6] = {} 
	GameRules.SkinTower[7] = {} 
	GameRules.SkinTower[8] = {} 
	GameRules.SkinTower[9] = {} 
	GameRules.SkinTower[10] = {} 
	GameRules.SkinTower[11] = {} 
	GameRules.SkinTower[12] = {} 
	GameRules.SkinTower[13] = {} 
	GameRules.SkinTower[14] = {} 
	GameRules.SkinTower[15] = {} 
	GameRules.SkinTower[16] = {} 
	
	GameRules.SkinTower[0][0] = {}
    GameRules.SkinTower[1][0] = {}
	GameRules.SkinTower[2][0] = {} 
	GameRules.SkinTower[3][0] = {} 
	GameRules.SkinTower[4][0] = {} 
	GameRules.SkinTower[5][0] = {} 
	GameRules.SkinTower[6][0] = {} 
	GameRules.SkinTower[7][0] = {} 
	GameRules.SkinTower[8][0] = {} 
	GameRules.SkinTower[9][0] = {} 
	GameRules.SkinTower[10][0] = {} 
	GameRules.SkinTower[11][0] = {} 
	GameRules.SkinTower[12][0] = {} 
	GameRules.SkinTower[13][0] = {} 
	GameRules.SkinTower[14][0] = {} 
	GameRules.SkinTower[15][0] = {} 
	GameRules.SkinTower[16][0] = {} 
	GameRules.FakeList = {}
	GameRules.trollnelves2 = trollnelves2()
	GameRules.trollnelves2:Inittrollnelves2()
	GameRules.MapName = ""

	GameRules.SaveDefItem = {}
	GameRules.SaveDefItem[0] = {}
	GameRules.SaveDefItem[1] = {} 
	GameRules.SaveDefItem[2] = {} 
	GameRules.SaveDefItem[3] = {} 
	GameRules.SaveDefItem[4] = {} 
	GameRules.SaveDefItem[5] = {} 
	GameRules.SaveDefItem[6] = {} 
	GameRules.SaveDefItem[7] = {} 
	GameRules.SaveDefItem[8] = {} 
	GameRules.SaveDefItem[9] = {} 
	GameRules.SaveDefItem[10] = {} 
	GameRules.SaveDefItem[11] = {} 
	GameRules.SaveDefItem[12] = {} 
	GameRules.SaveDefItem[13] = {} 
	GameRules.SaveDefItem[14] = {} 
	GameRules.SaveDefItem[15] = {} 
	GameRules.SaveDefItem[16] = {} 
	
	GameRules.SaveDefItem[0][0] = {}
    GameRules.SaveDefItem[1][0] = {}
	GameRules.SaveDefItem[2][0] = {} 
	GameRules.SaveDefItem[3][0] = {} 
	GameRules.SaveDefItem[4][0] = {} 
	GameRules.SaveDefItem[5][0] = {} 
	GameRules.SaveDefItem[6][0] = {} 
	GameRules.SaveDefItem[7][0] = {} 
	GameRules.SaveDefItem[8][0] = {} 
	GameRules.SaveDefItem[9][0] = {} 
	GameRules.SaveDefItem[10][0] = {} 
	GameRules.SaveDefItem[11][0] = {} 
	GameRules.SaveDefItem[12][0] = {} 
	GameRules.SaveDefItem[13][0] = {} 
	GameRules.SaveDefItem[14][0] = {} 
	GameRules.SaveDefItem[15][0] = {} 
	GameRules.SaveDefItem[16][0] = {} 

	LinkModifier:Start()
end
