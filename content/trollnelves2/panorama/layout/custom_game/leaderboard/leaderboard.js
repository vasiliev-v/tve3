// ===================== LEADERBOARD (CURRENT + HISTORY) =====================
// Текущий top10 НЕ ТРОГАЕМ. История top10_H — только из CustomNetTables, без фейков.

var INIT_PANEL = false
var HAS_PLAYER_IN_ALL_TABLE = false

// Активный вид: current (top10) или history (top10_H + ключ сезона)
var ACTIVE_VIEW = { type: "current", seasonKey: null }

/* ===================== ОТКРЫТИЕ/ЗАКРЫТИЕ ===================== */
function OpenPanel() {
    let Leaderboard = $("#Leaderboard")
    Leaderboard.SetHasClass("Open", !Leaderboard.BHasClass("Open"))

    if (!INIT_PANEL) {
        INIT_PANEL = true

        // Подписка на обновления истории (Shop / top10_H)
        SubscribeTopHistory()

        BuildSeasonTabs()
        ShowCurrentSeason()
        //InitLocalPlayer()
    }
}

function ClosePanel() {
    let Leaderboard = $("#Leaderboard")
    if (Leaderboard.BHasClass("Open")) {
        Leaderboard.SetHasClass("Open", false)
    }
}

/* ===================== NORMALIZE ===================== */

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
// поддерживаем 2 раскладки:
//  - 1-based (как из Lua NetTable): [1]=name,[2]=sum,[3]=troll,[4]=elves,[5]=games
//  - 0-based: [0]=name,[1]=sum,[2]=troll,[3]=elves,[4]=games
function NormalizeHistoryEntry(entry) {
    let name, sum, troll, elves, games
    if (entry[1] !== undefined) {
        // 1-based
        name  = String(entry[1] ?? "")
        sum   = Number(entry[2] ?? 0)
        troll = Number(entry[3] ?? 0)
        elves = Number(entry[4] ?? 0)
        games = Number(entry[5] ?? 0)
    } else {
        // 0-based
        name  = String(entry[0] ?? "")
        sum   = Number(entry[1] ?? 0)
        troll = Number(entry[2] ?? 0)
        elves = Number(entry[3] ?? 0)
        games = Number(entry[4] ?? 0)
    }

    // защита от NaN
    if (!Number.isFinite(sum)) sum = 0
    if (!Number.isFinite(troll)) troll = 0
    if (!Number.isFinite(elves)) elves = 0
    if (!Number.isFinite(games)) games = 0

    return { isHistory: true, steamid: null, name, sum, troll, elves, games }
}

/* ===================== SUBSCRIBE HISTORY ===================== */

function SubscribeTopHistory() {
    CustomNetTables.SubscribeNetTableListener("Shop", function(tableName, key, data) {
        if (key !== "top10_H") return

        // перестроим табы, когда прилетит история
        BuildSeasonTabs()

        // если сейчас открыт history — перерисуем
        if (ACTIVE_VIEW.type === "history") {
            const topH = CustomNetTables.GetTableValue("Shop", "top10_H")
            if (!topH || !topH[ACTIVE_VIEW.seasonKey]) {
                ShowCurrentSeason()
            } else {
                InitPlayersRating(1)
            }
        }
    })
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
    lblCurrent.text = $.Localize ? ($.Localize("#leaderboard_current_season") || "Current season") : "Current season"

    // История только из NetTable
    let topH = CustomNetTables.GetTableValue("Shop", "top10_H")

    if (topH) {
        let seasonKeys = []
        for (let k in topH) seasonKeys.push(k)

        // сортировка: по году DESC, затем Winter>Autumn>Summer>Spring
        const order = { "Winter": 1, "Autumn": 4, "Summer": 3, "Spring": 2 }
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
        $("#SeasonTitle").text = $.Localize ? ($.Localize("#leaderboard_current_season") || "Current season") : "Current season"
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
    const topH = CustomNetTables.GetTableValue("Shop", "top10_H")
    if (!topH || !topH[seasonKey]) {
        ShowCurrentSeason()
        return
    }
    ACTIVE_VIEW = { type: "history", seasonKey: seasonKey }
    UpdateActiveTabVisual()
    InitPlayersRating(1)
}

// sort_id: 1 - sum, 2 - troll, 3 - elves, 4 - games
function InitPlayersRating(sort_id) {
    let PlayersList = $("#PlayersList")
    PlayersList.RemoveAndDeleteChildren()

    // --- FIX: локальная строка должна исчезать в history ---
    let Local = $("#LocalPlayer")
    if (Local) {
        Local.RemoveAndDeleteChildren()
        Local.visible = (ACTIVE_VIEW.type === "current") // скрываем в history
    }
    // -------------------------------------------------------


    let sourceTable = null
    let rows = []

    if (ACTIVE_VIEW.type === "current") {
        // ================== ТЕКУЩИЙ ТОП10 (НЕ ТРОГАЕМ ЛОГИКУ) ==================
        sourceTable = CustomNetTables.GetTableValue("Shop", "top10")

        for (let idx in sourceTable) {
            rows.push(NormalizeCurrentEntry(sourceTable[idx]))
        }

    } else {
        // ================== ИСТОРИЯ (ТОЛЬКО NetTable top10_H) ==================
        const topH = CustomNetTables.GetTableValue("Shop", "top10_H")
        sourceTable = topH ? topH[ACTIVE_VIEW.seasonKey] : null
        if (!sourceTable) return

        for (let idx in sourceTable) {
            let r = NormalizeHistoryEntry(sourceTable[idx])
            r.place = Number(idx) // ключ позиции из Lua (строкой "1".."10")
            rows.push(r)
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

    // --- FIX: локальная строка только для current, и каждый раз заново ---
    if (ACTIVE_VIEW.type === "current") {
        InitLocalPlayer()
    }
}

/* ===================== ЛОКАЛЬНЫЙ ИГРОК (ТОЛЬКО CURRENT) ===================== */

function IsCondLocalPlayer(row) {
    // Только для текущего сезона (там есть steamid)
    if (ACTIVE_VIEW.type !== "current") return

    let shop_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))?.[13]
    if (!shop_table) return

    let local_steamid = String(shop_table[2]) // как и раньше
    if (row.steamid && row.steamid == local_steamid) {
        HAS_PLAYER_IN_ALL_TABLE = true
    }
}

function InitLocalPlayer() {
    if (ACTIVE_VIEW.type !== "current") return

    let Local = $("#LocalPlayer")
    if (Local) Local.RemoveAndDeleteChildren() // защита от дубля

    if (HAS_PLAYER_IN_ALL_TABLE) return

    let shop_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))?.[13]
    if (!shop_table) return

    const place  = shop_table[1]
    const steamid = String(shop_table[2])
    const sum    = Number(shop_table[3])
    const troll  = Number(shop_table[4])
    const elves  = Number(shop_table[5])
    const games  = Number(shop_table[6])

    const row = { isHistory:false, steamid, name:null, sum, troll, elves, games }
    CreatePlayer(place, row, true)
}

