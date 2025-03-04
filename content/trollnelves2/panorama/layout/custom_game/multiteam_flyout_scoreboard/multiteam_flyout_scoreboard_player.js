const ui = GameUI.CustomUIConfig();
function ToggleMute() {
    const playerId = $.GetContextPanel().GetAttributeInt('player_id', -1);
    if (playerId !== -1) {
        const newIsMuted = !Game.IsPlayerMuted(playerId);
        Game.SetPlayerMuted(playerId, newIsMuted);
        $.GetContextPanel().SetHasClass('player_muted', newIsMuted);
    }
}

function OnGiveResourcesButton() {
    const playerPanel = $.GetContextPanel();
    const casterID = Players.GetLocalPlayer();
    const target = playerPanel.pID;
    const gold = Number(playerPanel.FindChildInLayoutFile('GoldEntry').text) || 0;
    const lumber =
        Number(playerPanel.FindChildInLayoutFile('LumberEntry').text) || 0;
    playerPanel.FindChildInLayoutFile('GoldEntry').text = '';
    playerPanel.FindChildInLayoutFile('LumberEntry').text = '';
    GameEvents.SendCustomGameEventToServer('give_resources', {
        gold,
        lumber,
        target,
        casterID,
    });
}

function OnVoteKickButton() {
    const playerPanel = $.GetContextPanel();
    const casterID = Players.GetLocalPlayer();
    const target = playerPanel.pID;
    GameEvents.SendCustomGameEventToServer('votekick_start', {
        target,
        casterID,
    });
}

function OnVoteFlagButton() {
    const playerPanel = $.GetContextPanel();
    const casterID = Players.GetLocalPlayer();
    const target = playerPanel.pID;
    GameEvents.SendCustomGameEventToServer('flag_start', {
        target,
        casterID,
    });
    //$.Msg('Flag: ');
}
function OnGiveAllResourcesButton() {
    const playerPanel = $.GetContextPanel();
    const casterID = Players.GetLocalPlayer();
    const target = playerPanel.pID;
    const gold = ui.playerGold[casterID];
    const lumber = ui.playerLumber[casterID];
    playerPanel.FindChildInLayoutFile('GoldEntry').text = '';
    playerPanel.FindChildInLayoutFile('LumberEntry').text = '';
    GameEvents.SendCustomGameEventToServer('give_resources', {
        gold,
        lumber,
        target,
        casterID,
    });
}

function OnGiveAllGoldButton() {
    const playerPanel = $.GetContextPanel();
    const casterID = Players.GetLocalPlayer();
    const target = playerPanel.pID;
    const gold = ui.playerGold[casterID];
    playerPanel.FindChildInLayoutFile('GoldEntry').text = '';
    playerPanel.FindChildInLayoutFile('LumberEntry').text = '';
    GameEvents.SendCustomGameEventToServer('give_resources', {
        gold,
        lumber: 0,
        target,
        casterID,
    });
}
function OnGiveAllLumberButton() {
    const playerPanel = $.GetContextPanel();
    const casterID = Players.GetLocalPlayer();
    const target = playerPanel.pID;
    const lumber = ui.playerLumber[casterID];
    playerPanel.FindChildInLayoutFile('GoldEntry').text = '';
    playerPanel.FindChildInLayoutFile('LumberEntry').text = '';
    GameEvents.SendCustomGameEventToServer('give_resources', {
        gold: 0,
        lumber,
        target,
        casterID,
    });
}
(function () {
const playerId = $.GetContextPanel().GetAttributeInt('player_id', -1);
$.GetContextPanel().SetHasClass('player_muted', Game.IsPlayerMuted(playerId));
})();

function showHero() {
    $.Msg("ddd")
    const localPlayer = Game.GetLocalPlayerInfo();
    const playerPanel = $.GetContextPanel();
    const target = playerPanel.pID;
    const localPlayerTeamId = localPlayer ? localPlayer.player_team_id : -1;
    if ( localPlayer.player_team_id === localPlayerTeamId ) {
        const targetHeroEntityId = Players.GetPlayerHeroEntityIndex(target);
        GameUI.MoveCameraToEntity(targetHeroEntityId);
    }
}