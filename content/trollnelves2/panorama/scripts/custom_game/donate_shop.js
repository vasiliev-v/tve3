// Заказчик: vladu4eg
// Js Author: https://vk.com/dev_stranger

// Что нужно сделать в lua
// Заполнить в таблицу игрока примерно как "player_table" и поменять это везде в коде
// При покупке предмета отправлять стоимость и айди предмета и добавлять предмет в таблицу, сделал ивент на вызов ошибки если покупка не удалась ее там же вызвать и не забыть отправить ивент на изменение валюты
// Изменить айди курьеров и айди партиклов в луа, под айди предметов в магазине

// Важное
// Айдишник предметов не должны повторяться
// название питомцев должны начинаться с pet_, эффекты с particle_, а донат с donate_
// Остальное будем менять позже, сундуки если все таки нужны будут, я думаю лучше доделать после окончания магазина

var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements").FindChildTraverse("MenuButtons");
if ($("#ShopButton")) {
	if (parentHUDElements.FindChildTraverse("ShopButton")){
		$("#ShopButton").DeleteAsync( 0 );
	} else {
		$("#ShopButton").SetParent(parentHUDElements);
	}
}

var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "";
var chest_opened_time = 0.3

//////////ССЫЛКИ НА КНОПКИ С ДОНАТОМ ПРИ ПОКУПКЕ ВАЛЮТЫ///////////

var button_donate_link_1 = "https://patreon.com/tve3"
var button_donate_link_2 = "https://paypal.com"
var button_donate_link_3 = "https://donate.stream/en/vladu4eg"
var button_donate_link_4 = "https://tve-shop.com"

//////////Тестовая таблица игрока 1. валюта, 2. купленные айди, 3. шанс троля и бонус рейт///////////


var player_table = [
	[0,0],
	[""],
	[0, "none"],
	[0, "none"],

	// Массив ID СУНДУКА / КОЛИЧЕСТВО
	[
	]
]



