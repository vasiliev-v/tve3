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
            "1"
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
            "1"
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
                {2,2,2},
                {"-30","-20","-10"},
            },
            "0",
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
        },
        {
            "elf_spell_true", 
            "elf_spell_true", 
            "modifier_elf_spell_true", 
            {
                "elf_spell_true_description_level_1_shop", 
            }, 
            {
                {200, 400, 600},   
            },
            "0",
            "1"
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
            "1"
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
            "1"
        },
        {
            "elf_spell_damage_gold", 
            "elf_spell_damage_gold", 
            "modifier_elf_spell_damage_gold", 
            {
                "elf_spell_damage_gold_description_level_1_shop", 
                "elf_spell_damage_gold_description_level_2_shop", 
                "elf_spell_damage_gold_description_level_3_shop", 
                "elf_spell_damage_gold_description_level_4_shop", 
            }, 
            {
                {"4%","8%","15%"},
                {"30 min","30 min","30 min"},
                {"15 min","15 min","15 min"},
                {"5 min","5 min","5 min"},
            },
            "0",
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
        },
        -----------------------
        -- Troll spells
        -----------------------
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
            "1"
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
                {400,400,400},
                {5,10,15},
                {150,100,60},
            },
            "1",
            "1"
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
            "1"
        },
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
                {10,16,24},
                {250,200,150},
            },
            "1",
            "1"
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
            "1"
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
            "1"
        },
        {
            "troll_spell_haste",
            "troll_spell_haste", 
            "modifier_troll_spell_haste", 
            {
                "troll_spell_haste_description_level_1_shop", 
                "troll_spell_haste_description_level_2_shop", 
            }, 
            {
                {5,15,30},
                {'2%','4%','8%'},
            },
            "1",
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
                {2,2,2},
                {"-30","-20","-10"},
            },
            "0",
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
        },
        {
            "elf_spell_true", 
            "elf_spell_true", 
            "modifier_elf_spell_true_x4", 
            {
                "elf_spell_true_description_level_1_shop_x4", 
            }, 
            {
                {200, 300, 400},   
            },
            "0",
            "1"
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
            "1"
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
            "1"
        },
        {
            "elf_spell_damage_gold", 
            "elf_spell_damage_gold", 
            "modifier_elf_spell_damage_gold_x4", 
            {
                "elf_spell_damage_gold_description_level_1_shop_x4", 
                "elf_spell_damage_gold_description_level_2_shop_x4", 
                "elf_spell_damage_gold_description_level_3_shop_x4", 
                "elf_spell_damage_gold_description_level_3_shop_x4", 
            }, 
            {
                {"4%","8%","15%"},
                {"30 min","30 min","30 min"},
                {"15 min","15 min","15 min"},
                {"5 min","5 min","5 min"},
            },
            "0",
            "1"
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
            "1"
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
            "1"
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
            "1"
        },
        {
            "elf_spell_target_buff",
            "elf_spell_target_buff", 
            "modifier_elf_spell_target_buff_x4", 
            {
                "elf_spell_target_buff_description_level_1_shop_x4", 
                "elf_spell_target_buff_description_level_2_shop_x4", 
                "elf_spell_target_buff_description_level_3_shop_x4", 
                "elf_spell_target_buff_description_level_3_shop_x4", 
            }, 
            {
                {5, 10, 20},
                {60, 80, 120},
                {6, 8 ,12},
                {120, 100, 60},
            },
            "0",
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
        },
        -----------------------
        -- Troll spells  X4
        -----------------------
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
            "1"
        },
        {
            "troll_spell_gold_hit", 
            "troll_spell_gold_hit", 
            "modifier_troll_spell_gold_hit_x4", 
            {
                "troll_spell_gold_hit_description_level_1_shop_x4", 
                "troll_spell_gold_hit_description_level_2_shop_x4", 
                "troll_spell_gold_hit_description_level_3_shop_x4", 
                "troll_spell_gold_hit_description_level_3_shop_x4",
                
            }, 
            {
                {1,2,3},
                {400,400,400},
                {5,10,15},
                {150,100,60},
            },
            "1",
            "1"
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
            "1"
        },
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
        },
        {
            "troll_spell_haste",
            "troll_spell_haste", 
            "modifier_troll_spell_haste_x4", 
            {
                "troll_spell_haste_description_level_1_shop_x4", 
                "troll_spell_haste_description_level_2_shop_x4", 
            }, 
            {
                {5,15,30},
                {'2%','4%','8%'},
            },
            "1",
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
            "1"
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
if GameRules:IsCheatMode() then
    game_spells_lib.spells_cost_random = -2
end
game_spells_lib.SPELL_MAX_TIME_TO_ACTIVE = 999 -- в минутах до скольки можно поставить навык

CustomNetTables:SetTableValue("game_spells_lib", "spell_list", game_spells_lib.spells_list)
CustomNetTables:SetTableValue("game_spells_lib", "spell_cost", {cost = game_spells_lib.spells_cost_random})
CustomNetTables:SetTableValue("game_spells_lib", "spell_active", game_spells_lib.current_activated_spell)

-- ТЕСТОВАЯ ТАБЛИЦА ДАННЫХ ИГРОКА
--CustomNetTables:SetTableValue("game_spells_lib", tostring(0), game_spells_lib.PLAYER_INFO[0])

function game_spells_lib:event_set_activate_spell(data)
    if data.PlayerID == nil then return end
    local player_id = data.PlayerID
    local hero = PlayerResource:GetSelectedHeroEntity(player_id)
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        if hero == nil then return end
    end
    local modifier_name = data.modifier_name
    local spell_name = data.spell_name
    local havePerk = false
    game_spells_lib.PLAYER_INFO[player_id] = CustomNetTables:GetTableValue("Shop", tostring(player_id))["12"]
    for i=1,GetTableLng(game_spells_lib.PLAYER_INFO[player_id])-1 do
        if spell_name == game_spells_lib.PLAYER_INFO[player_id][tostring(i)][tostring(1)] then
            havePerk = true
            break
        end
    end
    if not havePerk then
        return
    end
    
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        for _, spell_history in pairs(game_spells_lib.spells_list) do
            if spell_history[1] == spell_name then
                if tonumber(spell_history[6]) == 0 and not hero:IsElf() then
                    return
                elseif tonumber(spell_history[6]) == 1 and not hero:IsTroll()  then
                    return
                end
            end
        end
        for _, spell_history in pairs(game_spells_lib.spells_list) do
            if spell_history[1] == spell_name then
                if tonumber(spell_history[7]) ~= 1 then
                    return
                end
            end
        end
    end
    -- Создание таблицы активных навыков у игрока с айди
    if game_spells_lib.current_activated_spell[player_id] == nil then
        game_spells_lib.current_activated_spell[player_id] = {}
    end

    -- нельзя использовать после опредленного времени
    if (GameRules:GetGameTime() / 60) >= game_spells_lib.SPELL_MAX_TIME_TO_ACTIVE then
		return
	end

    -- Находим есть ли у игрока этот навык, если есть то удаляет, если нет то добавляем
    if game_spells_lib:FindCurrentSpellPlayer(player_id, spell_name) then
        game_spells_lib:RemovePlayerSpell(player_id, spell_name, modifier_name, hero)
    else
        -- Если у игрока больше 3 активных навыков, то надо удалить самый старый включенный навык
        if #game_spells_lib.current_activated_spell[player_id] >= 3 then
            game_spells_lib:RemoveOldSpell(player_id, hero)
        end
        -- Добавление навыка
        game_spells_lib:AddPlayerSpell(player_id, spell_name, modifier_name, hero)
    end

    -- Обновление визуала активных навыков
    CustomNetTables:SetTableValue("game_spells_lib", "spell_active", game_spells_lib.current_activated_spell)
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
    for i=#game_spells_lib.current_activated_spell[id], 1, -1 do
        if game_spells_lib.current_activated_spell[id][i] == spell_name then
            table.remove(game_spells_lib.current_activated_spell[id], i)
            if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then return end
            DebugPrint("modifier_name " .. modifier_name)
            hero:RemoveModifierByName(modifier_name)
            break
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
    DebugPrint("lvl " .. game_spells_lib:GetSpellLevel(id, spell_name))
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
        DebugPrint("modifier_name 2  "  .. modifier_name)
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
        if not GameRules:IsCheatMode() then
            dataShop.SteamID = tostring(PlayerResource:GetSteamID(player_id))
            dataShop.Num = tostring(drop_info[1])
            dataShop.Score = tostring(drop_info[2])
            dataShop.Nick = "skill"
            dataShop.Coint = tostring(cost)
            dataShop.TypeDonate = "gem"
            dataShop.PlayerID = player_id
            Shop.GetSkill(dataShop, callback)
        end
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


function game_spells_lib:SetSpellPlayers()
    local pplc = PlayerResource:GetPlayerCount()
	for id=0,pplc-1 do
        if game_spells_lib.current_activated_spell[id] ~= nil then
            for _, spell_name in pairs(game_spells_lib.current_activated_spell[id]) do
                local hero = PlayerResource:GetSelectedHeroEntity(id)
                if hero == nil then 
                    return 
                end
                local modifier_name = game_spells_lib:FindModifierFromSpellName(spell_name)
                local spell_mod = hero:AddNewModifier(hero, nil, modifier_name, {}):SetStackCount(game_spells_lib:GetSpellLevel(id, spell_name))
                DebugPrint("lvl " .. game_spells_lib:GetSpellLevel(id, spell_name))
                if spell_mod then
                    spell_mod:SetStackCount(game_spells_lib:GetSpellLevel(id, spell_name))
                end
            end
        end
    end
end