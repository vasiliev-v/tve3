game_spells_lib = class({})

-- Массив существующих навыков
-- 1 - название
-- 2 - Иконка (ЭТО ДОЛЖНО БЫТЬ ДЕФОЛТНОЕ ОТОБРАЖЕНИЕ БЕЗ УРОВНЯ ПРОКАЧКИ, ЕСЛИ У ИГРОКА ЕСТЬ НАВЫК И УРОВЕНЬ, ТО ДОБАВЛЯЕТСЯ К ИКОНКЕ УЖЕ иконка_1 или иконка_2 и т.д.) (Не забудь что в js не компилятся иконки и их надо будет где-то закомпилить в xml или css)
-- 3 - Модификатор
-- 4 - Название улучшений 1-2-3
-- 5 - Цифры улучшение 
-- 6 - Эльф или Тролль.
-- 7 - Работает ли перк. 
if GameRules.MapSpeed ~= 4 then
    DebugPrint("test not x4")
    game_spells_lib.spells_list =
    {
        -----------------------
        -- Elf spells
        -----------------------
        {
            "elf_spell_solo_player", 
            "elf_spell_solo_player", 
            "modifier_elf_spell_solo_player", 
            {
                "elf_spell_solo_player_description_level_1_shop", 
                "elf_spell_solo_player_description_level_2_shop", 
            }, 
            {
                {"2","2","2"},
                {"2","5","10"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_limit_gold", 
            "elf_spell_limit_gold", 
            "modifier_elf_spell_limit_gold", 
            {
                "elf_spell_limit_gold_description_level_1_shop", 
            }, 
            {
                {"200k","400k","600k"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_limit_lumber", 
            "elf_spell_limit_lumber", 
            "modifier_elf_spell_limit_lumber", 
            {
                "elf_spell_limit_lumber_description_level_1_shop", 
            }, 
            {
                {"200k","400k","600k"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_damage_gold", 
            "elf_spell_damage_gold", 
            "modifier_elf_spell_damage_gold", 
            {
                "elf_spell_damage_gold_description_level_1_shop", 
                "elf_spell_damage_gold_description_level_2_shop", 
                "elf_spell_damage_gold_description_level_3_shop",
            }, 
            {
                {"4%","8%","15%"},
                {"30 min","30 min","30 min"},
                {"15 min","15 min","15 min"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_ms", 
            "elf_spell_ms", 
            "modifier_elf_spell_ms", 
            {
                "elf_spell_ms_description_level_1_shop",
                "elf_spell_ms_description_level_2_shop",
            },
            {
                {2,5,10},
                {2,5,10},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_tower_range", 
            "elf_spell_tower_range", 
            "modifier_elf_spell_tower_range", 
            {
                "elf_spell_tower_range_description_level_1_shop", 
            }, 
            {
                {10,20,40},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_armor_wall", 
            "elf_spell_armor_wall", 
            "modifier_elf_spell_armor_wall", 
            {
                "elf_spell_armor_wall_description_level_1_shop", 
            }, 
            {
                {"4%","8%","12%"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_tower_damage", 
            "elf_spell_tower_damage", 
            "modifier_elf_spell_tower_damage", 
            {
                "elf_spell_tower_damage_description_level_1_shop", 
            }, 
            {
                {"4%","8%","12%"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_lumber", 
            "elf_spell_lumber", 
            "modifier_elf_spell_lumber", 
            {
                "elf_spell_lumber_description_level_1_shop", 
                "elf_spell_lumber_description_level_2_shop", 
            }, 
            {
                {2,5,9},
                {"-20","-10","0"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_blink", 
            "elf_spell_blink", 
            "modifier_elf_spell_blink", 
            {
                "elf_spell_blink_description_level_1_shop", 
            }, 
            {
                {"+200","+400","+600"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_invis", 
            "elf_spell_invis", 
            "modifier_elf_spell_invis", 
            {
                "elf_spell_invis_description_level_1_shop", 
                "elf_spell_invis_description_level_2_shop", 
                "elf_spell_invis_description_level_3_shop", 
            }, 
            {
                {15.0, 30.0, 60.0},
                {"1.0", "0.8", "0.6"},
                {350, 300, 300},
                
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_haste",
            "elf_spell_haste", 
            "modifier_elf_spell_haste", 
            {
                "elf_spell_haste_description_level_1_shop", 
                "elf_spell_haste_description_level_2_shop", 
                "elf_spell_haste_description_level_3_shop", 
            }, 
            {
                {10, 20 ,50},
                {10, 20, 50},
                {350, 300, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_evasion",
            "elf_spell_evasion", 
            "modifier_elf_spell_evasion", 
            {
                "elf_spell_evasion_description_level_1_shop", 
                "elf_spell_evasion_description_level_2_shop", 
                "elf_spell_evasion_description_level_3_shop", 
            }, 
            {
                {"50%", "60%", "75%"},
                {3, 5 ,7},
                {350, 300, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_cd_reduce", 
            "elf_spell_cd_reduce", 
            "modifier_elf_spell_cd_reduce", 
            {
                "elf_spell_cd_reduce_description_level_1_shop", 
            }, 
            {
                {"-4%","-8%","-16%"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_gold", 
            "elf_spell_gold", 
            "modifier_elf_spell_gold", 
            {
                "elf_spell_gold_description_level_1_shop", 
                "elf_spell_gold_description_level_2_shop", 
            }, 
            {
                {10,15,20},
                {"-20","-10",0},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_target_buff",
            "elf_spell_target_buff", 
            "modifier_elf_spell_target_buff", 
            {
                "elf_spell_target_buff_description_level_1_shop", 
                "elf_spell_target_buff_description_level_2_shop", 
                "elf_spell_target_buff_description_level_3_shop", 
                "elf_spell_target_buff_description_level_4_shop", 
            }, 
            {
                {5, 10, 20},
                {60, 80, 120},
                {6, 8 ,12},
                {120, 100, 60},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_stun_target",
            "elf_spell_stun_target", 
            "modifier_elf_spell_stun_target", 
            {
                "elf_spell_stun_target_description_level_1_shop", 
                "elf_spell_stun_target_description_level_2_shop", 
            }, 
            {
                {1, 1.5, 2},
                {350, 300, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_teleport",
            "elf_spell_teleport", 
            "modifier_elf_spell_teleport", 
            {
                "elf_spell_teleport_description_level_1_shop", 
            }, 
            {
                {500, 400, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_target_damage",
            "elf_spell_target_damage", 
            "modifier_elf_spell_target_damage", 
            {
                "elf_spell_target_damage_description_level_1_shop", 
                "elf_spell_target_damage_description_level_2_shop", 
                "elf_spell_target_damage_description_level_3_shop", 
            }, 
            {
                {"10%", "20%", "30%"},
                {4, 5 , 6},
                {350, 300, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_cd_worker", 
            "elf_spell_cd_worker", 
            "modifier_elf_spell_cd_worker", 
            {
                "elf_spell_cd_worker_description_level_1_shop", 
            }, 
            {
                {"-30%","-50%","-75%"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_true", 
            "elf_spell_true", 
            "modifier_elf_spell_true", 
            {
                "elf_spell_true_description_level_1_shop", 
            }, 
            {
                {200, 250, 300}, 
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_reveal",
            "elf_spell_reveal", 
            "modifier_elf_spell_reveal", 
            {
                "elf_spell_reveal_description_level_1_shop", 
                "elf_spell_reveal_description_level_2_shop", 
            }, 
            {
                {30, 45, 60},
                {200, 150, 150},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_heal",
            "elf_spell_heal", 
            "modifier_elf_spell_heal", 
            {
                "elf_spell_heal_description_level_1_shop", 
                "elf_spell_heal_description_level_2_shop", 
                "elf_spell_heal_description_level_3_shop", 
                
            }, 
            {
                {1000, 2000, 3000},
                {"50%", "75%", "100%"},
                {350, 300, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },




        --[[
        {
            "elf_spell_smoke", 
            "elf_spell_smoke", 
            "modifier_elf_spell_smoke", 
            {
                "elf_spell_smoke_description_level_1_shop", 
                "elf_spell_smoke_description_level_2_shop", 
                "elf_spell_smoke_description_level_3_shop", 
                "elf_spell_smoke_description_level_4_shop", 
            }, 
            {
                {15, 30, 60},
                {30, 45, 95},
                {600, 900, 1200},
                {350, 300, 300},
                
            },
            "0",
            "1"
        },
        --]]








        -----------------------
        -- Troll spells
        -----------------------
        {
            "troll_spell_limit_gold",
            "troll_spell_limit_gold", 
            "modifier_troll_spell_limit_gold", 
            {
                "troll_spell_limit_gold_description_level_1_shop", 
            }, 
            {
                {'+200k','+300k','+400k'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_hp_reg",
            "troll_spell_hp_reg", 
            "modifier_troll_spell_hp_reg", 
            {
                "troll_spell_hp_reg_description_level_1_shop", 
            },
            {
                {2,4,8},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_armor",
            "troll_spell_armor", 
            "modifier_troll_spell_armor", 
            {
                "troll_spell_armor_description_level_1_shop", 
            }, 
            {
                {2,4,8},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_gold_hit", 
            "troll_spell_gold_hit", 
            "modifier_troll_spell_gold_hit", 
            {
                "troll_spell_gold_hit_description_level_1_shop", 
                "troll_spell_gold_hit_description_level_2_shop", 
                "troll_spell_gold_hit_description_level_3_shop", 
                "troll_spell_gold_hit_description_level_4_shop",
                
            }, 
            {
                {1,2,3},
                {"400%","400%","400%"},
                {5,10,15},
                {150,100,60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_atkspeed",
            "troll_spell_atkspeed", 
            "modifier_troll_spell_atkspeed", 
            {
                "troll_spell_atkspeed_description_level_1_shop", 
                "troll_spell_atkspeed_description_level_2_shop", 
                "troll_spell_atkspeed_description_level_3_shop", 
            }, 
            {
                {'200%','200%','200%'},
                {2,3,5},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_vision",
            "troll_spell_vision", 
            "modifier_troll_spell_vision", 
            {
                "troll_spell_vision_description_level_1_shop", 
            }, 
            {
                {150,225,300},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_ms", 
            "troll_spell_ms", 
            "modifier_troll_spell_ms", 
            {
                "troll_spell_ms_description_level_1_shop", 
            },
            {
                {15,20,25},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_cd_reduce",
            "troll_spell_cd_reduce", 
            "modifier_troll_spell_cd_reduce", 
            {
                "troll_spell_cd_reduce_description_level_1_shop", 
            }, 
            {
                {'-10%','-15%','-20%'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_magic_resist",
            "troll_spell_magic_resist", 
            "modifier_troll_spell_magic_resist", 
            {
                "troll_spell_magic_resist_description_level_1_shop", 
            }, 
            {
                {'+10%','+15%','+20%'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_status_resist",
            "troll_spell_status_resist", 
            "modifier_troll_spell_status_resist", 
            {
                "troll_spell_status_resist_description_level_1_shop", 
            }, 
            {
                {'+10%','+15%','+20%'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_haste",
            "troll_spell_haste", 
            "modifier_troll_spell_haste", 
            {
                "troll_spell_haste_description_level_1_shop", 
                "troll_spell_haste_description_level_2_shop", 
                "troll_spell_haste_description_level_3_shop", 
            }, 
            {
                {5,15,30},
                {'2%','4%','8%'},
                {1000,1000,1000},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_invis",
            "troll_spell_invis", 
            "modifier_troll_spell_invis", 
            {
                "troll_spell_invis_description_level_1_shop", 
                "troll_spell_invis_description_level_2_shop", 
            }, 
            {
                {20,40,60},
                {60,60,60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_silence_target",
            "troll_spell_silence_target", 
            "modifier_troll_spell_silence_target", 
            {
                "troll_spell_silence_target_description_level_1_shop", 
                "troll_spell_silence_target_description_level_2_shop", 
            }, 
            {
                {8,12,16},
                {250,200,150},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_stun_target",
            "troll_spell_stun_target", 
            "modifier_troll_spell_stun_target", 
            {
                "troll_spell_stun_target_description_level_1_shop", 
                "troll_spell_stun_target_description_level_2_shop", 
            }, 
            {
                {1,2,4},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_silence_area",
            "troll_spell_silence_area", 
            "modifier_troll_spell_silence_area", 
            {
                "troll_spell_silence_area_description_level_1_shop", 
                "troll_spell_silence_area_description_level_2_shop", 
            }, 
            {
                {5,8,12},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_ward",
            "troll_spell_ward", 
            "modifier_troll_spell_ward", 
            {
                "troll_spell_ward_description_level_1_shop", 
                "troll_spell_ward_description_level_2_shop", 
            }, 
            {
                {60,120,180},
                {60,60,60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_slow_target",
            "troll_spell_slow_target", 
            "modifier_troll_spell_slow_target", 
            {
                "troll_spell_slow_target_description_level_1_shop", 
                "troll_spell_slow_target_description_level_2_shop", 
                "troll_spell_slow_target_description_level_3_shop", 
            }, 
            {
                {-80,-90,-120},
                {10,15,20},
                {120,80,60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_slow_area",
            "troll_spell_slow_area", 
            "modifier_troll_spell_slow_area", 
            {
                "troll_spell_slow_area_description_level_1_shop", 
                "troll_spell_slow_area_description_level_2_shop", 
                "troll_spell_slow_area_description_level_3_shop", 
                "troll_spell_slow_area_description_level_4_shop", 
            }, 
            {
                {-50,-60,-70},
                {'-10%','-20%','-30%'},
                {2,5,10},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_wolf",
            "troll_spell_wolf", 
            "modifier_troll_spell_wolf", 
            {
                "troll_spell_wolf_description_level_1_shop",
                "troll_spell_wolf_description_level_2_shop",
                "troll_spell_wolf_description_level_3_shop",
                
            }, 
            {
                {50,100,200},
                {300,340,380},
                {300,150,60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_reveal",
            "troll_spell_reveal", 
            "modifier_troll_spell_reveal", 
            {
                "troll_spell_reveal_description_level_1_shop", 
            }, 
            {
                {'+1','+2','+3'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_night_buff",
            "troll_spell_night_buff", 
            "modifier_troll_spell_night_buff", 
            {
                "troll_spell_night_buff_description_level_1_shop", 
                "troll_spell_night_buff_description_level_2_shop", 
                "troll_spell_night_buff_description_level_3_shop", 
            }, 
            {
                {20,40,50},
                {20,40,60},
                {'1%','2%','3%'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_gold_wisp",
            "troll_spell_gold_wisp", 
            "modifier_troll_spell_gold_wisp", 
            {
                "troll_spell_gold_wisp_description_level_1_shop", 
                "troll_spell_gold_wisp_description_level_2_shop", 
                "troll_spell_gold_wisp_description_level_3_shop", 
            }, 
            {
                {128,160,192},
                {'MAX','MAX','MAX'},
                {5,10,25},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_evasion",
            "troll_spell_evasion", 
            "modifier_troll_spell_evasion", 
            {
                "troll_spell_evasion_description_level_1_shop", 
                "troll_spell_evasion_description_level_2_shop", 
            }, 
            {
                {2,3,5},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_bkb",
            "troll_spell_bkb", 
            "modifier_troll_spell_bkb", 
            {
                "troll_spell_bkb_description_level_1_shop", 
                "troll_spell_bkb_description_level_2_shop",
            }, 
            {
                {1,2,3},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        
    }
else -- X4
    DebugPrint("test x4")
    game_spells_lib.spells_list =
    {
        -----------------------
        -- Elf spells
        -----------------------
        {
            "elf_spell_solo_player", 
            "elf_spell_solo_player", 
            "modifier_elf_spell_solo_player", 
            {
                "elf_spell_solo_player_description_level_1_shop", 
                "elf_spell_solo_player_description_level_2_shop", 
            }, 
            {
                {"2","2","2"},
                {"2","5","10"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_limit_gold", 
            "elf_spell_limit_gold", 
            "modifier_elf_spell_limit_gold_x4", 
            {
                "elf_spell_limit_gold_description_level_1_shop_x4", 
            }, 
            {
                {"200k","350k","500k"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_limit_lumber", 
            "elf_spell_limit_lumber", 
            "modifier_elf_spell_limit_lumber_x4", 
            {
                "elf_spell_limit_lumber_description_level_1_shop_x4", 
            }, 
            {
                {"200k","350k","500k"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_damage_gold", 
            "elf_spell_damage_gold", 
            "modifier_elf_spell_damage_gold_x4", 
            {
                "elf_spell_damage_gold_description_level_1_shop_x4", 
                "elf_spell_damage_gold_description_level_2_shop_x4", 
            }, 
            {
                {"4%","8%","15%"},
                {"7 min","7 min","7 min"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_ms", 
            "elf_spell_ms", 
            "modifier_elf_spell_ms_x4", 
            {
                "elf_spell_ms_description_level_1_shop_x4",
                "elf_spell_ms_description_level_2_shop_x4",
            },
            {
                {5,10,15},
                {5,10,15},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_tower_range", 
            "elf_spell_tower_range", 
            "modifier_elf_spell_tower_range_x4", 
            {
                "elf_spell_tower_range_description_level_1_shop_x4", 
            }, 
            {
                {10,20,40},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_armor_wall", 
            "elf_spell_armor_wall", 
            "modifier_elf_spell_armor_wall_x4", 
            {
                "elf_spell_armor_wall_description_level_1_shop_x4", 
            }, 
            {
                {"4%","8%","12%"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_tower_damage", 
            "elf_spell_tower_damage", 
            "modifier_elf_spell_tower_damage_x4", 
            {
                "elf_spell_tower_damage_description_level_1_shop_x4", 
            }, 
            {
                {"4%","8%","12%"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },

        {
            "elf_spell_lumber", 
            "elf_spell_lumber", 
            "modifier_elf_spell_lumber_x4", 
            {
                "elf_spell_lumber_description_level_1_shop_x4", 
                "elf_spell_lumber_description_level_2_shop_x4", 
            }, 
            {
                {2,5,9},
                {"-20","-10","0"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_blink", 
            "elf_spell_blink", 
            "modifier_elf_spell_blink_x4", 
            {
                "elf_spell_blink_description_level_1_shop_x4", 
            }, 
            {
                {"+200","+400","+600"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_invis", 
            "elf_spell_invis", 
            "modifier_elf_spell_invis_x4", 
            {
                "elf_spell_invis_description_level_1_shop_x4", 
                "elf_spell_invis_description_level_2_shop_x4", 
                "elf_spell_invis_description_level_3_shop_x4", 
            }, 
            {
                {15.0, 30.0, 60.0},
                {"1.0", "0.8", "0.6"},
                {350, 300, 300},
                
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_haste",
            "elf_spell_haste", 
            "modifier_elf_spell_haste_x4", 
            {
                "elf_spell_haste_description_level_1_shop_x4", 
                "elf_spell_haste_description_level_2_shop_x4", 
                "elf_spell_haste_description_level_3_shop_x4", 
            }, 
            {
                {50, 50 ,"MAX"},
                {5, 6, 7},
                {300, 240, 180},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_evasion",
            "elf_spell_evasion", 
            "modifier_elf_spell_evasion_x4", 
            {
                "elf_spell_evasion_description_level_1_shop_x4", 
                "elf_spell_evasion_description_level_2_shop_x4", 
                "elf_spell_evasion_description_level_3_shop_x4", 
            }, 
            {
                {"30%", "45%", "60%"},
                {2, 3 ,6},
                {350, 300, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_cd_reduce", 
            "elf_spell_cd_reduce", 
            "modifier_elf_spell_cd_reduce_x4", 
            {
                "elf_spell_cd_reduce_description_level_1_shop_x4", 
            }, 
            {
                {"-5%","-7%","-10%"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_gold", 
            "elf_spell_gold", 
            "modifier_elf_spell_gold_x4", 
            {
                "elf_spell_gold_description_level_1_shop_x4", 
                "elf_spell_gold_description_level_2_shop_x4", 
            }, 
            {
                {10,15,20},
                {"-20","-10",0},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_target_buff",
            "elf_spell_target_buff", 
            "modifier_elf_spell_target_buff_x4", 
            {
                "elf_spell_target_buff_description_level_1_shop_x4", 
                "elf_spell_target_buff_description_level_2_shop_x4", 
                "elf_spell_target_buff_description_level_3_shop_x4", 
                "elf_spell_target_buff_description_level_4_shop_x4", 
            }, 
            {
                {5, 10, 20},
                {60, 80, 120},
                {6, 8 ,12},
                {120, 100, 60},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_stun_target",
            "elf_spell_stun_target", 
            "modifier_elf_spell_stun_target_x4", 
            {
                "elf_spell_stun_target_description_level_1_shop_x4", 
                "elf_spell_stun_target_description_level_2_shop_x4", 
            }, 
            {
                {1, 1.5, 2},
                {350, 300, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_teleport",
            "elf_spell_teleport", 
            "modifier_elf_spell_teleport_x4", 
            {
                "elf_spell_teleport_description_level_1_shop_x4", 
            }, 
            {
                {500, 400, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_target_damage",
            "elf_spell_target_damage", 
            "modifier_elf_spell_target_damage_x4", 
            {
                "elf_spell_target_damage_description_level_1_shop_x4", 
                "elf_spell_target_damage_description_level_2_shop_x4", 
                "elf_spell_target_damage_description_level_3_shop_x4", 
            }, 
            {
                {"8%", "10%", "15%"},
                {4, 5 , 6},
                {350, 300, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_cd_worker", 
            "elf_spell_cd_worker", 
            "modifier_elf_spell_cd_worker_x4", 
            {
                "elf_spell_cd_worker_description_level_1_shop_x4", 
            }, 
            {
                {"-10%","-20%","-25%"},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_reveal",
            "elf_spell_reveal", 
            "modifier_elf_spell_reveal_x4", 
            {
                "elf_spell_reveal_description_level_1_shop_x4", 
                "elf_spell_reveal_description_level_2_shop_x4", 
            }, 
            {
                {30, 45, 60},
                {200, 150, 150},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_true", 
            "elf_spell_true", 
            "modifier_elf_spell_true_x4", 
            {
                "elf_spell_true_description_level_1_shop_x4", 
            }, 
            {
                {200, 250, 300}, 
            },
            "0",
            "1",
            {0, 10000, 30000}
        },
        {
            "elf_spell_heal",
            "elf_spell_heal", 
            "modifier_elf_spell_heal_x4", 
            {
                "elf_spell_heal_description_level_1_shop_x4", 
                "elf_spell_heal_description_level_2_shop_x4", 
                "elf_spell_heal_description_level_3_shop_x4", 
                
            }, 
            {
                {1000, 2000, 3000},
                {"50%", "75%", "100%"},
                {350, 300, 300},
            },
            "0",
            "1",
            {0, 10000, 30000}
        },


       --[[
        {
            "elf_spell_smoke", 
            "elf_spell_smoke", 
            "modifier_elf_spell_smoke_x4", 
            {
                "elf_spell_smoke_description_level_1_shop_x4", 
                "elf_spell_smoke_description_level_2_shop_x4", 
                "elf_spell_smoke_description_level_3_shop_x4", 
                "elf_spell_smoke_description_level_3_shop_x4", 
            }, 
            {
                {15, 30, 60},
                {30, 45, 95},
                {600, 900, 1200},
                {350, 300, 300},
                
            },
            "0",
            "1"
        },
        --]]


        -----------------------
        -- Troll spells  X4
        -----------------------
        {
            "troll_spell_limit_gold",
            "troll_spell_limit_gold", 
            "modifier_troll_spell_limit_gold_x4", 
            {
                "troll_spell_limit_gold_description_level_1_shop_x4", 
            }, 
            {
                {'+200k','+350k','+500k'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_hp_reg",
            "troll_spell_hp_reg", 
            "modifier_troll_spell_hp_reg_x4", 
            {
                "troll_spell_hp_reg_description_level_1_shop_x4", 
            },
            {
                {2,4,8},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_armor",
            "troll_spell_armor", 
            "modifier_troll_spell_armor_x4", 
            {
                "troll_spell_armor_description_level_1_shop_x4", 
            }, 
            {
                {2,4,8},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_gold_hit", 
            "troll_spell_gold_hit", 
            "modifier_troll_spell_gold_hit_x4", 
            {
                "troll_spell_gold_hit_description_level_1_shop_x4", 
                "troll_spell_gold_hit_description_level_2_shop_x4", 
                "troll_spell_gold_hit_description_level_3_shop_x4", 
                "troll_spell_gold_hit_description_level_4_shop_x4",
                
            }, 
            {
                {1,2,3},
                {"400%","400%","400%"},
                {5,10,15},
                {150,100,60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_atkspeed",
            "troll_spell_atkspeed", 
            "modifier_troll_spell_atkspeed_x4", 
            {
                "troll_spell_atkspeed_description_level_1_shop_x4", 
                "troll_spell_atkspeed_description_level_2_shop_x4", 
                "troll_spell_atkspeed_description_level_3_shop_x4", 
            }, 
            {
                {'200%','200%','200%'},
                {2,3,5},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_vision",
            "troll_spell_vision", 
            "modifier_troll_spell_vision_x4", 
            {
                "troll_spell_vision_description_level_1_shop_x4", 
            }, 
            {
                {150,225,300},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_ms", 
            "troll_spell_ms", 
            "modifier_troll_spell_ms_x4", 
            {
                "troll_spell_ms_description_level_1_shop_x4", 
            },
            {
                {15,20,25},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_cd_reduce",
            "troll_spell_cd_reduce", 
            "modifier_troll_spell_cd_reduce_x4", 
            {
                "troll_spell_cd_reduce_description_level_1_shop_x4", 
            }, 
            {
                {'-7%','-10%','-15%'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_magic_resist",
            "troll_spell_magic_resist", 
            "modifier_troll_spell_magic_resist_x4", 
            {
                "troll_spell_magic_resist_description_level_1_shop_x4", 
            }, 
            {
                {'+10%','+15%','+20%'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_status_resist",
            "troll_spell_status_resist", 
            "modifier_troll_spell_status_resist_x4", 
            {
                "troll_spell_status_resist_description_level_1_shop_x4", 
            }, 
            {
                {'+10%','+15%','+20%'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_haste",
            "troll_spell_haste", 
            "modifier_troll_spell_haste_x4", 
            {
                "troll_spell_haste_description_level_1_shop_x4", 
                "troll_spell_haste_description_level_2_shop_x4", 
                "troll_spell_haste_description_level_3_shop_x4", 
            }, 
            {
                {5,15,30},
                {'2%','4%','8%'},
                {1000,1000,1000},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_invis",
            "troll_spell_invis", 
            "modifier_troll_spell_invis_x4", 
            {
                "troll_spell_invis_description_level_1_shop_x4", 
                "troll_spell_invis_description_level_2_shop_x4", 
            }, 
            {
                {20,40,60},
                {60,60,60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_silence_target",
            "troll_spell_silence_target", 
            "modifier_troll_spell_silence_target_x4", 
            {
                "troll_spell_silence_target_description_level_1_shop_x4", 
                "troll_spell_silence_target_description_level_2_shop_x4", 
            }, 
            {
                {7,8,9},
                {250,200,150},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_stun_target",
            "troll_spell_stun_target", 
            "modifier_troll_spell_stun_target_x4", 
            {
                "troll_spell_stun_target_description_level_1_shop_x4", 
                "troll_spell_stun_target_description_level_2_shop_x4", 
            }, 
            {
                {1,2,3},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_silence_area",
            "troll_spell_silence_area", 
            "modifier_troll_spell_silence_area_x4", 
            {
                "troll_spell_silence_area_description_level_1_shop_x4", 
                "troll_spell_silence_area_description_level_2_shop_x4", 
            }, 
            {
                {5,8,12},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_ward",
            "troll_spell_ward", 
            "modifier_troll_spell_ward_x4", 
            {
                "troll_spell_ward_description_level_1_shop_x4", 
                "troll_spell_ward_description_level_2_shop_x4", 
            }, 
            {
                {60,120,180},
                {60,60,60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_slow_target",
            "troll_spell_slow_target", 
            "modifier_troll_spell_slow_target_x4", 
            {
                "troll_spell_slow_target_description_level_1_shop_x4", 
                "troll_spell_slow_target_description_level_2_shop_x4", 
                "troll_spell_slow_target_description_level_3_shop_x4", 
            }, 
            {
                {-80,-90,-120},
                {10,15,20},
                {120,80,60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_slow_area",
            "troll_spell_slow_area", 
            "modifier_troll_spell_slow_area_x4", 
            {
                "troll_spell_slow_area_description_level_1_shop_x4", 
                "troll_spell_slow_area_description_level_2_shop_x4", 
                "troll_spell_slow_area_description_level_3_shop_x4", 
                "troll_spell_slow_area_description_level_3_shop_x4", 
            }, 
            {
                {-50,-60,-70},
                {'-10%','-20%','-30%'},
                {2,5,10},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_wolf",
            "troll_spell_wolf", 
            "modifier_troll_spell_wolf_x4", 
            {
                "troll_spell_wolf_description_level_1_shop_x4",
                "troll_spell_wolf_description_level_2_shop_x4",
                "troll_spell_wolf_description_level_3_shop_x4",
                
            }, 
            {
                {50,100,200},
                {300,340,380},
                {180,120,60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_reveal",
            "troll_spell_reveal", 
            "modifier_troll_spell_reveal_x4", 
            {
                "troll_spell_reveal_description_level_1_shop_x4", 
            }, 
            {
                {'+1','+2','+3'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_night_buff",
            "troll_spell_night_buff", 
            "modifier_troll_spell_night_buff_x4", 
            {
                "troll_spell_night_buff_description_level_1_shop_x4", 
                "troll_spell_night_buff_description_level_2_shop_x4", 
                "troll_spell_night_buff_description_level_3_shop_x4", 
            }, 
            {
                {20,40,50},
                {20,40,60},
                {'1%','2%','3%'},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_gold_wisp",
            "troll_spell_gold_wisp", 
            "modifier_troll_spell_gold_wisp_x4", 
            {
                "troll_spell_gold_wisp_description_level_1_shop_x4", 
                "troll_spell_gold_wisp_description_level_2_shop_x4", 
                "troll_spell_gold_wisp_description_level_3_shop_x4", 
            }, 
            {
                {128,160,192},
                {'MAX','MAX','MAX'},
                {5,10,25},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_evasion",
            "troll_spell_evasion", 
            "modifier_troll_spell_evasion_x4", 
            {
                "troll_spell_evasion_description_level_1_shop_x4", 
                "troll_spell_evasion_description_level_2_shop_x4", 
            }, 
            {
                {2,3,5},
                {300,250,200},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },
        {
            "troll_spell_bkb",
            "troll_spell_bkb", 
            "modifier_troll_spell_bkb_x4", 
            {
                "troll_spell_bkb_description_level_1_shop_x4", 
                "troll_spell_bkb_description_level_2_shop_x4",
            }, 
            {
                {1,2,3},
                {300,240,180},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },

    }     
end








-- Я пока хуй знает как тебе это переписать, но лучше я сделаю все напримере такого массива, а ты поправишь потом
game_spells_lib.PLAYER_INFO =
{
    [0] = 
    {
        spell_buying = {}, -- Будет хранение {"название", уровень}
        coins = 0,
    },
}

game_spells_lib.current_activated_spell = {}
game_spells_lib.spells_cost_random = 500
game_spells_lib.SPELL_MAX_TIME_TO_ACTIVE = 1
if not GameRules:IsCheatMode() and not GameRules.isTesting then
    game_spells_lib.spells_cost_random = -2
    --game_spells_lib.SPELL_MAX_TIME_TO_ACTIVE = 999 -- в минутах до скольки можно поставить навык
     
    for idx, spell in ipairs(game_spells_lib.spells_list) do
        spell[8] = {0, -3, -4}
    end

end


CustomNetTables:SetTableValue("game_spells_lib", "spell_list", game_spells_lib.spells_list)
CustomNetTables:SetTableValue("game_spells_lib", "spell_cost", {cost = game_spells_lib.spells_cost_random})
CustomNetTables:SetTableValue("game_spells_lib", "spell_active", game_spells_lib.current_activated_spell)

-- ТЕСТОВАЯ ТАБЛИЦА ДАННЫХ ИГРОКА
--CustomNetTables:SetTableValue("game_spells_lib", tostring(0), game_spells_lib.PLAYER_INFO[0])

function game_spells_lib:event_set_activate_spell(data)
    if GetMapName() == "1x1" then
        return
    end
    if data.PlayerID == nil then return end
    local player_id = data.PlayerID
    local hero = PlayerResource:GetSelectedHeroEntity(player_id)
    
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        if hero == nil then return end
    end

    local modifier_name = data.modifier_name
    local spell_name = data.spell_name
    local player_team = PlayerResource:GetTeam(player_id)
    -- Проверка, есть ли навык у игрока вообще
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    local havePerk = false
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        if spell_name == game_spells_lib.PLAYER_INFO[player_id][tostring(i)][tostring(1)] then
            havePerk = true
            break
        end
    end
    if not havePerk then return end

    -- Проверки на сторону и активность перка
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        for _, spell_history in pairs(game_spells_lib.spells_list) do
            if spell_history[1] == spell_name then
                if tonumber(spell_history[6]) == 0 and player_team ~= 2 and not hero:IsElf() then return end
                if tonumber(spell_history[6]) == 1 and player_team ~= 3 and not hero:IsTroll() then return end
                if tonumber(spell_history[7]) ~= 1 then return end
            end
        end
    end

    -- Создание таблицы, если нет
    if game_spells_lib.current_activated_spell[player_id] == nil then
        game_spells_lib.current_activated_spell[player_id] = {}
    end

    -- Проверка времени
    --if (GameRules:GetGameTime() / 60) >= game_spells_lib.SPELL_MAX_TIME_TO_ACTIVE then
    --    return
    --end
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP and not GameRules:IsCheatMode() then
        SendErrorMessage(player_id, "error_cant_take_aspect")
        return
    end
    local was_solo_before = game_spells_lib:HasSoloPerk(player_id)
    local is_solo_now = (spell_name == "elf_spell_solo_player")

    -- Если уже активен, то снимаем
    if game_spells_lib:FindCurrentSpellPlayer(player_id, spell_name) then
        game_spells_lib:RemovePlayerSpell(player_id, spell_name, modifier_name, hero)
    else
        -- Определяем лимит
        local max_allowed = 1
        if was_solo_before or is_solo_now or player_team == 3 or GameRules:IsCheatMode() then
            max_allowed = 3
        end

        -- Удаляем старый, если превышает лимит
        if #game_spells_lib.current_activated_spell[player_id] >= max_allowed then
            game_spells_lib:RemoveOldSpell(player_id, hero)
        end

        -- Добавляем новый
        game_spells_lib:AddPlayerSpell(player_id, spell_name, modifier_name, hero)
    end

    -- Обновляем отображение
    local result = {}
    for pid, list in pairs(game_spells_lib.current_activated_spell) do
        result[tostring(pid)] = {}
        for i = 1, #list do
            result[tostring(pid)][tostring(i)] = list[i]
        end
    end
    CustomNetTables:SetTableValue("game_spells_lib", "spell_active", result)
end


function game_spells_lib:GetSpellLevel(player_id, spell_name)
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        if spell_name == game_spells_lib.PLAYER_INFO[player_id][tostring(i)][tostring(1)] then
            return tonumber(game_spells_lib.PLAYER_INFO[player_id][tostring(i)][tostring(2)])
        end
    end
    return 0
end

function GetTableLng(tbl)
    local getN = 0
    for n in pairs(tbl) do 
      getN = getN + 1 
    end
    return getN
  end

function game_spells_lib:FindCurrentSpellPlayer(id, spell_name)
    if game_spells_lib.current_activated_spell[id] == nil then
        game_spells_lib.current_activated_spell[id] = {}
    end
    for _, spell in pairs(game_spells_lib.current_activated_spell[id]) do
        if spell == spell_name then
            return true
        end
    end
    return false
end

function game_spells_lib:RemovePlayerSpell(id, spell_name, modifier_name, hero)
    if game_spells_lib.current_activated_spell[id] == nil then
        game_spells_lib.current_activated_spell[id] = {}
    end

    local was_solo = false
    -- удаляем сам спелл
    for i = #game_spells_lib.current_activated_spell[id], 1, -1 do
        if game_spells_lib.current_activated_spell[id][i] == spell_name then
            table.remove(game_spells_lib.current_activated_spell[id], i)
            if spell_name == "elf_spell_solo_player" then
                was_solo = true
            end
            if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
                hero:RemoveModifierByName(modifier_name)
            end
            break
        end
    end

    -- если это solo и игрок не на BADGUYS (тролях), то оставляем только один последний перк
    local player_team = PlayerResource:GetTeam(id)
    if was_solo and player_team ~= DOTA_TEAM_BADGUYS then
        local last = game_spells_lib.current_activated_spell[id][#game_spells_lib.current_activated_spell[id]]
        game_spells_lib.current_activated_spell[id] = {}
        if last ~= nil then
            table.insert(game_spells_lib.current_activated_spell[id], last)
        end
    end
end


function game_spells_lib:AddPlayerSpell(id, spell_name, modifier_name, hero)
    if game_spells_lib.current_activated_spell[id] == nil then
        game_spells_lib.current_activated_spell[id] = {}
    end
    table.insert(game_spells_lib.current_activated_spell[id], spell_name)
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then return end
    local spell_mod = hero:AddNewModifier(hero, nil, modifier_name, {}):SetStackCount(game_spells_lib:GetSpellLevel(id, spell_name))
    if spell_mod then
        spell_mod:SetStackCount(game_spells_lib:GetSpellLevel(id, spell_name))
    end
end

function game_spells_lib:RemoveOldSpell(id, hero)
    if game_spells_lib.current_activated_spell[id] == nil then
        game_spells_lib.current_activated_spell[id] = {}
    end
    if game_spells_lib.current_activated_spell[id][1] ~= nil then
        local spell_name = table.remove(game_spells_lib.current_activated_spell[id], 1)
        if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then return end
        local modifier_name = game_spells_lib:FindModifierFromSpellName(spell_name)
        hero:RemoveModifierByName(modifier_name)
    end
end

function game_spells_lib:FindModifierFromSpellName(spell_name)
    for _, list in pairs(game_spells_lib.spells_list) do
        if list[1] == spell_name then
            return list[3]
        end
    end
    return nil
end

function game_spells_lib:event_buy_spell(data)
    if data.PlayerID == nil then return end
    local player_id = data.PlayerID
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    if game_spells_lib.PLAYER_INFO[player_id] == nil then
        return
    end
    local player = PlayerResource:GetPlayer( player_id )
    if player == nil then return end
    if data.idPerk ~= 0 and data.idPerk ~= 1 then
        return
    end
    local coint = CustomNetTables:GetTableValue("Shop", tostring(player_id))["0"]["1"]
    -- Минус деньги
    local cost = game_spells_lib.spells_cost_random
    if tonumber(coint) < cost then
        -- Ошибка, на всякий случай, но я энивей отключаю кнопку покупки (для арбузеров ебаных)
        print("Нет денег")
        return
    end
    local find_new_spell = game_spells_lib:FindNewSpell(player_id, data.idPerk) -- Находим случайный навык, которго нет у игрока, если таких нет то дальше будем искать на апгрейд
    local drop_info
    if find_new_spell then
        drop_info = game_spells_lib:PlayerDropNewSpell(find_new_spell, player_id)
        CustomGameEventManager:Send_ServerToPlayer( player, 'event_spell_shop_drop', {spell_name = find_new_spell} )
    else
        drop_info = game_spells_lib:PlayerUpgradeSpell(player_id, data.idPerk)
        if drop_info ~= nil and (drop_info[2] > 0 and drop_info[2] < 4) then
            CustomGameEventManager:Send_ServerToPlayer( player, 'event_spell_shop_drop', {spell_name = drop_info[1], upgrade = drop_info[2]} )
        end
    end
    DebugPrintTable(drop_info)
    if drop_info ~= nil and drop_info[2] < 4 and drop_info[2] > 0 then
        local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(player_id))
        local dataShop = {}
        if drop_info[4] == nil then
            PoolTable["12"][tostring(GetTableLng(PoolTable["12"]))] = drop_info   
        elseif drop_info[2] > 0 and drop_info[2] < 4 then
            PoolTable["12"][tostring(drop_info[4])] = drop_info 
        end
        CustomNetTables:SetTableValue("Shop", tostring(player_id), PoolTable)
        game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))[12]
        if not GameRules:IsCheatMode() and not GameRules.isTesting then
            dataShop.SteamID = tostring(PlayerResource:GetSteamID(player_id))
            dataShop.Num = tostring(drop_info[1])
            dataShop.Score = tostring(drop_info[2])
            dataShop.Nick = "skill"
            dataShop.Coint = tostring(cost)
            dataShop.TypeDonate = "gem"
            dataShop.PlayerID = player_id
            Shop.GetSkill(dataShop, callback)
        end
        game_spells_lib:UpdatePlayerSpellCosts(player_id)
    end

end

function game_spells_lib:PlayerDropNewSpell(find_new_spell, player_id)
    if game_spells_lib.PLAYER_INFO[player_id] == nil then
        return
    end
    local drop_info = 
    {
        find_new_spell, 1, nil, nil
    }
    CustomNetTables:SetTableValue("game_spells_lib", tostring(player_id), game_spells_lib.PLAYER_INFO[player_id])
    return drop_info
end

function game_spells_lib:PlayerUpgradeSpell(player_id, idPerk)
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    if game_spells_lib.PLAYER_INFO[player_id] == nil then
        return
    end
    
    local upgrade_info = {}
    local find_random_to_upgrade = {}
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        --DebugPrintTable(game_spells_lib.PLAYER_INFO[player_id][tostring(i)])
        --DebugPrint(game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"])
        if tonumber(game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"]) < 2 then
            for _, spell_history in pairs(game_spells_lib.spells_list) do
                if spell_history[1] == game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"] and tonumber(spell_history[6]) == idPerk then
                    table.insert(find_random_to_upgrade, game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"])
                end
            end
        end
    end
    --DebugPrintTable(find_random_to_upgrade)
    if #find_random_to_upgrade <= 0 then
        for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
            if tonumber(game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"]) < 3 then
                for _, spell_history in pairs(game_spells_lib.spells_list) do
                    if spell_history[1] == game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"] and tonumber(spell_history[6]) == idPerk then
                        table.insert(find_random_to_upgrade, game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"])
                    end
                end
            end
        end
    end
    --Рандом выбор 
    --local random_upgrade = find_random_to_upgrade[RandomInt(1, #find_random_to_upgrade)]

    --Первый найденный 
    local random_upgrade = find_random_to_upgrade[1]
    if random_upgrade then
        for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
            if game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"] == random_upgrade then
                game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"] = tonumber(game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"])  + 1
                table.insert(upgrade_info, game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"])
                table.insert(upgrade_info, game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["2"])
                table.insert(upgrade_info, 0)
                table.insert(upgrade_info, i)
                break
            end
        end
        CustomNetTables:SetTableValue("game_spells_lib", tostring(player_id), game_spells_lib.PLAYER_INFO[player_id])
        return upgrade_info
    end
end

function game_spells_lib:FindNewSpell(player_id, idPerk)
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    if game_spells_lib.PLAYER_INFO[player_id] == nil then
        return
    end
    local random_spells = {}
    for _, spell_history in pairs(game_spells_lib.spells_list) do
        if tonumber(spell_history[6]) == idPerk then
            table.insert(random_spells, spell_history)
        end
    end
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        for y=#random_spells, 1, -1 do
            if random_spells[y][1] == game_spells_lib.PLAYER_INFO[player_id][tostring(i)]["1"] then
                table.remove(random_spells, y)
            end
        end
    end
    if #random_spells > 0 then
      --Выбор первого скилла. 
      return random_spells[1][1]

      --Рандом выбор. 
      --return random_spells[RandomInt(1, #random_spells)][1]
    end
    return nil
end


function game_spells_lib:GetSpellCost(player_id, spell_name, level)
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    local player_spells = game_spells_lib.PLAYER_INFO[player_id]
    if not player_spells then return 0 end

    local target_index = nil
    local current_level = 0
    for i = 1, GetTableLng(player_spells) - 1 do
        local info = player_spells[tostring(i)]

        if info and info["1"] == spell_name then
            target_index = i
            current_level = tonumber(info[2]) or 0
            break
        end
    end

    if not target_index then return 0 end

    local required_level = level or (current_level + 1)
    if required_level > 3 then return 0 end

    local need_count = 0
    for i = 1, target_index - 1 do
        local info = player_spells[tostring(i)]
        local lvl = tonumber(info and info["2"]) or 0

        if lvl < required_level then
            need_count = need_count + (required_level - lvl)
        end
    end

    local cost = need_count * 500 * 0.5
    if cost < 500 then
        cost = 500
    end
    return cost

end

function game_spells_lib:UpdatePlayerSpellCosts(player_id)
    local shop = CustomNetTables:GetTableValue("Shop", tostring(player_id))
    if not shop then return end
    local spells = shop["12"]
    if not spells then return end

    GameRules.PoolTable[18][player_id] = GameRules.PoolTable[18][player_id] or {}
    local cost_table = GameRules.PoolTable[18][player_id]

    cost_table["0"] = cost_table["0"] or {}
    cost_table["1"] = cost_table["1"] or {}

    for i = 1, GetTableLng(spells) - 1 do
        local info = spells[tostring(i)]
        if info then
            local level = tonumber(info["2"]) or 0
            local cost = self:GetSpellCost(player_id, info["1"], level + 1)
            local side = tostring(game_spells_lib.spells_list[i] and game_spells_lib.spells_list[i][6] or "0")
            cost_table[side][tostring(i)] = cost
        end
    end

    shop["18"] = cost_table
    CustomNetTables:SetTableValue("Shop", tostring(player_id), shop)
end

function game_spells_lib:PlayerUpgradeSpellSelected(player_id, spell_name)
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    if game_spells_lib.PLAYER_INFO[player_id] == nil then return nil end
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        local info = game_spells_lib.PLAYER_INFO[player_id][tostring(i)]
        if info["1"] == spell_name then
            local current = tonumber(info["2"])
            if current >= 3 then return nil end
            info["2"] = current + 1
            local result = {spell_name, info["2"], 0, i}
            CustomNetTables:SetTableValue("game_spells_lib", tostring(player_id), game_spells_lib.PLAYER_INFO[player_id])
            return result
        end
    end
    return nil
end

function game_spells_lib:event_upgrade_spell(data)
    if not data.PlayerID or not data.spell_name then return end
    local player_id = data.PlayerID
    local spell_name = data.spell_name
    local player = PlayerResource:GetPlayer( player_id )
    local level = game_spells_lib:GetSpellLevel(player_id, spell_name)
    if level >= 3 then return end
  
    local cost = game_spells_lib:GetSpellCost(player_id, spell_name, level + 1)
    local coins = tonumber(CustomNetTables:GetTableValue("Shop", tostring(player_id))["0"]["1"])
   
    local upgrade_info = game_spells_lib:PlayerUpgradeSpellSelected(player_id, spell_name)

    if upgrade_info then

        local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(player_id))
        PoolTable["12"][tostring(upgrade_info[4])] = upgrade_info
        CustomNetTables:SetTableValue("Shop", tostring(player_id), PoolTable)
        game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))[12]
        local dataShop = {
            SteamID = tostring(PlayerResource:GetSteamID(player_id)),
            Num = tostring(upgrade_info[1]),
            Score = tostring(upgrade_info[2]),
            Nick = "skill_upgrade",
            Coint = tostring(cost),
            TypeDonate = "gem",
            PlayerID = player_id,
        }
        CustomGameEventManager:Send_ServerToPlayer( player, 'event_spell_shop_drop', {spell_name = spell_name, upgrade = level + 1} )
        if not GameRules:IsCheatMode() then
            Shop.GetSkill(dataShop, callback)
        end
        game_spells_lib:UpdatePlayerSpellCosts(player_id)
    end
end


function game_spells_lib:SetSpellPlayers(id)
    if string.match(GetMapName(),"1x1") then
        return
    end
     
    local team = PlayerResource:GetTeam(id)
    local active = game_spells_lib.current_activated_spell[id] or {}
    local team = PlayerResource:GetTeam(id)

    local hero = PlayerResource:GetSelectedHeroEntity(id)
    if not hero then
        Timers:CreateTimer(4, function()
            game_spells_lib:SetSpellPlayers(id)
        end)
		return
	end
    -- Удаляем все перки, которые не соответствуют команде, расе или выключены
    if hero then
    -- Проходим по всем выбранным перкам игрока
        for i = #active, 1, -1 do
            local spell_name = active[i]

            -- Ищем информацию об этом перке в общем списке
            for _, spell_info in ipairs(game_spells_lib.spells_list) do
                local name_in_list = spell_info[1]
                if name_in_list == spell_name then

                    local spell_team = tonumber(spell_info[6])  -- 0 - эльфы, 1 - тролли
                    local is_enabled = tonumber(spell_info[7]) == 1

                    local is_valid = false

                    -- Проверка условий: включен ли перк и подходит ли игрок по расе и команде
                    if is_enabled then
                        if spell_team == 0 and team == DOTA_TEAM_GOODGUYS and hero:IsElf() then
                            is_valid = true
                        elseif spell_team == 1 and team == DOTA_TEAM_BADGUYS and hero:IsTroll() then
                            is_valid = true
                        end
                    end

                    -- Если перк не подходит, удаляем его
                    if not is_valid then
                        table.remove(active, i)
                    end
                end
            end
        end
    end


    -- GOOD GUYS: DOTA_TEAM_GOODGUYS
    if team == DOTA_TEAM_GOODGUYS then
        if #active == 0 then
            -- нет перков: даём 1 случайный, но не elf_spell_solo_player
            local candidates = {}
            for _, info in ipairs(game_spells_lib.spells_list) do
                local spell_name = info[1]
                local allowed_team = info[6]     -- "0" — good guys
                local enabled      = info[7] == "1"
                if allowed_team == "0" and enabled and spell_name ~= "elf_spell_solo_player" then
                    table.insert(candidates, spell_name)
                end
            end
            if #candidates > 0 then
                active[1] = candidates[RandomInt(1, #candidates)]
            end
        else
            -- есть перки, но нет solo-перка: добавляем последний в списке
            local has_solo = false
            for _, name in ipairs(active) do
                if name == "elf_spell_solo_player" then has_solo = true break end
            end
            if not has_solo and #active > 0 then
            -- запоминаем последнюю запись
            local last_selected = active[#active]
                -- очищаем текущий список active
                for i = #active, 1, -1 do
                    table.remove(active, i)
                end
            -- сохраняем только последний выбранный перк
            table.insert(active, last_selected)
            end
        end
    -- BAD GUYS: DOTA_TEAM_BADGUYS
    elseif team == DOTA_TEAM_BADGUYS then
        if #active == 0 then
            -- нет перков: даём 3 случайных для bad guys
            local candidates = {}
            for _, info in ipairs(game_spells_lib.spells_list) do
                local spell_name  = info[1]
                local allowed_team = info[6]   -- "1" — bad guys
                local enabled      = info[7] == "1"
                if allowed_team == "1" and enabled then
                    table.insert(candidates, spell_name)
                end
            end
            -- выбираем без повторов
            local picked = {}
            while #picked < 3 and #candidates > 0 do
                local idx = RandomInt(1, #candidates)
                table.insert(picked, candidates[idx])
                table.remove(candidates, idx)
            end
            for i, name in ipairs(picked) do
                active[i] = name
            end
        end
    end

    -- Сохраняем обновлённый список, если он был пустым или мы его дополнили
    game_spells_lib.current_activated_spell[id] = active
    -- Наконец, выдаём перки герою
    if #active > 0 then
        local hero = PlayerResource:GetSelectedHeroEntity(id)
        if hero then
            for _, spell_name in ipairs(active) do
                local modifier_name = game_spells_lib:FindModifierFromSpellName(spell_name)
                local level = game_spells_lib:GetSpellLevel(id, spell_name)
                if not hero:HasModifier(modifier_name) then
                    local mod = hero:AddNewModifier(hero, nil, modifier_name, {})
                    if mod then
                        mod:SetStackCount(level)
                    end
                end
            end
        end
    end

    CustomNetTables:SetTableValue("game_spells_lib", "spell_active", game_spells_lib.current_activated_spell)

end


function game_spells_lib:HasSoloPerk(id)
    if game_spells_lib.current_activated_spell[id] == nil then
        return false
    end
    for _, s in pairs(game_spells_lib.current_activated_spell[id]) do
        if s == "elf_spell_solo_player" then
            return true
        end
    end
    return false
end
