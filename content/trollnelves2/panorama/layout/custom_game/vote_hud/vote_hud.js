$.GetContextPanel().GetParent().style.marginLeft = "0px;"

var ACTIVATED_STAGE_SCREEN = false
var ACTIVATED_STAGE_MAP = false
var ACTIVATED_STAGE_ROLE = false
var ACTIVATED_STAGE_PERKS = false
var OLD_SCREEN_STAGE = null
var SPELLS_TEXTURE = {}
var player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
var players_activated_spells = CustomNetTables.GetTableValue("game_spells_lib", "spell_active")
var game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list")

CustomNetTables.SubscribeNetTableListener( "game_spells_lib", UpdateSpellsLibTable );

function UpdateSpellsLibTable(t,k,d)
{
    if (k == "spell_active")
    {
        players_activated_spells = d
        UpdateCurrentSpells()
        UpdateListSelected()
    }
}

GameEvents.SubscribeProtected( "troll_elves_init_stage_screen", InitStageScreen );

function InitStageScreen()
{
    if (ACTIVATED_STAGE_SCREEN) { return }
    ACTIVATED_STAGE_SCREEN = true
    $("#GameSetupStages").style.opacity = "1"
}

function CloseOtherScreenStage()
{
    if (OLD_SCREEN_STAGE)
    {
        OLD_SCREEN_STAGE.style.opacity = "0"
    }
}

GameEvents.SubscribeProtected( "troll_elves_init_stage_select_map", InitStageSelectedMap );

function InitStageSelectedMap(data)
{
    if (ACTIVATED_STAGE_MAP) { return }
    ACTIVATED_STAGE_MAP = true
    CloseOtherScreenStage()
    OLD_SCREEN_STAGE = $("#WindowMapStage")
    if (data.maps)
    {
        for (var i = 1; i <= Object.keys(data.maps).length; i++) 
        {
            CreatePanelMap(data.maps, i)
        }
    }
    CreatePlayersVotesMap()
}

function CreatePlayersVotesMap()
{
    for (let i = 0; i <= 24; i++) 
    {
        if (Players.IsValidPlayerID( i ))
        {
            CreatePlayerVotePanel(i)
        }
    }
}

function CreatePlayerVotePanel(i)
{
    let PlayersCounter = $("#WindowStageMapPlayersCounter")

    let vote_player_panel = $.CreatePanel("Panel", PlayersCounter, "player_vote_"+i);
    vote_player_panel.AddClass("vote_player_panel");

    let vote_player_panel_enabled = $.CreatePanel("Panel", vote_player_panel, "");
    vote_player_panel_enabled.AddClass("vote_player_panel_enabled");
}

function CreatePanelMap(info, i) 
{
    let ChooseMapButton = $.CreatePanel("Panel", $("#MapsList"), "Map_id_"+i);
    ChooseMapButton.AddClass("ChooseMapButton");

    let ChooseMapButtonBG = $.CreatePanel("Panel", ChooseMapButton, "");
    ChooseMapButtonBG.AddClass("ChooseMapButtonBG");
    ChooseMapButtonBG.style.backgroundImage = "url('" + info[i][3] + "')";
    ChooseMapButtonBG.style.backgroundSize = "100%"

    let ChooseMapButtonInfo = $.CreatePanel("Panel", ChooseMapButton, "");
    ChooseMapButtonInfo.AddClass("ChooseMapButtonInfo");

    let ChooseMapButtonName = $.CreatePanel("Label", ChooseMapButtonInfo, "");
    ChooseMapButtonName.AddClass("ChooseMapButtonName");
    ChooseMapButtonName.text = info[i][1];

    let ChooseMapButtonVotesCounter = $.CreatePanel("Label", ChooseMapButtonInfo, "ChooseMapButtonVotesCounter");
    ChooseMapButtonVotesCounter.AddClass("ChooseMapButtonVotesCounter");
    ChooseMapButtonVotesCounter.text = ""

    ChooseMapButton.SetPanelEvent("onactivate", function() 
    {
        GameEvents.SendCustomGameEventToServer( "troll_elves_map_votes", {panel_id : i});
        Game.EmitSound("General.ButtonClick");
        LocalChoose(ChooseMapButton)
    });
}

function LocalChoose(panel)
{
    for (let child of $("#MapsList").Children())
    {
        child.ClearPanelEvent("onactivate")
        child.AddClass("DisabledChoose")
    }
    panel.SetHasClass("SelectedMapLocal", true);
}

GameEvents.SubscribeProtected( "troll_elves_map_votes_change_visual", UpdateMapSelectorPlayers );

