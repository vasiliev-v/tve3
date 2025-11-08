var INIT_PANEL = false
var HAS_PLAYER_IN_ALL_TABLE = false
var CURRENT_LEADERBOARD = []
var SEASON_DATA = []
var SEASON_BUTTONS = {}
var CURRENT_SEASON_ID = null
var CURRENT_SEASON_ALLOW_LOCAL = true
var LOCAL_PLAYER_ENTRY = null

var SEASON_TABLE_KEYS = [
    "top10_seasons",
    "top10_history",
    "top10season",
    "top10seasons",
]

function OpenPanel()
{
    let Leaderboard = $("#Leaderboard")
    let shouldOpen = !Leaderboard.BHasClass("Open")
    Leaderboard.SetHasClass("Open", shouldOpen)

    if (!shouldOpen)
    {
        return
    }

    if (!INIT_PANEL)
    {
        INIT_PANEL = true
    }

    BuildSeasonsAndLeaderboard()
}

function ClosePanel()
{
    let Leaderboard = $("#Leaderboard")
    if (Leaderboard.BHasClass("Open"))
    {
        Leaderboard.SetHasClass("Open", false)
    }
}

function BuildSeasonsAndLeaderboard()
{
    let preferredSelection = CURRENT_SEASON_ID
    SEASON_DATA = LoadSeasonData()
    RenderSeasonTabs(preferredSelection)
}

function LoadSeasonData()
{
    let seasons = []

    for (let index in SEASON_TABLE_KEYS)
    {
        let key = SEASON_TABLE_KEYS[index]
        let table = CustomNetTables.GetTableValue("Shop", key)
        if (!table)
        {
            continue
        }

        for (let seasonKey in table)
        {
            let normalized = NormalizeSeasonEntry(seasonKey, table[seasonKey], key)
            if (normalized)
            {
                seasons.push(normalized)
            }
        }
    }

    let currentTop = ExtractPlayersFromTable(CustomNetTables.GetTableValue("Shop", "top10"))
    if (currentTop.length > 0)
    {
        let alreadyHasCurrent = false
        for (let i in seasons)
        {
            if (seasons[i].isCurrent)
            {
                alreadyHasCurrent = true
                break
            }
        }

        if (!alreadyHasCurrent)
        {
            seasons.push({
                key: "current",
                displayName: $.Localize("#top10") || "Top 10",
                players: currentTop,
                order: Number.MAX_SAFE_INTEGER,
                isCurrent: true,
                allowLocal: true,
            })
        }
    }

    seasons.sort(function(a, b)
    {
        let orderA = a.order !== undefined && !isNaN(a.order) ? a.order : 0
        let orderB = b.order !== undefined && !isNaN(b.order) ? b.order : 0

        if (orderA === orderB)
        {
            let nameA = String(a.displayName || "")
            let nameB = String(b.displayName || "")
            return nameA.localeCompare(nameB)
        }

        return orderB - orderA
    })

    return seasons
}

function NormalizeSeasonEntry(entryKey, entryValue, sourceKey)
{
    if (!entryValue)
    {
        return null
    }

    let playersSource = entryValue.players || entryValue.leaderboard || entryValue.list || entryValue.data || entryValue.table || entryValue.rating || entryValue.top
    let players = ExtractPlayersFromTable(playersSource)

    if (players.length === 0 && typeof entryValue === "object" && !Array.isArray(entryValue))
    {
        players = ExtractPlayersFromTable(entryValue)
    }

    if (players.length === 0)
    {
        return null
    }

    let seasonName = entryValue.season || entryValue.season_name || entryValue.name || entryValue.title || entryValue.label
    let yearValue = entryValue.year || entryValue.season_year || entryValue.year_number

    let order = entryValue.order || entryValue.index || entryValue.season_id || entryValue.id || entryValue.position
    if (order !== undefined)
    {
        order = Number(order)
    }

    if (order === undefined || isNaN(order))
    {
        order = CalculateSeasonOrder(seasonName, yearValue, entryKey)
    }

    if (isNaN(order))
    {
        order = 0
    }

    return {
        key: sourceKey + "_" + entryKey,
        displayName: BuildSeasonDisplayName(seasonName, yearValue, entryKey),
        players: players,
        order: order,
        isCurrent: Boolean(entryValue.is_current || entryValue.current || entryValue.isCurrent),
        allowLocal: Boolean(entryValue.allowLocal || entryValue.allow_local || entryValue.is_current || entryValue.current || entryValue.isCurrent),
    }
}

