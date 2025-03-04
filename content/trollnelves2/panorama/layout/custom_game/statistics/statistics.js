var SETTINGS_LIST =
{
    "setting_fps_boots" : 
    {
        "localize" : "Playerstats5",
        "info_in_table" : 4,
        "function_name" : "fps",
    },
    "setting_sounds_wheel" : 
    {
        "localize" : "Playerstats6",
        "info_in_table" : 3,
        "function_name" : "mute",
    },
    "setting_blocking_resource" : 
    {
        "localize" : "Playerstats7",
        "info_in_table" : 5,
        "function_name" : "block",
    },
}

CustomNetTables.SubscribeNetTableListener( "Shop", UpdateSettingsTable )

function UpdateSettingsTable(table, key, data)
{
    if (key == Players.GetLocalPlayer())
    {
        SettingsButtonUpdater(true)
    }
}


function OpenPanel()
{
    let Statistics = $("#Statistics")
    if (!Statistics.BHasClass("Open"))
    {
        Statistics.SetHasClass("Open", true)
        UpdateInformation()
        UpdateAchivements()
        CreateColumns()
        SettingsButtonUpdater()
        Statistics.SetHasClass("IsLocal", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()) == Players.GetLocalPlayer())
    }
    else
    {
        Statistics.SetHasClass("Open", false)
    }
}

function ClosePanel()
{
    let Statistics = $("#Statistics")
    if (Statistics.BHasClass("Open"))
    {
        Statistics.SetHasClass("Open", false)
    }
}

function CreateColumns()
{
    let player_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))
    if (player_table)
    {
        let ColumnsList = $("#ColumnsList")
        ColumnsList.RemoveAndDeleteChildren()
        let elf_info = player_table[8][0]
        let troll_info = player_table[9][0]
        for (var i = 1; i <= 12;i++)
        {
            CreateColumn(i, elf_info, troll_info)
        }
    }
}

function CreateColumn(col_id, info_elf, info_troll) 
{
    let ColumnsList = $("#ColumnsList")
    var ColumnsListLine = $.CreatePanel("Panel", ColumnsList, "");
    ColumnsListLine.AddClass("ColumnsListLine");
    if (col_id % 2 != 0)
    {
        ColumnsListLine.AddClass("GrayStyle");
    }

    let stat_name = $.CreatePanel("Label", ColumnsListLine, "");
    stat_name.AddClass("StatsColumn_Name");
    stat_name.text = $.Localize("#PlayerInfo" + col_id)

    let StatsColumn_Elf = $.CreatePanel("Label", ColumnsListLine, "");
    StatsColumn_Elf.AddClass("StatsColumn_Elf");
    StatsColumn_Elf.text = GetStatsValue(col_id, info_elf)

    let StatsColumn_Troll = $.CreatePanel("Label", ColumnsListLine, "");
    StatsColumn_Troll.AddClass("StatsColumn_Troll");
    StatsColumn_Troll.text = GetStatsValue(col_id, info_troll)
}

function GetStatsValue(id, info)
{
    let result = "No"
    if (id == 1 && info != 0 )
        text = info.bonusPercent
    else if (id == 2 && info != 0 )
        text = info.matchID
    else if (id == 3 && info != 0 )
        text = info.chance + "%"
    else if (id == 4 && info != 0 )
        text = info.kill
    else if (id == 5 && info != 0 )
        text = info.death
    else if (id == 6 && info != 0 )
        text = info.time
    else if (id == 7 && info != 0 )
        text = info.gps
    else if (id == 8 && info != 0 )
        text = info.lps
    else if (id == 9 && info != 0 )
        text = info.goldGained
    else if (id == 10 && info != 0 )
        text = info.goldGiven
    else if (id == 11 && info != 0 )
        text = info.lumberGained
    else if (id == 12 && info != 0 )
        text = info.lumberGiven

    return result
}

function UpdateInformation()
{
    let shop_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))
    if (!shop_table) { return }
    let player_table = shop_table[5];
    let rating_elf = shop_table[8][0];
    let rating_troll = shop_table[9][0];
    let player_rep = shop_table[10];

    let PlayerAvatar = $("#PlayerAvatar")
    PlayerAvatar.steamid = player_table[1]

    let PlayerName = $("#PlayerName")
    PlayerName.text = Players.GetPlayerName(Players.GetLocalPlayer())

    let PlayerID = $("#PlayerID")
    PlayerID.text = "(ID: " + player_table[0] + ")"

    let ReputationRating = $("#ReputationRating")
    ReputationRating.text = String(player_rep[0] || 0)

    let ElfRating = $("#ElfRating")
    ElfRating.text = String(rating_elf.score || 0)

    let TrollRating = $("#TrollRating")
    TrollRating.text = String(rating_troll.score || 0)
}

function SettingsButtonUpdater(update)
{
    let PanelSettings = $("#PanelSettings")
    if (!update)
    {
        PanelSettings.RemoveAndDeleteChildren()
    }
    var player_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()));
    for (button_name in SETTINGS_LIST)
    {
        let settings_info = SETTINGS_LIST[button_name]
        if (update)
        {
            UpdateButtonSetting(settings_info, player_table, button_name)
        }
        else
        {
            CreateButtonSetting(settings_info, player_table, button_name)
        }
    }
} 

