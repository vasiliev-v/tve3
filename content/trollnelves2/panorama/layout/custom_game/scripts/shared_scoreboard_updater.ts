// @ts-nocheck
var type_panel = 3; // 1 - mini, 2 - medium, 3 - full
ChangePanelType("Maximum");

// =============================================================================
// =============================================================================
function _ScoreboardUpdater_SetTextSafe(panel, childName, textValue) {
    if (panel === null) {
        return;
    }
    const childPanel = panel.FindChildInLayoutFile(childName);
    if (childPanel === null) {
        return;
    }

    childPanel.text = textValue;
}

var scoreboardUi = GameUI.CustomUIConfig();
var donatePanel = {};
// =============================================================================
// =============================================================================
function _ScoreboardUpdater_UpdatePlayerPanel(scoreboardConfig, playersContainer, playerId, localPlayerTeamId) {
    const playerPanelName = "_dynamic_player_" + playerId;
    let playerPanel = playersContainer.FindChild(playerPanelName);
    if (playerPanel === null) {
        playerPanel = $.CreatePanel("Panel", playersContainer, playerPanelName);
        playerPanel.SetAttributeInt("player_id", playerId);
        playerPanel.BLoadLayout(scoreboardConfig.playerXmlName, false, false);
    }

    playerPanel.SetHasClass("is_local_player", (playerId == Game.GetLocalPlayerID()));
    playerPanel.pID = playerId;

    let isTeammate = false;

    const playerInfo = Game.GetPlayerInfo(playerId);
    const playerStatsScore = CustomNetTables.GetTableValue("scorestats", playerId.toString());

    const score_check = playerPanel.FindChildInLayoutFile("PlayerScoreInformation");
    const full_res_check = playerPanel.FindChildInLayoutFile("GiveResourcesTable");
    const kick_flag_check = playerPanel.FindChildInLayoutFile("DopPanels");

    if (playerInfo) {
        isTeammate = (playerInfo.player_team_id == localPlayerTeamId);
        playerPanel.SetHasClass("player_dead", (playerInfo.player_respawn_seconds >= 0));
        playerPanel.SetHasClass("local_player_teammate", isTeammate && (playerId != Game.GetLocalPlayerID()));

        let visible_score = true;
        let visible_kick = true;
        let visible_resource = true;
        let opacity_panels = false;
        let is_mini_type = false;

        if (playerPanel.BHasClass("is_local_player") || !isTeammate) {
            opacity_panels = true;
        }
        if (!isTeammate) {
            visible_kick = true;
        }
        if (Game.GetMapInfo().map_display_name == "clanwars" || Game.GetMapInfo().map_display_name == "1x1") {
            visible_kick = false;
            visible_resource = false;
        }
        if (type_panel == 2) {
            visible_score = false;
            visible_kick = false;
            is_mini_type = true;
        }
        if (type_panel == 1) {
            visible_score = false;
            visible_kick = false;
            visible_resource = false;
            is_mini_type = true;
        }

        if (full_res_check) {
            if (opacity_panels && !is_mini_type) {
                full_res_check.style.opacity = "0";
                full_res_check.style.visibility = "visible";
            } else if (!visible_resource) {
                full_res_check.style.visibility = "collapse";
            } else {
                full_res_check.style.visibility = "visible";
            }
        }

        if (kick_flag_check) {
            if (opacity_panels && !is_mini_type) {
                kick_flag_check.style.opacity = "0";
                kick_flag_check.style.visibility = "visible";
            } else if (!visible_kick) {
                kick_flag_check.style.visibility = "collapse";
            } else {
                kick_flag_check.style.visibility = "visible";
            }
        }

        if ($("#Legend")) {
            if (visible_score) {
                $("#Legend").visible = true;
            } else {
                $("#Legend").visible = false;
            }
        }

        if (score_check) {
            if (visible_score) {
                score_check.visible = true;
            } else {
                score_check.visible = false;
            }
        }

        if (GameUI.CustomUIConfig().team_colors) {
            var teamColor = GameUI.CustomUIConfig().team_colors[playerInfo.player_team_id];
            const teamColorPanel = playerPanel.FindChildInLayoutFile("TeamColor");

            const teamColor_GradentFromTransparentLeft = playerPanel.FindChildInLayoutFile("TeamColor_GradentFromTransparentLeft");
            if (teamColor_GradentFromTransparentLeft) {
                teamColor_GradentFromTransparentLeft.style.borderRight = "2px solid " + teamColor;
            }
        }

        _ScoreboardUpdater_SetTextSafe(playerPanel, "RespawnTimer", (playerInfo.player_respawn_seconds + 1)); // value is rounded down so just add one for rounded-up
        _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerName", playerInfo.player_name);
        _ScoreboardUpdater_SetTextSafe(playerPanel, "Level", playerInfo.player_level);
        _ScoreboardUpdater_SetTextSafe(playerPanel, "Kills", playerInfo.player_kills);
        _ScoreboardUpdater_SetTextSafe(playerPanel, "Deaths", playerInfo.player_deaths);

        const goldValue = scoreboardUi?.playerGold?.[playerId];
        const lumberValue = scoreboardUi?.playerLumber?.[playerId];

        /// /$.Msg("Scoreboard update... playerId: ", playerId, "; goldValue: ", goldValue, "; lumberValue: ", lumberValue);

        if (isTeammate) {
            var lumber_icon = playerPanel.FindChildInLayoutFile("GoldPanel");
            var gold_icon = playerPanel.FindChildInLayoutFile("LumberPanel");
            if (lumber_icon) {
                lumber_icon.style.visibility = "visible";
            }
            if (gold_icon) {
                gold_icon.style.visibility = "visible";
            }
            _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerGoldAmount", goldValue);
            _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerLumberAmount", lumberValue);
        } else {
            var lumber_icon = playerPanel.FindChildInLayoutFile("GoldPanel");
            var gold_icon = playerPanel.FindChildInLayoutFile("LumberPanel");
            if (lumber_icon) {
                lumber_icon.style.visibility = "collapse";
            }
            if (gold_icon) {
                gold_icon.style.visibility = "collapse";
            }
        }

        /// /$.Msg("Setting Scoreboard resources for playerId: ", playerId, "; playerStatsScore: ", playerStatsScore, "; ");
        if (playerStatsScore) {
            _ScoreboardUpdater_SetTextSafe(playerPanel, "ElfScore", playerStatsScore.playerScoreElf.toString());
            _ScoreboardUpdater_SetTextSafe(playerPanel, "TrollScore", playerStatsScore.playerScoreTroll.toString());
        }
        if (scoreboardUi && scoreboardUi.scoreboardAchievements) {
            const achivementInfo = scoreboardUi.scoreboardAchievements[playerId];
            const achievementIconPanel = playerPanel.FindChildInLayoutFile("AchievementIcon");
            const achievementPanel = playerPanel.FindChildInLayoutFile("AchievementPanel");
            const achievementCounter = playerPanel.FindChildInLayoutFile("AchievementCounter");
            if (achievementIconPanel && achievementPanel) {
                if (achivementInfo && achivementInfo.icon) {
                    achievementIconPanel.style.backgroundImage = "url('" + achivementInfo.icon + "')";
                    achievementPanel.visible = true;

                    if (achievementCounter) {
                        achievementCounter.text = achivementInfo.counter ?? "";
                        achievementCounter.visible = achivementInfo.counter != null;
                    }
                } else {
                    achievementPanel.visible = false;
                    if (achievementCounter) {
                        achievementCounter.visible = false;
                    }
                }
            }
        }
        /// /..////////////
        const playerPortrait = playerPanel.FindChildInLayoutFile("HeroIcon");
        const PlayerName = playerPanel.FindChildInLayoutFile("PlayerName");
        const playerPortraitFlyout = playerPanel.FindChildInLayoutFile("Hero");
        if (playerPortrait) {
            const portrait_path = "file://{images}/heroes/";

            if (playerInfo.player_selected_hero !== "") {
                playerPortrait.SetImage(portrait_path + playerInfo.player_selected_hero + ".png");
                const player_table: any = CustomNetTables.GetTableValue("Shop", playerId);
                if (donatePanel[playerId] != localPlayerTeamId && player_table != null) {
                    donatePanel[playerId] = localPlayerTeamId;
                    if (player_table[2][0] == "75") {
                        $.CreatePanel("DOTAParticleScenePanel", playerPortrait, "RevengeTargetFrame", { style: "width:100%;height:100%;", particleName: "particles/donate/gold_icon_bp_3.vpcf", particleonly: "true", startActive: "true", cameraOrigin: "0 0 165", lookAt: "0 0 0", fov: "55", squarePixels: "true" });
                        PlayerName.SetHasClass("rainbow_nickname_animate", true);
                    } else if (player_table[2][0] == "50") {
                        var color = Players.GetPlayerColor(playerId).toString(16);
                        color = "#" + color.substring(6, 8) + color.substring(4, 6) + color.substring(2, 4) + color.substring(0, 2) + ";";
                        if (color) {
                            PlayerName.style.color = color;
                            $.CreatePanel("DOTAParticleScenePanel", playerPortrait, "RevengeTargetFrame", { style: "width:100%;height:100%;" + "wash-color:" + color, particleName: "particles/donate/gold_icon_white", particleonly: "true", startActive: "true", cameraOrigin: "0 0 165", lookAt: "0 0 0", fov: "55", squarePixels: "true" });
                        }
                        // PlayerName.SetHasClass("rainbow_nickname", true)
                        // PlayerName.style.color = "gradient( linear, 100% 0%, 0% 0%, from( rgb(0, 183, 255)), color-stop( 0.5, rgb(0, 255, 85)), to( rgb(255, 196, 0)))"
                        // $.CreatePanel("DOTAParticleScenePanel", playerPortrait, "RevengeTargetFrame", { style: "width:100%;height:100%;", particleName: "particles/donate/gold_icon_bp_rainbow.vpcf", particleonly:"true", startActive:"true", cameraOrigin:"0 0 165", lookAt:"0 0 0",  fov:"55", squarePixels:"true" });
                    } else if (player_table[2][0] == "25" || player_table[3][0] == "10") {
                        var color = Players.GetPlayerColor(playerId).toString(16);
                        color = "#" + color.substring(6, 8) + color.substring(4, 6) + color.substring(2, 4) + color.substring(0, 2) + ";";
                        if (color) {
                            PlayerName.style.color = color;
                        }
                    }
                }
            } else {
                playerPortrait.SetImage("file://{images}/custom_game/unassigned.png");
            }
        }

        const playerPortrait_end = playerPanel.FindChildInLayoutFile("HeroIconEnd");

        if (playerPortrait_end) {
            if (playerInfo.player_selected_hero !== "") {
                playerPortrait_end.SetImage("file://{images}/heroes/icons/" + playerInfo.player_selected_hero + ".png");
            }
        }

        if (playerInfo.player_selected_hero_id == -1) {
            _ScoreboardUpdater_SetTextSafe(playerPanel, "HeroName", $.Localize("#DOTA_Scoreboard_Picking_Hero"));
        } else {
            _ScoreboardUpdater_SetTextSafe(playerPanel, "HeroName", $.Localize("#" + playerInfo.player_selected_hero));
        }

        const heroNameAndDescription = playerPanel.FindChildInLayoutFile("HeroNameAndDescription");
        if (heroNameAndDescription) {
            if (playerInfo.player_selected_hero_id == -1) {
                heroNameAndDescription.SetDialogVariable("hero_name", $.Localize("#DOTA_Scoreboard_Picking_Hero"));
            } else {
                heroNameAndDescription.SetDialogVariable("hero_name", $.Localize("#" + playerInfo.player_selected_hero));
            }
            heroNameAndDescription.SetDialogVariableInt("hero_level", playerInfo.player_level);
        }
        playerPanel.SetHasClass("player_connection_abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED);
        playerPanel.SetHasClass("player_connection_failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED);
        playerPanel.SetHasClass("player_connection_disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED);

        const playerAvatar = playerPanel.FindChildInLayoutFile("AvatarImage");
        if (playerAvatar) {
            playerAvatar.steamid = playerInfo.player_steamid;
        }

        const playerColorBar = playerPanel.FindChildInLayoutFile("PlayerColorBar");
        if (playerColorBar !== null) {
            if (GameUI.CustomUIConfig().team_colors) {
                var teamColor = GameUI.CustomUIConfig().team_colors[playerInfo.player_team_id];
                if (teamColor) {
                    playerColorBar.style.backgroundColor = teamColor;
                }
            } else {
                const playerColor = "#000000";
                playerColorBar.style.backgroundColor = playerColor;
            }
        }
    }

    const playerItemsContainer = playerPanel.FindChildInLayoutFile("PlayerItemsContainer");
    if (playerItemsContainer) {
        const playerItems = Game.GetPlayerItems(playerId);
        if (playerItems) {
            //        //$.Msg( "playerItems = ", playerItems );
            for (let i = playerItems.inventory_slot_min; i < playerItems.inventory_slot_max; ++i) {
                const itemPanelName = "_dynamic_item_" + i;
                let itemPanel = playerItemsContainer.FindChild(itemPanelName);
                if (itemPanel === null) {
                    itemPanel = $.CreatePanel("Image", playerItemsContainer, itemPanelName);
                    itemPanel.AddClass("PlayerItem");
                }

                const itemInfo = playerItems.inventory[i];
                if (itemInfo) {
                    let item_image_name = "file://{images}/items/" + itemInfo.item_name.replace("item_", "") + ".png";
                    if (itemInfo.item_name.indexOf("recipe") >= 0) {
                        item_image_name = "file://{images}/items/recipe.png";
                    }
                    itemPanel.SetImage(item_image_name);
                } else {
                    itemPanel.SetImage("");
                }
            }
        }
    }
}

// =============================================================================
// =============================================================================
function _ScoreboardUpdater_UpdateTeamPanel(scoreboardConfig, containerPanel, teamDetails, teamsInfo) {
    if (!containerPanel) {
        return;
    }

    const teamId = teamDetails.team_id;
    //    //$.Msg( "_ScoreboardUpdater_UpdateTeamPanel: ", teamId );

    /// /$.Msg("ID - " + teamId);
    const teamPanelName = "_dynamic_team_" + teamId;
    let teamPanel = containerPanel.FindChild(teamPanelName);
    if (teamPanel === null) {
        //        //$.Msg( "UpdateTeamPanel.Create: ", teamPanelName, " = ", scoreboardConfig.teamXmlName );
        teamPanel = $.CreatePanel("Panel", containerPanel, teamPanelName);
        teamPanel.SetAttributeInt("team_id", teamId);
        teamPanel.BLoadLayout(scoreboardConfig.teamXmlName, false, false);

        const logo_xml = GameUI.CustomUIConfig().team_logo_xml;
        if (logo_xml) {
            const teamLogoPanel = teamPanel.FindChildInLayoutFile("TeamLogo");
            if (teamLogoPanel) {
                teamLogoPanel.SetAttributeInt("team_id", teamId);
                teamLogoPanel.BLoadLayout(logo_xml, false, false);
            }
        }
    }

    let localPlayerTeamId = -1;
    const localPlayer = Game.GetLocalPlayerInfo();
    if (localPlayer) {
        localPlayerTeamId = localPlayer.player_team_id;
    }
    teamPanel.SetHasClass("local_player_team", localPlayerTeamId == teamId);
    teamPanel.SetHasClass("not_local_player_team", localPlayerTeamId != teamId);

    const teamPlayers = Game.GetPlayerIDsOnTeam(teamId);
    const playersContainer = teamPanel.FindChildInLayoutFile("PlayersContainer");
    if (playersContainer) {
        for (let i = 0; i < 16; i++) {
            const playerPanel = playersContainer.FindChild("_dynamic_player_" + i);
            if (playerPanel) {
                /// /$.Msg("Found " + playerPanel.id + " in team " + teamId);
                if (teamPlayers.indexOf(i) == -1) {
                    playerPanel.style.visibility = "collapse";
                    playerPanel.RemoveAndDeleteChildren();
                }
            }
        }
        for (const playerId of teamPlayers) {
            if (Players.GetPlayerSelectedHero(playerId) != "npc_dota_hero_wisp") {
                // $.Msg("Found " + playerId + " in team " + localPlayerTeamId);
                _ScoreboardUpdater_UpdatePlayerPanel(scoreboardConfig, playersContainer, playerId, localPlayerTeamId);
            }
        }
    }

    teamPanel.SetHasClass("no_players", (teamPlayers.length == 0));
    teamPanel.SetHasClass("one_player", (teamPlayers.length == 1));

    if (teamsInfo.max_team_players < teamPlayers.length) {
        teamsInfo.max_team_players = teamPlayers.length;
    }

    _ScoreboardUpdater_SetTextSafe(teamPanel, "TeamName", $.Localize("#" + teamDetails.team_name));

    return teamPanel;
}

// =============================================================================
// =============================================================================
function _ScoreboardUpdater_ReorderTeam(scoreboardConfig, teamsParent, teamPanel, teamId, newPlace, prevPanel) {
//    //$.Msg( "UPDATE: ", GameUI.CustomUIConfig().teamsPrevPlace );
    let oldPlace = null;
    if (GameUI.CustomUIConfig().teamsPrevPlace.length > teamId) {
        oldPlace = GameUI.CustomUIConfig().teamsPrevPlace[teamId];
    }
    GameUI.CustomUIConfig().teamsPrevPlace[teamId] = newPlace;

    if (newPlace != oldPlace) {
        //        //$.Msg( "Team ", teamId, " : ", oldPlace, " --> ", newPlace );
        teamPanel.RemoveClass("team_getting_worse");
        teamPanel.RemoveClass("team_getting_better");
        if (newPlace > oldPlace) {
            teamPanel.AddClass("team_getting_worse");
        } else if (newPlace < oldPlace) {
            teamPanel.AddClass("team_getting_better");
        }
    }

    teamsParent.MoveChildAfter(teamPanel, prevPanel);
}

// sort / reorder as necessary
function compareFunc(a, b) { // GameUI.CustomUIConfig().sort_teams_compare_func;
    if (a.team_score < b.team_score) {
        return 1; // [ B, A ]
    }
    if (a.team_score > b.team_score) {
        return -1; // [ A, B ]
    }
    return 0;
};

function stableCompareFunc(a, b) {
    const unstableCompare = compareFunc(a, b);
    if (unstableCompare !== 0) {
        return unstableCompare;
    }

    if (GameUI.CustomUIConfig().teamsPrevPlace.length <= a.team_id) {
        return 0;
    }

    if (GameUI.CustomUIConfig().teamsPrevPlace.length <= b.team_id) {
        return 0;
    }

    //            //$.Msg( GameUI.CustomUIConfig().teamsPrevPlace );

    const a_prev = GameUI.CustomUIConfig().teamsPrevPlace[a.team_id];
    const b_prev = GameUI.CustomUIConfig().teamsPrevPlace[b.team_id];
    if (a_prev < b_prev) { // [ A, B ]
        return -1; // [ A, B ]
    } else if (a_prev > b_prev) { // [ B, A ]
        return 1; // [ B, A ]
    } else {
        return 0;
    }
}

// =============================================================================
// =============================================================================
function _ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardConfig, teamsContainer) {
    const teamsList = [];
    for (var teamId of Game.GetAllTeamIDs()) {
        teamsList.push(Game.GetTeamDetails(teamId));
    }

    // update/create team panels
    const teamsInfo = { max_team_players: 0 };
    const panelsByTeam = [];
    for (var i = 0; i < teamsList.length; ++i) {
        var teamPanel = _ScoreboardUpdater_UpdateTeamPanel(scoreboardConfig, teamsContainer, teamsList[i], teamsInfo);
        if (teamPanel) {
            panelsByTeam[teamsList[i].team_id] = teamPanel;
        }
    }

    if (teamsList.length > 1) {
        // sort
        if (scoreboardConfig.shouldSort) {
            teamsList.sort(stableCompareFunc);
        }

        // reorder the panels based on the sort
        let prevPanel = panelsByTeam[teamsList[0].team_id];
        for (var i = 0; i < teamsList.length; ++i) {
            var teamId = teamsList[i].team_id;
            var teamPanel = panelsByTeam[teamId];
            _ScoreboardUpdater_ReorderTeam(scoreboardConfig, teamsContainer, teamPanel, teamId, i, prevPanel);
            prevPanel = teamPanel;
        }
    }
}

// =============================================================================
// =============================================================================
function ScoreboardUpdater_InitializeScoreboard(scoreboardConfig, scoreboardPanel) {
    GameUI.CustomUIConfig().teamsPrevPlace = [];
    if (typeof (scoreboardConfig.shouldSort) === "undefined") {
        // default to true
        scoreboardConfig.shouldSort = true;
    }
    _ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardConfig, scoreboardPanel);
    return { scoreboardConfig, scoreboardPanel };
}

// =============================================================================
// =============================================================================
function ScoreboardUpdater_SetScoreboardActive(scoreboardHandle, isActive) {
    if (scoreboardHandle.scoreboardConfig === null || scoreboardHandle.scoreboardPanel === null) {
        return;
    }

    if (isActive) {
        _ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardHandle.scoreboardConfig, scoreboardHandle.scoreboardPanel);
    }
}

