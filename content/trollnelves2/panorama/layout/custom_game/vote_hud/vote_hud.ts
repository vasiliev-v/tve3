// @ts-nocheck
$.GetContextPanel().GetParent().style.marginLeft = "0px;";

var ACTIVATED_STAGE_SCREEN = false;
var ACTIVATED_STAGE_MAP = false;
var ACTIVATED_STAGE_ROLE = false;
var ACTIVATED_STAGE_PERKS = false;
var OLD_SCREEN_STAGE = null;
var SPELLS_TEXTURE = {};
var UPDATED_CHANCE_TROLL = {};
var player_table: any = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
var players_activated_spells = CustomNetTables.GetTableValue("game_spells_lib", "spell_active");
var game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list");
var votedYesMod = false;
var modVoteLabelOverride = null;
var currentModState = null;

// ===== FIX 1x1 MAP STAGE (retry after 5 sec if team not ready) =====
var LAST_MAP_STAGE_DATA = null;
var MAP_STAGE_RETRY_SCHEDULED = false;

function ClearMapStageUI() {
    if ($("#MapsList")) {
        $("#MapsList").RemoveAndDeleteChildren();
    }

    if ($("#WindowStageMapPlayersCounter")) {
        $("#WindowStageMapPlayersCounter").RemoveAndDeleteChildren();
    }
}
// ================================================================

function InitSetup() {
    if (Game.GetMapInfo().map_display_name == "1x1") {
        $("#StageLinePanel_3").visible = false;
        $("#WindowMapStage").style.opacity = "0";
        $("#StagesLines").MoveChildBefore($("#StageLinePanel_2"), $("#StageLinePanel_1"));

        const StageLinePanel = $("#StageLinePanel_2");
        const StageLineFront = StageLinePanel.FindChildTraverse("StageLineFront_2");
        StageLineFront.style.width = "0%";
    }
}

function UpdateChat() {
    const FindLoadingChat = GameUI.CustomUIConfig().FindLoadingChat;
    if (FindLoadingChat) {
        FindLoadingChat();
    }
    const LoadingScreenChat = GameUI.CustomUIConfig().LoadingChat;
    if (LoadingScreenChat == null) {
        $.Schedule(3, UpdateChat);
        return;
    }
    LoadingScreenChat.SetParent($.GetContextPanel());
    LoadingScreenChat.style.opacity = "1";
    LoadingScreenChat.style["ui-scale"] = "80%";
}

CustomNetTables.SubscribeNetTableListener("game_spells_lib", VoteHud_UpdateSpellsLibTable);

function VoteHud_UpdateSpellsLibTable(t, k, d) {
    if (k == "spell_active") {
        players_activated_spells = d;
        VoteHud_UpdateCurrentSpells();
        UpdateListSelected();
    }
}

GameEvents.SubscribeProtected("troll_elves_init_stage_screen", InitStageScreen);

function InitStageScreen() {
    if (ACTIVATED_STAGE_SCREEN) {
        return;
    }
    ACTIVATED_STAGE_SCREEN = true;
    $("#GameSetupStages").style.opacity = "1";
}

function CloseOtherScreenStage() {
    if (OLD_SCREEN_STAGE) {
        OLD_SCREEN_STAGE.style.opacity = "0";
    }
}

GameEvents.SubscribeProtected("troll_elves_init_stage_select_map", InitStageSelectedMap);

