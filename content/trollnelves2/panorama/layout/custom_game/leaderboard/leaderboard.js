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
    current_2025:
    {
        name: "Current",
        year: 2025,
        order: 100,
        players:
        [
            { accountid: "106096878", summary: 12140, troll: 6120, elves: 6020, games: 134, rank: 1 },
            { accountid: "82631965", summary: 11400, troll: 5800, elves: 5600, games: 120, rank: 2 },
            { accountid: "139384706", summary: 11025, troll: 5650, elves: 5375, games: 112, rank: 3 },
            { accountid: "257483091", summary: 10340, troll: 5200, elves: 5140, games: 108, rank: 4 },
            { accountid: "998877665", summary: 9840, troll: 4920, elves: 4920, games: 101, rank: 5 },
            { accountid: "887766554", summary: 9525, troll: 4740, elves: 4785, games: 98, rank: 6 },
            { accountid: "776655443", summary: 9410, troll: 4700, elves: 4710, games: 94, rank: 7 },
            { accountid: "665544332", summary: 9320, troll: 4620, elves: 4700, games: 92, rank: 8 },
            { accountid: "554433221", summary: 9205, troll: 4560, elves: 4645, games: 90, rank: 9 },
            { accountid: "443322110", summary: 9050, troll: 4500, elves: 4550, games: 88, rank: 10 },
        ],
        local_player:
        {
            accountid: "112233445", summary: 8740, troll: 4350, elves: 4390, games: 86, rank: 14,
        },
    },
    winter_2024:
    {
        name: "Winter",
        year: 2024,
        order: 4,
        players:
        [
            { accountid: "257483091", summary: 11850, troll: 6000, elves: 5850, games: 140, rank: 1 },
            { accountid: "139384706", summary: 11260, troll: 5620, elves: 5640, games: 126, rank: 2 },
            { accountid: "82631965", summary: 10940, troll: 5470, elves: 5470, games: 120, rank: 3 },
            { accountid: "443322110", summary: 10480, troll: 5200, elves: 5280, games: 118, rank: 4 },
            { accountid: "665544332", summary: 10030, troll: 5030, elves: 5000, games: 110, rank: 5 },
        ],
        local_player:
        {
            accountid: "112233445", summary: 9540, troll: 4800, elves: 4740, games: 105, rank: 7,
        },
    },
    autumn_2024:
    {
        name: "Autumn",
        year: 2024,
        order: 3,
        players:
        [
            { accountid: "139384706", summary: 11580, troll: 5820, elves: 5760, games: 133, rank: 1 },
            { accountid: "82631965", summary: 11140, troll: 5610, elves: 5530, games: 127, rank: 2 },
            { accountid: "554433221", summary: 10520, troll: 5300, elves: 5220, games: 118, rank: 3 },
            { accountid: "887766554", summary: 10010, troll: 5000, elves: 5010, games: 110, rank: 4 },
            { accountid: "665544332", summary: 9720, troll: 4880, elves: 4840, games: 106, rank: 5 },
        ],
        local_player:
        {
            accountid: "112233445", summary: 9100, troll: 4550, elves: 4550, games: 104, rank: 9,
        },
    },
    summer_2024:
    {
        name: "Summer",
        year: 2024,
        order: 2,
        players:
        [
            { accountid: "998877665", summary: 11240, troll: 5660, elves: 5580, games: 130, rank: 1 },
            { accountid: "257483091", summary: 10980, troll: 5500, elves: 5480, games: 126, rank: 2 },
            { accountid: "776655443", summary: 10460, troll: 5200, elves: 5260, games: 120, rank: 3 },
            { accountid: "443322110", summary: 9920, troll: 4960, elves: 4960, games: 114, rank: 4 },
            { accountid: "332211009", summary: 9480, troll: 4720, elves: 4760, games: 108, rank: 5 },
        ],
        local_player:
        {
            accountid: "112233445", summary: 9020, troll: 4510, elves: 4510, games: 101, rank: 8,
        },
    },
    spring_2024:
    {
        name: "Spring",
        year: 2024,
        order: 1,
        players:
        [
            { accountid: "82631965", summary: 11080, troll: 5540, elves: 5540, games: 128, rank: 1 },
            { accountid: "665544332", summary: 10510, troll: 5260, elves: 5250, games: 120, rank: 2 },
            { accountid: "554433221", summary: 10140, troll: 5060, elves: 5080, games: 115, rank: 3 },
            { accountid: "332211009", summary: 9780, troll: 4880, elves: 4900, games: 110, rank: 4 },
            { accountid: "221100998", summary: 9340, troll: 4680, elves: 4660, games: 102, rank: 5 },
        ],
        local_player:
        {
            accountid: "112233445", summary: 8820, troll: 4410, elves: 4410, games: 96, rank: 10,
        },
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

    for (let index = 0; index < SEASON_TABS.length; index++)
    {
        PopulateSeasonPanel(SEASON_TABS[index])
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

function PopulateSeasonPanel(seasonTab)
{
    if (!seasonTab || !seasonTab.list || !seasonTab.local)
    {
        return
    }

    seasonTab.list.RemoveAndDeleteChildren()
    seasonTab.local.RemoveAndDeleteChildren()

    let players = ResolveSeasonPlayers(seasonTab.info)
    if (players.length === 0)
    {
        CreateSeasonPlaceholder(seasonTab.list, "No results for this season yet.")
    }
    else
    {
        for (let index = 0; index < players.length; index++)
        {
            let normalizedPlayer = NormalizeSeasonPlayerEntry(players[index], index + 1)
            if (!normalizedPlayer)
            {
                continue
            }
            CreateSeasonPlayerRow(seasonTab.list, normalizedPlayer, false)
        }
    }

    let localPlayer = ResolveSeasonLocalPlayer(seasonTab.info)
    if (localPlayer)
    {
        let normalizedLocal = NormalizeSeasonPlayerEntry(localPlayer, localPlayer.rank || localPlayer.place || 0)
        CreateSeasonPlayerRow(seasonTab.local, normalizedLocal, true)
    }
    else
    {
        CreateSeasonPlaceholder(seasonTab.local, "Local player has no record for this season.")
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

function ResolveSeasonPlayers(seasonInfo)
{
    if (!seasonInfo)
    {
        return []
    }

    if (Array.isArray(seasonInfo.players))
    {
        return seasonInfo.players
    }

    if (Array.isArray(seasonInfo.leaderboard))
    {
        return seasonInfo.leaderboard
    }

    if (Array.isArray(seasonInfo.entries))
    {
        return seasonInfo.entries
    }

    if (seasonInfo.players && typeof seasonInfo.players === "object")
    {
        let mappedPlayers = []
        for (let key in seasonInfo.players)
        {
            if (!seasonInfo.players.hasOwnProperty(key))
            {
                continue
            }
            mappedPlayers.push(seasonInfo.players[key])
        }
        return mappedPlayers
    }

    return []
}

function ResolveSeasonLocalPlayer(seasonInfo)
{
    if (!seasonInfo)
    {
        return null
    }

    if (seasonInfo.local_player)
    {
        return seasonInfo.local_player
    }

    if (seasonInfo.localPlayer)
    {
        return seasonInfo.localPlayer
    }

    if (seasonInfo.player)
    {
        return seasonInfo.player
    }

    return null
}

function NormalizeSeasonPlayerEntry(entry, fallbackRank)
{
    if (!entry)
    {
        return null
    }

    let normalized =
    {
        rank: Number(fallbackRank) || 0,
        accountid: "",
        steamid: "",
        summary: 0,
        troll: 0,
        elves: 0,
        games: 0,
        displayName: "",
    }

    if (Array.isArray(entry))
    {
        if (entry.length > 0 && entry[0] !== undefined && entry[0] !== null)
        {
            normalized.accountid = String(entry[0])
            normalized.steamid = String(entry[0])
        }
        if (entry.length > 1)
        {
            normalized.summary = ToNumber(entry[1], normalized.summary)
        }
        if (entry.length > 2)
        {
            normalized.troll = ToNumber(entry[2], normalized.troll)
        }
        if (entry.length > 3)
        {
            normalized.elves = ToNumber(entry[3], normalized.elves)
        }
        if (entry.length > 4)
        {
            normalized.games = ToNumber(entry[4], normalized.games)
        }
        if (entry.length > 5 && entry[5])
        {
            normalized.displayName = String(entry[5])
        }
    }
    else if (typeof entry === "object")
    {
        if (entry.rank !== undefined)
        {
            normalized.rank = Number(entry.rank) || normalized.rank
        }
        else if (entry.place !== undefined)
        {
            normalized.rank = Number(entry.place) || normalized.rank
        }

        let accountCandidate = entry.accountid
        if (accountCandidate === undefined || accountCandidate === null)
        {
            accountCandidate = entry.steamid || entry.id || entry.player_id || entry.playerid
        }

        if (accountCandidate !== undefined && accountCandidate !== null && accountCandidate !== "")
        {
            normalized.accountid = String(accountCandidate)
            normalized.steamid = String(entry.steamid || accountCandidate)
        }

        normalized.summary = ToNumber(entry.summary, normalized.summary)
        normalized.summary = ToNumber(entry.summary_rating, normalized.summary)
        normalized.summary = ToNumber(entry.total, normalized.summary)
        normalized.summary = ToNumber(entry.rating, normalized.summary)

        normalized.troll = ToNumber(entry.troll, normalized.troll)
        normalized.troll = ToNumber(entry.troll_rating, normalized.troll)
        normalized.troll = ToNumber(entry.rating_troll, normalized.troll)

        normalized.elves = ToNumber(entry.elves, normalized.elves)
        normalized.elves = ToNumber(entry.elves_rating, normalized.elves)
        normalized.elves = ToNumber(entry.rating_elves, normalized.elves)

        normalized.games = ToNumber(entry.games, normalized.games)
        normalized.games = ToNumber(entry.matches, normalized.games)
        normalized.games = ToNumber(entry.games_played, normalized.games)

        if (entry.name)
        {
            normalized.displayName = String(entry.name)
        }
        else if (entry.player_name)
        {
            normalized.displayName = String(entry.player_name)
        }
        else if (entry.username)
        {
            normalized.displayName = String(entry.username)
        }
    }
    else if (typeof entry === "string")
    {
        normalized.displayName = entry
    }

    if (!normalized.displayName && normalized.accountid)
    {
        normalized.displayName = normalized.accountid
    }

    if (!normalized.rank || normalized.rank <= 0)
    {
        normalized.rank = Number(fallbackRank) || 0
    }

    return normalized
}

function CreateSeasonPlayerRow(container, playerData, isLocal)
{
    if (!container || !playerData)
    {
        return
    }

    let line = $.CreatePanel("Panel", container, "")
    line.AddClass("LinePlayer")

    let highlightRank = Number(playerData.rank)
    if (!isNaN(highlightRank) && highlightRank > 0 && highlightRank <= 3 && !isLocal)
    {
        line.AddClass("LinePlayer_" + highlightRank)
    }

    let idLabel = $.CreatePanel("Label", line, "")
    idLabel.AddClass("Leaderboard_column_id")
    idLabel.text = highlightRank > 0 ? String(highlightRank) : "-"

    let nameContainer = $.CreatePanel("Panel", line, "")
    nameContainer.AddClass("Leaderboard_column_name")
    nameContainer.style.flowChildren = "right"

    if (playerData.accountid)
    {
        let avatar = $.CreatePanel("DOTAAvatarImage", nameContainer, "")
        avatar.style.width = "22px"
        avatar.style.height = "22px"
        avatar.style.marginRight = "10px"
        avatar.style.verticalAlign = "center"
        let accountIdNumber = Number(playerData.accountid)
        if (!isNaN(accountIdNumber) && accountIdNumber > 0)
        {
            avatar.accountid = accountIdNumber
        }
        else
        {
            avatar.accountid = playerData.accountid
        }

        let userName = $.CreatePanel("DOTAUserName", nameContainer, "")
        userName.AddClass("Leaderboard_column_name_label")
        userName.style.verticalAlign = "center"
        if (!isNaN(accountIdNumber) && accountIdNumber > 0)
        {
            userName.steamid = String(accountIdNumber)
        }
        else
        {
            userName.steamid = playerData.steamid || playerData.accountid
        }
        if (playerData.displayName)
        {
            userName.text = playerData.displayName
        }
    }
    else
    {
        let nameLabel = $.CreatePanel("Label", nameContainer, "")
        nameLabel.AddClass("Leaderboard_column_name_label")
        nameLabel.style.verticalAlign = "center"
        nameLabel.text = playerData.displayName || "Unknown"
    }

    let summaryLabel = $.CreatePanel("Label", line, "")
    summaryLabel.AddClass("Leaderboard_column_sum")
    summaryLabel.text = FormatSeasonValue(playerData.summary)

    let trollLabel = $.CreatePanel("Label", line, "")
    trollLabel.AddClass("Leaderboard_column_troll")
    trollLabel.text = FormatSeasonValue(playerData.troll)

    let elvesLabel = $.CreatePanel("Label", line, "")
    elvesLabel.AddClass("Leaderboard_column_elves")
    elvesLabel.text = FormatSeasonValue(playerData.elves)

    let gamesLabel = $.CreatePanel("Label", line, "")
    gamesLabel.AddClass("Leaderboard_column_games")
    gamesLabel.text = FormatSeasonValue(playerData.games)
}

function CreateSeasonPlaceholder(container, text)
{
    if (!container)
    {
        return
    }

    let label = $.CreatePanel("Label", container, "")
    label.AddClass("SeasonPlaceholderText")
    label.text = text || "No data"
}

function FormatSeasonValue(value)
{
    if (value === undefined || value === null)
    {
        return "-"
    }

    if (typeof value === "number")
    {
        if (!isFinite(value))
        {
            return "-"
        }
        return String(Math.round(value))
    }

    return String(value)
}

function ToNumber(value, fallback)
{
    let parsed = Number(value)
    if (!isNaN(parsed))
    {
        return parsed
    }

    return fallback === undefined ? 0 : fallback
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