// =============================================================================
// =============================================================================
function ScoreboardUpdater_GetTeamPanel(scoreboardHandle, teamId) {
    if (scoreboardHandle.scoreboardPanel === null) {
        return;
    }

    const teamPanelName = "_dynamic_team_" + teamId;
    return scoreboardHandle.scoreboardPanel.FindChild(teamPanelName);
}

// =============================================================================
// =============================================================================
function ScoreboardUpdater_GetSortedTeamInfoList(scoreboardHandle) {
    const teamsList = [];
    for (const teamId of Game.GetAllTeamIDs()) {
        teamsList.push(Game.GetTeamDetails(teamId));
    }

    if (teamsList.length > 1) {
        teamsList.sort(stableCompareFunc);
    }

    return teamsList;
}

function ChangePanelType(PanelType) {
    if ($("#ChangePanelType")) {
        for (panel_in of $("#ChangePanelType").Children()) {
            panel_in.SetHasClass("Active", false);
        }
    }
    if (PanelType == "Mini") {
        if ($("#MinType")) {
            $("#MinType").SetHasClass("Active", true);
        }
        type_panel = 1;
    } else if (PanelType == "Medium") {
        if ($("#MedType")) {
            $("#MedType").SetHasClass("Active", true);
        }
        type_panel = 2;
    } else if (PanelType == "Maximum") {
        if ($("#MaxType")) {
            $("#MaxType").SetHasClass("Active", true);
        }
        type_panel = 3;
    }
}