// ===== UPDATED: InitStageSelectedMap with 5 sec retry in 1x1 =====
function InitStageSelectedMap(data) {
    // Запоминаем последние данные стадии, чтобы можно было перерисовать позже
    if (data) {
        LAST_MAP_STAGE_DATA = data;
    }

    const is1x1 = Game.GetMapInfo().map_display_name == "1x1";
    const isTroll = Players.GetTeam(Players.GetLocalPlayer()) == 3;

    // Если уже активировали, но мы в 1x1 и раньше показали экран как "не тролль",
    // а теперь команда обновилась и мы тролль — разрешаем повторную прогрузку
    if (ACTIVATED_STAGE_MAP) {
        if (is1x1 && $("#MapSelectInfo") && $("#MapSelectInfo").visible && isTroll) {
            ACTIVATED_STAGE_MAP = false;
        } else {
            return;
        }
    }

    ACTIVATED_STAGE_MAP = true;
    CloseOtherScreenStage();
    OLD_SCREEN_STAGE = $("#WindowMapStage");
    $("#WindowMapStage").style.opacity = "1";

    $("#MapSelectInfo").visible = false;

    // Важно: чистим UI перед построением (иначе при повторе будут дубли)
    ClearMapStageUI();

    if (is1x1 && !isTroll) {
        $("#WindowStageMapPlayersCounter").visible = false;
        $("#MapsList").visible = false;
        $("#MapSelectInfo").visible = true;

        // Повторная проверка через 5 секунд (1 раз)
        if (!MAP_STAGE_RETRY_SCHEDULED) {
            MAP_STAGE_RETRY_SCHEDULED = true;
            $.Schedule(5.0, function () {
                MAP_STAGE_RETRY_SCHEDULED = false;

                // если за это время команда обновилась и мы стали троллем — перерисуем окно
                if (Game.GetMapInfo().map_display_name == "1x1" && Players.GetTeam(Players.GetLocalPlayer()) == 3) {
                    ACTIVATED_STAGE_MAP = false;
                    InitStageSelectedMap(LAST_MAP_STAGE_DATA);
                }
            });
        }

        InitModVote();
        return;
    }

    // обычная логика (тролль или не 1x1)
    $("#WindowStageMapPlayersCounter").visible = true;
    $("#MapsList").visible = true;

    if (data && data.maps) {
        for (let i = 1; i <= Object.keys(data.maps).length; i++) {
            CreatePanelMap(data.maps, i);
        }
    }

    CreatePlayersVotesMap();
    InitModVote();
}
// ===== END UPDATED =====

function CreatePlayersVotesMap() {
    for (let i = 0; i <= 24; i++) {
        if (Players.IsValidPlayerID(i)) {
            CreatePlayerVotePanel(i);
        }
    }
}

function CreatePlayerVotePanel(i) {
    const PlayersCounter = $("#WindowStageMapPlayersCounter");

    const vote_player_panel = $.CreatePanel("Panel", PlayersCounter, "player_vote_" + i);
    vote_player_panel.AddClass("vote_player_panel");

    const vote_player_panel_enabled = $.CreatePanel("Panel", vote_player_panel, "");
    vote_player_panel_enabled.AddClass("vote_player_panel_enabled");
}

function CreatePanelMap(info, i) {
    const ChooseMapButton = $.CreatePanel("Panel", $("#MapsList"), "Map_id_" + i);
    ChooseMapButton.AddClass("ChooseMapButton");

    const ChooseMapButtonBG = $.CreatePanel("Panel", ChooseMapButton, "");
    ChooseMapButtonBG.AddClass("ChooseMapButtonBG");
    ChooseMapButtonBG.style.backgroundImage = "url('" + info[i][3] + "')";
    ChooseMapButtonBG.style.backgroundSize = "100%";

    const ChooseMapButtonInfo = $.CreatePanel("Panel", ChooseMapButton, "");
    ChooseMapButtonInfo.AddClass("ChooseMapButtonInfo");

    const ChooseMapButtonName = $.CreatePanel("Label", ChooseMapButtonInfo, "");
    ChooseMapButtonName.AddClass("ChooseMapButtonName");
    ChooseMapButtonName.text = info[i][1];

    const ChooseMapButtonVotesCounter = $.CreatePanel("Label", ChooseMapButtonInfo, "ChooseMapButtonVotesCounter");
    ChooseMapButtonVotesCounter.AddClass("ChooseMapButtonVotesCounter");
    ChooseMapButtonVotesCounter.text = "";

    ChooseMapButton.SetPanelEvent("onactivate", function () {
        GameEvents.SendCustomGameEventToServer("troll_elves_map_votes", { panel_id: i });
        Game.EmitSound("General.ButtonClick");
        LocalChoose(ChooseMapButton);
    });
}

