"use strict";

function ChooseTeam(team, panel) {
	var PlayerID = Players.GetLocalPlayer()
	GameEvents.SendCustomGameEventToServer("player_team_choose", { "id": PlayerID, "team": team });
	$("#border_creep").SetHasClass("active_border", false)
	$("#border_hero").SetHasClass("active_border", false)
	$("#" + panel).SetHasClass("active_border", true)
}

//--------------------------------------------------------------------------------------------------
// Update the state for the transition timer periodically
//--------------------------------------------------------------------------------------------------
var timer = CustomNetTables.GetTableValue( "building_settings", "team_choice_time").value;
function UpdateTimer() {
	$("#TeamChoiceWrapper").SetDialogVariableInt("countdown_timer_seconds", timer);
    CheckMapVisible();
    if (timer <= 10)
    {
        for (var i = 0; i < $("#MapsContainer").GetChildCount(); i++) 
        {
            $("#MapsContainer").GetChild(i).SetPanelEvent("onactivate", function() {});
        }
    }
	if (timer-- > 0) 
    {
		$.Schedule(1, UpdateTimer);
	}
}

(function () {
	var mapInfo = Game.GetMapInfo();
	$("#MapInfo").SetDialogVariable("map_name", mapInfo.map_display_name);
	UpdateTimer();
	Game.AutoAssignPlayersToTeams();
    ShowInit();
})();

var Init = false
var Init2 = false

function ShowInit()
{
    GameEvents.SubscribeProtected( "troll_elves_load_maps_list", troll_elves_load_maps_list );
    GameEvents.SubscribeProtected( "troll_elves_map_votes_change_visual", SwapStyle );

    GameEvents.SubscribeProtected( "troll_elves_load_mods_list", troll_elves_load_mods_list );
    GameEvents.SubscribeProtected( "troll_elves_mod_votes_change_visual", SwapStyleMods );
}

function troll_elves_load_maps_list(data)
{
    if (Init)
    {
        return
    }
    if (data.maps)
    {
        for (var i = 1; i <= Object.keys(data.maps).length; i++) 
        {
            CreatePanelMap(data.maps, i)
        }
    }
    Init = true
}

function SetButtonActive(panel, panel_id)
{
    panel.SetPanelEvent("onactivate", function() 
    {
        GameEvents.SendCustomGameEventToServer( "troll_elves_map_votes", {panel_id : panel_id } );
        Game.EmitSound("General.ButtonClick");
        LocalChoose(panel_id)
    });
}

function SwapStyle(data)
{
    for (var i = 1; i <= Object.keys(data).length; i++) 
    {
        for (var d = 1; d <= Object.keys(data[i]).length; d++) 
        {
            let percent = data[i][d].percent
            let percent_panel = $("#MapsContainer").FindChildTraverse("button_select_percent_" + data[i][d].map_id)
            if (percent_panel) {
                percent_panel.text = percent + "%"
            }
        }
    }
}

function LocalChoose(id)
{
    for (var i = 0; i < $("#MapsContainer").GetChildCount(); i++) 
    {
        $("#MapsContainer").GetChild(i).FindChildTraverse("button_select_map_" + (i + 1)).SetHasClass("active", false)
        $("#MapsContainer").GetChild(i).SetPanelEvent("onactivate", function() {});
    }
    $("#button_select_map_" + id).SetHasClass("active", true);
}

function CreatePanelMap(info, i) 
{
    var ChooseMapButton = $.CreatePanel("Panel", $("#MapsContainer"), "");
    ChooseMapButton.AddClass("ChooseMapButton");

    var RealChooseKillsButton = $.CreatePanel("Panel", ChooseMapButton, "button_select_map_" + i);
    RealChooseKillsButton.AddClass("RealChooseMapButton");

    var ImageKills = $.CreatePanel("Label", ChooseMapButton, "");
    ImageKills.AddClass("ImageMap");
    ImageKills.text = info[i][1];
    var percent = $.CreatePanel("Label", ChooseMapButton, "button_select_percent_" + i);
    percent.AddClass("ImageMapPercent");
    percent.text = "0%"

    SetButtonActive(ChooseMapButton, i)
}

/////////////////
//////////////////
//////////////////
///////////////
/////////////
///
///
///
///
function troll_elves_load_mods_list(data)
{
    if (Init2)
    {
        return
    }
    if (data.maps)
    {
        for (var i = 1; i <= Object.keys(data.maps).length; i++) 
        {
            CreatePanelMod(data.maps, i)
        }
    }
    Init2 = true
}

function SetButtonActive2(panel, panel_id)
{
    panel.SetPanelEvent("onactivate", function() 
    {
        GameEvents.SendCustomGameEventToServer( "troll_elves_mod_votes", {panel_id : panel_id } );
        Game.EmitSound("General.ButtonClick");
        LocalChoose2(panel_id)
    });
}

function SwapStyleMods(data)
{
    for (var i = 1; i <= Object.keys(data).length; i++) 
    {
        for (var d = 1; d <= Object.keys(data[i]).length; d++) 
        {
            let percent = data[i][d].percent
            let percent_panel = $("#AngelWolfContainer").FindChildTraverse("button_select_percent2_" + data[i][d].map_id)
            if (percent_panel) {
                percent_panel.text = percent + "%"
                if (parseInt(percent_panel.text) >= 51)
                {
                    percent_panel.style.color = "#3ED038";
                }
            }
        }
    }
}

function LocalChoose2(id)
{
    for (var i = 0; i < $("#AngelWolfContainer").GetChildCount(); i++) 
    {
        $("#AngelWolfContainer").GetChild(i).FindChildTraverse("button_select_map2_" + (i + 1)).SetHasClass("active", false)
        $("#AngelWolfContainer").GetChild(i).SetPanelEvent("onactivate", function() {});
    }
    $("#button_select_map2_" + id).SetHasClass("active", true);
}

function CreatePanelMod(info, i) 
{
    var ChooseMapButton = $.CreatePanel("Panel", $("#AngelWolfContainer"), "");
    ChooseMapButton.AddClass("ChooseModButton");

    var RealChooseKillsButton = $.CreatePanel("Panel", ChooseMapButton, "button_select_map2_" + i);
    RealChooseKillsButton.AddClass("RealChooseModButton");

    var ImageKills = $.CreatePanel("Label", ChooseMapButton, "");
    ImageKills.AddClass("ImageMap");
    ImageKills.text = info[i][1];
    var percent = $.CreatePanel("Label", ChooseMapButton, "button_select_percent2_" + i);
    percent.AddClass("ImageMapPercent");
    percent.text = "0%"

    SetButtonActive2(ChooseMapButton, i)
}


function CheckMapVisible()
{
    if (Game.GetMapInfo().map_display_name == "clanwars")
    {
        $("#ChooseMapList").style.visibility = "collapse"
        $("#ChooseAngelWolf").style.visibility = "collapse"
    }
    else if (Game.GetMapInfo().map_display_name == "1x1")
    {
        $("#ChooseAngelWolf").style.visibility = "collapse"
    }
}

