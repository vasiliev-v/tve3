// @ts-nocheck
function MutePlayer() {
    const playerId = $.GetContextPanel().PlayerID;
    const newIsMuted = !Game.IsPlayerMuted(playerId);
    Game.SetPlayerMuted(playerId, newIsMuted);
    $.GetContextPanel().SetHasClass("player_muted", newIsMuted);
}

function TopScoreboard_SendResource() {
    const playerId = $.GetContextPanel().PlayerID;
    if (GameUI.CustomUIConfig().OpenSendResourcePanelGlobal) {
        GameUI.CustomUIConfig().OpenSendResourcePanelGlobal(playerId);
    }
}

function TopScoreboard_ShowHero() {
    const localPlayer = Game.GetLocalPlayerInfo();
    const playerPanel = $.GetContextPanel();
    const target = playerPanel.PlayerID;
    const localPlayerTeamId = localPlayer ? localPlayer.player_team_id : -1;
    if (localPlayer.player_team_id === localPlayerTeamId) {
        const targetHeroEntityId = Players.GetPlayerHeroEntityIndex(target);
        GameUI.MoveCameraToEntity(targetHeroEntityId);
    }
}