function CalculateSeasonOrder(seasonName, yearValue, fallbackKey)
{
    let yearNumber = ParseSeasonYear(yearValue)
    if (isNaN(yearNumber))
    {
        yearNumber = ParseSeasonYear(fallbackKey)
    }

    let seasonPriority = GetSeasonPriority(seasonName || fallbackKey)

    if (isNaN(yearNumber))
    {
        return seasonPriority
    }

    return yearNumber * 10 + seasonPriority
}

function ParseSeasonYear(value)
{
    if (value === undefined || value === null)
    {
        return NaN
    }

    let matches = String(value).match(/(20\d{2}|19\d{2}|\d{2})/)
    if (!matches || matches.length === 0)
    {
        return NaN
    }

    let number = parseInt(matches[matches.length - 1], 10)
    if (isNaN(number))
    {
        return NaN
    }

    if (number < 100)
    {
        number += 2000
    }

    return number
}

function GetSeasonPriority(seasonName)
{
    if (!seasonName)
    {
        return 0
    }

    let lower = String(seasonName).toLowerCase()

    if (lower.indexOf("winter") !== -1)
    {
        return 4
    }
    if (lower.indexOf("autumn") !== -1 || lower.indexOf("fall") !== -1)
    {
        return 3
    }
    if (lower.indexOf("summer") !== -1)
    {
        return 2
    }
    if (lower.indexOf("spring") !== -1)
    {
        return 1
    }

    let match = lower.match(/(\d+)/)
    if (match)
    {
        return parseInt(match[1], 10) % 10
    }

    return 0
}

function BuildSeasonDisplayName(seasonName, yearValue, fallbackKey)
{
    let baseName = FormatSeasonName(seasonName || fallbackKey)
    let yearText = FormatSeasonYear(yearValue)

    if (yearText)
    {
        return baseName + " " + yearText
    }

    return baseName
}

function FormatSeasonName(value)
{
    if (!value)
    {
        return $.Localize("#top10") || "Season"
    }

    let text = String(value).replace(/[_-]+/g, " ").trim()
    if (text.length === 0)
    {
        return $.Localize("#top10") || "Season"
    }

    let parts = text.split(/\s+/)
    for (let i in parts)
    {
        let part = parts[i]
        if (part.length > 0)
        {
            parts[i] = part.charAt(0).toUpperCase() + part.slice(1).toLowerCase()
        }
    }

    return parts.join(" ")
}

function FormatSeasonYear(value)
{
    let yearNumber = ParseSeasonYear(value)
    if (isNaN(yearNumber))
    {
        return ""
    }

    let shortYear = yearNumber % 100
    if (shortYear < 10)
    {
        return "0" + shortYear
    }

    return String(shortYear)
}

function RenderSeasonTabs(preferredSelection)
{
    let container = $("#SeasonTabs")
    let wrapper = $("#SeasonTabsContainer")

    if (!container || !wrapper)
    {
        return
    }

    container.RemoveAndDeleteChildren()
    SEASON_BUTTONS = {}

    if (SEASON_DATA.length === 0)
    {
        wrapper.SetHasClass("Hidden", true)
        CURRENT_SEASON_ID = "current"
        CURRENT_SEASON_ALLOW_LOCAL = true
        CURRENT_LEADERBOARD = ExtractPlayersFromTable(CustomNetTables.GetTableValue("Shop", "top10"))
        RefreshLeaderboard(1)
        return
    }

    wrapper.SetHasClass("Hidden", false)

    for (let i in SEASON_DATA)
    {
        let season = SEASON_DATA[i]
        let button = $.CreatePanel("Button", container, "")
        button.AddClass("SeasonTab")

        let label = $.CreatePanel("Label", button, "")
        label.AddClass("SeasonTabLabel")
        label.text = season.displayName

        (function(key)
        {
            button.SetPanelEvent("onactivate", function()
            {
                SelectSeason(key)
            })
        })(season.key)

        SEASON_BUTTONS[season.key] = button
    }

    let selectionKey = preferredSelection && SEASON_BUTTONS[preferredSelection] ? preferredSelection : SEASON_DATA[0].key
    SelectSeason(selectionKey)
}

function SelectSeason(seasonKey)
{
    let season = null
    for (let i in SEASON_DATA)
    {
        if (SEASON_DATA[i].key === seasonKey)
        {
            season = SEASON_DATA[i]
            break
        }
    }

    if (!season)
    {
        return
    }

    CURRENT_SEASON_ID = seasonKey
    CURRENT_SEASON_ALLOW_LOCAL = season.allowLocal !== undefined ? season.allowLocal : Boolean(season.isCurrent)

    for (let key in SEASON_BUTTONS)
    {
        if (!SEASON_BUTTONS.hasOwnProperty(key))
        {
            continue
        }
        SEASON_BUTTONS[key].SetHasClass("Selected", key === seasonKey)
    }

    CURRENT_LEADERBOARD = []
    for (let index in season.players)
    {
        let player = season.players[index]
        if (!player)
        {
            continue
        }

        if (player.slice)
        {
            CURRENT_LEADERBOARD.push(player.slice(0))
        }
        else
        {
            CURRENT_LEADERBOARD.push([player[0], player[1], player[2], player[3], player[4]])
        }
    }

    RefreshLeaderboard(1)
}

