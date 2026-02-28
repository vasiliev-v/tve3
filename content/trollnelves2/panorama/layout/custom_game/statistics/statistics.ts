// @ts-nocheck
var SETTINGS_LIST
= {
    setting_fps_boots:
    {
        localize: "Playerstats5",
        info_in_table: 4,
        function_name: "fps",
    },
    setting_sounds_wheel:
    {
        localize: "Playerstats6",
        info_in_table: 3,
        function_name: "mute",
    },
    setting_blocking_resource:
    {
        localize: "Playerstats7",
        info_in_table: 5,
        function_name: "block",
    },
};

var selectedAchivementId = null;
var isAchivementShownOnScoreboard = false;

CustomNetTables.SubscribeNetTableListener("Shop", UpdateSettingsTable);

function UpdateSettingsTable(table, key, data) {
    if (key == Players.GetLocalPlayer()) {
        SettingsButtonUpdater(true);
    }
}

function Statistics_OpenPanel() {
    const Statistics = $("#Statistics");
    if (!Statistics.BHasClass("Open")) {
        Statistics.SetHasClass("Open", true);
        UpdateInformation();
        CreateColumns();
        SettingsButtonUpdater();
        UpdateAchivements();
        Statistics.SetHasClass("IsLocal", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()) == Players.GetLocalPlayer());
    } else {
        Statistics.SetHasClass("Open", false);
    }
}

function Statistics_ClosePanel() {
    const Statistics = $("#Statistics");
    if (Statistics.BHasClass("Open")) {
        Statistics.SetHasClass("Open", false);
    }
}

function CreateColumns() {
    const player_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()));
    if (player_table) {
        const ColumnsList = $("#ColumnsList");
        ColumnsList.RemoveAndDeleteChildren();
        const elf_info = player_table[8][0];
        const troll_info = player_table[9][0];
        for (let i = 1; i <= 12; i++) {
            CreateColumn(i, elf_info, troll_info);
        }
    }
}

function CreateColumn(col_id, info_elf, info_troll) {
    const ColumnsList = $("#ColumnsList");
    const ColumnsListLine = $.CreatePanel("Panel", ColumnsList, "");
    ColumnsListLine.AddClass("ColumnsListLine");
    if (col_id % 2 != 0) {
        ColumnsListLine.AddClass("GrayStyle");
    }

    const stat_name = $.CreatePanel("Label", ColumnsListLine, "");
    stat_name.AddClass("StatsColumn_Name");
    stat_name.text = $.Localize("#PlayerInfo" + col_id);

    const StatsColumn_Elf = $.CreatePanel("Label", ColumnsListLine, "");
    StatsColumn_Elf.AddClass("StatsColumn_Elf");
    StatsColumn_Elf.text = GetStatsValue(col_id, info_elf);

    const StatsColumn_Troll = $.CreatePanel("Label", ColumnsListLine, "");
    StatsColumn_Troll.AddClass("StatsColumn_Troll");
    StatsColumn_Troll.text = GetStatsValue(col_id, info_troll);
}

function GetStatsValue(id, info) {
    let text = "No";
    if (id == 1 && info != 0) {
        text = info.bonusPercent;
    } else if (id == 2 && info != 0) {
        text = info.matchID;
    } else if (id == 3 && info != 0) {
        text = info.chance + "%";
    } else if (id == 4 && info != 0) {
        text = info.kill;
    } else if (id == 5 && info != 0) {
        text = info.death;
    } else if (id == 6 && info != 0) {
        text = info.time;
    } else if (id == 7 && info != 0) {
        text = info.gps;
    } else if (id == 8 && info != 0) {
        text = info.lps;
    } else if (id == 9 && info != 0) {
        text = info.goldGained;
    } else if (id == 10 && info != 0) {
        text = info.goldGiven;
    } else if (id == 11 && info != 0) {
        text = info.lumberGained;
    } else if (id == 12 && info != 0) {
        text = info.lumberGiven;
    }

    return text;
}

function UpdateInformation() {
    const shop_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()));
    if (!shop_table) {
        return;
    }

    const rating_elf = shop_table[13][5];
    const rating_troll = shop_table[13][4];
    const player_rep = shop_table[10];

    const PlayerAvatar = $("#PlayerAvatar");
    PlayerAvatar.steamid = shop_table[5][1];

    const PlayerName = $("#PlayerName");
    PlayerName.text = Players.GetPlayerName(Players.GetLocalPlayer());

    const PlayerID = $("#PlayerID");
    PlayerID.text = "(ID: " + shop_table[5][0] + ")";

    const ReputationRating = $("#ReputationRating");
    ReputationRating.text = String(player_rep[0] || 0);

    const ElfRating = $("#ElfRating");
    ElfRating.text = String(rating_elf || 0);

    const TrollRating = $("#TrollRating");
    TrollRating.text = String(rating_troll || 0);
}

