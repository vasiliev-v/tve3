var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements").FindChildTraverse("MenuButtons");
if ($("#RewardsButton")) {
	if (parentHUDElements.FindChildTraverse("RewardsButton")){
		$("#RewardsButton").DeleteAsync( 0 );
	} else {
		$("#RewardsButton").SetParent(parentHUDElements);
	}
}

var ButtonPanel = parentHUDElements.FindChildTraverse("RewardsButton");
var animation_timer_function = -1

var toggle = false;
var first_time = false;
var cooldown_panel = false


var multiplier = 1 // Множитель награды за каждую неделю


// день недели, Иконка, количество в цифрах чтоб умножать на недели и название награды(гемов, опыта, монет), тип гемы - 1, 2-опыт, 3 монеты

// Название кстати то что будет в addon_russia - "gems" "Гемов"

var rewards = 
[
	["1", "reward_gems", 5, "reward_gems", "1"],
	["2", "reward_gems", 10, "reward_gems", "1"],
	["3", "reward_gems", 15, "reward_gems", "1"],
	["4", "reward_gems", 20, "reward_gems", "1"],
	["5", "reward_gems", 25, "reward_gems", "1"],
	["6", "reward_gems", 50, "reward_gems", "1"],
	["7", "reward_gems", 75, "reward_gems", "1"], 
]

var player_table = 
[
	1,	
	1, // Сколько дней подряд заходит
	1, // Количество недель подряд
]


function ToggleRewards() {
	player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[6];
    if (toggle === false) {
    	if (cooldown_panel == false) {
	        toggle = true;
	        if (first_time === false) {
	            first_time = true;
	            InitGameRewards()
	            $("#RewardsPanel").AddClass("sethidden");
	        }  
	        if ($("#RewardsPanel").BHasClass("sethidden")) {
	            $("#RewardsPanel").RemoveClass("sethidden");
	        }
	        $("#RewardsPanel").AddClass("setvisible");
	        $("#RewardsPanel").style.visibility = "visible"
	        cooldown_panel = true
	        $.Schedule( 0.503, function(){
	        	cooldown_panel = false
	        })
	    }
    } else {
    	if (cooldown_panel == false) {
	        toggle = false;
	        if ($("#RewardsPanel").BHasClass("setvisible")) {
	            $("#RewardsPanel").RemoveClass("setvisible");
	        }
	        $("#RewardsPanel").AddClass("sethidden");
	        cooldown_panel = true
	        $.Schedule( 0.503, function(){
	        	cooldown_panel = false
	        	$("#RewardsPanel").style.visibility = "collapse"
			})
		}
    }
}

function InitGameRewards()
{
	var week = player_table[2] - 1
	
	for (var i = 0; i < rewards.length; i++) {
		let normal_day_week = i + 1
		normal_day_week = normal_day_week + ( 7 * week)

		CreateReward(normal_day_week, i + 1, rewards[i], week)
	}

	if(animation_timer_function != -1)
	{
		$.CancelScheduled(animation_timer_function)
		animation_timer_function = -1;
		ButtonPanel.SetHasClass( "RewardAnimationCheck", false )
	}
}

CheckRewardsAnimation()

function CheckRewardsAnimation()
{
	let player_table_other = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())[6];

	var week = player_table_other[2] - 1

	for (var i = 0; i < rewards.length; i++) {
		let normal_day_week = i + 1
		normal_day_week = normal_day_week + ( 7 * week)

		if (Number(normal_day_week) == Number(player_table_other[1]))
		{
			let go_recive = true
			if (Number(player_table_other[0]) == Number(normal_day_week))
			{
				go_recive = false
			}
			if (go_recive)
			{
				ButtonPanel.SetHasClass( "RewardAnimationCheck", true )
				break
			} else {
				ButtonPanel.SetHasClass( "RewardAnimationCheck", false )
			}
		}
	}

	animation_timer_function = $.Schedule(1, CheckRewardsAnimation)
}

