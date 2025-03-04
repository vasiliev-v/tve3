var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements").FindChildTraverse("MenuButtons");
if ($("#ClanButton")) {
	if (parentHUDElements.FindChildTraverse("ClanButton")){
		$("#ClanButton").DeleteAsync( 0 );
	} else {
		$("#ClanButton").SetParent(parentHUDElements);
	}
}

var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "";

function ToggleClan() {
    if (toggle === false) {
    	if (cooldown_panel == false) {
	        toggle = true;
	        if (first_time === false) {
	            first_time = false;
	            UpdateClanInfo()
	            $("#ClanPanel").AddClass("sethidden");
	        }  
	        if ($("#ClanPanel").BHasClass("sethidden")) {
	            $("#ClanPanel").RemoveClass("sethidden");
	        }
	        $("#ClanPanel").AddClass("setvisible");
	        $("#ClanPanel").style.visibility = "visible"
	        cooldown_panel = true
	        $.Schedule( 0.503, function(){
	        	cooldown_panel = false
	        })
	    }
    } else {
    	if (cooldown_panel == false) {
	        toggle = false;
	        if ($("#ClanPanel").BHasClass("setvisible")) {
	            $("#ClanPanel").RemoveClass("setvisible");
	        }
	        $("#ClanPanel").AddClass("sethidden");
	        cooldown_panel = true
	        $.Schedule( 0.503, function(){
	        	cooldown_panel = false
	        	$("#ClanPanel").style.visibility = "collapse"
			})
		}
    }
}

GameEvents.SubscribeProtected( 'clan_error_notification', ErrorFromLua ); // Отправка ошибки из луа переменная text
GameEvents.SubscribeProtected( 'clan_clan_created', ClanCreated ); // Успешное создание клана
GameEvents.SubscribeProtected( 'clan_clan_leaved', ClanLeaved ); // Покинул успешно клан
GameEvents.SubscribeProtected( 'clan_clan_decline', ClanLeaved ); // Принял приглашение в клан успешно
GameEvents.SubscribeProtected( 'clan_clan_accept', ClanAccepted ); // отклонил приглашение в клан успешно
GameEvents.SubscribeProtected( 'clan_clan_player_kicked', player_is_kicked ); // успешно кикнул из клана





// ЕСЛИ ХОЧЕШЬ ПРОТЕСТИРОВАТЬ БЕЗ ЛУА А НА ЖС ТО УБЕРИ КОММЕНТЫ ПОСЛЕ // Тестовая хуйня на стороне js



// Массив кланов
// Айди клана, название клана, лидер, макс.кол-во людей, игроки, массив игроков которых уже приглашали в клан и заявка висит
// 0 айди это значит что он не в клане
// У игрока микро массив из айди и рейтинга


var clans_table =
[
	[1, "Мужики", "76561198066362606", 50, [["76561198066362606", 30020],["76561198066362601", 30020],["76561198066362602", 30020],["76561198066362603", 30020],["76561198066362604", 30]], ["76561198066362606"] ],
]

// Массив игрока
// Айди игрока, айди клана, получил инвайт в клан ( массив из айдишников клана приглашений )
var player_table =
[
	"76561198066362606", 0, [1]
]

var choose_kick_player_id = null