var chests_table = [
	// ID Cундука, валюта, стоимость, локализация, иконка, массив шмоток в сундуке(проверяется со шмоткми в магазине)+шанс, последняя награда всегда коины шанс + gold/gem, от скольки до скольки коинов
	// Здесь только визуал, главное не забудь в луа прописывать сундук 4
	["523", "gold", "100", "chest_23", "chest_23", [["802","100"],["111","100"],["112","100"],["113","100"],["114","100"],["115","100"],["116","100"],["103","100"],["127","100"]], [20, "gold"], [10, 100] ],

	["501", "gold", "50", "chest_1", "chest_1", [["704","50"],["705","50"],["818","50"],["24","50"],["117","50"],["130","50"],["116","50"],["602","50"],["603","50"]],   [20, "gold"], [10, 50] ],
	["503", "gold", "50", "chest_3", "chest_3", [["723","50"],["719","50"],["822","50"],["26","50"],["119","50"],["114","50"],["115","50"],["605","50"],["606","50"]],   [20, "gold"], [10, 50] ],
	["516", "gold", "50", "chest_16", "chest_16", [["701","50"],["814","50"],["827","50"],["18","50"],["46","50"],["133","50"],["134","50"],["624","50"],["621","50"]],  [20, "gold"], [10, 50] ],
	["502", "gold", "75", "chest_2", "chest_2", [["712","50"],["716","50"],["819","50"],["25","50"],["118","50"],["131","50"],["602","50"],["603","50"],["604","50"]],   [20, "gold"], [15, 75] ],
	["504", "gold", "75", "chest_4", "chest_4", [["724","50"],["801","50"],["836","50"],["20","50"],["120","50"],["111","50"],["605","50"],["606","50"],["607","50"]],   [20, "gold"], [15, 75] ],
	["517", "gold", "75", "chest_17", "chest_17", [["702","50"],["816","50"],["833","50"],["23","50"],["115","50"],["135","50"],["624","50"],["621","50"],["622","50"]], [20, "gold"], [15, 75] ],
	["505", "gold", "100", "chest_5", "chest_5", [["720","50"],["802","50"],["838","50"],["21","50"],["122","50"],["112","50"],["606","50"],["607","50"],["608","50"]],   [20, "gold"], [15, 75] ],
	["518", "gold", "100", "chest_18", "chest_18", [["703","50"],["722","50"],["834","50"],["27","50"],["47","50"],["50","50"],["621","50"],["622","50"],["627","50"]], 	[20, "gold"], [20, 100] ],
	["506", "gold", "100", "chest_6", "chest_6", [["706","50"],["803","50"],["41","50"],["31","50"],["35","50"],["103","50"],["607","50"],["613","50"],["609","50"]], 	[20, "gold"], [20, 100] ],
	["519", "gold", "100", "chest_19", "chest_19", [["715","50"],["721","50"],["44","50"],["22","50"],["48","50"],["51","50"],["623","50"],["628","50"],["625","50"]], 	[20, "gold"], [20, 100] ],
	["507", "gold", "125", "chest_7", "chest_7", [["707","50"],["804","50"],["36","50"],["37","50"],["19","50"],["129","50"],["113","50"],["615","50"],["612","50"]], 	[20, "gold"], [25, 125] ],
	["508", "gold", "150", "chest_8", "chest_8", [["708","50"],["805","50"],["29","50"],["39","50"],["28","50"],["132","50"],["615","50"],["612","50"],["616","50"]], 	[20, "gold"], [30, 150] ],
	["509", "gold", "175", "chest_9", "chest_9", [["709","50"],["806","50"],["5","50"],["10","50"],["32","50"],["133","50"],["614","50"],["616","50"],["617","50"]], 		[20, "gold"], [35, 175] ],
	["520", "gold", "175", "chest_20", "chest_20", [["714","50"],["718","50"],["45","50"],["34","50"],["52","50"],["610","50"],["611","50"],["629","50"],["626","50"]], 	[20, "gold"], [35, 175] ],
	["510", "gold", "200", "chest_10", "chest_10", [["710","50"],["807","50"],["6","50"],["38","50"],["127","50"],["134","50"],["46","50"],["635","50"],["636","50"]], 	[20, "gold"], [40, 200] ],
	["511", "gold", "200", "chest_11", "chest_11", [["713","50"],["810","50"],["7","50"],["40","50"],["128","50"],["135","50"],["47","50"],["637","50"],["638","50"]], 	[20, "gold"], [40, 200] ],
	["512", "gold", "225", "chest_12", "chest_12", [["717","50"],["811","50"],["8","50"],["42","50"],["126","50"],["144","50"],["48","50"],["639","50"],["640","50"]], 	[20, "gold"], [45, 200] ],
	["513", "gold", "225", "chest_13", "chest_13", [["711","50"],["813","50"],["9","50"],["43","50"],["124","50"],["146","50"],["49","50"],["641","50"],["642","50"]], 	[20, "gold"], [45, 200] ],
	
	["522", "gold", "225", "chest_22", "chest_22", [["808","50"],["809","50"],["825","50"],["33","50"],["53","50"],["54","50"],["55","50"],["618","50"],["619","50"]], [20, "gold"], [45, 225] ],

	["514", "gold", "250", "chest_14", "chest_14", [["614","50"],["602","50"],["603","50"],["604","50"],["605","50"],["606","50"],["607","50"],["608","50"],["609","50"]], [20, "gold"], [50, 250] ],
	["515", "gold", "250", "chest_15", "chest_15", [["615","50"],["612","50"],["616","50"],["617","50"],["613","50"],["639","50"],["640","50"],["641","50"],["642","50"]], [20, "gold"], [50, 250] ],
	["521", "gold", "250", "chest_21", "chest_21", [["620","50"],["624","50"],["621","50"],["622","50"],["627","50"],["628","50"],["625","50"],["629","50"],["626","50"]], [20, "gold"], [40, 200] ],
	["524", "gold", "250", "chest_24", "chest_24", [["673","50"],["680","50"],["682","50"],["674","50"],["675","50"],["678","50"],["679","50"],["677","50"],["681","50"]], [20, "gold"], [40, 250] ],
	["525", "gold", "2000", "chest_25", "chest_25", [["654","50"],["669","50"],["668","50"],["667","50"],["656","50"],["660","50"],["659","50"],["662","50"],["663","50"]], [20, "gold"], [200, 2000] ],

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




/////////////////////////////

//////////МАССИВ РЕКОМЕНДУЕМЫХ ПРЕДМЕТОВ МАКСИМУМ 9///////////

var Items_recomended = [
	// ID ПРЕДМЕТА для проверки или для добавления в базу,ВАЛЮТА,СТОИМОСТЬ,ИКОНКА(именно название png файла),переменная названия в локализации, можно покупать много раз или один раз(проверка на покупку в базе)	
	["510", "gold", "200", "chest_10", "chest_10", [["710","50"],["807","50"],["6","50"],["38","50"],["127","50"],["134","50"],["46","50"],["635","50"],["636","50"]], 	[20, "gold"], [40, 200] ],
	["511", "gold", "200", "chest_11", "chest_11", [["713","50"],["810","50"],["7","50"],["40","50"],["128","50"],["135","50"],["47","50"],["637","50"],["638","50"]], 	[20, "gold"], [40, 200] ],
	["512", "gold", "225", "chest_12", "chest_12", [["717","50"],["811","50"],["8","50"],["42","50"],["126","50"],["144","50"],["48","50"],["639","50"],["640","50"]], 	[20, "gold"], [45, 200] ],
	["513", "gold", "225", "chest_13", "chest_13", [["711","50"],["813","50"],["9","50"],["43","50"],["124","50"],["146","50"],["49","50"],["641","50"],["642","50"]], 	[20, "gold"], [45, 200] ],

	["514", "gold", "250", "chest_14", "chest_14", [["614","50"],["602","50"],["603","50"],["604","50"],["605","50"],["606","50"],["607","50"],["608","50"],["609","50"]], [20, "gold"], [50, 250] ],
	["515", "gold", "250", "chest_15", "chest_15", [["615","50"],["612","50"],["616","50"],["617","50"],["613","50"],["639","50"],["640","50"],["641","50"],["642","50"]], [20, "gold"], [50, 250] ],
	["521", "gold", "250", "chest_21", "chest_21", [["620","50"],["624","50"],["621","50"],["622","50"],["627","50"],["628","50"],["625","50"],["629","50"],["626","50"]], [20, "gold"], [40, 200] ],
	["524", "gold", "250", "chest_24", "chest_24", [["673","50"],["680","50"],["682","50"],["674","50"],["675","50"],["678","50"],["679","50"],["677","50"],["681","50"]], [20, "gold"], [40, 250] ],
	["525", "gold", "2000", "chest_25", "chest_25", [["654","50"],["669","50"],["668","50"],["667","50"],["656","50"],["660","50"],["659","50"],["662","50"],["663","50"]], [20, "gold"], [200, 2000] ],


]

//////////МАССИВ ОКОШЕК НА ГЛАВНОЙ///////////

var Items_ADS = [
	["ads_name_1", "ads1"], // переменная названия в локализации, ИКОНКА(именно название png файла)
	["ads_name_2", "ads2"],
]


var Items_sounds = [
	["801",  "gold", "100", "sounds", "sounds_1", false, 1], 
	["802",  "gold", "100", "sounds", "sounds_2", false, 1], 
	["803",  "gold", "100", "sounds", "sounds_3", false, 1], 
	["804",  "gold", "100", "sounds", "sounds_4", false, 1],

	["805",  "gold", "100", "sounds", "sounds_5", false, 1], 
	["806",  "gold", "100", "sounds", "sounds_6", false, 1], 
	["807",  "gold", "100", "sounds", "sounds_7", false, 1], 
	["808",  "gold", "100", "sounds", "sounds_8", false, 1], 

	["809",  "gold", "100", "sounds", "sounds_9", false, 1], 
	["810",  "gold", "100", "sounds", "sounds_10", false, 1], 
	["811",  "gold", "100", "sounds", "sounds_11", false, 1], 
	["812",  "gold", "100", "sounds", "sounds_12", false, 1], 

	["813",  "gold", "100", "sounds", "sounds_13", false, 1], 
	["814",  "gold", "100", "sounds", "sounds_14", false, 1], 
	["815",  "gold", "100", "sounds", "sounds_15", false, 1], 
    ["816",  "gold", "100", "sounds", "sounds_16", false, 1],

	["817",  "gold", "100", "sounds", "sounds_17", false, 1], 
	["818",  "gold", "100", "sounds", "sounds_18", false, 1], 
	["819",  "gold", "100", "sounds", "sounds_19", false, 1], 
	["820",  "gold", "100", "sounds", "sounds_20", false, 1], 

	["821",  "gold", "100", "sounds", "sounds_21", false, 1], 
	["822",  "gold", "100", "sounds", "sounds_22", false, 1], 
	["823",  "gold", "100", "sounds", "sounds_23", false, 1], 
	["824",  "gold", "100", "sounds", "sounds_24", false, 1],

	["825",  "gold", "100", "sounds", "sounds_25", false, 1], 
	["826",  "gold", "100", "sounds", "sounds_26", false, 1], 
	["827",  "gold", "100", "sounds", "sounds_27", false, 1], 
	["828",  "gold", "100", "sounds", "sounds_28", false, 1], 

//	["829",  "gold", "100", "sound_29", "sounds_29", false, 1], 
//	["830",  "gold", "100", "sound_30", "sounds_30", false, 1], 
//	["831",  "gold", "100", "sound_31", "sounds_31", false, 1], 
//	["832",  "gold", "100", "sound_32", "sounds_32", false, 1], 

	["833",  "gold", "100", "sounds", "sounds_33", false, 1], 
	["834",  "gold", "100", "sounds", "sounds_34", false, 1], 
//	["835",  "gold", "100", "sound_35", "sounds_35", false, 1], 
	["836",  "gold", "100", "sounds", "sounds_36", false, 1], 

//	["837",  "gold", "100", "sound_37", "sounds_37", false, 1], 
	["838",  "gold", "100", "sounds", "sounds_38", false, 1], 
	
	["843",  "gold", "150", "sounds", "sounds_43", false, 1], 
	["844",  "gold", "150", "sounds", "sounds_44", false, 1], 
	["845",  "gold", "150", "sounds", "sounds_45", false, 1], 
	["846",  "gold", "150", "sounds", "sounds_46", false, 1], 
	["847",  "gold", "150", "sounds", "sounds_47", false, 1], 
	["848",  "gold", "150", "sounds", "sounds_48", false, 1], 
	["849",  "gold", "150", "sounds", "sounds_49", false, 1], 
	["850",  "gold", "150", "sounds", "sounds_50", false, 1], 
	["851",  "gold", "150", "sounds", "sounds_51", false, 1], 
	["852",  "gold", "150", "sounds", "sounds_52", false, 1], 
	["853",  "gold", "150", "sounds", "sounds_53", false, 1], 
	["854",  "gold", "150", "sounds", "sounds_54", false, 1], 
	["855",  "gold", "150", "sounds", "sounds_55", false, 1], 
	["856",  "gold", "150", "sounds", "sounds_56", false, 1], 
	["857",  "gold", "150", "sounds", "sounds_57", false, 1], 
	["858",  "gold", "150", "sounds", "sounds_58", false, 1], 
	["859",  "gold", "150", "sounds", "sounds_59", false, 1], 
	["860",  "gold", "150", "sounds", "sounds_60", false, 1], 
	["861",  "gold", "150", "sounds", "sounds_61", false, 1], 
	["862",  "gold", "150", "sounds", "sounds_62", false, 1], 
	["863",  "gold", "150", "sounds", "sounds_63", false, 1], 
	["864",  "gold", "150", "sounds", "sounds_64", false, 1], 
	["865",  "gold", "150", "sounds", "sounds_65", false, 1], 
	["866",  "gold", "150", "sounds", "sounds_66", false, 1], 
	["867",  "gold", "150", "sounds", "sounds_67", false, 1], 
	["868",  "gold", "150", "sounds", "sounds_68", false, 1], 
	["869",  "gold", "150", "sounds", "sounds_69", false, 1], 
	["870",  "gold", "150", "sounds", "sounds_70", false, 1], 
	["871",  "gold", "150", "sounds", "sounds_71", false, 1], 
	["872",  "gold", "150", "sounds", "sounds_72", false, 1], 
	["873",  "gold", "150", "sounds", "sounds_73", false, 1], 
	["874",  "gold", "150", "sounds", "sounds_74", false, 1], 
	["875",  "gold", "150", "sounds", "sounds_75", false, 1], 
	["876",  "gold", "150", "sounds", "sounds_76", false, 1], 
	["877",  "gold", "150", "sounds", "sounds_77", false, 1], 
	["878",  "gold", "150", "sounds", "sounds_78", false, 1], 
	["879",  "gold", "150", "sounds", "sounds_79", false, 1], 
	["880",  "gold", "150", "sounds", "sounds_80", false, 1], 
	["881",  "gold", "150", "sounds", "sounds_81", false, 1], 
	["882",  "gold", "150", "sounds", "sounds_82", false, 1], 
	["883",  "gold", "150", "sounds", "sounds_83", false, 1], 
	["884",  "gold", "150", "sounds", "sounds_84", false, 1], 
	["885",  "gold", "150", "sounds", "sounds_85", false, 1], 
	["886",  "gold", "150", "sounds", "sounds_86", false, 1], 
	["887",  "gold", "150", "sounds", "sounds_87", false, 1], 
	["888",  "gold", "150", "sounds", "sounds_88", false, 1], 

]

var Items_sprays = [
	["701",  "gold", "50", "spray_1", "spray_1", false, 1], 
	["702",  "gold", "50", "spray_2", "spray_2", false, 1], 
	["703",  "gold", "50", "spray_3", "spray_3", false, 1], 
	["704",  "gold", "50", "spray_4", "spray_4", false, 1], 

	["705",  "gold", "50", "spray_5", "spray_5", false, 1], 
	["706",  "gold", "50", "spray_6", "spray_6", false, 1], 
	["707",  "gold", "50", "spray_7", "spray_7", false, 1], 
	["708",  "gold", "50", "spray_8", "spray_8", false, 1],

	["709",  "gold", "50", "spray_9", "spray_9", false, 1], 
	["710",  "gold", "50", "spray_10", "spray_10", false, 1], 
	["711",  "gold", "50", "spray_11", "spray_11", false, 1], 
	["712",  "gold", "50", "spray_12", "spray_12", false, 1], 

	["713",  "gold", "50", "spray_13", "spray_13", false, 1], 
	["714",  "gold", "50", "spray_14", "spray_14", false, 1], 
	["715",  "gold", "50", "spray_15", "spray_15", false, 1], 
	["716",  "gold", "50", "spray_16", "spray_16", false, 1],

	["717",  "gold", "50", "spray_17", "spray_17", false, 1], 
	["718",  "gold", "50", "spray_18", "spray_18", false, 1], 
	["719",  "gold", "50", "spray_19", "spray_19", false, 1], 
	["720",  "gold", "50", "spray_20", "spray_20", false, 1],

	["721",  "gold", "50", "spray_21", "spray_21", false, 1], 
	["722",  "gold", "50", "spray_22", "spray_22", false, 1], 
	["723",  "gold", "50", "spray_23", "spray_23", false, 1], 
	["724",  "gold", "50", "spray_24", "spray_24", false, 1],  
]

//////////МАССИВ ПИТОМЦЕВ///////////

var Items_skin = [
	// ID ПРЕДМЕТА для проверки или для добавления в базу,ВАЛЮТА,СТОИМОСТЬ,ИКОНКА(именно название png файла),переменная названия в локализации, можно покупать много раз или один раз(проверка на покупку в базе)
	["601", "gold", "99999999", "skin_1", "skin_1", false, 7], 
	["602", "gold", "500", "skin_2", "skin_2", false, 7], 
	["603", "gold", "500", "skin_3", "skin_3", false, 7], 
	["604", "gold", "500", "skin_4", "skin_4", false, 7], 
	["605", "gold", "500", "skin_5", "skin_5", false, 7], 
	["606", "gold", "500", "skin_6", "skin_6", false, 7], 
	["607", "gold", "500", "skin_7", "skin_7", false, 7], 
	["608", "gold", "500", "skin_8", "skin_8", false, 7], 
	["609", "gold", "500", "skin_9", "skin_9", false, 7], 
	["610", "gold", "500", "skin_10", "skin_10", false, 7], 
	["611", "gold", "500", "skin_11", "skin_11", false, 7], 
	["612", "gold", "500", "skin_12", "skin_12", false, 7], 
	["613", "gold", "750", "skin_13", "skin_13", false, 7], 
	["614", "gold", "750", "skin_14", "skin_14", false, 7], 
	["615", "gold", "500", "skin_15", "skin_15", false, 7], 
	["616", "gold", "750", "skin_16", "skin_16", false, 7], 
	["617", "gold", "750", "skin_17", "skin_17", false, 7], 
	["618", "gold", "1000", "skin_18", "skin_18", false, 7], 
	["619", "gold", "1000", "skin_19", "skin_19", false, 7], 
	
	["635", "gold", "1000", "skin_35", "skin_35", false, 7], 
	["636", "gold", "1000", "skin_36", "skin_36", false, 7], 
	["637", "gold", "1000", "skin_37", "skin_37", false, 7], 
	["638", "gold", "1000", "skin_38", "skin_38", false, 7],
	["639", "gold", "1000", "skin_39", "skin_39", false, 7], 
	["640", "gold", "1000", "skin_40", "skin_40", false, 7], 
	["641", "gold", "1000", "skin_41", "skin_41", false, 7], 
	["642", "gold", "1000", "skin_42", "skin_42", false, 7],

	["644", "gold", "1000", "skin_44", "skin_44", false, 7],
	["645", "gold", "1000", "skin_45", "skin_45", false, 7],
	["646", "gold", "1000", "skin_46", "skin_46", false, 7],
	["647", "gold", "1000", "skin_47", "skin_47", false, 7],
	["648", "gold", "1000", "skin_48", "skin_48", false, 7],
	["649", "gold", "1000", "skin_49", "skin_49", false, 7],
	["650", "gold", "1000", "skin_50", "skin_50", false, 7],
	["651", "gold", "1000", "skin_51", "skin_51", false, 7],
	["652", "gold", "1000", "skin_52", "skin_52", false, 7],

	
	["620", "gold", "99999999", "skin_20", "skin_20", false, 7], 
	["621", "gold", "800", "skin_21", "skin_21", false, 7], 
	["622", "gold", "800", "skin_22", "skin_22", false, 7], 
	["623", "gold", "800", "skin_23", "skin_23", false, 7], 
	["624", "gold", "800", "skin_24", "skin_24", false, 7], 
	["625", "gold", "800", "skin_25", "skin_25", false, 7], 
	["626", "gold", "1000", "skin_26", "skin_26", false, 7], 
	["627", "gold", "800", "skin_27", "skin_27", false, 7], 
	["628", "gold", "800", "skin_28", "skin_28", false, 7], 
	["629", "gold", "1000", "skin_29", "skin_29", false, 7],

	["630", "gold", "5000", "skin_30", "skin_30", false, 7],
	["631", "gold", "5000", "skin_31", "skin_31", false, 7],

	["653", "gold", "2000", "skin_53", "skin_53", false, 8],
	["654", "gold", "5000", "skin_54", "skin_54", false, 8],
	["655", "gold", "3500", "skin_55", "skin_55", false, 8],
	["656", "gold", "3500", "skin_56", "skin_56", false, 8],
	["657", "gold", "5000", "skin_57", "skin_57", false, 8],
	["658", "gold", "5000", "skin_58", "skin_58", false, 8],
	["659", "gold", "3500", "skin_59", "skin_59", false, 8],
	["660", "gold", "3500", "skin_60", "skin_60", false, 8],
	["661", "gold", "3500", "skin_61", "skin_61", false, 8],
	["662", "gold", "3500", "skin_62", "skin_62", false, 8],
	["663", "gold", "3500", "skin_63", "skin_63", false, 8],
	["664", "gold", "3500", "skin_64", "skin_64", false, 8],
	["665", "gold", "5000", "skin_65", "skin_65", false, 8],
	["667", "gold", "3500", "skin_67", "skin_67", false, 8],
	["668", "gold", "3500", "skin_68", "skin_68", false, 8],
	["669", "gold", "3500", "skin_69", "skin_69", false, 8],
	["670", "gold", "5000", "skin_70", "skin_70", false, 8],
	["671", "gold", "3500", "skin_71", "skin_71", false, 8],
	["672", "gold", "5000", "skin_72", "skin_72", false, 8],

	["673", "gold", "300", "skin_73", "skin_73", false, 7], 
	["674", "gold", "500", "skin_74", "skin_74", false, 7], 
	["675", "gold", "500", "skin_75", "skin_75", false, 7], 
	["676", "gold", "1000", "skin_76", "skin_76", false, 7], 
	["677", "gold", "800", "skin_77", "skin_77", false, 7], 
	["678", "gold", "800", "skin_78", "skin_78", false, 7], 
	["679", "gold", "300", "skin_79", "skin_79", false, 7], 
	["680", "gold", "1000", "skin_80", "skin_80", false, 7], 
	["681", "gold", "300", "skin_81", "skin_81", false, 7], 
	["682", "gold", "1000", "skin_82", "skin_82", false, 7],
	
	["643", "gold", "99999999", "skin_43", "skin_43", false, 7], 
	["666", "gold", "99999999", "skin_66", "skin_66", false, 7],

	["683", "gold", "500", "skin_83", "skin_83", false, 7],
	["684", "gold", "750", "skin_84", "skin_84", false, 7],
	["685", "gold", "900", "skin_85", "skin_85", false, 7],
	["686", "gold", "1000", "skin_86", "skin_86", false, 8],
	["687", "gold", "1000", "skin_87", "skin_87", false, 8],
	["688", "gold", "1500", "skin_88", "skin_88", false, 8],
	["689", "gold", "2000", "skin_89", "skin_89", false, 8],
	["690", "gold", "5000", "skin_90", "skin_90", false, 8],
	["691", "gold", "5000", "skin_91", "skin_91", false, 8],
	["692", "gold", "5000", "skin_92", "skin_92", false, 8],
	["693", "gold", "5000", "skin_93", "skin_93", false, 8],
	["694", "gold", "5000", "skin_94", "skin_94", false, 8],
	["695", "gold", "99999999", "skin_95", "skin_95", false, 8],
	["696", "gold", "5000", "skin_96", "skin_96", false, 8],
	["697", "gold", "99999999", "skin_97", "skin_97", false, 8],
	["698", "gold", "5000", "skin_98", "skin_98", false, 8],

//	["630", "gold", "1500", "skin_30", "skin_30", false, 7], 
//	["631", "gold", "1500", "skin_31", "skin_31", false, 7], 
//	["632", "gold", "1500", "skin_32", "skin_32", false, 7], 
//	["633", "gold", "1500", "skin_33", "skin_33", false, 7], 
//	["634", "gold", "1500", "skin_34", "skin_34", false, 7], 
		
]

var Items_wisp = [
	// ID ПРЕДМЕТА для проверки или для добавления в базу,ВАЛЮТА,СТОИМОСТЬ,ИКОНКА(именно название png файла),переменная названия в локализации, можно покупать много раз или один раз(проверка на покупку в базе)
	["1201", "gold", "350", "skin_wisp_1", "skin_wisp_1", false, 7], 
	["1202", "gold", "150", "skin_wisp_2", "skin_wisp_2", false, 7], 
	["1203", "gold", "150", "skin_wisp_3", "skin_wisp_3", false, 7], 
	["1204", "gold", "150", "skin_wisp_4", "skin_wisp_4", false, 7], 
	["1205", "gold", "150", "skin_wisp_5", "skin_wisp_5", false, 7], 
	["1206", "gold", "150", "skin_wisp_6", "skin_wisp_6", false, 7], 
	["1207", "gold", "150", "skin_wisp_7", "skin_wisp_7", false, 7], 
	["1208", "gold", "150", "skin_wisp_8", "skin_wisp_8", false, 7], 
	["1209", "gold", "150", "skin_wisp_9", "skin_wisp_9", false, 7], 
	["1210", "gold", "150", "skin_wisp_10", "skin_wisp_10", false, 7], 
	["1211", "gold", "500", "skin_wisp_11", "skin_wisp_11", false, 7], 
	["1212", "gold", "250", "skin_wisp_12", "skin_wisp_12", false, 7], 
	["1213", "gold", "250", "skin_wisp_13", "skin_wisp_13", false, 7], 
	["1214", "gold", "250", "skin_wisp_14", "skin_wisp_14", false, 7], 
	["1215", "gold", "500", "skin_wisp_15", "skin_wisp_15", false, 7], 
	["1216", "gold", "500", "skin_wisp_16", "skin_wisp_16", false, 7], 
	["1217", "gold", "500", "skin_wisp_17", "skin_wisp_17", false, 7], 
	["1218", "gold", "250", "skin_wisp_18", "skin_wisp_18", false, 7], 
	["1219", "gold", "250", "skin_wisp_19", "skin_wisp_19", false, 7], 
	["1220", "gold", "500", "skin_wisp_20", "skin_wisp_20", false, 7], 
	["1221", "gold", "5000", "skin_wisp_21", "skin_wisp_21", false, 7], 
	["1222", "gold", "5000", "skin_wisp_22", "skin_wisp_22", false, 7], 
	["1223", "gold", "5000", "skin_wisp_23", "skin_wisp_23", false, 7], 
	["1224", "gold", "5000", "skin_wisp_24", "skin_wisp_24", false, 7], 
	["1225", "gold", "500", "skin_wisp_25", "skin_wisp_25", false, 7], 
	["1226", "gold", "500", "skin_wisp_26", "skin_wisp_26", false, 7], 
	
]

var Items_tower = [
	// ID ПРЕДМЕТА для проверки или для добавления в базу,ВАЛЮТА,СТОИМОСТЬ,ИКОНКА(именно название png файла),переменная названия в локализации, можно покупать много раз или один раз(проверка на покупку в базе)
	["1001", "gold", "100", "tower_11", "tower_11", false, 7], 
	["1002", "gold", "100", "tower_11_1", "tower_11_1", false, 7], 
	["1003", "gold", "100", "tower_12", "tower_12", false, 7], 
	["1004", "gold", "100", "tower_13", "tower_13", false, 7], 
	["1005", "gold", "100", "tower_12_1", "tower_12_1", false, 7], 
	["1006", "gold", "100", "tower_14", "tower_14", false, 7], 
	["1007", "gold", "100", "tower_15", "tower_15", false, 7], 
	["1008", "gold", "100", "tower_15_1", "tower_15_1", false, 7], 
	["1009", "gold", "100", "tower_16", "tower_16", false, 7], 
	["1010", "gold", "100", "tower_17", "tower_17", false, 7], 
	["1011", "gold", "100", "tower_18", "tower_18", false, 7], 
	["1012", "gold", "100", "tower_19", "tower_19", false, 7], 
	//["1013", "gold", "100", "tower_10_1", "tower_10_1", false, 7], 
	["1014", "gold", "100", "sight_tower_1", "true_sight_tower", false, 7], 
	["1015", "gold", "100", "sight_tower_2", "true_sight_tower", false, 7], 
	["1016", "gold", "100", "sight_tower_3", "true_sight_tower", false, 7], 
	["1017", "gold", "100", "sight_tower_4", "true_sight_tower", false, 7], 
	["1018", "gold", "100", "sight_tower_5", "true_sight_tower", false, 7], 
	["1019", "gold", "100", "sight_tower_6", "true_sight_tower", false, 7], 
	["1020", "gold", "100", "sight_tower_7", "true_sight_tower", false, 7], 
	["1021", "gold", "100", "sight_tower_8", "true_sight_tower", false, 7], 
	["1022", "gold", "100", "sight_tower_9", "true_sight_tower", false, 7], 
	["1023", "gold", "100", "high_sight_tower_1", "high_true_sight_tower", false, 7], 
	["1024", "gold", "100", "high_sight_tower_2", "high_true_sight_tower", false, 7], 
	["1025", "gold", "100", "high_sight_tower_3", "high_true_sight_tower", false, 7], 
	["1026", "gold", "100", "high_sight_tower_4", "high_true_sight_tower", false, 7], 
	["1027", "gold", "100", "high_sight_tower_5", "high_true_sight_tower", false, 7], 
	["1028", "gold", "100", "high_sight_tower_6", "high_true_sight_tower", false, 7], 
	["1029", "gold", "100", "high_sight_tower_7", "high_true_sight_tower", false, 7], 
	["1030", "gold", "100", "high_sight_tower_8", "high_true_sight_tower", false, 7], 
	["1031", "gold", "100", "high_sight_tower_9", "high_true_sight_tower", false, 7], 
	["1032", "gold", "300", "1_tower_12", "tower_12", false, 7], 
	["1033", "gold", "300", "1_tower_13", "tower_13", false, 7], 
	["1034", "gold", "300", "1_tower_21", "tower_21", false, 7], 
	["1035", "gold", "300", "1_tower_22", "tower_22", false, 7], 
	["1036", "gold", "300", "tower_flag_1", "flag", false, 7], 

	["1037", "gold", "300", "sight_tower_10", "true_sight_tower", false, 7], 
	["1038", "gold", "300", "sight_tower_11", "true_sight_tower", false, 7], 
	["1039", "gold", "300", "sight_tower_12", "true_sight_tower", false, 7], 
	["1040", "gold", "300", "sight_tower_13", "true_sight_tower", false, 7], 
	["1041", "gold", "300", "sight_tower_14", "true_sight_tower", false, 7], 
	["1042", "gold", "300", "sight_tower_15", "true_sight_tower", false, 7], 
	["1043", "gold", "300", "sight_tower_16", "true_sight_tower", false, 7], 
	["1044", "gold", "300", "sight_tower_17", "true_sight_tower", false, 7], 
	["1045", "gold", "300", "sight_tower_18", "true_sight_tower", false, 7], 
	["1046", "gold", "300", "sight_tower_19", "true_sight_tower", false, 7], 
	["1047", "gold", "300", "sight_tower_20", "true_sight_tower", false, 7], 
	["1048", "gold", "300", "sight_tower_21", "true_sight_tower", false, 7], 
	["1049", "gold", "300", "sight_tower_22", "true_sight_tower", false, 7], 
	["1050", "gold", "300", "sight_tower_23", "true_sight_tower", false, 7], 
	["1051", "gold", "300", "sight_tower_24", "true_sight_tower", false, 7], 
	["1052", "gold", "300", "sight_tower_25", "true_sight_tower", false, 7], 
	["1053", "gold", "300", "sight_tower_26", "true_sight_tower", false, 7], 
	["1054", "gold", "300", "sight_tower_27", "true_sight_tower", false, 7], 
	["1055", "gold", "300", "sight_tower_28", "true_sight_tower", false, 7], 
	["1056", "gold", "300", "sight_tower_29", "true_sight_tower", false, 7], 
	["1057", "gold", "300", "sight_tower_30", "true_sight_tower", false, 7], 
	["1058", "gold", "300", "sight_tower_31", "true_sight_tower", false, 7], 

]

var Items_pets = [
	// ID ПРЕДМЕТА для проверки или для добавления в базу,ВАЛЮТА,СТОИМОСТЬ,ИКОНКА(именно название png файла),переменная названия в локализации, можно покупать много раз или один раз(проверка на покупку в базе)
	["24", "gold", "100", "pet_24", "pet_24", false, 2],
	["25", "gold", "100", "pet_25", "pet_25", false, 2],
	["26", "gold", "100", "pet_26", "pet_26", false, 2],
	["20", "gold", "100", "pet_20", "pet_20", false, 2],
	["21", "gold", "100", "pet_21", "pet_21", false, 2],
	["31", "gold", "100", "pet_31", "pet_31", false, 2],
	["36", "gold", "100", "pet_36", "pet_36", false, 2],
	["37", "gold", "100", "pet_37", "pet_37", false, 2],
	["41", "gold", "100", "pet_41", "pet_41", false, 2],

	["29", "gold", "150", "pet_29", "pet_29", false, 2],
	["39", "gold", "150", "pet_39", "pet_39", false, 2],
	
	["5", "gold", "150", "pet_5", "pet_5", false, 3],
	["6", "gold", "150", "pet_6", "pet_6", false, 3],
	["7", "gold", "150", "pet_7", "pet_7", false, 3],
	["8", "gold", "150", "pet_8", "pet_8", false, 3],
	["9", "gold", "150", "pet_9", "pet_9", false, 3],
	["10", "gold", "150", "pet_10", "pet_10", false, 3],
	["38", "gold", "150", "pet_38", "pet_38", false, 3],

	["40", "gold", "150", "pet_40", "pet_40", false, 3],
	["42", "gold", "150", "pet_42", "pet_42", false, 3],
	["43", "gold", "150", "pet_43", "pet_43", false, 3],
	["44", "gold", "150", "pet_44", "pet_44", false, 3],
	["45", "gold", "150", "pet_45", "pet_45", false, 3],
	["18", "gold", "150", "pet_18", "pet_18", false, 3],
	["23", "gold", "150", "pet_23", "pet_23", false, 3],
	["27", "gold", "150", "pet_27", "pet_27", false, 3],
	["22", "gold", "150", "pet_22", "pet_22", false, 3],
	["54", "gold", "150", "pet_54", "pet_54", false, 3],
	["53", "gold", "150", "pet_53", "pet_53", false, 3],
	["34", "gold", "250", "pet_34", "pet_34", false, 4],
	["35", "gold", "250", "pet_35", "pet_35", false, 4],
	["19", "gold", "250", "pet_19", "pet_19", false, 4],
	["28", "gold", "250", "pet_28", "pet_28", false, 5],
	["32", "gold", "250", "pet_32", "pet_32", false, 5],
	["33", "gold", "350", "pet_33", "pet_33", false, 5],
	["55", "gold", "350", "pet_55", "pet_55", false, 5],
	["56", "gold", "350", "pet_56", "pet_56", false, 5],
	["57", "gold", "350", "pet_57", "pet_57", false, 5],

	["46", "gold", "400", "pet_46", "pet_46", false, 5],
	["47", "gold", "425", "pet_47", "pet_47", false, 5],
	["48", "gold", "450", "pet_48", "pet_48", false, 5],
	["49", "gold", "475", "pet_49", "pet_49", false, 5],
	["50", "gold", "500", "pet_50", "pet_50", false, 5],
	["51", "gold", "525", "pet_51", "pet_51", false, 5],
	["52", "gold", "550", "pet_52", "pet_52", false, 5],

	["58", "gold", "400", "pet_58", "pet_58", false, 5],
	["59", "gold", "425", "pet_59", "pet_59", false, 5],
	["60", "gold", "450", "pet_60", "pet_60", false, 5],
	["61", "gold", "475", "pet_61", "pet_61", false, 5],
	["62", "gold", "500", "pet_62", "pet_62", false, 5],
	["63", "gold", "525", "pet_63", "pet_63", false, 5],
	["64", "gold", "550", "pet_64", "pet_64", false, 5],

	["67", "gold", "500", "pet_67", "pet_67", false, 5],
	["68", "gold", "500", "pet_68", "pet_68", false, 5],
	["69", "gold", "500", "pet_69", "pet_69", false, 5],
	["70", "gold", "500", "pet_70", "pet_70", false, 5],
	["71", "gold", "500", "pet_71", "pet_71", false, 5],
	["72", "gold", "500", "pet_72", "pet_72", false, 5],
	["73", "gold", "500", "pet_73", "pet_73", false, 5],


	["1", "gold", "99999999", "pet_1", "pet_1", false, 8], 
	["2", "gold", "99999999", "pet_2", "pet_2", false, 8],
	["3", "gold", "99999999", "pet_3", "pet_3", false, 8],
	["4", "gold", "99999999", "pet_4", "pet_4", false, 8],

	["11", "gold", "99999999", "pet_11", "pet_11", false, 8],
	["12", "gold", "99999999", "pet_12", "pet_12", false, 8],
	["13", "gold", "99999999", "pet_13", "pet_13", false, 8],
	["14", "gold", "99999999", "pet_14", "pet_14", false, 8],
	["15", "gold", "99999999", "pet_15", "pet_15", false, 8],
	["16", "gold", "99999999", "pet_16", "pet_16", false, 8],

	["65", "gold", "99999999", "pet_65", "pet_65", false, 8], 
	["66", "gold", "99999999", "pet_66", "pet_66", false, 8],
	
	["17", "gold", "99999999", "pet_17", "pet_17", false, 8],
	["30", "gold", "99999999", "pet_30", "pet_30", false, 8],
	
]

var Items_gem = [
	// ID ПРЕДМЕТА для проверки или для добавления в базу,ВАЛЮТА,СТОИМОСТЬ,ИКОНКА(именно название png файла),переменная названия в локализации, можно покупать много раз или один раз(проверка на покупку в базе)	
	//["203", "gem", "20000", "chance75", "subscribe_3", true, 6],
	//["202", "gem", "15000", "chance50", "subscribe_2", true, 5],
	//["201", "gem", "10000", "chance25", "subscribe_1", true, 7],
	["111", "gem", "2000", "particle_11", "particle_11", false, 1], 
	["112", "gem", "1500", "particle_12", "particle_12", false, 1], 
	["113", "gem", "1500", "particle_13", "particle_13", false, 1], 
	["114", "gem", "1500", "particle_14", "particle_14", false, 1], 
	["115", "gem", "2000", "particle_15", "particle_15", false, 1], 
	["116", "gem", "1599", "particle_16", "particle_16", false, 1],
	["103", "gem", "2500", "particle_3", "particle_3", false, 1],
	["127", "gem", "3000", "particle_27", "particle_27", false, 1], 
	["128", "gem", "3500", "particle_28", "particle_28", false, 1], 
	["129", "gem", "4000", "particle_29", "particle_29", false, 1], 
	["132", "gem", "4500", "particle_32", "particle_32", false, 1], 
	["133", "gem", "4500", "particle_33", "particle_33", false, 1], 
	["134", "gem", "4500", "particle_34", "particle_34", false, 1], 
	["135", "gem", "4500", "particle_35", "particle_35", false, 1], 
	["144", "gem", "5000", "particle_44", "particle_44", false, 1], 
	["146", "gem", "5000", "particle_46", "particle_46", false, 1], 
	["181", "gem", "5000", "particle_81", "particle_81", false, 5], 
	["182", "gem", "5000", "particle_82", "particle_82", false, 5], 
	["183", "gem", "5000", "particle_83", "particle_83", false, 5], 
	["184", "gem", "5000", "particle_84", "particle_84", false, 5],  

	["117", "gem", "1100", "particle_17", "particle_17", false, 1], 
	["130", "gem", "1100", "particle_30", "particle_30", false, 1], 
	["119", "gem", "1300", "particle_19", "particle_19", false, 1],
	["131", "gem", "1300", "particle_31", "particle_31", false, 1], 
	["118", "gem", "1500", "particle_18", "particle_18", false, 1], 
	["120", "gem", "1700", "particle_20", "particle_20", false, 1], 
	["122", "gem", "1700", "particle_22", "particle_22", false, 1], 
	["124", "gem", "1700", "particle_24", "particle_24", false, 1],
	["126", "gem", "1700", "particle_26", "particle_26", false, 1], 


	["5", "gem", "1100", "pet_5", "pet_5", false, 1],
	["6", "gem", "1100", "pet_6", "pet_6", false, 1],
	["7", "gem", "1100", "pet_7", "pet_7", false, 1],
	["8", "gem", "1100", "pet_8", "pet_8", false, 1],
	["9", "gem", "1100", "pet_9", "pet_9", false, 1],
	["10", "gem", "1100", "pet_10", "pet_10", false, 1],

	["40", "gem", "1700", "pet_40", "pet_40", false, 1],
	["42", "gem", "1700", "pet_42", "pet_42", false, 1],
	["43", "gem", "1700", "pet_43", "pet_43", false, 1],
	["44", "gem", "1700", "pet_44", "pet_44", false, 1],
	["45", "gem", "1700", "pet_45", "pet_45", false, 1],
	["18", "gem", "1700", "pet_18", "pet_18", false, 1],
	["23", "gem", "1700", "pet_23", "pet_23", false, 1],
	["27", "gem", "1700", "pet_27", "pet_27", false, 1],
	["22", "gem", "1700", "pet_22", "pet_22", false, 1],
	["54", "gem", "1700", "pet_54", "pet_54", false, 1],
	["53", "gem", "1700", "pet_53", "pet_53", false, 1],
	["34", "gem", "2100", "pet_34", "pet_34", false, 1],
	["35", "gem", "2100", "pet_35", "pet_35", false, 1],
	["19", "gem", "2100", "pet_19", "pet_19", false, 1],
	["28", "gem", "2100", "pet_28", "pet_28", false, 1],
	["32", "gem", "2100", "pet_32", "pet_32", false, 1],
	["33", "gem", "2500", "pet_33", "pet_33", false, 1],
	["55", "gem", "2500", "pet_55", "pet_55", false, 1],
	["56", "gem", "2500", "pet_56", "pet_56", false, 5],
	["57", "gem", "2500", "pet_57", "pet_57", false, 5],

	["46", "gem", "3000", "pet_46", "pet_46", false, 5],
	["47", "gem", "3250", "pet_47", "pet_47", false, 5],
	["48", "gem", "4000", "pet_48", "pet_48", false, 5],
	["49", "gem", "4500", "pet_49", "pet_49", false, 5],
	["50", "gem", "5000", "pet_50", "pet_50", false, 5],
	["51", "gem", "5250", "pet_51", "pet_51", false, 5],
	["52", "gem", "5500", "pet_52", "pet_52", false, 5],

	["58", "gem", "4000", "pet_58", "pet_58", false, 5],
	["59", "gem", "4250", "pet_59", "pet_59", false, 5],
	["60", "gem", "4500", "pet_60", "pet_60", false, 5],
	["61", "gem", "4750", "pet_61", "pet_61", false, 5],
	["62", "gem", "5000", "pet_62", "pet_62", false, 5],
	["63", "gem", "5250", "pet_63", "pet_63", false, 5],
	["64", "gem", "5500", "pet_64", "pet_64", false, 5],	
]

//////////МАССИВ ЭФФЕКТОВ///////////

var Items_effects = [
	// ID ПРЕДМЕТА для проверки или для добавления в базу,ВАЛЮТА,СТОИМОСТЬ,ИКОНКА(именно название png файла),переменная названия в локализации, можно покупать много раз или один раз(проверка на покупку в базе)
	 
	
	["111", "gold", "150", "particle_11", "particle_11", false, 7], 
	["112", "gold", "75", "particle_12", "particle_12", false, 2], 
	["113", "gold", "75", "particle_13", "particle_13", false, 2], 
	["114", "gold", "75", "particle_14", "particle_14", false, 2], 
	["115", "gold", "75", "particle_15", "particle_15", false, 3], 
	["116", "gold", "75", "particle_16", "particle_16", false, 2],
	["103", "gold", "300", "particle_3", "particle_3", false, 7],
	["127", "gold", "500", "particle_27", "particle_27", false, 3], 
	["128", "gold", "500", "particle_28", "particle_28", false, 3], 
	["129", "gold", "500", "particle_29", "particle_29", false, 4], 
	["132", "gold", "500", "particle_32", "particle_32", false, 4], 
	["133", "gold", "500", "particle_33", "particle_33", false, 4], 
	["134", "gold", "500", "particle_34", "particle_34", false, 4], 
	["135", "gold", "500", "particle_35", "particle_35", false, 4], 
	["144", "gold", "500", "particle_44", "particle_44", false, 5], 
	["146", "gold", "500", "particle_46", "particle_46", false, 5],
	["181", "gold", "500", "particle_81", "particle_81", false, 5], 
	["182", "gold", "500", "particle_82", "particle_82", false, 5], 
	["183", "gold", "500", "particle_83", "particle_83", false, 5], 
	["184", "gold", "500", "particle_84", "particle_84", false, 5],  

	["117", "gold", "50", "particle_17", "particle_17", false, 2], 
	["118", "gold", "50", "particle_18", "particle_18", false, 2], 
	["119", "gold", "50", "particle_19", "particle_19", false, 2], 
	["120", "gold", "50", "particle_20", "particle_20", false, 2], 
	["122", "gold", "50", "particle_22", "particle_22", false, 2], 
	["124", "gold", "500", "particle_24", "particle_24", false, 3],
	["126", "gold", "500", "particle_26", "particle_26", false, 3], 
	["130", "gold", "50", "particle_30", "particle_30", false, 2], 
	["131", "gold", "50", "particle_31", "particle_31", false, 2], 


	["151", "gold", "5000", "particle_51", "particle_51", false, 8], 
	["158", "gold", "5000", "particle_58", "particle_58", false, 8], 
	["159", "gold", "5000", "particle_59", "particle_59", false, 8], 
	["160", "gold", "2000", "particle_60", "particle_60", false, 8], 
	["161", "gold", "2000", "particle_61", "particle_61", false, 8], 
	["162", "gold", "2000", "particle_62", "particle_62", false, 8], 
	["163", "gold", "5000", "particle_63", "particle_63", false, 8], 
	["164", "gold", "5000", "particle_64", "particle_64", false, 8], 
	["165", "gold", "5000", "particle_65", "particle_65", false, 8], 
	["166", "gold", "2000", "particle_66", "particle_66", false, 8], 
	["167", "gold", "2000", "particle_67", "particle_67", false, 8], 
	["168", "gold", "5000", "particle_68", "particle_68", false, 8], 
	["169", "gold", "5000", "particle_69", "particle_69", false, 8], 
	["170", "gold", "2000", "particle_70", "particle_70", false, 8], 
	["171", "gold", "2000", "particle_71", "particle_71", false, 8], 
	//["172", "gold", "99999999", "particle_72", "particle_72", false, 8], 
	["136", "gold", "5000", "particle_36", "particle_36", false, 8],
	["173", "gold", "5000", "particle_73", "particle_73", false, 8], 
	["174", "gold", "5000", "particle_74", "particle_74", false, 8], 
	["175", "gold", "5000", "particle_75", "particle_75", false, 8],



	["138", "gold", "99999999", "particle_38", "particle_38", false, 8], 
	["139", "gold", "99999999", "particle_39", "particle_39", false, 8], 
	["140", "gold", "99999999", "particle_40", "particle_40", false, 8], 
	["141", "gold", "99999999", "particle_41", "particle_41", false, 8], 
	["142", "gold", "99999999", "particle_42", "particle_42", false, 8], 
	["143", "gold", "99999999", "particle_43", "particle_43", false, 8],
	["121", "gold", "99999999", "particle_21", "particle_21", false, 8], 
	["186", "gold", "99999999", "particle_86", "particle_86", false, 8],  
	["125", "gold", "99999999", "particle_25", "particle_25", false, 8],
	["137", "gold", "99999999", "particle_37", "particle_37", false, 8],
	["149", "gold", "99999999", "particle_49", "particle_49", false, 8], 
	["150", "gold", "99999999", "particle_50", "particle_50", false, 8], 
	["105", "gold", "99999999", "particle_5", "particle_5", false, 8], 

	["153", "gold", "99999999", "particle_53", "particle_53", false, 8],
	["152", "gold", "99999999", "particle_52", "particle_52", false, 8],  
	["154", "gold", "99999999", "particle_54", "particle_54", false, 8], 
	["155", "gold", "99999999", "particle_55", "particle_55", false, 8], 
	["156", "gold", "99999999", "particle_56", "particle_56", false, 8], 
	["157", "gold", "99999999", "particle_57", "particle_57", false, 8], 
	["145", "gold", "99999999", "particle_45", "particle_45", false, 8],

	["106", "gold", "99999999", "particle_6", "particle_6", false, 8],
	["102", "gold", "99999999", "particle_2", "particle_2", false, 8], 
	["110", "gold", "99999999", "particle_10", "particle_10", false, 8], 
	["109", "gold", "99999999", "particle_9", "particle_9", false, 8],
	["123", "gold", "99999999", "particle_23", "particle_23", false, 8],  
	

	["107", "gold", "99999999", "particle_7", "particle_7", false, 8], 
	["108", "gold", "99999999", "particle_8", "particle_8", false, 8],
	["104", "gold", "99999999", "particle_4", "particle_4", false, 8], 
	["147", "gold", "99999999", "particle_47", "particle_47", false, 8], 
	["148", "gold", "99999999", "particle_48", "particle_48", false, 8], 
	

	["176", "gold", "99999999", "particle_76", "particle_76", false, 8],  
	["177", "gold", "99999999", "particle_77", "particle_77", false, 8],  
	["178", "gold", "99999999", "particle_78", "particle_78", false, 8],  
	["179", "gold", "99999999", "particle_79", "particle_79", false, 8],  
	["180", "gold", "99999999", "particle_80", "particle_80", false, 8],  
	["185", "gold", "99999999", "particle_85", "particle_85", false, 8],  

	["187", "gold", "99999999", "particle_87", "particle_87", false, 8],  
	["188", "gold", "99999999", "particle_88", "particle_88", false, 8],  
	["189", "gold", "99999999", "particle_89", "particle_89", false, 8],  
	["190", "gold", "99999999", "particle_90", "particle_90", false, 8],  
]

//////////МАССИВ ПОДПИСКИ///////////

var Items_subscribe = [
	// ID ПРЕДМЕТА для проверки или для добавления в базу,ВАЛЮТА,СТОИМОСТЬ,ИКОНКА(именно название png файла),переменная названия в локализации, можно покупать много раз или один раз(проверка на покупку в базе)
	["203", "gold", "1000", "chance75", "subscribe_3", true, 6],
	["202", "gold", "500", "chance50", "subscribe_2", true, 5],
	["201", "gold", "150", "chance25", "subscribe_1", true, 7],
	["204", "gold", "150", "bonus10", "subscribe_4", true, 3],
	//["205", "gold", "99999999", "battlepass", "subscribe_5", true, 7],
]

//////////МАССИВ ВАЛЮТЫ///////////

var Items_currency = [
	// ID ПРЕДМЕТА для проверки или для добавления в базу,ВАЛЮТА,СТОИМОСТЬ,ИКОНКА(именно название png файла),переменная названия в локализации если стоит вначале donate_ то предмет показывает кнопки на патреон..итд, можно покупать много раз или один раз(проверка на покупку в базе)
	["301",  "", "5$", "gold_icon", "donate_5", true], 
	["302", "", "10$", "gold_icon", "donate_10", true],
	["303", "", "15$", "gold_icon", "donate_15", true],
	["304", "", "20$", "gold_icon", "donate_20", true],
	["305", "", "25$", "gold_icon", "donate_25", true],
]
function ToggleShop() {
	player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());
	SetMainCurrency()
    if (toggle === false) {
    	if (cooldown_panel == false) {
	        toggle = true;
	        if (first_time === false) {
	            first_time = false;
	            $("#DonateShopPanel").AddClass("sethidden");
	            InitMainPanel()
				InitItems()
				InitInventory()
				InitShop()
				SwitchTab("MainContainer", "DonateMainButton")
	        }  
	        if ($("#DonateShopPanel").BHasClass("sethidden")) {
	            $("#DonateShopPanel").RemoveClass("sethidden");
	        }
	        $("#DonateShopPanel").AddClass("setvisible");
	        $("#DonateShopPanel").style.visibility = "visible"
	        cooldown_panel = true
	        $.Schedule( 0.503, function(){
	        	cooldown_panel = false
	        })
	    }
    } else {
    	if (cooldown_panel == false) {
	        toggle = false;
	        if ($("#DonateShopPanel").BHasClass("setvisible")) {
	            $("#DonateShopPanel").RemoveClass("setvisible");
	        }
	        $("#DonateShopPanel").AddClass("sethidden");
	        cooldown_panel = true
	        $.Schedule( 0.503, function(){
	        	cooldown_panel = false
	        	$("#DonateShopPanel").style.visibility = "collapse"
			})
		}
    }
}

