// @ts-nocheck
"use strict";

var g_TeamPanels = [];

var g_PlayerPanels = [];

var g_TEAM_SPECATOR = 1;

var MAP_NAME_ACTIVE = "clanwars";

function TeamSelect_OnLeaveTeamPressed() {
    Game.PlayerJoinTeam(DOTATeam_t.DOTA_TEAM_NOTEAM);
}

function OnLockAndStartPressed() {
    if (Game.GetUnassignedPlayerIDs().length > 0) {
        return;
    }

    Game.SetTeamSelectionLocked(true);
    Game.SetAutoLaunchEnabled(false);
    Game.SetRemainingSetupTime(4);
}

function OnCancelAndUnlockPressed() {
    Game.SetTeamSelectionLocked(false);
    Game.SetRemainingSetupTime(-1);
}

function OnAutoAssignPressed() {
    Game.AutoAssignPlayersToTeams();
}

function OnShufflePlayersPressed() {
    Game.ShufflePlayerTeamAssignments();
}

function FindOrCreatePanelForPlayer(playerId, parent) {
    for (let i = 0; i < g_PlayerPanels.length; ++i) {
        const playerPanel = g_PlayerPanels[i];

        if (playerPanel.GetAttributeInt("player_id", -1) == playerId) {
            playerPanel.SetParent(parent);
            return playerPanel;
        }
    }

    const newPlayerPanel = $.CreatePanel("Panel", parent, "player_root");
    newPlayerPanel.SetAttributeInt("player_id", playerId);
    newPlayerPanel.BLoadLayout("file://{resources}/layout/custom_game/team_select/team_select_player.xml", false, false);
    g_PlayerPanels.push(newPlayerPanel);
    return newPlayerPanel;
}

function FindPlayerSlotInTeamPanel(teamPanel, playerSlot) {
    const playerListNode = teamPanel.FindChildInLayoutFile("PlayerList");
    if (playerListNode == null) {
        return null;
    }

    const nNumChildren = playerListNode.GetChildCount();
    for (let i = 0; i < nNumChildren; ++i) {
        const panel = playerListNode.GetChild(i);
        if (panel.GetAttributeInt("player_slot", -1) == playerSlot) {
            return panel;
        }
    }

    return null;
}

function UpdateTeamPanel(teamPanel) {
    const teamId = teamPanel.GetAttributeInt("team_id", -1);
    if (teamId <= 0) {
        return;
    }

    const teamPlayers = Game.GetPlayerIDsOnTeam(teamId);
    for (var i = 0; i < teamPlayers.length; ++i) {
        var playerSlot = FindPlayerSlotInTeamPanel(teamPanel, i);
        playerSlot.RemoveAndDeleteChildren();
        FindOrCreatePanelForPlayer(teamPlayers[i], playerSlot);
    }

    const teamDetails = Game.GetTeamDetails(teamId);
    const nNumPlayerSlots = teamDetails.team_max_players;
    for (var i = teamPlayers.length; i < nNumPlayerSlots; ++i) {
        var playerSlot = FindPlayerSlotInTeamPanel(teamPanel, i);
        if (playerSlot.GetChildCount() == 0) {
            const empty_slot = $.CreatePanel("Panel", playerSlot, "player_root");
            empty_slot.BLoadLayout("file://{resources}/layout/custom_game/team_select/team_select_empty_slot.xml", false, false);
        }
    }

    teamPanel.SetHasClass("team_is_full", (teamPlayers.length === teamDetails.team_max_players));

    const localPlayerInfo = Game.GetLocalPlayerInfo();
    if (localPlayerInfo) {
        const localPlayerIsOnTeam = (localPlayerInfo.player_team_id === teamId);
        teamPanel.SetHasClass("local_player_on_this_team", localPlayerIsOnTeam);
    }
}

function OnTeamPlayerListChanged() {
    const unassignedPlayersContainerNode = $("#UnassignedPlayersContainer");
    if (unassignedPlayersContainerNode === null) {
        return;
    }

    for (var i = 0; i < g_PlayerPanels.length; ++i) {
        const playerPanel = g_PlayerPanels[i];
        playerPanel.SetParent(unassignedPlayersContainerNode);
    }

    const unassignedPlayers = Game.GetUnassignedPlayerIDs();
    for (var i = 0; i < unassignedPlayers.length; ++i) {
        const playerId = unassignedPlayers[i];
        FindOrCreatePanelForPlayer(playerId, unassignedPlayersContainerNode);
    }

    for (var i = 0; i < g_TeamPanels.length; ++i) {
        UpdateTeamPanel(g_TeamPanels[i]);
    }

    $("#GameAndPlayersRoot").SetHasClass("unassigned_players", unassignedPlayers.length != 0);
    $("#GameAndPlayersRoot").SetHasClass("no_unassigned_players", unassignedPlayers.length == 0);
}

