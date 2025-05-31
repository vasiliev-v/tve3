var BP_INIT = false
var player_bp_info = [0, []]

function OpenPanel() {
	player_bp_info[0] = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[7];
	player_bp_info[1] = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[14];
	//Куплен батллпасс. 
	player_bp_info[2] = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[15];
 
	if (!BP_INIT) {
		BP_INIT = true
		InitLevel()
		InitDonateRewards()
	}
    else
        InitLevel()
	$("#BattlePassPanel").SetHasClass("Open", !$("#BattlePassPanel").BHasClass("Open"))
}

function ClosePanel() {
	$("#BattlePassPanel").SetHasClass("Open", false)
}

function InitLevel() {
	if (!player_bp_info[0] || !player_bp_info[0][0]) return;

	let level = GetLevelPlayer(player_bp_info[0][0]);
	let currExp = GetExpPlayer(player_bp_info[0][0]);

	$("#LevelText").text = $.Localize("#battlepass_level") + ": " + level;

	let currXPNeeded = exp_battlepass[String(level)];
	let nextXPNeeded = exp_battlepass[String(level + 1)];

	if (nextXPNeeded !== undefined) {
		$("#ExpText").text = `Experience ${currExp} / ${nextXPNeeded}`;
		var width = 100 * currExp / nextXPNeeded;
	} else {
		// макс. уровень
		$("#ExpText").text = `Experience ${currXPNeeded} / ${currXPNeeded}`;
		var width = 100;
	}

	if (isNaN(width)) width = 0;
	width = Math.max(0, Math.min(100, width));
	$("#BattlePass_Progress_6").style.width = width + "%";
}

function InitDonateRewards() {
    // определяем текущий уровень игрока
    let lvl = 0;
    if (player_bp_info[0] && player_bp_info[0][0]) {
        lvl = GetLevelPlayer(player_bp_info[0][0]);
    }

    // итерируем по всем уровням, пока есть запись в exp_battlepass
    let i = 1;
    while (exp_battlepass[String(i)] !== undefined) {
        CreateLevels(i, lvl);
        CreateFreeReward(i, lvl);
        CreateDonateReward(i, lvl);
        CreateVisualLight(i);
        i++;
    }
}
function CreateLevels(reward_level, lvl) {
	let LevelPanelCenter = $.CreatePanel("Panel", $("#Levels"), "LevelPanelCenter" + reward_level);
	LevelPanelCenter.AddClass("LevelPanel");

	let LevelTextPanel = $.CreatePanel("Label", LevelPanelCenter, "LevelTextPanel");
	LevelTextPanel.AddClass("LevelTextPanel");
	LevelTextPanel.text = $.Localize("#battlepass_level") + " " + reward_level
}

function CreateFreeReward(reward_level, lvl) {
    // Ищем запись в free_rewards по ключам
    let create_reward_check = false;
    let reward_id            = 0;
    let reward_no_recieve    = true;
    let entry                = null;

    Object.keys(free_rewards).forEach(key => {
        const e = free_rewards[key];
        // e["1"] — это строковый уровень
        if (e && e["1"] === String(reward_level)) {
            create_reward_check = true;
            reward_id           = e["5"];
            entry               = e;
        }
    });

    // Проверяем, получил ли игрок уже эту награду
    for (const invKey in (player_bp_info[1] || [])) {
        if (player_bp_info[1][invKey] == reward_id) {
            reward_no_recieve = false;
            break;
        }
    }

    // Если нет записи — рисуем пустую панель
    if (!create_reward_check) {
        const emptyPanel = $.CreatePanel("Panel", $("#BattlePass_Free"), "RewardPanelFree" + reward_level);
        emptyPanel.AddClass("RewardPaneClear");
        return;
    }

    // Парсим поля записи
    const icon       = entry["3"];                     // имя иконки
    const count      = parseInt(entry["4"], 10);       // количество
    const rewardUID  = entry["5"];                     // ID награды
    const donateIcon = (donate_rewards[String(reward_level)] || {})["3"]; // для GiveReward

    // Создаём панель награды
    const RewardPanelFree = $.CreatePanel("Panel", $("#BattlePass_Free"), "RewardPanelFree" + reward_level);
    RewardPanelFree.AddClass("RewardPanelFree");

    // Иконка
    const RewardImage = $.CreatePanel("Panel", RewardPanelFree, "RewardImage");
    RewardImage.AddClass("reward_image");
    RewardImage.style.backgroundImage  = 
        `url("file://{images}/custom_game/shop/itemicon/${icon}.png")`;
    RewardImage.style.backgroundSize   = "100% 100%";

    const PanelLock = $.CreatePanel("Panel", RewardPanelFree, "PanelLock");
    PanelLock.AddClass("PanelLock");

    // Лейбл с количеством
    const RewardInfoLabel = $.CreatePanel("Label", RewardPanelFree, "");
    RewardInfoLabel.AddClass("RewardInfoLabel");
    if (count > 1) {
        RewardInfoLabel.text = count;
    }

    const BpLockedText = $.CreatePanel("Label", PanelLock, "BpLockedText");
    BpLockedText.AddClass("BpLockedText");

    // Разблокировка / получено / заблокировано
    if (lvl >= reward_level) {
        if (reward_no_recieve) {
            RewardPanelFree.AddClass("Unlocked");
            PanelLock.SetPanelEvent("onactivate", function() {
                GiveReward(
                    reward_id,
                    PanelLock,
                    RewardPanelFree
                );
            });
            BpLockedText.text = $.Localize("#battleshop_gives");
        } else {
            RewardPanelFree.AddClass("PanelGives");
            BpLockedText.text = $.Localize("#battlepass_gives");
        }
    } else {
        RewardPanelFree.AddClass("PanelLockOn");
        PanelLock.SetPanelEvent("onactivate", function(){});
        BpLockedText.text = $.Localize("#battleshop_locked");
    }
}