function InitShop() {
	player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());
	$("#TrollChance").SetPanelEvent('onmouseover', function() {
	    $.DispatchEvent('DOTAShowTextTooltip', $("#TrollChance"), $.Localize( "#shop_trollchance" ) + player_table[2][0] + "%<br>" + $.Localize( "#shop_trollchance_date") + player_table[2][1]); 
	});
	    
	$("#TrollChance").SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', $("#TrollChance"));
	});

	$("#BonusRate").SetPanelEvent('onmouseover', function() {
    $.DispatchEvent('DOTAShowTextTooltip', $("#BonusRate"), $.Localize( "#shop_bonusrate" ) + player_table[3][0] + "%<br>" + $.Localize( "#shop_bonusrate_date") + player_table[3][1]); });
    
	$("#BonusRate").SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', $("#BonusRate"));
	});

	GameEvents.SubscribeProtected( 'shop_set_currency', SetCurrency ); // Установление валюты переменные gold, gem
	GameEvents.SubscribeProtected( 'shop_error_notification', ShopError ); // Вызов ошибки переменная text - название ошибки


	GameEvents.SubscribeProtected( 'shop_reward_request', RewardRequest ); // Показывает полученный предмет

	GameEvents.SubscribeProtected( 'ChestAnimationOpen', ChestAnimationOpen ); // Запускает анимацию
}