function UpdateMapSelectorPlayers(data)
{
    let all_votes = 0
    for (table_id in data)
    {
        let map_info = data[table_id]
        let votes = map_info.votes
        let map_panel = $("#MapsList").FindChildTraverse("Map_id_"+map_info.map_id)
        if (map_panel)
        {
            let ChooseMapButtonVotesCounter = map_panel.FindChildTraverse("ChooseMapButtonVotesCounter")
            if (ChooseMapButtonVotesCounter)
            {
                if (votes > 0)
                {
                    all_votes = all_votes + votes
                    ChooseMapButtonVotesCounter.text = votes + " " + $.Localize("#votes")
                }
            }
        }
    }
    for (let i = 1; i <= 24; i++) 
    {
        if (all_votes >= i)
        {
            let PlayersCounter = $("#WindowStageMapPlayersCounter")
            let player_vote = PlayersCounter.FindChildTraverse("player_vote_"+(i-1))
            if (player_vote)
            {
                player_vote.AddClass("PlayerIsVote")
            }  
        }
    }
}

GameEvents.SubscribeProtected( "troll_elves_phase_time", troll_elves_phase_time );

function troll_elves_phase_time(data)
{
    let time = data.time
    let max_time = data.max_time
    let stage = data.stage
    let map = data.map
    let role = data.role

    for (let i = 1; i <= 3; i++) 
    {
        let StageLinePanel = $("#StageLinePanel_"+i)
        let StageLineFront = StageLinePanel.FindChildTraverse("StageLineFront_"+i)
        if (i == stage)
        {
            StageLinePanel.SetHasClass("ActiveStage", true)
            if (StageLineFront)
            {
                StageLineFront.style.width = (max_time - time) / max_time * 100 + "%"
            }
        }   
        else
        {
            StageLinePanel.SetHasClass("ActiveStage", false)
        }
        if (stage > i)
        {
            if (StageLineFront)
            {
                StageLineFront.style.width = "100%"
            }
        }
    }
    $("#StageTimer").text = time
    
    if (role)
    {
        let hero_localize = "you_play_elf_role"
        if (Players.GetTeam( Players.GetLocalPlayer() ) == 3)
        {
            hero_localize = "you_play_troll_role"
        }
        $("#GameInfo").style.opacity = "1"
        $("#SettingsHero").text = $.Localize("#"+hero_localize)
        $("#SettingsHero").visible = true
    }
    if (map)
    {
        $("#GameInfo").style.opacity = "1"
        $("#SettingsMap").text = $.Localize("#is_current_map") + " " + map
        $("#SettingsMap").visible = true
    }
}

GameEvents.SubscribeProtected( "troll_elves_init_stage_select_role", InitStageSelectedRole );

function InitStageSelectedRole()
{
    if (ACTIVATED_STAGE_ROLE) { return }
    ACTIVATED_STAGE_ROLE = true
    CloseOtherScreenStage()
    $("#WindowRoleStage").style.opacity = "1"
    OLD_SCREEN_STAGE = $("#WindowRoleStage")
    let player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());
    if (player_table)
    {
        $("#YourChanceTroll").text = $.Localize( "#shop_trollchance" ) + player_table[2][0] + "%"
    }
}

function ChooseTeam(team) 
{
    $("#ElfPanel").SetHasClass("SelectedRole", false)
    $("#TrollPanel").SetHasClass("SelectedRole", false)
	var PlayerID = Players.GetLocalPlayer()
	GameEvents.SendCustomGameEventToServer("player_team_choose", { "id": PlayerID, "team": team });
    if (team == "elf")
    {
        $("#ElfPanel").SetHasClass("SelectedRole", true)
    }
    else if (team == "troll")
    {
        $("#TrollPanel").SetHasClass("SelectedRole", true)
    }
}

GameEvents.SubscribeProtected( "troll_elves_init_stage_select_perks", InitStageSelectedPerks );

function InitStageSelectedPerks()
{
    if (ACTIVATED_STAGE_PERKS) { return }
    ACTIVATED_STAGE_PERKS = true
    CloseOtherScreenStage()
    $("#WindowPerksStage").style.opacity = "1"
    OLD_SCREEN_STAGE = $("#WindowPerksStage")
    InitSpellList()
    UpdateCurrentSpells()
    UpdateListSelected()
}

function InitSpellList()
{
    let active_shop = 0
    if (Players.GetTeam( Players.GetLocalPlayer() ) == 3)
    {
        active_shop = 1
    }
    for (var i = 0; i <= Object.keys(game_spells_lib).length; i++)
    {
        if (game_spells_lib[i] && game_spells_lib[i][6] == active_shop)
        {
            CreateSpell(game_spells_lib[i], $("#AllPerksList"), true)
        }
    }
}