function SettingsButtonUpdater(update) {
    const PanelSettings = $("#PanelSettings");
    if (!update) {
        PanelSettings.RemoveAndDeleteChildren();
    }
    const player_table: any = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()));
    for (button_name in SETTINGS_LIST) {
        const settings_info = SETTINGS_LIST[button_name];
        if (update) {
            UpdateButtonSetting(settings_info, player_table, button_name);
        } else {
            CreateButtonSetting(settings_info, player_table, button_name);
        }
    }
}

function CreateButtonSetting(settings_info, player_table, button_name) {
    const PanelSettings = $("#PanelSettings");

    const ButtonSetting = $.CreatePanel("Panel", PanelSettings, button_name);
    ButtonSetting.AddClass("ButtonSetting");

    const ButtonSettingName = $.CreatePanel("Label", ButtonSetting, "");
    ButtonSettingName.AddClass("ButtonSettingName");
    ButtonSettingName.text = $.Localize("#" + settings_info.localize);

    const SettingsButtonsContainer = $.CreatePanel("Panel", ButtonSetting, "");
    SettingsButtonsContainer.AddClass("SettingsButtonsContainer");

    const SettingButtonYes = $.CreatePanel("Panel", SettingsButtonsContainer, "");
    SettingButtonYes.AddClass("SettingButton");
    SettingButtonYes.AddClass("SettingButtonYes");
    SettingButtonYes.SetPanelEvent("onactivate", function () {
        GameEvents.SendCustomGameEventToServer("Statistics", { id: Players.GetLocalPlayer(), count: 1, type: settings_info.function_name });
    });

    const SettingButtonYesLabel = $.CreatePanel("Label", SettingButtonYes, "");
    SettingButtonYesLabel.AddClass("SettingButtonLabel");
    SettingButtonYesLabel.text = $.Localize("#fps_on");

    const SettingButtonNo = $.CreatePanel("Panel", SettingsButtonsContainer, "");
    SettingButtonNo.AddClass("SettingButton");
    SettingButtonNo.AddClass("SettingButtonNo");
    SettingButtonNo.SetPanelEvent("onactivate", function () {
        GameEvents.SendCustomGameEventToServer("Statistics", { id: Players.GetLocalPlayer(), count: 0, type: settings_info.function_name });
    });

    const SettingButtonNoLabel = $.CreatePanel("Label", SettingButtonNo, "");
    SettingButtonNoLabel.AddClass("SettingButtonLabel");
    SettingButtonNoLabel.text = $.Localize("#fps_off");

    if (player_table && player_table[5]) {
        ButtonSetting.SetHasClass("Active", player_table[5][settings_info.info_in_table] == 1);
        ButtonSetting.SetHasClass("Deactive", player_table[5][settings_info.info_in_table] == 0 || player_table[5][settings_info.info_in_table] == null);
    }
}

function UpdateButtonSetting(settings_info, player_table, button_name) {
    const PanelSettings = $("#PanelSettings");
    const ButtonSetting = PanelSettings.FindChildTraverse(button_name);
    if (ButtonSetting) {
        if (player_table && player_table[5]) {
            ButtonSetting.SetHasClass("Active", player_table[5][settings_info.info_in_table] == 1);
            ButtonSetting.SetHasClass("Deactive", player_table[5][settings_info.info_in_table] == 0 || player_table[5][settings_info.info_in_table] == null);
        }
    }
}

function EnsureScoreboardAchivementStore() {
    if (!GameUI.CustomUIConfig().scoreboardAchievements) {
        GameUI.CustomUIConfig().scoreboardAchievements = {};
    }
}

function UpdateScoreboardAchivementSelection() {
    EnsureScoreboardAchivementStore();
    const achivementData = DATA_ACHIVEMENTS_LIST[selectedAchivementId];
    const playerAchivements = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))?.[17];
    let counterValue = null;

    if (playerAchivements && selectedAchivementId in playerAchivements) {
        counterValue = playerAchivements[selectedAchivementId];
    }

    if (isAchivementShownOnScoreboard && achivementData) {
        GameUI.CustomUIConfig().scoreboardAchievements[Players.GetLocalPlayer()] = {
            id: selectedAchivementId,
            icon: achivementData.icon,
            counter: counterValue,
        };
    } else {
        GameUI.CustomUIConfig().scoreboardAchievements[Players.GetLocalPlayer()] = null;
        isAchivementShownOnScoreboard = false;
    }

    UpdateSelectedAchivementHighlight();
}