function SwitchTab(tab, button) {
	$("#MainContainer").style.visibility = "collapse";
	$("#ItemsContainer").style.visibility = "collapse";
	$("#InventoryContainer").style.visibility = "collapse";
	$("#GemContainer").style.visibility = "collapse";

	$("#DonateMainButton").style.boxShadow = "0px 0px 5px 1px black";
	$("#DonateItemsButton").style.boxShadow = "0px 0px 5px 1px black";
	$("#DonateInventoryButton").style.boxShadow = "0px 0px 5px 1px black";
	

	$("#" + button).style.boxShadow = "0px 0px 2px 0px white";

	InitMainPanel()
	InitItems()
	InitInventory()
	SetMainCurrency()

	$("#" + tab).style.visibility = "visible";
}

function SwitchShopTab(tab, button) {
	$("#AllDonateItems").style.visibility = "collapse";
	$("#PetsDonateItems").style.visibility = "collapse";
	$("#EffectsDonateItems").style.visibility = "collapse";
	$("#GemDonateItems").style.visibility = "collapse";
	$("#SubscribeDonateItems").style.visibility = "collapse";
	$("#ChestDonateItems").style.visibility = "collapse";
	$("#SkinDonateItems").style.visibility = "collapse";
	$("#TowerDonateItems").style.visibility = "collapse";
	$("#WispDonateItems").style.visibility = "collapse";
	
	$("#SoundsDonateItems").style.visibility = "collapse";
	$("#SpraysonateItems").style.visibility = "collapse";

	for (var i = 0; i < $("#MenuItems").GetChildCount(); i++) {
		$("#MenuItems").GetChild(i).style.boxShadow = "0px 0px 1px 1px black";
	}

	$("#" + button).style.boxShadow = "0px 0px 1px 1px white";

	InitMainPanel()
	InitItems()
	InitInventory()
	SetMainCurrency()

	$("#" + tab).style.visibility = "visible";
}