function ExtractPlayersFromTable(table)
{
    if (!table)
    {
        return []
    }

    let players = []

    if (Array.isArray(table))
    {
        for (let i = 0; i < table.length; i++)
        {
            let normalized = NormalizePlayerEntry(table[i])
            if (normalized)
            {
                players.push(normalized)
            }
        }
        return players
    }

    for (let key in table)
    {
        if (!table.hasOwnProperty(key))
        {
            continue
        }

        let normalized = NormalizePlayerEntry(table[key])
        if (normalized)
        {
            players.push(normalized)
        }
    }

    return players
}

function NormalizePlayerEntry(entry)
{
    if (!entry)
    {
        return null
    }

    if (Array.isArray(entry))
    {
        let hasZeroIndex = entry[0] !== undefined || entry["0"] !== undefined
        if (hasZeroIndex)
        {
            return [
                entry[0] !== undefined ? entry[0] : entry["0"] !== undefined ? entry["0"] : entry[1] !== undefined ? entry[1] : entry["1"],
                entry[1] !== undefined ? entry[1] : entry["1"] !== undefined ? entry["1"] : entry[2] !== undefined ? entry[2] : entry["2"] || 0,
                entry[2] !== undefined ? entry[2] : entry["2"] !== undefined ? entry["2"] : entry[3] !== undefined ? entry[3] : entry["3"] || 0,
                entry[3] !== undefined ? entry[3] : entry["3"] !== undefined ? entry["3"] : entry[4] !== undefined ? entry[4] : entry["4"] || 0,
                entry[4] !== undefined ? entry[4] : entry["4"] !== undefined ? entry["4"] : entry[5] !== undefined ? entry[5] : entry["5"] || 0,
            ]
        }

        return [
            entry[1] !== undefined ? entry[1] : entry["1"] !== undefined ? entry["1"] : entry[0],
            entry[2] !== undefined ? entry[2] : entry["2"] !== undefined ? entry["2"] : entry[1] || 0,
            entry[3] !== undefined ? entry[3] : entry["3"] !== undefined ? entry["3"] : entry[2] || 0,
            entry[4] !== undefined ? entry[4] : entry["4"] !== undefined ? entry["4"] : entry[3] || 0,
            entry[5] !== undefined ? entry[5] : entry["5"] !== undefined ? entry["5"] : entry[4] || 0,
        ]
    }

    if (typeof entry === "object")
    {
        let accountId = GetValueFromEntry(entry, [0, "0", 1, "1", "steamid", "steamID", "accountid", "accountID", "player_id", "playerID", "id"])
        if (accountId === undefined)
        {
            return null
        }

        return [
            accountId,
            GetValueFromEntry(entry, [2, "2", 1, "1", "summary", "summary_rating", "score", "rating", "points"]) || 0,
            GetValueFromEntry(entry, [3, "3", 2, "2", "troll", "troll_rating"]) || 0,
            GetValueFromEntry(entry, [4, "4", 3, "3", "elves", "elf", "elves_rating"]) || 0,
            GetValueFromEntry(entry, [5, "5", 4, "4", "games", "matches", "matchID"]) || 0,
        ]
    }

    return null
}

function GetValueFromEntry(entry, keys)
{
    for (let i = 0; i < keys.length; i++)
    {
        let key = keys[i]
        if (key === undefined)
        {
            continue
        }

        if (entry[key] !== undefined)
        {
            return entry[key]
        }
    }

    return undefined
}

function RefreshLeaderboard(sort_id)
{
    let PlayersList = $("#PlayersList")
    if (!PlayersList)
    {
        return
    }

    PlayersList.RemoveAndDeleteChildren()

    let LocalPlayer = $("#LocalPlayer")
    if (LocalPlayer)
    {
        LocalPlayer.RemoveAndDeleteChildren()
    }

    LOCAL_PLAYER_ENTRY = GetLocalPlayerEntry()
    HAS_PLAYER_IN_ALL_TABLE = false

    let players = []
    for (let index in CURRENT_LEADERBOARD)
    {
        let entry = CURRENT_LEADERBOARD[index]
        if (!entry)
        {
            continue
        }

        players.push(entry.slice ? entry.slice(0) : [entry[0], entry[1], entry[2], entry[3], entry[4]])
    }

    let sortIndex = Number(sort_id)
    if (isNaN(sortIndex))
    {
        sortIndex = 1
    }

    players.sort(function(a, b)
    {
        let valueA = Number(a[sortIndex]) || 0
        let valueB = Number(b[sortIndex]) || 0
        return valueB - valueA
    })

    for (let i = 0; i < players.length; i++)
    {
        let info = players[i]
        EvaluateLocalPlayerPresence(info)
        CreatePlayer(i, info)
    }

    RenderLocalPlayer()
}