function UpdateClanInfo()
{
	$('#BodyPanel').RemoveAndDeleteChildren()
	$('#Buttons').RemoveAndDeleteChildren()
	if (player_table[1] == 0) {
		var NoClanTitle = $.CreatePanel("Label", $('#BodyPanel'), "");
		NoClanTitle.AddClass("NoClanTitle");
		NoClanTitle.text = $.Localize("#clan_no_clan")

		var NoClanDescription = $.CreatePanel("Label", $('#BodyPanel'), "");
		NoClanDescription.AddClass("NoClanDescription");
		NoClanDescription.text = $.Localize("#clan_no_clan_desc")

		var ButtonGreen = $.CreatePanel("Panel", $('#Buttons'), "");
		ButtonGreen.AddClass("ButtonGreen");

		var ButtonText = $.CreatePanel("Label", ButtonGreen, "");
		ButtonText.AddClass("ButtonText");
		ButtonText.text = $.Localize("#clan_create")

		ButtonGreen.SetPanelEvent("onactivate", function() { 
			OpenCreateClan()
		})

 

		var InviteListTitle = $.CreatePanel("Label", $('#BodyPanel'), "");
		InviteListTitle.AddClass("InviteListTitle");
		InviteListTitle.text = $.Localize("#clan_invites")

		var InviteList = $.CreatePanel("Panel", $('#BodyPanel'), "");
		InviteList.AddClass("InviteList");

		for (var i = 0; i < player_table[2].length; i++) {
			let invite_clan_info = null
			for (var d = 0; d < clans_table.length; d++) {
				if (player_table[2][i] == clans_table[d][0])
				{
					invite_clan_info = clans_table[d]
				}
			}
			var ClanInvitePanel = $.CreatePanel("Panel", $('#BodyPanel'), "ClanInvitePanel_"+i);
			ClanInvitePanel.AddClass("ClanInvitePanel");

			$.CreatePanel("DOTAAvatarImage", ClanInvitePanel, "InvitePlayerAvatar", { style: "width:40px;height:40px;vertical-align:center;", steamid: invite_clan_info[2] });
			$.CreatePanel("DOTAUserName", ClanInvitePanel, "InvitePlayerNickname", { style: "color:white;margin-left:10px;vertical-align:center;width:60px;height:20px;", steamid: invite_clan_info[2] });

			var InviteYou = $.CreatePanel("Label", ClanInvitePanel, "");
			InviteYou.AddClass("InviteYou");
			InviteYou.text = $.Localize("#clan_player_you_invite")

			var InviteYouClanName = $.CreatePanel("Label", ClanInvitePanel, "");
			InviteYouClanName.AddClass("InviteYouClanName");
			InviteYouClanName.text = invite_clan_info[1]

			var ClanInviteAccept = $.CreatePanel("Panel", ClanInvitePanel, "");
			ClanInviteAccept.AddClass("ClanInviteAccept");
			SetClanAccept(ClanInviteAccept, invite_clan_info[0])

			var ClanInviteDecline = $.CreatePanel("Panel", ClanInvitePanel, "");
			ClanInviteDecline.AddClass("ClanInviteDecline");
			SetClanDecline(ClanInviteDecline, invite_clan_info[0])
		}


		return
	}

	var clan_info = null
	var leader = false

	for (var i = 0; i < clans_table.length; i++) {
		if (player_table[1] == clans_table[i][0])
		{
			clan_info = clans_table[i]
		}
	}

	if (player_table[0] == clan_info[2])
	{
		leader = true
	}

	var ClanNameTitle = $.CreatePanel("Label", $('#BodyPanel'), "");
	ClanNameTitle.AddClass("ClanNameTitle");
	ClanNameTitle.text = clan_info[1]

	var ClanNameMaxPlayers = $.CreatePanel("Label", $('#BodyPanel'), "");
	ClanNameMaxPlayers.AddClass("ClanNameMaxPlayers");
	ClanNameMaxPlayers.text = $.Localize("#clan_players") + "( " + clan_info[4].length + " / " + clan_info[3] + " )"


	var PlayersNavigation = $.CreatePanel("Panel", $('#BodyPanel'), "PlayersNavigation");
	PlayersNavigation.AddClass("PlayersNavigation");

	var PlayersNavigationPlayersLabel = $.CreatePanel("Label", PlayersNavigation, "");
	PlayersNavigationPlayersLabel.AddClass("PlayersNavigationPlayersLabel");
	PlayersNavigationPlayersLabel.text = $.Localize("#clan_player")

	var PlayersNavigationPlayersLabelRating = $.CreatePanel("Label", PlayersNavigation, "");
	PlayersNavigationPlayersLabelRating.AddClass("PlayersNavigationPlayersLabelRating");
	PlayersNavigationPlayersLabelRating.text = $.Localize("#clan_rating")

	var PlayersList = $.CreatePanel("Panel", $('#BodyPanel'), "PlayersList");
	PlayersList.AddClass("PlayersList");

	for (var i = 0; i < clan_info[4].length; i++) {
		let is_leader = false
		if (clan_info[4][i][0] == clan_info[2])
		{
			is_leader = true
		}
		CreatePlayer(PlayersList, clan_info[4][i], is_leader, leader)
	}

	if (!leader)
	{
		var ButtonRed = $.CreatePanel("Panel", $('#Buttons'), "");
		ButtonRed.AddClass("ButtonRed");

		var ButtonText = $.CreatePanel("Label", ButtonRed, "");
		ButtonText.AddClass("ButtonText");
		ButtonText.text = $.Localize("#clan_leave")

		ButtonRed.SetPanelEvent("onactivate", function() { 
			PlayerClanLeave()
		})
	} else {
		if (clan_info[4].length > 1)
		{
			var LeaderButtonKick = $.CreatePanel("Panel", $('#Buttons'), "");
			LeaderButtonKick.AddClass("LeaderButtonKick");

			var ButtonText = $.CreatePanel("Label", LeaderButtonKick, "");
			ButtonText.AddClass("ButtonText");
			ButtonText.text = $.Localize("#clan_kick")

			LeaderButtonKick.SetPanelEvent("onactivate", function() { 
				KickPlayer()
			})

			var LeaderButtonInvite = $.CreatePanel("Panel", $('#Buttons'), "");
			LeaderButtonInvite.AddClass("LeaderButtonInvite");

			var ButtonText = $.CreatePanel("Label", LeaderButtonInvite, "");
			ButtonText.AddClass("ButtonText");
			ButtonText.text = $.Localize("#clan_invite")

			if (clan_info[4].length >= clan_info[3]){
				LeaderButtonInvite.style.saturation = 0
			} else {
				LeaderButtonInvite.SetPanelEvent("onactivate", function() { 
					OpenClanInvite()
				})
			}
		} else 
		{
			var ButtonRed = $.CreatePanel("Panel", $('#Buttons'), "");
			ButtonRed.AddClass("LeaderButtonKick");

			var ButtonText = $.CreatePanel("Label", ButtonRed, "");
			ButtonText.AddClass("ButtonText");
			ButtonText.text = $.Localize("#clan_delete")

			ButtonRed.SetPanelEvent("onactivate", function() { 
				DeleteClan()
			})

			var LeaderButtonInvite = $.CreatePanel("Panel", $('#Buttons'), "");
			LeaderButtonInvite.AddClass("LeaderButtonInvite");

			var ButtonText = $.CreatePanel("Label", LeaderButtonInvite, "");
			ButtonText.AddClass("ButtonText");
			ButtonText.text = $.Localize("#clan_invite")

			if (clan_info[4].length >= clan_info[3])
			{
				LeaderButtonInvite.style.saturation = 0
			} else {
				LeaderButtonInvite.SetPanelEvent("onactivate", function() { 
					OpenClanInvite()
				})
			}
		}
	}

}