function CreateSpell(info, parent, active)
{
    let panel_id = ""
    if (active)
    {
        panel_id = info[1]
    }

    let player_id = Players.GetLocalPlayer()
    
    let PerkPanel = $.CreatePanel("Panel", parent, panel_id);
    PerkPanel.AddClass("PerkPanel");

    let PerkImage = $.CreatePanel("Panel", PerkPanel, "");
    PerkImage.AddClass("PerkImage");
    PerkImage.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + GetSpellTexture(info[1], GetPlayerSpellLevel(info[1], true)) + '.png")';
    PerkImage.style.backgroundSize = "100%"

    if (active)
    {
        PerkPanel.SetPanelEvent("onactivate", function()
        {
            GameEvents.SendCustomGameEventToServer( "event_set_activate_spell", {spell_name : info[1], modifier_name : info[3]} );
        })
        let PerkPanelNumber = $.CreatePanel("Label", PerkPanel, "PerkPanelNumber");
        PerkPanelNumber.AddClass("PerkPanelNumber");
        PerkPanelNumber.text = "2"

        SetShowText(PerkPanel, info[1] + "_description_level_" + GetSelectedPlayerSpellLevel(info[1], player_id), info[1], GetSelectedPlayerSpellLevel(info[1], player_id))
    }
} 

function UpdateCurrentSpells()
{
    $("#PlayerSelectedPerks").RemoveAndDeleteChildren()
    player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
    let active_table = players_activated_spells
    let player_id = Players.GetLocalPlayer()
    for (let i = 1; i <= 3; i++)
    {
        let spell_info = {}
        if (active_table)
        {
            if (active_table[player_id])
            {
                if (active_table[player_id][i] && active_table[player_id][i] != "")
                {
                    spell_info = GetSpellInformation(active_table[player_id][i])
                }
            }
        }
        CreateSpell(spell_info, $("#PlayerSelectedPerks"))
    }
}

function UpdateListSelected()
{
    let active_table = players_activated_spells
    let player_id = Players.GetLocalPlayer()
    for (let child of $("#AllPerksList").Children())
    {
        if (active_table && active_table[player_id]) 
        {
            if (child.id == active_table[player_id][1] || child.id == active_table[player_id][2] || child.id == active_table[player_id][3])
            {
                let PerkPanelNumber = child.FindChildTraverse("PerkPanelNumber")
                if (PerkPanelNumber)
                {
                    PerkPanelNumber.text = (child.id == active_table[player_id][1] ? "1" : (child.id == active_table[player_id][2] ? "2" : "3"))
                }
                child.SetHasClass("ActivePerk", true)
            }
            else
            {
                child.SetHasClass("ActivePerk", false)
            } 
        }
    }
}

function GetSpellInformation(spell_name)
{
    for (var i = 0; i <= Object.keys(game_spells_lib).length; i++)
    {
        if (game_spells_lib[i] && game_spells_lib[i][1] == spell_name)
        {
            return game_spells_lib[i]
        }
    }
    return null
}

function PlayerHasSpell(spell)
{
    if (player_table)
    {
        for ( var id in player_table)
        {
            if (player_table[id])
            {
                if (player_table[id][1] == spell)
                {
                    return true
                }
            }
        }
    }
    return false
}

function GetSpellTexture(spell_name, any_level)
{
    if (any_level == null)
    {
        any_level = 1
    }
    if (SPELLS_TEXTURE[spell_name + "_" + any_level])
    {
        return SPELLS_TEXTURE[spell_name + "_" + any_level]
    }
    for (var i = 0; i <= Object.keys(game_spells_lib).length; i++)
    {
        if (game_spells_lib[i] && game_spells_lib[i][1] == spell_name)
        {
            return game_spells_lib[i][2] //+ "_" + any_level
        }
    }
}

function GetPlayerSpellLevel(spell_name, texture)
{
    player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
    if (player_table)
    {
        for ( var id in player_table)
        {
            if (player_table[id])
            {
                if (player_table[id][1] == spell_name)
                {
                    return player_table[id][2]
                }
            }
        }
    }
    if (texture)
    {
        return 1
    }
    return 0
}

function SetShowText(panel, text, spell, level)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, "<b>" + $.Localize("#"+spell) + " " + level + "</b><br>" + $.Localize("#"+text)) });
        
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });       
}

function GetSelectedPlayerSpellLevel(spell_name, id)
{
    if (player_table)
    {
        for ( var id in player_table)
        {
            if (player_table[id])
            {
                if (player_table[id][1] == spell_name)
                {
                    return player_table[id][2]
                }
            }
        }
    }
    return 0
}

(function () {
	Game.AutoAssignPlayersToTeams();
})();