function LocalChoose(panel) {
    for (const child of $("#MapsList").Children()) {
        child.ClearPanelEvent("onactivate");
        child.AddClass("DisabledChoose");
    }
    panel.SetHasClass("SelectedMapLocal", true);
}

GameEvents.SubscribeProtected("troll_elves_map_votes_change_visual", UpdateMapSelectorPlayers);

function UpdateMapSelectorPlayers(data) {
    let all_votes = 0;
    for (const table_id in data) {
        const map_info = data[table_id];
        const votes = map_info.votes;
        const map_panel = $("#MapsList").FindChildTraverse("Map_id_" + map_info.map_id);
        if (map_panel) {
            const ChooseMapButtonVotesCounter = map_panel.FindChildTraverse("ChooseMapButtonVotesCounter");
            if (ChooseMapButtonVotesCounter) {
                if (votes > 0) {
                    all_votes = all_votes + votes;
                    ChooseMapButtonVotesCounter.text = $.Localize("#votes") + " " + votes;
                }
            }
        }
    }
    for (let i = 1; i <= 24; i++) {
        if (all_votes >= i) {
            const PlayersCounter = $("#WindowStageMapPlayersCounter");
            const player_vote = PlayersCounter.FindChildTraverse("player_vote_" + (i - 1));
            if (player_vote) {
                player_vote.AddClass("PlayerIsVote");
            }
        }
    }
}

GameEvents.SubscribeProtected("troll_elves_phase_time", troll_elves_phase_time);

function troll_elves_phase_time(data) {
    const time = data.time;
    const max_time = data.max_time;
    const stage = data.stage;
    const map = data.map;
    const role = data.role;

    if (data.mod !== undefined) {
        currentModState = data.mod;
    }

    for (let i = 1; i <= 3; i++) {
        const StageLinePanel = $("#StageLinePanel_" + i);
        const StageLineFront = StageLinePanel.FindChildTraverse("StageLineFront_" + i);
        if (i == stage) {
            StageLinePanel.SetHasClass("ActiveStage", true);
            if (StageLineFront) {
                if (max_time > 0 && time !== undefined) {
                    StageLineFront.style.width = (max_time - time) / max_time * 100 + "%";
                } else {
                    StageLineFront.style.width = "0%";
                }
            }
        } else {
            StageLinePanel.SetHasClass("ActiveStage", false);
        }
        if (stage > i && Game.GetMapInfo().map_display_name != "1x1") {
            if (StageLineFront) {
                StageLineFront.style.width = "100%";
            }
        }
    }
    $("#StageTimer").text = time;

    if ($("#ModVotePanel")) {
        $("#ModVotePanel").visible = stage != 3;
    }

    if (role) {
        let hero_localize = "you_play_elf_role";
        if (Players.GetTeam(Players.GetLocalPlayer()) == 3) {
            hero_localize = "you_play_troll_role";
        }
        $("#GameInfo").style.opacity = "1";
        $("#SettingsHero").text = $.Localize("#" + hero_localize);
        $("#SettingsHero").visible = true;
    }
    if (map) {
        $("#GameInfo").style.opacity = "1";
        $("#SettingsMap").text = $.Localize("#is_current_map") + " " + map.toUpperCase();
        $("#SettingsMap").visible = true;
    }
    if (stage >= 3) {
        modVoteLabelOverride = null;

        if (currentModState !== null) {
            $("#GameInfo").style.opacity = "1";
            const text = currentModState ? $.Localize("#wolves_mod_disabled_desc") : $.Localize("#wolves_mod_enabled_desc");
            $("#SettingsMod").text = text;
            $("#SettingsMod").visible = true;
        }
    } else if (data.mod !== undefined && !modVoteLabelOverride) {
        $("#GameInfo").style.opacity = "1";
        const text = data.mod ? $.Localize("#wolves_mod_disabled_desc") : $.Localize("#wolves_mod_enabled_desc");
        $("#SettingsMod").text = text;
        $("#SettingsMod").visible = true;
    } else if (modVoteLabelOverride) {
        $("#SettingsMod").text = modVoteLabelOverride;
        $("#SettingsMod").visible = true;
    }
}

