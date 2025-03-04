var chest_opened_time = 0.3
var FIRST_INIT_STORE = false
var data_categories = CustomNetTables.GetTableValue("Shop", "data_categories")
var data_chest = CustomNetTables.GetTableValue("Shop", "data_chest")
var button_donate_link_1 = "https://patreon.com/tve3"
var button_donate_link_2 = "https://paypal.com"
var button_donate_link_3 = "https://donate.stream/en/vladu4eg"
var button_donate_link_4 = "https://tve-shop.com"
var BOX_SHADOW_COLORS =
{
    "1" : "#b0c3d9",
    "2" : "#5e98d9",
    "3" : "#4b69ff",
    "4" : "#8847ff",
    "5" : "#d32ce6",
    "6" : "#b28a33",
    "7" : "#ade55c",
    "8" : "#eb4b4b",
}
var CHEST_GRADIENT_COLORS =
{
    "1" : ["#b0c3d9", "#808d9c"],
    "2" : ["#5e98d9", "#41648c"],
    "3" : ["#4b69ff", "#464e75"],
    "4" : ["#8847ff", "#594978"],
    "5" : ["#d32ce6", "#65196e"],
    "6" : ["#b28a33", "#664c15"],
    "7" : ["#ade55c", "#426314"],
    "8" : ["#eb4b4b", "#571212"],
}
var player_table = [
	[0,0],
	[""],
	[0, "none"],
	[0, "none"],
	// Массив ID СУНДУКА / КОЛИЧЕСТВО
	[
	]
]

var player_active_items = CustomNetTables.GetTableValue("Shop_active", Players.GetLocalPlayer())
var Items_ADS = 
[
	["ads_name_1", "ads1"], // переменная названия в локализации, ИКОНКА(именно название png файла)
	["ads_name_2", "ads2"],
]

// Последняя инфа в массиве это теперь редкость - вот цвета редкостей
//Common        1       
//Uncommon      2        
//Rare          3 
//Mythical      4     
//Legendary     5     
//Immortal	    6         
//Arcana        7    
//Ancient       8

var Items_ALL = data_categories["category_items_all"]
var Items_recomended = data_categories["category_items_recommended"]
var Items_sounds = data_categories["category_items_sounds"]
var Items_sprays = data_categories["category_items_sprays"]
var Items_skin = data_categories["category_items_skins_players"]
var Items_wisp = data_categories["category_items_skin_wisps"]
var Items_tower = data_categories["category_items_skins_towers"]
var Items_pets = data_categories["category_items_pets"]
var Items_gem = data_categories["category_items_gems"]
var Items_effects = data_categories["category_items_particles"]
var Items_subscribe = data_categories["category_items_subscribes"]
var chests_table = data_categories["category_items_chests"]
var Items_currency = 
[
	["301",  "", "5$", "gold_icon", "donate_5", true], 
	["302", "", "10$", "gold_icon", "donate_10", true],
	["303", "", "15$", "gold_icon", "donate_15", true],
	["304", "", "20$", "gold_icon", "donate_20", true],
	["305", "", "25$", "gold_icon", "donate_25", true],
]