function GiveReward(id, panel, rew_panel) {
	panel.SetPanelEvent("onactivate", function () { });
	rew_panel.AddClass("PanelGives");
	rew_panel.RemoveClass("Unlocked")
	panel.FindChildTraverse("BpLockedText").text = $.Localize("#" + "battlepass_gives")
	// Здесь нужно отправить в луа проверку на получение шмотки  id - айди шмотки
	GameEvents.SendCustomGameEventToServer("EventBattlePass", {  Type: id  }); // отправляешь ивент 
}

function CreateDonateReward(reward_level, lvl) {
    // 1. Ищем запись в donate_rewards
    let create_reward_check = false;
    let reward_id           = 0;
    let reward_no_recieve   = true;
    let entry               = null;

    Object.keys(donate_rewards).forEach(key => {
        const e = donate_rewards[key];
        // e["1"] — строковый уровень
        if (e && e["1"] === String(reward_level)) {
            create_reward_check = true;
            reward_id           = e["5"];  // ID награды
            entry               = e;
        }
    });

    // 2. Проверяем, есть ли в player_bp_info[1] этот reward_id
    for (const invKey in (player_bp_info[1] || {})) {
        if (player_bp_info[1][invKey] == reward_id) {
            reward_no_recieve = false;
            break;
        }
    }

    // 3. Если записи нет — рисуем «пустую» панель
    if (!create_reward_check) {
        const emptyPanel = $.CreatePanel("Panel", $("#BattlePass_Donate"), "RewardPanelDonate" + reward_level);
        emptyPanel.AddClass("RewardPaneClear");
        return;
    }

    // 4. Распаковываем поля записи
    const icon      = entry["3"];                     // имя иконки
    const count     = parseInt(entry["4"], 10);       // количество
    const rewardUID = entry["5"];                     // уникальный ID награды

    // 5. Создаём панель для донат-награды
    const panel = $.CreatePanel("Panel", $("#BattlePass_Donate"), "RewardPanelDonate" + reward_level);
    panel.AddClass("RewardPanelDonate");

    // Иконка
    const img = $.CreatePanel("Panel", panel, "RewardImage");
    img.AddClass("reward_image");
    img.style.backgroundImage = `url("file://{images}/custom_game/shop/itemicon/${icon}.png")`;
    img.style.backgroundSize  = "100% 100%";

    // Лейбл с количеством
    const infoLabel = $.CreatePanel("Label", panel, "");
    infoLabel.AddClass("RewardInfoLabel");
    if (count > 1) {
        infoLabel.text = count;
    }

    // Панель «замка» и текст в ней
    const lockPanel   = $.CreatePanel("Panel", panel, "PanelLock");
    lockPanel.AddClass("PanelLock");
    const statusLabel = $.CreatePanel("Label", lockPanel, "BpLockedText");
    statusLabel.AddClass("BpLockedText");

    // 6. Логика разблокировки / уже получено / заблокировано
    if (lvl >= reward_level) {
        if (reward_no_recieve) {
            panel.AddClass("Unlocked");
            lockPanel.SetPanelEvent("onactivate", function() {
                GiveReward(
                    reward_id,
                    lockPanel,
                    panel
                );
            });
            statusLabel.text = $.Localize("#battleshop_gives");
        } else {
            panel.AddClass("PanelGives");
            statusLabel.text = $.Localize("#battlepass_gives");
        }
    } else {
        panel.AddClass("PanelLockOn");
        lockPanel.SetPanelEvent("onactivate", function() {});
        statusLabel.text = $.Localize("#battleshop_locked");
    }
}



function CreateVisualLight(i) {
	let color = visual_level_light[i]
	let BattlePass_Effects = $("#BattlePass_Effects")
	if (color && color != "") {
		let RewardLight = $.CreatePanel("Panel", BattlePass_Effects, "");
		RewardLight.AddClass("RewardLight");
		RewardLight.style.washColor = color
	}
}


function GetLevelPlayer(tmp) {
	let exp = Number(tmp), level = 0;
	while (true) {
		let req = exp_battlepass[String(level + 1)];
		if (req !== undefined && exp >= req) {
			exp -= req;
			level++;
		} else break;
	}
	return level;
}

function GetExpPlayer(tmp) {
	let exp = Number(tmp), level = 0;
	while (true) {
		let req = exp_battlepass[String(level + 1)];
		if (req !== undefined && exp >= req) {
			exp -= req;
			level++;
		} else break;
	}
	return exp;
}


GameUI.CustomUIConfig().OpenBPGlobal = OpenPanel