GameEvents.SubscribeProtected("troll_elves_init_stage_select_role", InitStageSelectedRole);

function InitStageSelectedRole() {
    if (ACTIVATED_STAGE_ROLE) {
        return;
    }
    ACTIVATED_STAGE_ROLE = true;
    CloseOtherScreenStage();
    $("#WindowRoleStage").style.opacity = "1";
    OLD_SCREEN_STAGE = $("#WindowRoleStage");
    const player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());
    if (player_table && Object.keys(player_table[2][0]).length > 0) {
        $("#YourChanceTroll").text = $.Localize("#shop_trollchance") + player_table[2][0] + "%";
    }
}

function ChooseTeam(team) {
    $("#ElfPanel").SetHasClass("SelectedRole", false);
    $("#TrollPanel").SetHasClass("SelectedRole", false);
    const PlayerID = Players.GetLocalPlayer();
    GameEvents.SendCustomGameEventToServer("player_team_choose", { id: PlayerID, team: team });
    if (team == "elf") {
        $("#ElfPanel").SetHasClass("SelectedRole", true);
    } else if (team == "troll") {
        $("#TrollPanel").SetHasClass("SelectedRole", true);
    }
}

GameEvents.SubscribeProtected("troll_elves_init_stage_select_perks", InitStageSelectedPerks);

function InitStageSelectedPerks() {
    if (ACTIVATED_STAGE_PERKS) {
        return;
    }
    ACTIVATED_STAGE_PERKS = true;
    CloseOtherScreenStage();
    $("#WindowPerksStage").style.opacity = "1";
    OLD_SCREEN_STAGE = $("#WindowPerksStage");
    VoteHud_InitSpellList();
    VoteHud_UpdateCurrentSpells();
    UpdateListSelected();
}

function VoteHud_InitSpellList() {
    let active_shop = 0;
    if (Players.GetTeam(Players.GetLocalPlayer()) == 3) {
        active_shop = 1;
    }
    for (let i = 0; i <= Object.keys(game_spells_lib).length; i++) {
        if (game_spells_lib[i] && game_spells_lib[i][6] == active_shop && game_spells_lib[i][7] == "1") {
            VoteHud_CreateSpell(game_spells_lib[i], $("#AllPerksList"), true);
        }
    }
}

function VoteHud_CreateSpell(info, parent, active) {
    let panel_id = "";
    if (active && info && info[1]) {
        panel_id = info[1];
    }

    const PerkPanel = $.CreatePanel("Panel", parent, panel_id);
    PerkPanel.AddClass("PerkPanel");

    if (!info || !info[1]) {
        return;
    }

    const player_id = Players.GetLocalPlayer();

    const PerkImage = $.CreatePanel("Panel", PerkPanel, "");
    PerkImage.AddClass("PerkImage");
    PerkImage.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + VoteHud_GetSpellTexture(info[1], VoteHud_GetPlayerSpellLevel(info[1], true)) + '.png")';
    PerkImage.style.backgroundSize = "100%";

    if (active) {
        PerkPanel.SetPanelEvent("onactivate", function () {
            GameEvents.SendCustomGameEventToServer("event_set_activate_spell", { spell_name: info[1], modifier_name: info[3] });
        });
        const PerkPanelNumber = $.CreatePanel("Label", PerkPanel, "PerkPanelNumber");
        PerkPanelNumber.AddClass("PerkPanelNumber");
        PerkPanelNumber.text = "2";

        VoteHud_SetShowText(PerkPanel, info[3] + "_description_level_" + VoteHud_GetSelectedPlayerSpellLevel(info[1], player_id), info[1], VoteHud_GetSelectedPlayerSpellLevel(info[1], player_id));
    }
}

