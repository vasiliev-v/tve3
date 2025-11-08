var INIT_PANEL = false
var HAS_PLAYER_IN_ALL_TABLE = false
var FAKE_LEADERBOARD_LIST =
{

}
var FAKE_PLAYER_LOCAL =
{
}
var FAKE_SEASON_HISTORY =
{
    winter_2025:
    {
        name: "Winter",
        year: 2025,
        order: 4,
        players: [],
    },
    autumn_2024:
    {
        name: "Autumn",
        year: 2024,
        order: 3,
        players: [],
    },
    summer_2024:
    {
        name: "Summer",
        year: 2024,
        order: 2,
        players: [],
    },
    spring_2024:
    {
        name: "Spring",
        year: 2024,
        order: 1,
        players: [],
    },
}
var SEASON_TABS = []
var IS_SEASON_LISTENER_ATTACHED = false
var ACTIVE_SEASON_INDEX = 0

/*
var FAKE_PLAYER_LOCAL =
{
    top_place: 203,
    steamid: "106096878",
    troll_rating : 10100,
    elves_rating : 10200,
    summary_rating : 13000,
    games: 100,
}
*/

function OpenPanel()
{
    let Leaderboard = $("#Leaderboard")
    Leaderboard.SetHasClass("Open", !Leaderboard.BHasClass("Open"))
    if (!INIT_PANEL)
    {
        INIT_PANEL = true
        InitPlayersRating(1)
        InitLocalPlayer()
        InitSeasonTabs()
    }
}

function ClosePanel()
{
    let Leaderboard = $("#Leaderboard")
    if (Leaderboard.BHasClass("Open"))
    {
        Leaderboard.SetHasClass("Open", false)
    }
}

function InitPlayersRating(sort_id)
{
    let PlayersList = $("#PlayersList")
    PlayersList.RemoveAndDeleteChildren()
    FAKE_LEADERBOARD_LIST = CustomNetTables.GetTableValue("Shop", "top10")
    let players_table = []
    for (num in FAKE_LEADERBOARD_LIST)
    {
        let player_info = FAKE_LEADERBOARD_LIST[num]
        players_table.push([player_info[1], player_info[2], player_info[3], player_info[4], player_info[5]])
    }
    players_table.sort((a, b) => b[sort_id] - a[sort_id]);
    for (num in players_table)
    {
        IsCondLocalPlayer(players_table[num])
        CreatePlayer(num, players_table[num])
    }
}

function IsCondLocalPlayer(players_table)
{
    let shop_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))?.[13];
    if (!shop_table) { return }
    let local_player_info = [shop_table[2], shop_table[3], shop_table[4], shop_table[5], shop_table[6]]
    if (players_table[0] == local_player_info[0])
    {
        HAS_PLAYER_IN_ALL_TABLE = true
    }
}

function InitLocalPlayer()
{
    let shop_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))?.[13];
    if (!shop_table) { return }
    let local_player_info = [shop_table[2], shop_table[3], shop_table[4], shop_table[5], shop_table[6]]
    if (HAS_PLAYER_IN_ALL_TABLE)
    {
        return
    }
    CreatePlayer(shop_table[1], local_player_info, true)
}

