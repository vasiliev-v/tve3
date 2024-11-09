var toggle = false

GameEvents.SubscribeProtected( 'troll_quest_update', UpdateQuest ); // Обновить квест ( quest_id -- Айди квеста у игрока, current -- Новое значение в этом квесте )

function ToggleInfo()
{
	if (toggle === false) {
		$("#QuestPanelSwap").style.transform = "translateX( 18.3% )"
		$("#SwapPanelIcon").style.transform = "rotateZ(0deg)"
		toggle = true 
	} else {
		$("#QuestPanelSwap").style.transform = "translateX( 0% )"
		$("#SwapPanelIcon").style.transform = "rotateZ(180deg)"
		toggle = false
	}
}


// Массив визуальной информации по заданиям ( его кстати можно передать из луа чтоб не дублировать )

// Айди квеста, название, иконка, награда, максимальное количество для выполнения, УНИКАЛЬНЫЙ ЛИ КВЕСТ 0-обычный,1-батллпасс
var quest_information_table = 
[
	["1", "quest_kill_troll", "quest_kill_troll", "quest_kill_troll_reward", "5",  "0"],
	["2", "quest_kill_troll", "quest_kill_troll", "quest_kill_troll_reward", "5",  "1"],
	["3", "quest_kill_troll", "quest_kill_troll", "quest_kill_troll_reward", "5",  "1"],
]

// Массив игрока, передать надо бы

// Имеет ли батлл пасс (0,1), задания(внутри айди квеста и сколько уже прошел прогресс)

var player_table = 
[
	0,
	[
		["1", "1"],
		["2", "2"],
		["3", "3"],
	]

]



CreateQuests()

function CreateQuests()
{
	let has_battlepass = false
	//quest_information_table = CustomNetTables.GetTableValue("Shop", "bpday");
	//player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[10];

	// есть ли батлл пасс у игрока
	if (player_table) {
		if (player_table[0] != "none")
		{
			has_battlepass = true
		} else {
			has_battlepass = false
		}
	}
	if (quest_information_table) 
	{ 
		for (var i = 1; i <= 3; i++) {
			CreateQuest(quest_information_table[i], has_battlepass) // Создаем квесты игрока
			
		}
		
	}
}

function CreateQuest(quest_player_table, has_battlepass)
{
	let quest_table = null

	if (quest_player_table == null) {
		//$.Msg("У вас нет задания в базе")
		return
	}
	for (var i = 1; i <= Object.keys(player_table[1]).length; i++) {
		if (player_table[1][i][1] == quest_player_table[1])
		{
			quest_table = player_table[1][i]
		}
	}
	
	if (quest_player_table[6] == "1")
	{
		if (!has_battlepass)
		{
			CreateCloseQuest()
			return
		}
	}

	if (quest_table == null) {
		quest_table = ["0",quest_player_table[1] ,"0"]
	}


	var DayQuest = $.CreatePanel("Panel", $("#QuestsPanel"), "quest_id_" + quest_player_table[0]);
	DayQuest.AddClass("DayQuest");

	var QuestIcon = $.CreatePanel("Panel", DayQuest, "");
	QuestIcon.AddClass("QuestIcon");
	QuestIcon.style.backgroundImage = 'url("file://{images}/custom_game/quest/icons/' + quest_player_table[2] + '.png")';
	QuestIcon.style.backgroundSize = "100%"


	// Инфа о квесте 

	var QuestInfo = $.CreatePanel("Panel", DayQuest, "");
	QuestInfo.AddClass("QuestInfo");
	
	var QuestName = $.CreatePanel("Label", QuestInfo, "");
	QuestName.AddClass("QuestName");
	QuestName.text = $.Localize("#" + quest_player_table[1]) // название задания

	var QuestProgress = $.CreatePanel("Panel", QuestInfo, "");
	QuestProgress.AddClass("QuestProgress");

	var QuestProgressBackground = $.CreatePanel("Panel", QuestProgress, "");
	QuestProgressBackground.AddClass("QuestProgressBackground");

	var QuestProgressLine = $.CreatePanel("Panel", QuestProgress, "QuestProgressLine");
	QuestProgressLine.AddClass("QuestProgressLine");

	var percentage = ((quest_player_table[5]-quest_table[2])*100)/quest_player_table[5]
	QuestProgressLine.style['width'] = (100 - percentage) +'%';

	var QuestProgressLabel = $.CreatePanel("Label", QuestProgress, "QuestProgressLabel");
	QuestProgressLabel.AddClass("QuestProgressLabel");
	QuestProgressLabel.text = quest_table[2] + " / " + quest_player_table[5]  // Прогресс квеста

	var BorderLine = $.CreatePanel("Panel", QuestInfo, "");
	BorderLine.AddClass("BorderLine");

	var QuestRewardLabel = $.CreatePanel("Label", QuestInfo, "");
	QuestRewardLabel.AddClass("QuestRewardLabel");
	QuestRewardLabel.text = $.Localize("#" + quest_player_table[4]) // Награда квеста

	///////////////////////

	var QuestSucces = $.CreatePanel("Panel", DayQuest, "");
	QuestSucces.AddClass("QuestSucces");

	var QuestSuccesIcon = $.CreatePanel("Panel", QuestSucces, "QuestSuccesIcon");
	QuestSuccesIcon.AddClass("QuestSuccesIcon");
	QuestSuccesIcon.style.opacity = 0;

	if (Number(quest_table[2]) >= Number(quest_player_table[5]))
	{
		QuestSuccesIcon.style.opacity = 1;
	}
}

