-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc
require('events_protector')
require('LinkModifier')
require('internal/util')
require('trollnelves2')
require("setup_state_lib")
require("libraries/buildinghelper")
require('settings')
require("PrecacheLoad")
require("map_system")
require("mod_system")
require('PseudoRandom')
require('donate_store/wearables_data') 

function Precache( context )
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

PrecacheResource("model", "models/heroes/alchemist/alchemist_goblin_body.vmdl", context)
PrecacheResource("model", "models/heroes/alchemist/alchemist_scabbard.vmdl", context)
PrecacheResource("model", "models/heroes/alchemist/alchemist_saddlehat.vmdl", context)
PrecacheResource("model", "models/heroes/alchemist/alchemist_gauntlets.vmdl", context)
PrecacheResource("model", "models/heroes/alchemist/alchemist_goblinhat.vmdl", context)
PrecacheResource("model", "models/heroes/alchemist/alchemist_leftbottle.vmdl", context)
PrecacheResource("model", "models/heroes/alchemist/alchemist_goblin_head.vmdl", context)
PrecacheResource("model", "models/heroes/alchemist/alchemist_ogre_head.vmdl", context)
PrecacheResource("model", "models/heroes/alchemist/alchemist_shoulderbottles.vmdl", context)
PrecacheResource("model", "models/heroes/lanaya/lanaya_hair.vmdl", context)
PrecacheResource("model", "models/heroes/lanaya/lanaya_cowl_shoulder.vmdl", context)
PrecacheResource("model", "models/heroes/medusa/medusa_bow.vmdl", context)
PrecacheResource("model", "models/heroes/medusa/medusa_veil.vmdl", context)
PrecacheResource("model", "models/heroes/medusa/medusa_torso.vmdl", context)
PrecacheResource("model", "models/heroes/medusa/medusa_arms.vmdl", context)
PrecacheResource("model", "models/heroes/medusa/medusa_tail.vmdl", context)
PrecacheResource("model", "models/heroes/shadow_fiend/shadow_fiend_head.vmdl", context)
PrecacheResource("model", "models/heroes/shadow_fiend/shadow_fiend_head.vmdl", context)
PrecacheResource("model", "models/heroes/shadow_fiend/shadow_fiend_head.vmdl", context)
PrecacheResource("model", "models/heroes/vengeful/vengeful_hair.vmdl", context)
PrecacheResource("model", "models/heroes/vengeful/vengeful_weapon.vmdl", context)
PrecacheResource("model", "models/heroes/vengeful/vengeful_upperbody.vmdl", context)
PrecacheResource("model", "models/heroes/vengeful/vengeful_lowerbody.vmdl", context)
PrecacheResource("model", "models/heroes/luna/luna_weapon.vmdl", context)
PrecacheResource("model", "models/heroes/luna/luna_helmet.vmdl", context)
PrecacheResource("model", "models/heroes/luna/luna_shoulder.vmdl", context)
PrecacheResource("model", "models/heroes/luna/luna_mount.vmdl", context)
PrecacheResource("model", "models/heroes/luna/luna_head.vmdl", context)
PrecacheResource("model", "models/heroes/shadow_fiend/shadow_fiend_shoulders.vmdl", context)
PrecacheResource("model", "models/heroes/shadow_fiend/shadow_fiend_shoulders.vmdl", context)
PrecacheResource("model", "models/heroes/shadow_fiend/shadow_fiend_shoulders.vmdl", context)
PrecacheResource("model", "models/heroes/shadow_fiend/shadow_fiend_arms.vmdl", context)
PrecacheResource("model", "models/heroes/shadow_fiend/shadow_fiend_arms.vmdl", context)
PrecacheResource("model", "models/heroes/shadow_fiend/shadow_fiend_arms.vmdl", context)
PrecacheResource("model", "models/heroes/hoodwink/hoodwink_costume.vmdl", context)
PrecacheResource("model", "models/heroes/hoodwink/hoodwink_tail.vmdl", context)
PrecacheResource("model", "models/heroes/hoodwink/hoodwink_crossbow.vmdl", context)
PrecacheResource("model", "models/items/huskar/obsidian_claw_of_the_jaguar_arms/obsidian_claw_of_the_jaguar_arms.vmdl", context)
PrecacheResource("model", "models/items/huskar/obsidian_claw_of_the_jaguar_helmet/obsidian_claw_of_the_jaguar_helmet.vmdl", context)
PrecacheResource("model", "models/items/huskar/obsidian_claw_of_the_jaguar_shoulder/obsidian_claw_of_the_jaguar_shoulder.vmdl", context)
PrecacheResource("model", "models/items/mirana/mirana_nightsilver_owlion/mirana_nightsilver_owlion.vmdl", context)
PrecacheResource("model", "models/items/windrunner/shoulderpadfalcon/shoulderpadfalcon.vmdl", context)
PrecacheResource("model", "models/items/windrunner/wingsweapon2/wingsweapon2.vmdl", context)
PrecacheResource("model", "models/items/windrunner/featherquiver21/featherquiver21.vmdl", context)
PrecacheResource("model", "models/items/windrunner/falconcloak/falconcloak.vmdl", context)
PrecacheResource("model", "models/items/windrunner/falconhelm1/falconhelm1.vmdl", context)
PrecacheResource("model", "models/items/windrunner/wingsshoulders2/wingsshoulders2.vmdl", context)
PrecacheResource("model", "models/items/furion/scythe_of_vyse.vmdl", context)
PrecacheResource("model", "models/items/mirana/mirana_nightsilver_arms/mirana_nightsilver_arms.vmdl", context)
PrecacheResource("model", "models/items/mirana/mirana_nightsilver_quiver/mirana_nightsilver_quiver.vmdl", context)
PrecacheResource("model", "models/items/mirana/mirana_nightsilver_cape/mirana_nightsilver_cape.vmdl", context)
PrecacheResource("model", "models/items/mirana/mirana_nightsilver_shoulders/mirana_nightsilver_shoulders.vmdl", context)
PrecacheResource("model", "models/items/mirana/mirana_nightsilver_hair/mirana_nightsilver_hair.vmdl", context)
PrecacheResource("model", "models/items/mirana/mirana_nightsilver_weapon/mirana_nightsilver_weapon.vmdl", context)
PrecacheResource("model", "models/items/sniper/sharpshooter_stache/sharpshooter_stache.vmdl", context)
PrecacheResource("model", "models/items/sniper/killstealer/killstealer.vmdl", context)
PrecacheResource("model", "models/items/sniper/sharpshooter_shoulder/sharpshooter_shoulder.vmdl", context)
PrecacheResource("model", "models/items/sniper/sharpshooter_cloak/sharpshooter_cloak.vmdl", context)
PrecacheResource("model", "models/items/huskar/obsidian_blade_spear/obsidian_blade_spear.vmdl", context)
PrecacheResource("model", "models/items/huskar/obsidian_claw_of_the_jaguar_dagger/obsidian_claw_of_the_jaguar_dagger.vmdl", context)
PrecacheResource("model", "models/items/sniper/sharpshooter_arms/sharpshooter_arms.vmdl", context)
PrecacheResource("model", "models/items/kunkka/second_chance_of_the_kunkkistadore/second_chance_of_the_kunkkistadore.vmdl", context)
PrecacheResource("model", "models/items/kunkka/first_chance_of_the_kunkkistadore/first_chance_of_the_kunkkistadore.vmdl", context)
PrecacheResource("model", "models/items/kunkka/kunkkistadores_gloves/kunkkistadores_gloves.vmdl", context)
PrecacheResource("model", "models/items/kunkka/kunkkistadores_helm/kunkkistadores_helm.vmdl", context)
PrecacheResource("model", "models/items/kunkka/treds_of_the_kunkkistadore/treds_of_the_kunkkistadore.vmdl", context)
PrecacheResource("model", "models/items/kunkka/chestplate_of_the_kunkkistadore/chestplate_of_the_kunkkistadore.vmdl", context)
PrecacheResource("model", "models/items/kunkka/elegant_shoulders_of_the_kunkkistadore/elegant_shoulders_of_the_kunkkistadore.vmdl", context)
PrecacheResource("model", "models/items/kunkka/kunkkistadores_true_north/kunkkistadores_true_north.vmdl", context)
PrecacheResource("model", "models/items/chen/arms_navi/arms_navi.vmdl", context)
PrecacheResource("model", "models/items/chen/head_navi/head_navi.vmdl", context)
PrecacheResource("model", "models/items/chen/shoulder_navi/shoulder_navi.vmdl", context)
PrecacheResource("model", "models/items/chen/weapon_navi/weapon_navi.vmdl", context)
PrecacheResource("model", "models/items/sniper/wolf_arms_bright/wolf_arms_bright.vmdl", context)
PrecacheResource("model", "models/items/sniper/wolf_cape_bright/wolf_cape_bright.vmdl", context)
PrecacheResource("model", "models/items/sniper/wolf_gun_bright/wolf_gun_bright.vmdl", context)
PrecacheResource("model", "models/items/sniper/wolf_hat_bright/wolf_hat_bright.vmdl", context)
PrecacheResource("model", "models/items/sniper/wolf_shoulder_bright/wolf_shoulder_bright.vmdl", context)
PrecacheResource("model", "models/items/drow/death_shadow_bracers/death_shadow_bracers.vmdl", context)
PrecacheResource("model", "models/items/drow/death_shadow_cape/death_shadow_cape.vmdl", context)
PrecacheResource("model", "models/items/drow/death_shadow_cowl/death_shadow_cowl.vmdl", context)
PrecacheResource("model", "models/items/drow/death_shadow_boots/death_shadow_boots.vmdl", context)
PrecacheResource("model", "models/items/drow/death_shadow_quiver/death_shadow_quiver.vmdl", context)
PrecacheResource("model", "models/items/drow/death_shadow_mantle/death_shadow_mantle.vmdl", context)
PrecacheResource("model", "models/items/drow/death_shadow_bow/death_shadow_bow.vmdl", context)
PrecacheResource("model", "models/items/dazzle/band_of_summoning/band_of_summoning.vmdl", context)
PrecacheResource("model", "models/items/dazzle/headdress_of_the_yuwipi/headdress_of_the_yuwipi.vmdl", context)
PrecacheResource("model", "models/items/dazzle/bonedress_of_the_yuwipi/bonedress_of_the_yuwipi.vmdl", context)
PrecacheResource("model", "models/items/dazzle/staff_of_the_yuwipi/staff_of_the_yuwipi.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/demon_stone_bracers/demon_stone_bracers.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/demon_stone_belt/demon_stone_belt.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/demon_stone_hair/demon_stone_hair.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/demon_stone_necklace/demon_stone_necklace.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/demon_stone_weapon/demon_stone_weapon.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/arm_guards_of_prosperity/arm_guards_of_prosperity.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/crimson_guard_of_prosperity/crimson_guard_of_prosperity.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/phoenix_helm_of_prosperity/phoenix_helm_of_prosperity.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/jin__blade_of_prosperity/jin__blade_of_prosperity.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/huo__blade_of_prosperity/huo__blade_of_prosperity.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/ember_pauldrons_of_prosperity/ember_pauldrons_of_prosperity.vmdl", context)
PrecacheResource("model", "models/items/rikimaru/frozenblood_arms/frozenblood_arms.vmdl", context)
PrecacheResource("model", "models/items/rikimaru/frozenblood_weapon/frozenblood_weapon.vmdl", context)
PrecacheResource("model", "models/items/rikimaru/frozenblood_offhandweapon/frozenblood_offhandweapon.vmdl", context)
PrecacheResource("model", "models/items/rikimaru/frozenblood_head/frozenblood_head.vmdl", context)
PrecacheResource("model", "models/items/rikimaru/frozenblood_shoulder/frozenblood_shoulder.vmdl", context)
PrecacheResource("model", "models/items/rikimaru/frozenblood_tail/frozenblood_tail.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/vanquishing_demons_arms/vanquishing_demons_arms.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/vanquishing_demons_belt/vanquishing_demons_belt.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/vanquishing_demons_helmet/vanquishing_demons_helmet.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/vanquishing_demons_neck/vanquishing_demons_neck.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/vanquishing_demons_weapon/vanquishing_demons_weapon.vmdl", context)
PrecacheResource("model", "models/items/sniper/machine_gun_charlie/machine_gun_charlie.vmdl", context)
PrecacheResource("model", "models/items/rattletrap/forge_warrior_claw/forge_warrior_claw.vmdl", context)
PrecacheResource("model", "models/items/rattletrap/forge_warrior_helm/forge_warrior_helm.vmdl", context)
PrecacheResource("model", "models/items/rattletrap/forge_warrior_rocket_cannon/forge_warrior_rocket_cannon.vmdl", context)
PrecacheResource("model", "models/items/rattletrap/forge_warrior_steam_exoskeleton/forge_warrior_steam_exoskeleton.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/iron_claw_bracer/iron_claw_bracer.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/iron_claw_beard/iron_claw_beard.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/iron_claw_pauldron/iron_claw_pauldron.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/iron_claw_robe/iron_claw_robe.vmdl", context)
PrecacheResource("model", "models/items/lone_druid/iron_claw_weapon/iron_claw_weapon.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/mentor_high_plains_head/mentor_high_plains_head.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/mentor_high_plains_belt/mentor_high_plains_belt.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/mentor_high_plains_arms/mentor_high_plains_arms.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/mentor_high_plains_shoulder/mentor_high_plains_shoulder.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/mentor_high_plains_weapon/mentor_high_plains_weapon.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/mentor_high_plains_offhand/mentor_high_plains_offhand.vmdl", context)
PrecacheResource("model", "models/items/dragon_knight/ascension_weapon/ascension_weapon.vmdl", context)
PrecacheResource("model", "models/items/dragon_knight/ascension_back/ascension_back.vmdl", context)
PrecacheResource("model", "models/items/dragon_knight/ascension_offhand/ascension_offhand.vmdl", context)
PrecacheResource("model", "models/items/dragon_knight/ascension_arms/ascension_arms.vmdl", context)
PrecacheResource("model", "models/items/dragon_knight/ascension_shoulder/ascension_shoulder.vmdl", context)
PrecacheResource("model", "models/items/dragon_knight/ascension_head/ascension_head.vmdl", context)
PrecacheResource("model", "models/items/venomancer/acidflytrap_tenticles/acidflytrap_tenticles.vmdl", context)
PrecacheResource("model", "models/items/venomancer/acidflytrap_tail/acidflytrap_tail.vmdl", context)
PrecacheResource("model", "models/items/venomancer/acidflytrap_shoulders/acidflytrap_shoulders.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/blazearmor_arms/blazearmor_arms.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/blazearmor_belt/blazearmor_belt.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/blazearmor_shoulder/blazearmor_shoulder.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/blazearmor_head/blazearmor_head.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/blazearmor_offhand/blazearmor_offhand.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/blazearmor_weapon/blazearmor_weapon.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/stone_tranquility_belt/stone_tranquility_belt.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/stone_tranquility_weapon/stone_tranquility_weapon.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/stone_tranquility_helm/stone_tranquility_helm.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/stone_tranquility_neck/stone_tranquility_neck.vmdl", context)
PrecacheResource("model", "models/items/chaos_knight/burning_nightmare_chaos_knight_weapon/burning_nightmare_chaos_knight_weapon.vmdl", context)
PrecacheResource("model", "models/items/chaos_knight/burning_nightmare_chaos_knight_shoulder/burning_nightmare_chaos_knight_shoulder.vmdl", context)
PrecacheResource("model", "models/items/chaos_knight/burning_nightmare_chaos_knight_off_hand/burning_nightmare_chaos_knight_off_hand.vmdl", context)
PrecacheResource("model", "models/items/chaos_knight/burning_nightmare_chaos_knight_mount/burning_nightmare_chaos_knight_mount.vmdl", context)
PrecacheResource("model", "models/items/chaos_knight/burning_nightmare_chaos_knight_head/burning_nightmare_chaos_knight_head.vmdl", context)
PrecacheResource("model", "models/items/ancient_apparition/ancient_prophet_of_ice_tail/ancient_prophet_of_ice_tail.vmdl", context)
PrecacheResource("model", "models/items/visage/bound_of_the_soul_keeper_head/bound_of_the_soul_keeper_head.vmdl", context)
PrecacheResource("model", "models/items/omniknight/grey_night_arms/grey_night_arms.vmdl", context)
PrecacheResource("model", "models/items/omniknight/grey_night_back/grey_night_back.vmdl", context)
PrecacheResource("model", "models/items/omniknight/grey_night_head/grey_night_head.vmdl", context)
PrecacheResource("model", "models/items/omniknight/grey_night_shoulders/grey_night_shoulders.vmdl", context)
PrecacheResource("model", "models/items/omniknight/grey_night_weapon/grey_night_weapon.vmdl", context)
PrecacheResource("model", "models/items/clinkz/redbull_clinkz_head/redbull_clinkz_head.vmdl", context)
PrecacheResource("model", "models/items/clinkz/redbull_clinkz_gloves/redbull_clinkz_gloves.vmdl", context)
PrecacheResource("model", "models/items/clinkz/redbull_clinkz_back/redbull_clinkz_back.vmdl", context)
PrecacheResource("model", "models/items/clinkz/redbull_clinkz_shoulder/redbull_clinkz_shoulder.vmdl", context)
PrecacheResource("model", "models/items/enigma/world_chasm/world_chasm.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/the_jade_general_arms/the_jade_general_arms.vmdl", context)
PrecacheResource("model", "models/items/ancient_apparition/ancient_prophet_of_ice_shoulder/ancient_prophet_of_ice_shoulder.vmdl", context)
PrecacheResource("model", "models/items/ancient_apparition/ancient_prophet_of_ice_arms/ancient_prophet_of_ice_arms.vmdl", context)
PrecacheResource("model", "models/items/ancient_apparition/ancient_prophet_of_ice_arms/ancient_prophet_of_ice_arms.vmdl", context)
PrecacheResource("model", "models/items/ancient_apparition/ancient_prophet_of_ice_head/ancient_prophet_of_ice_head.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/the_jade_general_belt/the_jade_general_belt.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/the_jade_general_head/the_jade_general_head.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/the_jade_general_neck/the_jade_general_neck.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/the_jade_general_weapon/the_jade_general_weapon.vmdl", context)
PrecacheResource("model", "models/items/furion/the_ancient_guardian_head/the_ancient_guardian_head.vmdl", context)
PrecacheResource("model", "models/items/visage/bound_of_the_soul_keeper_armor/bound_of_the_soul_keeper_armor.vmdl", context)
PrecacheResource("model", "models/items/gyrocopter/flamed_falcon_patrol_weapon/flamed_falcon_patrol_weapon.vmdl", context)
PrecacheResource("model", "models/items/gyrocopter/flamed_falcon_patrol_off_hand/flamed_falcon_patrol_off_hand.vmdl", context)
PrecacheResource("model", "models/items/gyrocopter/flamed_falcon_patrol_misc/flamed_falcon_patrol_misc.vmdl", context)
PrecacheResource("model", "models/items/gyrocopter/flamed_falcon_patrol_head/flamed_falcon_patrol_head.vmdl", context)
PrecacheResource("model", "models/items/gyrocopter/flamed_falcon_patrol_back/flamed_falcon_patrol_back.vmdl", context)
PrecacheResource("model", "models/items/chen/chen_eye_of_power_mount/chen_eye_of_power_mount.vmdl", context)
PrecacheResource("model", "models/items/chen/chen_eye_of_power_weapon/chen_eye_of_power_weapon.vmdl", context)
PrecacheResource("model", "models/items/chen/chen_eye_of_power_shoulder/chen_eye_of_power_shoulder.vmdl", context)
PrecacheResource("model", "models/items/chen/chen_eye_of_power_misc/chen_eye_of_power_misc.vmdl", context)
PrecacheResource("model", "models/items/chen/chen_eye_of_power_head/chen_eye_of_power_head.vmdl", context)
PrecacheResource("model", "models/items/chen/chen_eye_of_power_arms/chen_eye_of_power_arms.vmdl", context)
PrecacheResource("model", "models/items/chen/mount_navi_combined/mount_navi_combined.vmdl", context)
PrecacheResource("model", "models/items/siren/arms_of_the_captive_princess_head/arms_of_the_captive_princess_head.vmdl", context)
PrecacheResource("model", "models/items/siren/arms_of_the_captive_princess_offhand/arms_of_the_captive_princess_offhand.vmdl", context)
PrecacheResource("model", "models/items/siren/arms_of_the_captive_princess_weapon/arms_of_the_captive_princess_weapon.vmdl", context)
PrecacheResource("model", "models/items/siren/arms_of_the_captive_princess_legs/arms_of_the_captive_princess_legs.vmdl", context)
PrecacheResource("model", "models/items/siren/arms_of_the_captive_princess_armor/arms_of_the_captive_princess_armor.vmdl", context)
PrecacheResource("model", "models/items/sniper/sniper_cape_immortal/sniper_cape_immortal.vmdl", context)
PrecacheResource("model", "models/items/chen/desert_wanderer_mount/desert_wanderer_mount.vmdl", context)
PrecacheResource("model", "models/items/chen/desert_wanderer_arms/desert_wanderer_arms.vmdl", context)
PrecacheResource("model", "models/items/chen/desert_wanderer_shoulder/desert_wanderer_shoulder.vmdl", context)
PrecacheResource("model", "models/items/chen/desert_wanderer_weapon/desert_wanderer_weapon.vmdl", context)
PrecacheResource("model", "models/items/chen/desert_wanderer_head/desert_wanderer_head.vmdl", context)
PrecacheResource("model", "models/items/witchdoctor/poison_cook_witch_doctor_back/poison_cook_witch_doctor_back.vmdl", context)
PrecacheResource("model", "models/items/witchdoctor/poison_cook_witch_doctor_shoulder/poison_cook_witch_doctor_shoulder.vmdl", context)
PrecacheResource("model", "models/items/witchdoctor/poison_cook_witch_doctor_head/poison_cook_witch_doctor_head.vmdl", context)
PrecacheResource("model", "models/items/witchdoctor/poison_cook_witch_doctor_weapon/poison_cook_witch_doctor_weapon.vmdl", context)
PrecacheResource("model", "models/items/witchdoctor/poison_cook_witch_doctor_belt/poison_cook_witch_doctor_belt.vmdl", context)
PrecacheResource("model", "models/items/shredder/treepunisher_armor/treepunisher_armor.vmdl", context)
PrecacheResource("model", "models/items/shredder/treepunisher_head/treepunisher_head.vmdl", context)
PrecacheResource("model", "models/items/shredder/treepunisher_back/treepunisher_back.vmdl", context)
PrecacheResource("model", "models/items/shredder/treepunisher_offhand/treepunisher_offhand.vmdl", context)
PrecacheResource("model", "models/items/shredder/treepunisher_offhand/treepunisher_offhand.vmdl", context)
PrecacheResource("model", "models/items/shredder/treepunisher_weapon/treepunisher_weapon.vmdl", context)
PrecacheResource("model", "models/items/shredder/treepunisher_weapon/treepunisher_weapon.vmdl", context)
PrecacheResource("model", "models/items/shredder/treepunisher_shoulder/treepunisher_shoulder.vmdl", context)
PrecacheResource("model", "models/items/shredder/treepunisher_shoulder/treepunisher_shoulder.vmdl", context)
PrecacheResource("model", "models/items/viper/viper_frigid_serpent_head/viper_frigid_serpent_head.vmdl", context)
PrecacheResource("model", "models/items/viper/viper_frigid_serpent_back/viper_frigid_serpent_back.vmdl", context)
PrecacheResource("model", "models/items/viper/viper_frigid_serpent_tail/viper_frigid_serpent_tail.vmdl", context)
PrecacheResource("model", "models/items/chen/ti8_chen_the_rat_king_head/ti8_chen_the_rat_king_head.vmdl", context)
PrecacheResource("model", "models/items/chen/ti8_chen_the_rat_king_weapon/ti8_chen_the_rat_king_weapon.vmdl", context)
PrecacheResource("model", "models/items/chen/ti8_chen_the_rat_king_mount/ti8_chen_the_rat_king_mount.vmdl", context)
PrecacheResource("model", "models/items/chen/ti8_chen_the_rat_king_shoulder/ti8_chen_the_rat_king_shoulder.vmdl", context)
PrecacheResource("model", "models/items/chen/ti8_chen_the_rat_king_arms/ti8_chen_the_rat_king_arms.vmdl", context)
PrecacheResource("model", "models/items/rattletrap/frostivus2018_lighter_fighter_head/frostivus2018_lighter_fighter_head.vmdl", context)
PrecacheResource("model", "models/items/rattletrap/frostivus2018_lighter_fighter_armor/frostivus2018_lighter_fighter_armor.vmdl", context)
PrecacheResource("model", "models/items/rattletrap/frostivus2018_lighter_fighter_misc/frostivus2018_lighter_fighter_misc.vmdl", context)
PrecacheResource("model", "models/items/rattletrap/frostivus2018_lighter_fighter_weapon/frostivus2018_lighter_fighter_weapon.vmdl", context)
PrecacheResource("model", "models/items/clinkz/clinkz_ti9_immortal_weapon/clinkz_ti9_immortal_weapon.vmdl", context)
PrecacheResource("model", "models/items/chen/ti9_cache_chen_emperor_of_the_sun_weapon/ti9_cache_chen_emperor_of_the_sun_weapon.vmdl", context)
PrecacheResource("model", "models/items/chen/ti9_cache_chen_emperor_of_the_sun_shoulder/ti9_cache_chen_emperor_of_the_sun_shoulder.vmdl", context)
PrecacheResource("model", "models/items/chen/ti9_cache_chen_emperor_of_the_sun_head/ti9_cache_chen_emperor_of_the_sun_head.vmdl", context)
PrecacheResource("model", "models/items/chen/ti9_cache_chen_emperor_of_the_sun_arms/ti9_cache_chen_emperor_of_the_sun_arms.vmdl", context)
PrecacheResource("model", "models/items/chen/ti9_cache_chen_emperor_of_the_sun_mount/ti9_cache_chen_emperor_of_the_sun_mount.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/kungfu_master_arms/kungfu_master_arms.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/kungfu_master_head/kungfu_master_head.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/kungfu_master_weapon/kungfu_master_weapon.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/kungfu_master_shoulder/kungfu_master_shoulder.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/kungfu_master_off_hand/kungfu_master_off_hand.vmdl", context)
PrecacheResource("model", "models/items/arc_warden/ti9_cache_aw_ancient_mechanism_shoulder/ti9_cache_aw_ancient_mechanism_shoulder.vmdl", context)
PrecacheResource("model", "models/items/arc_warden/ti9_cache_aw_ancient_mechanism_head/ti9_cache_aw_ancient_mechanism_head.vmdl", context)
PrecacheResource("model", "models/items/arc_warden/ti9_cache_aw_ancient_mechanism_back/ti9_cache_aw_ancient_mechanism_back.vmdl", context)
PrecacheResource("model", "models/items/arc_warden/ti9_cache_aw_ancient_mechanism_arms/ti9_cache_aw_ancient_mechanism_arms.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/kungfu_master_belt/kungfu_master_belt.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/ember_sindur_sensei_head/ember_sindur_sensei_head.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/ember_sindur_sensei_weapon/ember_sindur_sensei_weapon.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/ember_sindur_sensei_shoulder/ember_sindur_sensei_shoulder.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/ti9_cache_earthspirit_turquoise_giant_head/ti9_cache_earthspirit_turquoise_giant_head.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/ti9_cache_earthspirit_turquoise_giant_neck/ti9_cache_earthspirit_turquoise_giant_neck.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/ti9_cache_earthspirit_turquoise_giant_belt/ti9_cache_earthspirit_turquoise_giant_belt.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/ti9_cache_earthspirit_turquoise_giant_arms/ti9_cache_earthspirit_turquoise_giant_arms.vmdl", context)
PrecacheResource("model", "models/items/earth_spirit/ti9_cache_earthspirit_turquoise_giant_weapon/ti9_cache_earthspirit_turquoise_giant_weapon.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/ember_sindur_sensei_offhand/ember_sindur_sensei_offhand.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/ember_sindur_sensei_belt/ember_sindur_sensei_belt.vmdl", context)
PrecacheResource("model", "models/items/ember_spirit/ember_sindur_sensei_arms/ember_sindur_sensei_arms.vmdl", context)
PrecacheResource("model", "models/items/arc_warden/wicked_space_knight_shoulder/wicked_space_knight_shoulder.vmdl", context)
PrecacheResource("model", "models/items/arc_warden/wicked_space_knight_head/wicked_space_knight_head.vmdl", context)
PrecacheResource("model", "models/items/arc_warden/wicked_space_knight_back/wicked_space_knight_back.vmdl", context)
PrecacheResource("model", "models/items/arc_warden/wicked_space_knight_arms/wicked_space_knight_arms.vmdl", context)
PrecacheResource("model", "models/items/tinker/mecha_hornet_back/mecha_hornet_back.vmdl", context)
PrecacheResource("model", "models/items/tinker/mecha_hornet_weapon/mecha_hornet_weapon.vmdl", context)
PrecacheResource("model", "models/items/tinker/mecha_hornet_shoulder/mecha_hornet_shoulder.vmdl", context)
PrecacheResource("model", "models/items/tinker/mecha_hornet_off_hand/mecha_hornet_off_hand.vmdl", context)
PrecacheResource("model", "models/items/tinker/mecha_hornet_head/mecha_hornet_head.vmdl", context)
PrecacheResource("model", "models/items/vengefulspirit/venge_lost_seraph_weapon/venge_lost_seraph_weapon.vmdl", context)
PrecacheResource("model", "models/items/vengefulspirit/venge_lost_seraph_shoulder/venge_lost_seraph_shoulder.vmdl", context)
PrecacheResource("model", "models/items/vengefulspirit/venge_lost_seraph_legs/venge_lost_seraph_legs.vmdl", context)
PrecacheResource("model", "models/items/vengefulspirit/venge_lost_seraph_head/venge_lost_seraph_head.vmdl", context)
PrecacheResource("model", "models/items/furion/np_desert_traveller_shoulder/np_desert_traveller_shoulder.vmdl", context)
PrecacheResource("model", "models/items/furion/np_desert_traveller_neck/np_desert_traveller_neck.vmdl", context)
PrecacheResource("model", "models/items/furion/np_desert_traveller_back/np_desert_traveller_back.vmdl", context)
PrecacheResource("model", "models/items/furion/np_desert_traveller_arms/np_desert_traveller_arms.vmdl", context)
PrecacheResource("model", "models/items/sniper/scifi_sniper_test_head/scifi_sniper_test_head.vmdl", context)
PrecacheResource("model", "models/items/sniper/scifi_sniper_test_head/scifi_sniper_test_head.vmdl", context)
PrecacheResource("model", "models/items/sniper/scifi_sniper_test_arms/scifi_sniper_test_arms.vmdl", context)
PrecacheResource("model", "models/items/sniper/scifi_sniper_test_arms/scifi_sniper_test_arms.vmdl", context)
PrecacheResource("model", "models/items/sniper/scifi_sniper_test_shoulder/scifi_sniper_test_shoulder.vmdl", context)
PrecacheResource("model", "models/items/sniper/scifi_sniper_test_shoulder/scifi_sniper_test_shoulder.vmdl", context)
PrecacheResource("model", "models/items/sniper/scifi_sniper_test_gun/scifi_sniper_test_gun.vmdl", context)
PrecacheResource("model", "models/items/sniper/scifi_sniper_test_back/scifi_sniper_test_back.vmdl", context)
PrecacheResource("model", "models/items/shredder/halloween_vandal_claw/halloween_vandal_claw.vmdl", context)
PrecacheResource("model", "models/items/shredder/halloween_vandal_shoulder/halloween_vandal_shoulder.vmdl", context)
PrecacheResource("model", "models/items/shredder/halloween_vandal_saw/halloween_vandal_saw.vmdl", context)
PrecacheResource("model", "models/items/shredder/halloween_vandal_armor/halloween_vandal_armor.vmdl", context)
PrecacheResource("model", "models/items/shredder/halloween_vandal_back/halloween_vandal_back.vmdl", context)
PrecacheResource("model", "models/items/shredder/halloween_vandal_head/halloween_vandal_head.vmdl", context)
PrecacheResource("model", "models/items/enchantress/darkwood_witch_head/darkwood_witch_head.vmdl", context)
PrecacheResource("model", "models/items/enchantress/darkwood_witch_neck/darkwood_witch_neck.vmdl", context)
PrecacheResource("model", "models/items/enchantress/darkwood_witch_arms/darkwood_witch_arms.vmdl", context)
PrecacheResource("model", "models/items/enchantress/darkwood_witch_belt/darkwood_witch_belt.vmdl", context)
PrecacheResource("model", "models/items/enchantress/darkwood_witch_weapon/darkwood_witch_weapon.vmdl", context)
PrecacheResource("model", "models/items/sniper/spring2021_ambush_sniper_arms/spring2021_ambush_sniper_arms.vmdl", context)
PrecacheResource("model", "models/items/sniper/spring2021_ambush_sniper_cape/spring2021_ambush_sniper_cape.vmdl", context)
PrecacheResource("model", "models/items/sniper/spring2021_ambush_sniper_nest_cap/spring2021_ambush_sniper_nest_cap.vmdl", context)
PrecacheResource("model", "models/items/sniper/spring2021_ambush_sniper_shoulders/spring2021_ambush_sniper_shoulders.vmdl", context)
PrecacheResource("model", "models/items/sniper/spring2021_ambush_sniper_sniper_rifle/spring2021_ambush_sniper_sniper_rifle.vmdl", context)

