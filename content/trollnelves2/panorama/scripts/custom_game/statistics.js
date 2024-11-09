var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements").FindChildTraverse("MenuButtons");
if ($("#StatisticsButton")) {
    if (parentHUDElements.FindChildTraverse("StatisticsButton")){
        $("#StatisticsButton").DeleteAsync( 0 );
    } else {
        $("#StatisticsButton").SetParent(parentHUDElements);
    }
}

var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "";

function ToggleStatistics() {
    if (toggle === false) {
        if (cooldown_panel == false) {
            toggle = true;
            if (first_time === false) {
                first_time = true;
                $("#Statistics").AddClass("sethidden");
            }  
            if ($("#Statistics").BHasClass("sethidden")) {
                $("#Statistics").RemoveClass("sethidden");
            }
            $("#Statistics").AddClass("setvisible");
            $("#Statistics").style.visibility = "visible"
            UpdateTopWins()
            UpdateTopPlays()
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
            })
        }
    } else {
        if (cooldown_panel == false) {
            toggle = false;
            if ($("#Statistics").BHasClass("setvisible")) {
                $("#Statistics").RemoveClass("setvisible");
            }
            $("#Statistics").AddClass("sethidden");
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
                $("#Statistics").style.visibility = "collapse"
            })
        }
    }
}



function UpdateTopWins() {
    $('#PlayersColumnElvesRating').RemoveAndDeleteChildren()
    var player_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))[5];
    var rating_elf = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))[8][0];
    var rating_troll = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))[9][0];
    var player_rep = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))[10];
    var Line = $.CreatePanel("Panel", $("#PlayersColumnElvesRating"), "player_id_"+player_table[1]);
    Line.AddClass("LinePlayer");
    $.CreatePanelWithProperties("DOTAAvatarImage", Line, "AvatarLeaderboard", { style: "width:51px;height:51px;", steamid: player_table[1] });
    var SteamID = $.CreatePanel("Label", Line, "player_id_rating_"+player_table[1]);
    SteamID.AddClass("RatingLabel");
    //$.Msg(player_rep)
    var text = "no"
    if (player_table[0] != 0)
        text = player_table[0]
    SteamID.text = String("Friend ID: " + text)
    var count = 4
    if (Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()) == Players.GetLocalPlayer())
        count = 7
    for (var i = 1; i <= count;i++)
    {
        let Line = $.CreatePanel("Panel", $("#PlayersColumnElvesRating"), "player_id_"+i);
        Line.AddClass("LinePlayer");
        $.CreatePanelWithProperties("Label", Line, "AvatarStatistics", { text: $.Localize( "#PlayerStats"+i )});
        if ( i == 1)
        {
            let Rating = $.CreatePanel("Label", Line, "player_id_rating_"+i);
            Rating.AddClass("RatingLabel");
            Rating.text = String(player_rep[0])
            
        }
        if ( i == 2)
        {
            let Rating = $.CreatePanel("Label", Line, "player_id_rating_"+i);
            Rating.AddClass("RatingLabel");
            Rating.text = String(rating_elf.score || 0)
            
        }
        else if ( i == 3)
        {
            let Rating = $.CreatePanel("Label", Line, "player_id_rating_"+i);
            Rating.AddClass("RatingLabel");
            Rating.text = String(rating_troll.score || 0)
            
        }
        else if (i == 4)
        {
            let Rating = $.CreatePanel("Label", Line, "player_id_rating_"+i);
            Rating.AddClass("RatingLabel");
            Rating.text = String(player_table[2])
        }
        
        else if ( i == 5)
        {
            let RewardClaimed = $.CreatePanel("Panel", Line, "");
            RewardClaimed.AddClass("RewardClaimed");

            let RewardClaimLabel = $.CreatePanel("Label", RewardClaimed, "");
            RewardClaimLabel.AddClass("RewardClaimLabel");
            if (player_table[4] == 1)
                RewardClaimLabel.text = $.Localize("#fps_on")
            else
                RewardClaimLabel.text = $.Localize("#fps_off")

            if (Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()) == Players.GetLocalPlayer())
			    RewardClaimed.SetPanelEvent("onactivate", function() { RecieveReward( RewardClaimLabel, player_table[4], "fps") } );
            
        }

        else if ( i == 6)
        {
            let RewardClaimed = $.CreatePanel("Panel", Line, "");
            RewardClaimed.AddClass("RewardClaimed");

            let RewardClaimLabel = $.CreatePanel("Label", RewardClaimed, "");
            RewardClaimLabel.AddClass("RewardClaimLabel");
            if (player_table[3] == 1)
                RewardClaimLabel.text = $.Localize("#fps_on")
            else
                RewardClaimLabel.text = $.Localize("#fps_off")

            if (Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()) == Players.GetLocalPlayer())
			    RewardClaimed.SetPanelEvent("onactivate", function() { RecieveReward( RewardClaimLabel, player_table[3], "mute") } );
            
        }

        else if ( i == 7)
        {
            let RewardClaimed = $.CreatePanel("Panel", Line, "");
            RewardClaimed.AddClass("RewardClaimed");

            let RewardClaimLabel = $.CreatePanel("Label", RewardClaimed, "");
            RewardClaimLabel.AddClass("RewardClaimLabel");
            if (player_table[5] == 1)
                RewardClaimLabel.text = $.Localize("#fps_on")
            else
                RewardClaimLabel.text = $.Localize("#fps_off")

            if (Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()) == Players.GetLocalPlayer())
			    RewardClaimed.SetPanelEvent("onactivate", function() { RecieveReward( RewardClaimLabel, player_table[5], "block") } );
            
        }
        
    }
}