function CreatePlayer(num, player_info, is_local)
{
    let PlayersList = $("#PlayersList")
    if (is_local)
    {
        PlayersList = $("#LocalPlayer")
    }

    let Line = $.CreatePanel("Panel", PlayersList, "")
    Line.AddClass("LinePlayer")
    Line.AddClass("LinePlayer_"+(Number(num) + 1))

    let Leaderboard_column_id = $.CreatePanel("Label", Line, "")
    Leaderboard_column_id.AddClass("Leaderboard_column_id")
    Leaderboard_column_id.text = (Number(num) + 1)

    let Leaderboard_column_name = $.CreatePanel("Panel", Line, "")
    Leaderboard_column_name.AddClass("Leaderboard_column_name")
    Leaderboard_column_name.style.flowChildren = "right"

    let Leaderboard_column_name_avatar = $.CreatePanel("DOTAAvatarImage", Leaderboard_column_name, "", {style:"width:22px;height:22px;margin-right:10px;vertical-align:center;"})
    Leaderboard_column_name_avatar.accountid = player_info[0]

    let Leaderboard_column_name_label = $.CreatePanel("DOTAUserName", Leaderboard_column_name, "", {style:"vertical-align:center;"})
    Leaderboard_column_name_label.AddClass("Leaderboard_column_name_label")
    Leaderboard_column_name_label.steamid = player_info[0]

    let Leaderboard_column_sum = $.CreatePanel("Label", Line, "")
    Leaderboard_column_sum.AddClass("Leaderboard_column_sum")
    Leaderboard_column_sum.text = player_info[1]

    let Leaderboard_column_troll = $.CreatePanel("Label", Line, "")
    Leaderboard_column_troll.AddClass("Leaderboard_column_troll")
    Leaderboard_column_troll.text = player_info[2]

    let Leaderboard_column_elves = $.CreatePanel("Label", Line, "")
    Leaderboard_column_elves.AddClass("Leaderboard_column_elves")
    Leaderboard_column_elves.text = player_info[3]

    let Leaderboard_column_games = $.CreatePanel("Label", Line, "")
    Leaderboard_column_games.AddClass("Leaderboard_column_games")
    Leaderboard_column_games.text = player_info[4]
}

function InitSeasonTabs()
{
    if (!IS_SEASON_LISTENER_ATTACHED)
    {
        CustomNetTables.SubscribeNetTableListener("Shop", OnShopTableChanged)
        IS_SEASON_LISTENER_ATTACHED = true
    }

    UpdateSeasonTabs(CustomNetTables.GetTableValue("Shop", "season_history"))
}

function OnShopTableChanged(tableName, keyName, data)
{
    if (tableName !== "Shop")
    {
        return
    }

    if (keyName === "season_history")
    {
        UpdateSeasonTabs(data)
    }
}

function UpdateSeasonTabs(seasonData)
{
    let tabsContainer = $("#SeasonTabs")
    let contentContainer = $("#SeasonContent")

    if (!tabsContainer || !contentContainer)
    {
        return
    }

    tabsContainer.RemoveAndDeleteChildren()
    contentContainer.RemoveAndDeleteChildren()
    SEASON_TABS = []

    if (!seasonData || Object.keys(seasonData).length === 0)
    {
        seasonData = FAKE_SEASON_HISTORY
    }

    let seasons = []
    for (let seasonKey in seasonData)
    {
        if (!seasonData.hasOwnProperty(seasonKey))
        {
            continue
        }
        seasons.push({ key: seasonKey, info: seasonData[seasonKey] })
    }

    seasons.sort((a, b) =>
    {
        let orderDiff = ResolveSeasonOrder(b) - ResolveSeasonOrder(a)
        if (orderDiff !== 0)
        {
            return orderDiff
        }
        let keyA = Number(a.key)
        let keyB = Number(b.key)
        if (!Number.isNaN(keyA) && !Number.isNaN(keyB))
        {
            return keyA - keyB
        }

        return String(a.key).localeCompare(String(b.key))
    })

    for (let index = 0; index < seasons.length; index++)
    {
        let seasonEntry = seasons[index]
        let tabButton = $.CreatePanel("Button", tabsContainer, "")
        tabButton.AddClass("SeasonTabButton")

        let tabLabel = $.CreatePanel("Label", tabButton, "")
        tabLabel.text = ResolveSeasonLabel(seasonEntry, Number(index))

        let seasonPanel = $.CreatePanel("Panel", contentContainer, "SeasonPanel_" + seasonEntry.key)
        seasonPanel.AddClass("SeasonPanel")

        let headerPanel = $.CreatePanel("Panel", seasonPanel, "")
        headerPanel.AddClass("LeaderboardColumnsHeader")
        headerPanel.AddClass("SeasonHeader")
        BuildSeasonHeader(headerPanel)

        let playersList = $.CreatePanel("Panel", seasonPanel, "SeasonPlayersList_" + seasonEntry.key)
        playersList.AddClass("SeasonPlayersList")

        let localPlayer = $.CreatePanel("Panel", seasonPanel, "SeasonLocalPlayer_" + seasonEntry.key)
        localPlayer.AddClass("SeasonLocalPlayer")

        let buttonIndex = index
        tabButton.SetPanelEvent("onactivate", () => ActivateSeasonTab(buttonIndex))

        SEASON_TABS.push({
            button: tabButton,
            panel: seasonPanel,
            list: playersList,
            local: localPlayer,
            key: seasonEntry.key,
            info: seasonEntry.info,
        })
    }

    if (SEASON_TABS.length > 0)
    {
        let indexToActivate = ACTIVE_SEASON_INDEX
        if (indexToActivate >= SEASON_TABS.length)
        {
            indexToActivate = SEASON_TABS.length - 1
        }

        ActivateSeasonTab(Math.max(indexToActivate, 0))
    }
}

