var multiplier = 1 // Множитель награды за каждую неделю
// день недели, Иконка, количество в цифрах чтоб умножать на недели и название награды(гемов, опыта, монет), тип гемы - 1, 2-опыт, 3 монеты
// Название кстати то что будет в addon_russia - "gems" "Гемов"
var rewards = 
[
	["1", "reward_gems", "25", "reward_gems", "1"],
	["2", "reward_gems", "50", "reward_gems", "1"],
	["3", "reward_gems", "75", "reward_gems", "1"],
	["4", "reward_gems", "100", "reward_gems", "1"],
	["5", "reward_gems", "150", "reward_gems", "1"],
	["6", "reward_gems", "300", "reward_gems", "1"],
	["7", "reward_gems", "600", "reward_gems", "1"], 
]

var player_table = 
[
	1,	
	1, // Сколько дней подряд заходит
	1, // Количество недель подряд
]

function OpenPanel() 
{
    player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[6];
    InitGameRewards()
    $("#RewardsPanel").SetHasClass("Open", !$("#RewardsPanel").BHasClass("Open"))
}

function ClosePanel()
{
    $("#RewardsPanel").SetHasClass("Open", false)
}

function InitGameRewards()
{
	let week = player_table[2] - 1
	for (var i = 0; i < rewards.length; i++) 
    {
		let normal_day_week = i + 1
		normal_day_week = normal_day_week + ( 7 * week)
		CreateReward(normal_day_week, i + 1, rewards[i], week)
	}
}

function CreateReward(day, reward_day, reward_table, week)
{
	let Reward = $.CreatePanel("Panel", $("#RewardsRow"), "reward_day_" + day);
	Reward.AddClass("Reward");

    let RewardLight = $.CreatePanel("Panel", Reward, "");
	RewardLight.AddClass("RewardLight");

	let DayNumber = $.CreatePanel("Label", Reward, "");
	DayNumber.AddClass("DayNumber");
	DayNumber.text = day + " " + $.Localize("#rewards_days")

	let RewardIcon = $.CreatePanel("Panel", Reward, "");
	RewardIcon.AddClass("RewardIcon");

	let RewardIconImage = $.CreatePanel("Panel", RewardIcon, "");
	RewardIconImage.AddClass("RewardIconImage");
	RewardIconImage.style.backgroundImage = 'url("file://{images}/custom_game/rewards/icons/' + reward_table[1] + '.png")';

    let RewardLine = $.CreatePanel("Panel", $("#RewardsRow"), "");
	RewardLine.AddClass("RewardLine");

	let RewardInfoLabel = $.CreatePanel("Label", Reward, "");
	RewardInfoLabel.AddClass("RewardInfoLabel");
    
	let reward_info = reward_table[2]
	//if ( week > 0 ) // reward_coins
	//{
	//	reward_info = (multiplier * (week+1)) * reward_table[2]
	//}
	RewardInfoLabel.text = reward_info

	if (reward_day == 1) {
		//RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		RewardLight.style.washColor = "#8847ff"
	} else if (reward_day == 2) {
		//RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		RewardLight.style.washColor = "#8847ff"
	} else if (reward_day == 3) {
		//RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		RewardLight.style.washColor = "#8847ff"
	} else if (reward_day == 4) {
		//RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		RewardLight.style.washColor = "#8847ff"
	} else if (reward_day == 5) {
		//RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		RewardLight.style.washColor = "#8847ff"
	} else if (reward_day == 6) {
		//RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #d32ce6 ), to( #65196e ))';
		RewardLight.style.washColor = "#d32ce6"
	} else if (reward_day == 7) {
		//RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b28a33 ), to( #664c15 ))';
		RewardLight.style.washColor = "#b28a33"
	}

    let RewardClaimButton = $.CreatePanel("Panel", Reward, "RewardClaimButton");
	RewardClaimButton.AddClass("RewardClaimButton");

    let RewardClaimButtonLabel = $.CreatePanel("Label", RewardClaimButton, "RewardClaimButtonLabel");
	RewardClaimButtonLabel.AddClass("RewardClaimButtonLabel");

	if (Number(player_table[0]) >= Number(day))
	{
        Reward.AddClass("reward_recieved");
        RewardClaimButtonLabel.text = $.Localize("#reward_recieved")
	}

    if (Number(day) == Number(player_table[1]))
    {
    	let go_recive = true
    	if (Number(player_table[0]) == Number(day))
    	{
    		go_recive = false
    	}
    	if (go_recive)
    	{
            RewardClaimButtonLabel.text = $.Localize("#reward_recieve")
            Reward.AddClass("Unlocked")
			RewardClaimButton.SetPanelEvent("onactivate", function() { RecieveReward(RewardClaimButton, Reward, reward_table[4], reward_info) } );
		}
	}

	if (Number(day) > Number(player_table[1]))
	{
        RewardClaimButtonLabel.text = $.Localize("#reward_recieve")
		Reward.AddClass("reward_close");
	}
}

function RecieveReward(claim_panel, reward_panel, type_reward, reward_count)
{
	claim_panel.SetPanelEvent("onactivate", function() {} );
    reward_panel.AddClass("reward_recieved")
    let RewardClaimButtonLabel = claim_panel.GetChild(0)
    RewardClaimButtonLabel.text = $.Localize("#reward_recieved")
    reward_panel.RemoveClass("Unlocked")
	// На всякий случай нужно в луа вычислить формулу, но сюда тож закину
	// reward_count - количество 
	// type_reward - тип награды
	GameEvents.SendCustomGameEventToServer( "EventRewards", {id: Players.GetLocalPlayer(), count: reward_count, type: type_reward} ); // отправляешь ивент 
}

GameUI.CustomUIConfig().OpenRewardsGlobal = OpenPanel  