function VoteHud_UpdateCurrentSpells() {
    const container = $("#PlayerSelectedPerks");
    container.RemoveAndDeleteChildren();

    const playerId = Players.GetLocalPlayer();
    const activeTable = players_activated_spells[playerId] || {};
    const maxAllowed = GetMaxAllowedPerksForLocalPlayer();
    let rendered = 0;

    for (let slot = 1; slot <= 3; slot++) {
        const spellName = activeTable[slot];
        if (spellName && spellName !== "") {
            if (rendered >= maxAllowed) {
                break;
            }
            const info = GetSpellInformation(spellName);
            if (info) {
                VoteHud_CreateSpell(info, container, true);
                rendered++;
            }
        }
    }

    RenderEmptyCells(container, maxAllowed - rendered);
}

function UpdateListSelected() {
    const player_id = Players.GetLocalPlayer();
    const active_table = players_activated_spells?.[player_id] || {};
    const max_allowed = GetMaxAllowedPerksForLocalPlayer();

    const valid_spells = [];

    for (let i = 1; i <= 3; i++) {
        if (active_table[i] && active_table[i] !== "") {
            valid_spells.push(active_table[i]);
            if (valid_spells.length >= max_allowed) {
                break;
            }
        }
    }

    for (const panel of $("#AllPerksList").Children()) {
        const spell_name = panel.id;
        const is_active = Object.values(active_table).includes(spell_name);
        const is_valid = valid_spells.includes(spell_name);

        const label = panel.FindChildTraverse("PerkPanelNumber");
        if (label) {
            const index = Object.entries(active_table).find(([_, name]) => name === spell_name)?.[0];
            label.text = index || "";
        }

        panel.SetHasClass("ActivePerk", !!(is_active && is_valid));
        panel.ClearPanelEvent("onactivate");

        if (is_active && is_valid) {
            panel.RemoveClass("DisabledChoose");
            panel.SetPanelEvent("onactivate", () => {
                GameEvents.SendCustomGameEventToServer("event_set_activate_spell", {
                    spell_name: spell_name,
                    modifier_name: panel.GetAttributeString("modifier", ""),
                });
            });
        } else if (is_active && !is_valid) {
            panel.AddClass("DisabledChoose");
            panel.SetPanelEvent("onactivate", () => {});
        } else if (!is_active && valid_spells.length >= max_allowed) {
            panel.AddClass("DisabledChoose");
            panel.SetPanelEvent("onactivate", () => {});
        } else {
            panel.RemoveClass("DisabledChoose");
            panel.SetPanelEvent("onactivate", () => {
                GameEvents.SendCustomGameEventToServer("event_set_activate_spell", {
                    spell_name: spell_name,
                    modifier_name: panel.GetAttributeString("modifier", ""),
                });
            });
        }
    }
}

function GetSpellInformation(spell_name) {
    for (let i = 0; i <= Object.keys(game_spells_lib).length; i++) {
        if (game_spells_lib[i] && game_spells_lib[i][1] == spell_name) {
            return game_spells_lib[i];
        }
    }
    return null;
}

function VoteHud_PlayerHasSpell(spell) {
    if (player_table) {
        for (const entry_id in player_table) {
            if (player_table[entry_id]) {
                if (player_table[entry_id][1] == spell) {
                    return true;
                }
            }
        }
    }
    return false;
}

function VoteHud_GetSpellTexture(spell_name, any_level) {
    if (any_level == null) {
        any_level = 1;
    }
    if (SPELLS_TEXTURE[spell_name + "_" + any_level]) {
        return SPELLS_TEXTURE[spell_name + "_" + any_level];
    }
    for (let i = 0; i <= Object.keys(game_spells_lib).length; i++) {
        if (game_spells_lib[i] && game_spells_lib[i][1] == spell_name) {
            return game_spells_lib[i][2];
        }
    }
}

function VoteHud_GetPlayerSpellLevel(spell_name, texture?) {
    player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
    if (player_table) {
        for (const entry_id in player_table) {
            if (player_table[entry_id]) {
                if (player_table[entry_id][1] == spell_name) {
                    return player_table[entry_id][2];
                }
            }
        }
    }
    if (texture) {
        return 1;
    }
    return 0;
}