/* ===================== СОЗДАНИЕ СТРОКИ ===================== */
// num — индекс (0..), row — нормализованный объект
function CreatePlayer(num, row, is_local) {
    let container = is_local ? $("#LocalPlayer") : $("#PlayersList")

    let Line = $.CreatePanel("Panel", container, "")
    Line.AddClass("LinePlayer")
    Line.AddClass("LinePlayer_" + (Number(num) + 1))

    let Leaderboard_column_id = $.CreatePanel("Label", Line, "")
    Leaderboard_column_id.AddClass("Leaderboard_column_id")
    Leaderboard_column_id.text = row.place ? String(row.place) : String(Number(num) + 1)

    let Leaderboard_column_name = $.CreatePanel("Panel", Line, "")
    Leaderboard_column_name.AddClass("Leaderboard_column_name")
    Leaderboard_column_name.style.flowChildren = "right"

    if (!row.isHistory && row.steamid) {
        // Текущий сезон — аватар + имя по steamid
        let avatar = $.CreatePanel("DOTAAvatarImage", Leaderboard_column_name, "", {
            style:"width:22px;height:22px;margin-right:10px;vertical-align:center;"
        })
        avatar.accountid = row.steamid

        let uname = $.CreatePanel("DOTAUserName", Leaderboard_column_name, "", { style:"vertical-align:center;" })
        uname.AddClass("Leaderboard_column_name_label")
        uname.steamid = row.steamid
    } else {
        // История — ник строкой
        let nameLbl = $.CreatePanel("Label", Leaderboard_column_name, "", { style:"vertical-align:center;" })
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
var SEASON_SCROLL_PX = 0

function GetMaxScroll() {
    const viewport = $("#SeasonTabs")
    const ribbon = $("#SeasonTabsInner")
    if (!viewport || !ribbon) return 0
    const extra = ribbon.actuallayoutwidth - viewport.actuallayoutwidth
    return Math.max(0, extra)
}

function ApplyScroll() {
    const ribbon = $("#SeasonTabsInner")
    if (!ribbon) return
    ribbon.style.marginLeft = (-SEASON_SCROLL_PX) + "px"
}

function SeasonScroll(dir /* -1 или 1 */) {
    const viewport = $("#SeasonTabs")
    if (!viewport) return

    const step = Math.max(120, Math.floor(viewport.actuallayoutwidth * 0.6))
    const maxScroll = GetMaxScroll()

    SEASON_SCROLL_PX = Math.min(maxScroll, Math.max(0, SEASON_SCROLL_PX + dir * step))
    ApplyScroll()
}

function ScrollToActiveTab() {
    const viewport = $("#SeasonTabs")
    const ribbon = $("#SeasonTabsInner")
    if (!viewport || !ribbon) return

    const children = ribbon.Children()
    if (!children || children.length === 0) return

    let activeIndex = 0 // 0 — "Current season"
    if (ACTIVE_VIEW.type !== "current") {
        const targetKey = ACTIVE_VIEW.seasonKey
        for (let i = 1; i < children.length; i++) {
            const lbl = children[i].Children()[0]
            if (lbl && lbl.text === targetKey) {
                activeIndex = i
                break
            }
        }
    }

    // сумма ширин до активной кнопки
    let targetLeft = 0
    for (let i = 0; i < activeIndex; i++) {
        targetLeft += children[i].actuallayoutwidth
    }
    const targetRight = targetLeft + children[activeIndex].actuallayoutwidth

    const viewLeft = SEASON_SCROLL_PX
    const viewRight = SEASON_SCROLL_PX + viewport.actuallayoutwidth

    if (targetLeft < viewLeft) {
        SEASON_SCROLL_PX = Math.max(0, targetLeft)
    } else if (targetRight > viewRight) {
        SEASON_SCROLL_PX = Math.min(GetMaxScroll(), targetRight - viewport.actuallayoutwidth)
    }
    ApplyScroll()
}

/* ===================== EXPORT ===================== */
GameUI.CustomUIConfig().OpenLeaderboardGlobal = OpenPanel
GameUI.CustomUIConfig().CloseLeaderboardGlobal = ClosePanel