function OnPlayerSelectedTeam(nPlayerId, nTeamId, bSuccess) {
    const playerInfo = Game.GetLocalPlayerInfo();
    if (!playerInfo) {
        return;
    }

    if (playerInfo.player_id === nPlayerId) {
        if (bSuccess) {
            Game.EmitSound("ui_team_select_pick_team");
        } else {
            Game.EmitSound("ui_team_select_pick_team_failed");
        }
    }
}

function CheckForHostPrivileges() {
    const playerInfo = Game.GetLocalPlayerInfo();
    if (!playerInfo) {
        return;
    }

    $.GetContextPanel().SetHasClass("player_has_host_privileges", playerInfo.player_has_host_privileges);
}
var timer = CustomNetTables.GetTableValue("building_settings", "team_choice_time").value;
function UpdateTimer() {
    CheckMapVisible();
    const gameTime = Game.GetGameTime();
    const transitionTime = Game.GetStateTransitionTime();
    CheckForHostPrivileges();
    const mapInfo = Game.GetMapInfo();
    $("#MapInfo").SetDialogVariable("map_name", mapInfo.map_display_name);
    if (transitionTime >= 0) {
        $("#StartGameCountdownTimer").SetDialogVariableInt("countdown_timer_seconds", Math.max(0, Math.floor(transitionTime - gameTime)));
        $("#StartGameCountdownTimer").SetHasClass("countdown_active", true);
        $("#StartGameCountdownTimer").SetHasClass("countdown_inactive", false);
    } else {
        $("#StartGameCountdownTimer").SetHasClass("countdown_active", false);
        $("#StartGameCountdownTimer").SetHasClass("countdown_inactive", true);
    }
    if (timer <= 15) {
        $("#ShuffleTeamAssignmentButton").style.visibility = "collapse";
    }

    const autoLaunch = Game.GetAutoLaunchEnabled();
    $("#StartGameCountdownTimer").SetHasClass("auto_start", autoLaunch);
    $("#StartGameCountdownTimer").SetHasClass("forced_start", (autoLaunch == false));
    $.GetContextPanel().SetHasClass("teams_locked", Game.GetTeamSelectionLocked());
    $.GetContextPanel().SetHasClass("teams_unlocked", Game.GetTeamSelectionLocked() == false);
    timer = timer - 0.1;
    if (timer >= 0) {
        $.Schedule(0.1, UpdateTimer);
    }
}

function CheckMapVisible() {
    if (Game.GetMapInfo().map_display_name != MAP_NAME_ACTIVE) {
        $.GetContextPanel().style.visibility = "collapse";
        $("#TeamSelectContainer").style.visibility = "collapse";
    }
}

(function () {
    let bShowSpectatorTeam = false;
    let bAutoAssignTeams = true;
    if (GameUI.CustomUIConfig().team_select) {
        const cfg = GameUI.CustomUIConfig().team_select;
        if (cfg.bShowSpectatorTeam !== undefined) {
            bShowSpectatorTeam = cfg.bShowSpectatorTeam;
        }
        if (cfg.bAutoAssignTeams !== undefined) {
            bAutoAssignTeams = cfg.bAutoAssignTeams;
        }
    }
    $("#TeamSelectContainer").SetAcceptsFocus(true);
    const teamsListRootNode = $("#TeamsListRoot");
    const allTeamIDs = Game.GetAllTeamIDs();
    if (bShowSpectatorTeam) {
        allTeamIDs.unshift(g_TEAM_SPECATOR);
    }
    for (const teamId of allTeamIDs) {
        const teamNode = $.CreatePanel("Panel", teamsListRootNode, "");
        teamNode.AddClass("team_" + teamId); // team_1, etc.
        teamNode.SetAttributeInt("team_id", teamId);
        teamNode.BLoadLayout("file://{resources}/layout/custom_game/team_select/team_select_team.xml", false, false);
        g_TeamPanels.push(teamNode);
    }
    if (bAutoAssignTeams) {
        Game.AutoAssignPlayersToTeams();
    }
    OnTeamPlayerListChanged();
    UpdateTimer();
    CheckMapVisible();
    $.RegisterForUnhandledEvent("DOTAGame_TeamPlayerListChanged", OnTeamPlayerListChanged);
    $.RegisterForUnhandledEvent("DOTAGame_PlayerSelectedCustomTeam", OnPlayerSelectedTeam);
})();