function ActivateSeasonTab(activeIndex)
{
    activeIndex = Number(activeIndex)
    ACTIVE_SEASON_INDEX = activeIndex
    for (let index = 0; index < SEASON_TABS.length; index++)
    {
        let seasonTab = SEASON_TABS[index]
        let isActive = index === activeIndex
        seasonTab.button.SetHasClass("Active", isActive)
        seasonTab.panel.SetHasClass("Active", isActive)
    }
}

function ResolveSeasonOrder(seasonEntry)
{
    if (!seasonEntry)
    {
        return 0
    }

    let info = seasonEntry.info
    if (info && info.order !== undefined)
    {
        return Number(info.order) || 0
    }

    if (info && info.season_id !== undefined)
    {
        return Number(info.season_id) || 0
    }

    if (info && info.id !== undefined)
    {
        return Number(info.id) || 0
    }

    if (info && info.year !== undefined)
    {
        return Number(info.year) || 0
    }

    return Number(seasonEntry.key) || 0
}

function ResolveSeasonLabel(seasonEntry, fallbackIndex)
{
    if (!seasonEntry)
    {
        return "Season"
    }

    let info = seasonEntry.info
    if (typeof info === "string")
    {
        return info
    }

    if (Array.isArray(info))
    {
        let seasonName = info[0]
        let seasonYear = info[1]

        if (seasonYear !== undefined && seasonYear !== null)
        {
            seasonYear = String(seasonYear)
            if (seasonYear.length === 4)
            {
                seasonYear = seasonYear.slice(2)
            }
        }

        if (seasonName && seasonYear)
        {
            return seasonName + " " + seasonYear
        }

        if (seasonName)
        {
            return seasonName
        }

        if (seasonYear)
        {
            return String(seasonYear)
        }
    }

    if (info && info.button_label)
    {
        return info.button_label
    }

    if (info && info.label)
    {
        return info.label
    }

    let seasonName = ""
    if (info)
    {
        seasonName = info.name || info.season || info.title || ""
    }

    let seasonYear = info ? (info.year !== undefined ? info.year : (info.year_short !== undefined ? info.year_short : info.season_year)) : undefined

    if (seasonYear !== undefined && seasonYear !== null)
    {
        seasonYear = String(seasonYear)
        if (seasonYear.length === 4)
        {
            seasonYear = seasonYear.slice(2)
        }
    }

    if (seasonName && seasonYear)
    {
        return seasonName + " " + seasonYear
    }

    if (seasonName)
    {
        return seasonName
    }

    if (seasonYear)
    {
        return String(seasonYear)
    }

    return "Season " + (Number(fallbackIndex) + 1)
}

function BuildSeasonHeader(headerPanel)
{
    let columns = [
        { className: "Leaderboard_column_id", text: "№" },
        { className: "Leaderboard_column_name", text: "Name" },
        { className: "Leaderboard_column_sum", text: "Summary" },
        { className: "Leaderboard_column_troll", text: "Troll" },
        { className: "Leaderboard_column_elves", text: "Elves" },
        { className: "Leaderboard_column_games", text: "Games" },
    ]

    for (let column of columns)
    {
        let headerLabel = $.CreatePanel("Label", headerPanel, "")
        headerLabel.AddClass(column.className)
        headerLabel.text = column.text
    }
}

GameUI.CustomUIConfig().OpenLeaderboardGlobal = OpenPanel
GameUI.CustomUIConfig().CloseLeaderboardGlobal = ClosePanel