function OpenCreateClan()
{
	$("#ClanNotification").style.visibility = "visible"
	$("#ClanNotificationCreateClan").style.visibility = "visible"
}

function CloseCreateClan()
{
	$("#ClanNotification").style.visibility = "collapse"
	$("#ClanNotificationCreateClan").style.visibility = "collapse"
}

function CreateClanServer()
{
	CloseCreateClan()
	var clan_name = $("#ClanName").text
	$("#ClanName").text = ""

	if (clan_name == "") {
		ErrorFromJs("clan_error_name")
		return
	}

	OpenWaitLoaiding()

	// НУЖНО СГЕНЕРИРОВАТЬ УНИКАЛЬНЫЙ АЙДИ КЛАНА И ОТПРАВИТЬ ЕГО В ЛУА
	// НАЗВАНИЕ КЛАНА В ПЕРЕМЕННОЙ clan_name
	// ИЗ ЛУА УЖЕ ВЫЗЫВАЙ ИВЕНТ ( clan_clan_created - НА СОЗДАНИЕ КЛАНА) ( clan_error_notification - НА ОШИБКУ С ТЕКСТОМ)

	//GameEvents.SendCustomGameEventToServer( "create_clan", { } );


	// Тестовая хуйня на стороне js
	//player_table[1] = 1
	//ClanCreated()
}

