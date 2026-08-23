var TOP_MENU_BUTTONS =
[
    ["ButtonStats", StatsClick, "#TopMenu_Profile"],
    ["ButtonLeaderboards", LeaderboardsClick, "#TopMenu_Leaders"],
    ["ButtonStore", StoreClick, "#TopMenu_Shop"],
    ["ButtonBattlePass", BattlePassClick, "#TopMenu_BP"],
    ["ButtonRewards", RewardsClick, "#TopMenu_Rewards"],
    ["ButtonInfo", InfoClick, "#TopMenu_Info"],
    ["Discord", DiscordOpen, "#TopMenu_Discord"],
]

var RewardsButton = null
var updateRewardsLoop = true

function GetPlayerRating() {
    let pId = Players.GetLocalPlayer()
    let shop_table = CustomNetTables.GetTableValue("Shop", pId)
    if (!shop_table) return NaN

    let rating_data = shop_table[13]
    if (rating_data) {
        if (rating_data[3] != null || rating_data[4] != null) {
            let sum = Number(rating_data[3] || 0) + Number(rating_data[4] || 0)
            if (!isNaN(sum) && (rating_data[3] != null || rating_data[4] != null)) {
                return sum
            }
        }
        if (rating_data[5] != null) {
            let score = Number(rating_data[5])
            if (!isNaN(score)) return score
        }
    }

    let elf_data = shop_table[8] && shop_table[8][0]
    let troll_data = shop_table[9] && shop_table[9][0]

    let hasElf = elf_data && typeof elf_data === "object" && elf_data.score != null
    let hasTroll = troll_data && typeof troll_data === "object" && troll_data.score != null

    if (hasElf || hasTroll) {
        let elf = hasElf ? Number(elf_data.score) : 0
        let troll = hasTroll ? Number(troll_data.score) : 0
        let sum = elf + troll
        return sum
    }

    return NaN
}

function GetPlayerGames() {
    let pId = Players.GetLocalPlayer()
    let shop_table = CustomNetTables.GetTableValue("Shop", pId)
    if (!shop_table) return null

    let elf_data = shop_table[8] && shop_table[8][0]
    let troll_data = shop_table[9] && shop_table[9][0]

    let hasStats = (elf_data && typeof elf_data === "object") || (troll_data && typeof troll_data === "object")
    let rating_data = shop_table[13]

    if (!hasStats && !rating_data) {
        return null
    }

    let elfGames = (elf_data && typeof elf_data === "object" && elf_data.matchID != null) ? Number(elf_data.matchID) : 0
    let trollGames = (troll_data && typeof troll_data === "object" && troll_data.matchID != null) ? Number(troll_data.matchID) : 0
    let totalStatsGames = (!isNaN(elfGames) ? elfGames : 0) + (!isNaN(trollGames) ? trollGames : 0)

    let ratingGames = 0
    if (rating_data) {
        if (rating_data[6] !== undefined && !isNaN(Number(rating_data[6]))) {
            ratingGames = Number(rating_data[6])
        } else if (rating_data[5] !== undefined && !isNaN(Number(rating_data[5]))) {
            ratingGames = Number(rating_data[5])
        }
    }

    return Math.max(totalStatsGames, ratingGames)
}

function Init() {
    let TopMenuCustom = $("#TopMenuCustom")

    for (let button_info of TOP_MENU_BUTTONS)
    {
        let button = $.CreatePanel("Panel", TopMenuCustom, "")
        button.AddClass("ButtonTopMenu")
        button.AddClass(button_info[0])

        if (button_info[0] == "ButtonRewards") {
            RewardsButton = button
        }

        let function_button = button_info[1]
        button.SetPanelEvent("onactivate", function_button)

        // Текст снизу
        let label = $.CreatePanel("Label", button, "")
        label.AddClass("ButtonTopMenuText")
        label.text = $.Localize(button_info[2]) || ""
    }

    UpdateRewardsButtonLoop()
    CheckGamesVisibility()
}

function CheckGamesVisibility() {
    let TopMenuCustom = $("#TopMenuCustom")
    if (!TopMenuCustom) return

    let pId = Players.GetLocalPlayer()
    let shop_table = CustomNetTables.GetTableValue("Shop", pId)

    if (!shop_table) {
        TopMenuCustom.style.visibility = "collapse"
        $.Schedule(2, CheckGamesVisibility)
        return
    }

    let rating = GetPlayerRating()
    let games = GetPlayerGames()

    if (isNaN(rating)) {
        TopMenuCustom.style.visibility = "visible"
    } else if (games !== null && games > 5) {
        TopMenuCustom.style.visibility = "visible"
    } else {
        TopMenuCustom.style.visibility = "collapse"
    }
}

CustomNetTables.SubscribeNetTableListener("Shop", function(table, key, data) {
    if (key == Players.GetLocalPlayer()) {
        CheckGamesVisibility()
    }
})

function UpdateRewardsButtonLoop() {
    if (!updateRewardsLoop) {
        return
    }

    UpdateRewardsButton()

    // Следующий вызов через 1 секунду
    $.Schedule(5, UpdateRewardsButtonLoop)
}

function UpdateRewardsButton() {
    if (!RewardsButton) {
        return
    }

    let shop_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())
    if (!shop_table || !shop_table[6]) {
        return
    }

    let daily_info = shop_table[6]

    if (Number(daily_info[0]) < Number(daily_info[1])) {
        RewardsButton.AddClass("Unclaimed")
    } else {
        RewardsButton.RemoveClass("Unclaimed")
        updateRewardsLoop = false // Отключаем цикл при получении награды
    }
}

function DiscordOpen()
{
    $.DispatchEvent("ExternalBrowserGoToURL", 'https://discord.gg/tve4')
}

function StatsClick()
{
    GameUI.CustomUIConfig().CloseLeaderboardGlobal()
    GameUI.CustomUIConfig().CloseInfoGlobal()
    GameUI.CustomUIConfig().OpenStatsGlobal()
}

function LeaderboardsClick()
{
    GameUI.CustomUIConfig().CloseStatsGlobal()
    GameUI.CustomUIConfig().CloseInfoGlobal()
    GameUI.CustomUIConfig().OpenLeaderboardGlobal()
}

function InfoClick()
{
    GameUI.CustomUIConfig().CloseLeaderboardGlobal()
    GameUI.CustomUIConfig().CloseStatsGlobal()
    GameUI.CustomUIConfig().OpenInfoGlobal()
}

function BattlePassClick()
{
    GameUI.CustomUIConfig().OpenBPGlobal()
}

function RewardsClick()
{
    GameUI.CustomUIConfig().OpenRewardsGlobal()
}

function StoreClick()
{
    GameUI.CustomUIConfig().OpenStoreGlobal()
}

Init()