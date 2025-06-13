var UPDATED_QUEST_DAY = {}


//GameEvents.SubscribeProtected( 'troll_quest_update', UpdateQuest ); // Обновить квест ( quest_id -- Айди квеста у игрока, current -- Новое значение в этом квесте )

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
		const sortedQuests = Object.values(quest_information_table).sort((a, b) => {
			if (a.type < b.type) return -1;
			if (a.type > b.type) return  1;
			return 0;
		});
		if (sortedQuests) 
		{  
			Object.keys(sortedQuests).forEach(key => {
				CreateQuest(sortedQuests[key], has_battlepass); 
			});
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
	
    if (player_table[1][1])
    {  
        for (var i = 1; i <= Object.keys(player_table[1][1]).length; i++) 
        {
            if (player_table[1][1][i][1] == quest_player_table.id)
            {
                quest_table = player_table[1][1][i]; 
				break;
            }
        } 
    }

	if (quest_player_table.donate == "1")
	{
		if (!has_battlepass)
		{
			is_locked_quest_battlepass = true
		}
	}

	if (quest_table == null) 
    {
		return
	}

	let DayQuest = $.CreatePanel("Panel", $("#QuestsPanel"), "quest_id_" + quest_player_table.id);
	DayQuest.AddClass("DayQuest");
    if (is_locked_quest_battlepass)
    {
        DayQuest.AddClass("LockedQuest");
    }

	let QuestIcon = $.CreatePanel("Panel", DayQuest, "");
	QuestIcon.AddClass("QuestIcon");

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
        QuestName.text = $.Localize("#" + quest_player_table.name) // название задания
		QuestIcon.style.backgroundImage = 'url("file://{images}/custom_game/quest/icons/' + quest_player_table.icon + '.png")';
	 	QuestIcon.style.backgroundSize = "100%"
    }

	let QuestProgress = $.CreatePanel("Panel", QuestInfo, "");
	QuestProgress.AddClass("QuestProgress");

	let QuestProgressBackground = $.CreatePanel("Panel", QuestProgress, "");
	QuestProgressBackground.AddClass("QuestProgressBackground");

	let QuestProgressLine = $.CreatePanel("Panel", QuestProgress, "QuestProgressLine");
	QuestProgressLine.AddClass("QuestProgressLine");

	let percentage = ((quest_player_table.count-quest_table[2])*100)/quest_player_table.count
	QuestProgressLine.style['width'] = (100 - percentage) +'%';

	let QuestProgressLabel = $.CreatePanel("Label", QuestProgress, "QuestProgressLabel");
	QuestProgressLabel.AddClass("QuestProgressLabel");
	QuestProgressLabel.text = quest_table[2] + " / " + quest_player_table.count  // Прогресс квеста

	let QuestRewardLabel = $.CreatePanel("Label", QuestInfo, "");
	QuestRewardLabel.AddClass("QuestRewardLabel");
    if (is_locked_quest_battlepass)
    {
        QuestRewardLabel.text = $.Localize("#quest_locked_buy_battlepass")
    }
    else
    {
	    QuestRewardLabel.text = $.Localize("#" + quest_player_table.reward) // Награда квеста
    }

	let QuestSucces = $.CreatePanel("Panel", QuestIcon, "");
	QuestSucces.AddClass("QuestSucces");

	let QuestSuccesIcon = $.CreatePanel("Panel", QuestIcon, "QuestSuccesIcon");
	QuestSuccesIcon.AddClass("QuestSuccesIcon");

	if (Number(quest_table[2]) >= Number(quest_player_table.count))
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
	player_table[1] = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[10]; 
	player_table[0] = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[15];
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


GameEvents.SubscribeProtected( "troll_quest_update_after", UpdateQuestAfter );

function UpdateQuestAfter()
{
    if (UPDATED_QUEST_DAY[Players.GetLocalPlayer()] != null ) { return }
    UPDATED_QUEST_DAY[Players.GetLocalPlayer()] = true
	var questsPanel = $("#QuestsPanel");
    questsPanel.RemoveAndDeleteChildren();
    CreateQuests();
	//UpdateQuest()
}

CreateQuests()