function OpenWaitLoaiding()
{
	$("#ClanNotification").style.visibility = "visible"
	$("#LoadingSpinner").style.visibility = "visible"
}

function CloseWaitLoaiding()
{
	$("#ClanNotification").style.visibility = "collapse"
	$("#LoadingSpinner").style.visibility = "collapse"
}

function ErrorFromJs(error_name)
{
	CloseWaitLoaiding()
	$("#ClanNotification").style.visibility = "visible"
	$("#Error").text = $.Localize(error_name)
	$("#Error").style.visibility = "visible"
	$.Schedule( 2, RemoveError );
}

function ErrorFromLua(table)
{
	CloseWaitLoaiding()
	$("#ClanNotification").style.visibility = "visible"
	$("#Error").text = $.Localize(table.text)
	$("#Error").style.visibility = "visible"
	$.Schedule( 2, RemoveError );
}

function RemoveError()
{
	CloseWaitLoaiding()
	$("#ClanNotification").style.visibility = "collapse"
	$("#Error").style.visibility = "collapse"
	$("#Error").text = $.Localize("#clan_default_error")
}

function ClanCreated()
{
	// НАДО ОБНОВИТЬ ИНФУ И МАССИВ ИГРОКА ДЛЯ ПОЛУЧЕНИЯ ИНФЫ О КЛАНЕ
	UpdateClanInfo()
	CloseWaitLoaiding()
	UpdateClanInfo()
} 

function CreatePlayer(panel, player_info, is_leader, leader_active_kick) 
{
	var row = $.CreatePanel("Panel", panel, "player_id_"+player_info[0]);
    row.AddClass("LinePlayer");

    $.CreatePanel("DOTAAvatarImage", row, "AvatarPlayer", { style: "width:30px;height:30px;margin-left:10px;vertical-align:center;", steamid: player_info[0] });

	var crown = $.CreatePanel("Panel", row, "");
    crown.AddClass("crown");

    if (is_leader)
    {
    	crown.style.opacity = 1
    }

	let user = $.CreatePanel("DOTAUserName", row, "NicknamePlayer", { style: "color:white;vertical-align:center;width:300px;", steamid: player_info[0] });

    var Rating = $.CreatePanel("Label", row, "player_id_rating_"+player_info[0]);
    Rating.AddClass("RatingLabel");
    Rating.text = String(player_info[1])

    if (leader_active_kick)
    {
    	row.SetPanelEvent("onactivate", function() { 
			ChooseKickPlayerFromClan(row, player_info[0])
		})
    }

}

function PlayerClanLeave()
{
	OpenWaitLoaiding()
	//GameEvents.SendCustomGameEventToServer( "leave_clan", { } ); // ПОКИНУТЬ КЛАН




	// Тестовая хуйня на стороне js
	//player_table[1] = 0
	//ClanLeaved()
}

function ClanLeaved()
{
	// НАДО ОБНОВИТЬ ИНФУ И МАССИВ ИГРОКА ДЛЯ ПОЛУЧЕНИЯ ИНФЫ О КЛАНЕ
	UpdateClanInfo()
	CloseWaitLoaiding()
	UpdateClanInfo() 
} 