function EvaluateLocalPlayerPresence(playerInfo)
{
    if (!LOCAL_PLAYER_ENTRY || !playerInfo)
    {
        return
    }

    if (String(playerInfo[0]) === String(LOCAL_PLAYER_ENTRY.info[0]))
    {
        HAS_PLAYER_IN_ALL_TABLE = true
    }
}

function RenderLocalPlayer()
{
    if (!CURRENT_SEASON_ALLOW_LOCAL)
    {
        return
    }

    if (!LOCAL_PLAYER_ENTRY)
    {
        return
    }

    if (HAS_PLAYER_IN_ALL_TABLE)
    {
        return
    }

    CreatePlayer(LOCAL_PLAYER_ENTRY.rank !== undefined ? LOCAL_PLAYER_ENTRY.rank : 0, LOCAL_PLAYER_ENTRY.info, true)
}

function GetLocalPlayerEntry()
{
    let portraitUnit = Players.GetLocalPlayerPortraitUnit()
    if (portraitUnit === undefined)
    {
        return null
    }

    let playerID = Entities.GetPlayerOwnerID(portraitUnit)
    if (playerID === undefined || playerID < 0)
    {
        return null
    }

    let shopTable = CustomNetTables.GetTableValue("Shop", String(playerID))
    if (!shopTable)
    {
        shopTable = CustomNetTables.GetTableValue("Shop", playerID)
    }
    if (!shopTable)
    {
        return null
    }

    let ratingTable = shopTable["13"] || shopTable[13]
    if (!ratingTable)
    {
        return null
    }

    let accountId = GetValueFromEntry(ratingTable, [2, "2", 1, "1", "accountid", "accountID", "steamid", "steamID"])
    if (accountId === undefined)
    {
        return null
    }

    let info = [
        accountId,
        GetValueFromEntry(ratingTable, [3, "3", 2, "2", "summary", "summary_rating", "score"]) || 0,
        GetValueFromEntry(ratingTable, [4, "4", 3, "3", "troll", "troll_rating"]) || 0,
        GetValueFromEntry(ratingTable, [5, "5", 4, "4", "elves", "elf", "elves_rating"]) || 0,
        GetValueFromEntry(ratingTable, [6, "6", 5, "5", "games", "matches"]) || 0,
    ]

    return {
        rank: GetValueFromEntry(ratingTable, [1, "1", "rank", "position"]),
        info: info,
    }
}

function CreatePlayer(num, player_info, is_local)
{
    let PlayersList = $("#PlayersList")
    if (is_local)
    {
        PlayersList = $("#LocalPlayer")
    }

    if (!PlayersList)
    {
        return
    }

    let Line = $.CreatePanel("Panel", PlayersList, "")
    Line.AddClass("LinePlayer")

    let numericPosition = Number(num)
    if (!isNaN(numericPosition))
    {
        Line.AddClass("LinePlayer_" + (numericPosition + 1))
    }

    let Leaderboard_column_id = $.CreatePanel("Label", Line, "")
    Leaderboard_column_id.AddClass("Leaderboard_column_id")

    if (!isNaN(numericPosition))
    {
        Leaderboard_column_id.text = numericPosition + 1
    }
    else if (typeof num === "string")
    {
        Leaderboard_column_id.text = num
    }
    else
    {
        Leaderboard_column_id.text = ""
    }

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

function OnShopNetTableChanged(tableName, key, data)
{
    if (tableName !== "Shop")
    {
        return
    }

    if (key === "top10")
    {
        if (!INIT_PANEL)
        {
            return
        }

        BuildSeasonsAndLeaderboard()
        return
    }

    for (let index in SEASON_TABLE_KEYS)
    {
        if (key === SEASON_TABLE_KEYS[index])
        {
            if (!INIT_PANEL)
            {
                return
            }

            BuildSeasonsAndLeaderboard()
            return
        }
    }
}

(function()
{
    CustomNetTables.SubscribeNetTableListener("Shop", OnShopNetTableChanged)
})()

GameUI.CustomUIConfig().OpenLeaderboardGlobal = OpenPanel
GameUI.CustomUIConfig().CloseLeaderboardGlobal = ClosePanel