function CreateCloseQuest()
{
	//quest_information_table = CustomNetTables.GetTableValue("Shop", "bpday");
	var DayQuest = $.CreatePanel("Panel", $("#QuestsPanel"), "");
	DayQuest.AddClass("DayQuest");

	var QuestIconClose = $.CreatePanel("Panel", DayQuest, "");
	QuestIconClose.AddClass("QuestIconClose");

	var QuestClose = $.CreatePanel("Panel", QuestIconClose, "");
	QuestClose.AddClass("QuestClose");

	var QuestInfo = $.CreatePanel("Panel", DayQuest, "");
	QuestInfo.AddClass("QuestInfo");

	var QuestName = $.CreatePanel("Label", QuestInfo, "");
	QuestName.AddClass("QuestName");
	QuestName.text = "Закрыто" // название задания

	var BorderLine = $.CreatePanel("Panel", QuestInfo, "");
	BorderLine.AddClass("BorderLine");

	var QuestRewardLabel = $.CreatePanel("Label", QuestInfo, "");
	QuestRewardLabel.AddClass("QuestRewardLabel");
	QuestRewardLabel.text = "Необходим Battle Pass" // Награда квеста
}

function UpdateQuest(data)
{
	$("#QuestPanelSwap").style.visiblity = "visible"
	let quest_id = data.quest_id
	let current = data.current
	let quest_table = null
	//quest_information_table = CustomNetTables.GetTableValue("Shop", "bpday");
	for (var i = 1; i < quest_information_table.length; i++) {
		if (Number(quest_information_table[i][0]) == Number(quest_id))
		{
			quest_table = quest_information_table[i]
		}
	}

	if (quest_table == null) {
		//$.Msg("У вас нет задания в базе")
		return
	}

	let quest_panel = $.GetContextPanel().FindChildTraverse("quest_id_" + quest_id)
	if (quest_panel) {
		let percentage = ((quest_table[4]-current)*100)/quest_table[4]
		let QuestProgressLine = quest_panel.FindChildTraverse("QuestProgressLine")
		let QuestProgressLabel = quest_panel.FindChildTraverse("QuestProgressLabel")
		let QuestSuccesIcon = quest_panel.FindChildTraverse("QuestSuccesIcon")

		if (QuestProgressLine)
		{
			QuestProgressLine.style['width'] = (100 - percentage) +'%';
		}
		if (QuestProgressLabel)
		{
			QuestProgressLabel.text = current + " / " + quest_table[4]  // Прогресс квеста
		}
		if (QuestSuccesIcon)
		{
			if (Number(current) >= Number(quest_table[4]))
			{
				QuestSuccesIcon.style.opacity = 1;
			}
		}
	} else {
		//$.Msg("Не найдена панель задания")
	}
}