PrecacheResource("model", "models/heroes/lanaya/lanaya_bracers_skirt.vmdl", context)
PrecacheResource("model", "models/heroes/hoodwink/hoodwink_hood.vmdl", context)
PrecacheResource("model", "models/heroes/luna/luna_shield.vmdl", context)

PrecacheResource("particle", "particles/bloode_ground_child.vpcf", context) 
	PrecacheResource("particle", "particles/bloody_ground.vpcf", context) 
	PrecacheResource("particle", "particles/build_place.vpcf", context) 
	PrecacheResource("particle", "particles/pulsation_ground.vpcf", context) 


	PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts",context)
    PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts",context)

	-- PrecacheResource("soundfile", "soundevents/game_sounds_birzha.vsndevts", context) 
	PrecacheResource("soundfile", "soundevents/game_sounds_birzha_new.vsndevts", context) 

    PrecacheModel("models/heroes/lycan/lycan_fur.vmdl", context)
    PrecacheModel("models/heroes/lycan/lycan_armor.vmdl", context)
    PrecacheModel("models/heroes/lycan/lycan_blades.vmdl", context)
    PrecacheModel("models/heroes/lycan/lycan_belt.vmdl", context)
    PrecacheModel("models/heroes/lycan/lycan_head.vmdl", context)

	PrecacheModel("models/heroes/crystal_maiden/crystal_maiden.vmdl", context)
    PrecacheModel("models/heroes/crystal_maiden/crystal_maiden_staff.vmdl", context)
    PrecacheModel("models/heroes/crystal_maiden/crystal_maiden_cape.vmdl", context)
    PrecacheModel("models/items/crystal_maiden/magnolia_arms/magnolia_arms.vmdl", context)
    PrecacheModel("models/heroes/crystal_maiden/crystal_maiden_shoulders.vmdl", context)
	PrecacheModel("models/items/crystal_maiden/magnolia_head/magnolia_head.vmdl", context)

    PrecacheResource("particle", "particles/units/heroes/hero_lycan/lycan_feral_impulse.vpcf", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts", context)

	PrecacheWearableModels(context)



	PrecacheLoad:PrecacheLoad (context)
	
	GameRules.pc = context
	trollnelves2().pc = context
	
end

-- Create the game mode when we activate
function Activate()
	GameRules.lumberPrice = STARTING_LUMBER_PRICE
	GameRules.lumberSell = STARTING_LUMBER_PRICE - 10
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
	GameRules.damageGiven = {}
	GameRules.damageTake = {}
	GameRules.deathTime = {}
	GameRules.scores = {}
	GameRules.Rep = {}
	GameRules.GetRep = {}
	GameRules.GetXpBP = {} 
	GameRules.isTesting = true
	GameRules.server =  "https://localhost:7133/test/" -- "https://localhost:7133/test/" -- "https://localhost:5001/test/"  --  "https://tve4.eu/test/" -- "https://tve3.us/test/"
	GameRules.BonusGem = {}
	--GameRules.xp = {}
	GameRules.types = {}
	GameRules.trollID = nil
	GameRules.trollHero = nil
	GameRules.trollID2 = nil

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
	
	GameRules:GetGameModeEntity():SetDaynightCycleAdvanceRate(1 * GameRules.MapSpeed)

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
	GameRules.PoolTable[13] = {} -- личный рейт
	GameRules.PoolTable[14] = {} -- полученные предметы в БП 
	GameRules.PoolTable[15] = {} -- куплен батлпасс  
	GameRules.PoolTable[16] = {} -- хз
        GameRules.PoolTable[17] = {} -- достижения
        GameRules.PoolTable[18] = {} -- цены на аспекты
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
        GameRules.PoolTable[14][0] = {} -- полученные предметы в БП
        GameRules.PoolTable[18][0] = {}

        GameRules.PoolTable[18][0]["0"] = {}
        GameRules.PoolTable[18][0]["1"] = {}

	
	GameRules.SkinTower = {}
    GameRules.SaveDefItem = {}

    for ids=0, 16 do
        GameRules.SkinTower[ids] = {}
        GameRules.SkinTower[ids][0] = {}

        GameRules.SaveDefItem[ids] = {}
        GameRules.SaveDefItem[ids][0] = {}

        CustomNetTables:SetTableValue("Shop_active", tostring(ids), GameRules.SkinTower[ids])
    end

	GameRules.FakeList = {}
	GameRules.trollnelves2 = trollnelves2()
	GameRules.trollnelves2:Inittrollnelves2()
	GameRules.MapName = ""

	LinkModifier:Start()
end


function PrecacheWearableModels(context)
    -- 1) Прекешируем все .vmdl из wolfModels, bearModels и elfModels
    for _, info in pairs(Wearables.wolfModels or {}) do
        PrecacheModel(info.model, context)
    end
    for _, info in pairs(Wearables.bearModels or {}) do
        PrecacheModel(info.model, context)
    end
    for _, info in pairs(Wearables.elfModels or {}) do
        PrecacheModel(info.model, context)
    end

    -- 2) Прекешируем всё из TowerSkinConfigs:
    for _, cfg in pairs(Wearables.TowerSkinConfigs or {}) do
        -- 2.1) Если есть attachments (массив путей к .vmdl)
        if cfg.attachments then
            for _, modelPath in ipairs(cfg.attachments) do
                PrecacheModel(modelPath, context)
            end
        end

        -- 2.2) Если есть поле updateModel (одна модель .vmdl)
        if cfg.updateModel and cfg.updateModel.model then
            PrecacheModel(cfg.updateModel.model, context)
        end

        -- 2.3) Если есть частицы (particles) — «прекешируем» их через PrecacheResource
        if cfg.particles then
            for _, particleInfo in ipairs(cfg.particles) do
                if particleInfo.path then
                    PrecacheResource("particle", particleInfo.path, context)
                end
            end
        end
    end

    -- 3) Прекешируем всё из wispSkinConfig:
    for _, entry in pairs(Wearables.wispSkinConfig or {}) do
        -- 3.1) Если есть простое поле model
        if entry.model then
            PrecacheModel(entry.model, context)
        end

        -- 3.2) Если есть вложенная таблица mapModels
        if entry.mapModels then
            for _, mapInfo in pairs(entry.mapModels) do
                if mapInfo.model then
                    PrecacheModel(mapInfo.model, context)
                end
            end
        end
    end
	for _, pet in pairs(Wearables.petConfigs or {}) do
        -- 5.1) одиночная или выбор из двух моделей
        if pet.model then
            PrecacheModel(pet.model, context)
        elseif pet.models then
            for _, m in ipairs(pet.models) do
                PrecacheModel(m, context)
            end
        end
        -- 5.2) матгруппы не кешируем, они не модели
        -- 5.3) эффекты (частицы)
        if pet.effect then
            PrecacheResource("particle", pet.effect, context)
        end
    end
end