function SetClanDecline(panel, id)
{
	panel.SetPanelEvent("onactivate", function() { 
		ClanDecline(id)
	})
}

function SetClanAccept(panel, id)
{
	panel.SetPanelEvent("onactivate", function() { 
		ClanAccept(id)
	})
}

function ClanDecline(clan_id)
{
	OpenWaitLoaiding()
	//GameEvents.SendCustomGameEventToServer( "clan_decline", { } ); // ОТКЛОНИТЬ ЗАЯВКУ В КЛАН И УДАЛИТЬ ИЗ МАССИВА ПРИГЛАШЕНИЙ


	// Тестовая хуйня на стороне js
	//for (var i = 0; i < player_table[2].length; i++) {
	//	if (player_table[2][i] == clan_id)
	//	{
	//		player_table[2].splice(i, 1);
	//	}
	//}
	//ClanDeclined()
} 

function ClanAccept(clan_id)
{
	OpenWaitLoaiding()
	//GameEvents.SendCustomGameEventToServer( "clan_accept", { } ); // ПРИНЯТЬ ЗАЯВКУ В КЛАН И УДАЛИТЬ ИЗ МАССИВА ПРИГЛАШЕНИЙ


	// Тестовая хуйня на стороне js
	//player_table[1] = clan_id
	//ClanAccepted()
}

function ClanDeclined()
{
	// НАДО ОБНОВИТЬ ИНФУ И МАССИВ ИГРОКА ДЛЯ ПОЛУЧЕНИЯ ИНФЫ О КЛАНЕ
	UpdateClanInfo()
	CloseWaitLoaiding()
	UpdateClanInfo() 
}

function ClanAccepted()
{
	// НАДО ОБНОВИТЬ ИНФУ И МАССИВ ИГРОКА ДЛЯ ПОЛУЧЕНИЯ ИНФЫ О КЛАНЕ
	UpdateClanInfo()
	CloseWaitLoaiding()
	UpdateClanInfo() 
}

function ChooseKickPlayerFromClan(panel, player_id)
{
	if (player_id == player_table[0])
	{
		return
	}

	choose_kick_player_id = player_id

	let panel_players = $.GetContextPanel().FindChildTraverse("PlayersList")
	if (panel_players)
	{
		for (var i = 0; i < panel_players.GetChildCount(); i++) {
			panel_players.GetChild(i).style.backgroundColor = "#0000";
		}
		panel.style.backgroundColor = "#75653dc5";
	}
}

function KickPlayer()
{
	if (choose_kick_player_id == null)
	{
		return
	}


	// choose_kick_player_id - хранится айди выбранного игрока для кика
	// player_table[1] -- айди клана


	OpenWaitLoaiding()
	//GameEvents.SendCustomGameEventToServer( "clan_player_kicked", { } ); // ОТПРАВИТЬ УДАЛЕНИЕ ИЗ КЛАНА ВЫБРАННОГО ИГРОКА



	// Тестовая хуйня на стороне js
	//for (var i = 0; i < clans_table.length; i++) {
	//	for (var d = 0; d < clans_table[i][4].length; d++) {
	//		if (clans_table[i][4][d][0] == choose_kick_player_id)
	//		{
	//			clans_table[i][4].splice(d, 1);
	//		}
	//	}
	//}
	//player_is_kicked()

}

function player_is_kicked()
{
	// НАДО ОБНОВИТЬ ИНФУ И МАССИВ ИГРОКА ДЛЯ ПОЛУЧЕНИЯ ИНФЫ О КЛАНЕ
	choose_kick_player_id = null
	UpdateClanInfo()
	CloseWaitLoaiding()
	UpdateClanInfo() 
}

function DeleteClan()
{
	// player_table[1] -- айди клана
	OpenWaitLoaiding()
	//GameEvents.SendCustomGameEventToServer( "clan_delete_clan", { } ); // УДАЛИТЬ КЛАН И НЕ ЗАБЫТЬ ВЫГНАТЬ ЛИДЕРА ИЗ КЛАНА


	// Тестовая хуйня на стороне js
	//player_table[1] = 0
	//ClanDeleted()
}