function SwitchInventoryShopTab(tab, button) {
	$("#CouriersPanel").style.visibility = "collapse";
	$("#EffectsPanel").style.visibility = "collapse";
	$("#ChestsPanel").style.visibility = "collapse";
	$("#SkinPanel").style.visibility = "collapse";
	$("#TowerPanel").style.visibility = "collapse";
	$("#WispPanel").style.visibility = "collapse";
	for (var i = 0; i < $("#MenuInventory").GetChildCount(); i++) {
		$("#MenuInventory").GetChild(i).style.boxShadow = "0px 0px 1px 1px black";
	}

	$("#" + button).style.boxShadow = "0px 0px 1px 1px white";

	InitMainPanel()
	InitItems()
	InitInventory()
	SetMainCurrency()

	$("#" + tab).style.visibility = "visible";
}


function InitMainPanel() {
	$('#PopularityRecomDonateItems').RemoveAndDeleteChildren()
	for (var i = 0; i < Items_recomended.length; i++) {
		CreateItemInMain($('#PopularityRecomDonateItems'), Items_recomended, i)
	}
	$("#ChestItemText").text = $.Localize("#" +  Items_ADS[0][0] )
	$("#AdsItemText").text = $.Localize("#" +  Items_ADS[1][0] )
	$("#AdsChests").style.backgroundImage = 'url("file://{images}/custom_game/shop/ads/' + Items_ADS[0][1] + '.png")';
	$("#AdsItem_1").style.backgroundImage = 'url("file://{images}/custom_game/shop/ads/' + Items_ADS[1][1] + '.png")';
	$("#AdsChests").style.backgroundSize = "100% 100%"
	$("#AdsItem_1").style.backgroundSize = "100% 100%"
}

function InitItems() {
	$('#AllDonateItems').RemoveAndDeleteChildren()
	$('#PetsDonateItems').RemoveAndDeleteChildren()
	$('#EffectsDonateItems').RemoveAndDeleteChildren()
	$('#SubscribeDonateItems').RemoveAndDeleteChildren()
	$('#GemDonateItems').RemoveAndDeleteChildren()
	$('#ChestDonateItems').RemoveAndDeleteChildren()
	$('#SkinDonateItems').RemoveAndDeleteChildren()
	$('#TowerDonateItems').RemoveAndDeleteChildren()
	$('#WispDonateItems').RemoveAndDeleteChildren()

	$('#SoundsDonateItems').RemoveAndDeleteChildren()
	$('#SpraysonateItems').RemoveAndDeleteChildren()

	for (var i = 0; i < Items_pets.length; i++) {
		CreateItemInShop($('#AllDonateItems'), Items_pets, i)
		CreateItemInShop($('#PetsDonateItems'), Items_pets, i)
	}
	for (var i = 0; i < Items_effects.length; i++) {
 		CreateItemInShop($('#AllDonateItems'), Items_effects, i)
 		CreateItemInShop($('#EffectsDonateItems'), Items_effects, i)
	}

	for (var i = 0; i < Items_subscribe.length; i++) {
 		CreateItemInShop($('#AllDonateItems'), Items_subscribe, i)
 		CreateItemInShop($('#SubscribeDonateItems'), Items_subscribe, i)
	}
	for (var i = 0; i < Items_gem.length; i++) {
		CreateItemInShop($('#AllDonateItems'), Items_gem, i)
		CreateItemInShop($('#GemDonateItems'), Items_gem, i)
   }

   for (var i = 0; i < chests_table.length; i++) {
		CreateChestInShop($('#AllDonateItems'), chests_table, i)
		CreateChestInShop($('#ChestDonateItems'), chests_table, i)
   }

   for (var i = 0; i < Items_skin.length; i++) {
		CreateItemInShop($('#AllDonateItems'), Items_skin, i)
		CreateItemInShop($('#SkinDonateItems'), Items_skin, i)
	}

	for (var i = 0; i < Items_tower.length; i++) {
		CreateItemInShop($('#AllDonateItems'), Items_tower, i)
		CreateItemInShop($('#TowerDonateItems'), Items_tower, i)
	}

	for (var i = 0; i < Items_wisp.length; i++) {
		CreateItemInShop($('#AllDonateItems'), Items_wisp, i)
		CreateItemInShop($('#WispDonateItems'), Items_wisp, i)
	}

	for (var i = 0; i < Items_sounds.length; i++) {
		CreateItemInShop($('#AllDonateItems'), Items_sounds, i)
		CreateItemInShop($('#SoundsDonateItems'), Items_sounds, i)
	}

	for (var i = 0; i < Items_sprays.length; i++) {
		CreateItemInShop($('#AllDonateItems'), Items_sprays, i)
		CreateItemInShop($('#SpraysonateItems'), Items_sprays, i)
	}

}

function InitInventory() {
	player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());
	$('#CouriersPanel').RemoveAndDeleteChildren()
	$('#EffectsPanel').RemoveAndDeleteChildren()
	$('#ChestsPanel').RemoveAndDeleteChildren()
	$('#SkinPanel').RemoveAndDeleteChildren()
	$('#TowerPanel').RemoveAndDeleteChildren()
	$('#WispPanel').RemoveAndDeleteChildren()

	for (var i = 0; i < Items_pets.length; i++) {
		CreateItemInInventory($('#CouriersPanel'), Items_pets, i)
	}
	for (var i = 0; i < Items_effects.length; i++) {
 		CreateItemInInventory($('#EffectsPanel'), Items_effects, i)
	}

	for (var i = 0; i < chests_table.length; i++) {
 		CreateChestInInventory($('#ChestsPanel'), chests_table, i)
	}
	for (var i = 0; i < Items_skin.length; i++) {
		CreateItemInInventory($('#SkinPanel'), Items_skin, i)
   }
   for (var i = 0; i < Items_tower.length; i++) {
	CreateItemInInventory($('#TowerPanel'), Items_tower, i)
	}
	for (var i = 0; i < Items_wisp.length; i++) {
		CreateItemInInventory($('#WispPanel'), Items_wisp, i)
		}
}

	// ID Cундука, валюта, стоимость, иконка, локализация, массив шмоток в сундуке
	//["500", "gold", "450", "chest_rare", ["103", "127", "132", "133"] ],


function CreateChestInInventory(panel, table, i) {
	for ( var chest in player_table[4] )
	{
		if (player_table[4][chest][1] == table[i][0]) {
	
	
		 	var item_chest = $.CreatePanel("Panel", panel, "item_chest_" + table[i][0]);
			item_chest.AddClass("ItemChest");
			
			SetOpenChestPanel(item_chest, table[i])
	
			var ItemImage = $.CreatePanel("Panel", item_chest, "");
			ItemImage.AddClass("ItemImage");
			ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[i][3] + '.png")';
			ItemImage.style.backgroundSize = "contain"
	
			var ItemName = $.CreatePanel("Label", item_chest, "ItemName");
			ItemName.AddClass("ItemName");
			ItemName.text = $.Localize("#" + table[i][3] )
	
			var CountChest = $.CreatePanel("Label", item_chest, "CountChest");
			CountChest.AddClass("CountChest");
			CountChest.text = $.Localize( "#shop_chest_count" ) + " " + player_table[4][chest][2]
	
			var OpenChestPanel = $.CreatePanel("Panel", item_chest, "OpenChestPanel");
			OpenChestPanel.AddClass("OpenChestPanel");
	
			var ItemPrice = $.CreatePanel("Panel", OpenChestPanel, "ItemPrice");
			ItemPrice.AddClass("ItemPrice");
	
			var PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
			PriceLabel.AddClass("PriceLabel");
			PriceLabel.text = $.Localize( "#shop_open" )
	
		}
	}
}







function CreateItemInInventory(panel, table, i) {

	// player_table - Это таблица которая имеет в себе названия всех покупных предметов у игрока !!!
	// Здесь я проверяю питомцев в магазине и питомцев у игрока и добавляю их в инвентарь игрока

	for ( var item in player_table[1] )
    {
		if (item == table[i][0]) {
		 	var Recom_item = $.CreatePanel("Panel", panel, "item_inventory_" + table[i][0]);
			Recom_item.AddClass("ItemInventory");
			SetItemInventory(Recom_item, table[i])

			var ItemImage = $.CreatePanel("Panel", Recom_item, "");
			ItemImage.AddClass("ItemImage");
			ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[i][3] + '.png")';
			ItemImage.style.backgroundSize = "contain"

			var ItemName = $.CreatePanel("Label", Recom_item, "ItemName");
			ItemName.AddClass("ItemName");
			ItemName.text = $.Localize("#" +  table[i][4] )

			var BuyItemPanel = $.CreatePanel("Panel", Recom_item, "BuyItemPanel");
			BuyItemPanel.AddClass("BuyItemPanel");

			var ItemPrice = $.CreatePanel("Panel", BuyItemPanel, "ItemPrice");
			ItemPrice.AddClass("ItemPrice");

			var PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
			PriceLabel.AddClass("PriceLabel");
			PriceLabel.text = $.Localize( "#shop_activate" )

			UpdateItemActivate(table[i][0])	
		}
	}
}