function VoteHud_SetShowText(panel, text, spell, level) {
    panel.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowTextTooltip", panel, "<b>" + $.Localize("#" + spell) + " " + level + "</b><br>" + $.Localize("#" + text));
    });

    panel.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideTextTooltip", panel);
    });
}

function VoteHud_GetSelectedPlayerSpellLevel(spell_name, id) {
    if (player_table) {
        for (const entry_id in player_table) {
            if (player_table[entry_id]) {
                if (player_table[entry_id][1] == spell_name) {
                    return player_table[entry_id][2];
                }
            }
        }
    }
    return 0;
}

GameEvents.SubscribeProtected("troll_elves_update_chance", UpdateChanceForTroll);

function UpdateChanceForTroll() {
    if (UPDATED_CHANCE_TROLL[Players.GetLocalPlayer()] != null) {
        return;
    }
    UPDATED_CHANCE_TROLL[Players.GetLocalPlayer()] = true;
    const player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());
    if (player_table && Object.keys(player_table[2][0]).length > 0) {
        $("#YourChanceTroll").text = $.Localize("#shop_trollchance") + player_table[2][0] + "%";
    }
}

function GetMaxAllowedPerksForLocalPlayer() {
    const id = Players.GetLocalPlayer();
    const team = Players.GetTeam(id);

    if (team === 3) {
        return 3;
    }

    const active = players_activated_spells?.[id];
    if (!active) {
        return 1;
    }

    for (let i = 1; i <= 3; i++) {
        if (active[i] === "elf_spell_solo_player") {
            return 3;
        }
    }

    return 1;
}

function GetActivatedPerksCount() {
    const id = Players.GetLocalPlayer();
    const active = players_activated_spells?.[id];
    if (!active) {
        return 0;
    }

    let count = 0;
    for (let i = 1; i <= 3; i++) {
        if (active[i] && active[i] !== "") {
            count++;
        }
    }

    return count;
}

function RenderEmptyCells(parent, count) {
    for (let i = 0; i < count; i++) {
        const emptyPanel = $.CreatePanel("Panel", parent, undefined);
        emptyPanel.AddClass("PerkPanel");
    }
}

GameEvents.SubscribeProtected("troll_elves_mod_votes_change_visual", UpdateModVotes);

function InitModVote() {
    if (Game.GetMapInfo().map_display_name == "1x1") {
        $("#ModVotePanel").visible = false;
        return;
    }
    $("#ModVotePanel").visible = true;
    $("#ModVoteYes").SetPanelEvent("onactivate", function () {
        GameEvents.SendCustomGameEventToServer("troll_elves_mod_votes", { panel_id: 1 });
        LocalChooseMod($("#ModVoteYes"));
    });
}

function LocalChooseMod(panel) {
    $("#ModVoteYes").ClearPanelEvent("onactivate");
    $("#ModVoteYes").AddClass("DisabledChoose");
    panel.AddClass("SelectedModLocal");
    votedYesMod = true;
}

function UpdateModVotes(data) {
    if (data.table_votes) {
        data = data.table_votes;
    }
    let yesPercent = 0;

    for (const vote_id in data) {
        const info = data[vote_id];
        if (info.map_id == 1) {
            yesPercent = info.percent;
        }
    }

    const label = $("#SettingsMod");
    label.text = $.Localize("#wolves_mod_voting_desc") + " " + Math.floor(yesPercent) + "%";
    label.visible = true;

    modVoteLabelOverride = label.text;
    if (votedYesMod) {
        $("#ModVoteYes").AddClass("SelectedModLocal");
        $("#ModVoteYes").AddClass("DisabledChoose");
    }
}

(function () {
    Game.AutoAssignPlayersToTeams();
    UpdateChat();
    InitSetup();
    if (Game.GetMapInfo().map_display_name == "1x1") {
        $("#GameInfo").visible = false;
    }
})();
