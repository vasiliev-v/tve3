var INIT_PANEL = false
var HAS_PLAYER_IN_ALL_TABLE = false

// Активный вид: current (top10) или history (top10_H + ключ сезона)
var ACTIVE_VIEW = { type: "current", seasonKey: null }

var FAKE_LEADERBOARD_LIST = {}      // Текущий сезон (top10)
var FAKE_TOP10_H = null             // История сезонов (top10_H)
var FAKE_PLAYER_LOCAL = {}

/* ===================== ТЕСТОВЫЕ ДАННЫЕ ДЛЯ ИСТОРИИ ===================== */
function GenerateFakeHistory() {
    const seasons = [
        "Winter 25", "Autumn 25", "Summer 25", "Spring 25",
        "Winter 24", "Autumn 24", "Summer 24", "Spring 24",
        "Winter 23", "Autumn 23"
    ]

    let history = {}
    for (let s = 0; s < seasons.length; s++) {
        let seasonKey = seasons[s]
        let seasonTable = {}
        for (let i = 1; i <= 10; i++) {
            const base = (s + 1) * 1000 + i
            // В истории теперь НИК, а не steamid:
            const name = "Player_" + (base)
            const troll = 900 + ((s * 37 + i * 13) % 200)
            const elves = 900 + ((s * 53 + i * 17) % 200)
            const sum = troll + elves + ((i % 3) * 25)
            const games = 40 + ((s * 7 + i * 5) % 60)
            // формат истории: [name, sum, troll, elves, games]
            seasonTable[i] = [name, sum, troll, elves, games]
        }
        history[seasonKey] = seasonTable
    }
    return history
}

/* ===================== ОТКРЫТИЕ/ЗАКРЫТИЕ ===================== */
function OpenPanel() {
    let Leaderboard = $("#Leaderboard")
    Leaderboard.SetHasClass("Open", !Leaderboard.BHasClass("Open"))
    if (!INIT_PANEL) {
        INIT_PANEL = true

        let netTopH = CustomNetTables.GetTableValue("Shop", "top10_H")
        if (!netTopH) {
            FAKE_TOP10_H = GenerateFakeHistory()
        }

        BuildSeasonTabs()
        ShowCurrentSeason()
        InitLocalPlayer()
    }
}

function ClosePanel() {
    let Leaderboard = $("#Leaderboard")
    if (Leaderboard.BHasClass("Open")) {
        Leaderboard.SetHasClass("Open", false)
    }
}

/* ===================== ВСПОМОГАТЕЛЬНОЕ: НОРМАЛИЗАЦИЯ ===================== */

// ТЕКУЩИЙ СЕЗОН (top10):
// поддерживаем 2 раскладки:
//  - 1-based: [1]=steamid,[2]=sum,[3]=troll,[4]=elves,[5]=games
//  - 0-based: [0]=steamid, 1=sum, 2=troll, 3=elves, 4=games
function NormalizeCurrentEntry(entry) {
    let steamid, sum, troll, elves, games
    if (entry[1] !== undefined && entry[2] !== undefined) {
        // 1-based
        steamid = String(entry[1])
        sum     = Number(entry[2])
        troll   = Number(entry[3])
        elves   = Number(entry[4])
        games   = Number(entry[5])
    } else {
        // 0-based
        steamid = String(entry[0])
        sum     = Number(entry[1])
        troll   = Number(entry[2])
        elves   = Number(entry[3])
        games   = Number(entry[4])
    }
    return { isHistory: false, steamid, name: null, sum, troll, elves, games }
}

// ИСТОРИЯ (top10_H):
// новый формат по требованию: [name, sum, troll, elves, games]
function NormalizeHistoryEntry(entry) {
    const name  = String(entry[0] || "")
    const sum   = Number(entry[1] || 0)
    const troll = Number(entry[2] || 0)
    const elves = Number(entry[3] || 0)
    const games = Number(entry[4] || 0)
    return { isHistory: true, steamid: null, name, sum, troll, elves, games }
}

/* ===================== ТАБЫ СЕЗОНОВ ===================== */
function BuildSeasonTabs() {
    const ribbon = $("#SeasonTabsInner")
    ribbon.RemoveAndDeleteChildren()

    // "Текущий сезон"
    const btnCurrent = $.CreatePanel("Panel", ribbon, "")
    btnCurrent.AddClass("SeasonButton")
    btnCurrent.SetPanelEvent("onactivate", function () {
        ShowCurrentSeason()
    })
    let lblCurrent = $.CreatePanel("Label", btnCurrent, "")
    lblCurrent.text = $.Localize ? $.Localize("#leaderboard_current_season") || "Current season" : "Current season"

    // История
    let topH = CustomNetTables.GetTableValue("Shop", "top10_H")
    if (!topH) topH = FAKE_TOP10_H

    if (topH) {
        let seasonKeys = []
        for (let k in topH) seasonKeys.push(k)

        const order = { "Winter": 4, "Autumn": 3, "Summer": 2, "Spring": 1 }
        seasonKeys.sort((a, b) => {
            const [sa, ya] = a.split(" ")
            const [sb, yb] = b.split(" ")
            const ia = parseInt(ya) || 0
            const ib = parseInt(yb) || 0
            if (ia !== ib) return ib - ia
            return (order[sb] || 0) - (order[sa] || 0)
        })

        seasonKeys.forEach((key) => {
            const btn = $.CreatePanel("Panel", ribbon, "")
            btn.AddClass("SeasonButton")
            btn.SetPanelEvent("onactivate", function () {
                ShowSeason(key)
            })
            let lbl = $.CreatePanel("Label", btn, "")
            lbl.text = key
        })
    }

    UpdateActiveTabVisual()
    $.Schedule(0, function() {
        ScrollToActiveTab()
        ApplyScroll()
    })
}