function RecieveReward( RewardClaimLabel, player_table, type)
{
	if (player_table == 1)
        {
            RewardClaimLabel.text = $.Localize("#fps_off")
            player_table = 0;
        }
    else
        {
            RewardClaimLabel.text = $.Localize("#fps_on")
            player_table = 1
        }
	GameEvents.SendCustomGameEventToServer( "Statistics", {id: Players.GetLocalPlayer(), count: player_table, type: type} ); // отправляешь ивент 
}

function UpdateTopPlays() {
    $('#PlayersColumnMainRating').RemoveAndDeleteChildren()
    $('#PlayersColumnTrollRating').RemoveAndDeleteChildren()
    for (var i = 1; i <= 12;i++)
    {
        var player_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))[8][0];
        CreatePlayer(i, $("#PlayersColumnMainRating"),player_table)
    }
    for (var i = 1; i <= 12;i++)
    {
        var player_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))[9][0];
        CreatePlayer(i, $("#PlayersColumnTrollRating"),player_table)
    }
}

function CreatePlayer(id,  panel,player_table) {
    var Line = $.CreatePanel("Panel", panel, "player_id_"+id);
    Line.AddClass("LinePlayer");
    $.CreatePanelWithProperties("Label", Line, "AvatarStatistics", { text: $.Localize( "#PlayerInfo"+id )});
    var Rating = $.CreatePanel("Label", Line, "player_id_rating_"+id);
    Rating.AddClass("RatingLabel");
    var text = "no"

    if (id == 1 && player_table != 0 )
        text = player_table.bonusPercent
    else if (id == 2 && player_table != 0 )
        text = player_table.matchID
    else if (id == 3 && player_table != 0 )
        text = player_table.chance + "%"
    else if (id == 4 && player_table != 0 )
        text = player_table.kill
    else if (id == 5 && player_table != 0 )
        text = player_table.death
    else if (id == 6 && player_table != 0 )
        text = player_table.time
    else if (id == 7 && player_table != 0 )
        text = player_table.gps
    else if (id == 8 && player_table != 0 )
        text = player_table.lps
    else if (id == 9 && player_table != 0 )
        text = player_table.goldGained
    else if (id == 10 && player_table != 0 )
        text = player_table.goldGiven
    else if (id == 11 && player_table != 0 )
        text = player_table.lumberGained
    else if (id == 12 && player_table != 0 )
        text = player_table.lumberGiven


    Rating.text = String(text);
}

function SwitchTab(tab, button) {
    $("#StatisticsPanel1").style.visibility = "collapse";
    $("#StatisticsPanel2").style.visibility = "collapse";

    for (var i = 0; i < $("#MenuButtons").GetChildCount(); i++) {
        $("#MenuButtons").GetChild(i).style.boxShadow = "0px 0px 1px 1px black";
    }

    $("#" + button).style.boxShadow = "0px 0px 1px 0px white";
    $("#" + tab).style.visibility = "visible";
}

(function()
{

})();