function ClanDeleted()
{
	// НАДО ОБНОВИТЬ ИНФУ И МАССИВ ИГРОКА ДЛЯ ПОЛУЧЕНИЯ ИНФЫ О КЛАНЕ
	UpdateClanInfo()
	CloseWaitLoaiding()
	UpdateClanInfo() 
}

function OpenClanInvite()
{
	$('#InvitePlayersList').RemoveAndDeleteChildren()
	$("#ClanNotification").style.visibility = "visible"
	$("#InviteClan").style.visibility = "visible"

	for (var i = 2; i < 14; i++) {
		var teamPlayers = Game.GetPlayerIDsOnTeam( i )
		for ( var playerId of teamPlayers )
		{
			CreateInvitePlayer(playerId)
		}
	}
}

function CloseClanInvite()
{
	$("#ClanNotification").style.visibility = "collapse"
	$("#InviteClan").style.visibility = "collapse"
}

function CreateInvitePlayer(player_id)
{
	let player_info_main = Game.GetPlayerInfo( player_id )

	if (player_info_main.player_steamid == player_table[0])
	{
		return
	}

	var row = $.CreatePanel("Panel", $('#InvitePlayersList'), "player_id_"+player_id);
    row.AddClass("LinePlayer");

	$.CreatePanel("DOTAAvatarImage", row, "AvatarPlayer", { style: "width:30px;height:30px;margin-left:10px;vertical-align:center;", steamid: player_info_main.player_steamid });
	$.CreatePanel("DOTAUserName", row, "NicknamePlayer", { style: "color:white;vertical-align:center;width:300px;margin-left:20px;", steamid: player_info_main.player_steamid });

	var InvitePlayerButton = $.CreatePanel("Panel", row, "");
	InvitePlayerButton.AddClass("InvitePlayerButton");

	var InvitePlayerButtonLabel = $.CreatePanel("Label", InvitePlayerButton, "");
	InvitePlayerButtonLabel.AddClass("InvitePlayerButtonLabel");
	InvitePlayerButtonLabel.text = $.Localize("#clan_invite")

	let player_invited = false


	let invite_clan_info = null
	for (var d = 0; d < clans_table.length; d++) {
		if (player_table[1] == clans_table[d][0])
		{
			invite_clan_info = clans_table[d]
		}
	}

	for (var i = 0; i < invite_clan_info[5].length; i++) {
		if (invite_clan_info[5][i] == player_info_main.player_steamid)
		{
			player_invited = true
		}
	}


	if (player_invited)
	{
		InvitePlayerButton.style.saturation = 0;
		InvitePlayerButtonLabel.text = $.Localize("#clan_player_invited")
	} else {
    	InvitePlayerButton.SetPanelEvent("onactivate", function() { 
			InvitePlayer(player_info_main.player_steamid)
		})		
	}
}

function InvitePlayer(player_steam_id)
{
	// player_table[1] -- айди клана
	// player_steam_id -- стим айди игрока
	OpenWaitLoaiding()
	//GameEvents.SendCustomGameEventToServer( "clan_delete_clan", { } ); // ОТПРАВИТЬ ПРИГЛАШЕНИЕ + ДОБАВИТЬ В МАССИВ КЛАНА ЧТО ОН ПРИГЛАШЕН



	// Тестовая хуйня на стороне js
	//player_invited()
}

function player_invited()
{
	// НАДО ОБНОВИТЬ ИНФУ И МАССИВ ИГРОКА ДЛЯ ПОЛУЧЕНИЯ ИНФЫ О КЛАНЕ
	OpenClanInvite()
	UpdateClanInfo()
	CloseWaitLoaiding()
	OpenClanInvite()
	UpdateClanInfo() 
}