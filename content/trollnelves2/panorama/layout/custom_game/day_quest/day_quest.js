GameEvents.SubscribeProtected( 'troll_quest_update', UpdateQuest ); // Обновить квест ( quest_id -- Айди квеста у игрока, current -- Новое значение в этом квесте )

function ToggleInfo()
{
	$("#QuestMain").SetHasClass("Open", !$("#QuestMain").BHasClass("Open"))
}

// Массив визуальной информации по заданиям ( его кстати можно передать из луа чтоб не дублировать )
// Айди квеста, название, иконка, награда, максимальное количество для выполнения, УНИКАЛЬНЫЙ ЛИ КВЕСТ 0-обычный, 1-батллпасс
var quest_information_table = 
[
	["1", "quest_kill_troll", "spell_1_1", "quest_kill_troll_reward", "5",  "0"],
	["2", "quest_kill_troll", "spell_1_2", "quest_kill_troll_reward", "5",  "1"],
	["3", "quest_kill_troll", "spell_1_3", "quest_kill_troll_reward", "5",  "1"],
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



function CreateQuests()
{
	let has_battlepass = false
	quest_information_table = CustomNetTables.GetTableValue("Shop", "bpday");
	player_table[1] = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[10]; 
	player_table[0] = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[15];
	// есть ли батлл пасс у игрока
	if (player_table) 
    {
		if (player_table[0][0] != "none")
		{
			has_battlepass = true
		} 
        else 
        {
			has_battlepass = false
		}
	}
	if (quest_information_table) 
	{ 
		for (var i = 1; i <= 3; i++) 
        {
			CreateQuest(quest_information_table[i], has_battlepass) // Создаем квесты игрока
		}
	}
}

function CreateQuest(quest_player_table, has_battlepass)
{
	let quest_table = null
	if (quest_player_table == null) 
    {
		return
	}
    let is_locked_quest_battlepass = false

    if (player_table)
    {
        for (var i = 1; i <= Object.keys(player_table[1][1]).length; i++) 
        {
            if (player_table[1][i][1] == quest_player_table[1])
            {
                quest_table = player_table[1][i]
            }
        }
    }
	 
	if (quest_player_table[6] == "1")
	{
		if (!has_battlepass)
		{
			is_locked_quest_battlepass = true
		}
	}

	if (quest_table == null) 
    {
		quest_table = ["0",quest_player_table[1] ,"0"]
	}

	let DayQuest = $.CreatePanel("Panel", $("#QuestsPanel"), "quest_id_" + quest_player_table[0]);
	DayQuest.AddClass("DayQuest");
    if (is_locked_quest_battlepass)
    {
        DayQuest.AddClass("LockedQuest");
    }

	let QuestIcon = $.CreatePanel("Panel", DayQuest, "");
	QuestIcon.AddClass("QuestIcon");
	QuestIcon.style.backgroundImage = 'url("file://{images}/custom_game/quest/icons/' + quest_player_table[2] + '.png")';
	QuestIcon.style.backgroundSize = "100%"

	// Инфа о квесте 
	let QuestInfo = $.CreatePanel("Panel", DayQuest, "");
	QuestInfo.AddClass("QuestInfo");
	
	let QuestName = $.CreatePanel("Label", QuestInfo, "");
	QuestName.AddClass("QuestName");

    if (is_locked_quest_battlepass)
    {
        QuestName.text = $.Localize("#quest_locked")
    }
    else
    {
        QuestName.text = $.Localize("#" + quest_player_table[1]) // название задания
    }

	let QuestProgress = $.CreatePanel("Panel", QuestInfo, "");
	QuestProgress.AddClass("QuestProgress");

	let QuestProgressBackground = $.CreatePanel("Panel", QuestProgress, "");
	QuestProgressBackground.AddClass("QuestProgressBackground");

	let QuestProgressLine = $.CreatePanel("Panel", QuestProgress, "QuestProgressLine");
	QuestProgressLine.AddClass("QuestProgressLine");

	let percentage = ((quest_player_table[5]-quest_table[2])*100)/quest_player_table[5]
	QuestProgressLine.style['width'] = (100 - percentage) +'%';

	let QuestProgressLabel = $.CreatePanel("Label", QuestProgress, "QuestProgressLabel");
	QuestProgressLabel.AddClass("QuestProgressLabel");
	QuestProgressLabel.text = quest_table[2] + " / " + quest_player_table[5]  // Прогресс квеста

	let QuestRewardLabel = $.CreatePanel("Label", QuestInfo, "");
	QuestRewardLabel.AddClass("QuestRewardLabel");
    if (is_locked_quest_battlepass)
    {
        QuestRewardLabel.text = $.Localize("#quest_locked_buy_battlepass")
    }
    else
    {
	    QuestRewardLabel.text = $.Localize("#" + quest_player_table[4]) // Награда квеста
    }

	let QuestSucces = $.CreatePanel("Panel", QuestIcon, "");
	QuestSucces.AddClass("QuestSucces");

	let QuestSuccesIcon = $.CreatePanel("Panel", QuestIcon, "QuestSuccesIcon");
	QuestSuccesIcon.AddClass("QuestSuccesIcon");

	if (Number(quest_table[2]) >= Number(quest_player_table[5]))
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