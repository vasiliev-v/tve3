var BP_INIT = false
var player_bp_info = [0,[]]

// Опыт, забранные награды
var player_table = 
[
	[0,0],
	[""],
	[0, "none"],
	[0, "none"],
	// Массив ID СУНДУКА / КОЛИЧЕСТВО
	[]
]

function OpenPanel()
{
    player_bp_info = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[7];
    if (!BP_INIT)
    {
        BP_INIT = true
        InitLevel()
        InitDonateRewards()
    }
    $("#BattlePassPanel").SetHasClass("Open", !$("#BattlePassPanel").BHasClass("Open"))
}

function ClosePanel()
{
    $("#BattlePassPanel").SetHasClass("Open", false)
}

function InitLevel() 
{
	if (player_bp_info) 
    {
		let level = GetLevelPlayer(player_bp_info[0])
		let get_current_exp = GetExpPlayer(player_bp_info[0])
		$("#LevelText").text = $.Localize("#" + "battlepass_level") + ":" + " " + level
		let width = 0
		if (exp_battlepass[level+1]) 
        {
			$("#ExpText").text = "Experience " + get_current_exp + " / " + exp_battlepass[level+1]
			if (player_bp_info[0] > 0) 
            {
				width = (100 * get_current_exp ) / exp_battlepass[level+1]
			}
		} 
        else 
        {
			$("#ExpText").text = "Experience " + exp_battlepass[level] + " / " + exp_battlepass[level]
			if (player_bp_info[0] > 0) 
            {
				width = (100 * exp_battlepass[level] ) / exp_battlepass[level]
			}
		}
		$("#BattlePass_Progress_6").style.width = width + "%"
	}
}

function InitDonateRewards() 
{
	let level = 0
	if (player_bp_info) 
    {
		level = GetLevelPlayer(player_bp_info[0])
	}
	for (var i = 1; i < exp_battlepass.length; i++) 
    {
		CreateLevels(i)
		CreateFreeReward(i, level)
		CreateDonateReward(i, level)
        CreateVisualLight(i)
	}
}

function CreateLevels(reward_level, lvl)
{
	let LevelPanelCenter = $.CreatePanel("Panel", $("#Levels"), "LevelPanelCenter" + reward_level );
	LevelPanelCenter.AddClass("LevelPanel");

	let LevelTextPanel = $.CreatePanel("Label", LevelPanelCenter, "LevelTextPanel");
	LevelTextPanel.AddClass("LevelTextPanel");
	LevelTextPanel.text = $.Localize( "#battlepass_level") + " " + reward_level
}

function CreateFreeReward(reward_level, lvl)
{
	let create_reward_check = false
	let reward_id = 0
	let reward_no_recieve = true
	let reward_num  = 0
	for (var i = 0; i < free_rewards.length; i++) 
    {
		if (free_rewards[i][0] == reward_level) 
        {
			create_reward_check = true
			reward_id = free_rewards[i][1]
			reward_num = i
		}
	}
	for ( var reward_inventory in player_bp_info[1]  )
    {
    	if (player_bp_info[1][reward_inventory] == reward_id) 
        {
    		reward_no_recieve = false
    	}
	}

	if (create_reward_check)
    {
		let RewardPanelFree = $.CreatePanel("Panel", $("#BattlePass_Free"), "RewardPanelFree" + reward_level );
		RewardPanelFree.AddClass("RewardPanelFree");

		let RewardImage = $.CreatePanel("Panel", RewardPanelFree, "RewardImage" );
		RewardImage.AddClass("reward_image");
		RewardImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + free_rewards[reward_num][2] + '.png")';
		RewardImage.style.backgroundSize = "100% 100%"

		let PanelLock = $.CreatePanel("Panel", RewardPanelFree, "PanelLock" );
        PanelLock.AddClass("PanelLock");

        let RewardInfoLabel = $.CreatePanel("Label", RewardPanelFree, "");
	    RewardInfoLabel.AddClass("RewardInfoLabel");
        if (free_rewards[reward_num][3] > 1)
        {
            RewardInfoLabel.text = free_rewards[reward_num][3]
        }

        let BpLockedText = $.CreatePanel("Label", PanelLock, "BpLockedText");
		BpLockedText.AddClass("BpLockedText");

		if (lvl >= reward_level) 
        {
			if (reward_no_recieve) 
            {
                RewardPanelFree.AddClass("Unlocked")
				PanelLock.SetPanelEvent("onactivate", function() { GiveReward(reward_id, PanelLock, free_rewards[reward_num][2], RewardPanelFree) } );
			} 
            else 
            {
				RewardPanelFree.AddClass("PanelGives");
			}
		} 
        else 
        {
			RewardPanelFree.AddClass("PanelLockOn");
			PanelLock.SetPanelEvent("onactivate", function() {} );
		}

		if (lvl >= reward_level) 
        {
			if (reward_no_recieve) 
            { 
				BpLockedText.text = $.Localize("#battleshop_gives" )
			} 
            else 
            {
				BpLockedText.text = $.Localize("#battlepass_gives" )
			}
		} 
        else 
        {
			BpLockedText.text = $.Localize("#battleshop_locked" )
		}
	} 
    else 
    {
		let RewardPanelFree = $.CreatePanel("Panel", $("#BattlePass_Free"), "RewardPanelFree" + reward_level );
		RewardPanelFree.AddClass("RewardPaneClear");
	}
}