function CreateItemInMain(panel, table, i) {


	// player_table - Это таблица которая имеет в себе названия всех покупных предметов у игрока !!!
	// Здесь добавляются предметы на главный экран

	var Recom_item = $.CreatePanel("Panel", panel, "");
	Recom_item.AddClass("RecomItem");







	SetItemBuyFunction(Recom_item, table[i])

	var ItemImage = $.CreatePanel("Panel", Recom_item, "");
	ItemImage.AddClass("ItemImage");
	ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[i][3] + '.png")';
	ItemImage.style.backgroundSize = "contain"

	var ItemName = $.CreatePanel("Label", Recom_item, "");
	ItemName.AddClass("ItemName");
	ItemName.text = $.Localize("#" +  table[i][4] )

	var BuyItemPanel = $.CreatePanel("Panel", Recom_item, "BuyItemPanel");
	BuyItemPanel.AddClass("BuyItemPanel");

	if (table[i][6] == "1") {
		BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b0c3d9 ), to( #808d9c ))';
	} else if (table[i][6] == "2") {
		BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #5e98d9 ), to( #41648c ))';
	} else if (table[i][6] == "3") {
		BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #4b69ff ), to( #464e75 ))';
	} else if (table[i][6] == "4") {
		BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
	} else if (table[i][6] == "5") {
		BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #d32ce6 ), to( #65196e ))';
	} else if (table[i][6] == "6") {
		BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b28a33 ), to( #664c15 ))';
	} else if (table[i][6] == "7") {
		BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #ade55c ), to( #426314 ))';
	} else if (table[i][6] == "8") {
		BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #eb4b4b ), to( #571212 ))';
	}



	var ItemPrice = $.CreatePanel("Panel", BuyItemPanel, "ItemPrice");
	ItemPrice.AddClass("ItemPrice");

	var PriceIcon = $.CreatePanel("Panel", ItemPrice, "PriceIcon");
	PriceIcon.AddClass("PriceIcon" + table[i][1]);

	var PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
	PriceLabel.AddClass("PriceLabel");
	PriceLabel.text = table[i][2]
	
	for ( var item in player_table[1] )
    {
       	if (item == table[i][0]) {
       		Recom_item.SetPanelEvent("onactivate", function() {} );
			BuyItemPanel.style.backgroundColor = "gray"
			PriceLabel.text = $.Localize( "#shop_bought" )
			PriceIcon.DeleteAsync( 0 );
       	}
    }
}



	// ID Cундука, валюта, стоимость, локализация, иконка, массив шмоток в сундуке
	//["500", "gold", "450", "chest_rare", chest_rare", ["103", "127", "132", "133"] ],



function CreateChestInShop(panel, table, i) {

	// player_table - Это таблица которая имеет в себе названия всех покупных предметов у игрока !!!
	// Здесь добавляются предметы в нужную вкладку магазина
	if(table[i][2] != "99999999")
	{
		var Recom_item = $.CreatePanel("Panel", panel, "");
		Recom_item.AddClass("ItemShop");
	
		var ItemImage = $.CreatePanel("Panel", Recom_item, "");
		ItemImage.AddClass("ItemImage");
		ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[i][4] + '.png")';
		ItemImage.style.backgroundSize = "contain"

		var ItemName = $.CreatePanel("Label", Recom_item, "ItemName");
		ItemName.AddClass("ItemName");
		ItemName.text = $.Localize("#" +  table[i][3] )
	
		var BuyItemPanel = $.CreatePanel("Panel", Recom_item, "BuyItemPanel");
		BuyItemPanel.AddClass("BuyItemPanel");
	
	
	
		SetItemBuyFunction(Recom_item, table[i])
	
	
		var ItemPrice = $.CreatePanel("Panel", BuyItemPanel, "ItemPrice");
		ItemPrice.AddClass("ItemPrice");
	
		var PriceIcon = $.CreatePanel("Panel", ItemPrice, "PriceIcon");
		PriceIcon.AddClass("PriceIcon" + table[i][1]);
	
		var PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
		PriceLabel.AddClass("PriceLabel");
		PriceLabel.text = table[i][2]
	}

}








function CreateItemInShop(panel, table, i) {

	// player_table - Это таблица которая имеет в себе названия всех покупных предметов у игрока !!!
	// Здесь добавляются предметы в нужную вкладку магазина
	if(table[i][2] != "999999999")
	{
		var Recom_item = $.CreatePanel("Panel", panel, "");
		Recom_item.AddClass("ItemShop");
	
		var ItemImage = $.CreatePanel("Panel", Recom_item, "");
		ItemImage.AddClass("ItemImage");
		ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[i][3] + '.png")';
		ItemImage.style.backgroundSize = "contain"
		ItemImage.style.backgroundRepeat = "no-repeat"
		ItemImage.style.backgroundPosition= "center"
		var ItemName = $.CreatePanel("Label", Recom_item, "ItemName");
		ItemName.AddClass("ItemName");
		ItemName.text = $.Localize("#" +  table[i][4] )
	
		var BuyItemPanel = $.CreatePanel("Panel", Recom_item, "BuyItemPanel");
		BuyItemPanel.AddClass("BuyItemPanel");
	
		if (table[i][6] == "1") {
			BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b0c3d9 ), to( #808d9c ))';
		} else if (table[i][6] == "2") {
			BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #5e98d9 ), to( #41648c ))';
		} else if (table[i][6] == "3") {
			BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #4b69ff ), to( #464e75 ))';
		} else if (table[i][6] == "4") {
			BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		} else if (table[i][6] == "5") {
			BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #d32ce6 ), to( #65196e ))';
		} else if (table[i][6] == "6") {
			BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b28a33 ), to( #664c15 ))';
		} else if (table[i][6] == "7") {
			BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #ade55c ), to( #426314 ))';
		} else if (table[i][6] == "8") {
			BuyItemPanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #eb4b4b ), to( #571212 ))';
		}
	
		SetItemBuyFunction(Recom_item, table[i])
	
	
	
	
		var ItemPrice = $.CreatePanel("Panel", BuyItemPanel, "ItemPrice");
		ItemPrice.AddClass("ItemPrice");
	
		var PriceIcon = $.CreatePanel("Panel", ItemPrice, "PriceIcon");
		PriceIcon.AddClass("PriceIcon" + table[i][1]);
	
		var PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
		PriceLabel.AddClass("PriceLabel");
		PriceLabel.text = table[i][2]
	
		if(table[i][2] == "9999999")
		{
			Recom_item.SetPanelEvent("onactivate", function() {} );
			BuyItemPanel.style.backgroundColor = "Indigo"
			PriceLabel.text = $.Localize( "#shop_gold" )
			PriceIcon.DeleteAsync( 0 );
		}
		else if(table[i][2] == "99999999")
		{
			Recom_item.SetPanelEvent("onactivate", function() {} );
			BuyItemPanel.style.backgroundColor = "SlateBlue"
			PriceLabel.text = $.Localize( "#shop_event" )
			PriceIcon.DeleteAsync( 0 );
		}
		for ( var item in player_table[1] )
		{
			   if (item == table[i][0]) {
				   Recom_item.SetPanelEvent("onactivate", function() {} );
				BuyItemPanel.style.backgroundColor = "gray"
				PriceLabel.text = $.Localize( "#shop_bought" )
				PriceIcon.DeleteAsync( 0 );
			   }
		}
	}

}


function CloseItemInfo(){
  	$("#info_item_buy").style.visibility = "collapse"
  	$("#ItemInfoBody").RemoveAndDeleteChildren()
}

function BuyCurrencyPanelActive(){

	$("#info_item_buy").style.visibility = "visible"

	$("#ItemNameInfo").text = $.Localize( "#buy_currency" )

	var Panel_for_desc = $.CreatePanel("Label", $("#ItemInfoBody"), "Panel_for_desc");
	Panel_for_desc.AddClass("Panel_for_desc");

	var Item_desc = $.CreatePanel("Label", Panel_for_desc, "Item_desc");
	Item_desc.AddClass("Item_desc");
	Item_desc.text = $.Localize( "#buy_currency_description" )

	var columns = $.CreatePanel("Panel", $("#ItemInfoBody"), "columns");
	columns.AddClass("columns_donate");

	var column_1 = $.CreatePanel("Panel", columns, "column_1");
	column_1.AddClass("column_donate");

	var column_2 = $.CreatePanel("Panel", columns, "column_2");
	column_2.AddClass("column_donate");

	$.CreatePanelWithProperties("Label", column_1, "PatreonButton", { onactivate: `ExternalBrowserGoToURL(${button_donate_link_1});`, text: "Patreon" });
	$.CreatePanelWithProperties("Label", column_1, "Paypal", { onactivate: `ExternalBrowserGoToURL(${button_donate_link_2});`, text: "PayPal" });
	$.CreatePanelWithProperties("Label", column_2, "Discord", { onactivate: `ExternalBrowserGoToURL(${button_donate_link_4});`, text: "TvE Shop" });
	$.CreatePanelWithProperties("Label", column_2, "DonateStream", { onactivate: `ExternalBrowserGoToURL(${button_donate_link_3});`, text: "DonStream" });
}


function SetItemBuyFunction(panel, table){
	// Проверяет если это курьер или эффект то создает превью при наведении ( В МАГАЗИНЕ )

	if (table[4].indexOf("pet") == 0) {
		panel.SetPanelEvent("onmouseover", function() { 
		//	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "PreviewItemTooltipPet"+table[0], "file://{resources}/layout/custom_game/pets_tooltips.xml", "num="+table[0]);
		})

		panel.SetPanelEvent("onmouseout", function() { 
		//	$.DispatchEvent( "UIHideCustomLayoutTooltip", panel, "PreviewItemTooltipPet"+table[0]);
		})
	} else if (table[4].indexOf("particle") == 0) {
		panel.SetPanelEvent("onmouseover", function() { 
		//	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "PreviewItemTooltipParticle"+table[0], "file://{resources}/layout/custom_game/particles_tooltips.xml", "num="+table[0]);
		})

		panel.SetPanelEvent("onmouseout", function() { 
		//	$.DispatchEvent( "UIHideCustomLayoutTooltip", panel, "PreviewItemTooltipParticle"+table[0]);
		})
	}else if (table[4].indexOf("pet") == 0) {
			panel.SetPanelEvent("onmouseover", function() { 
			//	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "PreviewItemTooltipParticle"+table[0], "file://{resources}/layout/custom_game/particles_tooltips.xml", "num="+table[0]);
			})
	
			panel.SetPanelEvent("onmouseout", function() { 
			//	$.DispatchEvent( "UIHideCustomLayoutTooltip", panel, "PreviewItemTooltipParticle"+table[0]);
			})
	}


	// Создается панель с уточнением нужно ли купить предмет
    panel.SetPanelEvent("onactivate", function() { 
    	$("#info_item_buy").style.visibility = "visible"

    	$("#ItemNameInfo").text = $.Localize("#" +  table[4] )

		$("#ItemInfoBody").style.flowChildren = "down"

		var Panel_for_desc = $.CreatePanel("Label", $("#ItemInfoBody"), "Panel_for_desc");
		Panel_for_desc.AddClass("Panel_for_desc");

		var Item_desc = $.CreatePanel("Label", Panel_for_desc, "Item_desc");
		Item_desc.AddClass("Item_desc");
		var str = table[4].replace(/[^a-zа-яё]/gi, '');
		Item_desc.text = $.Localize("#" + str + "_description" )

		if (table[4].indexOf("chest") == 0) {

			var ChestItemPreview = $.CreatePanel("Panel", $("#ItemInfoBody"), "ChestItemPreview");
			ChestItemPreview.AddClass("ChestItemPreview");


			for (var i = 0; i < Items_sounds.length; i++) {
				CreateItemInChestPreview(ChestItemPreview, Items_sounds, i, table)
		    }
			for (var i = 0; i < Items_sprays.length; i++) {
				CreateItemInChestPreview(ChestItemPreview, Items_sprays, i, table)
		    }
			for (var i = 0; i < Items_effects.length; i++) {
				CreateItemInChestPreview(ChestItemPreview, Items_effects, i, table)
			}
			for (var i = 0; i < Items_pets.length; i++) {
				CreateItemInChestPreview(ChestItemPreview, Items_pets, i, table)
			}
			for (var i = 0; i < Items_subscribe.length; i++) {
				CreateItemInChestPreview(ChestItemPreview, Items_subscribe, i, table)
			}
			for (var i = 0; i < Items_skin.length; i++) {
				CreateItemInChestPreview(ChestItemPreview, Items_skin, i, table)
		    }
			for (var i = 0; i < Items_gem.length; i++) {
				CreateItemInChestPreview(ChestItemPreview, Items_gem, i, table)
		    }

		    CreateItemCurrencyPreview(ChestItemPreview, table[6][1], table[7], table[6][0])
		}

		var BuyItemPanel = $.CreatePanel("Panel", $("#ItemInfoBody"), "BuyItemPanel");
		BuyItemPanel.AddClass("BuyItemPanelInfo");

		var PriceLabel = $.CreatePanel("Label", BuyItemPanel, "PriceLabel");
		PriceLabel.AddClass("PriceLabelInfo");
		PriceLabel.text = $.Localize( "#shop_buy" )

		BuyItemPanel.SetPanelEvent("onactivate", function() { BuyItemFunction(panel, table); CloseItemInfo(); } );

    } );  
}




function SetItemInventory(panel, table) {
	// Проверяет если это курьер или эффект то создает превью при наведении (В ИНВЕНТАРЕ)
	if (table[4].indexOf("pet") == 0) {
		panel.SetPanelEvent("onmouseover", function() { 
		//	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "PreviewItemTooltipPet"+table[0], "file://{resources}/layout/custom_game/pets_tooltips.xml", "num="+table[0]);
		})
		panel.SetPanelEvent("onmouseout", function() { 
		//	$.DispatchEvent( "UIHideCustomLayoutTooltip", panel, "PreviewItemTooltipPet"+table[0]);
		})
		panel.SetPanelEvent("onactivate", function() { 
	 		SelectCourier(table[0])
	    });
	} 
	else if (table[4].indexOf("particle") == 0) {
		panel.SetPanelEvent("onmouseover", function() { 
		//	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "PreviewItemTooltipParticle"+table[0], "file://{resources}/layout/custom_game/particles_tooltips.xml", "num="+table[0]);
		})
		panel.SetPanelEvent("onmouseout", function() { 
		//	$.DispatchEvent( "UIHideCustomLayoutTooltip", panel, "PreviewItemTooltipParticle"+table[0]);
		})
		panel.SetPanelEvent("onactivate", function() { 
	 		SelectParticle(table[0])
	    });
	}
	else if (table[4].indexOf("skin") == 0 && table[4].indexOf("skin_wisp") != 0) {
		panel.SetPanelEvent("onmouseover", function() { 
		//	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "PreviewItemTooltipParticle"+table[0], "file://{resources}/layout/custom_game/particles_tooltips.xml", "num="+table[0]);
		})
		panel.SetPanelEvent("onmouseout", function() { 
		//	$.DispatchEvent( "UIHideCustomLayoutTooltip", panel, "PreviewItemTooltipParticle"+table[0]);
		})
		panel.SetPanelEvent("onactivate", function() { 
	 		SelectSkin(table[0])
	    });
	}
	else if (table[4].indexOf("skin_wisp") == 0 ) {
		panel.SetPanelEvent("onmouseover", function() { 
		//	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "PreviewItemTooltipParticle"+table[0], "file://{resources}/layout/custom_game/particles_tooltips.xml", "num="+table[0]);
		})
		panel.SetPanelEvent("onmouseout", function() { 
		//	$.DispatchEvent( "UIHideCustomLayoutTooltip", panel, "PreviewItemTooltipParticle"+table[0]);
		})
		panel.SetPanelEvent("onactivate", function() { 
	 		SelectWisp(table[0])
	    });
	}
	else if (table[4].indexOf("tower") == 0 || table[4].indexOf("true_sight_tower") == 0 || table[4].indexOf("high_true_sight_tower") == 0 || table[4].indexOf("flag") == 0) {
		panel.SetPanelEvent("onmouseover", function() { 
		//	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "PreviewItemTooltipParticle"+table[0], "file://{resources}/layout/custom_game/particles_tooltips.xml", "num="+table[0]);
		})
		panel.SetPanelEvent("onmouseout", function() { 
		//	$.DispatchEvent( "UIHideCustomLayoutTooltip", panel, "PreviewItemTooltipParticle"+table[0]);
		})
		panel.SetPanelEvent("onactivate", function() { 
	 		SelectTower(table)
	    });
	}
}

