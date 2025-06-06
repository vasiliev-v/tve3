MAXIMUM_ATTACK_SPEED = 600
MINIMUM_ATTACK_SPEED = 20

TROLL_HERO = "npc_dota_hero_troll_warlord" --"npc_dota_hero_arc_warden "
ELF_HERO = "npc_dota_hero_treant"
ANGEL_HERO = {"npc_dota_hero_crystal_maiden","npc_dota_hero_dark_willow"}  --{"npc_dota_hero_enigma","npc_dota_hero_queenofpain"}
WOLF_HERO =  {"npc_dota_hero_lycan","npc_dota_hero_night_stalker"} --{"npc_dota_hero_death_prophet","npc_dota_hero_abaddon"} 
BEAR_HERO = "npc_dota_hero_bear"

TEAM_CHOICE_TIME = 30

TROLL_SPAWN_TIME = 30
PRE_GAME_TIME = 40

ANGEL_RESPAWN_TIME = 10
WOLF_RESPAWN_TIME = 60 --120
WOLF_STARTING_RESOURCES_FRACTION = 0.40 --0.08 -- What percentage of troll's networth wolves should start with

ELF_STARTING_GOLD = 30
ELF_STARTING_GOLD_TURBO = 0
--ELF_NEWBIE_STARTING_GOLD = 50
ELF_STARTING_LUMBER = 0
ELF_STARTING_LUMBER_TURBO = 0
TROLL_STARTING_GOLD = 0
TROLL_STARTING_LUMBER = 0
TROLL_STARTING_GOLD_X2 = 100
TROLL_STARTING_GOLD_X4 = 800
TROLL_STARTING_GOLD_BATTLE = 0
TROLL_STARTING_GOLD_TURBO = 16000
TROLL_STARTING_GOLD_SOLO = 60
STARTING_LUMBER_PRICE = 150
MINIMUM_LUMBER_PRICE = 10
STARTING_MAX_FOOD = 1

STARTING_MAX_WISP = 15
STARTING_MAX_MINE = 15 --20
STARTING_MAX_WISP_MINE = 15

TIME_LIFE_WISP1_6 = 2400
TIME_LIFE_GOLD_WISP = 300

NO_CREATE_WISP = 2400

BUFF_ENIGMA_TIME = 7200
MIN_RATING_PLAYER = 1
MIN_RATING_PLAYER_CW = 10
PERC_KICK_PLAYER = 0.01
MIN_PLAYER_KICK = 1 --8
MIN_TIME_FOR_QUEST = 1  -- 1800

CHANCE_NEW_PERSON = 0 --10

TIMER_SAVER_HERO = 60

TIMER_KILL_CW = 181

EVENT_START = false
CHANCE_DROP_GEM_BANK = 75
CHANCE_DROP_GEM_BARRACKS_3 = 75
CHANCE_DROP_GOLD_BANK = 1
CHANCE_DROP_GOLD_BARRACKS_3 = 1

PLAYER_COLORS = {
    {0, 102, 255},   -- синий
    {0, 255, 255},   -- голубой
    {153, 0, 204},   -- темно-фиолетовый
    {225, 0, 255},   -- яркий фиолетовый
    {255, 255, 0},   -- желтый
    {255, 153, 51},  -- оранжевый
    {51, 204, 51},   -- яркий зеленый
    {0, 105, 0},     -- темно-зеленый
    {128, 0, 0},     -- бордовый
    {176, 0, 0},     -- темно-красный
    {60, 20, 74},    -- темно-фиолетово-коричневый
    {139, 69, 19},   -- коричневый
    {0, 0, 255},     -- синий
    {0, 0, 128},     -- темно-синий
    {0, 0, 0}        -- черный
}

MAX_LEVEL = 999

XP_PER_LEVEL_TABLE = {}
XP_PER_LEVEL_TABLE[1] = 0
for i = 2, MAX_LEVEL do
    XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + 100
end



dedicatedServerKey = GetDedicatedServerKeyV3("1")