function GiveReward(id, panel, type, rew_panel) 
{
	panel.SetPanelEvent("onactivate", function() {} );
	rew_panel.AddClass("PanelGives");
    rew_panel.RemoveClass("Unlocked")
	panel.FindChildTraverse("BpLockedText").text = $.Localize("#" + "battlepass_gives")
	// Здесь нужно отправить в луа проверку на получение шмотки  id - айди шмотки
	GameEvents.SendCustomGameEventToServer( "EventBattlePass", {PlayerID: Players.GetLocalPlayer(), Num: id, Nick: type} ); // отправляешь ивент 
}

function CreateDonateReward(reward_level, lvl) 
{
	let create_reward_check = false
	let reward_id = 0
	let reward_no_recieve = true
	let reward_num  = 0

	for (var i = 0; i < donate_rewards.length; i++) 
    {
		if (donate_rewards[i][0] == reward_level) 
        {
			create_reward_check = true
			reward_id = donate_rewards[i][1]
			reward_num = i
		}
	}

	for ( var reward_inventory in player_bp_info[1]  )
    {
    	if (player_bp_info[1][reward_inventory] == reward_id) 
        {
    		reward_no_recieve = false
    	}
	}

	if (create_reward_check)
    {
		let RewardPanelDonate = $.CreatePanel("Panel", $("#BattlePass_Donate"), "RewardPanelDonate" + reward_level );
		RewardPanelDonate.AddClass("RewardPanelDonate");

		let RewardImage = $.CreatePanel("Panel", RewardPanelDonate, "RewardImage" );
		RewardImage.AddClass("reward_image");
		RewardImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + donate_rewards[reward_num][2] + '.png")';
		RewardImage.style.backgroundSize = "100% 100%"

        let RewardInfoLabel = $.CreatePanel("Label", RewardPanelDonate, "");
	    RewardInfoLabel.AddClass("RewardInfoLabel");
        if (donate_rewards[reward_num][3] > 1)
        {
            RewardInfoLabel.text = donate_rewards[reward_num][3]
        }

		let PanelLock = $.CreatePanel("Panel", RewardPanelDonate, "PanelLock" );
        PanelLock.AddClass("PanelLock");

        let BpLockedText = $.CreatePanel("Label", PanelLock, "BpLockedText");
		BpLockedText.AddClass("BpLockedText");

		if (lvl >= reward_level) 
        {
			if (reward_no_recieve) 
            {
                RewardPanelDonate.AddClass("Unlocked")
				PanelLock.SetPanelEvent("onactivate", function() { GiveReward(reward_id, PanelLock, donate_rewards[reward_num][2], RewardPanelDonate) } );
			} 
            else 
            {
				RewardPanelDonate.AddClass("PanelGives");
			}
		} 
        else 
        {
			RewardPanelDonate.AddClass("PanelLockOn");
			PanelLock.SetPanelEvent("onactivate", function() {} );
		}
		if (lvl >= reward_level) 
        {
			if (reward_no_recieve) 
            {
				BpLockedText.text = $.Localize( "#battleshop_gives" )
			} 
            else 
            {
				BpLockedText.text = $.Localize( "#battlepass_gives" )
			}
		} 
        else 
        {
			BpLockedText.text = $.Localize( "#battleshop_locked" )
		}
	} 
    else 
    {
		let RewardPanelDonate = $.CreatePanel("Panel", $("#BattlePass_Donate"), "RewardPanelDonate" + reward_level );
		RewardPanelDonate.AddClass("RewardPaneClear");		
	}
}

function CreateVisualLight(i)
{
    let color = visual_level_light[i]
    let BattlePass_Effects = $("#BattlePass_Effects")
    if (color && color != "")
    {
        let RewardLight = $.CreatePanel("Panel", BattlePass_Effects, "");
        RewardLight.AddClass("RewardLight");
        RewardLight.style.washColor = color
    }
}


function GetLevelPlayer(tmp) 
{
	let level = 0
	let exp = Number(tmp) 
	for (var i = 1; i <= exp_battlepass.length; i++)
	{
		if (exp >= exp_battlepass[i]) 
        {
			exp = exp - exp_battlepass[i]
			level = level + 1
		} 
        else 
        {
			break
		}
	}
	return level
}

function GetExpPlayer(tmp) 
{
	let exp = Number(tmp) 
	for (var i = 1; i <= exp_battlepass.length; i++)
	{
		if (exp >= exp_battlepass[i]) 
        {
			exp = exp - exp_battlepass[i]
		} 
        else 
        {
			break
		}
	}
	return exp
}

GameUI.CustomUIConfig().OpenBPGlobal = OpenPanel