function CreateReward(day, reward_day, reward_table, week)
{
	var Reward = $.CreatePanel("Panel", $("#RewardsRow"), "reward_day_" + day);
	Reward.AddClass("Reward");

	var DayNumber = $.CreatePanel("Label", Reward, "");
	DayNumber.AddClass("DayNumber");
	DayNumber.text = day

	var DayText = $.CreatePanel("Label", Reward, "");
	DayText.AddClass("DayText");
	DayText.text = $.Localize("#rewards_days")

	var RewardIcon = $.CreatePanel("Panel", Reward, "");
	RewardIcon.AddClass("RewardIcon");

	var RewardIconImage = $.CreatePanel("Panel", RewardIcon, "");
	RewardIconImage.AddClass("RewardIconImage");
	RewardIconImage.style.backgroundImage = 'url("file://{images}/custom_game/rewards/icons/' + reward_table[1] + '.png")';

	var RewardInfo = $.CreatePanel("Panel", Reward, "");
	RewardInfo.AddClass("RewardInfo");

	var RewardInfoLabel = $.CreatePanel("Label", RewardInfo, "");
	RewardInfoLabel.AddClass("RewardInfoLabel");

	let reward_info = reward_table[2]
	if ( week > 0 ) // reward_coins
	{
		reward_info = (multiplier * (week+1)) * reward_table[2]
	}

	RewardInfoLabel.text = reward_info + " " + $.Localize("#" + reward_table[3])

	if (reward_day == 1) {
		RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		RewardIcon.style.border = "1px solid #8847ff"
	} else if (reward_day == 2) {
		RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		RewardIcon.style.border = "1px solid #8847ff"
	} else if (reward_day == 3) {
		RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		RewardIcon.style.border = "1px solid #8847ff"
	} else if (reward_day == 4) {
		RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		RewardIcon.style.border = "1px solid #8847ff"
	} else if (reward_day == 5) {
		RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #8847ff ), to( #594978 ))';
		RewardIcon.style.border = "1px solid #8847ff"
	} else if (reward_day == 6) {
		RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #d32ce6 ), to( #65196e ))';
		RewardIcon.style.border = "1px solid #d32ce6"
	} else if (reward_day == 7) {
		RewardInfo.style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #b28a33 ), to( #664c15 ))';
		RewardIcon.style.border = "1px solid #b28a33"
	}

	if (Number(player_table[0]) >= Number(day))
	{
		var RewardClaimed = $.CreatePanel("Panel", RewardIcon, "");
		RewardClaimed.AddClass("RewardClaimed");

		var RewardClaimLabel = $.CreatePanel("Label", RewardClaimed, "");
		RewardClaimLabel.AddClass("RewardClaimLabel");
		RewardClaimLabel.text = $.Localize("#reward_recieved")

		RewardIconImage.AddClass("reward_close");
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
			var RewardClaim = $.CreatePanel("Panel", Reward, "");
			RewardClaim.AddClass("RewardClaim");

			var RewardClaimLabel = $.CreatePanel("Label", RewardClaim, "");
			RewardClaimLabel.AddClass("RewardClaimLabel");
			RewardClaimLabel.text = $.Localize("#reward_recieve")

			RewardClaim.SetPanelEvent("onactivate", function() { RecieveReward(RewardClaim, Reward, RewardIcon, RewardIconImage, reward_table[4], reward_info) } );
		}
	}


	if (Number(day) > Number(player_table[1]))
	{
		RewardIconImage.AddClass("reward_close");
	}
}

function RecieveReward(claim_panel, reward_panel, RewardIcon, RewardIconImage, type_reward, reward_count)
{
	claim_panel.SetPanelEvent("onactivate", function() {} );
	claim_panel.DeleteAsync( 0.003 );

	var RewardClaimed = $.CreatePanel("Panel", RewardIcon, "");
	RewardClaimed.AddClass("RewardClaimed");

	var RewardClaimLabel = $.CreatePanel("Label", RewardClaimed, "");
	RewardClaimLabel.AddClass("RewardClaimLabel");
	RewardClaimLabel.text = $.Localize("#reward_recieved")

	RewardIconImage.AddClass("reward_close");


	// На всякий случай нужно в луа вычислить формулу, но сюда тож закину
	// reward_count - количество 
	// type_reward - тип награды


	GameEvents.SendCustomGameEventToServer( "EventRewards", {id: Players.GetLocalPlayer(), count: reward_count, type: type_reward} ); // отправляешь ивент 
}

function IDoNotKnowWhatItIs(){let _0x5a6472=parentHUDElements['FindChildTraverse']('RewardsButton'); var player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());if(player_table){if((player_table[0x0][0x0]!=null&player_table[0x0][0x1]!=null) & (player_table[0x0][0x0]!=0x0||player_table[0x0][0x1]>=10)){_0x5a6472&&(_0x5a6472['style']['visibility']='visible');return;}}_0x5a6472&&(_0x5a6472['style']['visibility']='collapse'),$['Schedule'](0x2,IDoNotKnowWhatItIs);}IDoNotKnowWhatItIs();