function UpdateActiveTabVisual() {
    const ribbon = $("#SeasonTabsInner")
    const tabs = ribbon.Children()
    for (let i = 0; i < tabs.length; i++) {
        tabs[i].RemoveClass("Active")
    }

    if (ACTIVE_VIEW.type === "current") {
        if (tabs.length > 0) tabs[0].AddClass("Active")
        $("#SeasonTitle").text = $.Localize ? $.Localize("#leaderboard_current_season") || "Current season" : "Current season"
    } else {
        const targetKey = ACTIVE_VIEW.seasonKey
        for (let i = 1; i < tabs.length; i++) {
            const lbl = tabs[i].Children()[0]
            if (lbl && lbl.text === targetKey) {
                tabs[i].AddClass("Active")
                break
            }
        }
        $("#SeasonTitle").text = targetKey
    }

    ScrollToActiveTab()
}

/* ===================== РЕНДЕР ТАБЛИЦЫ ===================== */
function ShowCurrentSeason() {
    ACTIVE_VIEW = { type: "current", seasonKey: null }
    UpdateActiveTabVisual()
    InitPlayersRating(1)
}

function ShowSeason(seasonKey) {
    ACTIVE_VIEW = { type: "history", seasonKey: seasonKey }
    UpdateActiveTabVisual()
    InitPlayersRating(1)
}

// sort_id: 1 - sum, 2 - troll, 3 - elves, 4 - games
function InitPlayersRating(sort_id) {
    let PlayersList = $("#PlayersList")
    PlayersList.RemoveAndDeleteChildren()

    let sourceTable = null
    let rows = []

    if (ACTIVE_VIEW.type === "current") {
        sourceTable = CustomNetTables.GetTableValue("Shop", "top10")
        if (!sourceTable || Object.keys(sourceTable).length === 0) {
            // Фейк в 0-based формате
            sourceTable = {}
            for (let i = 1; i <= 10; i++) {
                const steamid = String(111111111 + i)
                const troll = 1000 + (i * 7) % 90
                const elves = 1000 + (i * 5) % 90
                const sum = troll + elves + ((i % 3) * 10)
                const games = 50 + (i * 3) % 40
                sourceTable[i] = [steamid, sum, troll, elves, games]
            }
        }

        for (let idx in sourceTable) {
            rows.push(NormalizeCurrentEntry(sourceTable[idx]))
        }
    } else {
        // Исторический сезон: формат [name, sum, troll, elves, games]
        let topH = CustomNetTables.GetTableValue("Shop", "top10_H")
        if (!topH) topH = FAKE_TOP10_H
        sourceTable = topH ? topH[ACTIVE_VIEW.seasonKey] : null
        if (!sourceTable) return

        for (let idx in sourceTable) {
            rows.push(NormalizeHistoryEntry(sourceTable[idx]))
        }
    }

    // Сортировка
    const keyMap = { 1: "sum", 2: "troll", 3: "elves", 4: "games" }
    const sortKey = keyMap[sort_id] || "sum"
    rows.sort((a, b) => Number(b[sortKey]) - Number(a[sortKey]))

    HAS_PLAYER_IN_ALL_TABLE = false
    for (let i = 0; i < rows.length; i++) {
        IsCondLocalPlayer(rows[i])
        CreatePlayer(i, rows[i])
    }
}

function IsCondLocalPlayer(row) {
    // Только для текущего сезона (там есть steamid)
    if (ACTIVE_VIEW.type !== "current") return
    let shop_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))?.[13];
    if (!shop_table) return
    let local_steamid = String(shop_table[2]) // как и раньше
    if (row.steamid && row.steamid == local_steamid) {
        HAS_PLAYER_IN_ALL_TABLE = true
    }
}

function InitLocalPlayer() {
    // Только если локального нет в TOP10 текущего сезона — показываем отдельной строкой
    if (ACTIVE_VIEW.type !== "current") return
    if (HAS_PLAYER_IN_ALL_TABLE) return

    let shop_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))?.[13];
    if (!shop_table) return
    // shop_table: [?, place, steamid, sum, troll, elves, games] — как раньше
    const place = shop_table[1]
    const steamid = String(shop_table[2])
    const sum = Number(shop_table[3])
    const troll = Number(shop_table[4])
    const elves = Number(shop_table[5])
    const games = Number(shop_table[6])

    const row = { isHistory:false, steamid, name:null, sum, troll, elves, games }
    CreatePlayer(place, row, true)
} 

