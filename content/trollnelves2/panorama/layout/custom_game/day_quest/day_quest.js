GameEvents.SubscribeProtected( 'troll_quest_update', UpdateQuest ); // Обновить квест ( quest_id -- Айди квеста у игрока, current -- Новое значение в этом квесте )

function ToggleInfo()
{
	$("#QuestMain").SetHasClass("Open", !$("#QuestMain").BHasClass("Open"))
}

// Массив визуальной информации по заданиям ( его кстати можно передать из луа чтоб не дублировать )
// Айди квеста, название, иконка, награда, максимальное количество для выполнения, УНИКАЛЬНЫЙ ЛИ КВЕСТ 0-обычный, 1-батллпасс
var quest_information_table = 
[
	
]

// Массив игрока, передать надо бы
// Имеет ли батлл пасс (0,1), задания(внутри айди квеста и сколько уже прошел прогресс)
var player_table = 
[
	0,
	[
	
	]
]



function CreateQuests()
{
	let has_battlepass = false;
	quest_information_table = CustomNetTables.GetTableValue("Shop", "bpday");
	player_table[1] = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[10]; 
	player_table[0] = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[15];

	// Проверяем наличие баттлпасса
	if (player_table && player_table[0] && player_table[0][0] !== "none") 
    {
		has_battlepass = true;
	}

	// Проверяем, есть ли квесты в таблице
	if (quest_information_table) 
	{  
		for (var i in quest_information_table)  // Перебор по ключам
        {
			if (quest_information_table[i]) {
				CreateQuest(quest_information_table[i], has_battlepass); // Создаем квест
			}
		}
	}
}

function CreateQuest(quest_player_table, has_battlepass)
{
	let quest_table = null;
	if (!quest_player_table) return;

    let is_locked_quest_battlepass = false;

    if (player_table[1] && player_table[1][1]) 
    {  
        for (var i in player_table[1][1]) // Перебор по ключам
        {
            if (player_table[1][1][i] && player_table[1][1][i][1] == quest_player_table[1])
            { 
                quest_table = player_table[1][1][i];  
				break; // Выход после первого совпадения
            }
        }
    }
	 
	if (quest_player_table[6] == "1" && !has_battlepass)
	{
		is_locked_quest_battlepass = true;
	}

	if (!quest_table) return; 

	let DayQuest = $.CreatePanel("Panel", $("#QuestsPanel"), "quest_id_" + quest_player_table[0]);
	DayQuest.AddClass("DayQuest");
    if (is_locked_quest_battlepass)
    {
        DayQuest.AddClass("LockedQuest");
    }

	let QuestIcon = $.CreatePanel("Panel", DayQuest, "");
	QuestIcon.AddClass("QuestIcon");
	QuestIcon.style.backgroundImage = 'url("file://{images}/custom_game/quest/icons/' + quest_player_table[2] + '.png")';
	QuestIcon.style.backgroundSize = "100%";

	// Инфа о квесте 
	let QuestInfo = $.CreatePanel("Panel", DayQuest, "");
	QuestInfo.AddClass("QuestInfo");
	
	let QuestName = $.CreatePanel("Label", QuestInfo, "");
	QuestName.AddClass("QuestName");

    QuestName.text = is_locked_quest_battlepass ? $.Localize("#quest_locked") : $.Localize("#" + quest_player_table[1]); // название задания

	let QuestProgress = $.CreatePanel("Panel", QuestInfo, "");
	QuestProgress.AddClass("QuestProgress");

	let QuestProgressBackground = $.CreatePanel("Panel", QuestProgress, "");
	QuestProgressBackground.AddClass("QuestProgressBackground");

	let QuestProgressLine = $.CreatePanel("Panel", QuestProgress, "QuestProgressLine");
	QuestProgressLine.AddClass("QuestProgressLine");

	// Проверяем, что данные корректны
	if (quest_table[2] && quest_table[2][2] !== undefined) {
		let percentage = ((quest_player_table[5] - quest_table[2][2]) * 100) / quest_player_table[5];
		QuestProgressLine.style['width'] = (100 - percentage) + '%';

		let QuestProgressLabel = $.CreatePanel("Label", QuestProgress, "QuestProgressLabel");
		QuestProgressLabel.AddClass("QuestProgressLabel");
		QuestProgressLabel.text = quest_table[2][2] + " / " + quest_player_table[5];  // Прогресс квеста
	}

	let QuestRewardLabel = $.CreatePanel("Label", QuestInfo, "");
	QuestRewardLabel.AddClass("QuestRewardLabel");
    QuestRewardLabel.text = is_locked_quest_battlepass ? $.Localize("#quest_locked_buy_battlepass") : $.Localize("#" + quest_player_table[4]); // Награда квеста

	let QuestSucces = $.CreatePanel("Panel", QuestIcon, "");
	QuestSucces.AddClass("QuestSucces");

	let QuestSuccesIcon = $.CreatePanel("Panel", QuestIcon, "QuestSuccesIcon");
	QuestSuccesIcon.AddClass("QuestSuccesIcon");

	if (quest_table[2] && Number(quest_table[2][2]) >= Number(quest_player_table[5]))
	{
		DayQuest.AddClass("QuestComplete");
	}

    let QuestLockedBG = $.CreatePanel("Panel", QuestIcon, "");
	QuestLockedBG.AddClass("QuestLockedBG");
    
    let QuestLockedBGIcon = $.CreatePanel("Panel", QuestIcon, "");
	QuestLockedBGIcon.AddClass("QuestLockedBGIcon");
}


function UpdateQuest(data)
{
	$("#QuestPanelSwap").style.visibility = "visible"
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
	if (quest_panel) 
    {
		let percentage = ((quest_table[4]-current)*100)/quest_table[4]
		let QuestProgressLine = quest_panel.FindChildTraverse("QuestProgressLine")
		let QuestProgressLabel = quest_panel.FindChildTraverse("QuestProgressLabel")
		if (QuestProgressLine)
		{
			QuestProgressLine.style['width'] = (100 - percentage) +'%';
		}
		if (QuestProgressLabel)
		{
			QuestProgressLabel.text = current + " / " + quest_table[4]  // Прогресс квеста
		}
        if (Number(current) >= Number(quest_table[4]))
        {
            quest_panel.AddClass("QuestComplete");
        }
	}
}

CreateQuests()