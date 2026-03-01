// @ts-nocheck
"use strict";

(function () {
    if (ScoreboardUpdater_InitializeScoreboard === null) {
        $.Msg("WARNING: This file requires shared_scoreboard_updater.js to be included.");
    }

    // $.Msg("Initializing multiteam_end_screen.js");
    const scoreboardConfig
    = {
        teamXmlName: "file://{resources}/layout/custom_game/multiteam_end_screen/multiteam_end_screen_team.xml",
        playerXmlName: "file://{resources}/layout/custom_game/multiteam_end_screen/multiteam_end_screen_player.xml",
    };

    const endScoreboardHandle = ScoreboardUpdater_InitializeScoreboard(scoreboardConfig, $("#TeamsContainer"));
    $.GetContextPanel().SetHasClass("endgame", 1);

    const teamInfoList = ScoreboardUpdater_GetSortedTeamInfoList(endScoreboardHandle);
    let delay = 0.2;
    const delay_per_panel = 1 / teamInfoList.length;
    for (const teamInfo of teamInfoList) {
        const teamId = teamInfo.team_id;
        const teamPanel = ScoreboardUpdater_GetTeamPanel(endScoreboardHandle, teamId);
        teamPanel.SetHasClass("team_endgame", false);
        const callback = (function (panel) {
            return function () {
                panel.SetHasClass("team_endgame", 1);
            };
        }(teamPanel));
        $.Schedule(delay, callback);
        delay += delay_per_panel;

        const teamPlayers = Game.GetPlayerIDsOnTeam(teamId);
        const playersContainer = teamPanel.FindChildInLayoutFile("PlayersContainer");
        if (playersContainer) {
            for (const playerId of teamPlayers) {
                const playerPanel = playersContainer.FindChild("_dynamic_player_" + playerId);
                if (playerPanel) {
                    const playerResourceStats = CustomNetTables.GetTableValue("resources", playerId + "_resource_stats");
                    const playerStatsScore = CustomNetTables.GetTableValue("scorestats", playerId.toString());
                    if (playerResourceStats != null) {
                        /// /$.Msg("Setting end game resources for playerId: ", playerId, "; playerResourceStats: ", playerResourceStats, "; ");
                        _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerGoldAmount", FormatNumberWithCommas(Math.round(playerResourceStats.gold / 1000)));
                        _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerLumberAmount", FormatNumberWithCommas(Math.round(playerResourceStats.lumber / 1000)));
                        _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerGPSAmount", FormatNumberWithCommas(Math.round(playerResourceStats.goldGained / playerResourceStats.timePassed)));
                        _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerLPSAmount", FormatNumberWithCommas(Math.round(playerResourceStats.lumberGained / playerResourceStats.timePassed)));
                        _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerGoldGivenAmount", FormatNumberWithCommas(Math.round(playerResourceStats.goldGiven / 1000)));
                        _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerLumberGivenAmount", FormatNumberWithCommas(Math.round(playerResourceStats.lumberGiven / 1000)));
                        _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerChangeScore", playerResourceStats.PlayerChangeScore);
                        _ScoreboardUpdater_SetTextSafe(playerPanel, "GetGem", playerResourceStats.GetGem);
                    }
                    if (playerStatsScore != null) {
                        _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerScore", (parseInt(playerStatsScore.playerScoreElf) + parseInt(playerStatsScore.playerScoreTroll)).toString());
                    }
                }
            }
        }
    }

    const winningTeamId = Game.GetGameWinner();
    const winningTeamDetails = Game.GetTeamDetails(winningTeamId);
    const endScreenVictory = $("#EndScreenVictory");
    if (endScreenVictory) {
        if (Game.GetMapInfo().map_display_name == "clanwars") {
            endScreenVictory.SetDialogVariable("winning_team_name", winningTeamId == DOTATeam_t.DOTA_TEAM_BADGUYS ? "DIRE TEAM " : "RADIANT TEAM ");
        } else {
            endScreenVictory.SetDialogVariable("winning_team_name", winningTeamId == DOTATeam_t.DOTA_TEAM_BADGUYS ? "The Mighty Troll has slain everyone!" : "Elves have defended successfully!");
        }

        if (GameUI.CustomUIConfig().team_colors) {
            let teamColor = GameUI.CustomUIConfig().team_colors[winningTeamId];
            teamColor = teamColor.replace(";", "");
            endScreenVictory.style.color = teamColor + ";";
        }
    }

    const winningTeamLogo = $("#WinningTeamLogo");
    if (winningTeamLogo) {
        const logo_xml = GameUI.CustomUIConfig().team_logo_large_xml;
        if (logo_xml) {
            winningTeamLogo.SetAttributeInt("team_id", winningTeamId);
            winningTeamLogo.BLoadLayout(logo_xml, false, false);
        }
    }
})();