function CreateButtonSetting(settings_info, player_table, button_name)
{
    let PanelSettings = $("#PanelSettings")

    let ButtonSetting = $.CreatePanel("Panel", PanelSettings, button_name)
    ButtonSetting.AddClass("ButtonSetting")

    let ButtonSettingName = $.CreatePanel("Label", ButtonSetting, "")
    ButtonSettingName.AddClass("ButtonSettingName")
    ButtonSettingName.text = $.Localize("#" + settings_info.localize)

    let SettingsButtonsContainer =  $.CreatePanel("Panel", ButtonSetting, "")
    SettingsButtonsContainer.AddClass("SettingsButtonsContainer")

    let SettingButtonYes =  $.CreatePanel("Panel", SettingsButtonsContainer, "")
    SettingButtonYes.AddClass("SettingButton")
    SettingButtonYes.AddClass("SettingButtonYes")
    SettingButtonYes.SetPanelEvent("onactivate", function()
    {
        GameEvents.SendCustomGameEventToServer( "Statistics", {id: Players.GetLocalPlayer(), count: 1, type: settings_info.function_name} );
    })

    let SettingButtonYesLabel =  $.CreatePanel("Label", SettingButtonYes, "")
    SettingButtonYesLabel.AddClass("SettingButtonLabel")
    SettingButtonYesLabel.text = $.Localize("#fps_on")

    let SettingButtonNo =  $.CreatePanel("Panel", SettingsButtonsContainer, "")
    SettingButtonNo.AddClass("SettingButton")
    SettingButtonNo.AddClass("SettingButtonNo")
    SettingButtonNo.SetPanelEvent("onactivate", function()
    {
        GameEvents.SendCustomGameEventToServer( "Statistics", {id: Players.GetLocalPlayer(), count: 0, type: settings_info.function_name} );
    })
 
    let SettingButtonNoLabel =  $.CreatePanel("Label", SettingButtonNo, "")
    SettingButtonNoLabel.AddClass("SettingButtonLabel")
    SettingButtonNoLabel.text = $.Localize("#fps_off")
 
    if (player_table && player_table[5])
    {
        ButtonSetting.SetHasClass("Active", player_table[5][settings_info.info_in_table] == 1)
        ButtonSetting.SetHasClass("Deactive", player_table[5][settings_info.info_in_table] == 0 || player_table[5][settings_info.info_in_table] == null)
    }
}

function UpdateButtonSetting(settings_info, player_table, button_name)
{
    let PanelSettings = $("#PanelSettings")
    let ButtonSetting = PanelSettings.FindChildTraverse(button_name)
    if (ButtonSetting)
    {
        if (player_table && player_table[5])
        {
            ButtonSetting.SetHasClass("Active", player_table[5][settings_info.info_in_table] == 1)
            ButtonSetting.SetHasClass("Deactive", player_table[5][settings_info.info_in_table] == 0 || player_table[5][settings_info.info_in_table] == null)
        }
    }
}

function UpdateAchivements()
{
    $("#PanelAchivement").RemoveAndDeleteChildren()
    let player_fake_achivements = [1,2] // Сначала создаю ачивки которые есть у игрока, а потом все остальные
    let player_has_alp = {}
    for (achivement_id of player_fake_achivements)
    {
        player_has_alp[achivement_id] = true
        CreateAchivementPanel(achivement_id, true)
    }
    for (tbl_id in DATA_ACHIVEMENTS_LIST)
    {
        if (!player_has_alp[tbl_id])
        {
            CreateAchivementPanel(tbl_id, false)
        }
    }
}

function CreateAchivementPanel(achivement_id, active)
{
    let achivement_data = DATA_ACHIVEMENTS_LIST[achivement_id]

    let achiviment_panel = $.CreatePanel("Panel", $("#PanelAchivement"), "")
    achiviment_panel.AddClass("achiviment_panel")
    if (active)
    {
        achiviment_panel.AddClass("active")
    }

    let achiviment_panel_glow = $.CreatePanel("Panel", achiviment_panel, "")
    achiviment_panel_glow.AddClass("achiviment_panel_glow")

    let achiviment_panel_icon = $.CreatePanel("Panel", achiviment_panel, "")
    achiviment_panel_icon.AddClass("achiviment_panel_icon")
    achiviment_panel_icon.style.backgroundImage = "url('"+achivement_data.icon+"')"
    achiviment_panel_icon.style.backgroundSize = "100%"

    achiviment_panel.SetPanelEvent('onmouseover', function() 
    {
        $.DispatchEvent('DOTAShowTextTooltip', achiviment_panel, $.Localize( "#" + achivement_data.description_localize )); 
    });
    
	achiviment_panel.SetPanelEvent('onmouseout', function() 
    {
	    $.DispatchEvent('DOTAHideTextTooltip', achiviment_panel);
	});
}

GameUI.CustomUIConfig().OpenStatsGlobal = OpenPanel
GameUI.CustomUIConfig().CloseStatsGlobal = ClosePanel