function SelectAchivement(achivement_id) {
    if (selectedAchivementId === achivement_id) {
        isAchivementShownOnScoreboard = !isAchivementShownOnScoreboard;
    } else {
        selectedAchivementId = achivement_id;
        isAchivementShownOnScoreboard = true;
    }

    UpdateSelectedAchivementHighlight();
    UpdateScoreboardAchivementSelection();
}

function UpdateSelectedAchivementHighlight() {
    const container = $("#PanelAchivement");
    if (!container) {
        return;
    }

    // let children = container.Children() || []
    // children.forEach(child => {
    //    const isSelected = child.achivement_id == selectedAchivementId
    //    child.SetHasClass("selected", isSelected)
    //    child.SetHasClass("show-on-scoreboard", isSelected && isAchivementShownOnScoreboard)
    // })
}

function UpdateAchivements() {
    $("#PanelAchivement").RemoveAndDeleteChildren();
    const player_has_alp = {};
    EnsureScoreboardAchivementStore();
    const stored_achivement = GameUI.CustomUIConfig().scoreboardAchievements[Players.GetLocalPlayer()];
    player_achivements = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))[17] || {};

    if (stored_achivement && DATA_ACHIVEMENTS_LIST[stored_achivement.id]) {
        selectedAchivementId = stored_achivement.id;
        isAchivementShownOnScoreboard = true;
    } else {
        selectedAchivementId = null;
        isAchivementShownOnScoreboard = false;
    }

    if (!player_achivements || Object.keys(player_achivements).length === 0) {
        GameUI.CustomUIConfig().scoreboardAchievements[Players.GetLocalPlayer()] = null;
        UpdateScoreboardAchivementSelection();
        return;
    }
    for (const achivement_id in player_achivements) {
        if (!DATA_ACHIVEMENTS_LIST[achivement_id]) {
            continue;
        }
        player_has_alp[achivement_id] = true;
        CreateAchivementPanel(achivement_id, true, player_achivements[achivement_id]);
    }
    if (!selectedAchivementId) {
        const first_achivement = Object.keys(player_achivements)[0];
        selectedAchivementId = first_achivement;
    }
    UpdateSelectedAchivementHighlight();
    UpdateScoreboardAchivementSelection();
    // for (tbl_id in DATA_ACHIVEMENTS_LIST)
    // {
    //    if (!player_has_alp[tbl_id])
    //    {
    //        CreateAchivementPanel(tbl_id, false)
    //    }
    // }
}

function CreateAchivementPanel(achivement_id, active, counterValue) {
    const achivement_data = DATA_ACHIVEMENTS_LIST[achivement_id];

    const achiviment_panel = $.CreatePanel("Panel", $("#PanelAchivement"), "");
    achiviment_panel.AddClass("achiviment_panel");
    achiviment_panel.achivement_id = achivement_id;

    const achiviment_panel_body = $.CreatePanel("Panel", achiviment_panel, "");
    achiviment_panel_body.AddClass("achiviment_panel_body");

    if (active) {
        achiviment_panel.AddClass("active");
    }

    achiviment_panel.SetPanelEvent("onactivate", function () {
        SelectAchivement(achivement_id);
    });

    const achiviment_panel_glow = $.CreatePanel("Panel", achiviment_panel_body, "");
    achiviment_panel_glow.AddClass("achiviment_panel_glow");

    const achiviment_panel_icon = $.CreatePanel("Panel", achiviment_panel_body, "");
    achiviment_panel_icon.AddClass("achiviment_panel_icon");
    achiviment_panel_icon.style.backgroundImage = "url('" + achivement_data.icon + "')";
    achiviment_panel_icon.style.backgroundSize = "100%";

    const achiviment_panel_counter = $.CreatePanel("Panel", achiviment_panel, "");
    achiviment_panel_counter.AddClass("achiviment_panel_counter");

    const achiviment_panel_counter_glow = $.CreatePanel("Panel", achiviment_panel_counter, "");
    achiviment_panel_counter_glow.AddClass("achiviment_panel_counter_glow");

    const achiviment_panel_counter_label = $.CreatePanel("Label", achiviment_panel_counter, "");
    achiviment_panel_counter_label.AddClass("achiviment_panel_counter_label");
    achiviment_panel_counter_label.text = counterValue != null ? String(counterValue) : "";

    achiviment_panel_counter.visible = achivement_data.is_allow_counter && counterValue != null;

    achiviment_panel.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowTextTooltip", achiviment_panel, $.Localize("#" + achivement_data.description_localize));
    });

    achiviment_panel.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideTextTooltip", achiviment_panel);
    });
}

GameUI.CustomUIConfig().OpenStatsGlobal = Statistics_OpenPanel;
GameUI.CustomUIConfig().CloseStatsGlobal = Statistics_ClosePanel;