// ТВОЯ ФУНКЦИЯ НА ВКЛЮЧЕНИЕ/ВЫКЛЮЧЕНИЯ КУРЬЕРА

var courier_selected = null;

function SelectCourier(num)
{
    if (courier_selected != num)
    {

    	for (var i = 0; i < $("#CouriersPanel").GetChildCount(); i++) {
    		$("#CouriersPanel").GetChild(i).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #60842c ), to( #40601d ))"
        	$("#CouriersPanel").GetChild(i).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_activate" )
    	} 

    	$("#item_inventory_"+num).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #84302C ), to( #60321D ))"
        $("#item_inventory_"+num).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_deactivate" )
        GameEvents.SendCustomGameEventToServer( "SelectPets", { id: Players.GetLocalPlayer(),part:num, offp:false, name:num } );
        courier_selected = num;
		GameEvents.SendCustomGameEventToServer( "SetDefaultPets", { id: Players.GetLocalPlayer(),part:String(courier_selected)} );
    }
    else
    {
    	$("#item_inventory_"+courier_selected).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #60842c ), to( #40601d ))"
        $("#item_inventory_"+courier_selected).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_activate" )
        GameEvents.SendCustomGameEventToServer( "SelectPets", { id: Players.GetLocalPlayer(),part:num, offp:true, name:num } );
        courier_selected = null;
		GameEvents.SendCustomGameEventToServer( "SetDefaultPets", { id: Players.GetLocalPlayer(),part:"0"} );
    } 

}

// ТВОЯ ФУНКЦИЯ НА ВКЛЮЧЕНИЕ/ВЫКЛЮЧЕНИЯ Партикла

var particle_selected = null;

function SelectParticle(num)
{
	var numPart = 0
    if (particle_selected != num)
    {

    	for (var i = 0; i < $("#EffectsPanel").GetChildCount(); i++) {
    		$("#EffectsPanel").GetChild(i).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #60842c ), to( #40601d ))"
        	$("#EffectsPanel").GetChild(i).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_activate" )
    	} 

    	$("#item_inventory_"+num).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #84302C ), to( #60321D ))"
        $("#item_inventory_"+num).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_deactivate" )
		numPart = Number(num)-100
        GameEvents.SendCustomGameEventToServer( "SelectPart", { id: Players.GetLocalPlayer(),part:String(numPart), offp:false, name:String(numPart) } );
        particle_selected = num;
		GameEvents.SendCustomGameEventToServer( "SetDefaultPart", { id: Players.GetLocalPlayer(),part:String(numPart)} );
    }
    else
    {
    	$("#item_inventory_"+particle_selected).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #60842c ), to( #40601d ))"
        $("#item_inventory_"+particle_selected).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_activate" )
        GameEvents.SendCustomGameEventToServer( "SelectPart", { id: Players.GetLocalPlayer(),part:String(numPart) , offp:true, name:String(numPart)  } );
        particle_selected = null;
		GameEvents.SendCustomGameEventToServer( "SetDefaultPart", { id: Players.GetLocalPlayer(),part:"0"} );
    }	
}

var skin_selected = null;

function SelectSkin(num)
{
    if (skin_selected != num)
    {

    	for (var i = 0; i < $("#SkinPanel").GetChildCount(); i++) {
    		$("#SkinPanel").GetChild(i).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #60842c ), to( #40601d ))"
        	$("#SkinPanel").GetChild(i).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_activate" )
    	} 

    	$("#item_inventory_"+num).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #84302C ), to( #60321D ))"
        $("#item_inventory_"+num).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_deactivate" )
        GameEvents.SendCustomGameEventToServer( "SelectSkin", { id: Players.GetLocalPlayer(),part:String(num), offp:false, name:String(num) } );
        skin_selected = num;
		GameEvents.SendCustomGameEventToServer( "SetDefaultSkin", { id: Players.GetLocalPlayer(),part:String(num)} );
    }
    else
    {
    	$("#item_inventory_"+skin_selected).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #60842c ), to( #40601d ))"
        $("#item_inventory_"+skin_selected).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_activate" )
        GameEvents.SendCustomGameEventToServer( "SelectSkin", { id: Players.GetLocalPlayer(),part:String(num) , offp:true, name:String(num)  } );
        skin_selected = null;
		GameEvents.SendCustomGameEventToServer( "SetDefaultSkin", { id: Players.GetLocalPlayer(),part:"0"} );
    }	
}

var tower_selected = null;

function SelectTower(table)
{
	var num = table[0];
	var type = table[4];
    if (tower_selected != num)
    {
		for (var i = 0; i < $("#TowerPanel").GetChildCount(); i++) {
			if ($("#TowerPanel").GetChild(i).FindChildTraverse("ItemName").text == $.Localize("#" + type))
			{
				$("#TowerPanel").GetChild(i).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #60842c ), to( #40601d ))"
				$("#TowerPanel").GetChild(i).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_activate" )
			}
    		
    	} 

    	$("#item_inventory_"+num).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #84302C ), to( #60321D ))"
        $("#item_inventory_"+num).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_deactivate" )
        GameEvents.SendCustomGameEventToServer( "SelectSkinTower", { id: Players.GetLocalPlayer(),part:String(num), offp:false, name:String(num),type: type } );
        tower_selected = num;
		GameEvents.SendCustomGameEventToServer( "SetDefaultSkinTower", { id: Players.GetLocalPlayer(),part:String(num),type: type } );
    }
    else
    {
    	$("#item_inventory_"+tower_selected).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #60842c ), to( #40601d ))"
        $("#item_inventory_"+tower_selected).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_activate" )
        GameEvents.SendCustomGameEventToServer( "SelectSkinTower", { id: Players.GetLocalPlayer(),part:String(num) , offp:true, name:String(num),type: type   } );
        tower_selected = null;
		GameEvents.SendCustomGameEventToServer( "SetDefaultSkinTower", { id: Players.GetLocalPlayer(),part:"0",type: type } );
    }	
}
var wisp_selected = null
function SelectWisp(num)
{
	if (wisp_selected != num)
    {
    	for (var i = 0; i < $("#WispPanel").GetChildCount(); i++) {
    		$("#WispPanel").GetChild(i).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #60842c ), to( #40601d ))"
        	$("#WispPanel").GetChild(i).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_activate" )
    	} 

    	$("#item_inventory_"+num).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #84302C ), to( #60321D ))"
        $("#item_inventory_"+num).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_deactivate" )
        GameEvents.SendCustomGameEventToServer( "SelectSkinWisp", { id: Players.GetLocalPlayer(),part:String(num), offp:false, name:String(num) } );
        wisp_selected = num;
		GameEvents.SendCustomGameEventToServer( "SetDefaultSkinWisp", { id: Players.GetLocalPlayer(),part:String(num)} );
    }
    else
    {
    	$("#item_inventory_"+wisp_selected).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #60842c ), to( #40601d ))"
        $("#item_inventory_"+wisp_selected).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_activate" )
        GameEvents.SendCustomGameEventToServer( "SelectSkinWisp", { id: Players.GetLocalPlayer(),part:String(num) , offp:true, name:String(num)  } );
        wisp_selected = null;
		GameEvents.SendCustomGameEventToServer( "SetDefaultSkinWisp", { id: Players.GetLocalPlayer(),part:"0"} );
    }	
}


//////////// ФУНКЦИЯ ПОКУПКИ /////////

function BuyItemFunction(panel, table) {
	if ((table[1] == "gold" && Number(table[2]) <= Number(player_table[0][0])) || (table[1] == "gem" && Number(table[2]) <= Number(player_table[0][1])) && Number(table[2]) != "999999") 
	{
		GameEvents.SendCustomGameEventToServer( "BuyShopItem", { id: Players.GetLocalPlayer(), TypeDonate: table[1] , Coint: table[2], Nick: table[4], Num: table[0]  } );
		if (table[1] == "gold")
		{
			player_table[0][0] = Number(player_table[0][0]) - Number(table[2])
		}
		else if (table[1] == "gem")
		{
			player_table[0][1] = Number(player_table[0][1]) - Number(table[2])
		}
		SetMainCurrency()
		if ( !RegExp('chest').test(table[4]) & !RegExp('subscribe').test(table[4]))
		{
			panel.SetPanelEvent("onactivate", function() {} );
			panel.FindChildTraverse("BuyItemPanel").style.backgroundColor = "gray"
			panel.FindChildTraverse("PriceLabel").text = $.Localize( "#shop_bought" )
			panel.FindChildTraverse("PriceIcon").DeleteAsync( 0 );
		}
		
		ShopBuy("shop_nice_buy")
	} 
	else  
	{
		ShopError("shop_no_money")
	}

	if (!table[5]) {
		//player_table[1].push(table[0]) // player_table - Это таблица которая имеет в себе названия всех покупных предметов у игрока !!! Здесь добавляется в массив купленный предмет но для js тестил, там в луа надо отправлять название и обновлять net table

		
	}
}

//////////// ФУНКЦИЯ УСТАНОВКИ БАЛАНСА ПРИ ПЕРВОМ ОТКРЫТИИ /////////

function SetMainCurrency() {

	if (player_table[0]) {
		$("#Currency").text = String(player_table[0][0])
		$("#Currency2").text = 	String(player_table[0][1])	
	}

	//var table = CustomNetTables.GetTableValue("players", String(Players.GetLocalPlayer()));
	//if (table) {
	//	$("#Currency").text = table.currency_1
	//	$("#Currency2").text = 	table.currency_2	
	//}
}

//////////// ФУНКЦИЯ УСТАНОВКИ БАЛАНСА ПОСЛЕ ПОКУПКИ /////////

function SetCurrency(data) {
	if (data) {
		if (data.gold) {
			$("#Currency").text = String(data.gold)
		}
		if (data.gem) {
			$("#Currency2").text = 	String(data.gem)	
		}
	}
}

function ShopError(data) {
	$( "#shop_error_panel" ).style.visibility = "visible";

	if (data) {
		$( "#shop_error_label" ).text = $.Localize("#" +  data );
	} else {
		$( "#shop_error_label" ).text = "";
	}
	

	$( "#shop_error_label" ).SetHasClass( "error_visible", false );

	$.Schedule( 2, RemoveError );
}

function RemoveError() {
	$( "#shop_error_panel" ).style.visibility = "collapse";
	$( "#shop_error_label" ).SetHasClass( "error_visible", true );
	$( "#shop_error_label" ).text = "";
}

function ShopBuy(data) {
	$( "#shop_buy_panel" ).style.visibility = "visible";

	if (data) {
		$( "#shop_buy_label" ).text = $.Localize("#" +  data );
	} else {
		$( "#shop_buy_label" ).text = "";
	}
	

	$( "#shop_buy_label" ).SetHasClass( "buy_visible", false );

	$.Schedule( 2, RemoveBuy );
	InitInventory()
	SetMainCurrency()
}

function RemoveBuy() {
	$( "#shop_buy_panel" ).style.visibility = "collapse";
	$( "#shop_buy_label" ).SetHasClass( "buy_visible", true );
	$( "#shop_buy_label" ).text = "";
}