// num — индекс (0..), row — нормализованный объект
function CreatePlayer(num, row, is_local) {   
    let container = is_local ? $("#LocalPlayer") : $("#PlayersList")

    let Line = $.CreatePanel("Panel", container, "");
    Line.AddClass("LinePlayer");
    Line.AddClass("LinePlayer_"+(Number(num) + 1))

    let Leaderboard_column_id = $.CreatePanel("Label", Line, "")
    Leaderboard_column_id.AddClass("Leaderboard_column_id")
    Leaderboard_column_id.text = (Number(num) + 1)

    let Leaderboard_column_name = $.CreatePanel("Panel", Line, "")
    Leaderboard_column_name.AddClass("Leaderboard_column_name")
    Leaderboard_column_name.style.flowChildren = "right"

    if (!row.isHistory && row.steamid) {
        // Текущий сезон — показываем аватар и имя по steamid
        let avatar = $.CreatePanel("DOTAAvatarImage", Leaderboard_column_name, "", {style:"width:22px;height:22px;margin-right:10px;vertical-align:center;"})
        avatar.accountid = row.steamid

        let uname = $.CreatePanel("DOTAUserName", Leaderboard_column_name, "", {style:"vertical-align:center;"})
        uname.AddClass("Leaderboard_column_name_label")
        uname.steamid = row.steamid
    } else {
        // История — показываем ник, пришедший из таблицы
        let nameLbl = $.CreatePanel("Label", Leaderboard_column_name, "", {style:"vertical-align:center;"})
        nameLbl.AddClass("Leaderboard_column_name_label")
        nameLbl.text = row.name || "Unknown"
    }

    let Leaderboard_column_sum = $.CreatePanel("Label", Line, "")
    Leaderboard_column_sum.AddClass("Leaderboard_column_sum")
    Leaderboard_column_sum.text = row.sum

    let Leaderboard_column_troll = $.CreatePanel("Label", Line, "")
    Leaderboard_column_troll.AddClass("Leaderboard_column_troll")
    Leaderboard_column_troll.text = row.troll

    let Leaderboard_column_elves = $.CreatePanel("Label", Line, "")
    Leaderboard_column_elves.AddClass("Leaderboard_column_elves")
    Leaderboard_column_elves.text = row.elves

    let Leaderboard_column_games = $.CreatePanel("Label", Line, "")
    Leaderboard_column_games.AddClass("Leaderboard_column_games")
    Leaderboard_column_games.text = row.games
} 

/* ===================== ГОРИЗОНТАЛЬНАЯ ПРОКРУТКА ЛЕНТЫ ===================== */
var SEASON_SCROLL_PX = 0;

function GetMaxScroll() {
    const viewport = $("#SeasonTabs");
    const ribbon = $("#SeasonTabsInner");
    if (!viewport || !ribbon) return 0;
    const extra = ribbon.actuallayoutwidth - viewport.actuallayoutwidth;
    return Math.max(0, extra);
}

function ApplyScroll() {
    const ribbon = $("#SeasonTabsInner");
    if (!ribbon) return;
    ribbon.style.marginLeft = (-SEASON_SCROLL_PX) + "px";
}

function SeasonScroll(dir /* -1 или 1 */) {
    const viewport = $("#SeasonTabs");
    if (!viewport) return;

    const step = Math.max(120, Math.floor(viewport.actuallayoutwidth * 0.6));
    const maxScroll = GetMaxScroll();

    SEASON_SCROLL_PX = Math.min(maxScroll, Math.max(0, SEASON_SCROLL_PX + dir * step));
    ApplyScroll();
}

function ScrollToActiveTab() {
    const viewport = $("#SeasonTabs");
    const ribbon = $("#SeasonTabsInner");
    if (!viewport || !ribbon) return;

    const children = ribbon.Children();
    if (!children || children.length === 0) return;

    let activeIndex = 0; // 0 — "Current season"
    if (ACTIVE_VIEW.type !== "current") {
        const targetKey = ACTIVE_VIEW.seasonKey;
        for (let i = 1; i < children.length; i++) {
            const lbl = children[i].Children()[0];
            if (lbl && lbl.text === targetKey) {
                activeIndex = i;
                break
            }
        }
    }

    // сумма ширин до активной кнопки
    let targetLeft = 0;
    for (let i = 0; i < activeIndex; i++) {
        targetLeft += children[i].actuallayoutwidth;
    }
    const targetRight = targetLeft + children[activeIndex].actuallayoutwidth;

    const viewLeft = SEASON_SCROLL_PX;
    const viewRight = SEASON_SCROLL_PX + viewport.actuallayoutwidth;

    if (targetLeft < viewLeft) {
        SEASON_SCROLL_PX = Math.max(0, targetLeft);
    } else if (targetRight > viewRight) {
        SEASON_SCROLL_PX = Math.min(GetMaxScroll(), targetRight - viewport.actuallayoutwidth);
    }
    ApplyScroll();
}

GameUI.CustomUIConfig().OpenLeaderboardGlobal = OpenPanel
GameUI.CustomUIConfig().CloseLeaderboardGlobal = ClosePanel
