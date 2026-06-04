local AspectsConfig = {}

AspectsConfig.DEFAULT_MAX_LEVEL = 3
AspectsConfig.UPGRADE_COST_STEP = 500
AspectsConfig.DISCOUNT_TO_LEVEL_2 = 0.4
AspectsConfig.DISCOUNT_TO_LEVEL_3 = 0.6
AspectsConfig.DEFAULT_LEVEL_COSTS = {0, 10000, 30000}


-- Массив существующих навыков
-- 1 - название
-- 2 - Иконка (ЭТО ДОЛЖНО БЫТЬ ДЕФОЛТНОЕ ОТОБРАЖЕНИЕ БЕЗ УРОВНЯ ПРОКАЧКИ, ЕСЛИ У ИГРОКА ЕСТЬ НАВЫК И УРОВЕНЬ, ТО ДОБАВЛЯЕТСЯ К ИКОНКЕ УЖЕ иконка_1 или иконка_2 и т.д.) (Не забудь что в js не компилятся иконки и их надо будет где-то закомпилить в xml или css)
-- 3 - Модификатор
-- 4 - Название улучшений 1-2-3
-- 5 - Цифры улучшение
-- 6 - Эльф или Тролль.
-- 7 - Работает ли перк.
function AspectsConfig:GetSpellList()
    if GameRules.MapSpeed ~= 4  and GetMapName() ~= "1x1"then
    DebugPrint("test not x4")
    return
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
                {"10%","15%","20%"},
                {"35 min","35 min","35 min"},
                {"20 min","20 min","20 min"},
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
                "elf_spell_armor_wall_description_level_2_shop",
            },
            {
                {"5%","10%","15%"},
                {"1","1","1"},
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
                {"5%","10%","15%"},
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
                {4, 8 , 15},
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
                "elf_spell_true_description_level_2_shop",
                "elf_spell_true_description_level_3_shop",
                "elf_spell_true_description_level_4_shop",
            },
            {
                {300, 600, 900},
                {3, 5, 7},
                {300, 240, 180},
                {300, 300, 300},
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
                {45, 60, 75},
                {200, 175, 150},
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
                {'+200k','+350k','+550k'},
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
                {1,2,4},
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
                "troll_spell_vision_description_level_2_shop",
            },
            {
                {300,600,900},
                {300,600,900},
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
                {-80,-90,-100},
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
                "troll_spell_evasion_description_level_3_shop",
            },
            {
                {2,3,5},
                {300,250,200},
                {100,100,100},
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
        {
            "troll_spell_invis",
            "troll_spell_invis",
            "modifier_troll_spell_invis",
            {
                "troll_spell_invis_description_level_1_shop",
                "troll_spell_invis_description_level_2_shop",
            },
            {
                {2.5, 3, 5 },
                {80, 70, 60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },

    }
elseif GetMapName() == "1x1" then
    return
    {


        -----------------------
        -- Troll spells
        -----------------------
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
                {1},
                {"400%",},
                {5},
                {150},
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
                {'200%'},
                {2},
                {300},
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
                {15},
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
                {5},
                {'2%'},
                {1000},
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
                {20},
                {20},
                {'1%'},
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
                {128},
                {'MAX'},
                {5},
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
                "troll_spell_evasion_description_level_3_shop",
            },
            {
                {2},
                {300},
                {100},
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
                {2.5},
                {80},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },

    }
else -- X4
    DebugPrint("test x4")
    return
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
                {"10%","15%","20%"},
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
                {10,15,20},
                {10,15,20},
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
                "elf_spell_armor_wall_description_level_2_shop_x4",
            },
            {
                {"5%","10%","15%"},
                {"1","1","1"},
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
                {"5%","10%","15%"},
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
                {4, 8 , 15},
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
                {45, 60, 90},
                {150, 125, 100},
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
                "elf_spell_true_description_level_2_shop_x4",
                "elf_spell_true_description_level_3_shop_x4",
            },
            {
                {300, 600, 900},
                {3, 5, 7},
                {150, 120, 100},
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
                {'+200k','+350k','+550k'},
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
                "troll_spell_vision_description_level_2_shop_x4",
            },
            {
                {300,600,900},
                {300,600,900},
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
                "troll_spell_evasion_description_level_3_shop_x4",
            },
            {
                {2,3,5},
                {300,250,200},
                {80,80,80},
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
        {
            "troll_spell_invis",
            "troll_spell_invis",
            "modifier_troll_spell_invis_x4",
            {
                "troll_spell_invis_description_level_1_shop_x4",
                "troll_spell_invis_description_level_2_shop_x4",
            },
            {
                {2.5, 3, 5 },
                {80, 70, 60},
            },
            "1",
            "1",
            {0, 10000, 30000}
        },

    }
end
end

function AspectsConfig:GetMaxLevel(aspect)
    if aspect and aspect.max_level then
        return aspect.max_level
    end
    return self.DEFAULT_MAX_LEVEL
end

function AspectsConfig:GetCostStep()
    return self.UPGRADE_COST_STEP
end

function AspectsConfig:GetDiscountForLevel(level)
    if level == 2 then
        return self.DISCOUNT_TO_LEVEL_2
    end
    if level == 3 then
        return self.DISCOUNT_TO_LEVEL_3
    end
    return 0
end

function AspectsConfig:GetAspectById(aspect_id, spell_list)
    local list = spell_list or self:GetSpellList()
    for index, aspect in ipairs(list) do
        if aspect[1] == aspect_id then
            return aspect, index
        end
    end
    return nil, nil
end

function AspectsConfig:GetSerializableConfig(spell_list)
    local result = {}
    for index, aspect in ipairs(spell_list or self:GetSpellList()) do
        local id = aspect[1]
        result[tostring(index)] = {
            id = id,
            name = id,
            description = id .. "_description",
            icon = aspect[2],
            modifier = aspect[3],
            tooltip_keys = aspect[4],
            values = aspect[5],
            side = aspect[6],
            enabled = aspect[7],
            level_costs = aspect[8] or self.DEFAULT_LEVEL_COSTS,
            max_level = self:GetMaxLevel(aspect),
        }
    end
    return result
end

function AspectsConfig:FormatTemplate(template, values)
    if not template then return "" end
    return (template:gsub("{([%w_]+)}", function(key)
        local value = values and values[key]
        if value == nil then
            return "{" .. key .. "}"
        end
        return tostring(value)
    end))
end

return AspectsConfig