function UpdateItemActivate(id) {
	if (courier_selected !== null) {
		if (id == courier_selected)
		{
    		$("#item_inventory_"+id).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #84302C ), to( #60321D ))"
        	$("#item_inventory_"+id).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_deactivate" )
        }
	}
	if (particle_selected !== null) {
		if (id == particle_selected)
		{
    		$("#item_inventory_"+id).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #84302C ), to( #60321D ))"
        	$("#item_inventory_"+id).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_deactivate" )
        }			
	}
	if (skin_selected !== null) {
		if (id == skin_selected)
		{
    		$("#item_inventory_"+id).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #84302C ), to( #60321D ))"
        	$("#item_inventory_"+id).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_deactivate" )
        }			
	}
	if (tower_selected !== null) {
		if (id == tower_selected)
		{
    		$("#item_inventory_"+id).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #84302C ), to( #60321D ))"
        	$("#item_inventory_"+id).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_deactivate" )
        }			
	}
	if (wisp_selected !== null) {
		if (id == wisp_selected)
		{
    		$("#item_inventory_"+id).FindChildTraverse("BuyItemPanel").style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from( #84302C ), to( #60321D ))"
        	$("#item_inventory_"+id).FindChildTraverse("PriceLabel").text = $.Localize( "#shop_deactivate" )
        }			
	}
}





function CloseOpenChest(){
  	$("#ChestOpenPanelMainClosed").style.visibility = "collapse"
  	$("#ChestBodyInfo").RemoveAndDeleteChildren()
}










function SetOpenChestPanel(panel, table){
	// Создается панель с уточнением нужно ли купить предмет
    panel.SetPanelEvent("onactivate", function() { 
		InitInventory()
    	$("#ChestOpenPanelMainClosed").style.visibility = "visible"

    	$("#ChestName").text = $.Localize("#" +  table[3] )

		var ChestImage = $.CreatePanel("Panel",  $("#ChestBodyInfo"), "");
		ChestImage.AddClass("ChestImageInfo");
		ChestImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[3] + '.png")';
		ChestImage.style.backgroundSize = "100%"


		var OpenChestButton = $.CreatePanel("Panel",  $("#ChestBodyInfo"), "OpenChestButton");
		OpenChestButton.AddClass("OpenChestButton");

		var ChestAllRewardsPanel = $.CreatePanel("Panel",  $("#ChestBodyInfo"), "ChestAllRewardsPanel");
		ChestAllRewardsPanel.AddClass("ChestAllRewardsPanel");

		var OpenChest_Label = $.CreatePanel("Label", OpenChestButton, "OpenChest_Label");
		OpenChest_Label.AddClass("OpenChest_Label");
		OpenChest_Label.text = $.Localize( "#shop_open" )

		for (var i = 0; i < Items_sounds.length; i++) {
			CreateItemInChest(ChestAllRewardsPanel, Items_sounds, i, table)
	    }
		for (var i = 0; i < Items_sprays.length; i++) {
			CreateItemInChest(ChestAllRewardsPanel, Items_sprays, i, table)
	    }
		for (var i = 0; i < Items_effects.length; i++) {
			CreateItemInChest(ChestAllRewardsPanel, Items_effects, i, table)
		}
		for (var i = 0; i < Items_pets.length; i++) {
			CreateItemInChest(ChestAllRewardsPanel, Items_pets, i, table)
		}
		for (var i = 0; i < Items_subscribe.length; i++) {
			CreateItemInChest(ChestAllRewardsPanel, Items_subscribe, i, table)
		}
		for (var i = 0; i < Items_skin.length; i++) {
			CreateItemInChest(ChestAllRewardsPanel, Items_skin, i, table)
	    }
		for (var i = 0; i < Items_gem.length; i++) {
			CreateItemInChest(ChestAllRewardsPanel, Items_gem, i, table)
	    }

		

	    // Последним добавляется валюта золота "gem", gold
	    CreateItemCurrency(ChestAllRewardsPanel, table[6][1], table[7], table[6][0])





		OpenChestButton.SetPanelEvent("onactivate", function() { OpenChest(table); CloseOpenChest(); } );

    } );  
}

function OpenChest(table) {
	chest_opened_time = 0.3
  	$("#chest_opened_animation").RemoveAndDeleteChildren()


	var ChestOpenImage = $.CreatePanel("Panel",  $("#chest_opened_animation"), "ChestOpenImage");
	ChestOpenImage.AddClass("ChestOpenImage");
	ChestOpenImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[3] + '.png")';
	//ChestOpenImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[3] + '.png")';
	ChestOpenImage.style.backgroundSize = "100%"
	ChestOpenImage.style.transform = "scaleX(" + 0 + ')' + " " + 'scaleY(' + 0 +')'

	GameEvents.SendCustomGameEventToServer( "OpenChestAnimation", {chest_id : table[0], PlayerID2: Players.GetLocalPlayer()});

	// Вызывать в луа рандом именно здесь (желательно сделать задержку в 5 секунд может чуть больше и вызвать функцию RewardRequest )

	$("#chest_opened_animation").style.visibility = "visible"
	InitMainPanel()
	InitItems()
	InitInventory()
	SetMainCurrency()
}

function ChestAnimationOpen(data) {
	if (data.time < 4) {
		$("#chest_opened_animation").FindChildTraverse("ChestOpenImage").style.transform = "scaleX(" + data.time/3 + ')' + " " + 'scaleY(' + data.time/3 +')'
	} else {
		$("#chest_opened_animation").FindChildTraverse("ChestOpenImage").style.opacity = "0"
	}
}


// RewardRequest() - нужно вызывать из луа передавать туда иконку награды

function RewardRequest(data) {
	InitInventory() // обновить инвентарь
	SetMainCurrency()
	$("#chest_opened_animation").RemoveAndDeleteChildren()
	var RewardIcon = $.CreatePanel("Panel",  $("#chest_opened_animation"), "RewardIcon");
	RewardIcon.AddClass("ChestOpenImageItem");
	var icon

	if (data.reward) {
		for (var i = 0; i < Items_pets.length; i++) {
			if (Items_pets[i][0] == data.reward) {
				icon = Items_pets[i][3]
			}
		}
		for (var i = 0; i < Items_effects.length; i++) {
			if (Items_effects[i][0] == data.reward) {
				icon = Items_effects[i][3]
			}
		}

		for (var i = 0; i < Items_subscribe.length; i++) {
			if (Items_subscribe[i][0] == data.reward) {
				icon = Items_subscribe[i][3]
			}
		}
		for (var i = 0; i < Items_gem.length; i++) {
			if (Items_gem[i][0] == data.reward) {
				icon = Items_gem[i][3]
			}
	    }
		for (var i = 0; i < Items_skin.length; i++) {
			if (Items_skin[i][0] == data.reward) {
				icon = Items_skin[i][3]
			}
	    }
		for (var i = 0; i < Items_sprays.length; i++) {
			if (Items_sprays[i][0] == data.reward) {
				icon = Items_sprays[i][3]
			}
	    }
		for (var i = 0; i < Items_sounds.length; i++) {
			if (Items_sounds[i][0] == data.reward) {
				icon = Items_sounds[i][3]
			}
	    }
	    if (data.reward == "gold") {
	    	icon = "gold"
	    }
	    if (data.reward == "gem") {
	    	icon = "gem"
	    }
	}

	RewardIcon.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + icon + '.png")';
	RewardIcon.style.backgroundSize = "100%"

	var AcceptButton = $.CreatePanel("Panel",  $("#chest_opened_animation"), "AcceptButton");
	AcceptButton.AddClass("AcceptButton");
	
	var LabelAccept = $.CreatePanel("Label", AcceptButton, "LabelAccept");
	LabelAccept.AddClass("LabelAccept");
	LabelAccept.text = $.Localize( "#shop_accept" )
 
 	// Если нужно что-то передать в закрытие сундука всунь это в closechest
	AcceptButton.SetPanelEvent("onactivate", function() { CloseChest(); } );
	
}

function CloseChest() {
	// Закрытие сундука
	
	InitInventory() // обновить инвентарь
	SetMainCurrency()
	//ToggleShop()
	$("#chest_opened_animation").style.visibility = "collapse"
}




function CreateItemInChest(panel, table, i, table_chest) {

	for ( var chest_items in table_chest[5] ) {

		if (table[i][0] == table_chest[5][chest_items][0] ) {
			if (!panel.FindChildTraverse("item_" + table_chest[5][chest_items][0])) {
				var Chest_in_item = $.CreatePanel("Panel", panel, "item_" + table_chest[5][chest_items][0]);
				Chest_in_item.AddClass("Chest_in_item");

				CreateItemChance(Chest_in_item, $.Localize("#" + "shop_chance") + " " + table_chest[5][chest_items][1] + "%")

			
				var ItemImage = $.CreatePanel("Panel", Chest_in_item, "");
				ItemImage.AddClass("ItemChestImage");
				ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[i][3] + '.png")';
				ItemImage.style.backgroundSize = "100%"

				var RarePanel = $.CreatePanel("Panel", Chest_in_item, "");
				RarePanel.AddClass("RarePanel");



				if (table[i][6] == "1") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b0c3d9 ), to( #808d9c ))';
				} else if (table[i][6] == "2") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #5e98d9 ), to( #41648c ))';
				} else if (table[i][6] == "3") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #4b69ff ), to( #464e75 ))';
				} else if (table[i][6] == "4") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
				} else if (table[i][6] == "5") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #d32ce6 ), to( #65196e ))';
				} else if (table[i][6] == "6") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b28a33 ), to( #664c15 ))';
				} else if (table[i][6] == "7") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #ade55c ), to( #426314 ))';
				} else if (table[i][6] == "8") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #eb4b4b ), to( #571212 ))';
				}

				

			
				var ItemName = $.CreatePanel("Label", RarePanel, "ItemName");
				ItemName.AddClass("ItemChestName");
				ItemName.text = $.Localize("#" +  table[i][4] )
			
				for ( var item in player_table[1] )
				{
					if (item == table_chest[5][chest_items][0]) {
						ItemImage.style.brightness = "0.1"
						ItemImage.style.washColor = "gray"
					}
				}
			}
		}
	}

}














function CreateItemInChestPreview(panel, table, i, table_chest) {

	for ( var chest_items in table_chest[5] ) {

		if (table[i][0] == table_chest[5][chest_items][0] ) {
			if (!panel.FindChildTraverse("item_" + table_chest[5][chest_items][0])) {
				var Chest_in_item = $.CreatePanel("Panel", panel, "item_" + table_chest[5][chest_items][0]);
				Chest_in_item.AddClass("Chest_in_item_preview");

				CreateItemChance(Chest_in_item, $.Localize("#" + "shop_chance") + " " + table_chest[5][chest_items][1] + "%")

			
				var ItemImage = $.CreatePanel("Panel", Chest_in_item, "");
				ItemImage.AddClass("ItemChestImage_preview");
				ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[i][3] + '.png")';
				ItemImage.style.backgroundSize = "100%"

				var RarePanel = $.CreatePanel("Panel", Chest_in_item, "");
				RarePanel.AddClass("RarePanel");



				if (table[i][6] == "1") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b0c3d9 ), to( #808d9c ))';
				} else if (table[i][6] == "2") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #5e98d9 ), to( #41648c ))';
				} else if (table[i][6] == "3") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #4b69ff ), to( #464e75 ))';
				} else if (table[i][6] == "4") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
				} else if (table[i][6] == "5") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #d32ce6 ), to( #65196e ))';
				} else if (table[i][6] == "6") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b28a33 ), to( #664c15 ))';
				} else if (table[i][6] == "7") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #ade55c ), to( #426314 ))';
				} else if (table[i][6] == "8") {
					RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #eb4b4b ), to( #571212 ))';
				}

				

			
				var ItemName = $.CreatePanel("Label", RarePanel, "ItemName");
				ItemName.AddClass("ItemChestName_preview");
				ItemName.text = $.Localize("#" +  table[i][4] )
			
				for ( var item in player_table[1] )
				{
					if (item == table_chest[5][chest_items][0]) {
						ItemImage.style.brightness = "0.1"
						ItemImage.style.washColor = "gray"
					}
				}
			}
		}
	}

}

function CreateItemCurrencyPreview(panel, currency, count, chance) {

	var Chest_in_item = $.CreatePanel("Panel", panel, "item_" + currency);
	Chest_in_item.AddClass("Chest_in_item_preview");

	CreateItemChance(Chest_in_item, $.Localize("#" + "shop_chance") + " " + chance + "%<br>" + $.Localize("#" + "shop_currency_count") + " " + $.Localize("#" + "shop_currency_count_from") + " " + count[0] + " " + $.Localize("#shop_currency_count_to") + " " + count[1])

	var ItemImage = $.CreatePanel("Panel", Chest_in_item, "");
	ItemImage.AddClass("ItemChestImage_preview");
	ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + currency + '.png")';
	ItemImage.style.backgroundSize = "100%"

	var RarePanel = $.CreatePanel("Panel", Chest_in_item, "");
	RarePanel.AddClass("RarePanel");
	RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b28a33 ), to( #664c15 ))';

	var ItemName = $.CreatePanel("Label", RarePanel, "ItemName");
	ItemName.AddClass("ItemChestName_preview");
	ItemName.text = $.Localize( "#shop_currency_" + currency)
}

























function CreateItemCurrency(panel, currency, count, chance) {

	var Chest_in_item = $.CreatePanel("Panel", panel, "item_" + currency);
	Chest_in_item.AddClass("Chest_in_item");

	CreateItemChance(Chest_in_item, $.Localize("#" + "shop_chance") + " " + chance + "%<br>" + $.Localize("#" + "shop_currency_count") + " " + $.Localize("#" + "shop_currency_count_from") + " " + count[0] + " " + $.Localize("#" + "shop_currency_count_to") + " " + count[1])

	var ItemImage = $.CreatePanel("Panel", Chest_in_item, "");
	ItemImage.AddClass("ItemChestImage");
	ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + currency + '.png")';
	ItemImage.style.backgroundSize = "100%"

	var RarePanel = $.CreatePanel("Panel", Chest_in_item, "");
	RarePanel.AddClass("RarePanel");
	RarePanel.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b28a33 ), to( #664c15 ))';

	var ItemName = $.CreatePanel("Label", RarePanel, "ItemName");
	ItemName.AddClass("ItemChestName");
	ItemName.text = $.Localize( "#shop_currency_" + currency)
}



function CreateItemChance(panel, label) {
	panel.SetPanelEvent('onmouseover', function() {
	    $.DispatchEvent('DOTAShowTextTooltip', panel, label); 
	});
	    
	panel.SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', panel);
	});
}
CustomNetTables.SubscribeNetTableListener( "Shop", UpdateShop);


function UpdateShop()
{
	InitMainPanel()
	InitItems()
	InitInventory()
	InitShop()
}

 function IDoNotKnowWhatItIs(){let _0x5a6472=parentHUDElements['FindChildTraverse']('ShopButton'); var player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());if(player_table){if((player_table[0x0][0x0]!=null&player_table[0x0][0x1]!=null) & (player_table[0x0][0x0]!=0x0||player_table[0x0][0x1]>=5)){_0x5a6472&&(_0x5a6472['style']['visibility']='visible');return;}}_0x5a6472&&(_0x5a6472['style']['visibility']='collapse'),$['Schedule'](0x2,IDoNotKnowWhatItIs);}IDoNotKnowWhatItIs();